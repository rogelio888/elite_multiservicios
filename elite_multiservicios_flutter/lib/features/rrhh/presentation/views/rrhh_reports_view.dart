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

  // 1. Tabla de Nómina Consolidada
  Widget _buildPayrollTable(List dynamicEmployees, bool isDark) {
    if (dynamicEmployees.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay datos para mostrar',
        message: 'Ajuste los filtros de búsqueda o tipo de colaborador.',
        icon: Icons.filter_alt_off_outlined,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            horizontalMargin: 20,
            columnSpacing: 24,
            headingRowColor: WidgetStatePropertyAll(
              isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
            ),
            columns: [
              DataColumn(
                label: Text('Código', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Colaborador', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Tipo', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Cargo', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Área / Cliente', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Salario Base', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Correo APK', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Estado', style: _headerStyle(isDark)),
              ),
            ],
            rows: dynamicEmployees.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      e.code,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  DataCell(RrhhEmployeeTypeBadge(type: e.type)),
                  DataCell(
                    Text(
                      e.position,
                      style: GoogleFonts.inter(fontSize: 12.5),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.type == 'OFICINA'
                          ? 'Oficina Central (${e.area ?? "General"})'
                          : '${e.clientCompanyName ?? "Cliente"} (${e.workplaceBranch ?? "Sede"})',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      'Bs. ${e.baseSalary.toStringAsFixed(2)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.effectiveCorporateEmail,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  DataCell(
                    RrhhStatusChip(
                      label: e.status,
                      statusType: e.status == 'ACTIVO'
                          ? StatusType.success
                          : StatusType.danger,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // 2. Tabla de Incidencias
  Widget _buildIncidentsTable(bool isDark) {
    final list = _stateService.incidents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            horizontalMargin: 20,
            columnSpacing: 24,
            headingRowColor: WidgetStatePropertyAll(
              isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
            ),
            columns: [
              DataColumn(
                label: Text('Colaborador', style: _headerStyle(isDark)),
              ),
              DataColumn(label: Text('Tipo', style: _headerStyle(isDark))),
              DataColumn(label: Text('Gravedad', style: _headerStyle(isDark))),
              DataColumn(
                label: Text('Título / Detalle', style: _headerStyle(isDark)),
              ),
              DataColumn(label: Text('Fecha', style: _headerStyle(isDark))),
              DataColumn(
                label: Text('Reportado Por', style: _headerStyle(isDark)),
              ),
            ],
            rows: list.map((inc) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      inc.employeeName,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    RrhhStatusChip(
                      label: inc.type,
                      statusType: inc.type == 'FALTA'
                          ? StatusType.danger
                          : StatusType.warning,
                    ),
                  ),
                  DataCell(
                    Text(inc.severity, style: GoogleFonts.inter(fontSize: 12)),
                  ),
                  DataCell(
                    Text(
                      '${inc.title}: ${inc.description}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${inc.date.day}/${inc.date.month}/${inc.date.year}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  DataCell(
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
    );
  }

  // 3. Tabla de Bajas Históricas
  Widget _buildExitsTable(bool isDark) {
    final list = _stateService.exits;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            horizontalMargin: 20,
            columnSpacing: 24,
            headingRowColor: WidgetStatePropertyAll(
              isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
            ),
            columns: [
              DataColumn(
                label: Text('Colaborador', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Fecha de Baja', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text(
                  'Motivo de Desvinculación',
                  style: _headerStyle(isDark),
                ),
              ),
              DataColumn(
                label: Text('Finiquito Pagado', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Observaciones', style: _headerStyle(isDark)),
              ),
              DataColumn(
                label: Text('Procesado Por', style: _headerStyle(isDark)),
              ),
            ],
            rows: list.map((e) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      e.employeeName,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.exitDate.day}/${e.exitDate.month}/${e.exitDate.year}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    RrhhStatusChip(
                      label: e.reason,
                      statusType: StatusType.neutral,
                    ),
                  ),
                  DataCell(
                    Text(
                      'Bs. ${e.severancePay.toStringAsFixed(2)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.exitInterviewNotes,
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  DataCell(
                    Text(e.processedBy, style: GoogleFonts.inter(fontSize: 12)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
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
