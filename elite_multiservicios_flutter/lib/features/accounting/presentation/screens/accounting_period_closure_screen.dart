import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/accounting_excel_grid.dart';
import '../providers/accounting_providers.dart';

class AccountingPeriodClosureScreen extends ConsumerStatefulWidget {
  const AccountingPeriodClosureScreen({super.key});
  @override
  ConsumerState<AccountingPeriodClosureScreen> createState() =>
      _AccountingPeriodClosureScreenState();
}

class _AccountingPeriodClosureScreenState
    extends ConsumerState<AccountingPeriodClosureScreen> {
  bool _showSummaryCards = true;

  Future<void> _showNewClosureDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final nameCtrl = TextEditingController(
      text: 'Cierre ${now.month.toString().padLeft(2, '0')}-${now.year}',
    );
    final notesCtrl = TextEditingController();
    String periodType = 'MONTHLY';
    DateTime startDate = firstDayOfMonth;
    DateTime endDate = lastDayOfMonth;
    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.lock_clock, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('Ejecutar Cierre Contable'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'El cierre contable consolidará ingresos y egresos, generará el asiento de resultados y bloqueará modificaciones en el periodo.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Periodo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: periodType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Periodo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'MONTHLY',
                        child: Text('Mensual'),
                      ),
                      DropdownMenuItem(
                        value: 'ANNUAL',
                        child: Text('Anual / Fiscal'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setDlgState(() => periodType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    leading: const Icon(Icons.date_range, color: Colors.blue),
                    title: const Text('Rango de Fechas'),
                    subtitle: Text(
                      '${startDate.day}/${startDate.month}/${startDate.year}  →  ${endDate.day}/${endDate.month}/${endDate.year}',
                    ),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(
                          start: startDate,
                          end: endDate,
                        ),
                      );
                      if (picked != null) {
                        setDlgState(() {
                          startDate = picked.start;
                          endDate = picked.end;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notas u Observaciones (Opcional)',
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
                icon: const Icon(Icons.lock),
                label: const Text('Confirmar y Bloquear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  try {
                    await ref
                        .read(accountingRepositoryProvider)
                        .closeAccountingPeriod(
                          nameCtrl.text.trim(),
                          periodType,
                          startDate,
                          endDate,
                          notesCtrl.text.trim().isEmpty
                              ? null
                              : notesCtrl.text.trim(),
                          'Administrador',
                        );

                    ref.invalidate(periodClosuresProvider);

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Periodo contable cerrado y bloqueado con éxito.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al cerrar periodo: $e'),
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

  Future<void> _showReopenDialog(
    BuildContext context,
    WidgetRef ref,
    AccountingPeriodClosure closure,
  ) async {
    final reasonCtrl = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.lock_open, color: Colors.orange),
            SizedBox(width: 8),
            Text('Reapertura Excepcional'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Desea desbloquear temporalmente el periodo "${closure.periodName}"?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'La reapertura quedará registrada en el log de auditoría. Indique el motivo formal:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Motivo de la reapertura',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (reasonCtrl.text.trim().isEmpty) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Debe ingresar un motivo para reabrir.'),
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              try {
                await ref
                    .read(accountingRepositoryProvider)
                    .reopenPeriodClosure(
                      closure.id!,
                      reasonCtrl.text.trim(),
                    );

                ref.invalidate(periodClosuresProvider);

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Periodo reabierto correctamente.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Reabrir Periodo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final closuresAsync = ref.watch(periodClosuresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cierres de Periodo y Bloqueo'),
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
            onPressed: () => ref.invalidate(periodClosuresProvider),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.lock_clock),
              label: const Text('Nuevo Cierre'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _showNewClosureDialog(context, ref),
            ),
          ),
        ],
      ),
      body: closuresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
        data: (closures) {
          final double totalIncomeSum = closures.fold(
            0.0,
            (sum, c) => sum + c.totalIncome,
          );
          final double totalExpenseSum = closures.fold(
            0.0,
            (sum, c) => sum + c.totalExpense,
          );
          final double netResultSum = totalIncomeSum - totalExpenseSum;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AnimatedCrossFade(
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner de seguridad
                      Card(
                        color: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blue.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.shield_outlined,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Los periodos cerrados protegen la integridad contable. Queda estrictamente bloqueada la creación, edición o anulación de facturas y egresos en fechas de periodos bloqueados.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // KPIs
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              'Periodos Cerrados',
                              '${closures.where((c) => c.isLocked).length}',
                              Icons.lock,
                              Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              'Ingresos Consolidados',
                              '\$${totalIncomeSum.toStringAsFixed(2)}',
                              Icons.arrow_upward,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              'Egresos Consolidados',
                              '\$${totalExpenseSum.toStringAsFixed(2)}',
                              Icons.arrow_downward,
                              Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              'Resultado Neto',
                              '\$${netResultSum.toStringAsFixed(2)}',
                              Icons.account_balance,
                              netResultSum >= 0 ? Colors.teal : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tabla de Cierres
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: AccountingExcelGrid(
                    title: 'Historial de Cierres Contables y Bloqueos',
                    columns: [
                      ExcelGridColumn(title: 'Estado / Candado'),
                      ExcelGridColumn(title: 'Periodo'),
                      ExcelGridColumn(title: 'Tipo'),
                      ExcelGridColumn(title: 'Fecha Inicio'),
                      ExcelGridColumn(title: 'Fecha Fin'),
                      ExcelGridColumn(title: 'Ingresos (\$)', isNumeric: true),
                      ExcelGridColumn(title: 'Gastos (\$)', isNumeric: true),
                      ExcelGridColumn(
                        title: 'Resultado Neto (\$)',
                        isNumeric: true,
                      ),
                      ExcelGridColumn(title: 'Cerrado Por'),
                      ExcelGridColumn(title: 'Acciones'),
                    ],
                    rows: closures.map((c) {
                      final isPos = c.netResult >= 0;
                      return ExcelGridRow(
                        cells: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                c.isLocked ? Icons.lock : Icons.lock_open,
                                size: 16,
                                color: c.isLocked ? Colors.red : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                c.isLocked ? 'BLOQUEADO' : 'REABIERTO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: c.isLocked
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            c.periodName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(c.periodType == 'MONTHLY' ? 'Mensual' : 'Anual'),
                          Text(
                            '${c.startDate.day.toString().padLeft(2, '0')}/${c.startDate.month.toString().padLeft(2, '0')}/${c.startDate.year}',
                          ),
                          Text(
                            '${c.endDate.day.toString().padLeft(2, '0')}/${c.endDate.month.toString().padLeft(2, '0')}/${c.endDate.year}',
                          ),
                          Text(
                            '\$${c.totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text(
                            '\$${c.totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            '\$${c.netResult.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isPos ? Colors.teal : Colors.red,
                            ),
                          ),
                          Text(c.closedBy ?? 'Admin'),
                          c.isLocked
                              ? TextButton.icon(
                                  icon: const Icon(Icons.lock_open, size: 14),
                                  label: const Text(
                                    'Reabrir',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                  ),
                                  onPressed: () =>
                                      _showReopenDialog(context, ref, c),
                                )
                              : const Text(
                                  'Reabierto',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                        ],
                      );
                    }).toList(),
                  ),
                ), // Cierre de Expanded
              ],
            ),
          );
        },
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
