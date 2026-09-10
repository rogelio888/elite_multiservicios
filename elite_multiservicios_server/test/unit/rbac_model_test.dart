import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';

void main() {
  group('Security & RBAC Models Integrity Tests', () {
    test(
      'AppUser model instantiates with proper defaults and serialization',
      () {
        final now = DateTime.now().toUtc();
        final user = AppUser(
          email: 'developer@elite.com',
          fullName: 'Elite Developer',
          isActive: true,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        );

        expect(user.email, equals('developer@elite.com'));
        expect(user.isActive, isTrue);
        expect(user.isDeleted, isFalse);

        final json = user.toJson();
        expect(json['email'], equals('developer@elite.com'));
        expect(json['isActive'], isTrue);
        expect(json['isDeleted'], isFalse);
      },
    );

    test('AppRole and AppPermission models serialize correctly', () {
      final role = AppRole(
        name: 'Administrador',
        description: 'Acceso total a la plataforma',
        isSystemRole: true,
        createdAt: DateTime.now().toUtc(),
      );

      final permission = AppPermission(
        code: AppPermissions.usersCreate,
        module: 'users',
        description: 'Permite crear nuevos colaboradores',
      );

      expect(role.isSystemRole, isTrue);
      expect(permission.code, equals(AppPermissions.usersCreate));
      expect(permission.module, equals('users'));
    });

    test(
      'UserRole and RolePermission associations contain required relational foreign keys',
      () {
        final now = DateTime.now().toUtc();
        final userRole = UserRole(userId: 10, roleId: 2, assignedAt: now);
        final rolePerm = RolePermission(
          roleId: 2,
          permissionId: 5,
          assignedAt: now,
        );

        expect(userRole.userId, equals(10));
        expect(userRole.roleId, equals(2));
        expect(rolePerm.roleId, equals(2));
        expect(rolePerm.permissionId, equals(5));
      },
    );

    test('UserSession model holds security and expiration attributes', () {
      final now = DateTime.now().toUtc();
      final expires = now.add(const Duration(hours: 8));

      final session = UserSession(
        userId: 10,
        sessionTokenHash: 'sha256_hash_dummy_token',
        ipAddress: '127.0.0.1',
        deviceInfo: 'Mozilla/5.0 (Windows NT 10.0)',
        isRevoked: false,
        createdAt: now,
        lastActivityAt: now,
        expiresAt: expires,
      );

      expect(session.isRevoked, isFalse);
      expect(session.expiresAt.isAfter(session.createdAt), isTrue);
      expect(session.sessionTokenHash, isNotEmpty);
    });
  });
}
