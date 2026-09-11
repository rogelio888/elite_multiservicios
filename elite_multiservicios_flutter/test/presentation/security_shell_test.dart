import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/security_shell_screen.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/widgets/status_badge.dart';

void main() {
  group('Security Presentation & UI Widgets Tests', () {
    testWidgets('StatusBadge renders correctly with distinct variants', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: StatusBadge(
              label: 'Activo',
              variant: BadgeVariant.success,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.text('Activo'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets(
      'SecurityShellScreen renders sidebar and navigates across tabs',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SecurityShellScreen(),
          ),
        );

        expect(find.text('ELITE MULTISERVICIOS'), findsOneWidget);
        expect(find.text('Módulo de Seguridad'), findsOneWidget);
        expect(find.text('Dashboard General'), findsOneWidget);

        // Probar tap en navegación a "Usuarios"
        await tester.tap(find.text('Usuarios'));
        await tester.pumpAndSettle();

        expect(find.text('Gestión de Usuarios'), findsWidgets);

        // Probar tap en navegación a "Auditoría"
        await tester.tap(find.text('Auditoría'));
        await tester.pumpAndSettle();

        expect(find.text('Bitácora de Auditoría'), findsWidgets);
      },
    );
  });
}
