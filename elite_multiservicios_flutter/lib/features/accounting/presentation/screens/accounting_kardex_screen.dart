import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart';
import '../widgets/accounting_excel_grid.dart';
import '../providers/accounting_providers.dart';

class AccountingKardexScreen extends ConsumerStatefulWidget {
  const AccountingKardexScreen({super.key});

  @override
  ConsumerState<AccountingKardexScreen> createState() =>
      _AccountingKardexScreenState();
}

class _AccountingKardexScreenState
    extends ConsumerState<AccountingKardexScreen> {
  bool _showSummaryCards = true;
  bool _isLoadingInventory = true;
  List<OpsInventoryItem> _inventoryItems = [];
  int? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoadingInventory = true);
    try {
      final items = await client.ops.getInventory();
      if (!mounted) return;
      setState(() {
        _inventoryItems = items;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar inventario: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingInventory = false);
    }
  }

  Future<void> _showNewMovementDialog() async {
    if (_inventoryItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay items en inventario registrados.'),
        ),
      );
      return;
    }

    int selectedItem = _selectedItemId ?? _inventoryItems.first.id!;
    String movementType = 'IN_PURCHASE';

    final currentItem = _inventoryItems.firstWhere(
      (i) => i.id == selectedItem,
      orElse: () => _inventoryItems.first,
    );

    final qtyCtrl = TextEditingController(text: '1.0');
    final costCtrl = TextEditingController(
      text: currentItem.averageCost.toStringAsFixed(2),
    );
    final refCtrl = TextEditingController(text: 'FAC-COMPRA-');
    final otCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          final dialogItem = _inventoryItems.firstWhere(
            (i) => i.id == selectedItem,
            orElse: () => _inventoryItems.first,
          );

          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.inventory, color: Colors.blue),
                SizedBox(width: 8),
                Text('Registrar Movimiento de Kárdex'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actualiza existencias y recalcula automáticamente el Costo Promedio Ponderado e impacto en el Libro Mayor.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: selectedItem,
                    decoration: const InputDecoration(
                      labelText: 'Artículo / Insumo',
                      border: OutlineInputBorder(),
                    ),
                    items: _inventoryItems.map((item) {
                      return DropdownMenuItem<int>(
                        value: item.id,
                        child: Text(
                          '${item.name} (Stock: ${item.quantityInStock} ${item.unit})',
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDlgState(() {
                          selectedItem = val;
                          final itm = _inventoryItems.firstWhere(
                            (i) => i.id == val,
                          );
                          costCtrl.text = itm.averageCost.toStringAsFixed(2);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: movementType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Movimiento',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'IN_PURCHASE',
                        child: Text('📥 Entrada por Compra (Suma Stock)'),
                      ),
                      DropdownMenuItem(
                        value: 'OUT_WORK_ORDER',
                        child: Text(
                          '📤 Salida por Orden de Trabajo (Resta Stock)',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'IN_ADJUSTMENT',
                        child: Text('⚖️ Ajuste Positivo (+)'),
                      ),
                      DropdownMenuItem(
                        value: 'OUT_ADJUSTMENT',
                        child: Text('⚖️ Ajuste Negativo (-)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDlgState(() {
                          movementType = val;
                          if (val == 'OUT_WORK_ORDER') {
                            refCtrl.text = 'Consumo Técnico';
                          } else if (val == 'IN_PURCHASE') {
                            refCtrl.text = 'FAC-COMPRA-';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Cantidad (${dialogItem.unit})',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: costCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Costo Unitario (\$)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: refCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Documento de Referencia / Factura',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (movementType == 'OUT_WORK_ORDER') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: otCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'N° de Orden de Trabajo (OT)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notas o Justificación (Opcional)',
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
                icon: const Icon(Icons.save),
                label: const Text('Registrar en Kárdex'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
                  final cost = double.tryParse(costCtrl.text) ?? 0.0;
                  final otId = int.tryParse(otCtrl.text);

                  if (qty <= 0) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Ingrese una cantidad válida mayor a 0.'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  try {
                    await ref
                        .read(accountingRepositoryProvider)
                        .recordKardexMovement(
                          itemId: selectedItem,
                          movementType: movementType,
                          quantity: qty,
                          unitCost: cost,
                          referenceDoc: refCtrl.text.trim().isEmpty
                              ? 'S/R'
                              : refCtrl.text.trim(),
                          workOrderId: otId,
                          notes: notesCtrl.text.trim().isEmpty
                              ? null
                              : notesCtrl.text.trim(),
                        );

                    // Refrescar inventario local y kardex
                    _loadInventory();
                    ref.invalidate(kardexMovementsProvider);

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Movimiento de Kárdex asentado exitosamente.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al asentar movimiento: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
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
    final kardexAsync = ref.watch(kardexMovementsProvider(_selectedItemId));

    final totalInventoryValuation = _inventoryItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.quantityInStock * item.averageCost),
    );
    final totalStockUnits = _inventoryItems.fold<double>(
      0.0,
      (sum, item) => sum + item.quantityInStock,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kárdex Valuado e Inventario'),
        actions: [
          IconButton(
            icon: Icon(
              _showSummaryCards ? Icons.expand_less : Icons.expand_more,
              color: Colors.blueAccent,
            ),
            tooltip: _showSummaryCards ? 'Ocultar resumen' : 'Mostrar resumen',
            onPressed: () {
              setState(() {
                _showSummaryCards = !_showSummaryCards;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadInventory();
              ref.invalidate(kardexMovementsProvider);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Nuevo Movimiento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _showNewMovementDialog,
            ),
          ),
        ],
      ),
      body: _isLoadingInventory
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KPI Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                'Valoración Total Inventario',
                                '\$${totalInventoryValuation.toStringAsFixed(2)}',
                                Icons.account_balance_wallet,
                                Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                'Unidades en Existencia',
                                totalStockUnits.toStringAsFixed(1),
                                Icons.inventory_2,
                                Colors.teal,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                'Artículos Registrados',
                                '${_inventoryItems.length}',
                                Icons.category,
                                Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: kardexAsync.when(
                                data: (movements) => _buildMetricCard(
                                  'Movimientos Kárdex',
                                  '${movements.length}',
                                  Icons.history,
                                  Colors.orange,
                                ),
                                loading: () => _buildMetricCard(
                                  'Movimientos Kárdex',
                                  '...',
                                  Icons.history,
                                  Colors.orange,
                                ),
                                error: (err, stack) => _buildMetricCard(
                                  'Movimientos Kárdex',
                                  'Error',
                                  Icons.history,
                                  Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Filtro por Item
                        Row(
                          children: [
                            const Text(
                              'Filtrar por Artículo:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<int?>(
                                value: _selectedItemId,
                                isExpanded: true,
                                hint: const Text(
                                  'Todos los artículos de inventario',
                                ),
                                items: [
                                  const DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text(
                                      'Todos los artículos (General)',
                                    ),
                                  ),
                                  ..._inventoryItems.map((item) {
                                    return DropdownMenuItem<int?>(
                                      value: item.id,
                                      child: Text(
                                        '${item.name} — Stock: ${item.quantityInStock} ${item.unit} | CPP: \$${item.averageCost.toStringAsFixed(2)}',
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (val) {
                                  setState(() => _selectedItemId = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tabla Kárdex
                      ],
                    ),
                    secondChild: const SizedBox(
                      width: double.infinity,
                      height: 0,
                    ),
                    crossFadeState: _showSummaryCards
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                  Expanded(
                    child: kardexAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error cargando movimientos: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (movements) => AccountingExcelGrid(
                        title:
                            'Libro de Kárdex Contable (Costo Promedio Ponderado)',
                        columns: [
                          ExcelGridColumn(title: 'Fecha'),
                          ExcelGridColumn(title: 'Artículo'),
                          ExcelGridColumn(title: 'Tipo'),
                          ExcelGridColumn(title: 'Doc. Referencia'),
                          ExcelGridColumn(title: 'O.T.'),
                          ExcelGridColumn(title: 'Cantidad', isNumeric: true),
                          ExcelGridColumn(
                            title: 'Costo Unit. Ponderado (\$)',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Total Movimiento (\$)',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Saldo Unidades',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Valoración Total (\$)',
                            isNumeric: true,
                          ),
                        ],
                        rows: movements.map((m) {
                          final isEntry =
                              m.movementType == 'IN_PURCHASE' ||
                              m.movementType == 'IN_ADJUSTMENT';
                          return ExcelGridRow(
                            cells: [
                              Text(
                                '${m.date.day.toString().padLeft(2, '0')}/${m.date.month.toString().padLeft(2, '0')}/${m.date.year}',
                              ),
                              Text(
                                m.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isEntry
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    size: 14,
                                    color: isEntry ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isEntry ? 'ENTRADA' : 'SALIDA',
                                    style: TextStyle(
                                      color: isEntry
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              Text(m.referenceDoc),
                              Text(
                                m.workOrderId != null
                                    ? '#${m.workOrderId}'
                                    : '-',
                              ),
                              Text(
                                m.quantity.toStringAsFixed(2),
                                style: TextStyle(
                                  color: isEntry ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('\$${m.unitCost.toStringAsFixed(2)}'),
                              Text(
                                '\$${m.totalCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                m.balanceQuantity.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${m.balanceTotalCost.toStringAsFixed(2)}',
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
                  ), // Cierre de Expanded
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
