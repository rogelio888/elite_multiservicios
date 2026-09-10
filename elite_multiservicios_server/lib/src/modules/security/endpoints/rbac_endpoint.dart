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
}
