import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_payroll_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_payroll_kpis.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_payroll_period_selector.dart';

void main() {
  late RrhhRepositoryMock repo;

  setUp(() {
    repo = RrhhRepositoryMock();
  });

  Widget buildTestWidget({RrhhRepositoryMock? customRepo}) {
    return MaterialApp(
      home: Scaffold(
        body: RrhhPayrollView(
          repository: customRepo ?? repo,
        ),
      ),
    );
  }

  group('RrhhPayrollView (Pantalla 12 — Novedades para Nómina) Widget Tests', () {
    testWidgets('renders view with compact header, selector, 4 KPI cards, tabs and consolidated table',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Novedades para Nómina'), findsOneWidget);
      expect(find.text('Nuevo Período'), findsOneWidget);

      // Selector de Período
      expect(find.byType(RrhhPayrollPeriodSelector), findsOneWidget);
      expect(find.text('Período Mensual:'), findsOneWidget);

      // Panel de KPIs
      expect(find.byType(RrhhPayrollKpis), findsOneWidget);
      expect(find.text('Empleados con novedades'), findsOneWidget);
      expect(find.text('Total descuentos'), findsOneWidget);
      expect(find.text('Total pagos extra'), findsOneWidget);
      expect(find.text('Estado del período'), findsOneWidget);

      // Tabs internas
      expect(find.textContaining('1. Todos'), findsOneWidget);
      expect(find.textContaining('2. Permisos'), findsOneWidget);
      expect(find.textContaining('3. Vacaciones'), findsOneWidget);
      expect(find.textContaining('4. Incidencias'), findsOneWidget);
      expect(find.textContaining('5. Desvinculaciones'), findsOneWidget);

      // Columnas de la tabla consolidada
      expect(find.text('EMPLEADO'), findsOneWidget);
      expect(find.text('TIPO DE NOVEDAD'), findsOneWidget);
      expect(find.text('CÓDIGO ORIGEN'), findsOneWidget);
      expect(find.text('FECHA EFECTIVA'), findsOneWidget);
      expect(find.text('DESCRIPCIÓN'), findsOneWidget);
      expect(find.text('IMPACTO NÓMINA'), findsOneWidget);

      // Botones de exportación y footer
      expect(find.text('Exportar a Excel (.xlsx)'), findsOneWidget);
      expect(find.text('Exportar a CSV'), findsOneWidget);
      expect(find.text('Ver Histórico'), findsOneWidget);
    });

    testWidgets('tapping [Exportar a Excel] and [Exportar a CSV] shows snackbars', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Exportar a Excel
      final exportExcelBtn = find.text('Exportar a Excel (.xlsx)');
      expect(exportExcelBtn, findsOneWidget);
      await tester.tap(exportExcelBtn);
      await tester.pump();
      expect(find.textContaining('exportado exitosamente'), findsOneWidget);

      // Descartar snackbar previo
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).hideCurrentSnackBar();
      await tester.pumpAndSettle();

      // Exportar a CSV
      final exportCsvBtn = find.text('Exportar a CSV');
      expect(exportCsvBtn, findsOneWidget);
      await tester.tap(exportCsvBtn);
      await tester.pump();
      expect(find.textContaining('exportado exitosamente'), findsOneWidget);
    });

    testWidgets('tapping [Nuevo Período] opens RrhhNewPayrollPeriodDialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final newPeriodBtn = find.text('Nuevo Período');
      expect(newPeriodBtn, findsOneWidget);

      await tester.tap(newPeriodBtn);
      await tester.pumpAndSettle();

      // Modal abierto
      expect(find.text('Mes a Liquidar *'), findsOneWidget);
      expect(find.text('Año Fiscal *'), findsOneWidget);
      expect(find.text('Crear Período'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);

      // Cerrar modal
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('Mes a Liquidar *'), findsNothing);
    });

    testWidgets('tapping [Ver Histórico] opens history modal', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final historyBtn = find.text('Ver Histórico');
      expect(historyBtn, findsOneWidget);

      await tester.tap(historyBtn);
      await tester.pumpAndSettle();

      expect(find.text('Historial de Períodos de Nómina'), findsOneWidget);
      expect(find.text('Cerrar'), findsOneWidget);

      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.text('Historial de Períodos de Nómina'), findsNothing);
    });
  });
}
