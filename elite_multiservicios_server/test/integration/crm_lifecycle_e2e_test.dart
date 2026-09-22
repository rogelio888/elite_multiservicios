import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/crm/repositories/crm_customer_repository.dart';
import 'package:elite_multiservicios_server/src/modules/crm/repositories/crm_pipeline_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'CRM Lifecycle End-to-End & Zero-Mock Verification',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo continuo: Catálogo Maestro -> Lead (Origen & Servicio) -> Oportunidad con Parámetros Operativos -> Cliente 360° & Contrato con Partidas Vinculadas',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'crmPipeline',
                    method: 'promoteToCustomer',
                  )
                  as Session;

          final now = DateTime.now().toUtc();

          // ===================================================================
          // PASO 1: Catálogo Maestro - Línea de Servicio y Partida en PostgreSQL
          // ===================================================================
          final serviceLine = await CrmServiceLine.db.insertRow(
            session,
            CrmServiceLine(
              code: 'SRV-E2E-HVAC',
              name: 'Climatización Industrial',
              category: 'Mantenimiento',
              description:
                  'Línea especializada de climatización y aire acondicionado',
              isActive: true,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(serviceLine.id, isNotNull);

          final catItem = await CrmCatalogItem.db.insertRow(
            session,
            CrmCatalogItem(
              code: 'E2E-HVAC-01',
              category: 'Mantenimiento',
              serviceLineId: serviceLine.id!,
              concept: 'Mantenimiento Preventivo y Correctivo HVAC',
              calculationType: 'PER_UNIT',
              unitType: 'Mes',
              basePrice: 3500.0,
              minQuantity: 1.0,
              version: 1,
              description:
                  'Servicio técnico especializado en climatización industrial',
              isActive: true,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(catItem.id, isNotNull);
          expect(
            catItem.concept,
            equals('Mantenimiento Preventivo y Correctivo HVAC'),
          );

          // ===================================================================
          // PASO 2: Prospecto - Captación con Canal de Origen y Servicio Solicitado
          // ===================================================================
          final lead = await CrmLead.db.insertRow(
            session,
            CrmLead(
              code: 'LEAD-E2E-001',
              company: 'Torre Corporativa Platinum',
              contactPerson: 'Ing. Rodrigo Salinas',
              emailOrWeb: 'rsalinas@torreplatinum.bo',
              phone: '70011223',
              sector: 'Corporativo',
              advisor: 'Claudia Reyes',
              address: 'Av. San Martín #450, Equipetrol',
              origin: 'Sitio Web',
              requestedService: 'Climatización Industrial',
              status: 'Prospectado',
              temperature: 'Caliente',
              notes: 'Interesado en mantenimiento anual de sistema HVAC',
              estimatedValue: 42000.0,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(lead.id, isNotNull);
          expect(lead.origin, equals('Sitio Web'));
          expect(lead.requestedService, equals('Climatización Industrial'));

          // ===================================================================
          // PASO 3: Oportunidad en Pipeline - Compuertas con Parámetros Operativos
          // ===================================================================
          final opp = await CrmOpportunity.db.insertRow(
            session,
            CrmOpportunity(
              code: 'OPP-E2E-001',
              leadId: lead.id,
              title: 'Mantenimiento Climatización Torre Platinum',
              clientName: lead.company,
              contactPerson: lead.contactPerson,
              phone: lead.phone,
              stage: 'Negociación',
              contractType: 'Recurrente Mensual',
              serviceType: 'Mantenimiento',
              // Parámetros operativos y de facturación acordados:
              serviceFrequency: 'Lunes a Sábado',
              scheduleHours: '07:00 - 19:00',
              billingCycleDay: 10,
              specificRequirements:
                  'Técnicos con certificación de trabajo en altura y seguro de riesgos.',
              amount: 42000.0,
              probability: 90,
              owner: 'Claudia Reyes',
              closingDate: '31/12/2026',
              paymentTerms: '30 días fecha factura',
              advancePercentage: 0,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(opp.id, isNotNull);
          expect(opp.serviceFrequency, equals('Lunes a Sábado'));
          expect(opp.scheduleHours, equals('07:00 - 19:00'));
          expect(opp.billingCycleDay, equals(10));
          expect(opp.specificRequirements, contains('trabajo en altura'));

          // Partida cotizada vinculada al Catálogo Maestro
          final quoteItem = await CrmQuoteItem.db.insertRow(
            session,
            CrmQuoteItem(
              opportunityId: opp.id!,
              catalogItemId: catItem.id,
              category: catItem.category,
              concept: catItem.concept,
              calculationType: catItem.calculationType,
              unitType: catItem.unitType,
              quantity: 12.0,
              unitPrice: catItem.basePrice,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(quoteItem.id, isNotNull);
          expect(quoteItem.catalogItemId, equals(catItem.id));

          // ===================================================================
          // PASO 4: Promoción a Cliente 360° & Contrato Adjudicado
          // ===================================================================
          final pipelineService = CrmPipelineDataService(session);
          final customerDetail = await pipelineService.promoteToCustomer(
            opp.id!,
          );

          expect(customerDetail, isNotNull);
          final customer = customerDetail!.customer;
          expect(customer.tradeName, equals('Torre Corporativa Platinum'));
          expect(customer.activeServices, contains('Mantenimiento'));

          // Verificar que el contrato se creó con los datos operativos completos
          expect(customerDetail.contracts.length, greaterThanOrEqualTo(1));
          final contract = customerDetail.contracts.firstWhere(
            (c) => c.title == opp.title,
          );
          expect(contract.status, equals('Vigente'));
          expect(contract.serviceFrequency, equals('Lunes a Sábado'));
          expect(contract.scheduleHours, equals('07:00 - 19:00'));
          expect(contract.billingCycleDay, equals(10));
          expect(contract.specificRequirements, contains('trabajo en altura'));

          // ===================================================================
          // PASO 5: Verificación de Partida Presupuestaria Vinculada en BD
          // ===================================================================
          final budgetItems = await CrmContractBudgetItem.db.find(
            session,
            where: (t) =>
                t.contractId.equals(contract.id!) & t.isDeleted.equals(false),
          );
          expect(budgetItems.length, equals(1));
          final bItem = budgetItems.first;
          expect(
            bItem.catalogItemId,
            equals(catItem.id),
          ); // service_id referenciado
          expect(bItem.unitPrice, equals(3500.0));
          expect(bItem.quantity, equals(12.0));
          expect(bItem.unit, equals('Mes'));
          expect(bItem.description, contains('HVAC'));

          // ===================================================================
          // PASO 6: Contrato Manual Directo con Selector de Catálogo (Fase 5)
          // ===================================================================
          final customerService = CrmCustomerDataService(session);
          final directContract = await customerService.addContract(
            CrmCustomerContract(
              code: 'CTR-E2E-DIRECT-002',
              customerId: customer.id!,
              title: 'Limpieza de Fachada y Vidrios en Altura',
              contractType: 'Servicio Puntual / Evento',
              serviceCategory: 'Limpieza Especializada',
              serviceFrequency: 'Evento Único',
              scheduleHours: 'Sábado 08:00 - 18:00',
              billingCycleDay: 1,
              specificRequirements:
                  'Uso de andamios certificados y arnés doble línea.',
              totalAmount: 8500.0,
              recurringMonthlyAmount: 0.0,
              oneTimeAmount: 8500.0,
              paymentTerms: '50% anticipo, 50% contra entrega',
              executionTime: '1 fin de semana',
              advancePercentage: 50,
              status: 'Vigente',
              startDate: now,
              originType: 'Directo',
              notes: 'Contrato manual con partida del Catálogo Maestro.',
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
            budgetItems: [
              CrmContractBudgetItem(
                contractId: 0,
                catalogItemId: catItem.id,
                description: 'Limpieza especializada de fachada',
                quantity: 1,
                unit: 'Global',
                unitPrice: 8500.0,
                isDeleted: false,
                createdAt: now,
                updatedAt: now,
              ),
            ],
          );

          expect(directContract.id, isNotNull);
          expect(directContract.serviceFrequency, equals('Evento Único'));
          expect(directContract.billingCycleDay, equals(1));
          expect(
            directContract.specificRequirements,
            contains('andamios certificados'),
          );

          final directBudgetItems = await CrmContractBudgetItem.db.find(
            session,
            where: (t) =>
                t.contractId.equals(directContract.id!) &
                t.isDeleted.equals(false),
          );
          expect(directBudgetItems.length, equals(1));
          expect(directBudgetItems.first.catalogItemId, equals(catItem.id));
          expect(directBudgetItems.first.unitPrice, equals(8500.0));
        },
      );
    },
  );
}
