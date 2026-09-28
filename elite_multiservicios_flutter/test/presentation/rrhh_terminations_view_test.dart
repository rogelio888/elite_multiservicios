import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_remote.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_terminations_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_termination_record_row.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_termination_edit_dialog.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_termination_detail_drawer.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_primary_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTerminationsRepository extends RrhhRepositoryRemote {
  final _records = [
    RrhhTerminationRecord(
      id: 1,
      code: 'BAJA-001',
      employeeId: 18,
      employeeCode: 'EMP-018',
      employeeName: 'Fernando Roca',
      terminationType: 'renuncia_voluntaria',
      terminationDate: DateTime(2026, 9, 10),
      lastWorkDay: DateTime(2026, 9, 10),
      reason:
          'Renuncia voluntaria por motivos estrictamente personales y cambio de residencia',
      status: 'finalizada',
      paymentCompleted: true,
      createdAt: DateTime(2026, 9, 10),
      updatedAt: DateTime(2026, 9, 10),
      createdBy: 'RRHH',
    ),
    RrhhTerminationRecord(
      id: 2,
      code: 'BAJA-002',
      employeeId: 14,
      employeeCode: 'EMP-014',
      employeeName: 'Marcos Aguilera Soto',
      terminationType: 'despido_justificado',
      terminationDate: DateTime(2026, 9, 25),
      lastWorkDay: DateTime(2026, 9, 24),
      reason:
          'Despido justificado bajo el Artículo 16 de la LGT por falta muy grave',
      status: 'registrada',
      paymentCompleted: false,
      createdAt: DateTime(2026, 9, 25),
      updatedAt: DateTime(2026, 9, 25),
      createdBy: 'RRHH',
    ),
    RrhhTerminationRecord(
      id: 3,
      code: 'BAJA-003',
      employeeId: 21,
      employeeCode: 'EMP-021',
      employeeName: 'Carlos Gutiérrez',
      terminationType: 'fin_de_contrato',
      terminationDate: DateTime(2026, 9, 30),
      lastWorkDay: DateTime(2026, 9, 30),
      reason:
          'Vencimiento natural de contrato a plazo fijo sin renovación acordada',
      status: 'en_proceso',
      paymentCompleted: false,
      createdAt: DateTime(2026, 9, 20),
      updatedAt: DateTime(2026, 9, 20),
      createdBy: 'RRHH',
    ),
    RrhhTerminationRecord(
      id: 4,
      code: 'BAJA-004',
      employeeId: 25,
      employeeCode: 'EMP-025',
      employeeName: 'Lucía Méndez',
      terminationType: 'abandono_de_trabajo',
      terminationDate: DateTime(2026, 9, 18),
      lastWorkDay: DateTime(2026, 9, 12),
      reason:
          'Inasistencia continuada e injustificada durante más de seis días hábiles',
      status: 'finalizada',
      paymentCompleted: true,
      createdAt: DateTime(2026, 9, 18),
      updatedAt: DateTime(2026, 9, 18),
      createdBy: 'RRHH',
    ),
  ];

  @override
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return _records;
  }

  @override
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id) async {
    return _records.firstWhere((r) => r.id == id, orElse: () => _records.first);
  }
}

void main() {
  late RrhhRepository originalRepo;

  setUp(() {
    originalRepo = RrhhRepository.current;
    RrhhRepository.current = _FakeTerminationsRepository();
  });

  tearDown(() {
    RrhhRepository.current = originalRepo;
  });

  Widget buildTestWidget() {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: SizedBox(
          width: 1366,
          height: 850,
          child: RrhhTerminationsView(),
        ),
      ),
    );
  }

  group(
    'RrhhTerminationsView (Pantalla 11 — Desvinculaciones y Bajas) Widget Tests',
    () {
      testWidgets(
        'renders view with compact header, 4 KPI cards, filters, and terminations table',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          // 1. Header de sección y botón primario
          expect(find.text('Desvinculaciones'), findsOneWidget);
          expect(find.byType(RrhhPrimaryActionButton), findsOneWidget);
          expect(find.text('Registrar Desvinculación'), findsOneWidget);

          // 2. 4 KPIs
          expect(find.text('Bajas del mes'), findsOneWidget);
          expect(find.text('Pendientes de pago'), findsOneWidget);
          expect(find.text('Renuncias vs Despidos'), findsOneWidget);
          expect(find.text('Finiquitos vencidos'), findsOneWidget);

          // 3. Filtros y pills de estado
          expect(find.byType(TextField), findsOneWidget);
          expect(find.textContaining('Todos ('), findsOneWidget);
          expect(find.textContaining('Finalizadas ('), findsOneWidget);

          // 4. Columnas de tabla
          expect(find.text('CÓDIGO'), findsOneWidget);
          expect(find.text('EMPLEADO'), findsOneWidget);
          expect(find.text('TIPO DESVINCULACIÓN'), findsOneWidget);
          expect(find.text('FECHA EFECTIVA'), findsOneWidget);
          expect(find.text('ÚLTIMO DÍA'), findsOneWidget);
          expect(find.text('PAGO FINIQUITO'), findsOneWidget);
          expect(find.text('ESTADO'), findsOneWidget);
          expect(find.text('ACCIONES'), findsOneWidget);

          // 5. Filas pre-pobladas
          expect(find.byType(RrhhTerminationRecordRow), findsWidgets);
          expect(find.text('BAJA-001'), findsOneWidget);
          expect(find.text('BAJA-002'), findsOneWidget);
          expect(find.text('BAJA-003'), findsOneWidget);
          expect(find.text('BAJA-004'), findsOneWidget);
        },
      );

      testWidgets(
        'tapping [Registrar Desvinculación] opens RrhhTerminationEditDialog',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          final buttonFinder = find.byType(RrhhPrimaryActionButton);
          expect(buttonFinder, findsOneWidget);

          await tester.tap(buttonFinder);
          await tester.pumpAndSettle();

          expect(find.byType(RrhhTerminationEditDialog), findsOneWidget);
          expect(find.text('BLOQUE A — DATOS DEL EMPLEADO'), findsOneWidget);
          expect(
            find.text('BLOQUE B — TIPO Y CAUSAL DE DESVINCULACIÓN'),
            findsOneWidget,
          );
          expect(
            find.text('BLOQUE C — FECHAS Y PLAZO LEGAL DE PAGO (15 DÍAS)'),
            findsOneWidget,
          );
          expect(
            find.text('BLOQUE D — DOCUMENTOS Y OBLIGACIONES PENDIENTES'),
            findsOneWidget,
          );

          // Cerrar modal
          await tester.tap(find.text('Cancelar'));
          await tester.pumpAndSettle();
          expect(find.byType(RrhhTerminationEditDialog), findsNothing);
        },
      );

      testWidgets('tapping [Ver] in a row opens RrhhTerminationDetailDrawer', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1366, 850));
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Encontrar primer botón 'Ver'
        final verFinder = find.text('Ver').first;
        await tester.tap(verFinder);
        await tester.pumpAndSettle();

        expect(find.byType(RrhhTerminationDetailDrawer), findsOneWidget);
        expect(find.text('1. DATOS DEL EMPLEADO'), findsOneWidget);
        expect(find.text('2. DETALLE DE LA DESVINCULACIÓN'), findsOneWidget);
        expect(find.text('3. DOCUMENTACIÓN ADJUNTA'), findsOneWidget);
        expect(find.text('5. PLAZO LEGAL Y PAGO DE FINIQUITO'), findsOneWidget);
        expect(find.text('6. HISTORIAL DEL PROCESO'), findsOneWidget);

        // Cerrar drawer
        await tester.tap(find.byTooltip('Cerrar'));
        await tester.pumpAndSettle();
        expect(find.byType(RrhhTerminationDetailDrawer), findsNothing);
      });
    },
  );
}
