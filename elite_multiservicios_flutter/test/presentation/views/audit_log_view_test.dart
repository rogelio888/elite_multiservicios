import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/views/audit_log_view.dart';
import 'package:elite_multiservicios_flutter/features/security/services/security_api_service.dart';

class MockSecurityApiService extends Mock implements SecurityApiService {}

void main() {
  late MockSecurityApiService mockService;

  setUp(() {
    mockService = MockSecurityApiService();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: AuditLogView(service: mockService),
      ),
    );
  }

  group('AuditLogView Tests', () {
    testWidgets(
      'renders audit log table with paged records and metadata modal',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final sampleLogs = [
          AuditLog(
            id: 1,
            action: 'LOGIN_SUCCESS',
            userId: 1,
            userIdentifier: 'admin@elitemultiservicios.com',
            resource: 'session:#1',
            ipAddress: '192.168.1.50',
            result: 'SUCCESS',
            metadata: '{"method":"password","device":"desktop"}',
            timestamp: DateTime.utc(2026, 9, 12, 14, 30),
          ),
          AuditLog(
            id: 2,
            action: 'LOGIN_FAILED',
            userIdentifier: 'intruder@empresa.com',
            resource: 'auth_idp',
            ipAddress: '203.0.113.19',
            result: 'FAILURE',
            metadata: '{"reason":"invalid_credentials"}',
            timestamp: DateTime.utc(2026, 9, 12, 14, 35),
          ),
        ];

        when(
          () => mockService.listAuditLogsPaged(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
            action: any(named: 'action'),
            result: any(named: 'result'),
            userId: any(named: 'userId'),
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            search: any(named: 'search'),
          ),
        ).thenAnswer(
          (_) async => AuditLogPageResponse(
            items: sampleLogs,
            totalCount: 2,
            page: 1,
            totalPages: 1,
            pageSize: 25,
          ),
        );

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Verificar header
        expect(find.text('Bitácora de Auditoría del Sistema'), findsOneWidget);
        expect(
          find.text('Buscar por usuario, IP, recurso o acción...'),
          findsOneWidget,
        );

        // Verificar registros en la tabla
        expect(find.text('LOGIN_SUCCESS'), findsOneWidget);
        expect(find.text('LOGIN_FAILED'), findsOneWidget);
        expect(find.text('admin@elitemultiservicios.com'), findsOneWidget);
        expect(find.text('intruder@empresa.com'), findsOneWidget);
        expect(find.text('192.168.1.50'), findsOneWidget);

        // Verificar footer de paginación
        expect(find.text('Mostrando 1 a 2 de 2 registros'), findsOneWidget);

        // Abrir modal de detalle
        final detailButtons = find.byIcon(Icons.visibility_outlined);
        expect(detailButtons, findsNWidgets(2));
        await tester.tap(detailButtons.first);
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Detalle de Evento: LOGIN_SUCCESS'),
          findsOneWidget,
        );
        expect(find.text('Metadatos Estructurados (JSON):'), findsOneWidget);
        expect(find.text('Copiar JSON'), findsOneWidget);
        expect(find.text('Cerrar'), findsOneWidget);

        await tester.tap(find.text('Cerrar'));
        await tester.pumpAndSettle();
      },
    );
  });
}
