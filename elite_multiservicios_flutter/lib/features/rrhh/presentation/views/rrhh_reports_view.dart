import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // Header Principal con Exportación
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.12),
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
                              Text(
                                'Centro de Reportes & Métricas',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Planillas consolidadas, análisis salarial, bitácora de asistencias y exportación normativa',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
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
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _simulateExport(
                                context,
                                'Planilla General (Excel)',
                                'xlsx',
                              ),
                              icon: const Icon(Icons.table_view, size: 16),
                              label: const Text('Exportar Excel'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => _simulateExport(
                                context,
                                'Informe Ejecutivo RRHH',
                                'pdf',
                              ),
                              icon: const Icon(Icons.picture_as_pdf, size: 16),
                              label: const Text('Descargar PDF'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 11,
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
                    const SizedBox(height: 16),

                    // Barra de Filtros
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TabBar(
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
                                    'Planilla Consolidada (${filteredEmployees.length})',
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
                        ),
                        const SizedBox(width: 12),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'TODOS', label: Text('Todos')),
                            ButtonSegment(
                              value: 'OFICINA',
                              label: Text('Oficina'),
                            ),
                            ButtonSegment(value: 'CAMPO', label: Text('Campo')),
                          ],
                          selected: {_filterType},
                          onSelectionChanged: (val) =>
                              setState(() => _filterType = val.first),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStatePropertyAll(
                              GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'ACTIVO',
                              label: Text('Activos'),
                            ),
                            ButtonSegment(
                              value: 'INACTIVO',
                              label: Text('Bajas'),
                            ),
                            ButtonSegment(value: 'TODOS', label: Text('Ambos')),
                          ],
                          selected: {_filterStatus},
                          onSelectionChanged: (val) =>
                              setState(() => _filterStatus = val.first),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStatePropertyAll(
                              GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Filtrar reporte...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 18,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
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
                  ],
                ),
              ),

              // KPI bar rápida
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                color: isDark
                    ? const Color(0xFF0B1324)
                    : const Color(0xFFF1F5F9),
                child: Row(
                  children: [
                    _buildKpiPill(
                      label: 'Registros Filtrados',
                      value: '${filteredEmployees.length}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 16),
                    _buildKpiPill(
                      label: 'Masa Salarial Filtrada',
                      value: 'Bs. ${totalSalary.toStringAsFixed(2)}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 16),
                    _buildKpiPill(
                      label: 'Personal Oficina',
                      value:
                          '${filteredEmployees.where((e) => e.type == "OFICINA").length}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 16),
                    _buildKpiPill(
                      label: 'Personal Campo',
                      value:
                          '${filteredEmployees.where((e) => e.type == "CAMPO").length}',
                      isDark: isDark,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _simulateExport(
                        context,
                        'Libro de Asistencia Oficial (Ministerio de Trabajo)',
                        'pdf',
                      ),
                      icon: const Icon(Icons.account_balance, size: 16),
                      label: const Text('Formato Min. de Trabajo'),
                      style: TextButton.styleFrom(
                        textStyle: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido de Tablas
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

  Widget _buildKpiPill({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
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

  // 1. Tabla de Nómina Consolidada
  Widget _buildPayrollTable(List dynamicEmployees, bool isDark) {
    if (dynamicEmployees.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay datos para mostrar',
        message: 'Ajuste los filtros de búsqueda o tipo de colaborador.',
        icon: Icons.filter_alt_off_outlined,
      );
    }

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
                        thumbVisibility: true,
                        child: SingleChildScrollView(
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
                        thumbVisibility: true,
                        child: SingleChildScrollView(
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
                        thumbVisibility: true,
                        child: SingleChildScrollView(
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
