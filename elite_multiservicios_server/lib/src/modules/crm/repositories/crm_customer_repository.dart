import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Capa de persistencia y lógica de negocio para Clientes 360° en PostgreSQL.
class CrmCustomerDataService {
  final Session session;

  const CrmCustomerDataService(this.session);

  /// Lista los clientes activos con filtros avanzados y búsqueda en tiempo real.
  Future<List<CrmCustomer>> listCustomers({
    int limit = 100,
    int offset = 0,
    String? search,
    String? segment,
    String? status,
  }) async {
    return await CrmCustomer.db.find(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);

        if (segment != null && segment != 'Todos') {
          filter = filter & t.segment.equals(segment);
        }

        if (status != null && status != 'Todos') {
          filter = filter & t.status.equals(status);
        }

        if (search != null && search.trim().isNotEmpty) {
          final q = '%${search.trim()}%';
          final searchExpr =
              t.legalName.ilike(q) |
              t.tradeName.ilike(q) |
              t.taxId.ilike(q) |
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

  /// Obtiene la ficha 360° completa de un cliente hidratando sedes y contratos.
  Future<CrmCustomerDetailResponse?> getCustomerDetail(int customerId) async {
    final customer = await CrmCustomer.db.findFirstRow(
      session,
      where: (t) => t.id.equals(customerId) & t.isDeleted.equals(false),
    );
    if (customer == null) return null;

    final branches = await CrmCustomerBranch.db.find(
      session,
      where: (t) => t.customerId.equals(customerId) & t.isDeleted.equals(false),
      orderBy: (t) => t.isHeadquarters,
      orderDescending: true,
    );

    final contracts = await CrmCustomerContract.db.find(
      session,
      where: (t) => t.customerId.equals(customerId) & t.isDeleted.equals(false),
      orderBy: (t) => t.startDate,
      orderDescending: true,
    );

    final contractIds = contracts.map((c) => c.id!).toList();
    List<CrmContractBudgetItem> budgetItems = [];
    if (contractIds.isNotEmpty) {
      budgetItems = await CrmContractBudgetItem.db.find(
        session,
        where: (t) =>
            t.contractId.inSet(contractIds.toSet()) & t.isDeleted.equals(false),
      );
    }

    return CrmCustomerDetailResponse(
      customer: customer,
      branches: branches,
      contracts: contracts,
      budgetItems: budgetItems,
    );
  }

  /// Obtiene un cliente por su ID primario.
  Future<CrmCustomer?> getCustomerById(int customerId) async {
    return await CrmCustomer.db.findFirstRow(
      session,
      where: (t) => t.id.equals(customerId) & t.isDeleted.equals(false),
    );
  }

  /// Busca un cliente por NIT o coincidencia exacta de nombre comercial/razón social.
  Future<CrmCustomer?> findCustomerByTaxIdOrName({
    String? taxId,
    String? name,
  }) async {
    return await CrmCustomer.db.findFirstRow(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);
        if (taxId != null && taxId.trim().isNotEmpty) {
          filter = filter & t.taxId.equals(taxId.trim());
        } else if (name != null && name.trim().isNotEmpty) {
          final n = name.trim();
          filter = filter & (t.tradeName.ilike(n) | t.legalName.ilike(n));
        }
        return filter;
      },
    );
  }

  /// Registra un nuevo Cliente 360° con código secuencial CLI-XXX.
  Future<CrmCustomer> createCustomer(
    CrmCustomer customer, {
    CrmCustomerBranch? initialBranch,
    CrmCustomerContract? initialContract,
  }) async {
    final count = await CrmCustomer.db.count(session);
    final nextCode = customer.code.isNotEmpty
        ? customer.code
        : 'CLI-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now().toUtc();
    final toInsert = customer.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    final insertedCustomer = await CrmCustomer.db.insertRow(session, toInsert);

    // Si viene con sede inicial, la registramos
    CrmCustomerBranch? insertedBranch;
    if (initialBranch != null) {
      final bCount = await CrmCustomerBranch.db.count(session);
      final bCode = initialBranch.code.isNotEmpty
          ? initialBranch.code
          : 'BR-${(bCount + 1).toString().padLeft(3, '0')}';

      insertedBranch = await CrmCustomerBranch.db.insertRow(
        session,
        initialBranch.copyWith(
          code: bCode,
          customerId: insertedCustomer.id!,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        ),
      );
    }

    // Si viene con contrato inicial, lo registramos
    if (initialContract != null) {
      final cCount = await CrmCustomerContract.db.count(session);
      final cCode = initialContract.code.isNotEmpty
          ? initialContract.code
          : 'CTR-${(cCount + 1).toString().padLeft(3, '0')}';

      await CrmCustomerContract.db.insertRow(
        session,
        initialContract.copyWith(
          code: cCode,
          customerId: insertedCustomer.id!,
          branchId: insertedBranch?.id ?? initialContract.branchId,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        ),
      );
    }

    return insertedCustomer;
  }

  /// Actualiza los datos generales de un cliente.
  Future<CrmCustomer> updateCustomer(CrmCustomer customer) async {
    final toUpdate = customer.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmCustomer.db.updateRow(session, toUpdate);
  }

  /// Eliminación lógica (Soft Delete) del cliente y cascada sobre sedes y contratos.
  Future<bool> deleteCustomer(int customerId) async {
    final existing = await getCustomerById(customerId);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await CrmCustomer.db.updateRow(
      session,
      existing.copyWith(isDeleted: true, updatedAt: now),
    );

    // Marcar sedes asociadas como eliminadas
    final branches = await CrmCustomerBranch.db.find(
      session,
      where: (t) => t.customerId.equals(customerId) & t.isDeleted.equals(false),
    );
    for (final b in branches) {
      await CrmCustomerBranch.db.updateRow(
        session,
        b.copyWith(isDeleted: true, updatedAt: now),
      );
    }

    // Marcar contratos asociados como eliminados
    final contracts = await CrmCustomerContract.db.find(
      session,
      where: (t) => t.customerId.equals(customerId) & t.isDeleted.equals(false),
    );
    for (final c in contracts) {
      await CrmCustomerContract.db.updateRow(
        session,
        c.copyWith(isDeleted: true, updatedAt: now),
      );
    }

    return true;
  }

  // ===========================================================================
  // GESTIÓN DE SEDES OPERATIVAS (CUSTOMER BRANCHES)
  // ===========================================================================

  /// Agrega una sede operativa a un cliente.
  Future<CrmCustomerBranch> addBranch(CrmCustomerBranch branch) async {
    final count = await CrmCustomerBranch.db.count(session);
    final nextCode = branch.code.isNotEmpty
        ? branch.code
        : 'BR-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now().toUtc();
    final toInsert = branch.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmCustomerBranch.db.insertRow(session, toInsert);
  }

  /// Actualiza una sede operativa existente.
  Future<CrmCustomerBranch> updateBranch(CrmCustomerBranch branch) async {
    final toUpdate = branch.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmCustomerBranch.db.updateRow(session, toUpdate);
  }

  /// Eliminación lógica de una sede operativa.
  Future<bool> deleteBranch(int branchId) async {
    final existing = await CrmCustomerBranch.db.findFirstRow(
      session,
      where: (t) => t.id.equals(branchId) & t.isDeleted.equals(false),
    );
    if (existing == null) return false;

    await CrmCustomerBranch.db.updateRow(
      session,
      existing.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
    );
    return true;
  }

  // ===========================================================================
  // GESTIÓN DE CONTRATOS Y ÓRDENES DE TRABAJO (CUSTOMER CONTRACTS)
  // ===========================================================================

  /// Registra un contrato u orden de trabajo con sus partidas presupuestarias opcionales.
  Future<CrmCustomerContract> addContract(
    CrmCustomerContract contract, {
    List<CrmContractBudgetItem>? budgetItems,
  }) async {
    final count = await CrmCustomerContract.db.count(session);
    final nextCode = contract.code.isNotEmpty
        ? contract.code
        : 'CTR-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now().toUtc();
    final toInsert = contract.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    final insertedContract = await CrmCustomerContract.db.insertRow(
      session,
      toInsert,
    );

    if (budgetItems != null && budgetItems.isNotEmpty) {
      for (final item in budgetItems) {
        await CrmContractBudgetItem.db.insertRow(
          session,
          item.copyWith(
            contractId: insertedContract.id!,
            createdAt: now,
            updatedAt: now,
            isDeleted: false,
          ),
        );
      }
    }

    // Asegurar que la categoría del servicio esté reflejada en el cliente
    final customer = await getCustomerById(contract.customerId);
    if (customer != null &&
        !customer.activeServices.contains(contract.serviceCategory)) {
      final updatedServices = List<String>.from(customer.activeServices)
        ..add(contract.serviceCategory);
      await updateCustomer(customer.copyWith(activeServices: updatedServices));
    }

    return insertedContract;
  }

  /// Actualiza un contrato existente.
  Future<CrmCustomerContract> updateContract(
    CrmCustomerContract contract,
  ) async {
    final toUpdate = contract.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmCustomerContract.db.updateRow(session, toUpdate);
  }

  /// Conclusión formal de un contrato u orden de trabajo con acta de conformidad y calificación.
  Future<CrmCustomerContract?> completeContract(
    int contractId, {
    required DateTime actualEndDate,
    String? completionNotes,
    int satisfactionRating = 5,
    String? completedBy,
  }) async {
    final existing = await CrmCustomerContract.db.findFirstRow(
      session,
      where: (t) => t.id.equals(contractId) & t.isDeleted.equals(false),
    );
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: 'Completado',
      actualEndDate: actualEndDate,
      completionNotes: completionNotes,
      satisfactionRating: satisfactionRating,
      completedBy: completedBy ?? 'Operaciones',
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmCustomerContract.db.updateRow(session, updated);
  }

  /// Renovación directa de un contrato recurrente (+6 o +12 meses).
  Future<CrmCustomerContract?> renewContract(
    int contractId, {
    required int additionalMonths,
    double? adjustedMonthlyAmount,
    String? notes,
  }) async {
    final existing = await CrmCustomerContract.db.findFirstRow(
      session,
      where: (t) => t.id.equals(contractId) & t.isDeleted.equals(false),
    );
    if (existing == null) return null;

    final newExecution = 'Renovado +$additionalMonths meses';
    final newMonthly = adjustedMonthlyAmount ?? existing.recurringMonthlyAmount;

    final updated = existing.copyWith(
      status: 'Vigente',
      executionTime: newExecution,
      recurringMonthlyAmount: newMonthly,
      originType: 'Renovación',
      notes:
          notes ?? 'Contrato renovado por $additionalMonths meses adicionales.',
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmCustomerContract.db.updateRow(session, updated);
  }

  /// Cambio de estado puntual de un contrato (Pausar / Reactivar).
  Future<CrmCustomerContract?> updateContractStatus(
    int contractId,
    String newStatus,
  ) async {
    final existing = await CrmCustomerContract.db.findFirstRow(
      session,
      where: (t) => t.id.equals(contractId) & t.isDeleted.equals(false),
    );
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmCustomerContract.db.updateRow(session, updated);
  }

  // ===========================================================================
  // PARTIDAS PRESUPUESTARIAS (CONTRACT BUDGET ITEMS)
  // ===========================================================================

  /// Agrega una partida presupuestaria a un contrato.
  Future<CrmContractBudgetItem> addBudgetItem(
    CrmContractBudgetItem item,
  ) async {
    final now = DateTime.now().toUtc();
    final toInsert = item.copyWith(
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );
    return await CrmContractBudgetItem.db.insertRow(session, toInsert);
  }

  /// Eliminación lógica de una partida presupuestaria.
  Future<bool> deleteBudgetItem(int itemId) async {
    final existing = await CrmContractBudgetItem.db.findFirstRow(
      session,
      where: (t) => t.id.equals(itemId) & t.isDeleted.equals(false),
    );
    if (existing == null) return false;

    await CrmContractBudgetItem.db.updateRow(
      session,
      existing.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
    );
    return true;
  }

  // ===========================================================================
  // MÉTRICAS AGREGADAS DEL DIRECTORIO 360°
  // ===========================================================================

  /// Consolida métricas financieras y operativas del módulo en tiempo real.
  Future<CrmCustomerMetricsResponse> getMetrics() async {
    final activeCustomers = await CrmCustomer.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalActiveCustomers = activeCustomers
        .where((c) => c.status == 'Activo')
        .length;
    final totalB2b = activeCustomers
        .where((c) => c.segment == 'Corporativo B2B')
        .length;
    final totalB2c = activeCustomers
        .where((c) => c.segment == 'Residencial B2C')
        .length;

    final allBranches = await CrmCustomerBranch.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final allContracts = await CrmCustomerContract.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalBranches = allBranches.length;
    final totalContracts = allContracts.length;

    // MRR mensual de contratos vigentes o en ejecución
    final activeContracts = allContracts
        .where((c) => c.status == 'Vigente' || c.status == 'En Ejecución')
        .toList();

    final totalMrr = activeContracts.fold<double>(
      0.0,
      (acc, c) => acc + c.recurringMonthlyAmount,
    );

    // Volumen acumulado de obras / eventos únicos
    final totalProjectVolume = allContracts.fold<double>(
      0.0,
      (acc, c) => acc + c.oneTimeAmount,
    );

    // Contratos por vencer o listos para recontratar
    final expiringContractsCount = activeContracts.where((c) {
      final text = '${c.executionTime} ${c.notes ?? ''} ${c.endDate ?? ''}'
          .toLowerCase();
      return text.contains('vence') ||
          text.contains('renovación') ||
          text.contains('próximo');
    }).length;

    final readyToRenewCount = allContracts
        .where((c) => c.status == 'Completado')
        .length;

    return CrmCustomerMetricsResponse(
      totalActiveCustomers: totalActiveCustomers,
      totalMrr: totalMrr,
      totalProjectVolume: totalProjectVolume,
      totalBranches: totalBranches,
      totalContracts: totalContracts,
      totalB2b: totalB2b,
      totalB2c: totalB2c,
      expiringContractsCount: expiringContractsCount,
      readyToRenewCount: readyToRenewCount,
    );
  }
}
