import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as auth_idp;
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';
import '../../../exceptions/app_exception.dart';
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
    await RbacGuard.requireMfaVerified(session);
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
    await RbacGuard.requireMfaVerified(session);
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
    await RbacGuard.requireMfaVerified(session);
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
    await RbacGuard.requireMfaVerified(session);
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

  /// Retorna el AppUser asociado a la sesión autenticada actual.
  Future<AppUser> getCurrentUser(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado');
    }
    return await _resolveAuthenticatedAppUser(session, authUserIdStr);
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword(
    Session session, {
    required String currentPassword,
    required String newPassword,
  }) async {
    await RbacGuard.requireMfaVerified(session);
    // 1. Resolver el AppUser
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado');
    }
    final appUser = await _resolveAuthenticatedAppUser(session, authUserIdStr);

    // 2. Validar la contraseña actual usando Serverpod Auth IDP
    final authUuid = UuidValue.fromString(authUserIdStr);
    final emailAccount = await auth_idp.EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUuid),
    );
    if (emailAccount == null) {
      throw Exception('Cuenta de autenticación no encontrada');
    }

    final isCurrentValid = await AuthServices.instance.emailIdp.utils.hashUtil
        .validateHashFromString(
          secret: currentPassword,
          hashString: emailAccount.passwordHash,
        );
    if (!isCurrentValid) {
      throw Exception('La contraseña actual es incorrecta');
    }

    // 3. Validar la nueva contraseña (mínimo 8 caracteres)
    if (newPassword.trim().length < 8) {
      throw Exception('La nueva contraseña debe tener al menos 8 caracteres');
    }

    // 4. Actualizar la contraseña en Serverpod Auth IDP
    await AuthServices.instance.emailIdp.admin.setPassword(
      session,
      email: emailAccount.email,
      password: newPassword,
    );

    // 5. Actualizar `mustChangePassword: false` en AppUser
    final now = DateTime.now().toUtc();
    await AppUser.db.updateRow(
      session,
      appUser.copyWith(
        mustChangePassword: false,
        updatedAt: now,
      ),
    );

    // 6. Registrar en audit_log
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.passwordChanged,
        userId: appUser.id,
        userIdentifier: authUserIdStr,
        resource: 'user:#${appUser.id}',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {'changedAt': now.toIso8601String()},
      ),
    );
  }

  /// Resuelve la entidad AppUser vinculada a las credenciales autenticadas en la sesión.
  Future<AppUser> _resolveAuthenticatedAppUser(
    Session session,
    String authUserIdStr,
  ) async {
    AppUser? appUser;
    UuidValue? authUuid;
    try {
      authUuid = UuidValue.fromString(authUserIdStr);
    } catch (_) {}

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
