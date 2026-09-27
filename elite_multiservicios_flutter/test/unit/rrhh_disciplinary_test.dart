import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_disciplinary_record.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pantalla 10 — Bloque 3: Novedades Laborales (Incidencias y Disciplina)', () {
    late RrhhRepositoryMock repo;

    setUp(() {
      repo = RrhhRepositoryMock();
    });

    test('El mock contiene registros pre-poblados que cubren todos los tipos de falta y sanción', () async {
      final records = await repo.listDisciplinaryRecords();
      expect(records.length, greaterThanOrEqualTo(6));

      // Códigos INC-001 a INC-006
      final codes = records.map((r) => r.code).toList();
      expect(codes, containsAll(['INC-001', 'INC-002', 'INC-003', 'INC-004', 'INC-005', 'INC-006']));

      // 1. Falta leve con amonestación verbal
      final verbalRecord = records.firstWhere((r) => r.sanctionType == RrhhSanctionTypes.verbal);
      expect(verbalRecord.faultType, equals(RrhhFaultTypes.leve));
      expect(verbalRecord.status, equals(RrhhDisciplinaryStatus.sancionada));

      // 2. Falta grave con amonestación escrita
      final writtenRecord = records.firstWhere((r) => r.sanctionType == RrhhSanctionTypes.escrita);
      expect(writtenRecord.faultType, equals(RrhhFaultTypes.grave));

      // 3. Falta grave con suspensión de 2 días
      final suspensionRecord = records.firstWhere((r) => r.sanctionType == RrhhSanctionTypes.suspension);
      expect(suspensionRecord.suspensionDays, equals(2));
      expect(suspensionRecord.salaryDeduction, greaterThan(0));

      // 4. Falta gravísima con proceso en curso
      final gravisimaRecord = records.firstWhere((r) => r.faultType == RrhhFaultTypes.gravisima);
      expect(gravisimaRecord.requiresDischarge, isTrue);

      // 5. Al menos una archivada (sin sanción)
      final archivedRecord = records.firstWhere((r) => r.status == RrhhDisciplinaryStatus.archivada);
      expect(archivedRecord.sanctionType, isNull);
    });

    test('Reglas de negocio de severidad y debido proceso', () {
      expect(RrhhFaultTypes.requiresMandatoryDischarge(RrhhFaultTypes.grave), isTrue);
      expect(RrhhFaultTypes.requiresMandatoryDischarge(RrhhFaultTypes.gravisima), isTrue);
      expect(RrhhFaultTypes.requiresMandatoryDischarge(RrhhFaultTypes.leve), isFalse);

      expect(RrhhSanctionTypes.maxSuspensionDays, equals(5));
      expect(RrhhSanctionTypes.affectsPayroll(RrhhSanctionTypes.suspension), isTrue);
      expect(RrhhSanctionTypes.affectsPayroll(RrhhSanctionTypes.pecuniaria), isTrue);
      expect(RrhhSanctionTypes.affectsPayroll(RrhhSanctionTypes.verbal), isFalse);
      expect(RrhhSanctionTypes.affectsPayroll(RrhhSanctionTypes.escrita), isFalse);
    });

    test('Filtros por empleado, tipo de falta, sanción y estado', () async {
      // Filtrar faltas leves
      final leves = await repo.listDisciplinaryRecords(faultType: RrhhFaultTypes.leve);
      expect(leves.every((r) => r.faultType == RrhhFaultTypes.leve), isTrue);

      // Filtrar faltas graves
      final graves = await repo.listDisciplinaryRecords(faultType: RrhhFaultTypes.grave);
      expect(graves.every((r) => r.faultType == RrhhFaultTypes.grave), isTrue);

      // Filtrar por estado sancionada
      final sancionadas = await repo.listDisciplinaryRecords(status: RrhhDisciplinaryStatus.sancionada);
      expect(sancionadas.every((r) => r.status == RrhhDisciplinaryStatus.sancionada), isTrue);

      // Filtrar por sanción suspensión
      final suspensiones = await repo.listDisciplinaryRecords(sanctionType: RrhhSanctionTypes.suspension);
      expect(suspensiones.every((r) => r.sanctionType == RrhhSanctionTypes.suspension), isTrue);
    });

    test('Integración con Contabilidad: listPayrollAffectingDisciplinary expone sanciones con deducción', () async {
      final now = DateTime.now();
      final from = DateTime(now.year, now.month - 2, 1);
      final to = DateTime(now.year, now.month + 2, 28);

      final payrollAffecting = await repo.listPayrollAffectingDisciplinary(from, to);
      expect(payrollAffecting, isNotEmpty);

      for (final item in payrollAffecting) {
        expect(
          item.sanctionType == RrhhSanctionTypes.suspension ||
              item.sanctionType == RrhhSanctionTypes.pecuniaria,
          isTrue,
        );
        expect(item.salaryDeduction, isNotNull);
        expect(item.salaryDeduction!, greaterThan(0));
      }
    });

    test('CRUD: Creación, actualización de estado y eliminación restringida', () async {
      final now = DateTime.now();
      final newRecord = RrhhDisciplinaryRecord(
        id: 0,
        code: 'INC-TMP',
        employeeId: 101,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza',
        incidentDate: now,
        incidentDescription: 'Llegada 45 minutos tarde sin justificación previa.',
        faultType: RrhhFaultTypes.leve,
        requiresDischarge: false,
        sanctionType: RrhhSanctionTypes.verbal,
        notifiedEmployee: true,
        status: RrhhDisciplinaryStatus.registrada,
        createdAt: now,
        updatedAt: now,
        createdBy: 'Lic. Laura Mendoza',
      );

      final created = await repo.createDisciplinaryRecord(newRecord);
      expect(created.id, greaterThan(0));
      expect(created.code, startsWith('INC-'));

      // Actualizar estado a en_descargo
      final success = await repo.updateDisciplinaryStatus(
        created.id,
        RrhhDisciplinaryStatus.enDescargo,
        reason: 'Se solicitó justificación escrita',
      );
      expect(success, isTrue);

      final updated = await repo.getDisciplinaryRecordById(created.id);
      expect(updated, isNotNull);
      expect(updated!.status, equals(RrhhDisciplinaryStatus.enDescargo));

      // No debe permitir eliminar si no está en 'registrada'
      expect(
        () async => await repo.deleteDisciplinaryRecord(created.id),
        throwsA(isA<StateError>()),
      );

      // Regresar a registrada y eliminar exitosamente
      await repo.updateDisciplinaryStatus(created.id, RrhhDisciplinaryStatus.registrada);
      final deleted = await repo.deleteDisciplinaryRecord(created.id);
      expect(deleted, isTrue);

      final notFound = await repo.getDisciplinaryRecordById(created.id);
      expect(notFound, isNull);
    });
  });
}
