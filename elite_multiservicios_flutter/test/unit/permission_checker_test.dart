import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/permissions/permission_checker.dart';

void main() {
  group('PermissionChecker Tests', () {
    test('has() returns true when permission is present', () {
      final checker = PermissionChecker(
        userPermissions: {'users.view', 'users.create'},
      );

      expect(checker.has('users.view'), isTrue);
      expect(checker.has('users.delete'), isFalse);
    });

    test('hasAny() returns true when at least one permission matches', () {
      final checker = PermissionChecker(
        userPermissions: {'audit.view'},
      );

      expect(
        checker.hasAny(['audit.view', 'audit.export']),
        isTrue,
      );
      expect(
        checker.hasAny(['system.maintenance', 'roles.manage']),
        isFalse,
      );
    });

    test('hasAll() returns true only when all permissions are present', () {
      final checker = PermissionChecker(
        userPermissions: {'roles.view', 'roles.manage'},
      );

      expect(
        checker.hasAll(['roles.view', 'roles.manage']),
        isTrue,
      );
      expect(
        checker.hasAll(['roles.view', 'roles.manage', 'users.create']),
        isFalse,
      );
    });
  });
}
