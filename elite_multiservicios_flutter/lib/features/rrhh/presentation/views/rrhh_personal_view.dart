import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_applicant.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_applicant_modal.dart';
import '../widgets/rrhh_employee_modal.dart';
import '../widgets/rrhh_hire_dialog.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista núcleo de Personal (Todos, Activos, Inactivos, Postulantes)
class RrhhPersonalView extends StatefulWidget {
  const RrhhPersonalView({super.key});

  @override
  State<RrhhPersonalView> createState() => _RrhhPersonalViewState();
}

class _RrhhPersonalViewState extends State<RrhhPersonalView>
    with SingleTickerProviderStateMixin {
  final _rrhhService = RrhhStateService();
  late TabController _tabController;

  String _searchQuery = '';
  String _selectedTypeFilter = 'TODOS'; // 'TODOS', 'OFICINA', 'CAMPO'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _rrhhService.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rrhhService.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  List<RrhhEmployee> _getFilteredEmployees(String statusFilter) {
    return _rrhhService.employees.where((emp) {
      // Filtro de estado
      if (statusFilter == 'ACTIVOS' && emp.status != 'ACTIVO') return false;
      if (statusFilter == 'INACTIVOS' && emp.status != 'INACTIVO') return false;

      // Filtro por tipo
      if (_selectedTypeFilter == 'OFICINA' && emp.employeeType != 'OFICINA') {
        return false;
      }
      if (_selectedTypeFilter == 'CAMPO' && emp.employeeType != 'CAMPO') {
        return false;
      }

      // Búsqueda
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match =
            emp.fullName.toLowerCase().contains(q) ||
            emp.code.toLowerCase().contains(q) ||
            emp.identityCard.toLowerCase().contains(q) ||
            emp.position.toLowerCase().contains(q) ||
            emp.workplace.toLowerCase().contains(q);
        if (!match) return false;
      }

      return true;
    }).toList();
  }

  List<RrhhApplicant> _getFilteredApplicants() {
    return _rrhhService.applicants.where((app) {
      if (_selectedTypeFilter == 'OFICINA' && app.targetType != 'OFICINA') {
        return false;
      }
      if (_selectedTypeFilter == 'CAMPO' && app.targetType != 'CAMPO') {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match =
            app.fullName.toLowerCase().contains(q) ||
            app.code.toLowerCase().contains(q) ||
            app.identityCard.toLowerCase().contains(q) ||
            app.targetPosition.toLowerCase().contains(q) ||
            app.specialty.toLowerCase().contains(q);
        if (!match) return false;
      }

      return true;
    }).toList();
  }

  void _openHireDialog({RrhhApplicant? applicant}) {
    showDialog(
      context: context,
      builder: (ctx) => RrhhHireDialog(initialApplicant: applicant),
    );
  }

  void _openEmployeeModal(RrhhEmployee emp) {
    showDialog(
      context: context,
      builder: (ctx) => RrhhEmployeeModal(employee: emp),
    );
  }

  void _openApplicantModal(RrhhApplicant app) {
    showDialog(
      context: context,
      builder: (ctx) => RrhhApplicantModal(applicant: app),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con Botones de Acción
              _buildHeader(isDark, isMobile),
              const SizedBox(height: 16),

              // Buscador y Selector de Modalidad (Oficina vs Campo)
              _buildFiltersBar(isDark, isMobile),
              const SizedBox(height: 14),

              // Pestañas: Todos | Activos | Inactivos | Postulantes
              _buildTabsBar(isDark),
              const SizedBox(height: 16),

              // Contenido Principal
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEmployeesTableTab(
                      _getFilteredEmployees('TODOS'),
                      isDark,
                      constraints.maxWidth,
                      isMobile,
                    ),
                    _buildEmployeesTableTab(
                      _getFilteredEmployees('ACTIVOS'),
                      isDark,
                      constraints.maxWidth,
                      isMobile,
                    ),
                    _buildEmployeesTableTab(
                      _getFilteredEmployees('INACTIVOS'),
                      isDark,
                      constraints.maxWidth,
                      isMobile,
                    ),
                    _buildApplicantsTableTab(
                      _getFilteredApplicants(),
                      isDark,
                      constraints.maxWidth,
                      isMobile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Directorio de Personal & Postulantes',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Expedientes digitales, colaboradores activos/inactivos y banco de candidatos.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.person_add_alt_1, size: 16),
              label: const Text('Contratar / Registrar'),
              onPressed: () => _openHireDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiltersBar(bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, código, CI o cargo...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Filtro Tipo: TODOS / OFICINA / CAMPO
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'TODOS', label: Text('Todos')),
              ButtonSegment(value: 'OFICINA', label: Text('Oficina')),
              ButtonSegment(value: 'CAMPO', label: Text('Campo')),
            ],
            selected: {_selectedTypeFilter},
            onSelectionChanged: (set) {
              setState(() => _selectedTypeFilter = set.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: const Color(0xFF2563EB),
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: const Color(0xFF2563EB),
        tabs: [
          Tab(text: 'Todos (${_rrhhService.totalEmployeesCount})'),
          Tab(text: 'Activos (${_rrhhService.activeEmployeesCount})'),
          Tab(
            text: 'Inactivos / Bajas (${_rrhhService.inactiveEmployeesCount})',
          ),
          Tab(text: 'Postulantes (${_rrhhService.applicants.length})'),
        ],
      ),
    );
  }

  Widget _buildEmployeesTableTab(
    List<RrhhEmployee> employees,
    bool isDark,
    double maxWidth,
    bool isMobile,
  ) {
    if (employees.isEmpty) {
      return RrhhEmptyState(
        title: 'No se encontraron colaboradores',
        message:
            'No existen registros que coincidan con los filtros o criterios de búsqueda seleccionados.',
        isDark: isDark,
      );
    }

    if (isMobile) {
      return ListView.separated(
        itemCount: employees.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) => _buildEmployeeMobileCard(employees[i], isDark),
      );
    }

    final tableWidth = max(maxWidth - 48, 1080.0);
    const columnWidths = {
      0: FlexColumnWidth(2.6), // Colaborador
      1: FixedColumnWidth(115), // CI
      2: FlexColumnWidth(2.4), // Cargo & Tipo
      3: FlexColumnWidth(2.2), // Sucursal / Sede
      4: FixedColumnWidth(125), // Sueldo
      5: FixedColumnWidth(120), // Expediente
      6: FixedColumnWidth(105), // Estado
      7: FixedColumnWidth(125), // Acciones
    };

    return Container(
      width: double.infinity,
      height: double.infinity,
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
                            _buildHeaderCell('CI / Documento', isDark),
                            _buildHeaderCell('Cargo / Función', isDark),
                            _buildHeaderCell('Sucursal Asignada', isDark),
                            _buildHeaderCell('Sueldo Pactado', isDark),
                            _buildHeaderCell('Expediente', isDark),
                            _buildHeaderCell('Estado', isDark),
                            _buildHeaderCell(
                              'Acciones',
                              isDark,
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Filas con scroll vertical interactivo
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
                            children: employees.map((emp) {
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
                                  // 0: Colaborador
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color(
                                            0xFF2563EB,
                                          ).withValues(alpha: 0.15),
                                          child: Text(
                                            emp.fullName.isNotEmpty
                                                ? emp.fullName.substring(0, 1)
                                                : '?',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                emp.fullName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                emp.code,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: const Color(
                                                    0xFF64748B,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 1: CI
                                  _buildBodyCell(
                                    Text(
                                      emp.identityCard,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                  // 2: Cargo & Tipo
                                  _buildBodyCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          emp.position,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        RrhhEmployeeTypeBadge(
                                          employeeType: emp.employeeType,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 3: Sucursal Asignada
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        Icon(
                                          emp.employeeType == 'OFICINA'
                                              ? Icons.apartment
                                              : Icons.storefront,
                                          size: 14,
                                          color: const Color(0xFF2563EB),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            emp.workplace,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 4: Sueldo
                                  _buildBodyCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF10B981),
                                          ),
                                        ),
                                        Text(
                                          emp.contractType,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 5: Expediente
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        Icon(
                                          emp.attachedDocumentsCount == 6
                                              ? Icons.verified
                                              : Icons.warning_amber_rounded,
                                          size: 14,
                                          color: emp.attachedDocumentsCount == 6
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${emp.attachedDocumentsCount}/6 docs',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                emp.attachedDocumentsCount == 6
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFF59E0B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 6: Estado
                                  _buildBodyCell(
                                    RrhhStatusChip(status: emp.status),
                                  ),
                                  // 7: Acciones
                                  _buildBodyCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.tonalIcon(
                                        style: FilledButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.folder_open,
                                          size: 14,
                                        ),
                                        label: const Text(
                                          'Expediente',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        onPressed: () =>
                                            _openEmployeeModal(emp),
                                      ),
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

  Widget _buildApplicantsTableTab(
    List<RrhhApplicant> applicants,
    bool isDark,
    double maxWidth,
    bool isMobile,
  ) {
    if (applicants.isEmpty) {
      return RrhhEmptyState(
        title: 'No se encontraron postulantes',
        message:
            'No existen candidatos registrados con los criterios seleccionados.',
        isDark: isDark,
      );
    }

    final tableWidth = max(maxWidth - 48, 980.0);
    const columnWidths = {
      0: FlexColumnWidth(2.6), // Postulante
      1: FixedColumnWidth(120), // CI
      2: FlexColumnWidth(2.5), // Cargo & Especialidad
      3: FixedColumnWidth(125), // Pretensión
      4: FixedColumnWidth(130), // Fecha Postulación
      5: FixedColumnWidth(120), // Estado
      6: FixedColumnWidth(140), // Acciones
    };

    return Container(
      width: double.infinity,
      height: double.infinity,
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
                            _buildHeaderCell('Postulante', isDark),
                            _buildHeaderCell('CI / Teléfono', isDark),
                            _buildHeaderCell('Puesto & Especialidad', isDark),
                            _buildHeaderCell('Pretensión', isDark),
                            _buildHeaderCell('Fecha', isDark),
                            _buildHeaderCell('Etapa', isDark),
                            _buildHeaderCell(
                              'Acciones',
                              isDark,
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Filas con scroll vertical interactivo
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
                            children: applicants.map((app) {
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
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: const Color(
                                            0xFF10B981,
                                          ).withValues(alpha: 0.15),
                                          child: Text(
                                            app.fullName.isNotEmpty
                                                ? app.fullName.substring(0, 1)
                                                : '?',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF10B981),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                app.fullName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                app.code,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: const Color(
                                                    0xFF64748B,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.identityCard,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? const Color(0xFFCBD5E1)
                                                : const Color(0xFF334155),
                                          ),
                                        ),
                                        Text(
                                          app.phone,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.targetPosition,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        Text(
                                          app.specialty,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      app.expectedSalary != null
                                          ? 'Bs. ${app.expectedSalary!.toStringAsFixed(2)}'
                                          : 'A convenir',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF10B981),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      '${app.applicationDate.day}/${app.applicationDate.month}/${app.applicationDate.year}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    RrhhStatusChip(status: app.status),
                                  ),
                                  _buildBodyCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_red_eye,
                                              size: 16,
                                            ),
                                            tooltip: 'Ver detalle',
                                            onPressed: () =>
                                                _openApplicantModal(app),
                                          ),
                                          if (app.status == 'SELECCIONADO' ||
                                              app.status == 'EN_EVALUACION')
                                            IconButton(
                                              icon: const Icon(
                                                Icons.how_to_reg,
                                                size: 16,
                                                color: Color(0xFF10B981),
                                              ),
                                              tooltip: 'Contratar',
                                              onPressed: () => _openHireDialog(
                                                applicant: app,
                                              ),
                                            ),
                                        ],
                                      ),
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

  Widget _buildEmployeeMobileCard(RrhhEmployee emp, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(
                  0xFF2563EB,
                ).withValues(alpha: 0.15),
                child: Text(
                  emp.fullName.isNotEmpty ? emp.fullName[0] : '?',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emp.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              RrhhStatusChip(status: emp.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${emp.code} • ${emp.position}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sede: ${emp.workplace} • Sueldo: Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: () => _openEmployeeModal(emp),
              child: const Text('Expediente', style: TextStyle(fontSize: 11)),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _buildBodyCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: child,
    );
  }
}
