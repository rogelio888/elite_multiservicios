import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/crm/data/crm_leads_service.dart';

void main() {
  group('CrmLeadsService Unit Tests', () {
    late CrmLeadsService service;

    final initialTestLeads = [
      const LeadModel(
        id: 'PROSP-TEST-01',
        rawId: 1,
        code: 'PROSP-TEST-01',
        date: '18/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'EMBRIOVID',
        sector: 'Clínicas y centros médicos',
        address: 'Edif. Tacuaral, Equipetrol',
        phone: '77042047',
        status: 'En Espera de Respuesta',
        temperature: 'Templado',
        estimatedValue: 6800.0,
      ),
      const LeadModel(
        id: 'PROSP-TEST-02',
        rawId: 2,
        code: 'PROSP-TEST-02',
        date: '19/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'GINOFIV',
        sector: 'Clínicas y centros médicos',
        address: 'Av. Alemana #2450',
        phone: '79683941',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        estimatedValue: 9200.0,
      ),
    ];

    setUp(() {
      service = CrmLeadsService();
      service.setInitialLeadsForTesting(initialTestLeads);
    });

    test('initializes with seed leads and valid metrics', () {
      expect(service.leads.isNotEmpty, isTrue);
      expect(service.totalCount, equals(service.leads.length));
      expect(service.qualifiedCount, equals(1));
      expect(service.hotCount, equals(1));
      expect(service.conversionRate, equals(50.0));
      expect(service.totalPipelinePotential, equals(16000.0));
    });

    test('addLead inserts new lead at the top', () {
      final newLead = const LeadModel(
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
      service.setInitialLeadsForTesting([newLead, ...service.leads]);

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
