import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_termination_record.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pantalla 11 — Bloque 3: Desvinculaciones y Bajas Laborales (Unit Tests)', () {
    late RrhhRepositoryMock repo;

    setUp(() {
      repo = RrhhRepositoryMock();
    });

    test('El mock contiene registros pre-poblados coherentes con la LGT boliviana', () async {
      final records = await repo.listTerminationRecords();
      expect(records.length, greaterThanOrEqualTo(4));

      final codes = records.map((r) => r.code).toList();
      expect(codes, containsAll(['BAJA-001', 'BAJA-002', 'BAJA-003', 'BAJA-004']));

      // 1. Al menos una renuncia voluntaria finalizada
      final renuncia = records.firstWhere((r) => r.terminationType == RrhhTerminationTypes.renunciaVoluntaria && r.status == RrhhTerminationStatus.finalizada);
      expect(renuncia.resignationLetterFile, isNotNull);
      expect(renuncia.paymentCompleted, isTrue);

      // 2. Al menos un despido justificado con causal Art. 16
      final despido = records.firstWhere((r) => r.terminationType == RrhhTerminationTypes.despidoJustificado);
      expect(despido.justifiedCause, isNotNull);
      expect(despido.terminationMemoFile, isNotNull);

      // 3. Al menos un fin de contrato
      final finContrato = records.firstWhere((r) => r.terminationType == RrhhTerminationTypes.finDeContrato);
      expect(finContrato.workCertificateFile, isNotNull);

      // 4. Al menos una alerta de finiquito vencido (pago no completado y fecha límite superada)
      final vencido = records.firstWhere((r) => r.isPaymentExpired);
      expect(vencido.paymentCompleted, isFalse);
      expect(vencido.daysUntilPaymentDeadline, lessThan(0));
    });

    test('Regla de cálculo de plazo perentorio de 15 días calendario para finiquito (LGT D.S. 28699)', () {
      final lastDay = DateTime(2026, 9, 1);
      final deadline = lastDay.add(const Duration(days: 15));
      expect(deadline.difference(lastDay).inDays, equals(15));
      expect(deadline, equals(DateTime(2026, 9, 16)));
    });

    test('Filtros por causal, estado y búsqueda textual', () async {
      // Filtrar renuncias
      final renuncias = await repo.listTerminationRecords(terminationType: RrhhTerminationTypes.renunciaVoluntaria);
      expect(renuncias.every((r) => r.terminationType == RrhhTerminationTypes.renunciaVoluntaria), isTrue);

      // Filtrar por estado en proceso
      final enProceso = await repo.listTerminationRecords(status: RrhhTerminationStatus.enProceso);
      expect(enProceso.every((r) => r.status == RrhhTerminationStatus.enProceso), isTrue);

      // Búsqueda por texto (código o motivo)
      final searchResult = await repo.listTerminationRecords(search: 'BAJA-002');
      expect(searchResult.length, equals(1));
      expect(searchResult.first.code, equals('BAJA-002'));
    });

    test('Integración con Contabilidad: listPayrollAffectingTerminations expone bajas dentro del periodo', () async {
      final from = DateTime(2026, 8, 1);
      final to = DateTime(2026, 9, 30);

      final payrollTerminations = await repo.listPayrollAffectingTerminations(from, to);
      expect(payrollTerminations, isNotEmpty);
      expect(payrollTerminations.every((r) => r.status != RrhhTerminationStatus.cancelada), isTrue);
    });

    test('Regla de Oro: al finalizar la baja, el empleado pasa a estado BAJA y disponibilidad INACTIVO', () async {
      // Patricia Flores (EMP-005, employeeId 5) está en BAJA-004 con estado registrada
      final initialRecord = (await repo.listTerminationRecords()).firstWhere((r) => r.id == 4);
      expect(initialRecord.status, equals(RrhhTerminationStatus.registrada));

      // Finalizar la baja laboral
      final success = await repo.updateTerminationStatus(
        initialRecord.id,
        RrhhTerminationStatus.finalizada,
        reason: 'Baja completada formalmente con firma de finiquito.',
      );
      expect(success, isTrue);

      // Verificar que el empleado ahora tiene estado BAJA
      final updatedEmp = await repo.getEmployeeById(initialRecord.employeeId);
      expect(updatedEmp, isNotNull);
      expect(updatedEmp!.status, equals('BAJA'));
      expect(updatedEmp.availabilityStatus, equals('INACTIVO'));
      expect(updatedEmp.exitDate, equals(initialRecord.terminationDate));
    });

    test('Seguridad de eliminación: solo se pueden eliminar expedientes en estado registrada', () async {
      // Intentar eliminar un expediente en_proceso o finalizada debe lanzar StateError
      expect(
        () async => await repo.deleteTerminationRecord(1), // BAJA-001 está finalizada
        throwsA(isA<StateError>()),
      );

      // Crear un expediente temporal en estado registrada y eliminarlo
      final temp = await repo.createTerminationRecord(
        RrhhTerminationRecord(
          id: 0,
          code: 'BAJA-TMP',
          employeeId: 1,
          employeeCode: 'EMP-001',
          employeeName: 'Juan Carlos Pérez',
          terminationType: RrhhTerminationTypes.renunciaVoluntaria,
          terminationDate: DateTime.now(),
          lastWorkDay: DateTime.now(),
          reason: 'Renuncia temporal para prueba unitaria de eliminación.',
          status: RrhhTerminationStatus.registrada,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: 'Admin',
        ),
      );

      expect(temp.status, equals(RrhhTerminationStatus.registrada));
      final deleteSuccess = await repo.deleteTerminationRecord(temp.id);
      expect(deleteSuccess, isTrue);

      final notFound = await repo.getTerminationRecordById(temp.id);
      expect(notFound, isNull);
    });
  });
}
