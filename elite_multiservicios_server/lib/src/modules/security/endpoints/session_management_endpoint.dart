import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as auth_idp;
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';
import '../../../exceptions/app_exception.dart';

/// Endpoint RPC para el monitoreo y control de sesiones activas.
class SessionManagementEndpoint extends Endpoint {
  final AuditService _auditService;

  SessionManagementEndpoint({
    AuditService auditService = const ServerpodAuditService(),
  }) : _auditService = auditService;

  /// Registra la sesión actual del usuario autenticado en la tabla `user_session`.
  /// Se invoca después de un login exitoso.
  /// Retorna el `id` de la sesión creada.
  Future<int> registerSession(
    Session session, {
    required String sessionTokenHash,
    required DateTime expiresAt,
    bool? mfaVerified,
  }) async {
    // 1. Obtener identificador del usuario autenticado
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw Exception('Usuario no autenticado');
    }

    // 2. Resolver el AppUser correspondiente
    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    // 3. Extraer IP y User-Agent del request
    final ipAddress = session.request?.remoteInfo;
    final deviceInfo = session.request?.headers['user-agent']?.firstOrNull;

    // 4. Insertar fila en user_session
    final now = DateTime.now().toUtc();
    final userSession = await UserSession.db.insertRow(
      session,
      UserSession(
        userId: appUser.id!,
        sessionTokenHash: sessionTokenHash,
        ipAddress: ipAddress,
        deviceInfo: deviceInfo,
        isRevoked: false,
        mfaVerified: mfaVerified ?? false,
        createdAt: now,
        lastActivityAt: now,
        expiresAt: expiresAt.toUtc(),
      ),
    );

    // 5. Registrar evento LOGIN_SUCCESS en audit_log
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.loginSuccess,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource: 'session:#${userSession.id}/user:#${appUser.id}',
        ipAddress: ipAddress,
        result: AuditResult.success,
        metadata: {
          'ipAddress': ipAddress,
          'deviceInfo': deviceInfo,
          'sessionId': userSession.id,
        },
      ),
    );

    return userSession.id!;
  }

  /// Lista las sesiones activas asociadas a un usuario. Requiere sessions.view.
  Future<List<UserSession>> listUserSessions(
    Session session,
    int userId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.sessionsView);

    return await UserSession.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isRevoked.equals(false),
      orderBy: (t) => t.lastActivityAt,
      orderDescending: true,
    );
  }

  /// Revoca de forma inmediata una sesión activa por su ID. Requiere sessions.revoke.
  Future<bool> revokeSession(Session session, int sessionId) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.sessionsRevoke,
    );

    final userSession = await UserSession.db.findById(session, sessionId);
    if (userSession == null) return false;

    await UserSession.db.updateRow(
      session,
      userSession.copyWith(
        isRevoked: true,
        revokedAt: DateTime.now().toUtc(),
      ),
    );

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.sessionRevoked,
        userIdentifier: caller,
        resource: 'session:#$sessionId/user:#${userSession.userId}',
        result: AuditResult.success,
      ),
    );

    return true;
  }

  /// Cierra la sesión actual del usuario autenticado.
  /// Marca la fila en `user_session` como revocada y registra el evento en `audit_log`.
  /// Retorna `true` si se revocó correctamente, `false` si no se encontró la sesión.
  Future<bool> logout(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw Exception('Usuario no autenticado');
    }

    // 1. Resolver el AppUser por authUserId
    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    // 2. Buscar la sesión activa más reciente de este usuario
    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (activeSession == null) {
      session.log(
        'No hay sesión activa para revocar para el usuario ${appUser.id}',
      );
      return false;
    }

    // 3. Marcar como revocada con fecha actual UTC
    final now = DateTime.now().toUtc();
    await UserSession.db.updateRow(
      session,
      activeSession.copyWith(
        isRevoked: true,
        revokedAt: now,
        lastActivityAt: now,
      ),
    );

    // 4. Registrar LOGOUT en audit_log
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.logout,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource: 'session:#${activeSession.id}/user:#${appUser.id}',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {
          'sessionId': activeSession.id,
          'revokedAt': now.toIso8601String(),
        },
      ),
    );

    return true;
  }

  /// Marca la sesión activa actual del usuario autenticado como verificada con MFA.
  Future<void> markMfaVerified(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado.');
    }

    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (activeSession == null) return;

    await UserSession.db.updateRow(
      session,
      activeSession.copyWith(
        mfaVerified: true,
        lastActivityAt: DateTime.now().toUtc(),
      ),
      columns: (t) => [t.mfaVerified, t.lastActivityAt],
    );
  }

  /// Resuelve la entidad AppUser vinculada a las credenciales autenticadas en la sesión.
  Future<AppUser> _resolveAuthenticatedAppUser(
    Session session,
    String authUserIdStr,
  ) async {
    AppUser? appUser;
    UuidValue? authUuid;
    try {
      authUuid = UuidValue.fromString(authUserIdStr);
    } catch (_) {
      // No es un UUID
    }

    if (authUuid != null) {
      final emailAccount = await auth_idp.EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUuid),
      );
      if (emailAccount != null) {
        appUser = await AppUser.db.findFirstRow(
          session,
          where: (t) => t.email.equals(emailAccount.email),
        );
      }
    } else {
      final id = int.tryParse(authUserIdStr);
      if (id != null) {
        appUser = await AppUser.db.findFirstRow(
          session,
          where: (t) => t.id.equals(id) | t.userInfoId.equals(id),
        );
      }
    }

    if (appUser == null || appUser.id == null) {
      throw Exception('AppUser no encontrado para el usuario autenticado');
    }

    return appUser;
  }
}
