import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';
import 'package:elite_multiservicios_server/src/audit/audit_event.dart';

void main() {
  group('Server Security Domain Unit Tests', () {
    test('AppPermissions catalog contains core RBAC permissions', () {
      expect(AppPermissions.all, contains(AppPermissions.usersView));
      expect(AppPermissions.all, contains(AppPermissions.usersCreate));
      expect(AppPermissions.all, contains(AppPermissions.rolesManage));
      expect(AppPermissions.all, contains(AppPermissions.auditView));
      expect(AppPermissions.all, contains(AppPermissions.sessionsRevoke));
      expect(AppPermissions.all.length, greaterThanOrEqualTo(10));
    });

    test('AppException hierarchy properly preserves code and message', () {
      const unauthorized = UnauthorizedException();
      expect(unauthorized.code, equals('AUTH_REQUIRED'));
      expect(unauthorized.message, contains('no autenticado'));

      const forbidden = ForbiddenException(requiredPermission: 'users.create');
      expect(forbidden.code, equals('FORBIDDEN'));
      expect(forbidden.requiredPermission, equals('users.create'));

      final notFound = EntityNotFoundException('Usuario', 42);
      expect(notFound.code, equals('NOT_FOUND'));
      expect(notFound.entityId, equals(42));
    });

    test('AuditEventRecord serialization conforms to audit specifications', () {
      final record = AuditEventRecord(
        action: AuditEventType.userCreated,
        userId: 1,
        userIdentifier: 'admin@elite.com',
        resource: 'user:#25',
        ipAddress: '192.168.1.100',
        result: AuditResult.success,
      );

      final json = record.toJson();
      expect(json['action'], equals('USER_CREATED'));
      expect(json['userIdentifier'], equals('admin@elite.com'));
      expect(json['result'], equals('success'));
      expect(json['ipAddress'], equals('192.168.1.100'));
      expect(json['timestamp'], isNotNull);
    });
  });
}
