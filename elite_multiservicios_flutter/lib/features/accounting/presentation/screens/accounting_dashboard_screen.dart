import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingDashboardScreen extends ConsumerWidget {
  const AccountingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos los proveedores asíncronos
    final summaryAsync = ref.watch(financialSummaryProvider);
    final budgetsAsync = ref.watch(budgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Contabilidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresca ambos proveedores
              ref.invalidate(financialSummaryProvider);
              ref.invalidate(budgetsProvider);
            },
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error cargando el resumen financiero:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (summary) {
          // Extraemos los valores del summary
          final projectedIncome = summary.projectedIncome;
          final totalIncome = summary.totalIncome;
          final projectedExpenses = summary.projectedExpenses;
          final totalExpenses = summary.totalExpenses;
          final pettyCashBalance = summary.pettyCashBalance;
          final balance = summary.balance;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Presupuesto Proyectado vs Ejecutado',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Ingresos Proyectados',
                        projectedIncome,
                        Colors.green.shade200,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Ingresos Reales',
                        totalIncome,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Gastos Proyectados',
                        projectedExpenses,
                        Colors.red.shade200,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Gastos Reales',
                        totalExpenses,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Tabla Excel de Presupuestos (manejando su propio estado AsyncValue)
                SizedBox(
                  height: 300,
                  child: budgetsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Text('Error cargando presupuestos: $error'),
                    ),
                    data: (budgets) {
                      List<AccountingBudget> displayBudgets = budgets;

                      // Si no hay presupuestos, generamos uno temporal basado en el summary actual para la vista
                      if (displayBudgets.isEmpty) {
                        displayBudgets = [
                          AccountingBudget(
                            month: DateTime.now().month,
                            year: DateTime.now().year,
                            projectedIncome: summary.projectedIncome,
                            executedIncome: summary.totalIncome,
                            projectedExpenses: summary.projectedExpenses,
                            executedExpenses: summary.totalExpenses,
                            estimatedBalance:
                                summary.projectedIncome -
                                summary.projectedExpenses,
                          ),
                        ];
                      }

                      return AccountingExcelGrid(
                        title: 'Hoja de Control Mensual',
                        columns: [
                          ExcelGridColumn(title: 'Mes/Año'),
                          ExcelGridColumn(
                            title: 'Proy. Ingresos',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Ejec. Ingresos',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Proy. Gastos',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Ejec. Gastos',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Estimación Saldo',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(title: 'Saldo Real', isNumeric: true),
                        ],
                        rows: displayBudgets.map((b) {
                          return ExcelGridRow(
                            cells: [
                              Text('${b.month}/${b.year}'),
                              Text(
                                b.projectedIncome.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                b.executedIncome.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                b.projectedExpenses.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.red),
                              ),
                              Text(
                                b.executedExpenses.toStringAsFixed(2),
                                style: const TextStyle(color: Colors.red),
                              ),
                              Text(
                                b.estimatedBalance.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (b.executedIncome - b.executedExpenses)
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Fondos Actuales',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Caja Chica',
                        pettyCashBalance,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Balance General',
                        balance,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Bs ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
