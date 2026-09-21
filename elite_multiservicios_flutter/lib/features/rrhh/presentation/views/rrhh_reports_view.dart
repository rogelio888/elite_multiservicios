import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';
import '../widgets/rrhh_export_payroll_dialog.dart';
import '../utils/rrhh_payroll_exporter.dart';

/// Centro de Reportes y Analítica Laboral de RRHH.
class RrhhReportsView extends StatefulWidget {
  const RrhhReportsView({super.key});

  @override
  State<RrhhReportsView> createState() => _RrhhReportsViewState();
}

class _RrhhReportsViewState extends State<RrhhReportsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();

  String _filterType = 'TODOS'; // TODOS, OFICINA, CAMPO
  String _filterStatus = 'ACTIVO'; // ACTIVO, INACTIVO, TODOS
  String _searchQuery = '';
  String _payrollViewMode = 'OFICIAL'; // OFICIAL, RESUMEN

  late final ScrollController _payrollScrollController;
  late final ScrollController _incidentsScrollController;
  late final ScrollController _exitsScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _payrollScrollController = ScrollController();
    _incidentsScrollController = ScrollController();
    _exitsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _payrollScrollController.dispose();
    _incidentsScrollController.dispose();
    _exitsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _stateService,
      builder: (context, _) {
        final filteredEmployees = _stateService.allEmployees.where((e) {
          if (_filterType != 'TODOS' && e.type != _filterType) {
            return false;
          }
          if (_filterStatus != 'TODOS' && e.status != _filterStatus) {
            return false;
          }
          if (_searchQuery.isEmpty) {
            return true;
          }
          final q = _searchQuery.toLowerCase();
          return e.fullName.toLowerCase().contains(q) ||
              e.code.toLowerCase().contains(q) ||
              e.position.toLowerCase().contains(q) ||
              (e.clientCompanyName?.toLowerCase().contains(q) ?? false) ||
              e.area.toLowerCase().contains(q);
        }).toList();

        final totalSalary = filteredEmployees.fold<double>(
          0,
          (sum, e) => sum + e.baseSalary,
        );

        final oficinaCount = filteredEmployees
            .where((e) => e.type == "OFICINA")
            .length;
        final campoCount = filteredEmployees
            .where((e) => e.type == "CAMPO")
            .length;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // 1. Header Principal Ejecutivo con Exportación
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.analytics_outlined,
                        color: Color(0xFF6366F1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Centro de Reportes & Planillas',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Text(
                                  'NIT: 4625505019',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Elite Multiservicios • Planilla Oficial de Sueldos (OVT / Min. de Trabajo) y Auditoría Laboral',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'OFICIAL',
                              label: Text('Planilla Oficial (19 col)'),
                              icon: Icon(Icons.table_chart_outlined, size: 14),
                            ),
                            ButtonSegment(
                              value: 'RESUMEN',
                              label: Text('Directorio'),
                              icon: Icon(Icons.view_compact_outlined, size: 14),
                            ),
                          ],
                          selected: {_payrollViewMode},
                          onSelectionChanged: (val) =>
                              setState(() => _payrollViewMode = val.first),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStatePropertyAll(
                              GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => _openExportPayrollDialog(context),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 16,
                          ),
                          label: const Text('Exportar Excel (.xls)'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _simulateExport(
                            context,
                            'Informe Ejecutivo RRHH',
                            'pdf',
                          ),
                          icon: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 16,
                          ),
                          label: const Text('Descargar PDF'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Tarjetas Ejecutivas de KPIs (Diseño limpio y proporcional, CERO OVERFLOW)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Total Colaboradores',
                        value: '${filteredEmployees.length} activos',
                        sub: '$oficinaCount Oficina • $campoCount Campo',
                        icon: Icons.people_outline,
                        color: const Color(0xFF6366F1),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Masa Salarial Bruta',
                        value: 'Bs. ${totalSalary.toStringAsFixed(2)}',
                        sub: 'Total ganado mensual computable',
                        icon: Icons.payments_outlined,
                        color: const Color(0xFF3B82F6),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Aporte Gestora (12.71%)',
                        value:
                            'Bs. ${(totalSalary * 0.1271).toStringAsFixed(2)}',
                        sub: 'Seguridad Social / Jubilación',
                        icon: Icons.account_balance_outlined,
                        color: const Color(0xFFF59E0B),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'Líquido Pagable Total',
                        value:
                            'Bs. ${(totalSalary * (1 - 0.1271)).toStringAsFixed(2)}',
                        sub: 'Neto transferible a trabajadores',
                        icon: Icons.verified_outlined,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Barra Unificada de Pestañas y Filtros
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    TabBar(
                      controller: _tabController,
                      onTap: (_) => setState(() {}),
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: const Color(0xFF6366F1),
                      unselectedLabelColor: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      indicatorColor: const Color(0xFF6366F1),
                      indicatorWeight: 3,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        Tab(
                          text:
                              'Planilla Oficial de Sueldos (${filteredEmployees.length})',
                        ),
                        Tab(
                          text:
                              'Incidencias (${_stateService.incidents.length})',
                        ),
                        Tab(
                          text:
                              'Bajas Históricas (${_stateService.exits.length})',
                        ),
                      ],
                    ),
                    const Spacer(),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'TODOS', label: Text('Todos')),
                        ButtonSegment(value: 'OFICINA', label: Text('Oficina')),
                        ButtonSegment(value: 'CAMPO', label: Text('Campo')),
                      ],
                      selected: {_filterType},
                      onSelectionChanged: (val) =>
                          setState(() => _filterType = val.first),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        textStyle: WidgetStatePropertyAll(
                          GoogleFonts.inter(fontSize: 11.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'ACTIVO', label: Text('Activos')),
                        ButtonSegment(value: 'INACTIVO', label: Text('Bajas')),
                      ],
                      selected: {_filterStatus},
                      onSelectionChanged: (val) =>
                          setState(() => _filterStatus = val.first),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        textStyle: WidgetStatePropertyAll(
                          GoogleFonts.inter(fontSize: 11.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 190,
                      height: 36,
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buscar colaborador...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF0B1324)
                              : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Contenido de Tablas
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPayrollTable(filteredEmployees, isDark),
                    _buildIncidentsTable(isDark),
                    _buildExitsTable(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text,
    bool isDark, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildBodyCell(
    Widget child, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: child,
    );
  }

  // 1. Tabla de Nómina (Oficial de Sueldos y Salarios vs Resumen)
  Widget _buildPayrollTable(List dynamicEmployees, bool isDark) {
    if (dynamicEmployees.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay datos para mostrar',
        message: 'Ajuste los filtros de búsqueda o tipo de colaborador.',
        icon: Icons.filter_alt_off_outlined,
      );
    }

    if (_payrollViewMode == 'OFICIAL') {
      return _buildOfficialPayrollTable(dynamicEmployees, isDark);
    } else {
      return _buildSummaryPayrollTable(dynamicEmployees, isDark);
    }
  }

  // 1.A. PLANILLA OFICIAL DE SUELDOS Y SALARIOS (Formato Normativo Ministerio de Trabajo / Contabilidad)
  Widget _buildOfficialPayrollTable(List dynamicEmployees, bool isDark) {
    const columnWidths = {
      0: FixedColumnWidth(48), // Nº
      1: FixedColumnWidth(
        125,
      ), // Carnet de Identidad (e.g. 7823901 SCZ sin saltos)
      2: FixedColumnWidth(230), // Nombre del Empleado (completo sin recortes)
      3: FixedColumnWidth(110), // Nacionalidad (BOLIVIANA sin saltos)
      4: FixedColumnWidth(115), // F. Nacimiento (14/02/1996 en 1 línea)
      5: FixedColumnWidth(55), // Sexo (F / M)
      6: FixedColumnWidth(230), // Ocupación que Desempeña
      7: FixedColumnWidth(115), // Fecha Ingreso (01/12/2023 en 1 línea)
      8: FixedColumnWidth(120), // Sueldo Básico
      9: FixedColumnWidth(55), // Días Pagados (30)
      10: FixedColumnWidth(55), // Horas (8)
      11: FixedColumnWidth(125), // Salario Ganado (A)
      12: FixedColumnWidth(130), // Bono Antigüedad (B)
      13: FixedColumnWidth(100), // H. Extras (C)
      14: FixedColumnWidth(110), // Otros Bonos (D-F)
      15: FixedColumnWidth(130), // Total Ganado (G)
      16: FixedColumnWidth(130), // Retención Gestora 12.71% (H)
      17: FixedColumnWidth(105), // Otros Desc. (I-K)
      18: FixedColumnWidth(130), // Total Descuentos (L)
      19: FixedColumnWidth(140), // Líquido Pagable (LL)
      20: FixedColumnWidth(100), // Firma
    };

    const tableWidth = 2430.0;

    // Acumuladores de totales generales
    double sumSueldoBasico = 0;
    double sumSalarioGanado = 0;
    double sumBonoAntiguedad = 0;
    double sumTotalGanado = 0;
    double sumGestora = 0;
    double sumTotalDescuentos = 0;
    double sumLiquidoPagable = 0;

    final refDate = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Sub-barra de identificación de la planilla
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF1F5F9),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.table_chart_rounded,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PLANILLA DE SUELDOS Y SALARIOS — SEPTIEMBRE 2026 (EXPRESADO EN BOLIVIANOS)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Pestaña Oficial: PSUELDOS (Formato OVT / Min. Trabajo)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenedor con scroll horizontal para todas las columnas de ley
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      // Cabecera Fija Oficial
                      Table(
                        columnWidths: columnWidths,
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF161F30)
                                  : const Color(0xFFF8FAFC),
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                            children: [
                              _buildHeaderCell(
                                'Nº',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell('Carnet de Identidad', isDark),
                              _buildHeaderCell('Nombre del Empleado', isDark),
                              _buildHeaderCell(
                                'Nacionalidad',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'F. Nacimiento',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Sexo',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Ocupación que Desempeña',
                                isDark,
                              ),
                              _buildHeaderCell(
                                'F. Ingreso',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Sueldo Básico',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Días',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Horas',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Salario Ganado (A)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Bono Antigüedad (B)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'H. Extras (C)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Otros Bonos (D-F)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Total Ganado (G)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Gestora 12.71% (H)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Otros Desc. (I-K)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Total Desc. (L)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Líquido Pagable (LL)',
                                isDark,
                                alignment: Alignment.centerRight,
                              ),
                              _buildHeaderCell(
                                'Firma',
                                isDark,
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Filas de Datos con Scroll Vertical
                      Expanded(
                        child: Scrollbar(
                          controller: _payrollScrollController,
                          thumbVisibility: true,
                          interactive: true,
                          child: SingleChildScrollView(
                            controller: _payrollScrollController,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Table(
                                  columnWidths: columnWidths,
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: dynamicEmployees.asMap().entries.map((
                                    entry,
                                  ) {
                                    final idx = entry.key;
                                    final e = entry.value;

                                    final num = idx + 1;
                                    final ci = e.identityCard.isNotEmpty
                                        ? e.identityCard
                                        : '${e.code} SC';
                                    final nombre = e.fullName.toUpperCase();
                                    const nacionalidad = 'BOLIVIANA';
                                    final fechaNac = e.birthDate != null
                                        ? '${e.birthDate!.day.toString().padLeft(2, "0")}/${e.birthDate!.month.toString().padLeft(2, "0")}/${e.birthDate!.year}'
                                        : '15/04/1992';
                                    final sexo =
                                        RrhhPayrollExporter.inferGender(
                                          e.fullName,
                                        );
                                    final ocupacion = e.position.isNotEmpty
                                        ? e.position.toUpperCase()
                                        : e.occupation.toUpperCase();
                                    final fechaIngreso =
                                        '${e.fiscalStartDate.day.toString().padLeft(2, "0")}/${e.fiscalStartDate.month.toString().padLeft(2, "0")}/${e.fiscalStartDate.year}';

                                    final sueldoBasico = e.baseSalary;
                                    const dias = 30;
                                    const horas = 8;
                                    final salarioGanado = sueldoBasico;
                                    final bonoAntiguedad =
                                        RrhhPayrollExporter.calculateSeniorityBonus(
                                          e.fiscalStartDate,
                                          refDate,
                                        );
                                    const he = 0.0;
                                    const otrosBonos = 0.0;
                                    final totalGanado =
                                        salarioGanado +
                                        bonoAntiguedad +
                                        he +
                                        otrosBonos;
                                    final gestora = double.parse(
                                      (totalGanado * 0.1271).toStringAsFixed(2),
                                    );
                                    const otrosDesc = 0.0;
                                    final totalDesc = gestora + otrosDesc;
                                    final liquidoPagable =
                                        totalGanado - totalDesc;

                                    // Acumular sumas
                                    sumSueldoBasico += sueldoBasico;
                                    sumSalarioGanado += salarioGanado;
                                    sumBonoAntiguedad += bonoAntiguedad;
                                    sumTotalGanado += totalGanado;
                                    sumGestora += gestora;
                                    sumTotalDescuentos += totalDesc;
                                    sumLiquidoPagable += liquidoPagable;

                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color: idx % 2 == 1
                                            ? (isDark
                                                  ? const Color(
                                                      0xFF131B2E,
                                                    ).withValues(alpha: 0.5)
                                                  : const Color(0xFFF8FAFC))
                                            : Colors.transparent,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isDark
                                                ? const Color(0xFF1E293B)
                                                : const Color(0xFFE2E8F0),
                                          ),
                                        ),
                                      ),
                                      children: [
                                        // 0: Nº
                                        _buildBodyCell(
                                          Text(
                                            '$num',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 1: C.I.
                                        _buildBodyCell(
                                          Text(
                                            ci,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                        // 2: Nombre
                                        _buildBodyCell(
                                          Text(
                                            nombre,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        // 3: Nacionalidad
                                        _buildBodyCell(
                                          Text(
                                            nacionalidad,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 4: Fecha Nacimiento
                                        _buildBodyCell(
                                          Text(
                                            fechaNac,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 5: Sexo
                                        _buildBodyCell(
                                          Text(
                                            sexo,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 6: Ocupación
                                        _buildBodyCell(
                                          Text(
                                            ocupacion,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              color: isDark
                                                  ? const Color(0xFFCBD5E1)
                                                  : const Color(0xFF334155),
                                            ),
                                          ),
                                        ),
                                        // 7: Fecha Ingreso
                                        _buildBodyCell(
                                          Text(
                                            fechaIngreso,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 8: Sueldo Básico
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${sueldoBasico.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 9: Días
                                        _buildBodyCell(
                                          const Text(
                                            '$dias',
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 10: Horas
                                        _buildBodyCell(
                                          const Text(
                                            '$horas',
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        // 11: Salario Ganado (A)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${salarioGanado.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 12: Bono Antigüedad (B)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${bonoAntiguedad.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 13: HE (C)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${he.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 14: Otros Bonos (D-F)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${otrosBonos.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 15: Total Ganado (G)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${totalGanado.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 16: Retención Gestora 12.71% (H)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${gestora.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: const Color(0xFFEF4444),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 17: Otros Desc. (I-K)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${otrosDesc.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 18: Total Descuentos (L)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${totalDesc.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFFEF4444),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 19: Líquido Pagable (LL)
                                        _buildBodyCell(
                                          Text(
                                            'Bs. ${liquidoPagable.toStringAsFixed(2)}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF10B981),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        // 20: Firma
                                        _buildBodyCell(
                                          Container(
                                            height: 1,
                                            width: 60,
                                            color: isDark
                                                ? const Color(0xFF334155)
                                                : const Color(0xFFCBD5E1),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),

                                // Fila TOTAL GENERAL (Pie de la tabla)
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF161F30)
                                        : const Color(0xFFF1F5F9),
                                    border: Border(
                                      top: BorderSide(
                                        color: isDark
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFCBD5E1),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Table(
                                    columnWidths: columnWidths,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          _buildBodyCell(
                                            const SizedBox(),
                                            alignment: Alignment.center,
                                          ),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(
                                            Text(
                                              'TOTAL GENERAL (${dynamicEmployees.length})',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(const SizedBox()),
                                          // 8: Sueldo Básico Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumSueldoBasico.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          _buildBodyCell(const SizedBox()),
                                          _buildBodyCell(const SizedBox()),
                                          // 11: Salario Ganado Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumSalarioGanado.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          // 12: Bono Antigüedad Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumBonoAntiguedad.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          _buildBodyCell(
                                            Text(
                                              'Bs. 0.00',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          _buildBodyCell(
                                            Text(
                                              'Bs. 0.00',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          // 15: Total Ganado Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumTotalGanado.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF6366F1),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          // 16: Gestora Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumGestora.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFFEF4444),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          _buildBodyCell(
                                            Text(
                                              'Bs. 0.00',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          // 18: Total Descuentos Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumTotalDescuentos.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFFEF4444),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          // 19: Líquido Pagable Total
                                          _buildBodyCell(
                                            Text(
                                              'Bs. ${sumLiquidoPagable.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: const Color(0xFF10B981),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                          _buildBodyCell(const SizedBox()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Bloque de Certificación Legal y Firmas al pie
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF0B1324)
                                        : const Color(0xFFF8FAFC),
                                    border: Border(
                                      top: BorderSide(
                                        color: isDark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              '________________________________________',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.white38
                                                    : Colors.black38,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                            Text(
                                              'ROGELIO ARANDIA ARANDIA',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              '________________________________________',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.white38
                                                    : Colors.black38,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'NO. CARNET DE IDENTIDAD',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                            Text(
                                              '4444455 OR',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              '________________________________________',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.white38
                                                    : Colors.black38,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'FIRMA',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                            Text(
                                              'Sello y Rúbrica Institucional',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontStyle: FontStyle.italic,
                                                color: isDark
                                                    ? Colors.white38
                                                    : Colors.black38,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'La Paz, viernes, 18 de septiembre de 2026',
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontStyle: FontStyle.italic,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Planilla Oficial conforme a Ley General del Trabajo de Bolivia',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                color: isDark
                                                    ? Colors.white38
                                                    : Colors.black38,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1.B. VISTA RESUMEN RÁPIDO DE PERSONAL (8 columnas)
  Widget _buildSummaryPayrollTable(List dynamicEmployees, bool isDark) {
    const columnWidths = {
      0: FixedColumnWidth(95), // Código
      1: FlexColumnWidth(2.0), // Colaborador
      2: FixedColumnWidth(100), // Tipo
      3: FlexColumnWidth(2.2), // Cargo
      4: FlexColumnWidth(2.2), // Área / Cliente
      5: FixedColumnWidth(125), // Salario Base
      6: FlexColumnWidth(2.3), // Correo APK
      7: FixedColumnWidth(105), // Estado
    };

    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            final tableWidth = boxConstraints.maxWidth < 1180
                ? 1180.0
                : boxConstraints.maxWidth;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                height: boxConstraints.maxHeight,
                child: Column(
                  children: [
                    // Cabecera fija
                    Table(
                      columnWidths: columnWidths,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          children: [
                            _buildHeaderCell('Código', isDark),
                            _buildHeaderCell('Colaborador', isDark),
                            _buildHeaderCell('Tipo', isDark),
                            _buildHeaderCell('Cargo', isDark),
                            _buildHeaderCell('Área / Cliente', isDark),
                            _buildHeaderCell('Salario Base', isDark),
                            _buildHeaderCell('Correo APK', isDark),
                            _buildHeaderCell('Estado', isDark),
                          ],
                        ),
                      ],
                    ),
                    // Filas con scroll vertical
                    Expanded(
                      child: Scrollbar(
                        controller: _payrollScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _payrollScrollController,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Table(
                            columnWidths: columnWidths,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: dynamicEmployees.map((e) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                children: [
                                  // 0: Código
                                  _buildBodyCell(
                                    Text(
                                      e.code,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                  ),
                                  // 1: Colaborador
                                  _buildBodyCell(
                                    Text(
                                      e.fullName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  // 2: Tipo
                                  _buildBodyCell(
                                    RrhhEmployeeTypeBadge(type: e.type),
                                  ),
                                  // 3: Cargo
                                  _buildBodyCell(
                                    Text(
                                      e.position,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                  // 4: Área / Cliente
                                  _buildBodyCell(
                                    Text(
                                      e.type == 'OFICINA'
                                          ? 'Oficina Central (${e.area ?? "General"})'
                                          : '${e.clientCompanyName ?? "Cliente"} (${e.workplaceBranch ?? "Sede"})',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  // 5: Salario Base
                                  _buildBodyCell(
                                    Text(
                                      'Bs. ${e.baseSalary.toStringAsFixed(2)}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  // 6: Correo APK
                                  _buildBodyCell(
                                    Text(
                                      e.effectiveCorporateEmail,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  // 7: Estado
                                  _buildBodyCell(
                                    RrhhStatusChip(status: e.status),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 2. Tabla de Incidencias
  Widget _buildIncidentsTable(bool isDark) {
    final list = _stateService.incidents;
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay incidencias registradas',
        message: 'No existen registros de faltas o sanciones en el sistema.',
        icon: Icons.assignment_turned_in_outlined,
      );
    }

    const columnWidths = {
      0: FlexColumnWidth(2.0), // Colaborador
      1: FixedColumnWidth(110), // Tipo
      2: FixedColumnWidth(110), // Gravedad
      3: FlexColumnWidth(3.0), // Título / Detalle
      4: FixedColumnWidth(110), // Fecha
      5: FlexColumnWidth(1.8), // Reportado Por
    };

    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            final tableWidth = boxConstraints.maxWidth < 1100
                ? 1100.0
                : boxConstraints.maxWidth;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                height: boxConstraints.maxHeight,
                child: Column(
                  children: [
                    // Cabecera fija
                    Table(
                      columnWidths: columnWidths,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          children: [
                            _buildHeaderCell('Colaborador', isDark),
                            _buildHeaderCell('Tipo', isDark),
                            _buildHeaderCell('Gravedad', isDark),
                            _buildHeaderCell('Título / Detalle', isDark),
                            _buildHeaderCell('Fecha', isDark),
                            _buildHeaderCell('Reportado Por', isDark),
                          ],
                        ),
                      ],
                    ),
                    // Filas con scroll vertical
                    Expanded(
                      child: Scrollbar(
                        controller: _incidentsScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _incidentsScrollController,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Table(
                            columnWidths: columnWidths,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: list.map((inc) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                children: [
                                  _buildBodyCell(
                                    Text(
                                      inc.employeeName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    RrhhStatusChip(
                                      label: inc.type,
                                      statusType: inc.type == 'FALTA'
                                          ? StatusType.danger
                                          : StatusType.warning,
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      inc.severity,
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      '${inc.title}: ${inc.description}',
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      '${inc.date.day.toString().padLeft(2, "0")}/${inc.date.month.toString().padLeft(2, "0")}/${inc.date.year}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      inc.reportedBy,
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 3. Tabla de Bajas Históricas
  Widget _buildExitsTable(bool isDark) {
    final list = _stateService.exits;
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay bajas registradas',
        message: 'No existen desvinculaciones registradas en el historial.',
        icon: Icons.history_outlined,
      );
    }

    const columnWidths = {
      0: FlexColumnWidth(2.0), // Colaborador
      1: FixedColumnWidth(120), // Fecha de Baja
      2: FlexColumnWidth(2.0), // Motivo
      3: FixedColumnWidth(130), // Finiquito Pagado
      4: FlexColumnWidth(2.5), // Observaciones
      5: FlexColumnWidth(1.8), // Procesado Por
    };

    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            final tableWidth = boxConstraints.maxWidth < 1100
                ? 1100.0
                : boxConstraints.maxWidth;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                height: boxConstraints.maxHeight,
                child: Column(
                  children: [
                    // Cabecera fija
                    Table(
                      columnWidths: columnWidths,
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          children: [
                            _buildHeaderCell('Colaborador', isDark),
                            _buildHeaderCell('Fecha de Baja', isDark),
                            _buildHeaderCell(
                              'Motivo de Desvinculación',
                              isDark,
                            ),
                            _buildHeaderCell('Finiquito Pagado', isDark),
                            _buildHeaderCell('Observaciones', isDark),
                            _buildHeaderCell('Procesado Por', isDark),
                          ],
                        ),
                      ],
                    ),
                    // Filas con scroll vertical
                    Expanded(
                      child: Scrollbar(
                        controller: _exitsScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _exitsScrollController,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Table(
                            columnWidths: columnWidths,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: list.map((e) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                children: [
                                  _buildBodyCell(
                                    Text(
                                      e.employeeName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      '${e.exitDate.day.toString().padLeft(2, "0")}/${e.exitDate.month.toString().padLeft(2, "0")}/${e.exitDate.year}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    RrhhStatusChip(
                                      label: e.reason,
                                      statusType: StatusType.neutral,
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      'Bs. ${e.severancePay.toStringAsFixed(2)}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      e.exitInterviewNotes,
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      e.processedBy,
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openExportPayrollDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => RrhhExportPayrollDialog(
        employees: _stateService.allEmployees,
      ),
    );
  }

  void _simulateExport(
    BuildContext context,
    String reportName,
    String extension,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Generando y descargando "$reportName.$extension" con firmas normativas...',
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
