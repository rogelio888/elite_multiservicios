import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';
import 'package:elite_multiservicios_server/src/authorization/rbac_guard.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';
import 'package:elite_multiservicios_server/src/audit/audit_event.dart';

void main() {
  group('Security Endpoints & Authorization Unit Tests', () {
    test(
      'RbacGuard.validatePermission allows operation when permission exists',
      () {
        final userPermissions = {
          AppPermissions.usersView,
          AppPermissions.rolesView,
        };

        expect(
          () => RbacGuard.validatePermission(
            userPermissions,
            AppPermissions.usersView,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'RbacGuard.validatePermission throws ForbiddenException when permission is missing',
      () {
        final userPermissions = {
          AppPermissions.usersView,
        };

        expect(
          () => RbacGuard.validatePermission(
            userPermissions,
            AppPermissions.usersCreate,
          ),
          throwsA(
            isA<ForbiddenException>().having(
              (e) => e.requiredPermission,
              'requiredPermission',
              equals(AppPermissions.usersCreate),
            ),
          ),
        );
      },
    );

    test(
      'Audit events construct with correct parameters and serializations',
      () {
        final event = AuditEventRecord(
          action: AuditEventType.roleUpdated,
          userIdentifier: 'admin@elite.com',
          resource: 'user:#5/role:#2',
          result: AuditResult.success,
          metadata: {'action': 'assignRole'},
        );

        expect(event.action, equals('ROLE_UPDATED'));
        expect(event.result, equals(AuditResult.success));
        expect(event.metadata?['action'], equals('assignRole'));
        expect(event.toJson()['resource'], equals('user:#5/role:#2'));
      },
    );

    test('AppPermissions catalogs are formatted canonically', () {
      for (final perm in AppPermissions.all) {
        expect(perm, contains('.'));
        final parts = perm.split('.');
        expect(parts.length, equals(2));
        expect(parts.first, isNotEmpty);
        expect(parts.last, isNotEmpty);
      }
    });
  });
}
