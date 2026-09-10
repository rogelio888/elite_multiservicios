import 'package:serverpod/serverpod.dart';
import '../exceptions/app_exception.dart';
import '../modules/security/repositories/rbac_repository.dart';

/// Guardia de autorización basada en roles y permisos granulares (RBAC).
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

    // 2. Scopes de sesión de Serverpod
    final scopes = session.authenticated?.scopes ?? {};
    if (scopes.any((s) => s.name == requiredPermission || s.name == 'admin')) {
      return userIdentifier;
    }

    // 3. Resolución relacional en PostgreSQL
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

    throw ForbiddenException(
      requiredPermission: requiredPermission,
      message: 'No posee el permiso requerido: $requiredPermission',
    );
  }
}
