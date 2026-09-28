import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

class AccountingEndpoint extends Endpoint {
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
    );
  }

  /// Crear factura
  Future<AccountingInvoice> createInvoice(
    Session session,
    AccountingInvoice invoice,
  ) async {
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
    );
  }

  /// Crear gasto
  Future<AccountingExpense> createExpense(
    Session session,
    AccountingExpense expense,
  ) async {
    expense.createdAt = DateTime.now();
    expense.updatedAt = DateTime.now();
    return await AccountingExpense.db.insertRow(session, expense);
  }

  /// Obtener resumen financiero (simplificado)
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
      projectedExpenses: totalExpenses * 1.2, // Estimación básica
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
    var pettyCash = await AccountingPettyCash.db.findById(
      session,
      transaction.pettyCashId,
    );
    if (pettyCash != null) {
      if (transaction.type == 'EXPENSE') {
        pettyCash.balance -= transaction.amount;
      } else if (transaction.type == 'REPLENISHMENT') {
        pettyCash.balance += transaction.amount;
      }
      await AccountingPettyCash.db.updateRow(session, pettyCash);
    }
    return await AccountingPettyCashTransaction.db.insertRow(
      session,
      transaction,
    );
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
    final txn = await AccountingPettyCashTransaction.db.findById(
      session,
      transactionId,
    );
    if (txn != null) {
      // Revertir el efecto en el saldo de caja
      final pettyCash = await AccountingPettyCash.db.findById(
        session,
        txn.pettyCashId,
      );
      if (pettyCash != null) {
        if (txn.type == 'EXPENSE') {
          pettyCash.balance += txn.amount; // revertir gasto
        } else if (txn.type == 'REPLENISHMENT') {
          pettyCash.balance -= txn.amount; // revertir reembolso
        }
        await AccountingPettyCash.db.updateRow(session, pettyCash);
      }
      await AccountingPettyCashTransaction.db.deleteRow(session, txn);
    }
  }
}
