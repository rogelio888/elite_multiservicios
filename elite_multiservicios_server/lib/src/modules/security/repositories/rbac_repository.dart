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

  /// Obtiene los roles asignados a un usuario.
  Future<List<AppRole>> getUserRoles(int userId) async {
    final userRoles = await UserRole.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (userRoles.isEmpty) return [];
    final roleIds = userRoles.map((ur) => ur.roleId).toSet();
    return await AppRole.db.find(
      session,
      where: (t) => t.id.inSet(roleIds),
    );
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

  /// Remueve todos los roles asignados a un usuario.
  Future<void> removeAllRolesFromUser(int userId) async {
    await UserRole.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
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

  /// Crea un nuevo rol empresarial (no de sistema).
  Future<AppRole> createRole(AppRole role) async {
    final cleanName = role.name.trim();
    if (cleanName.isEmpty) {
      throw const FormatException('El nombre del rol es requerido.');
    }

    final existing = await AppRole.db.findFirstRow(
      session,
      where: (t) => t.name.ilike(cleanName),
    );
    if (existing != null) {
      throw FormatException('Ya existe un rol con el nombre "$cleanName".');
    }

    final toInsert = role.copyWith(
      name: cleanName,
      description: role.description.trim(),
      isSystemRole: false,
      createdAt: DateTime.now().toUtc(),
    );

    return await AppRole.db.insertRow(session, toInsert);
  }

  /// Actualiza un rol existente con salvaguarda para roles del sistema.
  Future<AppRole> updateRole(AppRole role) async {
    final existing = await AppRole.db.findById(session, role.id!);
    if (existing == null) {
      throw const FormatException('El rol solicitado no existe.');
    }

    final isSuper =
        existing.isSystemRole || existing.name.toLowerCase() == 'superadmin';
    final cleanName = isSuper ? existing.name : role.name.trim();

    final toUpdate = existing.copyWith(
      name: cleanName,
      description: role.description.trim(),
      isSystemRole: existing.isSystemRole,
    );

    return await AppRole.db.updateRow(session, toUpdate);
  }

  /// Elimina un rol si no es de sistema y purga sus dependencias.
  Future<bool> deleteRole(int roleId) async {
    final existing = await AppRole.db.findById(session, roleId);
    if (existing == null) return false;

    if (existing.isSystemRole || existing.name.toLowerCase() == 'superadmin') {
      throw const FormatException(
        'Los roles base del sistema son inmutables y no pueden ser eliminados.',
      );
    }

    // 1. Limpiar asignaciones de usuarios y permisos
    await UserRole.db.deleteWhere(
      session,
      where: (t) => t.roleId.equals(roleId),
    );
    await RolePermission.db.deleteWhere(
      session,
      where: (t) => t.roleId.equals(roleId),
    );

    // 2. Eliminar rol
    await AppRole.db.deleteRow(session, existing);
    return true;
  }

  /// Obtiene la lista de IDs de permisos asignados a un rol.
  Future<List<int>> getRolePermissions(int roleId) async {
    final links = await RolePermission.db.find(
      session,
      where: (t) => t.roleId.equals(roleId),
    );
    return links.map((l) => l.permissionId).toList();
  }

  /// Sincroniza atómicamente todos los permisos asignados a un rol.
  Future<List<int>> syncRolePermissions(
    int roleId,
    List<int> permissionIds,
  ) async {
    final role = await AppRole.db.findById(session, roleId);
    if (role == null) {
      throw const FormatException('El rol no existe.');
    }

    final isSuper =
        role.isSystemRole && role.name.toLowerCase() == 'superadmin';
    List<int> targetIds = permissionIds;

    // Si es superadmin, nunca se le pueden revocar permisos
    if (isSuper) {
      final allPerms = await AppPermission.db.find(session);
      targetIds = allPerms.map((p) => p.id!).toList();
    }

    // Purgar anteriores
    await RolePermission.db.deleteWhere(
      session,
      where: (t) => t.roleId.equals(roleId),
    );

    // Insertar nuevos
    final now = DateTime.now().toUtc();
    for (final permId in targetIds.toSet()) {
      await RolePermission.db.insertRow(
        session,
        RolePermission(
          roleId: roleId,
          permissionId: permId,
          assignedAt: now,
        ),
      );
    }

    return targetIds;
  }
}
