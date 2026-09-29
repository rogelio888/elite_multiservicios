import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../datasources/accounting_remote_data_source.dart';

class AccountingRepositoryImpl implements AccountingRepository {
  final AccountingRemoteDataSource remoteDataSource;

  AccountingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AccountingFinancialSummary> getFinancialSummary() =>
      remoteDataSource.getFinancialSummary();

  @override
  Future<List<AccountingBudget>> getBudgets() => remoteDataSource.getBudgets();

  @override
  Future<AccountingBudget> createBudget(AccountingBudget budget) =>
      remoteDataSource.createBudget(budget);

  @override
  Future<List<AccountingInvoice>> getInvoices() =>
      remoteDataSource.getInvoices();

  @override
  Future<AccountingInvoice> createInvoice(AccountingInvoice invoice) =>
      remoteDataSource.createInvoice(invoice);

  @override
  Future<AccountingInvoice?> updateInvoiceStatus(
    int invoiceId,
    String status,
  ) => remoteDataSource.updateInvoiceStatus(invoiceId, status);

  @override
  Future<List<AccountingInvoice>> getOverdueInvoices() =>
      remoteDataSource.getOverdueInvoices();

  @override
  Future<List<AccountingExpense>> getExpenses() =>
      remoteDataSource.getExpenses();

  @override
  Future<AccountingExpense> createExpense(AccountingExpense expense) =>
      remoteDataSource.createExpense(expense);

  @override
  Future<List<AccountingExpense>> getOverdueExpenses() =>
      remoteDataSource.getOverdueExpenses();

  @override
  Future<List<AccountingCostCenter>> getCostCenters() =>
      remoteDataSource.getCostCenters();

  @override
  Future<AccountingCostCenter> createCostCenter(
    AccountingCostCenter costCenter,
  ) => remoteDataSource.createCostCenter(costCenter);

  @override
  Future<List<AccountingPettyCash>> getPettyCash() =>
      remoteDataSource.getPettyCash();

  @override
  Future<AccountingPettyCash> createPettyCash(AccountingPettyCash pettyCash) =>
      remoteDataSource.createPettyCash(pettyCash);

  @override
  Future<List<AccountingPettyCashTransaction>> getPettyCashTransactions() =>
      remoteDataSource.getPettyCashTransactions();

  @override
  Future<AccountingPettyCashTransaction> addPettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  ) => remoteDataSource.addPettyCashTransaction(transaction);

  @override
  Future<AccountingPettyCashTransaction> updatePettyCashTransaction(
    AccountingPettyCashTransaction transaction,
  ) => remoteDataSource.updatePettyCashTransaction(transaction);

  @override
  Future<void> deletePettyCashTransaction(int transactionId) =>
      remoteDataSource.deletePettyCashTransaction(transactionId);

  @override
  Future<List<AccountingPayrollEstimation>> getPayrollEstimations() =>
      remoteDataSource.getPayrollEstimations();

  @override
  Future<AccountingPayrollEstimation> createPayrollEstimation(
    AccountingPayrollEstimation estimation,
  ) => remoteDataSource.createPayrollEstimation(estimation);

  @override
  Future<List<AccountingTransaction>> getTransactions() =>
      remoteDataSource.getTransactions();

  @override
  Future<AccountingTransaction> createTransaction(
    AccountingTransaction transaction,
  ) => remoteDataSource.createTransaction(transaction);

  @override
  Future<List<AccountingLedgerAccount>> getLedgerAccounts() =>
      remoteDataSource.getLedgerAccounts();

  @override
  Future<AccountingLedgerAccount> createLedgerAccount(
    AccountingLedgerAccount account,
  ) => remoteDataSource.createLedgerAccount(account);

  @override
  Future<List<AccountingFixedAsset>> getFixedAssets() =>
      remoteDataSource.getFixedAssets();

  @override
  Future<AccountingFixedAsset> createFixedAsset(AccountingFixedAsset asset) =>
      remoteDataSource.createFixedAsset(asset);

  @override
  Future<int> runMonthlyDepreciation() =>
      remoteDataSource.runMonthlyDepreciation();

  @override
  Future<List<AccountingTax>> getTaxes() => remoteDataSource.getTaxes();

  @override
  Future<AccountingTax> createTax(AccountingTax tax) =>
      remoteDataSource.createTax(tax);

  @override
  Future<List<AccountingPeriodClosure>> getPeriodClosures() =>
      remoteDataSource.getPeriodClosures();

  @override
  Future<AccountingPeriodClosure> closeAccountingPeriod(
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  ) => remoteDataSource.closeAccountingPeriod(
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
  ) => remoteDataSource.reopenPeriodClosure(closureId, reason);

  @override
  Future<List<AccountingKardexMovement>> getKardexMovements({int? itemId}) =>
      remoteDataSource.getKardexMovements(itemId: itemId);

  @override
  Future<AccountingKardexMovement> recordKardexMovement({
    required int itemId,
    required String movementType,
    required double quantity,
    required double unitCost,
    required String referenceDoc,
    int? workOrderId,
    String? notes,
  }) => remoteDataSource.recordKardexMovement(
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
  }) => remoteDataSource.getWorkOrderCosting(workOrderId: workOrderId);

  @override
  Future<AccountingInvoice> createInvoiceFromWorkOrder({
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  }) => remoteDataSource.createInvoiceFromWorkOrder(
    workOrderId: workOrderId,
    billedAmount: billedAmount,
    clientName: clientName,
    dueDate: dueDate,
    notes: notes,
  );
}
