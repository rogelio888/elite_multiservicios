import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio para la gestión relacional de RBAC (Roles y Permisos Granulares).
class RbacRepository {
  final Session session;

  const RbacRepository(this.session);

  /// Obtiene todos los roles registrados.
  Future<List<AppRole>> listRoles() async {
    return await AppRole.db.find(session, orderBy: (t) => t.name);
  }

  /// Obtiene el catálogo completo de permisos del sistema.
  Future<List<AppPermission>> listPermissions() async {
    return await AppPermission.db.find(session, orderBy: (t) => t.code);
  }

  /// Asigna un rol a un usuario. Si ya está asignado, retorna la asignación existente.
  Future<UserRole> assignRoleToUser(int userId, int roleId) async {
    final existing = await UserRole.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.roleId.equals(roleId),
    );

    if (existing != null) return existing;

    return await UserRole.db.insertRow(
      session,
      UserRole(
        userId: userId,
        roleId: roleId,
        assignedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Remueve un rol asignado a un usuario.
  Future<bool> removeRoleFromUser(int userId, int roleId) async {
    final existing = await UserRole.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.roleId.equals(roleId),
    );

    if (existing == null) return false;

    await UserRole.db.deleteRow(session, existing);
    return true;
  }

  /// Asigna un permiso granular a un rol.
  Future<RolePermission> assignPermissionToRole(
    int roleId,
    int permissionId,
  ) async {
    final existing = await RolePermission.db.findFirstRow(
      session,
      where: (t) =>
          t.roleId.equals(roleId) & t.permissionId.equals(permissionId),
    );

    if (existing != null) return existing;

    return await RolePermission.db.insertRow(
      session,
      RolePermission(
        roleId: roleId,
        permissionId: permissionId,
        assignedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Obtiene el conjunto de códigos de permisos efectivos para un usuario.
  /// Resuelve la cadena relacional: Usuario -> Roles -> Permisos.
  Future<Set<String>> getEffectivePermissionsForUser(int userId) async {
    // 1. Obtener roles asociados al usuario
    final userRoles = await UserRole.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (userRoles.isEmpty) return {};

    final roleIds = userRoles.map((ur) => ur.roleId).toList();

    // 2. Obtener permisos vinculados a esos roles
    final rolePermissions = await RolePermission.db.find(
      session,
      where: (t) => t.roleId.inSet(roleIds.toSet()),
    );

    if (rolePermissions.isEmpty) return {};

    final permissionIds = rolePermissions.map((rp) => rp.permissionId).toSet();

    // 3. Obtener los códigos canónicos de los permisos
    final permissions = await AppPermission.db.find(
      session,
      where: (t) => t.id.inSet(permissionIds),
    );

    return permissions.map((p) => p.code).toSet();
  }
}
