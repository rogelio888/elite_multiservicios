import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_leave_request.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pantalla 08 — Bloque 3: Novedades Laborales (Permisos y Licencias)', () {
    late RrhhRepositoryMock repo;

    setUp(() {
      repo = RrhhRepositoryMock();
    });

    test('El mock arranca con 5 permisos pre-poblados con variedad de estados y tipos', () async {
      final leaves = await repo.listLeaveRequests();
      expect(leaves.length, greaterThanOrEqualTo(5));

      final codes = leaves.map((l) => l.code).toList();
      expect(codes, containsAll(['PERM-001', 'PERM-002', 'PERM-003', 'PERM-004', 'PERM-005']));

      final statuses = leaves.map((l) => l.status).toSet();
      expect(statuses, containsAll([
        RrhhLeaveStatus.aprobado,
        RrhhLeaveStatus.enCurso,
        RrhhLeaveStatus.pendiente,
        RrhhLeaveStatus.finalizado,
        RrhhLeaveStatus.rechazado,
      ]));
    });

    test('Reglas de negocio de goce de haberes por tipo de permiso', () {
      // Obligatorios pagados por ley
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.maternidad), isTrue);
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.paternidad), isTrue);
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.enfermedad), isTrue);
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.accidente), isTrue);
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.duelo), isTrue);
      expect(RrhhLeaveTypes.isMandatoryPaid(RrhhLeaveTypes.matrimonio), isTrue);

      // No pagados
      expect(RrhhLeaveTypes.isMandatoryUnpaid(RrhhLeaveTypes.personalSinGoce), isTrue);
      expect(RrhhLeaveTypes.isMandatoryUnpaid(RrhhLeaveTypes.tramitePersonal), isTrue);

      // A criterio (discrecionales)
      expect(RrhhLeaveTypes.isDiscretionaryPaid(RrhhLeaveTypes.estudio), isTrue);
      expect(RrhhLeaveTypes.isDiscretionaryPaid(RrhhLeaveTypes.personalConGoce), isTrue);
      expect(RrhhLeaveTypes.isDiscretionaryPaid(RrhhLeaveTypes.calamidadDomestica), isTrue);
      expect(RrhhLeaveTypes.isDiscretionaryPaid(RrhhLeaveTypes.otro), isTrue);
    });

    test('Obligatoriedad de evidencia adjunta para ENFERMEDAD y ACCIDENTE', () {
      expect(RrhhLeaveTypes.requiresEvidence(RrhhLeaveTypes.enfermedad), isTrue);
      expect(RrhhLeaveTypes.requiresEvidence(RrhhLeaveTypes.accidente), isTrue);
      expect(RrhhLeaveTypes.requiresEvidence(RrhhLeaveTypes.estudio), isFalse);
      expect(RrhhLeaveTypes.requiresEvidence(RrhhLeaveTypes.tramitePersonal), isFalse);
    });

    test('Cálculo de duración en días calendario y días hábiles', () {
      final start = DateTime(2026, 6, 1); // Lunes
      final end = DateTime(2026, 6, 7); // Domingo (7 días calendario)

      expect(RrhhLeaveTypes.calculateCalendarDays(start, end), equals(7));
      // Lunes a Viernes son 5 días hábiles
      expect(RrhhLeaveTypes.calculateWorkingDays(start, end), equals(5));
    });

    test('Filtrado por estado, tipo y goce de haberes', () async {
      // Filtrar pendientes
      final pendientes = await repo.listLeaveRequests(status: RrhhLeaveStatus.pendiente);
      expect(pendientes.every((l) => l.status == RrhhLeaveStatus.pendiente), isTrue);

      // Filtrar pagados
      final pagados = await repo.listLeaveRequests(isPaid: true);
      expect(pagados.every((l) => l.isPaid == true), isTrue);

      // Filtrar no pagados
      final sinGoce = await repo.listLeaveRequests(isPaid: false);
      expect(sinGoce.every((l) => l.isPaid == false), isTrue);

      // Filtrar por búsqueda
      final searchResult = await repo.listLeaveRequests(search: 'PERM-001');
      expect(searchResult.length, equals(1));
      expect(searchResult.first.code, equals('PERM-001'));
    });

    test('Creación de nueva solicitud genera código correlativo PERM-006', () async {
      final newRequest = RrhhLeaveRequest(
        id: 0,
        code: '',
        employeeId: 1,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Ramos',
        leaveType: RrhhLeaveTypes.estudio,
        startDate: DateTime(2026, 8, 10),
        endDate: DateTime(2026, 8, 12),
        durationDays: 3,
        isPaid: true,
        reason: 'Exámenes de grado universitarios en ingeniería',
        evidenceFile: 'constancia_universidad.pdf',
        status: RrhhLeaveStatus.pendiente,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: 'Encargada RRHH',
      );

      final created = await repo.createLeaveRequest(newRequest);
      expect(created.id, greaterThan(0));
      expect(created.code, equals('PERM-006'));
      expect(created.status, equals(RrhhLeaveStatus.pendiente));

      final fetched = await repo.getLeaveRequestById(created.id);
      expect(fetched, isNotNull);
      expect(fetched!.code, equals('PERM-006'));
    });

    test('Flujo de resolución: Aprobación y Rechazo de solicitudes', () async {
      // 1. Aprobar solicitud PERM-003 (que está pendiente)
      final perm3 = (await repo.listLeaveRequests()).firstWhere((l) => l.code == 'PERM-003');
      expect(perm3.status, equals(RrhhLeaveStatus.pendiente));

      final approved = await repo.updateLeaveStatus(
        perm3.id,
        RrhhLeaveStatus.aprobado,
        approvedBy: 'Jefa RRHH',
      );
      expect(approved.status, equals(RrhhLeaveStatus.aprobado));
      expect(approved.approvedBy, equals('Jefa RRHH'));
      expect(approved.approvedAt, isNotNull);

      // 2. Rechazar con motivo obligatorio
      final permUpdated = await repo.updateLeaveStatus(
        perm3.id,
        RrhhLeaveStatus.rechazado,
        reason: 'No cuenta con cobertura de reemplazo durante el turno',
        approvedBy: 'Jefa RRHH',
      );
      expect(permUpdated.status, equals(RrhhLeaveStatus.rechazado));
      expect(permUpdated.rejectionReason, contains('No cuenta con cobertura'));
    });

    test('Integración con Contabilidad: listPayrollAffectingLeaves', () async {
      // Obtener novedades que impactan nómina en el período actual
      final now = DateTime.now();
      final payrollLeaves = await repo.listPayrollAffectingLeaves(
        now.subtract(const Duration(days: 30)),
        now.add(const Duration(days: 30)),
      );

      // Debe incluir permisos aprobados, en curso o finalizados dentro del rango
      expect(payrollLeaves.isNotEmpty, isTrue);
      for (final l in payrollLeaves) {
        expect(
          [RrhhLeaveStatus.aprobado, RrhhLeaveStatus.enCurso, RrhhLeaveStatus.finalizado],
          contains(l.status),
        );
      }
    });

    test('Eliminación de solicitud de permiso en estado pendiente', () async {
      final initial = await repo.listLeaveRequests();
      final perm3 = initial.firstWhere((l) => l.code == 'PERM-003');

      final deleted = await repo.deleteLeaveRequest(perm3.id);
      expect(deleted, isTrue);

      final after = await repo.listLeaveRequests();
      expect(after.any((l) => l.id == perm3.id), isFalse);
    });
  });
}
