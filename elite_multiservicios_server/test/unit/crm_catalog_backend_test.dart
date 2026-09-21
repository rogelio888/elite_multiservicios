import 'dart:convert';
import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';

void main() {
  group('CRM Dynamic Catalog & Quote Snapshot Integrity Tests', () {
    test('CrmSector instantiates with proper attributes and serialization', () {
      final now = DateTime.now().toUtc();
      final sector = CrmSector(
        code: 'SEC-SALUD',
        name: 'Clínicas y Centros Médicos',
        description: 'Instituciones de salud y bioseguridad',
        isActive: true,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      expect(sector.code, equals('SEC-SALUD'));
      expect(sector.name, equals('Clínicas y Centros Médicos'));
      expect(sector.isActive, isTrue);
      expect(sector.isDeleted, isFalse);

      final json = sector.toJson();
      expect(json['code'], equals('SEC-SALUD'));
      expect(json['name'], equals('Clínicas y Centros Médicos'));
    });

    test(
      'CrmServiceLine instantiates with proper attributes and serialization',
      () {
        final now = DateTime.now().toUtc();
        final line = CrmServiceLine(
          code: 'SRV-SEG-247',
          name: 'Seguridad Física',
          category: 'Personal',
          description: 'Vigilancia y patrullaje preventivo',
          isActive: true,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        );

        expect(line.code, equals('SRV-SEG-247'));
        expect(line.name, equals('Seguridad Física'));
        expect(line.category, equals('Personal'));

        final json = line.toJson();
        expect(json['code'], equals('SRV-SEG-247'));
        expect(json['name'], equals('Seguridad Física'));
        expect(json['category'], equals('Personal'));
      },
    );

    test('CrmCatalogItem models calculation rules and pricing correctly', () {
      final now = DateTime.now().toUtc();
      final metadataJson = jsonEncode({
        'hoursPerShift': 12,
        'daysPerMonth': 26,
      });
      final item = CrmCatalogItem(
        code: 'CAT-VIG-247',
        serviceLineId: 1,
        concept: 'Puesto de Vigilancia 24/7 (3 guardias rotativos)',
        category: 'Personal',
        calculationType: 'PER_POSITION',
        unitType: 'Puesto 24/7',
        basePrice: 6800.0,
        minQuantity: 1.0,
        version: 1,
        metadata: metadataJson,
        description: 'Cobertura continua de seguridad física',
        isActive: true,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      expect(item.code, equals('CAT-VIG-247'));
      expect(item.calculationType, equals('PER_POSITION'));
      expect(item.basePrice, equals(6800.0));
      expect(item.version, equals(1));

      final meta = jsonDecode(item.metadata!);
      expect(meta['hoursPerShift'], equals(12));
      expect(meta['daysPerMonth'], equals(26));
    });

    test(
      'CrmCatalogItemScope models sector-differentiated pricing overrides',
      () {
        final now = DateTime.now().toUtc();
        final scope = CrmCatalogItemScope(
          catalogItemId: 1,
          sectorId: 2,
          priceOverride: 32.0,
          isActive: true,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        );

        expect(scope.catalogItemId, equals(1));
        expect(scope.sectorId, equals(2));
        expect(scope.priceOverride, equals(32.0));
        expect(scope.isDeleted, isFalse);

        final json = scope.toJson();
        expect(json['priceOverride'], equals(32.0));
        expect(json['sectorId'], equals(2));
      },
    );

    test(
      'CrmQuoteItem stores inmutable snapshot of catalog pricing and formula',
      () {
        final now = DateTime.now().toUtc();
        final meta = jsonEncode({'hoursPerShift': 12, 'daysPerMonth': 26});
        final quoteItem = CrmQuoteItem(
          opportunityId: 101,
          category: 'Limpieza',
          concept: 'Limpieza Hospitalaria Especializada',
          unitType: 'm²',
          quantity: 500.0,
          unitPrice: 32.0,
          catalogItemId: 4,
          catalogVersion: 2,
          calculationType: 'PER_AREA',
          metadata: meta,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        );

        expect(quoteItem.catalogItemId, equals(4));
        expect(quoteItem.catalogVersion, equals(2));
        expect(quoteItem.calculationType, equals('PER_AREA'));
        expect(quoteItem.unitPrice, equals(32.0));
        expect(quoteItem.quantity, equals(500.0));

        final json = quoteItem.toJson();
        expect(json['catalogItemId'], equals(4));
        expect(json['catalogVersion'], equals(2));
        expect(json['calculationType'], equals('PER_AREA'));
        expect(json['metadata'], equals(meta));
      },
    );

    test(
      'AppPermissions catalog contains canonical catalog RBAC permissions',
      () {
        expect(AppPermissions.crmCatalogView, equals('catalog.view'));
        expect(AppPermissions.crmCatalogManage, equals('catalog.manage'));
        expect(AppPermissions.all, contains(AppPermissions.crmCatalogView));
        expect(AppPermissions.all, contains(AppPermissions.crmCatalogManage));
      },
    );
  });
}
