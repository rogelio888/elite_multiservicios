import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingBudgetsScreen extends ConsumerWidget {
  const AccountingBudgetsScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final projectedIncomeCtrl = TextEditingController();
    final projectedExpensesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final projInc = double.tryParse(projectedIncomeCtrl.text) ?? 0;
          final projExp = double.tryParse(projectedExpensesCtrl.text) ?? 0;
          final estBal = projInc - projExp;

          return AlertDialog(
            title: Text('Presupuesto ${now.month}/${now.year}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: projectedIncomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ingresos Proyectados (Bs)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: projectedExpensesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Gastos Proyectados (Bs)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: estBal >= 0
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Balance Estimado:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${estBal.toStringAsFixed(2)} Bs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: estBal >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final projInc =
                      double.tryParse(projectedIncomeCtrl.text) ?? 0;
                  final projExp =
                      double.tryParse(projectedExpensesCtrl.text) ?? 0;
                  if (projInc > 0 || projExp > 0) {
                    try {
                      await ref
                          .read(accountingRepositoryProvider)
                          .createBudget(
                            AccountingBudget(
                              month: now.month,
                              year: now.year,
                              projectedIncome: projInc,
                              executedIncome: 0,
                              projectedExpenses: projExp,
                              executedExpenses: 0,
                              estimatedBalance: projInc - projExp,
                            ),
                          );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ref.invalidate(budgetsProvider);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar presupuesto: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final budgetsAsync = ref.watch(budgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos y Control de Desviaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(budgetsProvider),
          ),
        ],
      ),
      body: budgetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error cargando presupuestos: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (allBudgets) {
          // Filtramos solo el mes actual como en el código original
          final currentBudgets = allBudgets
              .where((b) => b.month == now.month && b.year == now.year)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Presupuesto ${now.month}/${now.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showAddDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Nuevo Presupuesto'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: currentBudgets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bar_chart_outlined,
                                size: 64,
                                color: Theme.of(context).disabledColor,
                              ),
                              const SizedBox(height: 16),
                              const Text('No hay presupuesto para este mes'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _showAddDialog(context, ref),
                                child: const Text('Crear Presupuesto'),
                              ),
                            ],
                          ),
                        )
                      : AccountingExcelGrid(
                          title: 'Control de Presupuesto Mensual',
                          columns: [
                            ExcelGridColumn(title: 'Mes/Año'),
                            ExcelGridColumn(
                              title: 'Ingresos Proyect. (Bs)',
                              isNumeric: true,
                            ),
                            ExcelGridColumn(
                              title: 'Ingresos Ejecut. (Bs)',
                              isNumeric: true,
                            ),
                            ExcelGridColumn(
                              title: 'Gastos Proyect. (Bs)',
                              isNumeric: true,
                            ),
                            ExcelGridColumn(
                              title: 'Gastos Ejecut. (Bs)',
                              isNumeric: true,
                            ),
                            ExcelGridColumn(
                              title: 'Balance Est. (Bs)',
                              isNumeric: true,
                            ),
                            ExcelGridColumn(title: 'Estado'),
                          ],
                          rows: currentBudgets.map((b) {
                            final devInc = b.executedIncome - b.projectedIncome;
                            final devExp =
                                b.executedExpenses - b.projectedExpenses;
                            final isOnTrack = devExp <= 0 && devInc >= 0;
                            return ExcelGridRow(
                              cells: [
                                Text(
                                  '${b.month}/${b.year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(b.projectedIncome.toStringAsFixed(2)),
                                Text(
                                  b.executedIncome.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: devInc < 0
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                                Text(b.projectedExpenses.toStringAsFixed(2)),
                                Text(
                                  b.executedExpenses.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: devExp > 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                Text(
                                  b.estimatedBalance.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: b.estimatedBalance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: isOnTrack
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isOnTrack ? 'Normal' : 'Desviación',
                                      style: TextStyle(
                                        color: isOnTrack
                                            ? Colors.green
                                            : Colors.orange,
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
          );
        },
      ),
    );
  }
}
