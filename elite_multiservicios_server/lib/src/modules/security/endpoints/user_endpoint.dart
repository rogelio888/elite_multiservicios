import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/rbac_repository.dart';

/// Endpoint RPC para administración del ciclo de vida de usuarios.
/// Protegido con autorización backend-first estricta.
class UserEndpoint extends Endpoint {
  final AuditService _auditService;

  UserEndpoint({AuditService auditService = const ServerpodAuditService()})
    : _auditService = auditService;

  /// Lista usuarios paginados. Requiere permiso users.view.
  Future<List<AppUser>> listUsers(
    Session session, {
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.usersView);

    final repo = UserRepository(session);
    return await repo.listUsers(
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene el detalle de un usuario por ID. Requiere permiso users.view.
  Future<AppUser?> getUser(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.usersView);

    final repo = UserRepository(session);
    return await repo.findById(id);
  }

  /// Crea un nuevo usuario empresarial y le asocia sus roles iniciales. Requiere users.create.
  Future<AppUser> createUser(
    Session session, {
    required String email,
    required String fullName,
    List<int> roleIds = const [],
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.usersCreate,
    );

    final userRepo = UserRepository(session);
    final rbacRepo = RbacRepository(session);

    final existing = await userRepo.findByEmail(email);
    if (existing != null) {
      throw FormatException('El correo $email ya se encuentra registrado.');
    }

    final now = DateTime.now().toUtc();
    final newUser = await userRepo.create(
      AppUser(
        email: email,
        fullName: fullName,
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    // Asignar roles iniciales
    if (newUser.id != null) {
      for (final roleId in roleIds) {
        await rbacRepo.assignRoleToUser(newUser.id!, roleId);
      }
    }

    // Registrar en bitácora de auditoría
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.userCreated,
        userIdentifier: caller,
        resource: 'user:#${newUser.id}',
        result: AuditResult.success,
        metadata: {'email': email, 'rolesCount': roleIds.length},
      ),
    );

    return newUser;
  }

  /// Actualiza información de un usuario. Requiere users.update.
  Future<AppUser?> updateUser(
    Session session, {
    required int id,
    required String fullName,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.usersUpdate,
    );

    final repo = UserRepository(session);
    final user = await repo.findById(id);
    if (user == null) return null;

    final updated = await repo.update(user.copyWith(fullName: fullName));

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.userUpdated,
        userIdentifier: caller,
        resource: 'user:#$id',
        result: AuditResult.success,
        metadata: {'updatedField': 'fullName'},
      ),
    );

    return updated;
  }

  /// Activa o desactiva la cuenta de un usuario. Requiere users.disable.
  Future<bool> setUserActive(
    Session session, {
    required int id,
    required bool isActive,
  }) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.usersDisable,
    );

    final repo = UserRepository(session);
    final updated = await repo.setActiveStatus(id, isActive);
    if (updated == null) return false;

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: isActive
            ? AuditEventType.userUpdated
            : AuditEventType.userDisabled,
        userIdentifier: caller,
        resource: 'user:#$id',
        result: AuditResult.success,
        metadata: {'isActive': isActive},
      ),
    );

    return true;
  }

  /// Borrado lógico (Soft Delete) de un usuario. Requiere users.delete.
  Future<bool> deleteUser(Session session, int id) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.usersDelete,
    );

    final repo = UserRepository(session);
    final success = await repo.softDelete(id);
    if (!success) return false;

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.userDisabled,
        userIdentifier: caller,
        resource: 'user:#$id',
        result: AuditResult.success,
        metadata: {'softDelete': true},
      ),
    );

    return true;
  }
}
