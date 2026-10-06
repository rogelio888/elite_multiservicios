import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

class AccountingEndpoint extends Endpoint {
  /// Comprueba si una fecha cae dentro de un periodo contable cerrado y bloqueado
  Future<void> _assertPeriodNotLocked(Session session, DateTime date) async {
    final closures = await AccountingPeriodClosure.db.find(
      session,
      where: (t) =>
          t.isLocked.equals(true) & (t.startDate <= date) & (t.endDate >= date),
    );
    if (closures.isNotEmpty) {
      final period = closures.first;
      final startStr = period.startDate.toIso8601String().substring(0, 10);
      final endStr = period.endDate.toIso8601String().substring(0, 10);
      throw Exception(
        'Operación rechazada: El periodo contable "${period.periodName}" ($startStr a $endStr) está cerrado y bloqueado contra modificaciones.',
      );
    }
  }

  /// Obtener lista de centros de costo
  Future<List<AccountingCostCenter>> getCostCenters(Session session) async {
    return await AccountingCostCenter.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );
  }

  /// Crear centro de costo
  Future<AccountingCostCenter> createCostCenter(
    Session session,
    AccountingCostCenter costCenter,
  ) async {
    costCenter.createdAt = DateTime.now();
    costCenter.updatedAt = DateTime.now();
    return await AccountingCostCenter.db.insertRow(session, costCenter);
  }

  /// Obtener lista de facturas
  Future<List<AccountingInvoice>> getInvoices(Session session) async {
    return await AccountingInvoice.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
      orderBy: (t) => t.issueDate,
      orderDescending: true,
    );
  }

  /// Crear factura (con validación de periodo bloqueado)
  Future<AccountingInvoice> createInvoice(
    Session session,
    AccountingInvoice invoice,
  ) async {
    await _assertPeriodNotLocked(session, invoice.issueDate);
    invoice.createdAt = DateTime.now();
    invoice.updatedAt = DateTime.now();
    return await AccountingInvoice.db.insertRow(session, invoice);
  }

  /// Actualizar estado de factura
  Future<AccountingInvoice?> updateInvoiceStatus(
    Session session,
    int invoiceId,
    String status,
  ) async {
    var invoice = await AccountingInvoice.db.findById(session, invoiceId);
    if (invoice != null) {
      await _assertPeriodNotLocked(session, invoice.issueDate);
      invoice.status = status;
      invoice.updatedAt = DateTime.now();
      return await AccountingInvoice.db.updateRow(session, invoice);
    }
    return null;
  }

  /// Obtener lista de gastos
  Future<List<AccountingExpense>> getExpenses(Session session) async {
    return await AccountingExpense.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  /// Crear gasto (con validación de periodo bloqueado)
  Future<AccountingExpense> createExpense(
    Session session,
    AccountingExpense expense,
  ) async {
    await _assertPeriodNotLocked(session, expense.date);
    expense.createdAt = DateTime.now();
    expense.updatedAt = DateTime.now();
    return await AccountingExpense.db.insertRow(session, expense);
  }

  /// Obtener resumen financiero
  Future<AccountingFinancialSummary> getFinancialSummary(
    Session session,
  ) async {
    final invoices = await getInvoices(session);
    final expenses = await getExpenses(session);

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var invoice in invoices) {
      if (invoice.status == 'Paid') {
        totalIncome += invoice.totalAmount;
      }
    }

    for (var expense in expenses) {
      if (expense.status == 'Paid') {
        totalExpenses += expense.amount;
      }
    }

    final opportunities = await CrmOpportunity.db.find(session);
    double projectedInc = 0;
    for (var opp in opportunities) {
      if (opp.stage == 'Ganada' || opp.stage == 'Propuesta') {
        projectedInc += opp.amount;
      }
    }

    final pettyCash = await getPettyCash(session);
    double pCashBalance = pettyCash.fold(0.0, (sum, p) => sum + p.balance);

    return AccountingFinancialSummary(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      projectedIncome: projectedInc,
      projectedExpenses: totalExpenses * 1.2,
      pettyCashBalance: pCashBalance,
      balance: totalIncome - totalExpenses,
    );
  }

  /// Obtener Caja Chica
  Future<List<AccountingPettyCash>> getPettyCash(Session session) async {
    return await AccountingPettyCash.db.find(session);
  }

  /// Crear Caja Chica
  Future<AccountingPettyCash> createPettyCash(
    Session session,
    AccountingPettyCash pettyCash,
  ) async {
    return await AccountingPettyCash.db.insertRow(session, pettyCash);
  }

  /// Obtener transacciones de caja chica
  Future<List<AccountingPettyCashTransaction>> getPettyCashTransactions(
    Session session,
  ) async {
    return await AccountingPettyCashTransaction.db.find(
      session,
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  /// Agregar transacción de caja chica
  Future<AccountingPettyCashTransaction> addPettyCashTransaction(
    Session session,
    AccountingPettyCashTransaction transaction,
  ) async {
    await _assertPeriodNotLocked(session, transaction.date);

    return await session.db.transaction((txn) async {
      var pettyCash = await AccountingPettyCash.db.findById(
        session,
        transaction.pettyCashId,
        transaction: txn,
      );
      if (pettyCash != null) {
        if (transaction.type == 'EXPENSE') {
          pettyCash.balance -= transaction.amount;
        } else if (transaction.type == 'REPLENISHMENT') {
          pettyCash.balance += transaction.amount;
        }
        await AccountingPettyCash.db.updateRow(
          session,
          pettyCash,
          transaction: txn,
        );
      }
      return await AccountingPettyCashTransaction.db.insertRow(
        session,
        transaction,
        transaction: txn,
      );
    });
  }

  /// Obtener estimaciones de nómina
  Future<List<AccountingPayrollEstimation>> getPayrollEstimations(
    Session session,
  ) async {
    return await AccountingPayrollEstimation.db.find(session);
  }

  /// Crear estimación de nómina
  Future<AccountingPayrollEstimation> createPayrollEstimation(
    Session session,
    AccountingPayrollEstimation estimation,
  ) async {
    return await AccountingPayrollEstimation.db.insertRow(session, estimation);
  }

  /// Obtener presupuestos mensuales
  Future<List<AccountingBudget>> getBudgets(Session session) async {
    return await AccountingBudget.db.find(
      session,
      orderBy: (t) => t.month,
      orderDescending: true,
    );
  }

  /// Crear o actualizar presupuesto
  Future<AccountingBudget> createBudget(
    Session session,
    AccountingBudget budget,
  ) async {
    return await AccountingBudget.db.insertRow(session, budget);
  }

  /// Actualizar transacción de caja chica
  Future<AccountingPettyCashTransaction> updatePettyCashTransaction(
    Session session,
    AccountingPettyCashTransaction transaction,
  ) async {
    await _assertPeriodNotLocked(session, transaction.date);
    return await AccountingPettyCashTransaction.db.updateRow(
      session,
      transaction,
    );
  }

  /// Eliminar transacción de caja chica
  Future<void> deletePettyCashTransaction(
    Session session,
    int transactionId,
  ) async {
    await session.db.transaction((txn) async {
      final txnRecord = await AccountingPettyCashTransaction.db.findById(
        session,
        transactionId,
        transaction: txn,
      );
      if (txnRecord != null) {
        await _assertPeriodNotLocked(session, txnRecord.date);
        final pettyCash = await AccountingPettyCash.db.findById(
          session,
          txnRecord.pettyCashId,
          transaction: txn,
        );
        if (pettyCash != null) {
          if (txnRecord.type == 'EXPENSE') {
            pettyCash.balance += txnRecord.amount;
          } else if (txnRecord.type == 'REPLENISHMENT') {
            pettyCash.balance -= txnRecord.amount;
          }
          await AccountingPettyCash.db.updateRow(
            session,
            pettyCash,
            transaction: txn,
          );
        }
        await AccountingPettyCashTransaction.db.deleteRow(
          session,
          txnRecord,
          transaction: txn,
        );
      }
    });
  }

  // --- Transacciones Bancarias / Libro Diario ---

  Future<List<AccountingTransaction>> getTransactions(Session session) async {
    return await AccountingTransaction.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  Future<AccountingTransaction> createTransaction(
    Session session,
    AccountingTransaction transaction,
  ) async {
    await _assertPeriodNotLocked(session, transaction.date);
    transaction.createdAt = DateTime.now();
    transaction.updatedAt = DateTime.now();
    return await AccountingTransaction.db.insertRow(session, transaction);
  }

  // --- Activos Fijos ---

  Future<List<AccountingFixedAsset>> getFixedAssets(Session session) async {
    return await AccountingFixedAsset.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  Future<AccountingFixedAsset> createFixedAsset(
    Session session,
    AccountingFixedAsset asset,
  ) async {
    return await AccountingFixedAsset.db.insertRow(session, asset);
  }

  Future<int> runMonthlyDepreciation(Session session) async {
    final assets = await AccountingFixedAsset.db.find(
      session,
      where: (t) => t.isFullyDepreciated.equals(false),
    );
    int processed = 0;
    for (final asset in assets) {
      final monthlyDep = asset.purchaseValue / asset.usefulLifeMonths;
      asset.accumulatedDepreciation += monthlyDep;
      final maxDep = asset.purchaseValue;
      if (asset.accumulatedDepreciation >= maxDep) {
        asset.accumulatedDepreciation = maxDep;
        asset.isFullyDepreciated = true;
      }
      asset.lastDepreciationDate = DateTime.now();
      await AccountingFixedAsset.db.updateRow(session, asset);
      processed++;
    }
    return processed;
  }

  // --- Plan de Cuentas (Libro Mayor) ---

  Future<List<AccountingLedgerAccount>> getLedgerAccounts(
    Session session,
  ) async {
    return await AccountingLedgerAccount.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.code,
    );
  }

  Future<AccountingLedgerAccount> createLedgerAccount(
    Session session,
    AccountingLedgerAccount account,
  ) async {
    return await AccountingLedgerAccount.db.insertRow(session, account);
  }

  // --- Impuestos ---

  Future<List<AccountingTax>> getTaxes(Session session) async {
    return await AccountingTax.db.find(
      session,
      where: (t) => t.isActive.equals(true),
    );
  }

  Future<AccountingTax> createTax(
    Session session,
    AccountingTax tax,
  ) async {
    return await AccountingTax.db.insertRow(session, tax);
  }

  // --- Morosidad (Cuentas Vencidas) ---

  Future<List<AccountingInvoice>> getOverdueInvoices(Session session) async {
    final now = DateTime.now();
    return await AccountingInvoice.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          t.status.equals('Pending') &
          (t.dueDate < now),
    );
  }

  Future<List<AccountingExpense>> getOverdueExpenses(Session session) async {
    return await AccountingExpense.db.find(
      session,
      where: (t) => t.isDeleted.equals(false) & t.status.equals('Pending'),
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  // =========================================================================
  // 1. CIERRES DE PERIODO CONTABLE Y BLOQUEO DE MODIFICACIONES
  // =========================================================================

  /// Obtiene el historial de cierres contables
  Future<List<AccountingPeriodClosure>> getPeriodClosures(
    Session session,
  ) async {
    return await AccountingPeriodClosure.db.find(
      session,
      orderBy: (t) => t.startDate,
      orderDescending: true,
    );
  }

  /// Ejecuta el cierre de un periodo contable, bloquea modificaciones y genera asiento de regularización
  Future<AccountingPeriodClosure> closeAccountingPeriod(
    Session session,
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  ) async {
    // Normalizar rango
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    // 1. Verificar si ya existe un periodo cerrado que solape
    final existing = await AccountingPeriodClosure.db.find(
      session,
      where: (t) =>
          t.isLocked.equals(true) &
          ((t.startDate <= end) & (t.endDate >= start)),
    );
    if (existing.isNotEmpty) {
      throw Exception(
        'Ya existe un periodo cerrado que solapa con el rango seleccionado: ${existing.first.periodName}',
      );
    }

    // 2. Totalizar ingresos reconocidos (facturas cobradas en el rango)
    final invoices = await AccountingInvoice.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          t.status.equals('Paid') &
          (t.issueDate >= start) &
          (t.issueDate <= end),
    );
    final totalIncome = invoices.fold<double>(
      0.0,
      (sum, item) => sum + item.totalAmount,
    );

    // 3. Totalizar gastos pagados en el rango
    final expenses = await AccountingExpense.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          t.status.equals('Paid') &
          (t.date >= start) &
          (t.date <= end),
    );
    final totalExpense = expenses.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );

    final netResult = totalIncome - totalExpense;

    // 4. Crear registro de Cierre Contable
    final closure = AccountingPeriodClosure(
      periodName: periodName,
      periodType: periodType,
      startDate: start,
      endDate: end,
      status: 'CLOSED',
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netResult: netResult,
      closedBy: closedBy ?? 'Administrador',
      closedAt: DateTime.now(),
      closureNotes: notes,
      isLocked: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final savedClosure = await AccountingPeriodClosure.db.insertRow(
      session,
      closure,
    );

    // 5. Asiento Contable Automático de Cierre (Transferencia a Resultados del Ejercicio)
    final closingTx = AccountingTransaction(
      date: end,
      amount: netResult.abs(),
      type: netResult >= 0 ? 'Income' : 'Expense',
      account: '3.1.01 Resultados Acumulados / Utilidades del Ejercicio',
      notes:
          'Asiento de Cierre Contable Periodo [$periodName]: Ingresos \$${totalIncome.toStringAsFixed(2)} - Gastos \$${totalExpense.toStringAsFixed(2)} = Resultado \$${netResult.toStringAsFixed(2)}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
    await AccountingTransaction.db.insertRow(session, closingTx);

    return savedClosure;
  }

  /// Reabre un periodo cerrado para correcciones excepcionales supervisadas
  Future<AccountingPeriodClosure> reopenPeriodClosure(
    Session session,
    int closureId,
    String reason,
  ) async {
    final closure = await AccountingPeriodClosure.db.findById(
      session,
      closureId,
    );
    if (closure == null) {
      throw Exception('Cierre contable #$closureId no encontrado');
    }

    closure.isLocked = false;
    closure.status = 'REOPENED';
    closure.closureNotes =
        '${closure.closureNotes ?? ''}\n[REAPERTURA ${DateTime.now().toIso8601String().substring(0, 19)}]: $reason';
    closure.updatedAt = DateTime.now();

    return await AccountingPeriodClosure.db.updateRow(session, closure);
  }

  // =========================================================================
  // 2. INTEGRACIÓN CON INVENTARIO Y KÁRDEX VALUADO
  // =========================================================================

  /// Obtiene los movimientos del kárdex contable (filtrable por ítem)
  Future<List<AccountingKardexMovement>> getKardexMovements(
    Session session, {
    int? itemId,
  }) async {
    if (itemId != null) {
      return await AccountingKardexMovement.db.find(
        session,
        where: (t) => t.itemId.equals(itemId),
        orderBy: (t) => t.date,
        orderDescending: true,
      );
    }
    return await AccountingKardexMovement.db.find(
      session,
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  /// Registra un movimiento en Kárdex, recalcula costo promedio ponderado e impacta contabilidad
  Future<AccountingKardexMovement> recordKardexMovement(
    Session session, {
    required int itemId,
    required String movementType,
    required double quantity,
    required double unitCost,
    required String referenceDoc,
    int? workOrderId,
    String? notes,
  }) async {
    final now = DateTime.now();
    await _assertPeriodNotLocked(session, now);

    final item = await OpsInventoryItem.db.findById(session, itemId);
    if (item == null) {
      throw Exception('Item de inventario #$itemId no existe');
    }

    double appliedUnitCost = unitCost;
    double newStock = item.quantityInStock;
    double newAvgCost = item.averageCost;

    if (movementType == 'IN_PURCHASE' || movementType == 'IN_ADJUSTMENT') {
      // Entrada: Ponderar costo promedio
      final currentTotalVal = item.quantityInStock * item.averageCost;
      final addedVal = quantity * unitCost;
      newStock = item.quantityInStock + quantity;
      newAvgCost = newStock > 0
          ? (currentTotalVal + addedVal) / newStock
          : unitCost;
      appliedUnitCost = unitCost;
    } else if (movementType == 'OUT_WORK_ORDER' ||
        movementType == 'OUT_ADJUSTMENT') {
      // Salida: Valuar al costo promedio actual
      if (item.quantityInStock < quantity) {
        throw Exception(
          'Stock insuficiente para ${item.name}. Disponible: ${item.quantityInStock} ${item.unit}, Requerido: $quantity ${item.unit}',
        );
      }
      appliedUnitCost = item.averageCost > 0 ? item.averageCost : unitCost;
      newStock = item.quantityInStock - quantity;
      // El costo promedio unitario se mantiene
    }

    item.quantityInStock = newStock;
    item.averageCost = newAvgCost;
    item.updatedAt = now;
    await OpsInventoryItem.db.updateRow(session, item);

    final movementTotalCost = quantity * appliedUnitCost;
    final balanceTotalCost = newStock * newAvgCost;

    final kardexEntry = AccountingKardexMovement(
      itemId: item.id!,
      itemName: item.name,
      date: now,
      movementType: movementType,
      referenceDoc: referenceDoc,
      workOrderId: workOrderId,
      quantity: quantity,
      unitCost: appliedUnitCost,
      totalCost: movementTotalCost,
      balanceQuantity: newStock,
      balanceTotalCost: balanceTotalCost,
      notes: notes,
      createdAt: now,
    );

    final savedKardex = await AccountingKardexMovement.db.insertRow(
      session,
      kardexEntry,
    );

    // Integrar a Gastos / Costo de Venta si fue salida para Orden de Trabajo
    if (movementType == 'OUT_WORK_ORDER') {
      final desc =
          'Consumo en O.T. #${workOrderId ?? 'N/A'}: ${quantity.toStringAsFixed(2)} ${item.unit} de ${item.name} ($referenceDoc)';
      final expense = AccountingExpense(
        supplierName: 'Almacén Central (Inventario)',
        date: now,
        amount: movementTotalCost,
        category: 'Insumos y Materiales de Servicio',
        status: 'Paid',
        description: desc,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      await AccountingExpense.db.insertRow(session, expense);
    }

    return savedKardex;
  }

  // =========================================================================
  // 3. INTEGRACIÓN CON OPERACIONES Y COSTEO POR ORDEN DE TRABAJO (OT)
  // =========================================================================

  /// Obtiene el costeo detallado y margen de rentabilidad por Orden de Trabajo
  Future<List<AccountingWorkOrderCostSummary>> getWorkOrderCosting(
    Session session, {
    int? workOrderId,
  }) async {
    final workOrders = await OpsWorkOrder.db.find(
      session,
      where: workOrderId != null ? (t) => t.id.equals(workOrderId) : null,
      orderBy: (t) => t.date,
      orderDescending: true,
    );

    final allKardex = await AccountingKardexMovement.db.find(
      session,
      where: (t) => t.workOrderId.notEquals(null),
    );

    final allInvoices = await AccountingInvoice.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final allExpenses = await AccountingExpense.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final List<AccountingWorkOrderCostSummary> results = [];

    for (final order in workOrders) {
      // 1. Materiales desde Kárdex
      final orderKardex = allKardex.where((k) => k.workOrderId == order.id);
      final materialsCost = orderKardex.fold<double>(
        0.0,
        (sum, k) => sum + k.totalCost,
      );

      // 2. Gastos directos vinculados
      final orderExpenses = allExpenses.where(
        (e) =>
            (e.description?.contains('O.T. #${order.id}') ?? false) ||
            (e.description?.contains('OT #${order.id}') ?? false),
      );
      final otherExpenses = orderExpenses.fold<double>(
        0.0,
        (sum, e) => sum + e.amount,
      );

      // 3. Costo estándar de mano de obra técnica asignada
      final double laborCost = order.assignedEmployeeId != null ? 65.0 : 0.0;

      final totalCost = materialsCost + otherExpenses + laborCost;

      // 4. Facturación vinculada a la OT
      final relatedInvoices = allInvoices.where(
        (inv) =>
            (inv.notes?.contains('OT #${order.id}') ?? false) ||
            (inv.notes?.contains('O.T. #${order.id}') ?? false) ||
            (inv.invoiceNumber.contains('FAC-OT-${order.id}-')),
      );

      final invoicedAmount = relatedInvoices.fold<double>(
        0.0,
        (sum, inv) => sum + inv.totalAmount,
      );

      final isBilled = relatedInvoices.isNotEmpty;
      final invoiceId = isBilled ? relatedInvoices.first.id : null;

      final grossMargin = invoicedAmount - totalCost;
      final grossMarginPercentage = invoicedAmount > 0
          ? (grossMargin / invoicedAmount) * 100
          : 0.0;

      results.add(
        AccountingWorkOrderCostSummary(
          workOrderId: order.id!,
          workOrderDate: order.date,
          workOrderStatus: order.status,
          contractId: order.contractId,
          clientName: 'Cliente Contrato #${order.contractId}',
          serviceDescription: order.notes ?? 'Servicio Técnico Especializado',
          materialsCost: materialsCost,
          laborCost: laborCost,
          otherExpenses: otherExpenses,
          totalCost: totalCost,
          invoicedAmount: invoicedAmount,
          grossMargin: grossMargin,
          grossMarginPercentage: grossMarginPercentage,
          isBilled: isBilled,
          invoiceId: invoiceId,
        ),
      );
    }

    return results;
  }

  /// Facturación inmediata en 1 clic de una Orden de Trabajo completada
  Future<AccountingInvoice> createInvoiceFromWorkOrder(
    Session session, {
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  }) async {
    final now = DateTime.now();
    await _assertPeriodNotLocked(session, now);

    final workOrder = await OpsWorkOrder.db.findById(session, workOrderId);
    if (workOrder == null) {
      throw Exception('Orden de Trabajo #$workOrderId no encontrada');
    }

    final invoiceNumber =
        'FAC-OT-$workOrderId-${now.millisecondsSinceEpoch.toString().substring(7)}';

    final invoice = AccountingInvoice(
      invoiceNumber: invoiceNumber,
      customerId: workOrder.contractId,
      issueDate: now,
      dueDate: dueDate,
      totalAmount: billedAmount,
      status: 'Pending',
      notes:
          'Factura de Servicio vinculada a OT #$workOrderId ($clientName). ${notes ?? ''}',
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await AccountingInvoice.db.insertRow(session, invoice);
  }
}
