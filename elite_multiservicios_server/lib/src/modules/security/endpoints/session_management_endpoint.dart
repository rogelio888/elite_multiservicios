import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
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

  /// Obtiene la duración configurada para los refresh tokens desde JwtTokenManager.
  /// Si ocurre un fallo inesperado, recurre a 14 días con log de advertencia.
  Duration _getRefreshTokenLifetime(Session session) {
    try {
      return AuthServices.getTokenManager<JwtTokenManager>()
          .jwt
          .config
          .refreshTokenLifetime;
    } catch (e, stackTrace) {
      session.log(
        'No se pudo obtener refreshTokenLifetime de JwtTokenManager, usando 14 días por defecto: $e',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return const Duration(days: 14);
    }
  }

  /// Registra la sesión actual del usuario autenticado en la tabla `user_session`.
  /// Se invoca después de un login exitoso.
  /// Retorna el `id` de la sesión creada.
  Future<int> registerSession(
    Session session, {
    bool? mfaVerified,
  }) async {
    // 1. Obtener identificadores del usuario autenticado y su sesión
    final authUserIdStr = session.authenticated?.userIdentifier;
    final authSessionId = session.authenticated?.authId;
    if (authUserIdStr == null || authSessionId == null) {
      throw const UnauthorizedException('Usuario o sesión no autenticada.');
    }

    // 2. Resolver el AppUser correspondiente
    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    // 3. Extraer IP y User-Agent del request
    final ipAddress = session.request?.remoteInfo;
    final deviceInfo = session.request?.headers['user-agent']?.firstOrNull;

    // 4. Calcular expiración canónica según configuración de JWT
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(_getRefreshTokenLifetime(session));

    // 5. Insertar o actualizar fila en user_session usando authSessionId
    final existingSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.authSessionId.equals(authSessionId),
    );

    final UserSession userSession;
    if (existingSession != null) {
      userSession = await UserSession.db.updateRow(
        session,
        existingSession.copyWith(
          userId: appUser.id!,
          isRevoked: false,
          mfaVerified: mfaVerified ?? false,
          lastActivityAt: now,
          expiresAt: expiresAt,
          ipAddress: ipAddress,
          deviceInfo: deviceInfo,
        ),
      );
    } else {
      userSession = await UserSession.db.insertRow(
        session,
        UserSession(
          userId: appUser.id!,
          authSessionId: authSessionId,
          sessionTokenHash: null,
          ipAddress: ipAddress,
          deviceInfo: deviceInfo,
          isRevoked: false,
          mfaVerified: mfaVerified ?? false,
          reconcileAttempts: 0,
          createdAt: now,
          lastActivityAt: now,
          expiresAt: expiresAt,
        ),
      );
    }

    // 6. Registrar evento LOGIN_SUCCESS en audit_log
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
          'authSessionId': authSessionId,
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

    final now = DateTime.now().toUtc();
    await UserSession.db.updateRow(
      session,
      userSession.copyWith(
        isRevoked: true,
        revokedAt: now,
        lastActivityAt: now,
      ),
    );

    // Revocar en Serverpod nativo si tiene authSessionId
    if (userSession.authSessionId != null) {
      try {
        await AuthServices.instance.tokenManager.revokeToken(
          session,
          tokenId: userSession.authSessionId!,
        );
      } catch (e, stackTrace) {
        session.log(
          'Error al revocar refresh token en Serverpod para sessionId $sessionId, authSessionId ${userSession.authSessionId}: $e',
          level: LogLevel.error,
          exception: e,
          stackTrace: stackTrace,
        );
      }
    }

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
  /// Marca la fila en `user_session` como revocada y revoca el token nativo en Serverpod.
  /// Retorna `true` de forma idempotente para preservar la UX de cierre de sesión.
  Future<bool> logout(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    final authSessionId = session.authenticated?.authId;
    if (authUserIdStr == null || authSessionId == null) {
      throw const UnauthorizedException(
        'Identificador de sesión no disponible.',
      );
    }

    // 1. Resolver el AppUser por authUserId
    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    // 2. Buscar exactamente la sesión vinculada a esta llamada
    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(appUser.id!) &
          t.authSessionId.equals(authSessionId) &
          t.isRevoked.equals(false),
    );

    final now = DateTime.now().toUtc();

    // 3. Si la sesión existe en user_session, marcarla como revocada
    if (activeSession != null) {
      await UserSession.db.updateRow(
        session,
        activeSession.copyWith(
          isRevoked: true,
          revokedAt: now,
          lastActivityAt: now,
        ),
      );
    } else {
      session.log(
        'Logout idempotente: no se encontró sesión activa en user_session para authSessionId $authSessionId.',
        level: LogLevel.info,
      );
    }

    // 4. Revocar siempre el refresh token nativo en Serverpod (Fail-Open con alerta y logging)
    try {
      await AuthServices.instance.tokenManager.revokeToken(
        session,
        tokenId: authSessionId,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error al revocar refresh token en Serverpod para authSessionId $authSessionId: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    }

    // 5. Registrar LOGOUT en audit_log
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.logout,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource:
            'session:#${activeSession?.id ?? "unknown"}/user:#${appUser.id}',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {
          'sessionId': activeSession?.id,
          'authSessionId': authSessionId,
          'revokedAt': now.toIso8601String(),
        },
      ),
    );

    return true;
  }

  /// Marca la sesión activa actual del usuario autenticado como verificada con MFA.
  Future<void> markMfaVerified(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    final authSessionId = session.authenticated?.authId;
    if (authUserIdStr == null || authSessionId == null) {
      throw const UnauthorizedException('Usuario o sesión no autenticada.');
    }

    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(appUser.id!) &
          t.authSessionId.equals(authSessionId) &
          t.isRevoked.equals(false),
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
    final isUuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(authUserIdStr);
    if (isUuid) {
      try {
        authUuid = UuidValue.fromString(authUserIdStr);
      } catch (_) {
        // No es un UUID
      }
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
