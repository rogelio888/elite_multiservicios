import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/reset_password_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/verify_code_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  final testRequestId = UuidValue.fromString(
    '00000000-0000-0000-0000-000000000001',
  );

  setUpAll(() {
    registerFallbackValue(
      UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    );
  });

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: VerifyCodeScreen(
        authService: mockAuthService,
        passwordResetRequestId: testRequestId,
        email: 'admin@elitemultiservicios.com',
      ),
    );
  }

  group('VerifyCodeScreen Widget Tests', () {
    testWidgets('renders title, 8 input fields and countdown resend text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Verificar Código'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(8));
      expect(find.textContaining('Reenviar en 60s'), findsOneWidget);
      expect(find.text('Verificar código'), findsOneWidget);
      expect(find.text('Volver al inicio de sesión'), findsOneWidget);
    });

    testWidgets('shows validation message on incomplete code submission', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final button = find.text('Verificar código');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Ingresá los 8 dígitos del código'), findsOneWidget);
    });

    testWidgets('decrements resend countdown when time advances', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      expect(find.textContaining('Reenviar en 60s'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Reenviar en 59s'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      expect(find.textContaining('Reenviar en 55s'), findsOneWidget);
    });

    testWidgets(
      'displays error message when code verification fails with expired',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        when(
          () => mockAuthService.verifyPasswordResetCode(
            passwordResetRequestId: any(named: 'passwordResetRequestId'),
            verificationCode: any(named: 'verificationCode'),
          ),
        ).thenThrow(Exception('Code has expired'));

        await tester.pumpWidget(buildTestWidget());

        final inputs = find.byType(TextFormField);
        for (int i = 0; i < 8; i++) {
          await tester.enterText(inputs.at(i), '$i');
        }

        final button = find.text('Verificar código');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(
          find.text('El código expiró. Solicitá uno nuevo.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'navigates to ResetPasswordScreen on successful code verification',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        when(
          () => mockAuthService.verifyPasswordResetCode(
            passwordResetRequestId: any(named: 'passwordResetRequestId'),
            verificationCode: any(named: 'verificationCode'),
          ),
        ).thenAnswer((_) async => 'fake-finish-token');

        await tester.pumpWidget(buildTestWidget());

        final inputs = find.byType(TextFormField);
        for (int i = 0; i < 8; i++) {
          await tester.enterText(inputs.at(i), '$i');
        }

        final button = find.byType(FilledButton);
        await tester.tap(button, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.byType(ResetPasswordScreen), findsOneWidget);
      },
    );
  });
}
