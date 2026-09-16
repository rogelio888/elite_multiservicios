import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/crm/data/crm_customers_service.dart';

void main() {
  group('CrmCustomersService Tests', () {
    late CrmCustomersService service;

    setUp(() {
      service = CrmCustomersService();
    });

    test('initializes with default customer accounts and valid MRR', () {
      expect(service.customers.isNotEmpty, isTrue);
      expect(service.totalActiveCustomers, greaterThanOrEqualTo(3));
      expect(service.totalMrr, greaterThan(0));
      expect(service.totalBranches, greaterThanOrEqualTo(7));
    });

    test('addCustomer inserts new customer at index 0 and updates metrics', () {
      final initialCount = service.customers.length;
      final initialBranches = service.totalBranches;

      const newBranch = CustomerBranch(
        id: 'BR-TEST-1',
        name: 'Sede Principal Test',
        address: 'Av. Cristo Redentor #100',
        localContact: 'Lic. Juan Perez',
        localPhone: '70012345',
        isHeadquarters: true,
      );

      final newCustomer = CustomerItem(
        id: 'CLI-TEST-01',
        legalName: 'Empresa Test S.A.',
        tradeName: 'Empresa Test',
        taxId: '987654321',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: const ['Limpieza Integral'],
        contactPerson: 'Lic. Juan Perez',
        phone: '70012345',
        email: 'contacto@test.bo',
        monthlyBilling: 8500.0,
        branches: const [newBranch],
      );

      service.addCustomer(newCustomer);

      expect(service.customers.length, equals(initialCount + 1));
      expect(service.customers.first.id, equals('CLI-TEST-01'));
      expect(service.totalBranches, equals(initialBranches + 1));
    });

    test('addBranchToCustomer appends a branch to existing customer', () {
      final target = service.customers.first;
      final initialBranchesCount = target.branches.length;

      const secondaryBranch = CustomerBranch(
        id: 'BR-SEC-01',
        name: 'Sucursal Secundaria',
        address: 'Calle 4 Oeste #50',
        localContact: 'Pedro Gomez',
        localPhone: '71122334',
        isHeadquarters: false,
      );

      service.addBranchToCustomer(target.id, secondaryBranch);

      final updated = service.customers.firstWhere((c) => c.id == target.id);
      expect(updated.branches.length, equals(initialBranchesCount + 1));
      expect(updated.branches.any((b) => b.id == 'BR-SEC-01'), isTrue);
    });

    test('updateCustomer toggles status and adjusts active MRR', () {
      final target = service.customers.firstWhere((c) => c.status == 'Activo');
      final mrrBefore = service.totalMrr;

      final paused = target.copyWith(status: 'En Pausa');
      service.updateCustomer(paused);

      expect(service.totalMrr, equals(mrrBefore - target.monthlyBilling));

      // Restore
      service.updateCustomer(target);
      expect(service.totalMrr, equals(mrrBefore));
    });

    test('isOpportunityPromoted returns correct status for opportunityId', () {
      expect(service.isOpportunityPromoted('OPP-999-NOT-EXISTS'), isFalse);

      final promoCustomer = CustomerItem(
        id: 'CLI-PROMO-1',
        legalName: 'Promo S.R.L.',
        tradeName: 'Promo Corp',
        taxId: '11223344',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: const ['Seguridad Física'],
        contactPerson: 'Admin',
        phone: '78899000',
        email: 'admin@promo.bo',
        monthlyBilling: 15000.0,
        opportunityId: 'OPP-PROMO-999',
        branches: const [
          CustomerBranch(
            id: 'BR-PROMO',
            name: 'Sede Promo',
            address: 'Dir 1',
            localContact: 'Admin',
            localPhone: '78899000',
            isHeadquarters: true,
          ),
        ],
      );

      service.addCustomer(promoCustomer);

      expect(service.isOpportunityPromoted('OPP-PROMO-999'), isTrue);
      expect(
        service.getCustomerByOpportunityId('OPP-PROMO-999')?.tradeName,
        equals('Promo Corp'),
      );
    });
  });
}
