import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingWorkOrderCostingScreen extends StatefulWidget {
  const AccountingWorkOrderCostingScreen({super.key});

  @override
  State<AccountingWorkOrderCostingScreen> createState() =>
      _AccountingWorkOrderCostingScreenState();
}

class _AccountingWorkOrderCostingScreenState
    extends State<AccountingWorkOrderCostingScreen> {
  bool _isLoading = true;
  List<AccountingWorkOrderCostSummary> _costSummaries = [];

  @override
  void initState() {
    super.initState();
    _loadCostingData();
  }

  Future<void> _loadCostingData() async {
    setState(() => _isLoading = true);
    try {
      final summaries = await client.accounting.getWorkOrderCosting();
      if (!mounted) return;
      setState(() => _costSummaries = summaries);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar costeo de órdenes: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showQuickInvoiceDialog(
    AccountingWorkOrderCostSummary summary,
  ) async {
    final suggestedAmount = summary.totalCost > 0
        ? (summary.totalCost * 1.35) // Margen sugerido del 35%
        : 150.0;

    final amountCtrl = TextEditingController(
      text: suggestedAmount.toStringAsFixed(2),
    );
    final clientNameCtrl = TextEditingController(
      text: summary.clientName ?? 'Cliente General',
    );
    final notesCtrl = TextEditingController(
      text: 'Servicio técnico realizado bajo OT #${summary.workOrderId}.',
    );
    DateTime dueDate = DateTime.now().add(const Duration(days: 15));
    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.green),
                const SizedBox(width: 8),
                Text('Facturar Orden de Trabajo #${summary.workOrderId}'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Costo Directo Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${summary.totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: clientNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre / Razón Social del Cliente',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Monto Total a Facturar (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    leading: const Icon(Icons.event, color: Colors.blueAccent),
                    title: const Text('Fecha de Vencimiento de Pago'),
                    subtitle: Text(
                      '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                    ),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDlgState(() => dueDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notas / Concepto Factura',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Generar Factura Contable'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                  if (amount <= 0) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Ingrese un monto a facturar válido.'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  setState(() => _isLoading = true);
                  try {
                    await client.accounting.createInvoiceFromWorkOrder(
                      workOrderId: summary.workOrderId,
                      billedAmount: amount,
                      clientName: clientNameCtrl.text.trim(),
                      dueDate: dueDate,
                      notes: notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim(),
                    );
                    _loadCostingData();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Factura de servicio generada y vinculada a la OT exitosamente.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al generar factura: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalBilled = _costSummaries.fold(
      0.0,
      (sum, s) => sum + s.invoicedAmount,
    );
    final double totalCosts = _costSummaries.fold(
      0.0,
      (sum, s) => sum + s.totalCost,
    );
    final double totalProfit = totalBilled - totalCosts;
    final double avgMargin = totalBilled > 0
        ? (totalProfit / totalBilled) * 100
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Costeo de Órdenes de Trabajo (OT)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCostingData,
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
                  // KPI Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Facturación Órdenes',
                          '\$${totalBilled.toStringAsFixed(2)}',
                          Icons.receipt,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          'Costos Directos Totales',
                          '\$${totalCosts.toStringAsFixed(2)}',
                          Icons.shopping_cart,
                          Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          'Margen Bruto Total',
                          '\$${totalProfit.toStringAsFixed(2)}',
                          Icons.trending_up,
                          totalProfit >= 0 ? Colors.teal : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          'Rentabilidad Media',
                          '${avgMargin.toStringAsFixed(1)}%',
                          Icons.pie_chart,
                          avgMargin >= 25 ? Colors.blue : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tabla de Costeo
                  AccountingExcelGrid(
                    title:
                        'Desglose de Costos y Rentabilidad por Servicio / OT',
                    columns: [
                      ExcelGridColumn(title: 'N° OT'),
                      ExcelGridColumn(title: 'Fecha'),
                      ExcelGridColumn(title: 'Estado Servicio'),
                      ExcelGridColumn(
                        title: 'Materiales Kárdex (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(
                        title: 'Mano de Obra (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(
                        title: 'Otros Gastos (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(
                        title: 'Costo Total Directo (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(
                        title: 'Facturación (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(
                        title: 'Margen Bruto (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(title: 'Margen (%)', isNumeric: true),
                      ExcelGridColumn(title: 'Acción Facturación'),
                    ],
                    rows: _costSummaries.map((s) {
                      final hasProfit = s.grossMargin >= 0;
                      return ExcelGridRow(
                        cells: [
                          Text(
                            'OT #${s.workOrderId}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${s.workOrderDate.day.toString().padLeft(2, '0')}/${s.workOrderDate.month.toString().padLeft(2, '0')}/${s.workOrderDate.year}',
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: s.workOrderStatus == 'Completado'
                                  ? Colors.green.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              s.workOrderStatus,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: s.workOrderStatus == 'Completado'
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          Text('\$${s.materialsCost.toStringAsFixed(2)}'),
                          Text('\$${s.laborCost.toStringAsFixed(2)}'),
                          Text('\$${s.otherExpenses.toStringAsFixed(2)}'),
                          Text(
                            '\$${s.totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${s.invoicedAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: s.isBilled ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${s.grossMargin.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: hasProfit ? Colors.teal : Colors.red,
                            ),
                          ),
                          Text(
                            '${s.grossMarginPercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: s.grossMarginPercentage >= 20
                                  ? Colors.green
                                  : (s.grossMarginPercentage > 0
                                        ? Colors.orange
                                        : Colors.red),
                            ),
                          ),
                          s.isBilled
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Facturado',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              : ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.receipt_long,
                                    size: 14,
                                  ),
                                  label: const Text(
                                    'Facturar 1-Clic',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                  onPressed: () => _showQuickInvoiceDialog(s),
                                ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
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
