import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

abstract class AccountingRemoteDataSource {
  Future<AccountingFinancialSummary> getFinancialSummary();
  Future<List<AccountingBudget>> getBudgets();
  Future<AccountingBudget> createBudget(AccountingBudget budget);

  Future<List<AccountingInvoice>> getInvoices();
  Future<AccountingInvoice> createInvoice(AccountingInvoice invoice);
  Future<AccountingInvoice?> updateInvoiceStatus(int invoiceId, String status);
  Future<List<AccountingInvoice>> getOverdueInvoices();

  Future<List<AccountingExpense>> getExpenses();
  Future<AccountingExpense> createExpense(AccountingExpense expense);
  Future<List<AccountingExpense>> getOverdueExpenses();

  Future<List<AccountingCostCenter>> getCostCenters();
  Future<AccountingCostCenter> createCostCenter(
    AccountingCostCenter costCenter,
  );

  Future<List<AccountingPettyCash>> getPettyCash();
  Future<AccountingPettyCash> createPettyCash(AccountingPettyCash pettyCash);
  Future<List<AccountingPettyCashTransaction>> getPettyCashTransactions();
  Future<AccountingPettyCashTransaction> addPettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  );
  Future<AccountingPettyCashTransaction> updatePettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  );
  Future<void> deletePettyCashTransaction(int transactionId);

  Future<List<AccountingPayrollEstimation>> getPayrollEstimations();
  Future<AccountingPayrollEstimation> createPayrollEstimation(
    AccountingPayrollEstimation estimation,
  );

  Future<List<AccountingTransaction>> getTransactions();
  Future<AccountingTransaction> createTransaction(
    AccountingTransaction transaction,
  );
  Future<List<AccountingLedgerAccount>> getLedgerAccounts();
  Future<AccountingLedgerAccount> createLedgerAccount(
    AccountingLedgerAccount account,
  );

  Future<List<AccountingFixedAsset>> getFixedAssets();
  Future<AccountingFixedAsset> createFixedAsset(AccountingFixedAsset asset);
  Future<int> runMonthlyDepreciation();

  Future<List<AccountingTax>> getTaxes();
  Future<AccountingTax> createTax(AccountingTax tax);

  Future<List<AccountingPeriodClosure>> getPeriodClosures();
  Future<AccountingPeriodClosure> closeAccountingPeriod(
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  );
  Future<AccountingPeriodClosure> reopenPeriodClosure(
    int closureId,
    String reason,
  );

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

  Future<List<AccountingWorkOrderCostSummary>> getWorkOrderCosting({
    int? workOrderId,
  });
  Future<AccountingInvoice> createInvoiceFromWorkOrder({
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  });
}

class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  final Client client;

  AccountingRemoteDataSourceImpl({required this.client});

  @override
  Future<AccountingFinancialSummary> getFinancialSummary() =>
      client.accounting.getFinancialSummary();

  @override
  Future<List<AccountingBudget>> getBudgets() => client.accounting.getBudgets();

  @override
  Future<AccountingBudget> createBudget(AccountingBudget budget) =>
      client.accounting.createBudget(budget);

  @override
  Future<List<AccountingInvoice>> getInvoices() =>
      client.accounting.getInvoices();

  @override
  Future<AccountingInvoice> createInvoice(AccountingInvoice invoice) =>
      client.accounting.createInvoice(invoice);

  @override
  Future<AccountingInvoice?> updateInvoiceStatus(
    int invoiceId,
    String status,
  ) => client.accounting.updateInvoiceStatus(invoiceId, status);

  @override
  Future<List<AccountingInvoice>> getOverdueInvoices() =>
      client.accounting.getOverdueInvoices();

  @override
  Future<List<AccountingExpense>> getExpenses() =>
      client.accounting.getExpenses();

  @override
  Future<AccountingExpense> createExpense(AccountingExpense expense) =>
      client.accounting.createExpense(expense);

  @override
  Future<List<AccountingExpense>> getOverdueExpenses() =>
      client.accounting.getOverdueExpenses();

  @override
  Future<List<AccountingCostCenter>> getCostCenters() =>
      client.accounting.getCostCenters();

  @override
  Future<AccountingCostCenter> createCostCenter(
    AccountingCostCenter costCenter,
  ) => client.accounting.createCostCenter(costCenter);

  @override
  Future<List<AccountingPettyCash>> getPettyCash() =>
      client.accounting.getPettyCash();

  @override
  Future<AccountingPettyCash> createPettyCash(AccountingPettyCash pettyCash) =>
      client.accounting.createPettyCash(pettyCash);

  @override
  Future<List<AccountingPettyCashTransaction>> getPettyCashTransactions() =>
      client.accounting.getPettyCashTransactions();

  @override
  Future<AccountingPettyCashTransaction> addPettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  ) => client.accounting.addPettyCashTransaction(transaction);

  @override
  Future<AccountingPettyCashTransaction> updatePettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  ) => client.accounting.updatePettyCashTransaction(transaction);

  @override
  Future<void> deletePettyCashTransaction(int transactionId) =>
      client.accounting.deletePettyCashTransaction(transactionId);

  @override
  Future<List<AccountingPayrollEstimation>> getPayrollEstimations() =>
      client.accounting.getPayrollEstimations();

  @override
  Future<AccountingPayrollEstimation> createPayrollEstimation(
    AccountingPayrollEstimation estimation,
  ) => client.accounting.createPayrollEstimation(estimation);

  @override
  Future<List<AccountingTransaction>> getTransactions() =>
      client.accounting.getTransactions();

  @override
  Future<AccountingTransaction> createTransaction(
    AccountingTransaction transaction,
  ) => client.accounting.createTransaction(transaction);

  @override
  Future<List<AccountingLedgerAccount>> getLedgerAccounts() =>
      client.accounting.getLedgerAccounts();

  @override
  Future<AccountingLedgerAccount> createLedgerAccount(
    AccountingLedgerAccount account,
  ) => client.accounting.createLedgerAccount(account);

  @override
  Future<List<AccountingFixedAsset>> getFixedAssets() =>
      client.accounting.getFixedAssets();

  @override
  Future<AccountingFixedAsset> createFixedAsset(AccountingFixedAsset asset) =>
      client.accounting.createFixedAsset(asset);

  @override
  Future<int> runMonthlyDepreciation() =>
      client.accounting.runMonthlyDepreciation();

  @override
  Future<List<AccountingTax>> getTaxes() => client.accounting.getTaxes();

  @override
  Future<AccountingTax> createTax(AccountingTax tax) =>
      client.accounting.createTax(tax);

  @override
  Future<List<AccountingPeriodClosure>> getPeriodClosures() =>
      client.accounting.getPeriodClosures();

  @override
  Future<AccountingPeriodClosure> closeAccountingPeriod(
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  ) => client.accounting.closeAccountingPeriod(
    periodName,
    periodType,
    startDate,
    endDate,
    notes,
    closedBy,
  );

  @override
  Future<AccountingPeriodClosure> reopenPeriodClosure(
    int closureId,
    String reason,
  ) => client.accounting.reopenPeriodClosure(closureId, reason);

  @override
  Future<List<AccountingKardexMovement>> getKardexMovements({int? itemId}) =>
      client.accounting.getKardexMovements(itemId: itemId);

  @override
  Future<AccountingKardexMovement> recordKardexMovement({
    required int itemId,
    required String movementType,
    required double quantity,
    required double unitCost,
    required String referenceDoc,
    int? workOrderId,
    String? notes,
  }) => client.accounting.recordKardexMovement(
    itemId: itemId,
    movementType: movementType,
    quantity: quantity,
    unitCost: unitCost,
    referenceDoc: referenceDoc,
    workOrderId: workOrderId,
    notes: notes,
  );

  @override
  Future<List<AccountingWorkOrderCostSummary>> getWorkOrderCosting({
    int? workOrderId,
  }) => client.accounting.getWorkOrderCosting(workOrderId: workOrderId);

  @override
  Future<AccountingInvoice> createInvoiceFromWorkOrder({
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  }) => client.accounting.createInvoiceFromWorkOrder(
    workOrderId: workOrderId,
    billedAmount: billedAmount,
    clientName: clientName,
    dueDate: dueDate,
    notes: notes,
  );
}
