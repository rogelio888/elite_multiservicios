import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_vacations_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_vacation_balance_tab.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_vacation_records_tab.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_vacation_edit_dialog.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_primary_action_button.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: SizedBox(
          width: 1366,
          height: 850,
          child: RrhhVacationsView(),
        ),
      ),
    );
  }

  group(
    'RrhhVacationsView (Pantalla 09 — Control de Vacaciones) Widget Tests',
    () {
      testWidgets(
        'renders view with header, 4 KPI cards, and Tab 1 Saldo por empleado by default',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          // Botón de acción primario con un solo '+' y label correcto
          expect(find.byType(RrhhPrimaryActionButton), findsOneWidget);
          expect(find.text('Registrar Vacaciones'), findsOneWidget);

          // 2. Panel de Resumen (4 Cards)
          expect(find.text('Empleados con saldo disponible'), findsOneWidget);
          expect(find.text('Días pendientes totales'), findsOneWidget);
          expect(find.text('Próximos vencimientos'), findsOneWidget);
          expect(find.text('Vacaciones vencidas sin usar'), findsOneWidget);

          // 3. Pestañas internas
          expect(find.textContaining('Saldo por empleado'), findsOneWidget);
          expect(find.textContaining('Historial de goces'), findsOneWidget);

          // 4. Tab 1 visible por defecto
          expect(find.byType(RrhhVacationBalanceTab), findsOneWidget);
          expect(find.text('COLABORADOR'), findsOneWidget);
          expect(find.text('ANTIGÜEDAD'), findsOneWidget);
          expect(find.text('ASIGNADOS'), findsOneWidget);
          expect(find.text('GOZADOS'), findsOneWidget);
          expect(find.text('PENDIENTES'), findsOneWidget);

          // Verificamos presencia de colaboradores con distintas antigüedades
          expect(find.text('Juan Carlos Pérez Mendoza'), findsOneWidget);
          expect(find.text('María Elena Gómez'), findsOneWidget);
          expect(find.text('Carlos E. Mamani Choque'), findsOneWidget);
        },
      );

      testWidgets(
        'switches to Tab 2 Historial de goces and displays vacation records',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          // Clic en pestaña "Historial de goces"
          await tester.tap(find.textContaining('Historial de goces'));
          await tester.pumpAndSettle();

          // Tab 2 activa
          expect(find.byType(RrhhVacationRecordsTab), findsOneWidget);
          expect(find.text('CÓDIGO'), findsOneWidget);
          expect(find.text('PERÍODO'), findsOneWidget);
          expect(find.text('MODO CÓMPUTO'), findsOneWidget);

          // Registros pre-poblados visibles
          expect(find.text('VAC-001'), findsOneWidget);
          expect(find.text('VAC-002'), findsOneWidget);
        },
      );

      testWidgets(
        'clicking Registrar Vacaciones opens modal dialog with form',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          // Clic en botón primario
          await tester.tap(find.text('Registrar Vacaciones'));
          await tester.pumpAndSettle();

          // Modal abierto
          expect(find.byType(RrhhVacationEditDialog), findsOneWidget);
          expect(find.text('Programar Vacaciones'), findsOneWidget);
          expect(find.text('Empleado *'), findsOneWidget);
          expect(find.text('Fecha Desde *'), findsOneWidget);
          expect(find.text('Fecha Hasta *'), findsOneWidget);
          expect(
            find.text('Días Hábiles (Lunes a Viernes - Ley)'),
            findsOneWidget,
          );

          // Cerrar modal
          await tester.tap(find.text('Cancelar'));
          await tester.pumpAndSettle();

          expect(find.byType(RrhhVacationEditDialog), findsNothing);
        },
      );
    },
  );
}
