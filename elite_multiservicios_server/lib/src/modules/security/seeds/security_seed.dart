import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';

/// Seed de base de datos para inicializar el catálogo de permisos canónicos y rol inicial.
/// Cumple con la política de datos reales de base de datos (No-Mock Policy).
class SecuritySeed {
  /// Inicializa los permisos canónicos y el rol Super Administrador si no existen.
  static Future<void> seed(Session session) async {
    session.log(
      'Ejecutando seed de seguridad en PostgreSQL...',
      level: LogLevel.info,
    );

    // 1. Catálogo de Permisos
    for (final code in AppPermissions.all) {
      final existing = await AppPermission.db.findFirstRow(
        session,
        where: (t) => t.code.equals(code),
      );

      if (existing == null) {
        final parts = code.split('.');
        final module = parts.isNotEmpty ? parts.first : 'system';

        await AppPermission.db.insertRow(
          session,
          AppPermission(
            code: code,
            module: module,
            description: 'Permiso canónico del sistema para $code',
          ),
        );
      }
    }

    // 2. Rol Super Administrador
    var adminRole = await AppRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals('Super Administrador'),
    );

    adminRole ??= await AppRole.db.insertRow(
      session,
      AppRole(
        name: 'Super Administrador',
        description: 'Rol con acceso total e irrestricto a todos los módulos',
        isSystemRole: true,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    // 3. Vincular todos los permisos al rol Super Administrador
    final allPermissions = await AppPermission.db.find(session);
    for (final perm in allPermissions) {
      if (perm.id == null) continue;

      final existingLink = await RolePermission.db.findFirstRow(
        session,
        where: (t) =>
            t.roleId.equals(adminRole!.id!) & t.permissionId.equals(perm.id!),
      );

      if (existingLink == null) {
        await RolePermission.db.insertRow(
          session,
          RolePermission(
            roleId: adminRole.id!,
            permissionId: perm.id!,
            assignedAt: DateTime.now().toUtc(),
          ),
        );
      }
    }

    session.log(
      'Seed de seguridad completado exitosamente.',
      level: LogLevel.info,
    );
  }
}
