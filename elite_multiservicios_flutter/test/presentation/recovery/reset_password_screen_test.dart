import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/reset_password_screen.dart';
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
      home: ResetPasswordScreen(
        authService: mockAuthService,
        finishPasswordResetToken: 'dummy-token-12345',
      ),
    );
  }

  group('ResetPasswordScreen Widget Tests', () {
    testWidgets(
      'renders title, 2 password fields, submit button and back link',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Nueva Contraseña'), findsOneWidget);
        expect(
          find.text('Elegí una contraseña segura para tu cuenta'),
          findsOneWidget,
        );
        expect(find.text('NUEVA CONTRASEÑA'), findsOneWidget);
        expect(find.text('CONFIRMAR CONTRASEÑA'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Guardar contraseña'), findsOneWidget);
        expect(find.text('Cancelar y volver al login'), findsOneWidget);
      },
    );

    testWidgets('evaluates password strength dynamically', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final passwordField = find.byType(TextFormField).first;

      // 1. Password corta (< 8)
      await tester.enterText(passwordField, 'abc');
      await tester.pump();
      expect(find.text('Seguridad: Débil'), findsOneWidget);

      // 2. Password de 8+ pero sin mayúscula y número
      await tester.enterText(passwordField, 'abcdefgh');
      await tester.pump();
      expect(find.text('Seguridad: Media'), findsOneWidget);

      // 3. Password de 8+ con mayúscula y número
      await tester.enterText(passwordField, 'NuevaPassword123!');
      await tester.pump();
      expect(find.text('Seguridad: Fuerte'), findsOneWidget);
    });

    testWidgets('validates minimum length and matching passwords', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);
      final submitButton = find.text('Guardar contraseña');

      // Test < 8 caracteres
      await tester.enterText(fields.at(0), '1234');
      await tester.enterText(fields.at(1), '1234');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(
        find.text('La contraseña debe tener al menos 8 caracteres'),
        findsOneWidget,
      );

      // Test no coinciden
      await tester.enterText(fields.at(0), 'NuevaPassword123!');
      await tester.enterText(fields.at(1), 'DiferentePassword123!');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('calls finishPasswordReset and shows success dialog', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(
        () => mockAuthService.finishPasswordReset(
          finishPasswordResetToken: any(named: 'finishPasswordResetToken'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget());

      final fields = find.byType(TextFormField);
      final submitButton = find.text('Guardar contraseña');

      await tester.enterText(fields.at(0), 'NuevaPassword123!');
      await tester.enterText(fields.at(1), 'NuevaPassword123!');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(
        () => mockAuthService.finishPasswordReset(
          finishPasswordResetToken: 'dummy-token-12345',
          newPassword: 'NuevaPassword123!',
        ),
      ).called(1);

      // Dialog de éxito
      expect(find.text('Contraseña actualizada'), findsOneWidget);
      expect(
        find.text(
          'Ya podés iniciar sesión con tu nueva contraseña corporativa.',
        ),
        findsOneWidget,
      );
      expect(find.text('Volver al inicio de sesión'), findsOneWidget);
    });
  });
}
