import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_mock_dataset.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_employee.dart'
    as local;

void main() {
  group('FASE B: Extensión RrhhEmployee & Repositorio', () {
    late RrhhRepository repo;

    setUp(() {
      repo = RrhhRepository.current;
    });

    test('Empleados iniciales conservan campos nuevos como null por retrocompatibilidad', () {
      final employees = RrhhMockDataset.initialEmployees();
      final emp1 = employees.firstWhere((e) => e.code == 'EMP-001');

      expect(emp1.code, 'EMP-001');
      expect(emp1.bankName, isNull);
      expect(emp1.accountType, isNull);
      expect(emp1.accountNumber, isNull);
      expect(emp1.afpName, isNull);
      expect(emp1.bonuses, isNull);
      expect(emp1.deductions, isNull);
      expect(emp1.documentChecklist, isNull);
    });

    test('Empleado completo EMP-019 posee todos los campos de Fase B poblados', () {
      final employees = RrhhMockDataset.initialEmployees();
      final emp19 = employees.firstWhere((e) => e.code == 'EMP-019');

      expect(emp19.code, 'EMP-019');
      expect(emp19.fullName, 'Valeria Justiniano Paz');
      expect(emp19.bankName, 'Banco Mercantil Santa Cruz');
      expect(emp19.accountType, 'Ahorro');
      expect(emp19.accountNumber, '4029182374');
      expect(emp19.afpName, 'Gestora Pública');
      expect(emp19.afpNumber, 'GP-8839201');
      expect(emp19.healthInsurance, 'Caja Nacional de Salud (CNS)');
      expect(emp19.fullAddress, contains('Barrio Sirari'));
      expect(emp19.maritalStatus, 'Casado');
      expect(emp19.childrenCount, 2);
      expect(emp19.emergencyContactName, 'Roberto Mendoza Aguilera');
      expect(emp19.emergencyContactPhone, '77390123');
      expect(emp19.emergencyContactRelation, 'Cónyuge');
      expect(emp19.workdayType, 'Completa');
      expect(emp19.contractStartDate, isNotNull);
      expect(emp19.contractSignedPdfUrl, contains('emp_019_firmado.pdf'));
      expect(emp19.bonuses?.length, 2);
      expect(emp19.deductions?.length, 1);
      expect(emp19.shiftId, 'TURNO-003');
      expect(emp19.baseLocation, contains('Oficina Central'));
      expect(emp19.supervisorEmployeeId, 'EMP-002');
      expect(emp19.documentChecklist?['CI'], 'validado');
      expect(emp19.documentChecklist?['LICENCIA'], 'pendiente');
    });

    test('updateEmployeeBankInfo actualiza los datos bancarios', () async {
      final updated = await repo.updateEmployeeBankInfo(
        1,
        bankName: 'Banco Bisa',
        accountType: 'Corriente',
        accountNumber: '1122334455',
      );

      expect(updated.bankName, 'Banco Bisa');
      expect(updated.accountType, 'Corriente');
      expect(updated.accountNumber, '1122334455');
    });

    test('updateEmployeeSocialSecurity actualiza AFP y seguro médico', () async {
      final updated = await repo.updateEmployeeSocialSecurity(
        1,
        afpName: 'Gestora Pública',
        afpNumber: 'GP-1234567',
        healthInsurance: 'Caja Petrolera de Salud',
      );

      expect(updated.afpName, 'Gestora Pública');
      expect(updated.afpNumber, 'GP-1234567');
      expect(updated.healthInsurance, 'Caja Petrolera de Salud');
    });

    test('updateEmployeePersonalInfo actualiza dirección y contacto de emergencia', () async {
      final updated = await repo.updateEmployeePersonalInfo(
        1,
        fullAddress: 'Av. Banzer 4to Anillo #500, Santa Cruz',
        maritalStatus: 'Casado',
        childrenCount: 3,
        emergencyContactName: 'Juana Pérez',
        emergencyContactPhone: '71199887',
        emergencyContactRelation: 'Hermana',
      );

      expect(updated.fullAddress, 'Av. Banzer 4to Anillo #500, Santa Cruz');
      expect(updated.maritalStatus, 'Casado');
      expect(updated.childrenCount, 3);
      expect(updated.emergencyContactName, 'Juana Pérez');
      expect(updated.emergencyContactPhone, '71199887');
      expect(updated.emergencyContactRelation, 'Hermana');
    });

    test('updateEmployeeContract actualiza datos contractuales complementarios', () async {
      final now = DateTime(2026, 1, 1);
      final updated = await repo.updateEmployeeContract(
        1,
        contractType: 'Indefinido',
        paymentModality: 'MENSUAL',
        workdayType: 'Completa',
        contractStartDate: now,
        contractSignedPdfUrl: 'https://storage/contract_1.pdf',
      );

      expect(updated.contractType, 'Indefinido');
      expect(updated.paymentModality, 'MENSUAL');
      expect(updated.workdayType, 'Completa');
      expect(updated.contractStartDate, now);
      expect(updated.contractSignedPdfUrl, 'https://storage/contract_1.pdf');
    });

    test('updateEmployeeBonuses y updateEmployeeDeductions persisten listas de entidades', () async {
      final bonuses = [
        RrhhEmployeeBonus(
          code: 'BONO-PROD',
          name: 'Bono de Productividad',
          type: 'Variable',
          amount: 350.0,
          isPercentage: false,
        ),
      ];

      final deductions = [
        RrhhEmployeeDeduction(
          code: 'DESC-RCIVA',
          name: 'Retención RC-IVA',
          type: 'Porcentaje',
          amount: 13.0,
          isPercentage: true,
        ),
      ];

      final withBonuses = await repo.updateEmployeeBonuses(1, bonuses);
      expect(withBonuses.bonuses?.first.code, 'BONO-PROD');
      expect(withBonuses.bonuses?.first.amount, 350.0);

      final withDeductions = await repo.updateEmployeeDeductions(1, deductions);
      expect(withDeductions.deductions?.first.code, 'DESC-RCIVA');
      expect(withDeductions.deductions?.first.isPercentage, isTrue);
    });

    test('updateEmployeeAssignment actualiza turno, sede y supervisor', () async {
      final updated = await repo.updateEmployeeAssignment(
        1,
        shiftId: 'TURNO-002',
        baseLocation: 'Parque Industrial - Planta Sur',
        supervisorEmployeeId: 'EMP-005',
      );

      expect(updated.shiftId, 'TURNO-002');
      expect(updated.baseLocation, 'Parque Industrial - Planta Sur');
      expect(updated.supervisorEmployeeId, 'EMP-005');
    });

    test('updateEmployeeDocuments actualiza el checklist documental', () async {
      final checklist = {
        'CI': 'validado',
        'FELCC': 'validado',
        'AVISO': 'recibido',
        'CROQUIS': 'pendiente',
      };

      final updated = await repo.updateEmployeeDocuments(1, checklist);
      expect(updated.documentChecklist?['CI'], 'validado');
      expect(updated.documentChecklist?['AVISO'], 'recibido');
      expect(updated.documentChecklist?['CROQUIS'], 'pendiente');
    });

    test('getEmployeeContractData expone la información requerida por Contabilidad', () async {
      final contractData = await repo.getEmployeeContractData(19);

      expect(contractData.employeeId, 19);
      expect(contractData.code, 'EMP-019');
      expect(contractData.fullName, 'Valeria Justiniano Paz');
      expect(contractData.status, 'ACTIVO');
      expect(contractData.contractType, 'Indefinido');
      expect(contractData.baseSalary, 6500.0);
      expect(contractData.paymentModality, 'MENSUAL');
      expect(contractData.bonuses?.length, 2);
      expect(contractData.deductions?.length, 1);
      expect(contractData.contractStartDate, DateTime(2025, 3, 1));
      expect(contractData.terminationDate, isNull);
    });

    test('Modelo local RrhhEmployee soporta serialización toJson y fromJson con campos nuevos', () {
      final empLocal = local.RrhhEmployee(
        id: 'EMP-999',
        code: 'EMP-999',
        fullName: 'Test Employee Local',
        birthPlace: 'La Paz',
        identityCard: '9988776 LP',
        phone: '70099887',
        address: 'Zona Central',
        occupation: 'Supervisor',
        personalReference: 'Ref 1',
        referencePhone: '71122334',
        employeeType: 'OFICINA',
        area: 'Administración',
        position: 'Jefe',
        specialty: 'Gestión',
        workplace: 'Oficina',
        supervisor: 'Director',
        realStartDate: DateTime(2025, 1, 1),
        fiscalStartDate: DateTime(2025, 1, 1),
        agreedSalary: 5000.0,
        contractType: 'Indefinido',
        observations: 'Ninguna',
        status: 'ACTIVO',
        bankName: 'Banco Unión',
        accountNumber: '12345678',
        documentChecklist: {'CI': 'validado'},
      );

      final json = empLocal.toJson();
      expect(json['bankName'], 'Banco Unión');
      expect(json['accountNumber'], '12345678');
      expect(json['documentChecklist']['CI'], 'validado');

      final deserialized = local.RrhhEmployee.fromJson(json);
      expect(deserialized.bankName, 'Banco Unión');
      expect(deserialized.accountNumber, '12345678');
      expect(deserialized.documentChecklist?['CI'], 'validado');
    });
  });
}
