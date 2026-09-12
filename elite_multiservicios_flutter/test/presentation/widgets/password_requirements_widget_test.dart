import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';
import 'package:elite_multiservicios_flutter/features/security/presentation/widgets/password_requirements_widget.dart';

void main() {
  Widget buildTestWidget({
    required String password,
    String? email,
    String? fullName,
    bool isCompact = false,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: PasswordRequirementsWidget(
          password: password,
          email: email,
          fullName: fullName,
          isCompact: isCompact,
        ),
      ),
    );
  }

  group('PasswordRequirementsWidget Tests', () {
    testWidgets('renders all 6 criteria and shows 0/6 for empty password', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(password: ''));

      expect(find.text('Requisitos de Seguridad'), findsOneWidget);
      expect(find.text('Verificación en tiempo real (0/6)'), findsOneWidget);
      expect(find.text('Débil'), findsOneWidget);

      expect(find.text('Mínimo 10 caracteres'), findsOneWidget);
      expect(find.text('Al menos una letra mayúscula (A-Z)'), findsOneWidget);
      expect(find.text('Al menos una letra minúscula (a-z)'), findsOneWidget);
      expect(find.text('Al menos un número (0-9)'), findsOneWidget);
      expect(
        find.text('Al menos un carácter especial (!@#\$%...)'),
        findsOneWidget,
      );
      expect(
        find.text('No es una contraseña común ni predecible'),
        findsOneWidget,
      );
    });

    testWidgets('detects partial criteria and reflects in met count', (
      tester,
    ) async {
      // 8 caracteres, mayúscula y minúscula, sin número ni símbolo
      await tester.pumpWidget(buildTestWidget(password: 'Abcdefgh'));

      // 2 criterios cumplidos: mayúscula y minúscula. (longitud < 10, sin número, sin símbolo)
      expect(
        find.text('Verificación en tiempo real (3/6)'),
        findsOneWidget,
      ); // mayúscula, minúscula, not common
      expect(find.text('Mínimo 10 caracteres'), findsOneWidget);
    });

    testWidgets('detects robust password and shows 6/6 and Óptima', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          password: 'PasswordSuperSegura2026!',
          email: 'admin@elitemultiservicios.com',
          fullName: 'Administrador General',
        ),
      );

      expect(find.text('Verificación en tiempo real (6/6)'), findsOneWidget);
      expect(find.text('Óptima'), findsOneWidget);
    });

    testWidgets('flags common password as not meeting rule 6', (tester) async {
      await tester.pumpWidget(buildTestWidget(password: 'password'));
      // 'password' solo cumple minúscula (1/6) - longitud < 10, sin mayúscula, sin número, sin símbolo, es común
      expect(find.text('Verificación en tiempo real (1/6)'), findsOneWidget);
    });
  });
}
