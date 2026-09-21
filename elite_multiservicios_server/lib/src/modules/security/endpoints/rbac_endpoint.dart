import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';
import '../repositories/rbac_repository.dart';

/// Endpoint RPC para administración de Roles y Permisos Granulares (RBAC).
class RbacEndpoint extends Endpoint {
  final AuditService _auditService;

  RbacEndpoint({AuditService auditService = const ServerpodAuditService()})
    : _auditService = auditService;

  /// Lista los roles registrados en el sistema. Requiere roles.view.
  Future<List<AppRole>> listRoles(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.rolesView);

    final repo = RbacRepository(session);
    return await repo.listRoles();
  }

  /// Lista el catálogo de permisos granulares. Requiere permissions.view.
  Future<List<AppPermission>> listPermissions(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.permissionsView);

    final repo = RbacRepository(session);
    return await repo.listPermissions();
  }

  /// Asigna un rol a un usuario. Requiere roles.manage.
  Future<UserRole> assignRoleToUser(
    Session session, {
    required int userId,
    required int roleId,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.rolesManage,
    );

    final repo = RbacRepository(session);
    final assignment = await repo.assignRoleToUser(userId, roleId);

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.roleUpdated,
        userIdentifier: caller,
        resource: 'user:#$userId/role:#$roleId',
        result: AuditResult.success,
        metadata: {'action': 'assignRole'},
      ),
    );

    return assignment;
  }

  /// Remueve un rol asignado a un usuario. Requiere roles.manage.
  Future<bool> removeRoleFromUser(
    Session session, {
    required int userId,
    required int roleId,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.rolesManage,
    );

    final repo = RbacRepository(session);
    final success = await repo.removeRoleFromUser(userId, roleId);

    if (success) {
      await _auditService.logEvent(
        session,
        AuditEventRecord(
          action: AuditEventType.roleUpdated,
          userIdentifier: caller,
          resource: 'user:#$userId/role:#$roleId',
          result: AuditResult.success,
          metadata: {'action': 'removeRole'},
        ),
      );
    }

    return success;
  }

  /// Asigna un permiso granular a un rol. Requiere permissions.assign.
  Future<RolePermission> assignPermissionToRole(
    Session session, {
    required int roleId,
    required int permissionId,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.permissionsAssign,
    );

    final repo = RbacRepository(session);
    final link = await repo.assignPermissionToRole(roleId, permissionId);

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.permissionChanged,
        userIdentifier: caller,
        resource: 'role:#$roleId/permission:#$permissionId',
        result: AuditResult.success,
      ),
    );

    return link;
  }

  /// Obtiene la lista de códigos de permisos efectivos de un usuario.
  Future<List<String>> getUserEffectivePermissions(
    Session session,
    int userId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rolesView);

    final repo = RbacRepository(session);
    final permissions = await repo.getEffectivePermissionsForUser(userId);
    return permissions.toList()..sort();
  }

  /// Crea un nuevo rol empresarial. Requiere roles.manage.
  Future<AppRole> createRole(Session session, AppRole role) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.rolesManage,
    );

    final repo = RbacRepository(session);
    final created = await repo.createRole(role);

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.roleUpdated,
        userIdentifier: caller,
        resource: 'role:#${created.id}',
        result: AuditResult.success,
        metadata: {'action': 'createRole', 'name': created.name},
      ),
    );

    return created;
  }

  /// Actualiza un rol existente. Requiere roles.manage.
  Future<AppRole> updateRole(Session session, AppRole role) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.rolesManage,
    );

    final repo = RbacRepository(session);
    final updated = await repo.updateRole(role);

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.roleUpdated,
        userIdentifier: caller,
        resource: 'role:#${updated.id}',
        result: AuditResult.success,
        metadata: {'action': 'updateRole', 'name': updated.name},
      ),
    );

    return updated;
  }

  /// Elimina un rol empresarial (los de sistema no se pueden eliminar). Requiere roles.manage.
  Future<bool> deleteRole(Session session, int roleId) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.rolesManage,
    );

    final repo = RbacRepository(session);
    final success = await repo.deleteRole(roleId);

    if (success) {
      await _auditService.logEvent(
        session,
        AuditEventRecord(
          action: AuditEventType.roleUpdated,
          userIdentifier: caller,
          resource: 'role:#$roleId',
          result: AuditResult.success,
          metadata: {'action': 'deleteRole'},
        ),
      );
    }

    return success;
  }

  /// Obtiene los IDs de los permisos asignados a un rol. Requiere permissions.view.
  Future<List<int>> getRolePermissions(Session session, int roleId) async {
    await RbacGuard.requirePermission(session, AppPermissions.permissionsView);
    final repo = RbacRepository(session);
    return await repo.getRolePermissions(roleId);
  }

  /// Sincroniza en bloque los permisos de un rol (Matriz RBAC). Requiere permissions.assign.
  Future<List<int>> syncRolePermissions(
    Session session, {
    required int roleId,
    required List<int> permissionIds,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.permissionsAssign,
    );

    final repo = RbacRepository(session);
    final synced = await repo.syncRolePermissions(roleId, permissionIds);

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.permissionChanged,
        userIdentifier: caller,
        resource: 'role:#$roleId',
        result: AuditResult.success,
        metadata: {'assignedPermissionsCount': synced.length},
      ),
    );

    return synced;
  }
}
