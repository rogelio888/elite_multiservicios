import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

abstract class AccountingRepository {
  Future<AccountingFinancialSummary> getFinancialSummary();
  Future<List<AccountingBudget>> getBudgets();
  Future<AccountingBudget> createBudget(AccountingBudget budget);
  
  // Facturas y Gastos
  Future<List<AccountingInvoice>> getInvoices();
  Future<AccountingInvoice> createInvoice(AccountingInvoice invoice);
  Future<AccountingInvoice?> updateInvoiceStatus(int invoiceId, String status);
  Future<List<AccountingInvoice>> getOverdueInvoices();
  
  Future<List<AccountingExpense>> getExpenses();
  Future<AccountingExpense> createExpense(AccountingExpense expense);
  Future<List<AccountingExpense>> getOverdueExpenses();

  // Centros de costo
  Future<List<AccountingCostCenter>> getCostCenters();
  Future<AccountingCostCenter> createCostCenter(AccountingCostCenter costCenter);

  // Caja Chica
  Future<List<AccountingPettyCash>> getPettyCash();
  Future<AccountingPettyCash> createPettyCash(AccountingPettyCash pettyCash);
  Future<List<AccountingPettyCashTransaction>> getPettyCashTransactions();
  Future<AccountingPettyCashTransaction> addPettyCashTransaction(AccountingPettyCashTransaction transaction);
  Future<AccountingPettyCashTransaction> updatePettyCashTransaction(AccountingPettyCashTransaction transaction);
  Future<void> deletePettyCashTransaction(int transactionId);

  // Nómina
  Future<List<AccountingPayrollEstimation>> getPayrollEstimations();
  Future<AccountingPayrollEstimation> createPayrollEstimation(AccountingPayrollEstimation estimation);

  // Libro Mayor y Transacciones
  Future<List<AccountingTransaction>> getTransactions();
  Future<AccountingTransaction> createTransaction(AccountingTransaction transaction);
  Future<List<AccountingLedgerAccount>> getLedgerAccounts();
  Future<AccountingLedgerAccount> createLedgerAccount(AccountingLedgerAccount account);

  // Activos Fijos
  Future<List<AccountingFixedAsset>> getFixedAssets();
  Future<AccountingFixedAsset> createFixedAsset(AccountingFixedAsset asset);
  Future<int> runMonthlyDepreciation();

  // Impuestos
  Future<List<AccountingTax>> getTaxes();
  Future<AccountingTax> createTax(AccountingTax tax);

  // Cierres Contables
  Future<List<AccountingPeriodClosure>> getPeriodClosures();
  Future<AccountingPeriodClosure> closeAccountingPeriod(
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  );
  Future<AccountingPeriodClosure> reopenPeriodClosure(int closureId, String reason);

  // Kárdex
  Future<List<AccountingKardexMovement>> getKardexMovements({int? itemId});
  Future<AccountingKardexMovement> recordKardexMovement({
    required int itemId,
    required String movementType,
    required double quantity,
    required double unitCost,
    required String referenceDoc,
    int? workOrderId,
    String? notes,
  });

  // Costeo de OT
  Future<List<AccountingWorkOrderCostSummary>> getWorkOrderCosting({int? workOrderId});
  Future<AccountingInvoice> createInvoiceFromWorkOrder({
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  });
}
