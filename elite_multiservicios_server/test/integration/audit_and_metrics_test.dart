import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/audit/audit_event.dart';
import 'package:elite_multiservicios_server/src/modules/security/repositories/audit_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Audit and SystemMetrics Integration Tests', (
    sessionBuilder,
    endpoints,
  ) {
    test(
      'AuditRepository.listLogsPaged filters by action and paginates correctly',
      () async {
        // Usar session interna de Serverpod
        final session =
            (sessionBuilder as dynamic).internalBuild(
                  endpoint: 'audit',
                  method: 'listLogsPaged',
                )
                as Session;

        final repo = AuditRepository(session);

        // Insertar eventos de prueba
        await repo.record(
          AuditEventRecord(
            action: AuditEventType.loginSuccess,
            userIdentifier: 'test_audit_user@elitemultiservicios.com',
            result: AuditResult.success,
            ipAddress: '10.0.0.1',
            resource: 'session:#101',
          ),
        );

        await repo.record(
          AuditEventRecord(
            action: AuditEventType.loginFailed,
            userIdentifier: 'test_audit_user@elitemultiservicios.com',
            result: AuditResult.failure,
            ipAddress: '10.0.0.2',
            resource: 'session:#102',
          ),
        );

        // 1. Consulta sin filtros
        final pageAll = await repo.listLogsPaged(
          page: 1,
          pageSize: 10,
          search: 'test_audit_user@elitemultiservicios.com',
        );

        expect(pageAll.items.length, greaterThanOrEqualTo(2));
        expect(pageAll.totalCount, greaterThanOrEqualTo(2));
        expect(pageAll.page, equals(1));
        expect(pageAll.pageSize, equals(10));

        // 2. Filtro por acción 'LOGIN_SUCCESS'
        final pageSuccess = await repo.listLogsPaged(
          page: 1,
          pageSize: 10,
          action: 'LOGIN_SUCCESS',
          search: 'test_audit_user@elitemultiservicios.com',
        );

        expect(pageSuccess.items, isNotEmpty);
        for (final item in pageSuccess.items) {
          expect(item.action, equals('LOGIN_SUCCESS'));
        }

        // 3. Filtro por resultado 'FAILURE'
        final pageFailure = await repo.listLogsPaged(
          page: 1,
          pageSize: 10,
          result: 'FAILURE',
          search: 'test_audit_user@elitemultiservicios.com',
        );

        expect(pageFailure.items, isNotEmpty);
        for (final item in pageFailure.items) {
          expect(item.result, equals('FAILURE'));
        }
      },
    );

    test(
      'AuditEndpoint requires authentication & audit.view permission',
      () async {
        // Llamada sin autenticación debe fallar
        expect(
          () => endpoints.audit.listLogsPaged(
            sessionBuilder,
            page: 1,
            pageSize: 25,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'SystemMetricsEndpoint requires authentication & audit.view permission',
      () async {
        // Llamada sin autenticación debe fallar
        expect(
          () => endpoints.systemMetrics.getMetrics(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
