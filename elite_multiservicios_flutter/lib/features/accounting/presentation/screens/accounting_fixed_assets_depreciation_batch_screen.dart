import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AccountingFixedAssetsDepreciationBatchScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AccountingFixedAssetsDepreciationBatchScreen({
    super.key,
    this.onBack,
  });

  @override
  State<AccountingFixedAssetsDepreciationBatchScreen> createState() =>
      _AccountingFixedAssetsDepreciationBatchScreenState();
}

class _AccountingFixedAssetsDepreciationBatchScreenState
    extends State<AccountingFixedAssetsDepreciationBatchScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  bool _isUSD = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBreadcrumbs(),
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 65,
                        child: _buildLeftTable(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 35,
                        child: _buildRightPanel(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Container(
      color: const Color(0xFFF8FAFC), // Light grey background
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text('Módulo\nContable',
              style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8), fontSize: 11, height: 1.2)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          InkWell(
            onTap: widget.onBack,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text('Activos Fijos &\nDepreciaciones',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8), fontSize: 11, height: 1.2)),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Text('Cierre Mensual por\nLote',
              style: GoogleFonts.inter(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600, height: 1.2)),
          const Spacer(),
          // Search input
          Container(
            height: 36,
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.search, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Buscar comprobante, activo o c',
                      style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8), fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('⌘K',
                      style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8), fontSize: 10)),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // USD / BOB Toggle
          Container(
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _isUSD = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _isUSD ? Colors.white : const Color(0xFFF1F5F9),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    child: Text('USD',
                        style: GoogleFonts.inter(
                            color: _isUSD ? const Color(0xFFFFFFFF) : const Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: _isUSD ? FontWeight.w600 : FontWeight.w500)),
                  ),
                ),
                Container(width: 1, color: const Color(0xFFE2E8F0)),
                InkWell(
                  onTap: () => setState(() => _isUSD = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !_isUSD ? Colors.white : const Color(0xFFF1F5F9),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    child: Text('BOB',
                        style: GoogleFonts.inter(
                            color: !_isUSD ? const Color(0xFFFFFFFF) : const Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: !_isUSD ? FontWeight.w600 : FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // TC
          Text('TC:\n6.96',
              style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8), fontSize: 10, height: 1.2), textAlign: TextAlign.center),
          const SizedBox(width: 16),
          // Mayor Sincronizado
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: Color(0xFF10B981), shape: BoxShape.rectangle),
                ),
                const SizedBox(width: 8),
                Text('Mayor:\nSincronizado',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8), fontSize: 10, height: 1.2)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Bell
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.notifications_none,
                size: 18, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Text(
                      'Cierre Mensual de Depreciación por Lote',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFFFFF),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 14, color: Color(0xFFD97706)),
                          const SizedBox(width: 4),
                          Text(
                            'Pendiente de Ejecución',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD97706),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ejecución automatizada de amortización lineal y generación del comprobante contable al Libro Mayor.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              _buildHeaderDropdown('PERIODO FISCAL', 'Octubre 2024'),
              const SizedBox(width: 16),
              _buildHeaderInput('FECHA DE ASIENTO', '31/10/2024',
                  icon: Icons.calendar_today_outlined),
              const SizedBox(width: 16),
              _buildHeaderInput('MONEDA DE REGISTRO', _isUSD ? 'USD (TC: 6.96)' : 'BOB'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInput(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: GoogleFonts.inter(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            title: 'ACTIVOS A DEPRECIAR',
            value: '42 activos',
            icon: Icons.archive_outlined,
            iconColor: const Color(0xFF8B5CF6),
            subtitle: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '100% elegibles',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF059669),
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '0 excluidos',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'GASTO DEL PERIODO (DÉBITO)',
            value: '\$12,450.00',
            icon: Icons.trending_down,
            iconColor: const Color(0xFFEF4444),
            subtitle: Text(
              'Amortización mensual calculada',
              style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8), fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'DEPRECIACIÓN ACUMULADA PROY.',
            value: '\$521,950.00',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF3B82F6),
            subtitle: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+2.45% s/ anterior',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF2563EB),
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'ESTADO DEL ASIENTO',
            value: 'Listo para Balance',
            valueColor: const Color(0xFF059669),
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFF10B981),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all, size: 14, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text(
                  'Partida Doble Verificada',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF059669), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    Color valueColor = const Color(0xFFFFFFFF),
    required IconData icon,
    required Color iconColor,
    required Widget subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          subtitle,
        ],
      ),
    );
  }

  Widget _buildLeftTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lista de Cálculo por Activo',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '42 registros',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterDropdown(),
                    const SizedBox(width: 12),
                    _buildSearchInput(),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTableHeader(),
          _buildTableRow(
              'ACT-2024-001',
              'Servidor Dell PowerEdge R750',
              'IT Hardware',
              const Color(0xFFEFF6FF),
              const Color(0xFF3B82F6),
              '\$37,800.00',
              '14 / 48',
              '\$787.50'),
          _buildTableRow(
              'ACT-2023-009',
              'Camioneta Toyota Hilux 4x4',
              'Vehículos',
              const Color(0xFFFFFBEB),
              const Color(0xFFD97706),
              '\$42,000.00',
              '22 / 60',
              '\$700.00'),
          _buildTableRow(
              'ACT-2022-014',
              'Generador Eléctrico Caterpillar 150kVA',
              'Maquinaria',
              const Color(0xFFEEF2FF),
              const Color(0xFF4F46E5),
              '\$54,000.00',
              '32 / 120',
              '\$450.00'),
          _buildTableRow(
              'ACT-2024-019',
              'Lote 25x Laptops Lenovo ThinkPad T14',
              'IT Hardware',
              const Color(0xFFEFF6FF),
              const Color(0xFF3B82F6),
              '\$36,250.00',
              '8 / 36',
              '\$1,006.94'),
          _buildTableRow(
              'ACT-2023-045',
              'Furgón Reparto Mercedes Sprinter',
              'Vehículos',
              const Color(0xFFFFFBEB),
              const Color(0xFFD97706),
              '\$65,000.00',
              '18 / 60',
              '\$1,083.33'),
          _buildTableRow(
              'ACT-2021-008',
              'Torno Industrial CNC Haas ST-20',
              'Maquinaria',
              const Color(0xFFEEF2FF),
              const Color(0xFF4F46E5),
              '\$105,000.00',
              '44 / 120',
              '\$875.00',
              isLast: true),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '... 36 activos adicionales calculados bajo parámetros de depreciación lineal estándar ...',
              style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Text(
            'Todas las Categorías',
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 24),
          const Icon(Icons.keyboard_arrow_down,
              size: 14, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Text(
            'Filtrar tag o descripción...',
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text('CÓDIGO/TAG',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
          Expanded(
              flex: 4,
              child: Text('DESCRIPCIÓN DEL ACTIVO',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
          Expanded(
              flex: 2,
              child: Text('CATEGORÍA',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
          Expanded(
              flex: 2,
              child: Text('COSTO BASE',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
          Expanded(
              flex: 1,
              child: Text('MESES (T/V)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
          Expanded(
              flex: 2,
              child: Text('CUOTA MENSUAL',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8)))),
        ],
      ),
    );
  }

  Widget _buildTableRow(
      String code,
      String desc,
      String category,
      Color badgeBg,
      Color badgeText,
      String cost,
      String months,
      String quota,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              code,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              desc,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFFFFFFF),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              cost,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              months,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              quota,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.receipt_long,
                        color: Color(0xFF818CF8), size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMPROBANTE DE DIARIO',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'CD-2024-10-DEP',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF064E3B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF059669)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check,
                          color: Color(0xFF34D399), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Partida Doble Cuadrada',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF34D399),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FECHA DEL ASIENTO:',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF94A3B8))),
                          const SizedBox(height: 4),
                          Text('31/10/2024',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TIPO DE OPERACIÓN:',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF94A3B8))),
                          const SizedBox(height: 4),
                          Text('Asiento de Ajuste Mensual',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('GLOSA CONTABLE OFICIAL:',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: const Color(0xFF94A3B8))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    '"Registro de la depreciación de activos fijos correspondiente al mes de Octubre 2024 según método de línea recta (NIC 16)."',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFE2E8F0),
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('DISTRIBUCIÓN CUENTAS CONTABLES (MAYOR)',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8))),
                    ),
                    const SizedBox(width: 8),
                    Text('MONEDA: USD',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Text('CUENTA / DENOMINACIÓN',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: const Color(0xFF94A3B8)))),
                    Expanded(
                        flex: 2,
                        child: Text('DÉBITO',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: const Color(0xFF94A3B8)))),
                    Expanded(
                        flex: 2,
                        child: Text('CRÉDITO',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                                fontSize: 10, color: const Color(0xFF94A3B8)))),
                  ],
                ),
                const Divider(color: Color(0xFFE2E8F0), height: 16),
                _buildJournalRow('5.1.04.01\nGasto Deprec. Equipos Computación',
                    '\$6,820.00', ''),
                _buildJournalRow('5.1.04.02\nGasto Deprec. Vehículos y Transp.',
                    '\$3,430.00', ''),
                _buildJournalRow('5.1.04.03\nGasto Deprec. Maquinaria y Equipos',
                    '\$2,200.00', ''),
                _buildJournalRow('1.2.04.01\nDeprec. Acumulada Activos Fijos', '',
                    '\$12,450.00',
                    isCredit: true),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL CUADRADO',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.account_balance,
                                    size: 14, color: Color(0xFF34D399)),
                                const SizedBox(width: 6),
                                Text('Diferencia: \$0.00',
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF34D399),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('DÉBITO TOTAL',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 9)),
                            const SizedBox(height: 4),
                            Text('\$12,450.00',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF0F172A),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('CRÉDITO TOTAL',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 9)),
                            const SizedBox(height: 4),
                            Text('\$12,450.00',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF34D399),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Elaborado por:',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: const Color(0xFF94A3B8))),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.smart_toy,
                                size: 14, color: Color(0xFF818CF8)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text('FinTrack Auto-Engine v4',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFE2E8F0))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aprobador Requerido:',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: const Color(0xFF94A3B8))),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF59E0B),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text('Harold Eastman (CFO)',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFE2E8F0))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'CONFIRMAR EJECUCIÓN LOTE DEP-2024-10',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
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
    );
  }

  Widget _buildJournalRow(String account, String debit, String credit,
      {bool isCredit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: isCredit ? 16.0 : 0.0),
              child: Text(
                account,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                  height: 1.4,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              debit,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: debit.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              credit,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: credit.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFFE2E8F0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






