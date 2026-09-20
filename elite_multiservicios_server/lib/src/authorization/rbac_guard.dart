import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as auth_idp;
import '../generated/protocol.dart';
import '../exceptions/app_exception.dart';
import '../modules/security/repositories/rbac_repository.dart';

/// Guardia de autorización basada en roles y permisos granulares (RBAC) y MFA.
/// La seguridad se valida siempre en el servidor.
class RbacGuard {
  /// Verifica que la sesión cuente con un usuario autenticado.
  static String requireAuthentication(Session session) {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw const UnauthorizedException();
    }
    return authInfo.userIdentifier;
  }

  /// Comprueba directamente si un conjunto de permisos efectivos contiene el permiso requerido.
  /// Lanza [ForbiddenException] si no está presente.
  static void validatePermission(
    Set<String> effectivePermissions,
    String requiredPermission,
  ) {
    if (!effectivePermissions.contains(requiredPermission)) {
      throw ForbiddenException(
        requiredPermission: requiredPermission,
        message: 'No posee el permiso requerido: $requiredPermission',
      );
    }
  }

  /// Verifica que el usuario autenticado posea el permiso requerido.
  /// Valida en orden:
  /// 1. Permisos explícitos provistos (tests o caché).
  /// 2. Scopes de autenticación en sesión de Serverpod.
  /// 3. Permisos efectivos resueltos desde PostgreSQL mediante [RbacRepository].
  static Future<String> requirePermission(
    Session session,
    String requiredPermission, {
    Set<String>? userPermissions,
  }) async {
    final userIdentifier = requireAuthentication(session);

    // 1. Permisos explícitos provistos
    if (userPermissions != null) {
      validatePermission(userPermissions, requiredPermission);
      return userIdentifier;
    }

    // 2. Comprobación OBLIGATORIA de MFA para toda llamada protegida
    await requireMfaVerified(session);

    // 3. Scopes de sesión de Serverpod
    final scopes = session.authenticated?.scopes ?? {};
    if (scopes.any((s) => s.name == requiredPermission || s.name == 'admin')) {
      return userIdentifier;
    }

    // 3. Resolución relacional en PostgreSQL
    try {
      final appUser = await resolveAppUser(session, userIdentifier);
      if (appUser.id != null) {
        final rbacRepo = RbacRepository(session);
        final effectivePerms = await rbacRepo.getEffectivePermissionsForUser(
          appUser.id!,
        );
        if (effectivePerms.contains(requiredPermission)) {
          return userIdentifier;
        }
      }
    } catch (_) {
      final userIdInt = int.tryParse(userIdentifier);
      if (userIdInt != null) {
        final rbacRepo = RbacRepository(session);
        final effectivePerms = await rbacRepo.getEffectivePermissionsForUser(
          userIdInt,
        );
        if (effectivePerms.contains(requiredPermission)) {
          return userIdentifier;
        }
      }
    }

    throw ForbiddenException(
      requiredPermission: requiredPermission,
      message: 'No posee el permiso requerido: $requiredPermission',
    );
  }

  /// Verifica que la sesión actual tenga MFA verificado para usuarios con MFA habilitado.
  /// Si no está verificado, lanza [MfaRequiredException].
  static Future<void> requireMfaVerified(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado.');
    }

    // 1. Resolver el AppUser autenticado
    final appUser = await resolveAppUser(session, authUserIdStr);

    // 2. Si el usuario no tiene MFA habilitado en su cuenta, no se exige verificación
    if (!appUser.mfaEnabled) {
      return;
    }

    // 3. Buscar la sesión activa del usuario
    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (activeSession == null || !activeSession.mfaVerified) {
      throw const MfaRequiredException();
    }
  }

  /// Resuelve la entidad AppUser vinculada al identificador de autenticación.
  static Future<AppUser> resolveAppUser(
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
      throw const UnauthorizedException(
        'AppUser no encontrado para el usuario autenticado.',
      );
    }

    return appUser;
  }
}
