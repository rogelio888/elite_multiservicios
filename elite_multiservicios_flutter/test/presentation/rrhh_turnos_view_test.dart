import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_turnos_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_turnos_tab_shifts.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_turnos_tab_schedules.dart';

void main() {
  Widget buildTestWidget({String? initialTab}) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SizedBox(
          width: 1280,
          height: 800,
          child: RrhhTurnosView(initialTab: initialTab),
        ),
      ),
    );
  }

  group('RrhhTurnosView (Pantalla 07) Tests', () {
    testWidgets('renders view with header and Tab 1 Turnos by default', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verificar encabezado ejecutivo
      expect(find.text('Turnos y Horarios Base'), findsOneWidget);
      expect(find.text('Catálogo de turnos de trabajo y horarios plantilla'), findsOneWidget);

      // Verificar las 2 pestañas
      expect(find.text('1. Turnos'), findsOneWidget);
      expect(find.text('2. Horarios Base'), findsOneWidget);

      // Verificar que Tab 1 Turnos está visible
      expect(find.byType(RrhhTurnosTabShifts), findsOneWidget);
      expect(find.text('Nuevo Turno'), findsOneWidget);

      // Verificar columnas y datos de turnos
      expect(find.text('CÓDIGO'), findsOneWidget);
      expect(find.text('NOMBRE DEL TURNO'), findsOneWidget);
      expect(find.text('TURNO-001'), findsOneWidget);
      expect(find.text('Turno Mañana'), findsOneWidget);
    });

    testWidgets('switches to Tab 2 Horarios Base and displays schedules list', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Clic en la pestaña 2 "Horarios Base"
      await tester.tap(find.text('2. Horarios Base'));
      await tester.pumpAndSettle();

      // Verificar que Tab 2 Horarios Base está visible
      expect(find.byType(RrhhTurnosTabSchedules), findsOneWidget);
      expect(find.text('Nuevo Horario'), findsOneWidget);

      // Verificar columnas de horarios base
      expect(find.text('TURNOS INCLUIDOS'), findsOneWidget);
      expect(find.text('HORAS SEM.'), findsOneWidget);
      expect(find.text('HORARIO-001'), findsOneWidget);
      expect(find.text('Horario Administrativo Central'), findsOneWidget);
    });
  });
}
