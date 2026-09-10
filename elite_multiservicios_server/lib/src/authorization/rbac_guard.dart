import 'package:serverpod/serverpod.dart';
import '../exceptions/app_exception.dart';

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

  /// Verifica que el usuario autenticado posea el permiso requerido.
  /// Se integra con el sistema de scopes o permisos de base de datos.
  static void requirePermission(
    Session session,
    String requiredPermission, {
    Set<String> userPermissions = const {},
  }) {
    requireAuthentication(session);

    if (!userPermissions.contains(requiredPermission)) {
      throw ForbiddenException(
        requiredPermission: requiredPermission,
        message: 'No posee el permiso requerido: $requiredPermission',
      );
    }
  }
}
