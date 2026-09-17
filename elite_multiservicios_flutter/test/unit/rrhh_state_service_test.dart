import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/services/rrhh_state_service.dart';

void main() {
  group('RrhhStateService Unit Tests', () {
    late RrhhStateService service;

    setUp(() {
      service = RrhhStateService();
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
  });
}
