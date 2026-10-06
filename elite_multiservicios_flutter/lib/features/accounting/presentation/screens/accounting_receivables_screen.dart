import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingReceivablesScreen extends StatefulWidget {
  const AccountingReceivablesScreen({super.key});

  @override
  State<AccountingReceivablesScreen> createState() =>
      _AccountingReceivablesScreenState();
}

class _AccountingReceivablesScreenState
    extends State<AccountingReceivablesScreen> {
  int _activeTab = 0;
  bool _showPaymentPanel = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Content Area
        Expanded(
          child: SingleChildScrollView(
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
                    _buildLibroVentas(),
                  ] else if (_activeTab == 2) ...[
                    _buildHistorialCobros(),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Right Side Panel (Payment Registration)
        if (_showPaymentPanel)
          Container(
            width: 450,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              border: Border(left: BorderSide(color: Color(0xFF334155))),
            ),
            child: _buildPaymentPanel(),
          ),
      ],
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
                'Facturación a Clientes y\nGestión de Cobranzas (CxC)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Control de cartera por cobrar, análisis de morosidad por\ntramos de vencimiento (Aging) y registro de recibos oficiales\nsegún normativa contable boliviana.',
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
            'Exportar Libro IVA (Excel/PDF)',
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
                        bottom: BorderSide(color: Color(0xFF6366F1), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    color: _activeTab == 0
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cartera de Cuentas\npor Cobrar & Aging',
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
                        color: const Color(0xFF312E81),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '18\nActivas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF818CF8),
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
                        bottom: BorderSide(color: Color(0xFF6366F1), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: _activeTab == 1
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Libro de Facturas\nEmitidas (Ventas)',
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
                        bottom: BorderSide(color: Color(0xFF6366F1), width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: _activeTab == 2
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Historial de Cobros y\nRecibos Oficiales',
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
          title: 'TOTAL\nCARTERA\nVIGENTE\n(CxC)',
          icon: Icons.account_balance,
          value: '241,600',
          valuePrefix: 'Bs.',
          valueColor: Colors.white,
          footerWidget: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '18\nFacturas ',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: '100%\n',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF818CF8),
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
                  text: 'Cartera\nde cobro',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF818CF8),
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
          title: 'COBRADO\nESTE MES\n(Q3)',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF34D399),
          value: '185,400',
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
                  'Tasa de\nrecuperación\n84%',
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
                  '+12%\nvs .',
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
          title: 'CARTERA\nVENCIDA (>\n30 DÍAS)',
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFFBBF24),
          value: '32,800',
          valuePrefix: 'Bs.',
          valueColor: const Color(0xFFFBBF24),
          footerWidget: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB45309).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '3\nfacturas\nen mora',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFBBF24),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '13.6%\nen\nriesgo',
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
          title: 'PROVISIÓN\nINCOBRABILIDAD\n(NIC 9)',
          icon: Icons.report_problem_outlined,
          iconColor: const Color(0xFFFCA5A5),
          value: '4,200.',
          valuePrefix: 'Bs.',
          valueColor: const Color(0xFFFCA5A5),
          footerWidget: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Estimación\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'por riesgo\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'crediticio\n',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 9,
                  ),
                ),
                TextSpan(
                  text: 'Auditori\n2026',
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
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
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
                      'DISTRIBUCIÓN DE ANTIGÜEDAD DE SALDOS (AGING\nSCHEDULE)',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Desglose de cartera total por tramos temporales de exigibilidad\nlegal y financiera',
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
                    '241,600.00',
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
                  flex: 73,
                  child: Container(color: const Color(0xFF34D399)),
                ),
                Expanded(
                  flex: 14,
                  child: Container(color: const Color(0xFFFBBF24)),
                ),
                Expanded(
                  flex: 9,
                  child: Container(color: const Color(0xFFF97316)),
                ),
                Expanded(
                  flex: 5,
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
                '176,000.00',
                '72.8%',
                const Color(0xFF34D399),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO 1 - 30\nDÍAS',
                '32,800.00',
                '13.6%',
                const Color(0xFFFBBF24),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO 31 - 60\nDÍAS',
                '21,500.00',
                '8.9%',
                const Color(0xFFF97316),
              ),
              const SizedBox(width: 12),
              _buildAgingBucket(
                'VENCIDO > 90\nDÍAS',
                '11,300.00',
                '4.7%',
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
                    'CLIENTE &\nRAZÓN\nSOCIAL',
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
                    'EMISIÓN /\nVENCIMIENTO',
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
                    'IMPORTE\nFACTURADO',
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              border: const Border(
                left: BorderSide(color: Color(0xFF6366F1), width: 4),
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
                        'FAC-2026-089',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF818CF8),
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
                        'Constructora Santa Cruz S.R.L.',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIT: 1029384021',
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
                        '15/01/2026',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vence: 14/02/2026',
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
                        'Bs. 85,000.00',
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
                        'Bs. 35,000.00',
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
              ],
            ),
          ),
          // More rows would go here
        ],
      ),
    );
  }

  Widget _buildPaymentPanel() {
    return Column(
      children: [
        // Panel Header
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFF334155))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Color(0xFF34D399),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar Cobranza de Factura',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF312E81),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FAC-2026-089',
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF818CF8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Libro de Ventas SIN',
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                onPressed: () => setState(() => _showPaymentPanel = false),
              ),
            ],
          ),
        ),

        // Panel Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CLIENTE EMISIÓN',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'NIT: 1029384021',
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Constructora Santa Cruz S.R.L.',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Facturado',
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bs. 85,000.00',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo Pendiente Actual',
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bs. 35,000.00',
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF34D399),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monto a Cobrar (Bs.) *',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Pago Total (100%)',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF818CF8),
                            fontSize: 10,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          ' · Parcial',
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF064E3B)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Bs.',
                        style: GoogleFonts.robotoMono(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '35,000.00',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF34D399),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Cuenta Bancaria o Caja Destino *',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Banco Nacional de Bolivia - BNB Cta. Cte. BOB (1.1.01.02)',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Método de Pago',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF334155),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transferencia Electrónica / QF',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha de Ingreso',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF334155),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '10/02/2026',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  'N° Comprobante / Referencia Bancaria',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    'TRANSF-BNB-994821',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFF334155)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF818CF8),
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ASIENTO CONTABLE AUTOMÁTICO (PREVIEW)',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF818CF8),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Cód: AS-2026-8911',
                              style: GoogleFonts.robotoMono(
                                color: Colors.grey[500],
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color(0xFF34D399),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '1.1.01.02 BNB Cta. Cte. BOB',
                                        style: GoogleFonts.robotoMono(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Débito (+) Ingreso Bancario',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Bs. 35,000.00',
                                  style: GoogleFonts.robotoMono(
                                    color: const Color(0xFF34D399),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color(0xFFFCA5A5),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '1.1.02.01 CxC Comerciales',
                                        style: GoogleFonts.robotoMono(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Crédito (-) Extinción de Deuda',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Bs. 35,000.00',
                                  style: GoogleFonts.robotoMono(
                                    color: const Color(0xFFFCA5A5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Glosa: Cobro de Factura FAC-2026-089 Cliente Constructora Santa Cruz S.R.L. mediante BNB Transf. #994821.',
                              style: GoogleFonts.inter(
                                color: Colors.grey[400],
                                fontSize: 10,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Panel Footer
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            border: Border(top: BorderSide(color: Color(0xFF334155))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _showPaymentPanel = false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[400],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: Text(
                  'Confirmar Cobro y Generar Recibo',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibroVentas() {
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
                  'Libro de Ventas (Formato LCV - SIN)',
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
                    'CLIENTE / RAZÓN SOCIAL',
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
                    'NIT/CI',
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
                    'CÓD. CONTROL',
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
                    'DÉBITO FISCAL',
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
          _buildSalesRow(
            '02/10/2026',
            'Constructora Cimentar SRL',
            '1029384029',
            '10045',
            'Bs. 45,000.00',
            'A1-B2-C3-D4',
            'Bs. 5,850.00',
          ),
          _buildSalesRow(
            '06/10/2026',
            'Inversiones del Sur SA',
            '4059683021',
            '10046',
            'Bs. 12,500.00',
            'E5-F6-G7-H8',
            'Bs. 1,625.00',
          ),
          _buildSalesRow(
            '09/10/2026',
            'Juan Pérez',
            '6892019',
            '10047',
            'Bs. 1,200.00',
            'J9-K0-L1-M2',
            'Bs. 156.00',
          ),
        ],
      ),
    );
  }

  Widget _buildSalesRow(
    String fecha,
    String cliente,
    String nit,
    String nFactura,
    String total,
    String control,
    String debito,
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
              cliente,
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
              control,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              debito,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFFFCA5A5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialCobros() {
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
                  'Historial de Cobros y Recibos Oficiales',
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
                    'Filtro: Todos',
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
                    'N° RECIBO',
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
                    'CLIENTE',
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
                    'FACTURA REF.',
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
                    'MEDIO DE PAGO',
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
                    'MONTO COBRADO',
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
          _buildReceiptHistoryRow(
            'RC-2026-0891',
            '01/10/2026',
            'Constructora Cimentar SRL',
            '10040',
            'Transf. BNB Cta. Cte.',
            'Bs. 15,000.00',
            true,
          ),
          _buildReceiptHistoryRow(
            'RC-2026-0892',
            '04/10/2026',
            'Edificio Los Pinos',
            '10042',
            'Cheque BMSC #020',
            'Bs. 4,500.00',
            true,
          ),
          _buildReceiptHistoryRow(
            'RC-2026-0893',
            '08/10/2026',
            'Hotel Central',
            '10044',
            'Efectivo',
            'Bs. 2,100.00',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptHistoryRow(
    String nRecibo,
    String fecha,
    String cliente,
    String factura,
    String metodo,
    String monto,
    bool validado,
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
              nRecibo,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFF818CF8),
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
              cliente,
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
              factura,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[400],
                fontSize: 11,
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
                  color: validado
                      ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                      : const Color(0xFFB45309).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  validado ? 'CONCILIADO' : 'EN TRÁNSITO',
                  style: GoogleFonts.inter(
                    color: validado
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
