import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'accounting_fixed_assets_screen.dart';
import 'accounting_fixed_assets_depreciation_batch_screen.dart';
import 'accounting_reconciliation_screen.dart';

class AccountingDashboardScreen extends ConsumerStatefulWidget {
  const AccountingDashboardScreen({super.key});
  @override
  ConsumerState<AccountingDashboardScreen> createState() => _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends ConsumerState<AccountingDashboardScreen> {
  String _currency = 'BOB';
  final double _exchangeRate = 6.96;

  String _formatCurrency(double amountUsd) {
    if (_currency == 'BOB') {
      return 'Bs ${(amountUsd * _exchangeRate).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }
    return '\$${amountUsd.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String _formatCompact(double amountUsd) {
    if (_currency == 'BOB') {
      return 'Bs ${(amountUsd * _exchangeRate / 1000).toStringAsFixed(1)}k';
    }
    return '\$${(amountUsd / 1000).toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Text(
              'FinTrack',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCurrencyToggle('USD'),
                  Container(width: 1, color: Colors.grey.shade300),
                  _buildCurrencyToggle('BOB'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              child: Icon(Icons.notifications_none, color: Colors.black),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(40, 40),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Resumen Ejecutivo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CORP-PROD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Consolidación financiera multimoneda & control de tesorería institucional.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.calendar_today, size: 16, color: Colors.blueAccent),
                          label: const Text(
                            'Hoy, 24 Octubre 2024',
                            style: TextStyle(color: Color(0xFF111827)),
                          ),
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download, size: 16, color: Color(0xFF4B5563)),
                        label: const Text(
                          'Exportar',
                          style: TextStyle(color: Color(0xFF111827)),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUrgentActionsCard(),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    title: 'TOTAL CASH AVAILABLE',
                    amount: _formatCurrency(482900.00),
                    pillText: '↗ +4.2% vs mes anterior',
                    pillColor: const Color(0xFFDCFCE7),
                    pillTextColor: const Color(0xFF166534),
                    trailingText: '3 Cuentas activas',
                    icon: Icons.account_balance,
                    iconColor: const Color(0xFF059669),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    title: 'ACCOUNTS RECEIVABLE',
                    amount: _formatCurrency(124350.00),
                    pillText: '8 pendientes',
                    pillColor: const Color(0xFFDBEAFE),
                    pillTextColor: const Color(0xFF1E40AF),
                    trailingText: 'Próx. vto: 28 Oct (${_formatCompact(18500.0)})',
                    icon: Icons.receipt_long,
                    iconColor: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    title: 'ACCOUNTS PAYABLE',
                    amount: _formatCurrency(86120.00),
                    pillText: '3 vencidas (${_formatCurrency(12400.00)})',
                    pillColor: const Color(0xFFFEE2E2),
                    pillTextColor: const Color(0xFF991B1B),
                    trailingText: 'Salida prog: Viernes',
                    icon: Icons.payments_outlined,
                    iconColor: const Color(0xFFDC2626),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountingFixedAssetsScreen()));
                    },
                    child: _buildMetricCard(
                      title: 'NET FIXED ASSETS BOOK VALUE',
                      amount: _formatCurrency(1340500.00),
                      pillText: 'CAPEX Tracked',
                      pillColor: const Color(0xFFEEF2FF),
                      pillTextColor: const Color(0xFF4F46E5),
                      trailingText: 'Deprec. Mensual: ${_formatCurrency(12450.00)}',
                      icon: Icons.domain,
                      iconColor: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCashFlowProjection(),
                  const SizedBox(height: 16),
                  _buildLiquidityAging(),
                  const SizedBox(height: 16),
                  _buildRecentTransactions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyToggle(String currency) {
    final isSelected = _currency == currency;
    return InkWell(
      onTap: () {
        setState(() {
          _currency = currency;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        color: isSelected ? Colors.transparent : const Color(0xFFF3F4F6),
        child: Text(
          currency,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentActionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8),
        border: Border.all(color: const Color(0xFFFDE047)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 8),
              const Text(
                'ACCIONES URGENTES REQUERIDAS (2)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF92400E),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Cierre de ciclo contable en 6 días',
            style: TextStyle(
              color: Color(0xFFB45309),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem('Ejecución por lote de Depreciación ...', 'Ejecutar', true, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountingFixedAssetsDepreciationBatchScreen()));
          }),
          const SizedBox(height: 8),
          _buildActionItem('2 transacciones bancarias sin con...', 'Conciliar', false, () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountingBankReconciliationScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, String buttonText, bool primary, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFEF08A)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            ),
          ),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary ? const Color(0xFFD97706) : Colors.white,
                foregroundColor: primary ? Colors.white : const Color(0xFF92400E),
                elevation: 0,
                side: primary ? BorderSide.none : const BorderSide(color: Color(0xFFD1D5DB)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(buttonText, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required String pillText,
    required Color pillColor,
    required Color pillTextColor,
    required String trailingText,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: pillTextColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  pillText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: pillTextColor,
                  ),
                ),
              ),
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowProjection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proyección de Flujo de Caja (6 Meses)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Análisis comparativo de Tesorería: Flujo Proyectado vs Flujo Real ejecutado.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(width: 12, height: 2, color: const Color(0xFF4F46E5)),
              const SizedBox(width: 4),
              const Text('Flujo Real', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 16),
              Container(width: 12, height: 1, color: const Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              const Text('Flujo Proyectado', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 150),
              painter: _ChartPainter(),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mayo', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              Text('Junio', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              Text('Julio', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              Text('Agosto', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              Text('Septiembre', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              Text('Octubre', style: TextStyle(fontSize: 10, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Punto Máximo (Sep):', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  Text(_formatCurrency(510200.00), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Desviación Promedio:', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  const Text('±3.1%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Ver conciliación completa →',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidityAging() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aging de Liquidez',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Ratio: 1.44 (Saludable)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Distribución de vencimientos de cartera a corto plazo.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          _buildAgingRow('0-30 días (Vigente)', _formatCurrency(78200.00), '62.9%', const Color(0xFF10B981), 0.629),
          const SizedBox(height: 12),
          _buildAgingRow('31-60 días', _formatCurrency(31150.00), '25.0%', const Color(0xFF4F46E5), 0.25),
          const SizedBox(height: 12),
          _buildAgingRow('61-90 días (Alerta)', _formatCurrency(11000.00), '8.8%', const Color(0xFFF59E0B), 0.088),
          const SizedBox(height: 12),
          _buildAgingRow('>90 días (Mora crítica)', _formatCurrency(4000.00), '3.3%', const Color(0xFFEF4444), 0.033),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined, color: Color(0xFF4F46E5), size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'Total Cobranzas Activas',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                  ],
                ),
                Text(
                  _formatCurrency(124350.00),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Auditoría de cartera automatizada', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              Text('Gestionar Cobros', style: TextStyle(fontSize: 12, color: Color(0xFF4F46E5), fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgingRow(String label, String amount, String percentage, Color color, double factor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(width: 4),
                Text('($percentage)', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            )
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: factor,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ÚLTIMOS MOVIMIENTOS DE\nTESORERÍA',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                ),
                Text(
                  'Sucursal\nCentral',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                Row(
                  children: [
                    Text('Ver Libro\nMayor', style: TextStyle(fontSize: 12, color: Color(0xFF4F46E5), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                    SizedBox(width: 4),
                    Icon(Icons.open_in_new, size: 14, color: Color(0xFF4F46E5)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('REFERENCIA\n/ FOLIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
                Expanded(flex: 3, child: Text('CONCEPTO\n& ENTIDAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
                Expanded(flex: 2, child: Text('CUENTA\nORIGEN /\nDESTINO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
                Expanded(flex: 1, child: Text('FECHA\nVALOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)))),
              ],
            ),
          ),
          _buildTransactionRow(
            ref: 'TRX-94821',
            concept: 'Cobro Factura #4029 - Importadora Andina',
            type: 'Cliente Corporativo / Transferencia Swift',
            account: 'Bco. Nacional\n#8841',
            date: '24 Oct\n2024',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildTransactionRow(
            ref: 'TRX-94820',
            concept: 'Pago Licencias Enterprise AWS Cloud',
            type: 'OPEX Infraestructura IT / Débito Automático',
            account: 'Bco. Mercantil\n#1029',
            date: '23 Oct\n2024',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildTransactionRow(
            ref: 'TRX-94819',
            concept: 'Depósito Cheque Custodia - Constructora Bolívar',
            type: 'Adelanto Obra Sucursal El Alto',
            account: 'Bco. BISA\n#4910',
            date: '23 Oct\n2024',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required String ref,
    required String concept,
    required String type,
    required String account,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(ref, style: const TextStyle(fontSize: 12, color: Color(0xFF374151)))),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(concept, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(type, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(account, style: const TextStyle(fontSize: 12, color: Color(0xFF374151)))),
          Expanded(flex: 1, child: Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final realPaint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final projPaint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final realPath = Path();
    final projPath = Path();

    realPath.moveTo(0, size.height * 0.8);
    realPath.quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.4, size.height * 0.5);
    realPath.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.8, size.height * 0.1);
    realPath.quadraticBezierTo(size.width * 0.9, size.height * 0.05, size.width, size.height * 0.2);

    projPath.moveTo(0, size.height * 0.7);
    projPath.quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.6, size.height * 0.3);
    projPath.quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width, size.height * 0.15);

    _drawDashedLine(canvas, projPath, projPaint);
    canvas.drawPath(realPath, realPaint);

    final dotPaint = Paint()..color = const Color(0xFF4F46E5)..style = PaintingStyle.fill;
    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final dotGreenPaint = Paint()..color = const Color(0xFF10B981)..style = PaintingStyle.fill;

    _drawDot(canvas, Offset(size.width * 0.4, size.height * 0.5), dotPaint, whitePaint);
    _drawDot(canvas, Offset(size.width * 0.6, size.height * 0.42), dotPaint, whitePaint);
    _drawDot(canvas, Offset(size.width * 0.8, size.height * 0.12), dotPaint, whitePaint);
    _drawDot(canvas, Offset(size.width, size.height * 0.2), dotGreenPaint, whitePaint);
  }

  void _drawDot(Canvas canvas, Offset offset, Paint paint, Paint bgPaint) {
    canvas.drawCircle(offset, 4, bgPaint);
    canvas.drawCircle(offset, 3, paint);
  }

  void _drawDashedLine(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    for (var metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + 4),
          Offset.zero,
        );
        distance += 8;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
