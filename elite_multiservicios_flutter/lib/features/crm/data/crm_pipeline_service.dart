import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart' show client;
import '../presentation/views/crm_pipeline_view.dart'
    show OpportunityItem, QuoteItem;

/// Servicio singleton reactivo para la gestión de Oportunidades y Pipeline Comercial
/// conectado directamente a los endpoints RPC de Serverpod y PostgreSQL.
class CrmPipelineService extends ChangeNotifier {
  static final CrmPipelineService _instance = CrmPipelineService._internal();
  factory CrmPipelineService({Client? customClient}) {
    if (customClient != null) {
      _instance._clientOverride = customClient;
    }
    return _instance;
  }

  CrmPipelineService._internal();

  Client? _clientOverride;
  Client get _activeClient => _clientOverride ?? client;

  final List<OpportunityItem> _deals = [];
  bool _isLoading = false;
  String? _error;
  CrmPipelineMetricsResponse? _metrics;

  List<OpportunityItem> get deals => List.unmodifiable(_deals);
  bool get isLoading => _isLoading;
  String? get error => _error;
  CrmPipelineMetricsResponse? get metrics => _metrics;

  /// Carga la lista de oportunidades reales desde PostgreSQL vía Serverpod RPC.
  Future<void> loadDeals({
    String? search,
    String? serviceType,
    String? stage,
    String? owner,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final remoteOpportunities = await _activeClient.crmPipeline
          .listOpportunities(
            limit: 200,
            offset: 0,
            search: search,
            serviceType: serviceType,
            stage: stage,
            owner: owner,
          );

      final List<OpportunityItem> freshList = [];
      for (final opp in remoteOpportunities) {
        List<QuoteItem> quoteItems = [];
        if (opp.id != null) {
          try {
            final remoteItems = await _activeClient.crmPipeline.getQuoteItems(
              opp.id!,
            );
            quoteItems = remoteItems
                .map(
                  (qi) => QuoteItem(
                    id: qi.id?.toString() ?? '',
                    category: qi.category,
                    concept: qi.concept,
                    unitType: qi.unitType,
                    quantity: qi.quantity,
                    unitPrice: qi.unitPrice,
                    catalogItemId: qi.catalogItemId,
                    catalogVersion: qi.catalogVersion,
                    calculationType: qi.calculationType,
                    metadata: qi.metadata,
                  ),
                )
                .toList();
          } catch (_) {}
        }
        freshList.add(_opportunityFromCrm(opp, quoteItems: quoteItems));
      }

      final Map<String, OpportunityItem> uniqueMap = {};
      for (final item in freshList) {
        uniqueMap[item.id] = item;
      }

      _deals.clear();
      _deals.addAll(uniqueMap.values);

      try {
        _metrics = await _activeClient.crmPipeline.getMetrics();
      } catch (e) {
        debugPrint(
          '[CrmPipelineService] Error al obtener métricas de pipeline: $e',
        );
      }
    } catch (e) {
      debugPrint('[CrmPipelineService] Error al cargar oportunidades: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registra una nueva oportunidad en PostgreSQL.
  Future<OpportunityItem?> addDeal(OpportunityItem deal) async {
    try {
      final crmOpp = _opportunityToCrm(deal);
      final crmItems = deal.quoteItems.isNotEmpty
          ? deal.quoteItems
                .map(
                  (q) => CrmQuoteItem(
                    opportunityId: 0,
                    category: q.category,
                    concept: q.concept,
                    unitType: q.unitType,
                    quantity: q.quantity,
                    unitPrice: q.unitPrice,
                    catalogItemId: q.catalogItemId,
                    catalogVersion: q.catalogVersion,
                    calculationType: q.calculationType,
                    metadata: q.metadata,
                    createdAt: DateTime.now().toUtc(),
                    updatedAt: DateTime.now().toUtc(),
                    isDeleted: false,
                  ),
                )
                .toList()
          : null;
      final created = await _activeClient.crmPipeline.createOpportunity(
        crmOpp,
        quoteItems: crmItems,
      );
      final model = _opportunityFromCrm(created, quoteItems: deal.quoteItems);
      _deals.insert(0, model);
      notifyListeners();
      await loadDeals();
      return model;
    } catch (e) {
      debugPrint('[CrmPipelineService] Error al registrar oportunidad: $e');
      _error = e.toString();
      rethrow;
    }
  }

  /// Actualiza los datos generales de una oportunidad en PostgreSQL.
  Future<void> updateDeal(OpportunityItem updated) async {
    try {
      final crmOpp = _opportunityToCrm(updated);
      final rawOppId =
          int.tryParse(updated.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final crmItems = updated.quoteItems.isNotEmpty
          ? updated.quoteItems
                .map(
                  (q) => CrmQuoteItem(
                    opportunityId: rawOppId,
                    category: q.category,
                    concept: q.concept,
                    unitType: q.unitType,
                    quantity: q.quantity,
                    unitPrice: q.unitPrice,
                    catalogItemId: q.catalogItemId,
                    catalogVersion: q.catalogVersion,
                    calculationType: q.calculationType,
                    metadata: q.metadata,
                    createdAt: DateTime.now().toUtc(),
                    updatedAt: DateTime.now().toUtc(),
                    isDeleted: false,
                  ),
                )
                .toList()
          : null;
      final res = await _activeClient.crmPipeline.updateOpportunity(
        crmOpp,
        quoteItems: crmItems,
      );
      final idx = _deals.indexWhere(
        (d) => d.id == updated.id || (d.id == res.code),
      );
      if (idx != -1) {
        _deals[idx] = _opportunityFromCrm(res, quoteItems: updated.quoteItems);
      }
      notifyListeners();
      await loadDeals();
    } catch (e) {
      debugPrint('[CrmPipelineService] Error al actualizar oportunidad: $e');
      _error = e.toString();
      rethrow;
    }
  }

  /// Mueve una oportunidad de etapa en el embudo comercial (Kanban).
  Future<void> moveDeal(OpportunityItem deal, String newStage) async {
    final idx = _deals.indexWhere((d) => d.id == deal.id);
    int newProb = deal.probability;
    if (newStage == 'Calificación') newProb = 20;
    if (newStage == 'Visita Técnica') newProb = 40;
    if (newStage == 'Propuesta') newProb = 60;
    if (newStage == 'Negociación') newProb = 80;
    if (newStage == 'Ganada') newProb = 100;

    final updatedLocal = deal.copyWith(stage: newStage, probability: newProb);
    if (idx != -1) {
      _deals[idx] = updatedLocal;
      notifyListeners();
    }

    try {
      await updateDeal(updatedLocal);
    } catch (e) {
      debugPrint(
        '[CrmPipelineService] Error al persistir movimiento de etapa: $e',
      );
      _error = e.toString();
    }
  }

  /// Reabre una oportunidad ganada de regreso a la etapa de 'Negociación'.
  Future<void> reopenDealToNegotiation(
    String dealId, {
    required String reason,
  }) async {
    final idx = _deals.indexWhere((d) => d.id == dealId);
    if (idx == -1) return;
    final deal = _deals[idx];
    final updatedNotes = deal.notes.isNotEmpty
        ? '${deal.notes}\n[Reapertura desde Clientes 360°]: $reason'
        : '[Reapertura desde Clientes 360°]: $reason';
    final updated = deal.copyWith(
      stage: 'Negociación',
      probability: 80,
      notes: updatedNotes,
    );
    _deals[idx] = updated;
    notifyListeners();
    try {
      await updateDeal(updated);
    } catch (e) {
      debugPrint('[CrmPipelineService] Error al reabrir oportunidad: $e');
      _error = e.toString();
    }
  }

  /// Promueve una oportunidad ganada a Cliente 360° en PostgreSQL.
  Future<CrmCustomerDetailResponse?> promoteToCustomer(
    OpportunityItem deal, {
    String? wonNotes,
  }) async {
    try {
      final rawId = int.tryParse(deal.id.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawId == null || rawId <= 0) {
        throw Exception(
          'ID de oportunidad inválido para promoción a Cliente 360°',
        );
      }

      final response = await _activeClient.crmPipeline.promoteToCustomer(rawId);

      await loadDeals();
      return response;
    } catch (e) {
      debugPrint('[CrmPipelineService] Error al promover a cliente: $e');
      _error = e.toString();
      rethrow;
    }
  }

  // --- Mappers ---

  static OpportunityItem _opportunityFromCrm(
    CrmOpportunity opp, {
    List<QuoteItem>? quoteItems,
  }) {
    return OpportunityItem(
      id: opp.code.isNotEmpty ? opp.code : (opp.id?.toString() ?? ''),
      title: opp.title,
      clientName: opp.clientName,
      contactPerson: opp.contactPerson,
      phone: opp.phone,
      serviceType: opp.serviceType,
      amount: opp.amount,
      stage: opp.stage,
      probability: opp.probability,
      owner: opp.owner,
      closingDate: opp.closingDate,
      notes: opp.notes ?? '',
      contractType: opp.contractType,
      serviceFrequency: opp.serviceFrequency,
      scheduleHours: opp.scheduleHours,
      billingCycleDay: opp.billingCycleDay,
      specificRequirements: opp.specificRequirements,
      executionTime: opp.executionTime,
      paymentTerms: opp.paymentTerms,
      advancePercentage: opp.advancePercentage,
      quoteItems: quoteItems ?? const [],
      contactRole: opp.contactRole,
      businessSegment: opp.businessSegment,
      siteName: opp.siteName ?? '',
      siteAddress: opp.siteAddress ?? '',
      siteCity: opp.siteCity,
      siteContactName: opp.siteContactName ?? '',
      siteContactPhone: opp.siteContactPhone ?? '',
      siteAccessRequirements: opp.siteAccessRequirements ?? '',
      isSiteHeadquarters: opp.isSiteHeadquarters,
      legalBusinessName: opp.legalBusinessName ?? '',
      taxId: opp.taxId ?? '',
      legalRepresentative: opp.legalRepresentative ?? '',
      billingEmail: opp.billingEmail ?? '',
      serviceStartDate: opp.serviceStartDate ?? '',
      advancePaid: opp.advancePaid,
      wonNotes: opp.wonNotes ?? '',
      customerId: opp.customerId != null
          ? 'CLI-${opp.customerId.toString().padLeft(3, '0')}'
          : null,
      branchId: opp.branchId != null
          ? 'BR-${opp.branchId.toString().padLeft(3, '0')}'
          : null,
      branchName: opp.branchName,
    );
  }

  static CrmOpportunity _opportunityToCrm(OpportunityItem item) {
    final rawId = int.tryParse(item.id.replaceAll(RegExp(r'[^0-9]'), ''));
    final now = DateTime.now().toUtc();

    return CrmOpportunity(
      id: rawId != null && rawId > 0 ? rawId : null,
      code: item.id.startsWith('OPP') ? item.id : '',
      title: item.title,
      clientName: item.clientName,
      contactPerson: item.contactPerson,
      phone: item.phone,
      serviceType: item.serviceType,
      amount: item.amount,
      stage: item.stage,
      probability: item.probability,
      owner: item.owner,
      closingDate: item.closingDate,
      notes: item.notes.isNotEmpty ? item.notes : null,
      contractType: item.contractType,
      serviceFrequency: item.serviceFrequency,
      scheduleHours:
          item.scheduleHours != null && item.scheduleHours!.isNotEmpty
          ? item.scheduleHours
          : null,
      billingCycleDay: item.billingCycleDay,
      specificRequirements:
          item.specificRequirements != null &&
              item.specificRequirements!.isNotEmpty
          ? item.specificRequirements
          : null,
      executionTime: item.executionTime,
      paymentTerms: item.paymentTerms,
      advancePercentage: item.advancePercentage,
      contactRole: item.contactRole,
      businessSegment: item.businessSegment,
      siteName: item.siteName.isNotEmpty ? item.siteName : null,
      siteAddress: item.siteAddress.isNotEmpty ? item.siteAddress : null,
      siteCity: item.siteCity,
      siteContactName: item.siteContactName.isNotEmpty
          ? item.siteContactName
          : null,
      siteContactPhone: item.siteContactPhone.isNotEmpty
          ? item.siteContactPhone
          : null,
      siteAccessRequirements: item.siteAccessRequirements.isNotEmpty
          ? item.siteAccessRequirements
          : null,
      isSiteHeadquarters: item.isSiteHeadquarters,
      legalBusinessName: item.legalBusinessName.isNotEmpty
          ? item.legalBusinessName
          : null,
      taxId: item.taxId.isNotEmpty ? item.taxId : null,
      legalRepresentative: item.legalRepresentative.isNotEmpty
          ? item.legalRepresentative
          : null,
      billingEmail: item.billingEmail.isNotEmpty ? item.billingEmail : null,
      serviceStartDate: item.serviceStartDate.isNotEmpty
          ? item.serviceStartDate
          : null,
      advancePaid: item.advancePaid,
      wonNotes: item.wonNotes.isNotEmpty ? item.wonNotes : null,
      createdAt: now,
      updatedAt: now,
    );
  }
}
