import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/views/server_metrics_view.dart';
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
        body: ServerMetricsView(service: mockService),
      ),
    );
  }

  group('ServerMetricsView Tests', () {
    testWidgets('renders KPI cards and server runtime info', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final sampleMetrics = ServerMetricsResponse(
        uptimeSeconds: 86400, // 1 día
        memoryRssBytes: 150 * 1024 * 1024, // 150 MB
        databaseLatencyMs: 8,
        activeSessionsCount: 7,
        failedLoginsLast24h: 1,
        serverTimestamp: DateTime.utc(2026, 9, 12, 14, 0),
        serverVersion: '3.4.13',
      );

      when(
        () => mockService.getServerMetrics(),
      ).thenAnswer((_) async => sampleMetrics);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verificar títulos
      expect(find.text('Telemetría y Estado del Servidor'), findsOneWidget);
      expect(find.text('SISTEMA ONLINE'), findsOneWidget);

      // Verificar las 5 tarjetas KPI
      expect(find.text('Tiempo de Actividad'), findsOneWidget);
      expect(find.text('1d 0h 0m'), findsOneWidget);

      expect(find.text('Memoria RSS en Uso'), findsOneWidget);
      expect(find.text('150.0 MB'), findsOneWidget);

      expect(find.text('Latencia PostgreSQL'), findsOneWidget);
      expect(find.text('8 ms'), findsOneWidget);

      expect(find.text('Sesiones Activas'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);

      expect(find.text('Logins Fallidos (24h)'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      // Verificar panel de runtime
      expect(find.text('Información del Servidor & Runtime'), findsOneWidget);
      expect(find.text('Serverpod Version'), findsOneWidget);
      expect(find.text('Dart SDK'), findsOneWidget);
      expect(find.text('Endpoint Health'), findsOneWidget);
    });

    testWidgets('shows error banner when backend is unreachable', (
      tester,
    ) async {
      when(
        () => mockService.getServerMetrics(),
      ).thenThrow(Exception('Connection refused'));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('No se pudo conectar con el endpoint'),
        findsOneWidget,
      );
      expect(find.text('ERROR CONEXIÓN'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}
