import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_shift.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_remote.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_turnos_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_turnos_tab_shifts.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_turnos_tab_schedules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTurnosRepository extends RrhhRepositoryRemote {
  @override
  Future<List<RrhhShift>> listShifts() async {
    return [
      RrhhShift(
        id: 1,
        code: 'TURNO-001',
        name: 'Turno Mañana',
        startTime: '08:00',
        endTime: '16:00',
        workDays: [1, 2, 3, 4, 5],
        shiftType: 'Completa',
        isActive: true,
        assignedEmployeesCount: 12,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    ];
  }

  @override
  Future<List<RrhhBaseSchedule>> listBaseSchedules() async {
    return [
      RrhhBaseSchedule(
        id: 1,
        code: 'HORARIO-001',
        name: 'Horario Administrativo Central',
        includedShiftCodes: const ['TURNO-001'],
        workerType: 'OFICINA',
        totalWeeklyHours: 40.0,
        isActive: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    ];
  }
}

void main() {
  late RrhhRepository originalRepo;

  setUp(() {
    originalRepo = RrhhRepository.current;
    RrhhRepository.current = _FakeTurnosRepository();
  });

  tearDown(() {
    RrhhRepository.current = originalRepo;
  });

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
    testWidgets('renders view with header and Tab 1 Turnos by default', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verificar encabezado ejecutivo
      expect(find.text('Turnos y Horarios Base'), findsOneWidget);
      expect(
        find.text('Catálogo de turnos de trabajo y horarios plantilla'),
        findsOneWidget,
      );

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

    testWidgets('switches to Tab 2 Horarios Base and displays schedules list', (
      tester,
    ) async {
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
