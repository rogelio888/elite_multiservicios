import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/mfa_verification_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget buildTestWidget({
    String challengeId = 'test-challenge-123',
    String emailHint = 'a***n@elitemultiservicios.com',
    bool rememberMe = false,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: MfaVerificationScreen(
        authService: mockAuthService,
        challengeId: challengeId,
        emailHint: emailHint,
        rememberMe: rememberMe,
      ),
    );
  }

  group('MfaVerificationScreen Widget Tests', () {
    testWidgets('renders title, 6 input fields and countdown resend text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Verificación de Dos Pasos'), findsOneWidget);
      expect(
        find.textContaining(
          'a***n@elitemultiservicios.com',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNWidgets(6));
      expect(find.textContaining('Reenviar en 60s'), findsOneWidget);
      expect(find.textContaining('Verificar e ingresar'), findsOneWidget);
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

      final button = find.textContaining('Verificar e ingresar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Ingresá los 6 dígitos del código'), findsOneWidget);
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

    testWidgets('displays error message when verification fails', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(
        () => mockAuthService.verifyMfa(
          challengeId: any(named: 'challengeId'),
          code: any(named: 'code'),
          rememberMe: any(named: 'rememberMe'),
        ),
      ).thenThrow(Exception('MFA_CODE_EXPIRED'));

      await tester.pumpWidget(buildTestWidget());

      final inputs = find.byType(TextFormField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(inputs.at(i), '$i');
      }
      await tester.pumpAndSettle();

      expect(
        find.text('El código expiró. Solicitá uno nuevo.'),
        findsOneWidget,
      );
    });

    testWidgets('pops with true on successful verification', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(
        () => mockAuthService.verifyMfa(
          challengeId: any(named: 'challengeId'),
          code: any(named: 'code'),
          rememberMe: any(named: 'rememberMe'),
        ),
      ).thenAnswer(
        (_) async => MfaVerifyResponse(
          success: true,
        ),
      );

      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => MfaVerificationScreen(
                      authService: mockAuthService,
                      challengeId: 'test-challenge-123',
                      emailHint: 'a***n@elitemultiservicios.com',
                      rememberMe: false,
                    ),
                  ),
                );
              },
              child: const Text('Open MFA'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open MFA'));
      await tester.pumpAndSettle();

      expect(find.text('Verificación de Dos Pasos'), findsOneWidget);

      final inputs = find.byType(TextFormField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(inputs.at(i), '$i');
      }
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });
  });
}
