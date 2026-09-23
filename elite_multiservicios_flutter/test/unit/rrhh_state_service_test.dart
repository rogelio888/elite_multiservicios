import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/services/rrhh_state_service.dart';

void main() {
  group('RrhhStateService Unit Tests', () {
    late RrhhStateService service;

    setUp(() {
      service = RrhhStateService();
      service.resetForTesting();
    });

    test('Initializes with comprehensive mock data and computed KPIs', () {
      expect(service.areas.isNotEmpty, isTrue);
      expect(service.positions.isNotEmpty, isTrue);
      expect(service.specialties.isNotEmpty, isTrue);
      expect(service.clients.isNotEmpty, isTrue);
      expect(service.schedules.isNotEmpty, isTrue);
      expect(service.employees.isNotEmpty, isTrue);
      expect(service.activeEmployees.isNotEmpty, isTrue);
      expect(service.inactiveEmployees.isNotEmpty, isTrue);
      expect(service.officeEmployees.isNotEmpty, isTrue);
      expect(service.fieldEmployees.isNotEmpty, isTrue);
      expect(service.applicants.isNotEmpty, isTrue);
      expect(service.assignments.isNotEmpty, isTrue);
      expect(service.leaves.isNotEmpty, isTrue);
      expect(service.vacations.isNotEmpty, isTrue);
      expect(service.incidents.isNotEmpty, isTrue);
      expect(service.movements.isNotEmpty, isTrue);
      expect(service.exits.isNotEmpty, isTrue);
    });

    test('Differentiates Oficina vs Campo correctly', () {
      final officeCount = service.officeEmployees.length;
      final fieldCount = service.fieldEmployees.length;
      expect(officeCount, greaterThan(0));
      expect(fieldCount, greaterThan(0));
      expect(officeCount + fieldCount, equals(service.activeEmployees.length));
    });

    test(
      'Terminating employee changes status to INACTIVO without deleting record',
      () {
        final active = service.activeEmployees.first;
        final initialTotal = service.totalEmployeesCount;
        final initialActive = service.activeEmployeesCount;
        final initialInactive = service.inactiveEmployeesCount;

        service.terminateEmployee(
          employeeId: active.id,
          reason: 'Renuncia voluntaria',
          exitObservations: 'Entrega de inventario y finiquito cancelado.',
          processedBy: 'Test Runner (RRHH)',
          severancePay: 3500.0,
        );

        expect(service.totalEmployeesCount, equals(initialTotal));
        expect(service.activeEmployeesCount, equals(initialActive - 1));
        expect(service.inactiveEmployeesCount, equals(initialInactive + 1));

        final terminated = service.employees.firstWhere(
          (e) => e.id == active.id,
        );
        expect(terminated.status, equals('INACTIVO'));
        expect(terminated.exitReason, equals('Renuncia voluntaria'));
        expect(terminated.timeline.first.category, equals('DESVINCULACION'));
      },
    );

    test(
      'Hiring applicant generates credentials and active employee record',
      () {
        final applicant = service.applicants.first;
        final initialActive = service.activeEmployeesCount;

        final newEmployee = service.hireApplicant(
          applicant: applicant,
          code: 'TEST-EMP-999',
          employeeType: 'CAMPO',
          area: 'Operaciones',
          position: 'Técnico de Limpieza',
          specialty: 'Limpieza Hospitalaria',
          workplace: 'Hospital Obrero N° 1',
          supervisor: 'Supervisor General',
          agreedSalary: 3200.0,
          contractType: 'Plazo Fijo',
          scheduleName: 'Turno Mañana',
          observations: 'Contratación de prueba unitaria',
          processedBy: 'Test HR Manager',
        );

        expect(service.activeEmployeesCount, equals(initialActive + 1));
        expect(newEmployee.status, equals('ACTIVO'));
        expect(
          newEmployee.effectiveCorporateEmail.contains(
            '@elitemultiservicios.com',
          ),
          isTrue,
        );
        expect(
          newEmployee.effectiveTemporaryPassword.startsWith('Elite.'),
          isTrue,
        );
      },
    );

    test(
      'getRotationHistory retrieves chronological sequence with origin traceability',
      () {
        // Carlos Mendoza Rios (emp-1) has an initial and a rotated assignment in mock data
        final history = service.getRotationHistory('emp-1');
        expect(history.length, greaterThanOrEqualTo(2));
        expect(history.first.status, equals('FINALIZADA'));
        expect(history.last.status, equals('ACTIVA'));
        expect(history.first.rotationNumber, equals(0));
        expect(history.last.rotationNumber, equals(1));
        expect(history.last.originDescription, isNotNull);
        expect(
          history.last.originDescription!.contains('Ventura Mall'),
          isTrue,
        );
      },
    );

    test(
      'rotateEmployee preserves previous origin, increments rotation number, and updates employee record',
      () {
        final emp = service.employees.firstWhere(
          (e) => e.code == 'EMP-004',
        ); // Andrea Soliz
        final initialHistory = service.getRotationHistory(emp.id);
        final initialRotationsCount = initialHistory.length;
        final prevAssignment = service.getActiveAssignment(emp.id);
        expect(prevAssignment, isNotNull);
        final expectedOrigin = prevAssignment!.fullDestinationSummary;

        service.rotateEmployee(
          employeeId: emp.id,
          employeeName: emp.fullName,
          employeeCode: emp.code,
          type: 'CAMPO',
          clientCompanyId: 'cli-1',
          clientCompanyName: 'Kolping Bolivia',
          contractedServiceId: 'srv-101',
          contractedServiceName: 'Mantenimiento Preventivo',
          workplaceBranch: 'Kolping - Central',
          scheduleName: 'Operativo Mañana (07:00 - 15:00)',
          supervisorName: 'Ricardo Montaño Justiniano',
          rotationReason: 'Reasignación temporal por auditoría de calidad',
        );

        final updatedHistory = service.getRotationHistory(emp.id);
        expect(updatedHistory.length, equals(initialRotationsCount + 1));

        final activeNow = service.getActiveAssignment(emp.id);
        expect(activeNow, isNotNull);
        expect(activeNow!.status, equals('ACTIVA'));
        expect(
          activeNow.rotationNumber,
          equals(prevAssignment.rotationNumber + 1),
        );
        expect(activeNow.originDescription, equals(expectedOrigin));
        expect(
          activeNow.rotationReason,
          equals('Reasignación temporal por auditoría de calidad'),
        );
        expect(activeNow.clientCompanyName, equals('Kolping Bolivia'));

        // Verify employee record sync
        final updatedEmp = service.employees.firstWhere((e) => e.id == emp.id);
        expect(updatedEmp.supervisor, equals('Ricardo Montaño Justiniano'));
        expect(updatedEmp.timeline.first.category, equals('ASIGNACION'));
        expect(
          updatedEmp.timeline.first.title.contains('Rotación de Personal'),
          isTrue,
        );
      },
    );
  });
}
