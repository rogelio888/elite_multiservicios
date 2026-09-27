import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_disciplinary_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_disciplinary_record_row.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_disciplinary_edit_dialog.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_disciplinary_detail_drawer.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_primary_action_button.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: SizedBox(
          width: 1366,
          height: 850,
          child: RrhhDisciplinaryView(),
        ),
      ),
    );
  }

  group('RrhhDisciplinaryView (Pantalla 10 — Incidencias y Disciplina) Widget Tests', () {
    testWidgets('renders view with compact header, 4 KPI cards, filters, and disciplinary records table', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1366, 850));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 1. Header de sección y botón primario
      expect(find.text('Incidencias y Régimen Disciplinario'), findsOneWidget);
      expect(find.byType(RrhhPrimaryActionButton), findsOneWidget);
      expect(find.text('Nueva Incidencia'), findsOneWidget);

      // 2. Filtros y pills de estado
      expect(find.byType(TextField), findsOneWidget);
      expect(find.textContaining('Todos ('), findsOneWidget);
      expect(find.textContaining('Sancionadas ('), findsOneWidget);

      // 4. Columnas de tabla
      expect(find.text('CÓDIGO'), findsOneWidget);
      expect(find.text('EMPLEADO'), findsOneWidget);
      expect(find.text('FECHA HECHO'), findsOneWidget);
      expect(find.text('TIPO FALTA'), findsOneWidget);
      expect(find.text('SANCIÓN'), findsOneWidget);
      expect(find.text('ESTADO'), findsOneWidget);
      expect(find.text('SUSPENSIÓN'), findsOneWidget);
      expect(find.text('ACCIONES'), findsOneWidget);

      // 5. Filas pre-pobladas
      expect(find.byType(RrhhDisciplinaryRecordRow), findsWidgets);
      expect(find.text('INC-001'), findsOneWidget);
      expect(find.text('INC-002'), findsOneWidget);
    });

    testWidgets('tapping [+ Registrar Incidencia] opens RrhhDisciplinaryEditDialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1366, 850));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(RrhhPrimaryActionButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(RrhhDisciplinaryEditDialog), findsOneWidget);
      expect(find.text('BLOQUE A — DATOS DEL EMPLEADO'), findsOneWidget);
      expect(find.text('BLOQUE B — DETALLE DE LA INCIDENCIA'), findsOneWidget);
      expect(find.text('BLOQUE C — DEBIDO PROCESO Y DESCARGO'), findsOneWidget);
      expect(find.text('BLOQUE D — SANCIÓN PROPUESTA O ACCIÓN'), findsOneWidget);

      // Cerrar modal
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(RrhhDisciplinaryEditDialog), findsNothing);
    });

    testWidgets('tapping [Ver] in a row opens RrhhDisciplinaryDetailDrawer', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1366, 850));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Encontrar primer botón 'Ver'
      final verFinder = find.text('Ver').first;
      await tester.tap(verFinder);
      await tester.pumpAndSettle();

      expect(find.byType(RrhhDisciplinaryDetailDrawer), findsOneWidget);
      expect(find.text('1. DATOS DEL EMPLEADO'), findsOneWidget);
      expect(find.text('2. DATOS DE LA INCIDENCIA'), findsOneWidget);
      expect(find.text('4. SANCIÓN Y RESOLUCIÓN'), findsOneWidget);
      expect(find.text('6. HISTORIAL DEL PROCESO'), findsOneWidget);

      // Cerrar drawer
      await tester.tap(find.byTooltip('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.byType(RrhhDisciplinaryDetailDrawer), findsNothing);
    });
  });
}
