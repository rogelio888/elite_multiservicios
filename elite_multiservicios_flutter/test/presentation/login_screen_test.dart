import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests (Stitch Specification)', () {
    testWidgets(
      'renders all expected form fields, labels and branding in desktop view',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        );

        // Validar textos de branding e interfaz
        expect(find.text('ELITE MULTISERVICIOS'), findsOneWidget);
        expect(find.text('Correo Corporativo'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);

        // Validar campos de formulario
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Iniciar Sesión'), findsNWidgets(2)); // Título y botón
      },
    );

    testWidgets('triggers client-side validations on empty submission', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Presionar el botón de inicio de sesión sin ingresar datos
      final loginButton = find.byType(FilledButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Debe mostrar mensajes de validación
      expect(
        find.text('El correo corporativo es obligatorio'),
        findsOneWidget,
      );
      expect(find.text('La contraseña es obligatoria'), findsOneWidget);
    });

    testWidgets('toggles password visibility when suffix icon is tapped', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      );

      // Icono inicial debe ser visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap para alternar a visible
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Icono debe cambiar a visibility_off_outlined
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
