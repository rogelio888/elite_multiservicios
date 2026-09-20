import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import 'crm_customer_repository.dart';

/// Capa de persistencia y lógica de negocio para el Pipeline de Ventas y Cotizador en PostgreSQL.
class CrmPipelineDataService {
  final Session session;

  const CrmPipelineDataService(this.session);

  /// Lista oportunidades con filtros avanzados por etapa, asesor, tipo de contrato y búsqueda.
  Future<List<CrmOpportunity>> listOpportunities({
    int limit = 100,
    int offset = 0,
    String? search,
    String? stage,
    String? owner,
    String? serviceType,
  }) async {
    return await CrmOpportunity.db.find(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);

        if (stage != null && stage != 'Todos') {
          filter = filter & t.stage.equals(stage);
        }

        if (owner != null && owner != 'Todos') {
          filter = filter & t.owner.equals(owner);
        }

        if (serviceType != null && serviceType != 'Todos') {
          filter = filter & t.serviceType.equals(serviceType);
        }

        if (search != null && search.trim().isNotEmpty) {
          final q = '%${search.trim()}%';
          final searchExpr =
              t.title.ilike(q) |
              t.clientName.ilike(q) |
              t.contactPerson.ilike(q) |
              t.phone.ilike(q) |
              t.code.ilike(q);
          filter = filter & searchExpr;
        }

        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Obtiene una oportunidad por su ID primario.
  Future<CrmOpportunity?> getOpportunityById(int id) async {
    return await CrmOpportunity.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Obtiene las líneas de cotización vinculadas a una oportunidad.
  Future<List<CrmQuoteItem>> getQuoteItems(int opportunityId) async {
    return await CrmQuoteItem.db.find(
      session,
      where: (t) =>
          t.opportunityId.equals(opportunityId) & t.isDeleted.equals(false),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Registra una nueva oportunidad en el Pipeline con código secuencial OPP-XXX.
  Future<CrmOpportunity> createOpportunity(
    CrmOpportunity opp, {
    List<CrmQuoteItem>? quoteItems,
  }) async {
    final count = await CrmOpportunity.db.count(session);
    final nextCode = opp.code.isNotEmpty
        ? opp.code
        : 'OPP-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now().toUtc();
    final toInsert = opp.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    final insertedOpp = await CrmOpportunity.db.insertRow(session, toInsert);

    if (quoteItems != null && quoteItems.isNotEmpty) {
      for (final item in quoteItems) {
        await CrmQuoteItem.db.insertRow(
          session,
          item.copyWith(
            opportunityId: insertedOpp.id!,
            createdAt: now,
            updatedAt: now,
            isDeleted: false,
          ),
        );
      }
    }

    return insertedOpp;
  }

  /// Actualiza los datos generales y compuertas de una oportunidad.
  Future<CrmOpportunity> updateOpportunity(
    CrmOpportunity opp, {
    List<CrmQuoteItem>? quoteItems,
  }) async {
    double finalAmount = opp.amount;
    if (quoteItems != null && quoteItems.isNotEmpty) {
      final itemsTotal = quoteItems.fold<double>(
        0.0,
        (acc, item) => acc + (item.quantity * item.unitPrice),
      );
      if (itemsTotal > 0) {
        finalAmount = itemsTotal;
      }
    } else if (finalAmount <= 0 && opp.id != null) {
      final existingItems = await getQuoteItems(opp.id!);
      final itemsTotal = existingItems.fold<double>(
        0.0,
        (acc, item) => acc + (item.quantity * item.unitPrice),
      );
      if (itemsTotal > 0) {
        finalAmount = itemsTotal;
      }
    }

    final toUpdate = opp.copyWith(
      amount: finalAmount,
      updatedAt: DateTime.now().toUtc(),
    );
    final updatedOpp = await CrmOpportunity.db.updateRow(session, toUpdate);

    if (quoteItems != null) {
      // Reemplazo de partidas de cotización
      final existingItems = await getQuoteItems(opp.id!);
      for (final item in existingItems) {
        await CrmQuoteItem.db.updateRow(
          session,
          item.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
        );
      }
      for (final item in quoteItems) {
        await CrmQuoteItem.db.insertRow(
          session,
          item.copyWith(
            opportunityId: opp.id!,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
            isDeleted: false,
          ),
        );
      }
    }

    return updatedOpp;
  }

  /// Actualiza la etapa o compuerta comercial de una oportunidad.
  Future<CrmOpportunity?> updateStage(int id, String newStage) async {
    final existing = await getOpportunityById(id);
    if (existing == null) return null;

    int newProb = existing.probability;
    switch (newStage) {
      case 'Calificación':
        newProb = 20;
        break;
      case 'Visita Técnica':
        newProb = 40;
        break;
      case 'Propuesta':
        newProb = 60;
        break;
      case 'Negociación':
        newProb = 80;
        break;
      case 'Ganada':
        newProb = 100;
        break;
    }

    double finalAmount = existing.amount;
    if (finalAmount <= 0) {
      final items = await getQuoteItems(id);
      if (items.isNotEmpty) {
        final itemsTotal = items.fold<double>(
          0.0,
          (acc, item) => acc + (item.quantity * item.unitPrice),
        );
        if (itemsTotal > 0) {
          finalAmount = itemsTotal;
        }
      }
    }

    final updated = existing.copyWith(
      stage: newStage,
      probability: newProb,
      amount: finalAmount,
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmOpportunity.db.updateRow(session, updated);
  }

  /// Traspaso formal y transaccional de una Oportunidad Ganada a Clientes 360°.
  /// Crea o vincula Cliente, Sede Operativa y Contrato/Presupuesto sin duplicar registros.
  Future<CrmCustomerDetailResponse?> promoteToCustomer(
    int opportunityId,
  ) async {
    final opp = await getOpportunityById(opportunityId);
    if (opp == null) return null;

    final customerService = CrmCustomerDataService(session);
    final now = DateTime.now().toUtc();

    // 1. Detectar si el cliente ya existe
    CrmCustomer? existingCustomer;
    if (opp.customerId != null) {
      existingCustomer = await customerService.getCustomerById(opp.customerId!);
    }
    existingCustomer ??= await customerService.findCustomerByTaxIdOrName(
      taxId: opp.taxId?.isNotEmpty == true ? opp.taxId : null,
      name: opp.clientName,
    );

    int customerId;
    int? branchId;

    if (existingCustomer == null) {
      // Crear cliente nuevo
      final newCustomer = await customerService.createCustomer(
        CrmCustomer(
          code: '',
          legalName: opp.legalBusinessName?.isNotEmpty == true
              ? opp.legalBusinessName!
              : opp.clientName,
          tradeName: opp.clientName,
          taxId: opp.taxId?.isNotEmpty == true
              ? opp.taxId!
              : 'NIT-${DateTime.now().millisecondsSinceEpoch % 1000000}',
          segment: opp.businessSegment.isNotEmpty
              ? opp.businessSegment
              : 'Corporativo B2B',
          status: 'Activo',
          activeServices: [opp.serviceType],
          contactPerson: opp.contactPerson,
          phone: opp.phone,
          email: opp.billingEmail?.isNotEmpty == true
              ? opp.billingEmail!
              : 'contacto@${opp.clientName.toLowerCase().replaceAll(RegExp(r'\s+'), '')}.bo',
          opportunityId: opp.id,
          startDate: now,
          notes:
              'Cliente incorporado automáticamente desde Pipeline Ganada (${opp.title}).',
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
      customerId = newCustomer.id!;

      // Crear sede inicial con datos de inspección
      final initialBranch = await customerService.addBranch(
        CrmCustomerBranch(
          code: '',
          customerId: customerId,
          name: opp.siteName?.isNotEmpty == true
              ? opp.siteName!
              : 'Sede Principal / ${opp.clientName}',
          address: opp.siteAddress?.isNotEmpty == true
              ? opp.siteAddress!
              : 'Dirección coordinada en inspección técnica',
          localContact: opp.siteContactName?.isNotEmpty == true
              ? opp.siteContactName!
              : opp.contactPerson,
          localPhone: opp.siteContactPhone?.isNotEmpty == true
              ? opp.siteContactPhone!
              : opp.phone,
          isHeadquarters: opp.isSiteHeadquarters,
          notes: opp.siteAccessRequirements,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
      branchId = initialBranch.id;
    } else {
      customerId = existingCustomer.id!;
      branchId = opp.branchId;
    }

    // 2. Crear contrato adjudicado
    final quoteItems = await getQuoteItems(opportunityId);
    final budgetItems = quoteItems
        .map(
          (q) => CrmContractBudgetItem(
            contractId: 0, // Se asigna en addContract
            description: '${q.category}: ${q.concept}',
            quantity: q.quantity,
            unit: q.unitType,
            unitPrice: q.unitPrice,
            isDeleted: false,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList();

    final isRecurring = opp.contractType.contains('Recurrente');
    final isProject =
        opp.contractType.contains('Proyecto') ||
        opp.contractType.contains('Evento');

    final contract = await customerService.addContract(
      CrmCustomerContract(
        code: '',
        customerId: customerId,
        branchId: branchId,
        title: opp.title,
        contractType: opp.contractType,
        serviceCategory: opp.serviceType,
        totalAmount: opp.amount,
        recurringMonthlyAmount: isRecurring ? (opp.amount / 12) : 0.0,
        oneTimeAmount: isProject ? opp.amount : 0.0,
        paymentTerms: opp.paymentTerms,
        executionTime: opp.executionTime,
        advancePercentage: opp.advancePercentage,
        status: 'Vigente',
        startDate: now,
        originType: 'Pipeline Ganada',
        notes: opp.wonNotes ?? 'Contrato adjudicado desde el Pipeline.',
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      budgetItems: budgetItems,
    );

    // 3. Marcar oportunidad como Ganada y vincular IDs
    await CrmOpportunity.db.updateRow(
      session,
      opp.copyWith(
        stage: 'Ganada',
        probability: 100,
        customerId: customerId,
        branchId: branchId,
        updatedAt: now,
      ),
    );

    // 4. Programar tarea de cobro de anticipo / inicio de servicio en la Agenda
    final taskCount = await CrmTask.db.count(session);
    final taskCode = 'TSK-${(taskCount + 1).toString().padLeft(3, '0')}';
    await CrmTask.db.insertRow(
      session,
      CrmTask(
        code: taskCode,
        title: 'Cobro de Anticipo / Inicio: ${opp.title}',
        taskType: 'Cobro / Seguimiento de Anticipo',
        clientName: opp.clientName,
        contactPerson: opp.contactPerson,
        phone: opp.phone,
        scheduledAt: now.add(const Duration(days: 1)),
        scheduledTimeText: '09:30',
        priority: 'Alta / Urgente',
        status: 'Pendiente',
        callContext:
            'Oportunidad adjudicada. Confirmar acreditación de anticipo del ${opp.advancePercentage}% e inicio de operaciones.',
        leadId: opp.leadId,
        opportunityId: opp.id,
        customerId: customerId,
        contractId: contract.id,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return await customerService.getCustomerDetail(customerId);
  }

  /// Eliminación lógica (Soft Delete) de una oportunidad y sus cotizaciones.
  Future<bool> deleteOpportunity(int id) async {
    final existing = await getOpportunityById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await CrmOpportunity.db.updateRow(
      session,
      existing.copyWith(isDeleted: true, updatedAt: now),
    );

    final items = await getQuoteItems(id);
    for (final item in items) {
      await CrmQuoteItem.db.updateRow(
        session,
        item.copyWith(isDeleted: true, updatedAt: now),
      );
    }

    return true;
  }

  /// Calcula las métricas agregadas del embudo y pipeline comercial en tiempo real.
  Future<CrmPipelineMetricsResponse> getPipelineMetrics() async {
    final activeOpps = await CrmOpportunity.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalOpps = activeOpps.length;
    final qualificationCount = activeOpps
        .where((o) => o.stage == 'Calificación')
        .length;
    final technicalVisitCount = activeOpps
        .where((o) => o.stage == 'Visita Técnica')
        .length;
    final proposalCount = activeOpps
        .where((o) => o.stage == 'Propuesta')
        .length;
    final negotiationCount = activeOpps
        .where((o) => o.stage == 'Negociación')
        .length;
    final wonCount = activeOpps.where((o) => o.stage == 'Ganada').length;

    final totalValue = activeOpps.fold<double>(
      0.0,
      (acc, o) => acc + o.amount,
    );

    final weightedValue = activeOpps.fold<double>(
      0.0,
      (acc, o) => acc + (o.amount * (o.probability / 100.0)),
    );

    final winRate = totalOpps > 0 ? (wonCount / totalOpps) * 100.0 : 0.0;

    return CrmPipelineMetricsResponse(
      totalOpportunities: totalOpps,
      totalPipelineValue: totalValue,
      weightedValue: weightedValue,
      qualificationCount: qualificationCount,
      technicalVisitCount: technicalVisitCount,
      proposalCount: proposalCount,
      negotiationCount: negotiationCount,
      wonCount: wonCount,
      winRate: winRate,
    );
  }
}
