import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accounting_payables_modal.dart';

class AccountingExpensesScreen extends StatefulWidget {
  const AccountingExpensesScreen({super.key});

  @override
  State<AccountingExpensesScreen> createState() =>
      _AccountingExpensesScreenState();
}

class _AccountingExpensesScreenState extends State<AccountingExpensesScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTabBar(),
            const SizedBox(height: 24),
            if (_activeTab == 0) ...[
              _buildKpiCards(),
              const SizedBox(height: 24),
              _buildAgingSchedule(),
              const SizedBox(height: 24),
              _buildFilterBar(),
              const SizedBox(height: 16),
              _buildDataTable(),
            ] else if (_activeTab == 1) ...[
              _buildLibroCompras(),
            ] else if (_activeTab == 2) ...[
              _buildHistorialPagos(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Egresos y Cuentas por\nPagar a Proveedores (CxP)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Control de cartera de proveedores, programación de pagos por\ntramos de vencimiento (Aging) y emisión de comprobantes de egreso.',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[300],
            side: const BorderSide(color: Color(0xFF334155)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          icon: const Icon(Icons.download_outlined, size: 16),
          label: Text(
            'Exportar Libro de Compras',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _activeTab = 0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 0
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEF4444), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom,
                    color: _activeTab == 0
                        ? const Color(0xFFFCA5A5)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cartera de Proveedores\n& Aging',
                    style: GoogleFonts.inter(
                      color: _activeTab == 0 ? Colors.white : Colors.grey[400],
                      fontSize: 12,
                      fontWeight: _activeTab == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (_activeTab == 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F1D1D),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '24\nActivas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFCA5A5),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () => setState(() => _activeTab = 1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 1
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEF4444), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_outlined,
                    color: _activeTab == 1
                        ? const Color(0xFFFCA5A5)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Libro de Compras\n(RC-IVA)',
                    style: GoogleFonts.inter(
                      color: _activeTab == 1 ? Colors.white : Colors.grey[400],
                      fontSize: 12,
                      fontWeight: _activeTab == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () => setState(() => _activeTab = 2),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 2
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFEF4444), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: _activeTab == 2
                        ? const Color(0xFFFCA5A5)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Historial de Pagos y\nComprobantes',
                    style: GoogleFonts.inter(
                      color: _activeTab == 2 ? Colors.white : Colors.grey[400],
                      fontSize: 12,
                      fontWeight: _activeTab == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCards() {
    return Row(
      children: [
        _buildKpiCard(
          title: 'TOTAL\nPASIVO\nCIRCULANTE',
          icon: Icons.account_balance_wallet,
          value: '185,200',
          valuePrefix: 'Bs.',
          valueColor: Colors.white,
          footerWidget: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '24\nFacturas ',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: '100%\n',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFCA5A5),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'pendientes',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'Obligaciones',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFCA5A5),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildKpiCard(
          title: 'PAGADO\nESTE MES\n(Q3)',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF34D399),
          value: '95,400',
          valuePrefix: 'Bs.',
          valueColor: const Color(0xFF34D399),
          footerWidget: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Tasa de\ncumplimiento\n92%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF34D399),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '+5%\nvs .',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildKpiCard(
          title: 'OBLIGACIONES\nVENCIDAS (>\n30 DÍAS)',
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFEF4444), // Red for payables
          value: '42,100',
          valuePrefix: 'Bs.',
          valueColor: const Color(0xFFFCA5A5),
          footerWidget: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F1D1D).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '5\nfacturas\nen mora',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFCA5A5),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '22.7%\nen\nriesgo',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildKpiCard(
          title: 'RETENCIONES\nFISCALES\nPOR PAGAR',
          icon: Icons.account_balance,
          iconColor: const Color(0xFFFBBF24),
          value: '12,500.',
          valuePrefix: 'Bs.',
          valueColor: const Color(0xFFFBBF24),
          footerWidget: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'IUE / IT\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'declaraciones\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'pendientes\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'Oct 2026',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required IconData icon,
    Color iconColor = Colors.grey,
    required String value,
    required String valuePrefix,
    required Color valueColor,
    required Widget footerWidget,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(icon, color: iconColor, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  valuePrefix,
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: GoogleFonts.robotoMono(
                    color: valueColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            footerWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildAgingSchedule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DISTRIBUCIÓN DE OBLIGACIONES POR VENCER Y VENCIDAS',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Desglose de cartera de proveedores por exigibilidad legal',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Analizado: Bs.',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '185,200.00',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress Bar
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Expanded(
                  flex: 55,
                  child: Container(color: const Color(0xFF34D399)),
                ),
                Expanded(
                  flex: 22,
                  child: Container(color: const Color(0xFFFBBF24)),
                ),
                Expanded(
                  flex: 15,
                  child: Container(color: const Color(0xFFF97316)),
                ),
                Expanded(
                  flex: 8,
                  child: Container(color: const Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Buckets
          Row(
            children: [
              _buildAgingBucket(
                'AL DÍA / NO\nVENCIDO',
                '101,860.00',
                '55.0%',
                const Color(0xFF34D399),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO 1 - 30\nDÍAS',
                '40,744.00',
                '22.0%',
                const Color(0xFFFBBF24),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO 31 - 60\nDÍAS',
                '27,780.00',
                '15.0%',
                const Color(0xFFF97316),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO > 90\nDÍAS',
                '14,816.00',
                '8.0%',
                const Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgingBucket(
    String title,
    String value,
    String percentage,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.circle, color: color, size: 8),
                const SizedBox(width: 6),
                Text(
                  'Bs.',
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                value,
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                '($percentage)',
                style: GoogleFonts.robotoMono(color: color, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(Icons.search, color: Colors.grey, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                'Estado de Pago: Todos',
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                'Plazo de VenciMiento: Todos',
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                'Monto: Todos los montos',
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(Icons.refresh, color: Colors.grey, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'N°\nFACTURA',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PROVEEDOR &\nRAZÓN\nSOCIAL',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'RECEPCIÓN /\nVENCIMIENTO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'IMPORTE\nADEUDADO',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'SALDO\nPENDIENTE',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 120), // Action button space
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
              border: const Border(
                left: BorderSide(color: Color(0xFFEF4444), width: 4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FCV-88392',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFFFCA5A5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Imcruz Maquinaria S.A.',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIT: 1028492019',
                        style: GoogleFonts.robotoMono(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '10/01/2026',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vence: 09/02/2026',
                        style: GoogleFonts.robotoMono(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bs. 14,000.00',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bs. 14,000.00',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFFFCA5A5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB45309).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Vencido 1-30',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFBBF24),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (context) => const AccountingPayablesModal(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Liquidar',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // More rows would go here
        ],
      ),
    );
  }

  Widget _buildLibroCompras() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Registro de Compras (Formato LCV - SIN)',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    'Período: Octubre 2026',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'FECHA',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PROVEEDOR',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'NIT',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'N° FACTURA',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'IMPORTE TOTAL',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'SUJETO A CRÉDITO',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'CRÉDITO FISCAL',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildLcvRow(
            '05/10/2026',
            'Entel S.A.',
            '1020492023',
            '90342',
            'Bs. 500.00',
            'Bs. 500.00',
            'Bs. 65.00',
          ),
          _buildLcvRow(
            '10/10/2026',
            'Imcruz Maquinaria S.A.',
            '1028492019',
            '88392',
            'Bs. 14,000.00',
            'Bs. 14,000.00',
            'Bs. 1,820.00',
          ),
          _buildLcvRow(
            '12/10/2026',
            'Papelería La Escolar',
            '2039485012',
            '1023',
            'Bs. 250.00',
            'Bs. 250.00',
            'Bs. 32.50',
          ),
        ],
      ),
    );
  }

  Widget _buildLcvRow(
    String fecha,
    String proveedor,
    String nit,
    String nFactura,
    String total,
    String sujeto,
    String credito,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              fecha,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              proveedor,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              nit,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              nFactura,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sujeto,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              credito,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFF34D399),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialPagos() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de Pagos y Egresos (Comprobantes)',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    'Filtro: Últimos 30 días',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'N° COMPROBANTE',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'FECHA',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PROVEEDOR / BENEFICIARIO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'MÉTODO DE PAGO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'MONTO PAGADO',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'ESTADO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildPaymentHistoryRow(
            'CE-2026-0391',
            '01/10/2026',
            'Servicios de Impuestos Nacionales',
            'Transf. BNB Cta. Cte.',
            'Bs. 21,500.00',
            true,
          ),
          _buildPaymentHistoryRow(
            'CE-2026-0392',
            '03/10/2026',
            'Entel S.A.',
            'Transf. BNB Cta. Cte.',
            'Bs. 500.00',
            true,
          ),
          _buildPaymentHistoryRow(
            'CE-2026-0393',
            '05/10/2026',
            'Caja de Salud (CNS)',
            'Cheque BMSC #0991',
            'Bs. 18,200.00',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryRow(
    String nComp,
    String fecha,
    String proveedor,
    String metodo,
    String monto,
    bool completado,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              nComp,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFFFCA5A5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              fecha,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              proveedor,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              metodo,
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              monto,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: completado
                      ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                      : const Color(0xFFB45309).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  completado ? 'LIQUIDADO' : 'PENDIENTE',
                  style: GoogleFonts.inter(
                    color: completado
                        ? const Color(0xFF34D399)
                        : const Color(0xFFFBBF24),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
