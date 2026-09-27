import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_vacation.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pantalla 09 — Bloque 3: Novedades Laborales (Control de Vacaciones)', () {
    late RrhhRepositoryMock repo;

    setUp(() {
      repo = RrhhRepositoryMock();
    });

    test('Escala legal de vacaciones según Ley General del Trabajo de Bolivia', () {
      final now = DateTime(2026, 9, 26);

      // 1. Menos de 1 año ininterrumpido -> 0 días (Sin derecho todavía)
      final hireUnderOneYear = DateTime(2026, 1, 15);
      expect(RrhhVacationCalculator.getCompletedYears(hireUnderOneYear, now), equals(0));
      expect(RrhhVacationCalculator.getAssignedDays(hireUnderOneYear, now), equals(0));

      // 2. De 1 a 5 años -> 15 días hábiles
      final hireTwoYears = DateTime(2024, 5, 10);
      expect(RrhhVacationCalculator.getCompletedYears(hireTwoYears, now), equals(2));
      expect(RrhhVacationCalculator.getAssignedDays(hireTwoYears, now), equals(15));

      final hireFourYears = DateTime(2022, 9, 1);
      expect(RrhhVacationCalculator.getCompletedYears(hireFourYears, now), equals(4));
      expect(RrhhVacationCalculator.getAssignedDays(hireFourYears, now), equals(15));

      // 3. De 5 a 10 años -> 20 días hábiles
      final hireFiveYears = DateTime(2021, 9, 20);
      expect(RrhhVacationCalculator.getCompletedYears(hireFiveYears, now), equals(5));
      expect(RrhhVacationCalculator.getAssignedDays(hireFiveYears, now), equals(20));

      final hireEightYears = DateTime(2018, 3, 15);
      expect(RrhhVacationCalculator.getCompletedYears(hireEightYears, now), equals(8));
      expect(RrhhVacationCalculator.getAssignedDays(hireEightYears, now), equals(20));

      // 4. De 10 o más años -> 30 días hábiles
      final hireTenYears = DateTime(2016, 9, 20);
      expect(RrhhVacationCalculator.getCompletedYears(hireTenYears, now), equals(10));
      expect(RrhhVacationCalculator.getAssignedDays(hireTenYears, now), equals(30));

      final hireFifteenYears = DateTime(2011, 1, 10);
      expect(RrhhVacationCalculator.getCompletedYears(hireFifteenYears, now), equals(15));
      expect(RrhhVacationCalculator.getAssignedDays(hireFifteenYears, now), equals(30));
    });

    test('Cómputo de días hábiles vs calendario', () {
      // Período de Lunes a Domingo (7 días calendario, 5 días hábiles)
      final monday = DateTime(2026, 10, 5); // Lunes
      final sunday = DateTime(2026, 10, 11); // Domingo

      expect(
        RrhhVacationCalculator.countDays(monday, sunday, countingMode: 'calendario'),
        equals(7),
      );
      expect(
        RrhhVacationCalculator.countDays(monday, sunday, countingMode: 'habiles'),
        equals(5),
      );
    });

    test('Formateo de antigüedad en lenguaje natural', () {
      final now = DateTime(2026, 9, 26);
      final hireRecent = DateTime(2026, 4, 15); // ~5 meses
      expect(RrhhVacationCalculator.formatAntiquity(hireRecent, now), contains('meses'));

      final hireThreeYears = DateTime(2023, 5, 10); // 3 años y meses
      expect(RrhhVacationCalculator.formatAntiquity(hireThreeYears, now), contains('3 años'));
    });

    test('Próximo aniversario laboral', () {
      final now = DateTime(2026, 9, 26);
      final hire = DateTime(2023, 11, 15);
      final nextAnniv = RrhhVacationCalculator.getNextAnniversary(hire, now);

      expect(nextAnniv.year, equals(2026));
      expect(nextAnniv.month, equals(11));
      expect(nextAnniv.day, equals(15));
    });

    test('El mock arranca con registros de goces pre-poblados y diversos estados', () async {
      final records = await repo.listVacationRecords();
      expect(records.length, greaterThanOrEqualTo(5));

      final codes = records.map((r) => r.code).toList();
      expect(codes, containsAll(['VAC-001', 'VAC-002', 'VAC-003', 'VAC-004']));

      final statuses = records.map((r) => r.status).toSet();
      expect(statuses, containsAll([
        RrhhVacationRecordStatus.gozado,
        RrhhVacationRecordStatus.enCurso,
        RrhhVacationRecordStatus.programado,
        RrhhVacationRecordStatus.cancelado,
      ]));
    });

    test('Cálculo de saldo por empleado en el mock según antigüedad real', () async {
      final balances = await repo.listVacationBalances();
      expect(balances, isNotEmpty);

      // EMP-001: Ingreso 2023 (~3 años) -> 15 días asignados
      final emp1 = balances.firstWhere((b) => b.employeeCode == 'EMP-001');
      expect(emp1.assignedDays, equals(15));
      expect(emp1.usedDays, greaterThanOrEqualTo(0));
      expect(emp1.pendingDays, equals(emp1.assignedDays - emp1.usedDays));

      // EMP-002: Ingreso 2020 (~6 años) -> 20 días asignados
      final emp2 = balances.firstWhere((b) => b.employeeCode == 'EMP-002');
      expect(emp2.assignedDays, equals(20));

      // EMP-004: Ingreso 2015 (~11 años) -> 30 días asignados
      final emp4 = balances.firstWhere((b) => b.employeeCode == 'EMP-004');
      expect(emp4.assignedDays, equals(30));

      // EMP-014: Ingreso 2026 (<1 año) -> 0 días asignados (sin derecho todavía)
      final emp14 = balances.firstWhere((b) => b.employeeCode == 'EMP-014');
      expect(emp14.assignedDays, equals(0));
      expect(emp14.balanceStatus, equals(RrhhVacationBalanceStatus.sinDerecho));
    });

    test('Creación de un nuevo período de vacaciones correlativo VAC-XXX', () async {
      final initial = await repo.listVacationRecords();
      final initialCount = initial.length;

      final newRecord = RrhhVacationRecord(
        id: 0,
        code: '',
        employeeId: 1,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mamani Quispe',
        startDate: DateTime(2026, 11, 2),
        endDate: DateTime(2026, 11, 6),
        daysCounted: 5,
        countingMode: 'habiles',
        status: RrhhVacationRecordStatus.programado,
        notes: 'Vacaciones de fin de año programadas en test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: 'Test Agent',
      );

      final created = await repo.createVacationRecord(newRecord);
      expect(created.id, greaterThan(0));
      expect(created.code, startsWith('VAC-'));

      final updatedList = await repo.listVacationRecords();
      expect(updatedList.length, equals(initialCount + 1));
      expect(updatedList.first.code, equals(created.code));
    });

    test('Transición de estados: programado -> en_curso -> gozado', () async {
      final newRecord = RrhhVacationRecord(
        id: 0,
        code: '',
        employeeId: 2,
        employeeCode: 'EMP-002',
        employeeName: 'Ana Flores Choque',
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 5),
        daysCounted: 5,
        countingMode: 'habiles',
        status: RrhhVacationRecordStatus.programado,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: 'Test Agent',
      );

      final created = await repo.createVacationRecord(newRecord);
      expect(created.status, equals(RrhhVacationRecordStatus.programado));

      // Iniciar
      final inCourse = await repo.updateVacationStatus(
        created.id,
        RrhhVacationRecordStatus.enCurso,
      );
      expect(inCourse.status, equals(RrhhVacationRecordStatus.enCurso));

      // Finalizar (Gozado)
      final finished = await repo.updateVacationStatus(
        created.id,
        RrhhVacationRecordStatus.gozado,
      );
      expect(finished.status, equals(RrhhVacationRecordStatus.gozado));
    });

    test('Cancelación con registro de motivo en notas', () async {
      final records = await repo.listVacationRecords(
        status: RrhhVacationRecordStatus.programado,
      );
      final target = records.first;

      final cancelled = await repo.updateVacationStatus(
        target.id,
        RrhhVacationRecordStatus.cancelado,
        reason: 'Urgencia operativa imprevista',
      );

      expect(cancelled.status, equals(RrhhVacationRecordStatus.cancelado));
      expect(cancelled.notes, contains('Urgencia operativa imprevista'));
    });

    test('Eliminación de registro de vacaciones', () async {
      final newRecord = await repo.createVacationRecord(
        RrhhVacationRecord(
          id: 0,
          code: '',
          employeeId: 1,
          employeeCode: 'EMP-001',
          employeeName: 'Carlos Mamani Quispe',
          startDate: DateTime(2026, 12, 1),
          endDate: DateTime(2026, 12, 5),
          daysCounted: 5,
          countingMode: 'habiles',
          status: RrhhVacationRecordStatus.programado,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: 'Test',
        ),
      );

      final deleted = await repo.deleteVacationRecord(newRecord.id);
      expect(deleted, isTrue);

      final found = await repo.getVacationRecordById(newRecord.id);
      expect(found, isNull);
    });

    test('Entrega a Contabilidad: listPayrollAffectingVacations', () async {
      final affecting = await repo.listPayrollAffectingVacations(
        DateTime(2026, 6, 1),
        DateTime(2026, 9, 30),
      );

      expect(affecting, isNotEmpty);
      expect(affecting.every((r) => r.status != RrhhVacationRecordStatus.cancelado), isTrue);
    });
  });
}
