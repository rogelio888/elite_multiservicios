import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/views/active_sessions_view.dart';
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
        body: ActiveSessionsView(service: mockService),
      ),
    );
  }

  group('ActiveSessionsView Tests', () {
    testWidgets(
      'renders active sessions with KPIs, user cards and device icons',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1080);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final sampleUsers = [
          AppUser(
            id: 1,
            email: 'admin@elitemultiservicios.com',
            fullName: 'Super Administrador Principal',
            isActive: true,
            isDeleted: false,
            createdAt: DateTime.utc(2026, 1, 1),
            updatedAt: DateTime.utc(2026, 1, 1),
          ),
          AppUser(
            id: 2,
            email: 'carlos.mendoza@elitemultiservicios.com',
            fullName: 'Carlos Mendoza',
            isActive: true,
            isDeleted: false,
            createdAt: DateTime.utc(2026, 1, 2),
            updatedAt: DateTime.utc(2026, 1, 2),
          ),
        ];

        final sampleSessionsUser1 = [
          UserSession(
            id: 101,
            userId: 1,
            sessionTokenHash: 'mock_session_hash_1', // gitleaks:allow
            ipAddress: '::1',
            deviceInfo:
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/128.0.0.0 Safari/537.36',
            isRevoked: false,
            mfaVerified: true,
            createdAt: DateTime.utc(2026, 9, 13, 10, 0),
            lastActivityAt: DateTime.utc(2026, 9, 13, 14, 0),
            expiresAt: DateTime.utc(2026, 9, 20, 10, 0),
          ),
        ];

        final sampleSessionsUser2 = [
          UserSession(
            id: 102,
            userId: 2,
            sessionTokenHash: 'mock_session_hash_2', // gitleaks:allow
            ipAddress: '192.168.1.150',
            deviceInfo:
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15',
            isRevoked: false,
            mfaVerified: false,
            createdAt: DateTime.utc(2026, 9, 13, 11, 0),
            lastActivityAt: DateTime.utc(2026, 9, 13, 13, 0),
            expiresAt: DateTime.utc(2026, 9, 20, 11, 0),
          ),
        ];

        when(
          () => mockService.listUsers(),
        ).thenAnswer((_) async => sampleUsers);
        when(
          () => mockService.listUserSessions(1),
        ).thenAnswer((_) async => sampleSessionsUser1);
        when(
          () => mockService.listUserSessions(2),
        ).thenAnswer((_) async => sampleSessionsUser2);

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // 1. Verificar Header & KPIs
        expect(find.text('Monitoreo de Sesiones Activas'), findsOneWidget);
        expect(find.text('CONTROL DE CONCURRENCIA & SESIONES'), findsOneWidget);
        expect(find.text('Sesiones Activas'), findsOneWidget);
        expect(find.text('Protección 2FA / MFA'), findsOneWidget);
        expect(find.text('IPs / Nodos Únicos'), findsOneWidget);

        // 2. Verificar sanitización de IP (::1 a Localhost)
        expect(
          find.textContaining('127.0.0.1 (Localhost / Servidor)'),
          findsOneWidget,
        );
        expect(find.textContaining('192.168.1.150'), findsOneWidget);

        // 3. Verificar parsing de dispositivo
        expect(find.text('Google Chrome en Windows 11 / PC'), findsOneWidget);
        expect(find.text('Apple Safari en macOS / Apple'), findsOneWidget);

        // 4. Verificar badges MFA
        expect(find.text('2FA Verificado'), findsOneWidget);
        expect(find.text('Sin MFA'), findsOneWidget);

        // 5. Verificar usuarios
        expect(find.text('Super Administrador Principal'), findsOneWidget);
        expect(find.text('Carlos Mendoza'), findsOneWidget);

        // 6. Abrir modal de ficha técnica
        final fichaButtons = find.widgetWithText(OutlinedButton, 'Ficha');
        expect(fichaButtons, findsNWidgets(2));
        await tester.tap(fichaButtons.first);
        await tester.pumpAndSettle();

        expect(find.text('Ficha Técnica de Sesión #101'), findsOneWidget);
        expect(find.text('Identidad del Usuario Autenticado'), findsOneWidget);
        expect(find.text('Cerrar'), findsOneWidget);

        // Cerrar modal
        await tester.tap(find.text('Cerrar'));
        await tester.pumpAndSettle();
      },
    );
  });
}
