import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingCashFlowForecastScreen extends StatelessWidget {
  const AccountingCashFlowForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsRow(),
        const SizedBox(height: 24),
        _buildScenariosRow(),
        const SizedBox(height: 24),
        _buildMatrix(),
        const SizedBox(height: 24),
        _buildBottomAlerts(),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricCard(
          title: 'SALDO INICIAL PROYECTADO Q3',
          icon: Icons.account_balance,
          value: 'Bs. 482,900.00',
          valueColor: Colors.white,
          footerText: 'Conciliado con Bóvedas y BNB / Santander',
          footerIconColor: const Color(0xFF6366F1),
        ),
        _buildMetricCard(
          title: 'ENTRADAS OPERATIVAS ESTIMADAS (CxC)',
          icon: Icons.arrow_upward,
          value: '+Bs. 620,000.00',
          valueColor: const Color(0xFF34D399),
          customFooter: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '+12.4% vs mes\nanterior',
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
                  'Cartera vigente\n94.2%',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildMetricCard(
          title: 'SALIDAS OPERATIVAS ESTIMADAS (CxP/OPEX)',
          icon: Icons.arrow_downward,
          value: '-Bs. 515,000.00',
          valueColor: const Color(0xFFEF4444),
          customFooter: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F1D1D).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Egresos\nComprometidos',
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
                  'Nómina, Proveedor...',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildMetricCard(
          title: 'SUPERÁVIT NETO PROYECTADO',
          icon: Icons.trending_up,
          value: '+Bs. 105,000.00',
          valueColor: Colors.white,
          suffix: '/ mensual\nprom.',
          footerText: 'Línea de flotación y solvencia garantizada',
          footerIconColor: const Color(0xFF34D399),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required String value,
    required Color valueColor,
    String? suffix,
    String? footerText,
    Color? footerIconColor,
    Widget? customFooter,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
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
                Icon(icon, color: Colors.grey[500], size: 14),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.robotoMono(
                    color: valueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    suffix,
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (customFooter != null)
              customFooter
            else if (footerText != null)
              Row(
                children: [
                  Icon(Icons.circle, color: footerIconColor, size: 8),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      footerText,
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenariosRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, color: Colors.grey, size: 16),
          const SizedBox(width: 8),
          Text(
            'ESCENARIO:',
            style: GoogleFonts.inter(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          _buildScenarioChip(
            'Escenario Base / Conservador',
            true,
            const Color(0xFF6366F1),
          ),
          const SizedBox(width: 12),
          _buildScenarioChip(
            'Escenario Optimista (+15% en Cobros)',
            false,
            Colors.grey,
          ),
          const SizedBox(width: 12),
          _buildScenarioChip(
            'Escenario Estresado (-20% / Stress Test)',
            false,
            Colors.grey,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                _buildToggleButton('Semanal', false),
                _buildToggleButton('Mensual (Jul-Dic)', true),
                _buildToggleButton('Trimestral Q3-Q4', false),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 8),
              Text(
                'Línea Flotación Mínima (Bs. 150,000)',
                style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BOB',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    'USD',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 10,
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

  Widget _buildScenarioChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? null : Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: isActive ? Colors.white : color, size: 8),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isActive ? Colors.white : Colors.grey[500],
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMatrix() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F30), // Slightly darker background for matrix
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.table_chart_outlined,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'MATRIZ MENSUAL ESTRUCTURADA NIC 7 (VALORES EXPRESADOS EN BOLIVIANOS - BOB)',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.square, color: Colors.grey[600], size: 10),
                    const SizedBox(width: 4),
                    Text(
                      'Real Ejecutado',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.square,
                      color: Color(0xFF6366F1),
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cierre Septiembre',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.square, color: Colors.grey[800], size: 10),
                    const SizedBox(width: 4),
                    Text(
                      'Proyectado Q4',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'CONCEPTO DE FLUJO / PARTIDA',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'JULIO 2026',
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(REAL)',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'AGOSTO 2026',
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(REAL)',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'SEPTIEMBRE 2026',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(CIERRE)',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6366F1),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'OCTUBRE 2026',
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(PROY.)',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'NOVIEMBRE 2026',
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(PROY.)',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildDataRow(
            title: '(+) SALDO DE CAJA INICIAL',
            isHeader: true,
            v1: '395,000.00',
            v2: '440,200.00',
            v3: '482,900.00',
            v4: '587,900.00',
            v5: '642,100.00',
          ),
          _buildDataRow(
            title: '(+) INGRESOS OPERATIVOS PROYECTADOS',
            isSectionHeader: true,
            iconColor: const Color(0xFF34D399),
          ),
          _buildDataRow(
            title: 'Cobranzas Clientes Facturas Vigentes (CxC)',
            indent: true,
            v1: '490,000.00',
            v2: '512,000.00',
            v3: '520,000.00',
            v4: '540,000.00',
            v5: '560,000.00',
          ),
          _buildDataRow(
            title: 'Cobranzas Cartera Recuperada & Ventas Contado',
            indent: true,
            v1: '82,000.00',
            v2: '95,000.00',
            v3: '100,000.00',
            v4: '85,000.00',
            v5: '90,000.00',
          ),
          _buildDataRow(
            title: '= TOTAL INGRESOS OPERATIVOS',
            isTotalRow: true,
            color: const Color(0xFF34D399),
            v1: '572,000.00',
            v2: '607,000.00',
            v3: '620,000.00',
            v4: '625,000.00',
            v5: '650,000.00',
          ),

          _buildDataRow(
            title: '(-) EGRESOS OPERATIVOS ESTIMADOS (OPEX)',
            isSectionHeader: true,
            iconColor: const Color(0xFFEF4444),
          ),
          _buildDataRow(
            title: 'Pagos Programados a Proveedores (CxP)',
            indent: true,
            v1: '(195,000.00)',
            v2: '(204,300.00)',
            v3: '(210,000.00)',
            v4: '(225,000.00)',
            v5: '(228,000.00)',
            isNegative: true,
          ),
          _buildDataRow(
            title: 'Planilla de Sueldos y Cargas Sociales',
            indent: true,
            v1: '(182,000.00)',
            v2: '(184,000.00)',
            v3: '(185,000.00)',
            v4: '(185,000.00)',
            v5: '(185,000.00)',
            isNegative: true,
          ),
          _buildDataRow(
            title: 'Impuestos y Retenciones Fiscales',
            indent: true,
            v1: '(68,000.00)',
            v2: '(71,000.00)',
            v3: '(75,000.00)',
            v4: '(68,000.00)',
            v5: '(72,000.00)',
            isNegative: true,
          ),
          _buildDataRow(
            title: 'Mantenimiento & Servicios Generales Planta',
            indent: true,
            v1: '(41,800.00)',
            v2: '(44,000.00)',
            v3: '(45,000.00)',
            v4: '(42,000.00)',
            v5: '(44,000.00)',
            isNegative: true,
          ),
          _buildDataRow(
            title: '= TOTAL EGRESOS OPERATIVOS',
            isTotalRow: true,
            color: const Color(0xFFEF4444),
            v1: '(486,800.00)',
            v2: '(503,300.00)',
            v3: '(515,000.00)',
            v4: '(520,000.00)',
            v5: '(529,000.00)',
          ),

          _buildDataRow(
            title: '(=) FLUJO OPERATIVO NETO (OCF)',
            isHeader: true,
            tag: 'EBITDA',
            color: const Color(0xFF34D399),
            v1: '+85,200.00',
            v2: '+103,700.00',
            v3: '+105,000.00',
            v4: '+105,000.00',
            v5: '+121,000.00',
            isBoldValues: true,
          ),

          _buildDataRow(
            title: '(-) EGRESOS DE CAPITAL (CAPEX) & INVERSIONES',
            isSectionHeader: true,
            iconColor: const Color(0xFF6366F1),
          ),
          _buildDataRow(
            title: 'Cuotas Adquisición de Activos Fijos & Maquinaria',
            indent: true,
            v1: '(40,000.00)',
            v2: '(40,000.00)',
            v3: '(35,000.00)',
            v4: '(40,000.00)',
            v5: '(40,000.00)',
            isNegative: true,
          ),

          _buildDataRow(
            title: '(=) SALDO FINAL DISPONIBLE (Línea Flotación)',
            subtitle: 'Tesorería Central consolidada post-compromisos',
            isHeader: true,
            highlightV3: true,
            color: Colors.white,
            v1: '440,200.00',
            v2: '482,900.00',
            v3: '552,900.00',
            v4: '617,900.00',
            v5: '687,900.00',
            isBoldValues: true,
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFF59E0B),
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  '* En Diciembre 2026 se computa la provisión del Segundo Aguinaldo y Cierre Contable Anual.',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Text(
                  'AUDITORÍA: OK   PRECISIÓN: 2 DECIMALES',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required String title,
    String? subtitle,
    bool isHeader = false,
    bool isSectionHeader = false,
    bool isTotalRow = false,
    bool indent = false,
    Color? iconColor,
    Color? color,
    String? v1,
    String? v2,
    String? v3,
    String? v4,
    String? v5,
    bool isNegative = false,
    bool isBoldValues = false,
    bool highlightV3 = false,
    String? tag,
  }) {
    Color valColor(String? v, bool highlight) {
      if (highlight) return const Color(0xFF34D399);
      if (color != null) return color;
      if (isNegative) return const Color(0xFFFCA5A5);
      return Colors.white;
    }

    Widget valueText(String? v, {bool highlight = false}) {
      if (v == null) return const SizedBox();
      return Column(
        children: [
          if (highlightV3 && highlight)
            Text(
              'Bs.',
              style: GoogleFonts.robotoMono(
                color: valColor(v, highlight),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            v,
            style: GoogleFonts.robotoMono(
              color: valColor(v, highlight),
              fontSize: highlightV3 && highlight ? 14 : 11,
              fontWeight: isBoldValues || highlight
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isTotalRow
            ? const Color(0xFF1E293B).withValues(alpha: 0.5)
            : (highlightV3
                  ? const Color(0xFF0F172A).withValues(alpha: 0.5)
                  : Colors.transparent),
        border: const Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: indent ? 24 : 0),
              child: Row(
                children: [
                  if (isSectionHeader) ...[
                    Icon(Icons.add_circle_outline, color: iconColor, size: 14),
                    const SizedBox(width: 8),
                  ],
                  if (highlightV3) ...[
                    Container(
                      width: 4,
                      height: 16,
                      color: const Color(0xFF34D399),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  color:
                                      color ??
                                      (isHeader || isSectionHeader || isTotalRow
                                          ? Colors.white
                                          : Colors.grey[300]),
                                  fontSize: isHeader ? 12 : 11,
                                  fontWeight:
                                      isHeader || isSectionHeader || isTotalRow
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (tag != null)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF818CF8),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 2, child: Center(child: valueText(v1))),
          Expanded(flex: 2, child: Center(child: valueText(v2))),
          Expanded(
            flex: 2,
            child: Center(child: valueText(v3, highlight: highlightV3)),
          ),
          Expanded(flex: 2, child: Center(child: valueText(v4))),
          Expanded(flex: 2, child: Center(child: valueText(v5))),
        ],
      ),
    );
  }

  Widget _buildBottomAlerts() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB45309).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Punto de Tensión Estacional Detectado: Diciembre 2026',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFBBF24),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFB45309,
                              ).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Riesgo Controlado',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFBBF24),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'La provisión de doble aguinaldo legal y retenciones tributarias de fin de año incrementará las salidas operativas a Bs. 687,000.00. Aunque el flujo operativo mensual presentará un déficit técnico momentáneo de -Bs. 15,000.00, el saldo arrastrado de caja (Bs. 672,900.00) garantiza una cobertura holgada 4.4x sobre la línea de flotación mínima exigida (Bs. 150,000.00).',
                        style: GoogleFonts.inter(
                          color: Colors.grey[300],
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
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
                  children: [
                    Text(
                      'SANDBOX DE ESTRÉS',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Icon(
                      Icons.science_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Simule impactos de morosidad o contracción de facturación para recalcular la solvencia en tiempo real.',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F1D1D).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simular Caída de Cobranza (-15%)',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFCA5A5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFFFCA5A5),
                        size: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance,
                        color: Color(0xFF818CF8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Generar Orden de Crédito Preventivo BNB',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF818CF8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF818CF8),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
