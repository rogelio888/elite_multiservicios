import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingBudgetsScreen extends StatefulWidget {
  const AccountingBudgetsScreen({super.key});

  @override
  State<AccountingBudgetsScreen> createState() => _AccountingBudgetsScreenState();
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
      final budgets = await client.accounting.getBudgets(_now.year, _now.month);
      if (!mounted) return;
      setState(() {
        _budgets = budgets;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final limitController = TextEditingController();
    String category = 'Nómina';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Presupuesto para ${_now.month}/${_now.year}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: category,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Nómina', child: Text('Nómina')),
                  DropdownMenuItem(value: 'Insumos Operativos', child: Text('Insumos Operativos')),
                  DropdownMenuItem(value: 'Servicios', child: Text('Servicios Básicos')),
                  DropdownMenuItem(value: 'Mantenimiento', child: Text('Mantenimiento Vehículos')),
                ],
                onChanged: (val) => setDialogState(() => category = val!),
              ),
              TextField(
                controller: limitController,
                decoration: const InputDecoration(labelText: 'Límite Máximo (Bs)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final limit = double.tryParse(limitController.text) ?? 0;
                if (limit > 0) {
                  await client.accounting.createOrUpdateBudget(
                    AccountingBudget(
                      category: category,
                      month: _now.month,
                      year: _now.year,
                      limitAmount: limit,
                      consumedAmount: 0,
                      createdAt: _now,
                      updatedAt: _now,
                    ),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: const Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presupuestos y Control de Desviaciones')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Presupuesto Mes Actual: ${_now.month}/${_now.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Asignar Nuevo Tope'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AccountingExcelGrid(
                      title: 'Control de Presupuestos',
                      columns: [
                        ExcelGridColumn(title: 'Categoría'),
                        ExcelGridColumn(title: 'Límite Asignado (Bs)', isNumeric: true),
                        ExcelGridColumn(title: 'Consumido (Bs)', isNumeric: true),
                        ExcelGridColumn(title: 'Disponible (Bs)', isNumeric: true),
                        ExcelGridColumn(title: 'Estado'),
                      ],
                      rows: _budgets.map((b) {
                        final available = b.limitAmount - b.consumedAmount;
                        final percent = (b.consumedAmount / b.limitAmount) * 100;
                        Color statusColor = Colors.green;
                        String statusText = 'Normal';
                        if (percent >= 100) {
                          statusColor = Colors.red;
                          statusText = 'Excedido';
                        } else if (percent >= 80) {
                          statusColor = Colors.orange;
                          statusText = 'Peligro (>80%)';
                        }

                        return ExcelGridRow(
                          cells: [
                            Text(b.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(b.limitAmount.toStringAsFixed(2)),
                            Text(b.consumedAmount.toStringAsFixed(2), style: TextStyle(color: percent > 100 ? Colors.red : null)),
                            Text(available.toStringAsFixed(2)),
                            Row(
                              children: [
                                Icon(Icons.circle, color: statusColor, size: 12),
                                const SizedBox(width: 8),
                                Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
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
