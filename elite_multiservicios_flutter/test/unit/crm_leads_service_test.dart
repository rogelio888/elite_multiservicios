import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/crm/data/crm_leads_service.dart';

void main() {
  group('CrmLeadsService Unit Tests', () {
    late CrmLeadsService service;

    setUp(() {
      service = CrmLeadsService();
    });

    test('initializes with seed leads and valid metrics', () {
      expect(service.leads.isNotEmpty, isTrue);
      expect(service.totalCount, equals(service.leads.length));
      expect(service.qualifiedCount, greaterThan(0));
      expect(service.conversionRate, greaterThan(0.0));
      expect(service.totalPipelinePotential, greaterThan(0.0));
    });

    test('addLead inserts new lead at the top', () {
      final newLead = LeadModel(
        id: 'PROSP-TEST-99',
        date: 'Hoy',
        advisor: 'Asesor Test',
        company: 'Empresa Test S.A.',
        sector: 'Banca & Finanzas',
        address: 'Av. Las Américas #500',
        phone: '77001122',
        status: 'Prospectado',
        temperature: 'Frío',
        estimatedValue: 12000.0,
      );

      final countBefore = service.totalCount;
      service.addLead(newLead);

      expect(service.totalCount, equals(countBefore + 1));
      expect(service.leads.first.id, equals('PROSP-TEST-99'));
      expect(service.leads.first.company, equals('Empresa Test S.A.'));
    });

    test('updateStatus updates status reactively', () {
      final lead = service.leads.first;
      service.updateStatus(lead.id, 'Interesado (Calificado)');

      final updated = service.leads.firstWhere((l) => l.id == lead.id);
      expect(updated.status, equals('Interesado (Calificado)'));
    });

    test('updateTemperature alters lead temperature', () {
      final lead = service.leads.first;
      service.updateTemperature(lead.id, 'Caliente');

      final updated = service.leads.firstWhere((l) => l.id == lead.id);
      expect(updated.temperature, equals('Caliente'));
    });

    test('markPromoted updates isPromoted, status and temperature', () {
      final lead = service.leads.first;
      service.markPromoted(lead.id);

      final updated = service.leads.firstWhere((l) => l.id == lead.id);
      expect(updated.isPromoted, isTrue);
      expect(updated.status, equals('Interesado (Calificado)'));
      expect(updated.temperature, equals('Caliente'));
    });

    test('deleteLead removes lead from list', () {
      final lead = service.leads.last;
      final countBefore = service.totalCount;

      service.deleteLead(lead.id);

      expect(service.totalCount, equals(countBefore - 1));
      expect(service.leads.any((l) => l.id == lead.id), isFalse);
    });
  });
}
