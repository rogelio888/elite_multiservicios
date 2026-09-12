import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/recovery/force_password_change_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  bool passwordChangedCalled = false;

  setUp(() {
    mockAuthService = MockAuthService();
    passwordChangedCalled = false;
  });

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: ForcePasswordChangeScreen(
        authService: mockAuthService,
        onPasswordChanged: () {
          passwordChangedCalled = true;
        },
      ),
    );
  }

  group('ForcePasswordChangeScreen Widget Tests', () {
    testWidgets(
      'renders title, 3 password fields, submit button and compliance footnote',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestWidget());

        expect(
          find.text('Cambio de Contraseña Obligatorio'),
          findsOneWidget,
        );
        expect(
          find.text(
            'Por seguridad, debés cambiar tu contraseña temporal antes de continuar.',
          ),
          findsOneWidget,
        );
        expect(find.text('CONTRASEÑA ACTUAL'), findsOneWidget);
        expect(find.text('NUEVA CONTRASEÑA'), findsOneWidget);
        expect(find.text('CONFIRMAR NUEVA CONTRASEÑA'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.text('Actualizar y continuar'), findsOneWidget);
        expect(
          find.text(
            'Este cambio es obligatorio. La contraseña debe tener al menos 8 caracteres.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('evaluates password strength dynamically', (tester) async {
      tester.view.physicalSize = const Size(1920, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());

      final newPasswordField = find.byType(TextFormField).at(1);

      await tester.enterText(newPasswordField, 'weak');
      await tester.pump();
      expect(find.text('Seguridad: Débil'), findsOneWidget);

      await tester.enterText(newPasswordField, 'med12345');
      await tester.pump();
      expect(find.text('Seguridad: Media'), findsOneWidget);

      await tester.enterText(newPasswordField, 'StrongPass1!');
      await tester.pump();
      expect(find.text('Seguridad: Fuerte'), findsOneWidget);
    });

    testWidgets(
      'validates required fields and mismatched passwords',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildTestWidget());

        // Submit vacío
        await tester.tap(find.text('Actualizar y continuar'));
        await tester.pump();

        expect(find.text('Ingresá tu contraseña actual'), findsOneWidget);
        expect(find.text('Ingresá la nueva contraseña'), findsOneWidget);
        expect(find.text('Confirmá la nueva contraseña'), findsOneWidget);

        // Mismatch
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'OldPassword1!',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'NewPassword1!',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'DifferentPassword2!',
        );

        await tester.tap(find.text('Actualizar y continuar'));
        await tester.pump();

        expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
      },
    );

    testWidgets(
      'submits successfully and triggers onPasswordChanged callback',
      (tester) async {
        tester.view.physicalSize = const Size(1920, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        when(
          () => mockAuthService.changePassword(
            currentPassword: 'OldPassword1!',
            newPassword: 'NewPassword1!',
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(buildTestWidget());

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'OldPassword1!',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'NewPassword1!',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'NewPassword1!',
        );

        await tester.tap(find.text('Actualizar y continuar'));
        await tester.pump();

        expect(passwordChangedCalled, isTrue);
      },
    );

    testWidgets('shows error banner when changePassword fails', (tester) async {
      tester.view.physicalSize = const Size(1920, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(
        () => mockAuthService.changePassword(
          currentPassword: 'WrongOldPassword',
          newPassword: 'NewPassword1!',
        ),
      ).thenThrow(Exception('La contraseña actual es incorrecta'));

      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'WrongOldPassword',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'NewPassword1!',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'NewPassword1!',
      );

      await tester.tap(find.text('Actualizar y continuar'));
      await tester.pump();

      expect(find.text('La contraseña actual es incorrecta.'), findsOneWidget);
    });
  });
}
