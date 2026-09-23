import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
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

    // 3.1 Rol Developer (Ingeniería de Software con acceso total)
    var devRole = await AppRole.db.findFirstRow(
      session,
      where: (t) => t.name.equals('Developer'),
    );

    devRole ??= await AppRole.db.insertRow(
      session,
      AppRole(
        name: 'Developer',
        description:
            'Rol de ingeniería con acceso completo a todos los módulos del sistema',
        isSystemRole: true,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    for (final perm in allPermissions) {
      if (perm.id == null) continue;

      final existingLink = await RolePermission.db.findFirstRow(
        session,
        where: (t) =>
            t.roleId.equals(devRole!.id!) & t.permissionId.equals(perm.id!),
      );

      if (existingLink == null) {
        await RolePermission.db.insertRow(
          session,
          RolePermission(
            roleId: devRole.id!,
            permissionId: perm.id!,
            assignedAt: DateTime.now().toUtc(),
          ),
        );
      }
    }

    // 4. Sembrado seguro del usuario Administrador Inicial
    final adminEmail =
        Platform.environment['SEED_ADMIN_EMAIL'] ??
        'rogeliovladimir2016@gmail.com';
    final adminPassword = Platform.environment['SEED_ADMIN_PASSWORD'];

    if (adminPassword == null || adminPassword.isEmpty) {
      throw StateError(
        'FATAL: La variable de entorno SEED_ADMIN_PASSWORD no está definida. '
        'No se permite sembrar el usuario administrador sin una contraseña explícita.',
      );
    }

    // 4.0 Limpieza de usuario ficticio obsoleto si no es el adminEmail configurado
    if (adminEmail.trim().toLowerCase() != 'admin@elitemultiservicios.com') {
      final legacyUser = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.email.equals('admin@elitemultiservicios.com'),
      );
      if (legacyUser != null && legacyUser.id != null) {
        session.log(
          'Eliminando usuario semilla obsoleto admin@elitemultiservicios.com...',
          level: LogLevel.info,
        );
        await UserRole.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(legacyUser.id!),
        );
        await AppUser.db.deleteRow(session, legacyUser);
      }
    }

    // 4.1 Sembrado en subsistema de autenticación Serverpod IDP (si no existe)
    final existingAuthAccount = await AuthServices.instance.emailIdp.admin
        .findAccount(session, email: adminEmail);

    if (existingAuthAccount == null) {
      session.log(
        'Creando credenciales Auth IDP para $adminEmail...',
        level: LogLevel.info,
      );

      // A. Crear usuario base de autenticación en Serverpod Core
      final authUser = await AuthServices.instance.authUsers.create(
        session,
        scopes: {Scope('admin')},
      );

      // B. Crear credencial de correo y contraseña hasheada en Serverpod IDP
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: authUser.id,
        email: adminEmail,
        password: adminPassword,
      );

      // C. Crear perfil de usuario en Serverpod Core (necesario ya que createEmailAuthentication no lo crea)
      await AuthServices.instance.userProfiles.createUserProfile(
        session,
        authUser.id,
        UserProfileData(
          email: adminEmail,
          fullName: 'Administrador del Sistema',
          userName: 'admin',
        ),
      );
    } else {
      session.log(
        'Credenciales Auth IDP para $adminEmail ya existen.',
        level: LogLevel.info,
      );
      if (Platform.environment['SEED_ADMIN_OVERWRITE_PASSWORD'] == 'true' ||
          adminPassword.isNotEmpty) {
        session.log(
          'Sincronizando contraseña con SEED_ADMIN_PASSWORD...',
          level: LogLevel.info,
        );
        try {
          await AuthServices.instance.emailIdp.admin.setPassword(
            session,
            email: adminEmail,
            password: adminPassword,
          );
        } catch (e) {
          session.log(
            'Aviso actualizando contraseña en Auth IDP: $e',
            level: LogLevel.warning,
          );
        }
      }
    }

    var adminUser = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(adminEmail),
    );

    final isRogelioAdmin =
        adminEmail.trim().toLowerCase() == 'rogeliovladimir2016@gmail.com';

    if (adminUser == null) {
      adminUser = await AppUser.db.insertRow(
        session,
        AppUser(
          email: adminEmail,
          fullName: isRogelioAdmin
              ? 'Rogelio Hinojosa'
              : 'Administrador del Sistema',
          isActive: true,
          isDeleted: false,
          mustChangePassword: false,
          mfaEnabled: true,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      final isLocked =
          adminUser.failedLoginAttempts > 0 || adminUser.lockedUntil != null;
      final isInactive = !adminUser.isActive;
      final needsMfa = !adminUser.mfaEnabled;
      final needsNameUpdate =
          isRogelioAdmin &&
          (adminUser.fullName == 'Administrador del Sistema' ||
              adminUser.fullName == 'Rogelio Vladimir');

      if (needsMfa || isLocked || isInactive || needsNameUpdate) {
        session.log(
          'Garantizando estado de admin: isActive=true, reset bloqueos, mfaEnabled=true...',
          level: LogLevel.info,
        );
        adminUser = await AppUser.db.updateRow(
          session,
          adminUser.copyWith(
            fullName: needsNameUpdate ? 'Rogelio Hinojosa' : adminUser.fullName,
            isActive: true,
            failedLoginAttempts: 0,
            lockedUntil: null,
            mfaEnabled: true,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    }

    // Vincular rol Super Administrador al usuario creado
    final existingUserRole = await UserRole.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(adminUser!.id!) & t.roleId.equals(adminRole!.id!),
    );

    if (existingUserRole == null) {
      await UserRole.db.insertRow(
        session,
        UserRole(
          userId: adminUser.id!,
          roleId: adminRole.id!,
          assignedAt: DateTime.now().toUtc(),
        ),
      );
    }

    // Directiva de seguridad estricta: Garantizar que TODOS los usuarios del sistema tengan 2FA (MFA) activo
    final usersWithoutMfa = await AppUser.db.find(
      session,
      where: (t) => t.mfaEnabled.equals(false),
    );
    for (final u in usersWithoutMfa) {
      session.log(
        'Activando 2FA obligatorio para usuario ${u.email}...',
        level: LogLevel.info,
      );
      await AppUser.db.updateRow(
        session,
        u.copyWith(
          mfaEnabled: true,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    }

    session.log(
      'Seed de seguridad completado exitosamente con usuario admin: $adminEmail.',
      level: LogLevel.info,
    );
  }
}
