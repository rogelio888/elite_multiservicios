import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client
import '../widgets/accounting_excel_grid.dart';

class AccountingDashboardScreen extends StatefulWidget {
  const AccountingDashboardScreen({super.key});

  @override
  State<AccountingDashboardScreen> createState() =>
      _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends State<AccountingDashboardScreen> {
  bool _isLoading = true;
  double _totalIncome = 0;
  double _totalExpenses = 0;
  double _projectedIncome = 0;
  double _projectedExpenses = 0;
  double _pettyCashBalance = 0;
  double _balance = 0;

  List<AccountingBudget> _budgets = [];

  @override
  void initState() {
    super.initState();
    _loadFinancialSummary();
  }

  Future<void> _loadFinancialSummary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final summary = await client.accounting.getFinancialSummary();
      final budgets = await client.accounting.getBudgets();

      if (!mounted) return;
      setState(() {
        _totalIncome = summary.totalIncome;
        _totalExpenses = summary.totalExpenses;
        _projectedIncome = summary.projectedIncome;
        _projectedExpenses = summary.projectedExpenses;
        _pettyCashBalance = summary.pettyCashBalance;
        _balance = summary.balance;

        // Si no hay presupuestos, generamos uno temporal basado en el summary actual para la vista (simulación)
        if (budgets.isEmpty) {
          _budgets = [
            AccountingBudget(
              month: DateTime.now().month,
              year: DateTime.now().year,
              projectedIncome: summary.projectedIncome,
              executedIncome: summary.totalIncome,
              projectedExpenses: summary.projectedExpenses,
              executedExpenses: summary.totalExpenses,
              estimatedBalance:
                  summary.projectedIncome - summary.projectedExpenses,
            ),
          ];
        } else {
          _budgets = budgets;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando el resumen financiero: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Contabilidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFinancialSummary,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          _projectedIncome,
                          Colors.green.shade200,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Ingresos Reales',
                          _totalIncome,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Gastos Proyectados',
                          _projectedExpenses,
                          Colors.red.shade200,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Gastos Reales',
                          _totalExpenses,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Nuevo: Tabla Excel de Presupuestos
                  SizedBox(
                    height: 300,
                    child: AccountingExcelGrid(
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
                        ExcelGridColumn(title: 'Proy. Gastos', isNumeric: true),
                        ExcelGridColumn(title: 'Ejec. Gastos', isNumeric: true),
                        ExcelGridColumn(
                          title: 'Estimación Saldo',
                          isNumeric: true,
                        ),
                        ExcelGridColumn(title: 'Saldo Real', isNumeric: true),
                      ],
                      rows: _budgets.map((b) {
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
                          _pettyCashBalance,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Balance General',
                          _balance,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
