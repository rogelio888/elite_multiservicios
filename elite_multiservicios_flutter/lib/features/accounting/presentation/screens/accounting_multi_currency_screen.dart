import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/accounting_excel_grid.dart';

// Este provider simula los saldos en moneda extranjera y el tipo de cambio oficial
final multiCurrencyProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return {
    'exchangeRate': 6.96,
    'lastUpdate': DateTime.now().subtract(const Duration(hours: 2)),
    'accounts': [
      {
        'id': 'ACT-USD-01',
        'name': 'Banco FIE Cta. Dólares',
        'balanceUsd': 15000.00,
        'historicExchangeRate': 6.86, // Tipo de cambio al que ingresó
        'currentExchangeRate': 6.96, // Tipo de cambio actual
      },
      {
        'id': 'CXC-USD-04',
        'name': 'Cuentas por Cobrar Ext.',
        'balanceUsd': 4500.00,
        'historicExchangeRate': 6.96,
        'currentExchangeRate': 6.96,
      },
      {
        'id': 'CXP-USD-12',
        'name': 'Proveedores Repuestos USD',
        'balanceUsd': -2800.00,
        'historicExchangeRate': 6.90,
        'currentExchangeRate': 6.96,
      }
    ]
  };
});

class AccountingMultiCurrencyScreen extends ConsumerStatefulWidget {
  const AccountingMultiCurrencyScreen({super.key});
  @override
  ConsumerState<AccountingMultiCurrencyScreen> createState() => _AccountingMultiCurrencyScreenState();
}
class _AccountingMultiCurrencyScreenState extends ConsumerState<AccountingMultiCurrencyScreen> {
  bool _showSummaryCards = true;

  @override
  Widget build(BuildContext context) {
    final currencyDataAsync = ref.watch(multiCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor Multimoneda y Diferencia de Cambio', style: TextStyle(fontWeight: FontWeight.bold)),
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
                const SnackBar(content: Text('Asiento de Ajuste por Diferencia de Cambio generado exitosamente en el Libro Mayor.'), backgroundColor: Colors.blueAccent),
              );
            },
            icon: const Icon(Icons.account_balance, size: 18),
            label: const Text('Contabilizar Ajustes'),
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
      body: currencyDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (data) {
          final double currentRate = data['exchangeRate'];
          final DateTime lastUpdate = data['lastUpdate'];
          final List accounts = data['accounts'] as List;

          double totalGainLoss = 0;

          for (var account in accounts) {
            double balanceUsd = account['balanceUsd'];
            double historicRate = account['historicExchangeRate'];
            double balanceHistoricBs = balanceUsd * historicRate;
            double balanceCurrentBs = balanceUsd * currentRate;
            
            // Si es positivo (Activo), subida de TC = Ganancia. Si es pasivo (negativo), subida de TC = Pérdida.
            double diff = balanceCurrentBs - balanceHistoricBs;
            totalGainLoss += diff;
          }

          final isGain = totalGainLoss >= 0;

          return SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              children: [                AnimatedCrossFade(
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Banner
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.teal.shade800, Colors.teal.shade500]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.tealAccent.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.currency_exchange, color: Colors.white, size: 40),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const Text('Tipo de Cambio Oficial (BCB)', style: TextStyle(fontSize: 16, color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('1 USD = $currentRate Bs', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Actualizado el', style: TextStyle(fontSize: 14, color: Colors.white70)),
                          Text('${lastUpdate.day.toString().padLeft(2, '0')}/${lastUpdate.month.toString().padLeft(2, '0')}/${lastUpdate.year} ${lastUpdate.hour.toString().padLeft(2, '0')}:${lastUpdate.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // KPIs
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Exposición Activa (Caja/CxC)', '\$ 19,500.00', Icons.arrow_upward, [Colors.blue.shade500, Colors.blue.shade700])),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Exposición Pasiva (CxP)', '\$ 2,800.00', Icons.arrow_downward, [Colors.orange.shade500, Colors.orange.shade700])),
                    const SizedBox(width: 16),
                    
                    
                Expanded(
                      child: _buildMetricCard(
                        isGain ? 'Ganancia por Tipo de Cambio' : 'Pérdida por Tipo de Cambio', 
                        'Bs ${totalGainLoss.abs().toStringAsFixed(2)}', 
                        isGain ? Icons.trending_up : Icons.trending_down, 
                        isGain ? [Colors.green.shade500, Colors.green.shade700] : [Colors.red.shade500, Colors.red.shade700]
                      )
                    ),
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
                    title: 'Revaluación de Saldos en Moneda Extranjera (USD)',
                    columns: [
                      ExcelGridColumn(title: 'Código Cuenta'),
                      ExcelGridColumn(title: 'Nombre de la Cuenta'),
                      ExcelGridColumn(title: 'Saldo Original (USD)', isNumeric: true),
                      ExcelGridColumn(title: 'T.C. Histórico', isNumeric: true),
                      ExcelGridColumn(title: 'Saldo Histórico (Bs)', isNumeric: true),
                      ExcelGridColumn(title: 'T.C. Actual', isNumeric: true),
                      ExcelGridColumn(title: 'Saldo Actualizado (Bs)', isNumeric: true),
                      ExcelGridColumn(title: 'Diferencia (Bs)', isNumeric: true),
                    ],
                    rows: accounts.map((c) {
                      double balanceUsd = c['balanceUsd'];
                      double historicRate = c['historicExchangeRate'];
                      double balanceHistoricBs = balanceUsd * historicRate;
                      double balanceCurrentBs = balanceUsd * currentRate;
                      double diff = balanceCurrentBs - balanceHistoricBs;
                      
                      bool isPositiveGain = diff >= 0;

                      return ExcelGridRow(
                        cells: [
                          Row(
                            children: [
                              const Icon(Icons.account_balance_wallet, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(c['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent)),
                            ],
                          ),
                          Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(balanceUsd.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                          Text(historicRate.toStringAsFixed(2), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(balanceHistoricBs.abs().toStringAsFixed(2), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(currentRate.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, )),
                          Text(balanceCurrentBs.abs().toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, )),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: diff == 0 ? Colors.transparent : (isPositiveGain ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text(
                              diff.abs().toStringAsFixed(2),
                              style: TextStyle(
                                color: diff == 0 ? Colors.grey : (isPositiveGain ? Colors.green : Colors.red),
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                            ),
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
