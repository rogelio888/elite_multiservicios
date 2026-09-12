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

    // 4. Sembrado seguro del usuario Administrador Inicial
    final adminEmail =
        Platform.environment['SEED_ADMIN_EMAIL'] ??
        'admin@elitemultiservicios.com';
    final adminPassword = Platform.environment['SEED_ADMIN_PASSWORD'];

    if (adminPassword == null || adminPassword.isEmpty) {
      throw StateError(
        'FATAL: La variable de entorno SEED_ADMIN_PASSWORD no está definida. '
        'No se permite sembrar el usuario administrador sin una contraseña explícita.',
      );
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
      session.log('Credenciales Auth IDP para $adminEmail ya existen.');
    }

    var adminUser = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(adminEmail),
    );

    adminUser ??= await AppUser.db.insertRow(
      session,
      AppUser(
        email: adminEmail,
        fullName: 'Administrador del Sistema',
        isActive: true,
        isDeleted: false,
        mustChangePassword: true,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );

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

    session.log(
      'Seed de seguridad completado exitosamente con usuario admin: $adminEmail.',
      level: LogLevel.info,
    );
  }
}
