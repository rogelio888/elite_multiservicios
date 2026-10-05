import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/accounting_excel_grid.dart';

// Este provider debería estar en accounting_providers.dart, lo simulamos localmente para UI
final recurringContractsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return [
    {
      'id': 'CTR-001',
      'client': 'Condominio Las Palmas',
      'service': 'Mantenimiento Preventivo Áreas Verdes',
      'amount': 2500.00,
      'frequency': 'Mensual',
      'nextBilling': DateTime.now().add(const Duration(days: 2)),
      'status': 'Activo',
      'autoCharge': true,
    },
    {
      'id': 'CTR-042',
      'client': 'Edificio Torre Azul',
      'service': 'Mantenimiento Ascensores',
      'amount': 4500.00,
      'frequency': 'Mensual',
      'nextBilling': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Pendiente Emisión',
      'autoCharge': false,
    },
    {
      'id': 'CTR-018',
      'client': 'Clínica San Juan',
      'service': 'Limpieza y Desinfección Hospitalaria',
      'amount': 12000.00,
      'frequency': 'Quincenal',
      'nextBilling': DateTime.now().add(const Duration(days: 10)),
      'status': 'Activo',
      'autoCharge': true,
    }
  ];
});

class AccountingRecurringBillingScreen extends ConsumerStatefulWidget {
  const AccountingRecurringBillingScreen({super.key});
  @override
  ConsumerState<AccountingRecurringBillingScreen> createState() => _AccountingRecurringBillingScreenState();
}
class _AccountingRecurringBillingScreenState extends ConsumerState<AccountingRecurringBillingScreen> {
  bool _showSummaryCards = true;

  @override
  Widget build(BuildContext context) {
    final contractsAsync = ref.watch(recurringContractsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación Recurrente (Igualas / Contratos)', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showSummaryCards ? Icons.expand_less : Icons.expand_more, color: Colors.blueAccent),
            tooltip: _showSummaryCards ? 'Ocultar resumen' : 'Mostrar resumen',
            onPressed: () { setState(() { _showSummaryCards = !_showSummaryCards; }); },
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ejecutando facturación por lotes...'), backgroundColor: Colors.blueAccent),
              );
            },
            icon: const Icon(Icons.bolt, size: 18),
            label: const Text('Ejecutar Lote Pendiente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: contractsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (contracts) {
          final activeCount = contracts.where((c) => c['status'] == 'Activo').length;
          final pendingCount = contracts.where((c) => c['status'] == 'Pendiente Emisión').length;
          final totalMonthly = contracts.fold(0.0, (sum, c) => sum + (c['amount'] as double));

          return SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              children: [                AnimatedCrossFade(
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPIs de Suscripciones
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Contratos Activos', activeCount.toString(), Icons.handshake, [Colors.teal.shade500, Colors.teal.shade700])),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Facturas Pendientes Emisión', pendingCount.toString(), Icons.pending_actions, [Colors.orange.shade500, Colors.orange.shade700])),
                    const SizedBox(width: 16),
                    
                    
                Expanded(child: _buildMetricCard('Ingreso Mensual Base (MRR)', 'Bs ${totalMonthly.toStringAsFixed(2)}', Icons.payments, [Colors.indigo.shade500, Colors.indigo.shade700])),
                  ],
                ),
                const SizedBox(height: 32),
                    ],
                  ),
                  secondChild: const SizedBox(width: double.infinity, height: 0),
                  crossFadeState: _showSummaryCards ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.7, child: AccountingExcelGrid(
                    title: 'Pólizas de Mantenimiento y Facturación Automática',
                    columns: [
                      ExcelGridColumn(title: 'ID Contrato (CRM)'),
                      ExcelGridColumn(title: 'Cliente'),
                      ExcelGridColumn(title: 'Servicio Contratado'),
                      ExcelGridColumn(title: 'Frecuencia'),
                      ExcelGridColumn(title: 'Cuota (Bs)', isNumeric: true),
                      ExcelGridColumn(title: 'Próxima Facturación'),
                      ExcelGridColumn(title: 'Cargo Auto.'),
                      ExcelGridColumn(title: 'Estado Motor'),
                      ExcelGridColumn(title: 'Acciones'),
                    ],
                    rows: contracts.map((c) {
                      final isPending = c['status'] == 'Pendiente Emisión';
                      final nextDate = c['nextBilling'] as DateTime;
                      final dateStr = '${nextDate.day.toString().padLeft(2, '0')}/${nextDate.month.toString().padLeft(2, '0')}/${nextDate.year}';
                      
                      return ExcelGridRow(
                        cells: [
                          Row(
                            children: [
                              const Icon(Icons.assignment, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(c['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent)),
                            ],
                          ),
                          Text(c['client'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(c['service'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
                            child: Text(c['frequency'], style: const TextStyle(fontSize: 11)),
                          ),
                          Text(c['amount'].toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                          Text(dateStr, style: TextStyle(color: isPending ? Colors.red : null, fontWeight: isPending ? FontWeight.bold : FontWeight.normal)),
                          Icon(c['autoCharge'] ? Icons.check_circle : Icons.cancel, color: c['autoCharge'] ? Colors.green : Colors.grey, size: 18),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPending ? Colors.orange.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(
                              c['status'],
                              style: TextStyle(color: isPending ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          IconButton(
                            icon: Icon(isPending ? Icons.receipt_long : Icons.edit, color: isPending ? Colors.orange : Colors.grey, size: 18),
                            onPressed: () {
                              if (isPending) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Generando factura para ${c['client']}...'), backgroundColor: Colors.tealAccent),
                                );
                              }
                            },
                          ),
                        ]
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ));
        }
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, List<Color> gradientColors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: gradientColors.last.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
