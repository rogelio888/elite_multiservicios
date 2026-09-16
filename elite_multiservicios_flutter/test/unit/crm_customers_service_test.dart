import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/crm/data/crm_customers_service.dart';

void main() {
  group('CrmCustomersService Multi-Contract Tests', () {
    late CrmCustomersService service;

    setUp(() {
      service = CrmCustomersService();
    });

    test(
      'initializes with multi-modal accounts: recurrent, projects and events',
      () {
        expect(service.customers.isNotEmpty, isTrue);
        expect(service.totalActiveCustomers, greaterThanOrEqualTo(4));
        expect(service.totalMrr, greaterThan(0));
        expect(service.totalProjectVolume, greaterThan(0));
        expect(service.totalBranches, greaterThanOrEqualTo(8));
        expect(service.totalContracts, greaterThanOrEqualTo(7));

        // Checks diverse contract types exist
        final contractTypes = service.customers
            .expand((c) => c.contracts)
            .map((ctr) => ctr.contractType)
            .toSet();
        expect(contractTypes.contains('Recurrente Mensual'), isTrue);
        expect(contractTypes.contains('Proyecto Único'), isTrue);
        expect(contractTypes.contains('Servicio por Evento'), isTrue);
        expect(contractTypes.contains('Híbrido'), isTrue);
      },
    );

    test(
      'addCustomer supports project-based and event contracts without recurring billing',
      () {
        final initialCount = service.customers.length;
        final initialProjectVolume = service.totalProjectVolume;
        final initialMrr = service.totalMrr;

        const projectContract = CustomerContract(
          id: 'CTR-TEST-PROJ',
          title: 'Vitrificado y Sellado de Pisos Industriales',
          contractType: 'Proyecto Único',
          serviceCategory: 'Limpieza Integral',
          totalAmount: 24000.0,
          oneTimeAmount: 24000.0,
          recurringMonthlyAmount: 0.0,
          paymentTerms: '50% Anticipo / 50% Entrega',
          executionTime: '10 días hábiles',
          advancePercentage: 50,
          status: 'Vigente',
          startDate: 'Hoy',
        );

        const branch = CustomerBranch(
          id: 'BR-TEST-PROJ',
          name: 'Planta Principal',
          address: 'Parque Industrial PI-24',
          localContact: 'Ing. Ronald Rojas',
          localPhone: '71009988',
          isHeadquarters: true,
        );

        final projectCustomer = CustomerItem(
          id: 'CLI-TEST-PROJ',
          legalName: 'Industrias del Oriente S.A.',
          tradeName: 'Industrias Oriente',
          taxId: '8091827364',
          segment: 'Corporativo B2B',
          status: 'Activo',
          activeServices: const ['Limpieza Integral'],
          contactPerson: 'Ing. Ronald Rojas',
          phone: '71009988',
          email: 'planta@oriente.bo',
          branches: const [branch],
          contracts: const [projectContract],
        );

        service.addCustomer(projectCustomer);

        expect(service.customers.length, equals(initialCount + 1));
        expect(projectCustomer.primaryContractType, equals('Proyecto Único'));
        expect(projectCustomer.monthlyBilling, equals(0.0));
        expect(projectCustomer.totalProjectBilling, equals(24000.0));
        // MRR remains unchanged, project volume increases
        expect(service.totalMrr, equals(initialMrr));
        expect(
          service.totalProjectVolume,
          equals(initialProjectVolume + 24000.0),
        );
      },
    );

    test(
      'addContractToCustomer appends a new contract and updates activeServices',
      () {
        final target = service.customers.first;
        final initialContractsCount = target.contracts.length;

        const eventContract = CustomerContract(
          id: 'CTR-EVENT-TEST',
          title: 'Operativo de Seguridad para Lanzamiento de Producto',
          contractType: 'Servicio por Evento',
          serviceCategory: 'Seguridad Física',
          totalAmount: 18000.0,
          oneTimeAmount: 18000.0,
          paymentTerms: '100% Contra Entrega',
          executionTime: '2 días',
          status: 'Vigente',
          startDate: 'Hoy',
        );

        service.addContractToCustomer(target.id, eventContract);

        final updated = service.customers.firstWhere((c) => c.id == target.id);
        expect(updated.contracts.length, equals(initialContractsCount + 1));
        expect(updated.contracts.any((c) => c.id == 'CTR-EVENT-TEST'), isTrue);
        expect(updated.activeServices.contains('Seguridad Física'), isTrue);
      },
    );

    test('updateCustomer toggles status and properly adjusts active MRR', () {
      final target = service.customers.firstWhere(
        (c) => c.status == 'Activo' && c.monthlyBilling > 0,
      );
      final mrrBefore = service.totalMrr;

      final paused = target.copyWith(status: 'En Pausa');
      service.updateCustomer(paused);

      expect(service.totalMrr, equals(mrrBefore - target.monthlyBilling));

      // Restore
      service.updateCustomer(target);
      expect(service.totalMrr, equals(mrrBefore));
    });

    test('isOpportunityPromoted returns true for linked opportunity', () {
      expect(service.isOpportunityPromoted('OPP-UNPROMOTED'), isFalse);

      final promoCustomer = CustomerItem(
        id: 'CLI-PROMO-HYBRID',
        legalName: 'Clínica Nueva S.R.L.',
        tradeName: 'Clínica Nueva',
        taxId: '99887766',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: const ['Software / Tecnología'],
        contactPerson: 'Dr. Flores',
        phone: '77665544',
        email: 'admin@clinicanueva.bo',
        opportunityId: 'OPP-HYBRID-101',
        branches: const [
          CustomerBranch(
            id: 'BR-CLINICA',
            name: 'Consultorios Central',
            address: 'Calle Sucre #25',
            localContact: 'Dr. Flores',
            localPhone: '77665544',
            isHeadquarters: true,
          ),
        ],
        contracts: const [
          CustomerContract(
            id: 'CTR-HYBRID-1',
            title: 'Software de Gestión + Póliza Mensual',
            contractType: 'Híbrido',
            serviceCategory: 'Software / Tecnología',
            totalAmount: 25000.0,
            oneTimeAmount: 15000.0,
            recurringMonthlyAmount: 1000.0,
            paymentTerms: '50% Anticipo + Abono mensual',
            executionTime: '30 días + 12 meses',
            status: 'Vigente',
            startDate: 'Hoy',
          ),
        ],
      );

      service.addCustomer(promoCustomer);

      expect(service.isOpportunityPromoted('OPP-HYBRID-101'), isTrue);
      expect(promoCustomer.primaryContractType, equals('Híbrido'));
      expect(promoCustomer.monthlyBilling, equals(1000.0));
      expect(promoCustomer.totalProjectBilling, equals(15000.0));
    });

    test(
      'supports full stage gates promotion: inspection branch, legal taxId and multi-modal contract',
      () {
        const branchFromGate = CustomerBranch(
          id: 'BR-GATE-01',
          name: 'Sede Operativa Norte / Equipetrol',
          address: 'Av. San Martín #450, Piso 3',
          localContact: 'Lic. Marcelo Justiniano',
          localPhone: '77312890',
          isHeadquarters: true,
          notes: 'EPP obligatorio, ingreso por recepción principal',
        );

        const contractFromGate = CustomerContract(
          id: 'CTR-GATE-01',
          title: 'Vigilancia Física Perimetral 24/7',
          contractType: 'Recurrente Mensual',
          serviceCategory: 'Seguridad',
          totalAmount: 14500.0,
          recurringMonthlyAmount: 14500.0,
          oneTimeAmount: 0.0,
          paymentTerms: 'Facturación mensual a 30 días',
          executionTime: 'Contrato 12 meses',
          advancePercentage: 0,
          status: 'Vigente',
          startDate: '01 Oct 2026',
        );

        final customerFromWonGate = CustomerItem(
          id: 'CLI-GATE-WON',
          legalName: 'Corporación Inmobiliaria del Sur S.A.',
          tradeName: 'Condominio Las Palmas Real',
          taxId: '1029384756',
          segment: 'Residencial B2C',
          status: 'Activo',
          activeServices: const ['Seguridad'],
          contactPerson: 'Lic. Marcelo Justiniano',
          phone: '77312890',
          email: 'facturacion@laspalmas.bo',
          opportunityId: 'OPP-101-WON',
          startDate: '01 Oct 2026',
          branches: const [branchFromGate],
          contracts: const [contractFromGate],
          notes: 'Contrato cerrado con compuertas progresivas completadas.',
        );

        service.addCustomer(customerFromWonGate);

        expect(service.isOpportunityPromoted('OPP-101-WON'), isTrue);
        final stored = service.getCustomerByOpportunityId('OPP-101-WON');
        expect(stored, isNotNull);
        expect(stored!.legalName, equals('Corporación Inmobiliaria del Sur S.A.'));
        expect(stored.taxId, equals('1029384756'));
        expect(stored.branches.length, equals(1));
        expect(stored.branches.first.isHeadquarters, isTrue);
        expect(stored.branches.first.address, contains('Av. San Martín'));
        expect(stored.contracts.first.contractType, equals('Recurrente Mensual'));
        expect(stored.monthlyBilling, equals(14500.0));
      },
    );
  });
}
