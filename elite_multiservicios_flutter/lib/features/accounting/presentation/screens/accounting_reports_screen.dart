import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import '../utils/accounting_file_helper.dart';

class AccountingReportsScreen extends ConsumerStatefulWidget {
  const AccountingReportsScreen({super.key});

  @override
  ConsumerState<AccountingReportsScreen> createState() =>
      _AccountingReportsScreenState();
}

class _AccountingReportsScreenState
    extends ConsumerState<AccountingReportsScreen> {
  void _exportCSV(
    List<AccountingInvoice> allInvoices,
    List<AccountingExpense> allExpenses,
    List<AccountingInvoice> overdueInvoices,
  ) {
    // Generate CSV for P&L
    final StringBuffer csv = StringBuffer();
    csv.writeln('ESTADO DE RESULTADOS (P&L)');
    csv.writeln('Concepto,Monto (Bs)');

    double totalIncome = 0;
    for (var i in allInvoices) {
      totalIncome += i.totalAmount;
    }
    csv.writeln(
      'Ingresos Totales (Facturación),${totalIncome.toStringAsFixed(2)}',
    );

    double totalExpense = 0;
    for (var e in allExpenses) {
      totalExpense += e.amount;
    }
    csv.writeln(
      'Egresos Totales (Costos y Gastos),${totalExpense.toStringAsFixed(2)}',
    );

    final margin = totalIncome - totalExpense;
    csv.writeln('Utilidad Neta,${margin.toStringAsFixed(2)}');

    csv.writeln('');
    csv.writeln('REPORTE DE MOROSIDAD (Cuentas por Cobrar)');
    csv.writeln('Cliente,Fecha Venc.,Monto,Estado');
    for (var inv in overdueInvoices) {
      csv.writeln(
        'Cliente ${inv.customerId},${inv.dueDate.toString().substring(0, 10)},${inv.totalAmount},VENCIDO',
      );
    }

    downloadFileWeb(
      csv.toString(),
      'Reporte_Contable_${DateTime.now().toIso8601String().substring(0, 10)}.csv',
      'text/csv;charset=utf-8',
    );
  }

  void _refresh() {
    ref.invalidate(overdueInvoicesProvider);
    ref.invalidate(overdueExpensesProvider);
    ref.invalidate(expensesProvider);
    ref.invalidate(invoicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final overdueInvoicesAsync = ref.watch(overdueInvoicesProvider);
    final overdueExpensesAsync = ref.watch(overdueExpensesProvider);
    final expensesAsync = ref.watch(expensesProvider);
    final invoicesAsync = ref.watch(invoicesProvider);

    final isLoading =
        overdueInvoicesAsync.isLoading ||
        overdueExpensesAsync.isLoading ||
        expensesAsync.isLoading ||
        invoicesAsync.isLoading;

    final hasError =
        overdueInvoicesAsync.hasError ||
        overdueExpensesAsync.hasError ||
        expensesAsync.hasError ||
        invoicesAsync.hasError;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reportes Financieros y Morosidad')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reportes Financieros y Morosidad'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refresh,
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'Error al cargar los datos',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final overdueInvoices = overdueInvoicesAsync.value ?? [];
    final overdueExpenses = overdueExpensesAsync.value ?? [];
    final allExpenses = expensesAsync.value ?? [];
    final allInvoices = invoicesAsync.value ?? [];

    double totalIncome = allInvoices.fold(0, (sum, i) => sum + i.totalAmount);
    double totalExpense = allExpenses.fold(0, (sum, e) => sum + e.amount);
    double margin = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes Financieros y Morosidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar a CSV/Excel',
            onPressed: () =>
                _exportCSV(allInvoices, allExpenses, overdueInvoices),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de Resultados (P&L) Resumido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatInfo(
                      title: 'Ingresos Totales',
                      value: totalIncome,
                      color: Colors.green,
                    ),
                    _StatInfo(
                      title: 'Egresos Totales',
                      value: totalExpense,
                      color: Colors.red,
                    ),
                    _StatInfo(
                      title: 'Utilidad Neta',
                      value: margin,
                      color: margin >= 0 ? Colors.blue : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_download),
              label: const Text('Exportar Reportes a Excel (CSV)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  _exportCSV(allInvoices, allExpenses, overdueInvoices),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AccountingExcelGrid(
                title: 'Reporte de Morosidad (Cuentas por Cobrar Vencidas)',
                columns: [
                  ExcelGridColumn(title: 'Factura #'),
                  ExcelGridColumn(title: 'Cliente'),
                  ExcelGridColumn(title: 'Fecha Emisión'),
                  ExcelGridColumn(title: 'Fecha Vencimiento'),
                  ExcelGridColumn(title: 'Monto (Bs)', isNumeric: true),
                  ExcelGridColumn(title: 'Estado'),
                ],
                rows: overdueInvoices.map((inv) {
                  return ExcelGridRow(
                    cells: [
                      Text(inv.invoiceNumber),
                      Text(
                        'Cliente ${inv.customerId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(inv.issueDate.toString().substring(0, 10)),
                      Text(
                        inv.dueDate.toString().substring(0, 10),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(inv.totalAmount.toStringAsFixed(2)),
                      const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'VENCIDO',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AccountingExcelGrid(
                title: 'Morosidad de Proveedores (Cuentas por Pagar)',
                columns: [
                  ExcelGridColumn(title: 'Proveedor'),
                  ExcelGridColumn(title: 'Categoría'),
                  ExcelGridColumn(title: 'Fecha Vencimiento'),
                  ExcelGridColumn(title: 'Monto (Bs)', isNumeric: true),
                  ExcelGridColumn(title: 'Estado'),
                ],
                rows: overdueExpenses.map((exp) {
                  return ExcelGridRow(
                    cells: [
                      Text(
                        exp.supplierName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(exp.category),
                      Text(
                        exp.date.toString().substring(0, 10),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(exp.amount.toStringAsFixed(2)),
                      const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'VENCIDO',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatInfo extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const _StatInfo({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          'Bs ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
