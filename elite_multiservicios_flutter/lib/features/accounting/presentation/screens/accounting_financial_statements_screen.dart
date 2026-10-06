import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingFinancialStatementsScreen extends StatefulWidget {
  const AccountingFinancialStatementsScreen({super.key});

  @override
  State<AccountingFinancialStatementsScreen> createState() =>
      _AccountingFinancialStatementsScreenState();
}

class _AccountingFinancialStatementsScreenState
    extends State<AccountingFinancialStatementsScreen> {
  int _activeTab = 0;
  int _currencyIndex = 0; // 0 for Bs, 1 for USD

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
              _buildEquationBar(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildActivoColumn()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildPasivoPatrimonioColumn()),
                ],
              ),
            ] else if (_activeTab == 1) ...[
              _buildEstadoResultados(),
            ] else if (_activeTab == 2) ...[
              _buildBalanceComprobacion(),
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
                'Estados Financieros Oficiales y\nDictamen Contable',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Balance General Clasificado al cierre contable Q3 bajo normativa contable\nboliviana e internacional.',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Text(
                    'Gestión 2026 (Al 30 de Septiembre - Q3)',
                    style: GoogleFonts.inter(
                      color: Colors.grey[300],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _currencyIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _currencyIndex == 0
                            ? const Color(0xFF334155)
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Bs. (BOB)',
                        style: GoogleFonts.inter(
                          color: _currencyIndex == 0
                              ? Colors.white
                              : Colors.grey[400],
                          fontSize: 11,
                          fontWeight: _currencyIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _currencyIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _currencyIndex == 1
                            ? const Color(0xFF334155)
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        'USD (\$)',
                        style: GoogleFonts.inter(
                          color: _currencyIndex == 1
                              ? Colors.white
                              : Colors.grey[400],
                          fontSize: 11,
                          fontWeight: _currencyIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                side: const BorderSide(color: Color(0xFFB45309)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: const Color(0xFFB45309).withValues(alpha: 0.1),
              ),
              icon: const Icon(
                Icons.picture_as_pdf_outlined,
                size: 16,
                color: Color(0xFFFCA5A5),
              ),
              label: Text(
                'Dictamen (PDF)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const Icon(Icons.download, size: 16),
              label: Text(
                'Exportar Balance (.xlsx)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
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
                    Icons.balance,
                    color: _activeTab == 0
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Balance General Clasificado',
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
                        'Q3 2026',
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
                    Icons.show_chart,
                    color: _activeTab == 1
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estado de Resultados (P&L Integral)',
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
                    Icons.checklist_rtl,
                    color: _activeTab == 2
                        ? const Color(0xFF818CF8)
                        : Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Balance de Comprobación (Sumas y Saldos)',
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

  Widget _buildEquationBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF064E3B).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF34D399),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Ecuación Fundamental Cuadrada',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF34D399).withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Diferencia: Bs. 0.00 (100% Cuadrado)',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF34D399),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Activo (Bs. 2,145,000.00) = Total Pasivo + Patrimonio (Bs. 2,145,000.00)',
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[300],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF34D399),
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  'Asiento de Cierre Inmutable (SHA-256)',
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          '1. ACTIVO',
          'Cuentas Reales de\nBalance',
          'Bs. 2,145,000.00',
          const Color(0xFF6366F1),
        ),
        const SizedBox(height: 16),
        _buildSubSection(
          '1.1 ACTIVO CORRIENTE (CIRCULANTE)',
          'Subtotal: Bs. 804,500.00',
        ),
        _buildRowItem(
          '1.1.01',
          'Disponible en Caja y Bancos',
          'Bs. 482,900.00',
          tag: 'Tesorería',
          tagIcon: Icons.open_in_new,
        ),
        _buildRowItem(
          '1.1.02',
          'Cuentas por Cobrar Comerciales (CxC)',
          'Bs. 241,600.00',
          subtitle: 'Cartera vigente 0-30 días sin mora',
        ),
        _buildRowItem(
          '1.1.03',
          'Crédito Fiscal IVA y Anticipos Tributarios',
          'Bs. 80,000.00',
        ),
        const SizedBox(height: 24),
        _buildSubSection(
          '1.2 ACTIVO NO CORRIENTE (ACTIVO FIJO)',
          'Neto: Bs. 1,340,500.00',
        ),
        _buildRowItem(
          '1.2.01',
          'Costo Histórico y Revalúos de Activos Fijos',
          'Bs. 1,850,000.00',
        ),
        _buildRedRowItem(
          '1.2.04',
          '(-) Depreciación\nAcumulada',
          '(Bs. 509,500.00)',
          tag: 'Cuenta\nReguladora',
        ),
        _buildHighlightBar(
          'Subtotal Valor Neto en Libros (VNL)',
          'Bs. 1,340,500.00',
        ),
        const SizedBox(height: 24),
        _buildFooter(
          'TOTAL ACTIVO',
          'Bs. 2,145,000.00',
          const Color(0xFF34D399),
        ),
      ],
    );
  }

  Widget _buildPasivoPatrimonioColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          '2. PASIVO Y 3. PATRIMONIO',
          'Fuentes de\nFinanciamiento',
          'Bs. 2,145,000.00',
          const Color(0xFF34D399),
        ),
        const SizedBox(height: 16),
        _buildSubSection(
          '2. PASIVO (OBLIGACIONES)',
          'Total Pasivo: Bs. 620,000.00',
        ),
        _buildRowItem(
          '2.1',
          'Cuentas por Pagar Proveedores Comerciales (CxP)',
          'Bs. 86,120.00',
        ),
        _buildRowItem(
          '2.2',
          'Obligaciones Fiscales, Laborales y Sociales por\nPagar',
          'Bs. 533,880.00',
          subtitle: 'IUE, IVA, Retenciones tributarias y CNS',
        ),
        _buildHighlightBar(
          'Subtotal Total Pasivo',
          'Bs. 620,000.00',
          isDark: true,
        ),
        const SizedBox(height: 24),
        _buildSubSection(
          '3. PATRIMONIO NETO (FONDOS PROPIOS)',
          'Total Patrimonio: Bs. 1,525,000.00',
        ),
        _buildRowItem(
          '3.1',
          'Capital Social Aportado y Pagado',
          'Bs. 1,000,000.00',
        ),
        _buildGreenRowItem(
          '3.1.03',
          'Reserva por Revalúos\nTécnicos',
          'Bs. 384,200.00',
          subtitle: 'Revalúo pericial homologado D.S. 24051',
          tag: 'Superávit NIC\n16',
        ),
        _buildRowItem(
          '3.1.05',
          'Utilidad Neta Acumulada del Periodo',
          'Bs. 140,800.00',
        ),
        _buildHighlightBar(
          'Subtotal Total Patrimonio Neto',
          'Bs. 1,525,000.00',
          isDark: true,
        ),
        const SizedBox(height: 24),
        _buildFooter(
          'TOTAL PASIVO Y PATRIMONIO',
          'Bs. 2,145,000.00',
          const Color(0xFF34D399),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    String value,
    Color dotColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: dotColor, size: 8),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.robotoMono(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.grey[300],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: Colors.grey[300],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
    String code,
    String name,
    String value, {
    String? subtitle,
    String? tag,
    IconData? tagIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 45,
            child: Text(
              code,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (tag != null)
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            tag,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF818CF8),
                              fontSize: 10,
                            ),
                          ),
                          if (tagIcon != null) ...[
                            const SizedBox(width: 4),
                            Icon(
                              tagIcon,
                              color: const Color(0xFF818CF8),
                              size: 10,
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRedRowItem(
    String code,
    String name,
    String value, {
    required String tag,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF7F1D1D).withValues(alpha: 0.15),
        border: Border.all(color: const Color(0xFF7F1D1D)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            child: Text(
              code,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFFFCA5A5),
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(
                color: const Color(0xFFFCA5A5),
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7F1D1D).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: GoogleFonts.inter(
                color: const Color(0xFFFCA5A5),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFFFCA5A5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreenRowItem(
    String code,
    String name,
    String value, {
    required String tag,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF064E3B).withValues(alpha: 0.15),
        border: Border.all(color: const Color(0xFF064E3B)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            child: Text(
              code,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFF34D399),
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF34D399),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: GoogleFonts.inter(
                color: const Color(0xFF34D399),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF34D399),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightBar(String title, String value, {bool isDark = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.5)
            : const Color(0xFF1E1B4B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFF312E81),
        ),
      ),
      child: Row(
        children: [
          if (!isDark) ...[
            const Icon(
              Icons.account_tree_outlined,
              color: Color(0xFF818CF8),
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.grey[300],
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: isDark ? Colors.white : const Color(0xFF818CF8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoResultados() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEquationBarPL(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSubSection(
                '4. INGRESOS OPERATIVOS',
                'Total: Bs. 3,500,000.00',
              ),
              _buildRowItem(
                '4.1.01',
                'Ingresos por Servicios Prestados',
                'Bs. 3,500,000.00',
              ),
              const SizedBox(height: 16),
              _buildSubSection(
                '5. COSTOS OPERATIVOS',
                'Total: Bs. 1,800,000.00',
              ),
              _buildRowItem(
                '5.1.01',
                'Costo de Servicios Prestados',
                'Bs. 1,800,000.00',
              ),
              _buildHighlightBar(
                'UTILIDAD BRUTA EN VENTAS',
                'Bs. 1,700,000.00',
                isDark: true,
              ),
              const SizedBox(height: 24),
              _buildSubSection(
                '6. GASTOS OPERATIVOS',
                'Total: Bs. 1,250,000.00',
              ),
              _buildRowItem(
                '6.1.01',
                'Gastos Administrativos',
                'Bs. 800,000.00',
              ),
              _buildRowItem(
                '6.1.02',
                'Gastos de Comercialización',
                'Bs. 350,000.00',
              ),
              _buildRowItem(
                '6.1.03',
                'Depreciaciones y Amortizaciones',
                'Bs. 100,000.00',
              ),
              _buildHighlightBar(
                'UTILIDAD OPERATIVA (EBIT)',
                'Bs. 450,000.00',
                isDark: true,
              ),
              const SizedBox(height: 24),
              _buildSubSection(
                '7. OTROS INGRESOS / EGRESOS',
                'Neto: Bs. 50,000.00',
              ),
              _buildRowItem('7.1.01', 'Ingresos Financieros', 'Bs. 80,000.00'),
              _buildRowItem('7.2.01', 'Gastos Financieros', 'Bs. 30,000.00'),
              _buildHighlightBar(
                'UTILIDAD ANTES DE IMPUESTOS (EBT)',
                'Bs. 500,000.00',
                isDark: true,
              ),
              const SizedBox(height: 24),
              _buildRedRowItem(
                '8.1.01',
                '(-) Impuesto a las Utilidades (IUE 25%)',
                '(Bs. 125,000.00)',
                tag: 'Provisión',
              ),
              const SizedBox(height: 16),
              _buildFooter(
                'UTILIDAD NETA DEL EJERCICIO',
                'Bs. 375,000.00',
                const Color(0xFF34D399),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquationBarPL() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF312E81).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF312E81),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Color(0xFF818CF8),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Estado de Resultados Integral (P&L)',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Margen Neto: 10.7%',
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Acumulado de Gestión - Cumplimiento NIC 1',
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[300],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceComprobacion() {
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
                    'CÓDIGO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'DESCRIPCIÓN DE LA CUENTA',
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
                    'SUMAS DEBE',
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
                    'SUMAS HABER',
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
                    'SALDO DEUDOR',
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
                    'SALDO ACREEDOR',
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
          _buildTrialBalanceRow(
            '1.1.01.01',
            'Caja Moneda Nacional',
            '450,000.00',
            '150,000.00',
            '300,000.00',
            '0.00',
          ),
          _buildTrialBalanceRow(
            '1.1.01.02',
            'Banco M.N.',
            '1,200,000.00',
            '800,000.00',
            '400,000.00',
            '0.00',
          ),
          _buildTrialBalanceRow(
            '2.1.01.01',
            'Cuentas por Pagar Comerciales',
            '200,000.00',
            '350,000.00',
            '0.00',
            '150,000.00',
          ),
          _buildTrialBalanceRow(
            '3.1.01.01',
            'Capital Social',
            '0.00',
            '1,000,000.00',
            '0.00',
            '1,000,000.00',
          ),
          _buildTrialBalanceRow(
            '4.1.01.01',
            'Ventas de Servicios',
            '0.00',
            '2,500,000.00',
            '0.00',
            '2,500,000.00',
          ),
          _buildTrialBalanceRow(
            '6.1.01.01',
            'Sueldos y Salarios',
            '600,000.00',
            '0.00',
            '600,000.00',
            '0.00',
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              border: const Border(top: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'TOTALES SUMAS Y SALDOS',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '2,450,000.00',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '2,450,000.00',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '1,300,000.00',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '1,300,000.00',
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
          ),
        ],
      ),
    );
  }

  Widget _buildTrialBalanceRow(
    String code,
    String name,
    String sDebe,
    String sHaber,
    String sDeudor,
    String sAcreedor,
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
              code,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sDebe,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sHaber,
              textAlign: TextAlign.right,
              style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              sDeudor,
              textAlign: TextAlign.right,
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
              sAcreedor,
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
}
