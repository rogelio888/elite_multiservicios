import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Para obtener la instancia global de `client`
import '../../domain/repositories/accounting_repository.dart';
import '../../data/datasources/accounting_remote_data_source.dart';
import '../../data/repositories/accounting_repository_impl.dart';

// =========================================================================
// DEPENDENCY INJECTION (Core Providers)
// =========================================================================

final accountingRemoteDataSourceProvider = Provider<AccountingRemoteDataSource>((ref) {
  return AccountingRemoteDataSourceImpl(client: client);
});

final accountingRepositoryProvider = Provider<AccountingRepository>((ref) {
  final remoteDataSource = ref.watch(accountingRemoteDataSourceProvider);
  return AccountingRepositoryImpl(remoteDataSource: remoteDataSource);
});

// =========================================================================
// DATA PROVIDERS (Lectura)
// =========================================================================

final financialSummaryProvider = FutureProvider.autoDispose<AccountingFinancialSummary>((ref) {
  return ref.watch(accountingRepositoryProvider).getFinancialSummary();
});

final budgetsProvider = FutureProvider.autoDispose<List<AccountingBudget>>((ref) {
  return ref.watch(accountingRepositoryProvider).getBudgets();
});

final invoicesProvider = FutureProvider.autoDispose<List<AccountingInvoice>>((ref) {
  return ref.watch(accountingRepositoryProvider).getInvoices();
});

final expensesProvider = FutureProvider.autoDispose<List<AccountingExpense>>((ref) {
  return ref.watch(accountingRepositoryProvider).getExpenses();
});

final costCentersProvider = FutureProvider.autoDispose<List<AccountingCostCenter>>((ref) {
  return ref.watch(accountingRepositoryProvider).getCostCenters();
});

final pettyCashProvider = FutureProvider.autoDispose<List<AccountingPettyCash>>((ref) {
  return ref.watch(accountingRepositoryProvider).getPettyCash();
});

final pettyCashTransactionsProvider = FutureProvider.autoDispose<List<AccountingPettyCashTransaction>>((ref) {
  return ref.watch(accountingRepositoryProvider).getPettyCashTransactions();
});

final payrollEstimationsProvider = FutureProvider.autoDispose<List<AccountingPayrollEstimation>>((ref) {
  return ref.watch(accountingRepositoryProvider).getPayrollEstimations();
});

final ledgerAccountsProvider = FutureProvider.autoDispose<List<AccountingLedgerAccount>>((ref) {
  return ref.watch(accountingRepositoryProvider).getLedgerAccounts();
});

final transactionsProvider = FutureProvider.autoDispose<List<AccountingTransaction>>((ref) {
  return ref.watch(accountingRepositoryProvider).getTransactions();
});

final fixedAssetsProvider = FutureProvider.autoDispose<List<AccountingFixedAsset>>((ref) {
  return ref.watch(accountingRepositoryProvider).getFixedAssets();
});

final taxesProvider = FutureProvider.autoDispose<List<AccountingTax>>((ref) {
  return ref.watch(accountingRepositoryProvider).getTaxes();
});

final overdueInvoicesProvider = FutureProvider.autoDispose<List<AccountingInvoice>>((ref) {
  return ref.watch(accountingRepositoryProvider).getOverdueInvoices();
});

final overdueExpensesProvider = FutureProvider.autoDispose<List<AccountingExpense>>((ref) {
  return ref.watch(accountingRepositoryProvider).getOverdueExpenses();
});

final periodClosuresProvider = FutureProvider.autoDispose<List<AccountingPeriodClosure>>((ref) {
  return ref.watch(accountingRepositoryProvider).getPeriodClosures();
});

// Para Kárdex y Costeo de OTs (que pueden tener un filtro opcional), usamos `family`
final kardexMovementsProvider = FutureProvider.family.autoDispose<List<AccountingKardexMovement>, int?>((ref, itemId) {
  return ref.watch(accountingRepositoryProvider).getKardexMovements(itemId: itemId);
});

final workOrderCostingProvider = FutureProvider.family.autoDispose<List<AccountingWorkOrderCostSummary>, int?>((ref, workOrderId) {
  return ref.watch(accountingRepositoryProvider).getWorkOrderCosting(workOrderId: workOrderId);
});
