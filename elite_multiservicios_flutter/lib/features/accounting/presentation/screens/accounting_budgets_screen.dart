import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingBudgetsScreen extends StatefulWidget {
  const AccountingBudgetsScreen({super.key});

  @override
  State<AccountingBudgetsScreen> createState() =>
      _AccountingBudgetsScreenState();
}

class _AccountingBudgetsScreenState extends State<AccountingBudgetsScreen> {
  bool _isLoading = true;
  List<AccountingBudget> _budgets = [];
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final budgets = await client.accounting.getBudgets();
      if (!mounted) return;
      setState(() {
        _budgets = budgets
            .where((b) => b.month == _now.month && b.year == _now.year)
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
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
            title: Text('Presupuesto ${_now.month}/${_now.year}'),
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
                    await client.accounting.createBudget(
                      AccountingBudget(
                        month: _now.month,
                        year: _now.year,
                        projectedIncome: projInc,
                        executedIncome: 0,
                        projectedExpenses: projExp,
                        executedExpenses: 0,
                        estimatedBalance: projInc - projExp,
                      ),
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    _loadData();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuestos y Control de Desviaciones'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Presupuesto ${_now.month}/${_now.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Nuevo Presupuesto'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _budgets.isEmpty
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
                                  onPressed: _showAddDialog,
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
                            rows: _budgets.map((b) {
                              final devInc =
                                  b.executedIncome - b.projectedIncome;
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
            ),
    );
  }
}
