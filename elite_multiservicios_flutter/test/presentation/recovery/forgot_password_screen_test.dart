import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/forgot_password_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/verify_code_screen.dart';
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

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: ForgotPasswordScreen(
        authService: mockAuthService,
      ),
    );
  }

  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('renders title, email field, submit button and back link', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Recuperar Contraseña'), findsOneWidget);
      expect(
        find.text(
          'Te enviaremos un código de verificación a tu correo corporativo',
        ),
        findsOneWidget,
      );
      expect(find.text('Correo corporativo'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Enviar código de recuperación'), findsOneWidget);
      expect(find.text('Volver al inicio de sesión'), findsOneWidget);
    });

    testWidgets('validates required email field on submit', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final button = find.text('Enviar código de recuperación');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('El correo corporativo es obligatorio'),
        findsOneWidget,
      );
    });

    testWidgets('validates invalid email format', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final field = find.byType(TextFormField);
      await tester.enterText(field, 'correo-invalido');

      final button = find.text('Enviar código de recuperación');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text('Formato de correo electrónico inválido'),
        findsOneWidget,
      );
    });

    testWidgets('displays error banner when startPasswordReset fails', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(
        () => mockAuthService.startPasswordReset(any()),
      ).thenThrow(Exception('Backend network failure'));

      await tester.pumpWidget(buildTestWidget());

      final field = find.byType(TextFormField);
      await tester.enterText(field, 'admin@elitemultiservicios.com');

      final button = find.text('Enviar código de recuperación');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No pudimos enviar el código. Verificá el correo o intentá de nuevo.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'navigates to VerifyCodeScreen when startPasswordReset succeeds',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final dummyId = UuidValue.fromString(
          '00000000-0000-0000-0000-000000000001',
        );
        when(
          () => mockAuthService.startPasswordReset(any()),
        ).thenAnswer((_) async => dummyId);

        await tester.pumpWidget(buildTestWidget());

        final field = find.byType(TextFormField);
        await tester.enterText(field, 'admin@elitemultiservicios.com');

        final button = find.text('Enviar código de recuperación');
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.byType(VerifyCodeScreen), findsOneWidget);
      },
    );
  });
}
