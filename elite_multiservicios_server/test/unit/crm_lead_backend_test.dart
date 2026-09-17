import 'package:test/test.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';

void main() {
  group('CRM Leads Backend & Protocol Integrity Tests', () {
    test('CrmLead model instantiates with proper defaults and serialization', () {
      final now = DateTime.now().toUtc();
      final lead = CrmLead(
        code: 'PROSP-001',
        company: 'EMBRIOVID',
        companyUrl: 'https://www.embriovid.com/contactos',
        sector: 'Clínicas y centros médicos',
        advisor: 'Rodrigo Acha',
        address: 'Edif. Tacuaral, Av. San Martín',
        phone: '77042047',
        contactPerson: 'Lic. Maria Eugenia',
        status: 'Prospectado',
        temperature: 'Templado',
        estimatedValue: 6800.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(lead.code, equals('PROSP-001'));
      expect(lead.company, equals('EMBRIOVID'));
      expect(lead.status, equals('Prospectado'));
      expect(lead.temperature, equals('Templado'));
      expect(lead.estimatedValue, equals(6800.0));
      expect(lead.isPromoted, isFalse);
      expect(lead.isDeleted, isFalse);

      final json = lead.toJson();
      expect(json['code'], equals('PROSP-001'));
      expect(json['company'], equals('EMBRIOVID'));
      expect(json['status'], equals('Prospectado'));
      expect(json['temperature'], equals('Templado'));
      expect(json['estimatedValue'], equals(6800.0));
    });

    test('CrmLeadMetricsResponse models aggregated commercial metrics correctly', () {
      final metrics = CrmLeadMetricsResponse(
        totalCount: 12,
        contactedCount: 5,
        waitingCount: 2,
        qualifiedCount: 4,
        hotCount: 4,
        conversionRate: 33.33,
        totalPipelinePotential: 75200.0,
      );

      expect(metrics.totalCount, equals(12));
      expect(metrics.contactedCount, equals(5));
      expect(metrics.waitingCount, equals(2));
      expect(metrics.qualifiedCount, equals(4));
      expect(metrics.hotCount, equals(4));
      expect(metrics.conversionRate, closeTo(33.33, 0.01));
      expect(metrics.totalPipelinePotential, equals(75200.0));

      final json = metrics.toJson();
      expect(json['totalCount'], equals(12));
      expect(json['totalPipelinePotential'], equals(75200.0));
    });

    test('AppPermissions includes all required CRM Leads operations', () {
      expect(AppPermissions.crmLeadsView, equals('leads.view'));
      expect(AppPermissions.crmLeadsCreate, equals('leads.create'));
      expect(AppPermissions.crmLeadsUpdate, equals('leads.update'));
      expect(AppPermissions.crmLeadsDelete, equals('leads.delete'));
      expect(AppPermissions.crmLeadsPromote, equals('leads.promote'));

      expect(AppPermissions.all, contains(AppPermissions.crmLeadsView));
      expect(AppPermissions.all, contains(AppPermissions.crmLeadsCreate));
      expect(AppPermissions.all, contains(AppPermissions.crmLeadsUpdate));
      expect(AppPermissions.all, contains(AppPermissions.crmLeadsDelete));
      expect(AppPermissions.all, contains(AppPermissions.crmLeadsPromote));
    });

    test('CrmLead copyWith updates status, temperature and promotion status', () {
      final now = DateTime.now().toUtc();
      final lead = CrmLead(
        code: 'PROSP-002',
        company: 'GINOFIV',
        sector: 'Clínicas y centros médicos',
        advisor: 'Vanessa Requejo',
        address: 'Av. Alemana',
        phone: '79683941',
        contactPerson: 'Ing. Sandra Hurtado',
        status: 'Prospectado',
        temperature: 'Frío',
        estimatedValue: 9200.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final promoted = lead.copyWith(
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        isPromoted: true,
        promotedOpportunityId: 105,
      );

      expect(promoted.status, equals('Interesado (Calificado)'));
      expect(promoted.temperature, equals('Caliente'));
      expect(promoted.isPromoted, isTrue);
      expect(promoted.promotedOpportunityId, equals(105));
    });
  });
}
