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

    return AccountingFinancialSummary(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      balance: totalIncome - totalExpenses,
    );
  }
}
