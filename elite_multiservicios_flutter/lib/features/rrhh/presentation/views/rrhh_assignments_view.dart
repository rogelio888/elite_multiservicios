import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_assignment.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/models/rrhh_schedule.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista de Asignaciones, Clientes con Multi-Servicio y Horarios/Turnos.
/// Rediseñada con estética ejecutiva limpia, Data Table de alta densidad y barra unificada (Estilo Directorio).
class RrhhAssignmentsView extends StatefulWidget {
  const RrhhAssignmentsView({super.key});

  @override
  State<RrhhAssignmentsView> createState() => _RrhhAssignmentsViewState();
}

class _RrhhAssignmentsViewState extends State<RrhhAssignmentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _assignmentsScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  String _searchQuery = '';
  String _filterType = 'TODOS'; // TODOS, OFICINA, CAMPO
  String _selectedCompany = 'TODAS';
  bool _isTableView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _assignmentsScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _stateService,
      builder: (context, _) {
        // 1. Calcular sedes y empresas disponibles para el selector adaptativo
        final allCompanies = <String>{'TODAS', 'Oficina Central Elite'};
        for (final a in _stateService.assignments) {
          if (a.clientCompanyName != null && a.clientCompanyName!.trim().isNotEmpty) {
            allCompanies.add(a.clientCompanyName!.trim());
          }
        }
        for (final c in _stateService.clientCompanies) {
          if (c.name.trim().isNotEmpty) {
            allCompanies.add(c.name.trim());
          }
        }
        final availableCompanies = allCompanies.toList()..sort((a, b) {
          if (a == 'TODAS') return -1;
          if (b == 'TODAS') return 1;
          return a.compareTo(b);
        });

        // 2. Filtrar Asignaciones
        final assignments = _stateService.assignments.where((a) {
          if (a.status != 'ACTIVA') return false;
          if (_filterType != 'TODOS' && a.type != _filterType) return false;
          if (_selectedCompany != 'TODAS') {
            if (_selectedCompany == 'Oficina Central Elite') {
              if (a.type != 'OFICINA') return false;
            } else {
              if ((a.clientCompanyName ?? '').trim().toLowerCase() !=
                  _selectedCompany.trim().toLowerCase()) {
                return false;
              }
            }
          }
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return a.employeeName.toLowerCase().contains(q) ||
              a.employeeCode.toLowerCase().contains(q) ||
              (a.clientCompanyName?.toLowerCase().contains(q) ?? false) ||
              (a.contractedServiceName?.toLowerCase().contains(q) ?? false) ||
              (a.officeArea?.toLowerCase().contains(q) ?? false) ||
              (a.officeRole?.toLowerCase().contains(q) ?? false) ||
              (a.workplaceBranch?.toLowerCase().contains(q) ?? false) ||
              a.supervisorName.toLowerCase().contains(q) ||
              a.scheduleName.toLowerCase().contains(q) ||
              (a.originDescription?.toLowerCase().contains(q) ?? false);
        }).toList();

        // 3. Filtrar Clientes
        final clients = _stateService.clientCompanies.where((c) {
          if (_selectedCompany != 'TODAS') {
            if (c.name.trim().toLowerCase() != _selectedCompany.trim().toLowerCase()) {
              return false;
            }
          }
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return c.name.toLowerCase().contains(q) ||
              c.industry.toLowerCase().contains(q) ||
              c.branches.any((b) => b.toLowerCase().contains(q)) ||
              c.services.any((s) => s.serviceName.toLowerCase().contains(q));
        }).toList();

        // 4. Filtrar Horarios
        final schedules = _stateService.schedules.where((s) {
          if (_filterType == 'OFICINA' && s.appliesTo == 'CAMPO') return false;
          if (_filterType == 'CAMPO' && s.appliesTo == 'OFICINA') return false;
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return s.name.toLowerCase().contains(q) ||
              s.appliesTo.toLowerCase().contains(q) ||
              s.daysOfWeek.any((d) => d.toLowerCase().contains(q));
        }).toList();

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 16 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Cabecera Ejecutiva Limpia
                    _buildHeader(isDark, isMobile),
                    const SizedBox(height: 16),

                    // 2. Barra de Filtro Unificada y Prolija (Estilo Imagen 2)
                    _buildUnifiedFilterBar(isDark, availableCompanies, isMobile),
                    const SizedBox(height: 14),

                    // 3. Pestañas: Asignaciones de Personal | Clientes & Servicios | Horarios & Turnos
                    _buildTabsBar(
                      isDark,
                      assignments.length,
                      clients.length,
                      schedules.length,
                    ),
                    const SizedBox(height: 14),

                    // 4. TabBarView con Tablas Ejecutivas y Contenido Prolijo
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAssignmentsTab(
                            assignments,
                            isDark,
                            constraints.maxWidth,
                            isMobile,
                          ),
                          _buildClientsList(clients, isDark),
                          _buildSchedulesList(schedules, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --- 1. CABECERA EJECUTIVA ---
  Widget _buildHeader(bool isDark, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asignaciones & Horarios',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Destinos Oficina vs Campo (Clientes y Servicios contratados) y Gestión de Turnos.',
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
        const SizedBox(width: 14),
        FilledButton.icon(
          icon: const Icon(Icons.add, size: 16),
          label: Text(
            _tabController.index == 0
                ? 'Nueva Asignación'
                : (_tabController.index == 1
                    ? 'Nuevo Cliente / Servicio'
                    : 'Nuevo Horario'),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => _openCreationDialog(context),
        ),
      ],
    );
  }

  // --- 2. BARRA DE FILTRO UNIFICADA Y PROLIJA (ESTILO IMAGEN 2) ---
  Widget _buildUnifiedFilterBar(
    bool isDark,
    List<String> availableCompanies,
    bool isMobile,
  ) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final searchField = Container(
      height: 38,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
        style: GoogleFonts.inter(
          fontSize: 13,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por colaborador, código, sede o servicio...',
          hintStyle: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 16,
            color: Color(0xFF64748B),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 14),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );

    final companySelector = _buildAdaptiveCompanySelector(
      isDark,
      availableCompanies,
    );

    final typeFilterGroup = _buildFilterGroup<String>(
      options: const [
        (value: 'TODOS', label: 'Todos'),
        (value: 'OFICINA', label: 'Oficina'),
        (value: 'CAMPO', label: 'Campo'),
      ],
      selectedValue: _filterType,
      onSelected: (val) => setState(() => _filterType = val),
      isDark: isDark,
    );

    final viewModeToggle = Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.table_rows_outlined,
              size: 16,
              color: _isTableView
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : const Color(0xFF64748B),
            ),
            tooltip: 'Vista Tabla (Ejecutiva)',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            style: IconButton.styleFrom(
              backgroundColor: _isTableView
                  ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () => setState(() => _isTableView = true),
          ),
          const SizedBox(width: 2),
          IconButton(
            icon: Icon(
              Icons.grid_view_outlined,
              size: 16,
              color: !_isTableView
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : const Color(0xFF64748B),
            ),
            tooltip: 'Vista Tarjetas',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            style: IconButton.styleFrom(
              backgroundColor: !_isTableView
                  ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () => setState(() => _isTableView = false),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 950;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        companySelector,
                        typeFilterGroup,
                        if (!isMobile) viewModeToggle,
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 10),
                    companySelector,
                    const SizedBox(width: 10),
                    typeFilterGroup,
                    const SizedBox(width: 10),
                    viewModeToggle,
                  ],
                ),
        );
      },
    );
  }

  // --- SELECTOR ADAPTATIVO DE EMPRESAS/SEDES (REGLA 7 vs 8+) ---
  Widget _buildAdaptiveCompanySelector(
    bool isDark,
    List<String> companies,
  ) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    final bool enableSearch = companies.length >= 8;

    if (!enableSearch) {
      // Hasta 7 registros: Dropdown estándar limpio
      return Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.business_outlined,
              size: 15,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCompany,
                dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                items: companies.map((comp) {
                  final isAll = comp == 'TODAS';
                  final count = isAll
                      ? _stateService.assignments.where((a) => a.status == 'ACTIVA').length
                      : (comp == 'Oficina Central Elite'
                          ? _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.type == 'OFICINA').length
                          : _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.clientCompanyName?.trim().toLowerCase() == comp.trim().toLowerCase()).length);

                  return DropdownMenuItem<String>(
                    value: comp,
                    child: Text(
                      isAll ? 'Todas las Empresas ($count)' : '$comp ($count)',
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCompany = val);
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    // 8 o más registros: Modal de búsqueda interactivo
    final selectedCount = _selectedCompany == 'TODAS'
        ? _stateService.assignments.where((a) => a.status == 'ACTIVA').length
        : (_selectedCompany == 'Oficina Central Elite'
            ? _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.type == 'OFICINA').length
            : _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.clientCompanyName?.trim().toLowerCase() == _selectedCompany.trim().toLowerCase()).length);

    return InkWell(
      onTap: () => _openCompanySearchModal(context, isDark, companies),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.business_outlined,
              size: 15,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190),
              child: Text(
                _selectedCompany == 'TODAS'
                    ? 'Todas las Empresas ($selectedCount)'
                    : '$_selectedCompany ($selectedCount)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Buscar',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  // Modal interactivo de búsqueda de empresas/sedes
  void _openCompanySearchModal(
    BuildContext context,
    bool isDark,
    List<String> companies,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        String filter = '';
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final filtered = companies.where((c) {
              if (filter.isEmpty) return true;
              return c.toLowerCase().contains(filter.toLowerCase());
            }).toList();

            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtrar por Empresa / Sede',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      onChanged: (v) => setDialogState(() => filter = v.trim()),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Escribe el nombre de la empresa o sede...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                          color: Color(0xFF6366F1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF0B1120)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${filtered.length} sedes/empresas encontradas:',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (sepCtx, i) => Divider(
                          height: 1,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                        ),
                        itemBuilder: (itemCtx, i) {
                          final comp = filtered[i];
                          final isSelected = comp == _selectedCompany;
                          final isAll = comp == 'TODAS';
                          final count = isAll
                              ? _stateService.assignments.where((a) => a.status == 'ACTIVA').length
                              : (comp == 'Oficina Central Elite'
                                  ? _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.type == 'OFICINA').length
                                  : _stateService.assignments.where((a) => a.status == 'ACTIVA' && a.clientCompanyName?.trim().toLowerCase() == comp.trim().toLowerCase()).length);

                          return InkWell(
                            onTap: () {
                              setState(() => _selectedCompany = comp);
                              Navigator.of(ctx).pop();
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isAll
                                        ? Icons.corporate_fare_outlined
                                        : Icons.business,
                                    size: 16,
                                    color: isSelected
                                        ? const Color(0xFF6366F1)
                                        : (isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF64748B)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isAll ? 'Todas las Empresas' : comp,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? const Color(0xFF6366F1)
                                            : (isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Segmented Buttons estilo pastilla compacta (Idéntico a Imagen 2)
  Widget _buildFilterGroup<T>({
    required List<({T value, String label})> options,
    required T selectedValue,
    required ValueChanged<T> onSelected,
    required bool isDark,
  }) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt.value == selectedValue;
          return GestureDetector(
            onTap: () => onSelected(opt.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                opt.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 3. BARRA DE PESTAÑAS (TABBAR) ---
  Widget _buildTabsBar(
    bool isDark,
    int assignmentsCount,
    int clientsCount,
    int schedulesCount,
  ) {
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: 'Asignaciones de Personal ($assignmentsCount)'),
          Tab(text: 'Clientes & Servicios ($clientsCount)'),
          Tab(text: 'Horarios & Turnos ($schedulesCount)'),
        ],
      ),
    );
  }

  // --- 4. CONTENIDO TAB ASIGNACIONES ---
  Widget _buildAssignmentsTab(
    List<RrhhAssignment> assignments,
    bool isDark,
    double maxWidth,
    bool isMobile,
  ) {
    if (assignments.isEmpty) {
      return RrhhEmptyState(
        title: 'No hay asignaciones registradas',
        message:
            'No se encontraron asignaciones que coincidan con los filtros o criterios de búsqueda seleccionados.',
        icon: Icons.assignment_late_outlined,
        isDark: isDark,
      );
    }

    if (isMobile) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 6, bottom: 20),
        itemCount: assignments.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) => _buildAssignmentMobileCard(assignments[i], isDark),
      );
    }

    if (!_isTableView) {
      return _buildAssignmentsCardsGrid(assignments, isDark);
    }

    return _buildAssignmentsTable(assignments, isDark, maxWidth);
  }

  // --- TABLA EJECUTIVA DE ASIGNACIONES (UNIFORME - ESTILO IMAGEN 2) ---
  Widget _buildAssignmentsTable(
    List<RrhhAssignment> assignments,
    bool isDark,
    double maxWidth,
  ) {
    final tableWidth = max(maxWidth - 48, 1150.0);
    const columnWidths = {
      0: FlexColumnWidth(2.6), // Colaborador
      1: FlexColumnWidth(2.4), // Cargo & Modalidad
      2: FlexColumnWidth(2.4), // Destino / Sede
      3: FlexColumnWidth(2.1), // Horario / Turno
      4: FlexColumnWidth(1.9), // Supervisor
      5: FixedColumnWidth(135), // Rotación
      6: FixedColumnWidth(95), // Estado
      7: FixedColumnWidth(155), // Acciones
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
            return Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  height: boxConstraints.maxHeight,
                  child: Column(
                    children: [
                      // Cabecera Fija Unificada
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
                              _buildHeaderCell('Cargo / Función', isDark),
                              _buildHeaderCell('Destino / Sede', isDark),
                              _buildHeaderCell('Horario / Turno', isDark),
                              _buildHeaderCell('Supervisor', isDark),
                              _buildHeaderCell(
                                'Rotación',
                                isDark,
                                alignment: Alignment.center,
                              ),
                              _buildHeaderCell(
                                'Estado',
                                isDark,
                                alignment: Alignment.center,
                              ),
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
                          controller: _assignmentsScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _assignmentsScrollController,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Table(
                            columnWidths: columnWidths,
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: assignments.map((a) {
                              final isOficina = a.type == 'OFICINA';
                              final historyCount = _stateService
                                  .getRotationHistory(a.employeeId)
                                  .length;

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
                                          backgroundColor: isOficina
                                              ? const Color(0xFF8B5CF6)
                                                  .withValues(alpha: 0.15)
                                              : const Color(0xFF10B981)
                                                  .withValues(alpha: 0.15),
                                          child: Text(
                                            a.employeeName.isNotEmpty
                                                ? a.employeeName.substring(0, 1)
                                                : '?',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: isOficina
                                                  ? const Color(0xFF8B5CF6)
                                                  : const Color(0xFF10B981),
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
                                                a.employeeName,
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
                                                a.employeeCode,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 10,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 1: Cargo / Función & Modalidad (Vertical Unificado)
                                  _buildBodyCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isOficina
                                              ? (a.officeRole ?? 'Operativo')
                                              : (a.contractedServiceName ??
                                                  'Servicio General'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.5,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        RrhhEmployeeTypeBadge(type: a.type),
                                      ],
                                    ),
                                  ),

                                  // 2: Destino / Sede
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        Icon(
                                          isOficina
                                              ? Icons.apartment
                                              : Icons.location_city_outlined,
                                          size: 14,
                                          color: isOficina
                                              ? const Color(0xFF8B5CF6)
                                              : const Color(0xFF06B6D4),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isOficina
                                                    ? 'Oficina Central Elite'
                                                    : (a.clientCompanyName ??
                                                        'Empresa Cliente'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11.5,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                isOficina
                                                    ? 'Área: ${a.officeArea ?? "General"}'
                                                    : 'Sede: ${a.workplaceBranch ?? "Principal"}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 3: Horario / Turno
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 13,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                a.scheduleName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11.5,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                isOficina
                                                    ? '08:30 - 18:30 • Lun-Vie'
                                                    : 'Turno Operativo',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 4: Supervisor
                                  _buildBodyCell(
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.supervisor_account,
                                          size: 13,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            a.supervisorName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 5: Rotación
                                  _buildBodyCell(
                                    Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: a.rotationNumber > 0
                                            ? Tooltip(
                                                message:
                                                    'Rotó desde: ${a.originDescription ?? "Anterior"}${a.rotationReason != null && a.rotationReason!.isNotEmpty ? "\nMotivo: ${a.rotationReason}" : ""}',
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF59E0B)
                                                        .withValues(alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(6),
                                                    border: Border.all(
                                                      color: const Color(0xFFF59E0B)
                                                          .withValues(alpha: 0.35),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.sync_alt,
                                                        size: 11,
                                                        color: Color(0xFFF59E0B),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Rotación #${a.rotationNumber}',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 10.5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                            0xFFF59E0B,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF64748B)
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: const Color(0xFF64748B)
                                                        .withValues(alpha: 0.35),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.flag_outlined,
                                                      size: 11,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Puesto Inicial',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                  ),

                                  // 6: Estado
                                  _buildBodyCell(
                                    Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: RrhhStatusChip(
                                          label: a.status,
                                          statusType: a.status == 'ACTIVA'
                                              ? StatusType.success
                                              : StatusType.neutral,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                  ),

                                  // 7: Acciones
                                  _buildBodyCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            tooltip: historyCount > 1
                                                ? 'Historial ($historyCount)'
                                                : 'Historial',
                                            icon: Badge(
                                              isLabelVisible: historyCount > 1,
                                              label: Text(
                                                '$historyCount',
                                                style: const TextStyle(
                                                    fontSize: 9),
                                              ),
                                              child: const Icon(
                                                Icons.history,
                                                size: 15,
                                                color: Color(0xFF3B82F6),
                                              ),
                                            ),
                                            onPressed: () =>
                                                _openRotationHistoryDialog(
                                              context,
                                              a,
                                            ),
                                            style: IconButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: const EdgeInsets.all(6),
                                              backgroundColor:
                                                  const Color(0xFF3B82F6)
                                                      .withValues(alpha: 0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          FilledButton.tonalIcon(
                                            onPressed: () =>
                                                _openReassignDialog(context, a),
                                            icon: const Icon(
                                              Icons.swap_horiz,
                                              size: 14,
                                            ),
                                            label: const Text(
                                              'Rotar',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: FilledButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              backgroundColor: const Color(
                                                0xFF6366F1,
                                              ).withValues(alpha: 0.14),
                                              foregroundColor: const Color(
                                                0xFF6366F1,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 7,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 8,
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
            ),
          );
        },
      ),
    ),
  );
  }

  // --- TARJETAS MÓVILES (RESPONSIVE) ---
  Widget _buildAssignmentMobileCard(RrhhAssignment a, bool isDark) {
    final isOficina = a.type == 'OFICINA';
    final historyCount = _stateService.getRotationHistory(a.employeeId).length;

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
                radius: 16,
                backgroundColor: isOficina
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                    : const Color(0xFF10B981).withValues(alpha: 0.15),
                child: Text(
                  a.employeeName.isNotEmpty ? a.employeeName[0] : '?',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isOficina
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      a.employeeCode,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              RrhhEmployeeTypeBadge(type: a.type),
              const SizedBox(width: 6),
              RrhhStatusChip(
                label: a.status,
                statusType: a.status == 'ACTIVA'
                    ? StatusType.success
                    : StatusType.neutral,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1324) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isOficina ? Icons.apartment : Icons.location_city_outlined,
                  size: 15,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isOficina
                        ? 'Oficina Central Elite • Área: ${a.officeArea ?? "General"} • Cargo: ${a.officeRole ?? "Operativo"}'
                        : 'Empresa: ${a.clientCompanyName ?? "N/A"} • Servicio: ${a.contractedServiceName ?? "General"} • Sede: ${a.workplaceBranch ?? "Principal"}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (a.originDescription != null && a.rotationNumber > 0) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.alt_route, size: 13, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Rotó desde: ${a.originDescription!}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.schedule, size: 13, color: const Color(0xFF64748B)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  a.scheduleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openRotationHistoryDialog(context, a),
                icon: const Icon(Icons.history, size: 13, color: Color(0xFF3B82F6)),
                label: Text(
                  historyCount > 1 ? 'Historial ($historyCount)' : 'Historial',
                  style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                onPressed: () => _openReassignDialog(context, a),
                icon: const Icon(Icons.swap_horiz, size: 13),
                label: const Text('Rotar Destino', style: TextStyle(fontSize: 11)),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.14),
                  foregroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TARJETAS EN VISTA GRID/CARD ALTERNATIVA ---
  Widget _buildAssignmentsCardsGrid(
    List<RrhhAssignment> assignments,
    bool isDark,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 6, bottom: 20),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAssignmentMobileCard(assignments[index], isDark),
        );
      },
    );
  }

  // --- CELDAS PARA TABLA EJECUTIVA ---
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

  Widget _buildBodyCell(Widget child, {EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: child,
    );
  }

  Widget _buildClientsList(List<RrhhClientCompany> clients, bool isDark) {
    if (clients.isEmpty) {
      return RrhhEmptyState(
        title: 'No hay empresas cliente registradas',
        message: 'No se encontraron empresas con servicios contratados.',
        icon: Icons.corporate_fare_outlined,
        isDark: isDark,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 6, bottom: 20),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.business_center,
                          color: Color(0xFF3B82F6),
                          size: 22,
                        ),
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
                                client.name,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 10),
                              RrhhStatusChip(
                                label: client.industry,
                                statusType: StatusType.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sedes activas: ${client.branches.join(", ")}  •  Contacto: ${client.contactPerson}',
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
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  'Servicios Contratados por el Cliente:',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: client.services.map((svc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0B1324)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            svc.category == 'SEGURIDAD'
                                ? Icons.security
                                : (svc.category == 'LIMPIEZA'
                                      ? Icons.cleaning_services
                                      : Icons.build_outlined),
                            size: 16,
                            color: const Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                svc.serviceName,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'Personal asignado: ${svc.assignedEmployeesCount} personas',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF10B981),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSchedulesList(List<RrhhWorkSchedule> schedules, bool isDark) {
    if (schedules.isEmpty) {
      return RrhhEmptyState(
        title: 'No hay horarios configurados',
        message: 'No se encontraron horarios que coincidan con los criterios de búsqueda.',
        icon: Icons.schedule_outlined,
        isDark: isDark,
      );
    }

    return Column(
      children: [
        // Banner aclaratorio de delimitación con la APK de asistencia
        Container(
          margin: const EdgeInsets.only(top: 6, bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF2563EB).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF2563EB),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delimitación funcional: La definición de turnos, jornadas y tolerancias corresponde a RRHH. '
                  'Las marcaciones de entrada, salida y verificación biométrica se ejecutan de manera autónoma en la APK móvil de Asistencia.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark
                        ? const Color(0xFF93C5FD)
                        : const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final s = schedules[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: s.isNightShift
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          s.isNightShift
                              ? Icons.nightlight_round
                              : Icons.wb_sunny,
                          color: s.isNightShift
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFFF59E0B),
                          size: 22,
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
                                  s.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RrhhStatusChip(
                                  label: 'Aplica: ${s.appliesTo}',
                                  statusType: StatusType.info,
                                ),
                                if (s.isNightShift) ...[
                                  const SizedBox(width: 6),
                                  const RrhhStatusChip(
                                    label: 'Nocturno',
                                    statusType: StatusType.warning,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Horario: ${s.formattedStartTime} a ${s.formattedEndTime}  •  Tolerancia de atraso: ${s.gracePeriodMinutes} minutos  •  Días: ${s.daysOfWeek.join(", ")}',
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openRotationHistoryDialog(BuildContext context, RrhhAssignment a) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final history = _stateService.getRotationHistory(a.employeeId);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 680,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.history_toggle_off,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Historial de Rotaciones & Asignaciones',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Colaborador: ${a.employeeName} (${a.employeeCode}) • ${a.type}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barra de Resumen
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B1324)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.alt_route,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Total de Destinos / Puntos: ${history.length}',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    if (history.isNotEmpty)
                      Text(
                        'Puesto Inicial: ${history.first.startDate.day}/${history.first.startDate.month}/${history.first.startDate.year}',
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
              const SizedBox(height: 16),

              // Línea de Tiempo Vertical
              Expanded(
                child: history.isEmpty
                    ? const Center(
                        child: Text(
                          'Sin historial de rotaciones registrado',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(right: 14),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          final isFirst = index == 0;
                          final isLast = index == history.length - 1;
                          final isActive = item.status == 'ACTIVA';

                          final startStr =
                              '${item.startDate.day}/${item.startDate.month}/${item.startDate.year}';
                          final endStr = item.endDate != null
                              ? '${item.endDate!.day}/${item.endDate!.month}/${item.endDate!.year}'
                              : 'Actualidad (Vigente)';

                          final days = (item.endDate ?? DateTime.now())
                              .difference(item.startDate)
                              .inDays;
                          final durationStr = days >= 30
                              ? '${(days / 30).floor()} meses y ${days % 30} días'
                              : '$days días';

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Línea vertical y nodo
                                SizedBox(
                                  width: 40,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? const Color(0xFF10B981)
                                              : (isFirst
                                                    ? const Color(0xFF2563EB)
                                                    : const Color(0xFFF59E0B)),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isActive
                                                ? Icons.check
                                                : (isFirst
                                                      ? Icons.flag
                                                      : Icons.sync_alt),
                                            size: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      if (!isLast)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: isDark
                                                ? const Color(0xFF1E293B)
                                                : const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Tarjeta informativa del hito
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF0B1324)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isActive
                                            ? const Color(
                                                0xFF10B981,
                                              ).withValues(alpha: 0.5)
                                            : (isDark
                                                  ? const Color(0xFF1E293B)
                                                  : const Color(0xFFE2E8F0)),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              isFirst
                                                  ? '🌱 PUESTO INICIAL'
                                                  : '🔄 ROTACIÓN #${item.rotationNumber}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: isFirst
                                                    ? const Color(0xFF2563EB)
                                                    : (isActive
                                                          ? const Color(
                                                              0xFF10B981,
                                                            )
                                                          : const Color(
                                                              0xFFF59E0B,
                                                            )),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            RrhhStatusChip(
                                              label: item.status,
                                              statusType: isActive
                                                  ? StatusType.success
                                                  : StatusType.neutral,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '$startStr → $endStr',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item.fullDestinationSummary,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Horario: ${item.scheduleName}  •  Supervisor: ${item.supervisorName}  •  Permanencia: $durationStr',
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                        if (item.originDescription != null &&
                                            !isFirst) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            'Punto de partida previo: ${item.originDescription}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF3B82F6),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                        if (item.rotationReason != null &&
                                            item
                                                .rotationReason!
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? const Color(0xFF1E293B)
                                                  : const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Motivo: ${item.rotationReason}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontStyle: FontStyle.italic,
                                                color: isDark
                                                    ? const Color(0xFFCBD5E1)
                                                    : const Color(0xFF475569),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonal(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openReassignDialog(BuildContext context, RrhhAssignment a) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Horarios disponibles
    final availableScheduleNames = <String>{};
    for (final s in _stateService.schedules) {
      availableScheduleNames.add('${s.name} (${s.formattedTimeRange})');
    }
    String currentSchedule = availableScheduleNames.isNotEmpty
        ? availableScheduleNames.first
        : 'Administrativo Central (08:30 - 17:30)';
    for (final name in availableScheduleNames) {
      if (name.contains(a.scheduleName) || a.scheduleName.contains(name)) {
        currentSchedule = name;
        break;
      }
    }

    // Tipo de destino (OFICINA o CAMPO)
    String selectedType = a.type;

    // Si es campo: selección de cliente y servicio/sede
    final clients = _stateService.clientCompanies;
    RrhhClientCompany? selectedClient = clients.isNotEmpty
        ? clients.first
        : null;
    if (a.clientCompanyId != null) {
      final match = clients.where(
        (c) => c.id == a.clientCompanyId || c.name == a.clientCompanyName,
      );
      if (match.isNotEmpty) selectedClient = match.first;
    }

    RrhhClientContractedService? selectedService;
    if (selectedClient != null && selectedClient.services.isNotEmpty) {
      selectedService = selectedClient.services.first;
      if (a.contractedServiceName != null) {
        final matchSvc = selectedClient.services.where(
          (s) => s.serviceName == a.contractedServiceName,
        );
        if (matchSvc.isNotEmpty) selectedService = matchSvc.first;
      }
    }

    // Si es oficina: selección de área y cargo
    final areas = _stateService.areas;
    String selectedArea = areas.isNotEmpty ? areas.first.name : 'Operaciones';
    if (a.officeArea != null && areas.any((ar) => ar.name == a.officeArea)) {
      selectedArea = a.officeArea!;
    }
    final positionCtrl = TextEditingController(
      text: a.officeRole ?? 'Operativo',
    );

    final supervisorCtrl = TextEditingController(text: a.supervisorName);
    final reasonCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    const quickReasons = [
      'Rotación periódica por política preventiva',
      'Cobertura temporal por baja o vacaciones',
      'Refuerzo operativo por alta demanda',
      'Solicitud formal del cliente',
      'Reorganización de cuadrilla de campo',
      'Ascenso o traslado de área',
    ];
    String selectedQuickReason = quickReasons.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rotar Personal a Nuevo Destino',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${a.employeeName} (${a.employeeCode})',
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
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 10, 16),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 530,
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.78,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 14, top: 4, bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuadro destacado de Destino Actual (Desde dónde rota)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1324)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              size: 14,
                              color: Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'PUNTO DE ORIGEN ACTUAL (Desde dónde rota):',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a.fullDestinationSummary,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Horario: ${a.scheduleName}  •  Supervisor: ${a.supervisorName}',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selector de Tipo de Destino (Campo u Oficina)
                  Text(
                    'Nuevo Destino',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'CAMPO',
                        label: Text('Empresa Cliente (Campo)'),
                        icon: Icon(Icons.location_city, size: 16),
                      ),
                      ButtonSegment(
                        value: 'OFICINA',
                        label: Text('Oficina Central'),
                        icon: Icon(Icons.business, size: 16),
                      ),
                    ],
                    selected: {selectedType},
                    onSelectionChanged: (val) {
                      setDlgState(() {
                        selectedType = val.first;
                        if (selectedType == 'OFICINA') {
                          supervisorCtrl.text = 'Gerencia General';
                        } else if (selectedService != null) {
                          supervisorCtrl.text = 'Ricardo Montaño Justiniano';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  if (selectedType == 'CAMPO') ...[
                    // Selector adaptativo (<=7 normal, >=8 con búsqueda Google)
                    RrhhAdaptiveSelector<RrhhClientCompany>(
                      label: 'Empresa Cliente Destino *',
                      hintText: 'Buscar o escribir empresa...',
                      initialValue: selectedClient,
                      items: clients,
                      itemLabel: (c) => c.name,
                      itemSubtitle: (c) =>
                          '${c.services.length} servicio(s) contratado(s)',
                      itemIcon: Icons.business,
                      prefixIcon: Icons.location_city,
                      onChanged: (c) {
                        setDlgState(() {
                          selectedClient = c;
                          if (c != null && c.services.isNotEmpty) {
                            selectedService = c.services.first;
                          } else {
                            selectedService = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (selectedClient != null &&
                        selectedClient!.services.isNotEmpty)
                      DropdownButtonFormField<RrhhClientContractedService>(
                        key: ValueKey('service_${selectedClient?.id}'),
                        initialValue:
                            selectedClient!.services.contains(
                              selectedService,
                            )
                            ? selectedService
                            : selectedClient!.services.first,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Servicio Contratado y Sede *',
                          prefixIcon: Icon(
                            Icons.room_service_outlined,
                            size: 18,
                          ),
                        ),
                        items: selectedClient!.services
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  '${s.serviceName} (${s.branchLocation})',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (s) {
                          setDlgState(() => selectedService = s);
                        },
                      ),
                  ] else ...[
                    // Dropdown simple y compacto de Área en Oficina Central
                    DropdownButtonFormField<String>(
                      initialValue: areas.any((ar) => ar.name == selectedArea)
                          ? selectedArea
                          : (areas.isNotEmpty
                                ? areas.first.name
                                : 'Operaciones'),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Área en Oficina Central *',
                        prefixIcon: Icon(Icons.corporate_fare, size: 18),
                      ),
                      items: areas
                          .map(
                            (ar) => DropdownMenuItem(
                              value: ar.name,
                              child: Text(
                                ar.name,
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDlgState(() => selectedArea = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: positionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Cargo o Rol *',
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Horario / Turno: Dropdown nativo y compacto sin sobrecargar
                  DropdownButtonFormField<String>(
                    initialValue:
                        availableScheduleNames.contains(
                          currentSchedule,
                        )
                        ? currentSchedule
                        : availableScheduleNames.first,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Horario / Turno Asignado *',
                      prefixIcon: Icon(Icons.access_time, size: 18),
                    ),
                    items: availableScheduleNames
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDlgState(() => currentSchedule = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Supervisor Asignado
                  TextField(
                    controller: supervisorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Supervisor Inmediato *',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Motivo de la Rotación
                  Text(
                    'Motivo de la Rotación',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Causal de Rotación: Dropdown simple directo con las 6 opciones fijas
                  DropdownButtonFormField<String>(
                    initialValue: quickReasons.contains(selectedQuickReason)
                        ? selectedQuickReason
                        : quickReasons.first,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Causal de Rotación *',
                      prefixIcon: Icon(Icons.info_outline, size: 18),
                    ),
                    items: quickReasons
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDlgState(() => selectedQuickReason = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Detalle o Justificación Adicional (opcional)',
                      hintText:
                          'Ej: Reemplazo por baja médica de 3 semanas en sede Equipetrol...',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Confirmar Rotación y Guardar'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final fullReason = reasonCtrl.text.trim().isNotEmpty
                    ? '$selectedQuickReason: ${reasonCtrl.text.trim()}'
                    : selectedQuickReason;

                _stateService.rotateEmployee(
                  employeeId: a.employeeId,
                  employeeName: a.employeeName,
                  employeeCode: a.employeeCode,
                  type: selectedType,
                  clientCompanyId: selectedType == 'CAMPO'
                      ? selectedClient?.id
                      : null,
                  clientCompanyName: selectedType == 'CAMPO'
                      ? selectedClient?.name
                      : null,
                  contractedServiceId: selectedType == 'CAMPO'
                      ? selectedService?.id
                      : null,
                  contractedServiceName: selectedType == 'CAMPO'
                      ? selectedService?.serviceName
                      : null,
                  workplaceBranch: selectedType == 'CAMPO'
                      ? selectedService?.branchLocation
                      : 'Oficina Central',
                  officeArea: selectedType == 'OFICINA' ? selectedArea : null,
                  officeRole: selectedType == 'OFICINA'
                      ? positionCtrl.text.trim()
                      : null,
                  scheduleName: currentSchedule,
                  supervisorName: supervisorCtrl.text.trim(),
                  rotationReason: fullReason,
                  notes: notesCtrl.text.trim().isNotEmpty
                      ? notesCtrl.text.trim()
                      : null,
                );

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Rotación registrada para ${a.employeeName}. Se conservó el origen en el historial.',
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openCreationDialog(BuildContext context) {
    final currentTab = _tabController.index;
    if (currentTab == 0) {
      _openNewAssignmentDialog(context);
    } else if (currentTab == 1) {
      _openNewClientDialog(context);
    } else {
      _openNewScheduleDialog(context);
    }
  }

  void _openNewAssignmentDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employees = _stateService.employees
        .where((e) => e.status == 'ACTIVO')
        .toList();

    if (employees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No hay colaboradores activos disponibles para asignar.',
          ),
        ),
      );
      return;
    }

    RrhhEmployee selectedEmp = employees.first;

    // Horarios disponibles
    final availableScheduleNames = <String>{};
    for (final s in _stateService.schedules) {
      availableScheduleNames.add('${s.name} (${s.formattedTimeRange})');
    }
    String currentSchedule = availableScheduleNames.isNotEmpty
        ? availableScheduleNames.first
        : 'Administrativo Central (08:30 - 17:30)';

    // Tipo de destino (OFICINA o CAMPO)
    String selectedType = selectedEmp.employeeType == 'OFICINA'
        ? 'OFICINA'
        : 'CAMPO';

    // Clientes y Servicios
    final clients = _stateService.clientCompanies;
    RrhhClientCompany? selectedClient = clients.isNotEmpty
        ? clients.first
        : null;
    RrhhClientContractedService? selectedService =
        (selectedClient != null && selectedClient.services.isNotEmpty)
        ? selectedClient.services.first
        : null;

    // Áreas de oficina
    final areas = _stateService.areas;
    String selectedArea = areas.isNotEmpty ? areas.first.name : 'Operaciones';
    final positionCtrl = TextEditingController(text: selectedEmp.position);
    final supervisorCtrl = TextEditingController(
      text: selectedType == 'OFICINA'
          ? 'Gerencia General'
          : 'Ricardo Montaño Justiniano',
    );
    final reasonCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    const assignmentReasons = [
      'Asignación operativa de personal',
      'Rotación periódica por política preventiva',
      'Reorganización de cuadrilla de campo',
      'Refuerzo operativo por alta demanda',
      'Cobertura temporal por baja o vacaciones',
      'Solicitud formal del cliente',
      'Ascenso o traslado de área',
    ];
    String selectedReason = assignmentReasons.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) {
          // Asignación activa actual del colaborador si existe
          RrhhAssignment? activeAsg;
          for (final a in _stateService.assignments) {
            if (a.employeeId == selectedEmp.id && a.status == 'ACTIVA') {
              activeAsg = a;
              break;
            }
          }

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.assignment_ind,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva Asignación de Personal',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Asignar destino operativo en Empresa Cliente u Oficina Central',
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
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 10, 16),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 530,
                maxHeight: MediaQuery.sizeOf(ctx).height * 0.78,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 14, top: 4, bottom: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de Colaborador
                    // Selector adaptativo de Colaborador (13 colaboradores >= 8 -> Búsqueda tipo Google)
                    RrhhAdaptiveSelector<RrhhEmployee>(
                      label: 'Colaborador a Asignar *',
                      hintText:
                          'Buscar colaborador por nombre, código o cargo...',
                      initialValue: selectedEmp,
                      items: employees,
                      itemLabel: (emp) => '${emp.fullName} (${emp.code})',
                      itemSubtitle: (emp) => emp.position,
                      itemIcon: Icons.person,
                      prefixIcon: Icons.badge_outlined,
                      onChanged: (emp) {
                        if (emp != null) {
                          setDlgState(() {
                            selectedEmp = emp;
                            positionCtrl.text = emp.position;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Cuadro informativo de Ubicación / Asignación Actual
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0B1324)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                activeAsg != null
                                    ? Icons.pin_drop
                                    : Icons.info_outline,
                                size: 14,
                                color: const Color(0xFF3B82F6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                activeAsg != null
                                    ? 'ASIGNACIÓN ACTUAL:'
                                    : 'ESTADO ACTUAL:',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            activeAsg != null
                                ? activeAsg.fullDestinationSummary
                                : 'Puesto Inicial • ${selectedEmp.workplace}',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activeAsg != null
                                ? 'Horario: ${activeAsg.scheduleName}  •  Supervisor: ${activeAsg.supervisorName}'
                                : 'Cargo: ${selectedEmp.position}  •  Supervisor: ${selectedEmp.supervisor}',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector de Tipo de Destino (Campo u Oficina)
                    Text(
                      'Nuevo Destino a Asignar',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'CAMPO',
                          label: Text('Empresa Cliente (Campo)'),
                          icon: Icon(Icons.location_city, size: 16),
                        ),
                        ButtonSegment(
                          value: 'OFICINA',
                          label: Text('Oficina Central'),
                          icon: Icon(Icons.business, size: 16),
                        ),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (val) {
                        setDlgState(() {
                          selectedType = val.first;
                          if (selectedType == 'OFICINA') {
                            supervisorCtrl.text = 'Gerencia General';
                          } else if (selectedService != null) {
                            supervisorCtrl.text = 'Ricardo Montaño Justiniano';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    if (selectedType == 'CAMPO') ...[
                      // Selector adaptativo de Empresa Cliente (5 empresas <= 7 -> Selector normal; >= 8 -> Búsqueda tipo Google)
                      RrhhAdaptiveSelector<RrhhClientCompany>(
                        label: 'Empresa Cliente Destino *',
                        hintText: 'Buscar o escribir empresa...',
                        initialValue: selectedClient,
                        items: clients,
                        itemLabel: (c) => c.name,
                        itemSubtitle: (c) =>
                            '${c.services.length} servicio(s) contratado(s)',
                        itemIcon: Icons.business,
                        prefixIcon: Icons.location_city,
                        onChanged: (c) {
                          setDlgState(() {
                            selectedClient = c;
                            if (c != null && c.services.isNotEmpty) {
                              selectedService = c.services.first;
                            } else {
                              selectedService = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      if (selectedClient != null &&
                          selectedClient!.services.isNotEmpty)
                        DropdownButtonFormField<RrhhClientContractedService>(
                          key: ValueKey('service_${selectedClient?.id}'),
                          initialValue:
                              selectedClient!.services.contains(
                                selectedService,
                              )
                              ? selectedService
                              : selectedClient!.services.first,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Servicio Contratado y Sede *',
                            prefixIcon: Icon(
                              Icons.room_service_outlined,
                              size: 18,
                            ),
                          ),
                          items: selectedClient!.services
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    '${s.serviceName} (${s.branchLocation})',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (s) {
                            setDlgState(() => selectedService = s);
                          },
                        ),
                    ] else ...[
                      // Dropdown simple de Área en Oficina Central
                      DropdownButtonFormField<String>(
                        initialValue: areas.any((ar) => ar.name == selectedArea)
                            ? selectedArea
                            : (areas.isNotEmpty
                                  ? areas.first.name
                                  : 'Operaciones'),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Área en Oficina Central *',
                          prefixIcon: Icon(Icons.corporate_fare, size: 18),
                        ),
                        items: areas
                            .map(
                              (ar) => DropdownMenuItem(
                                value: ar.name,
                                child: Text(
                                  ar.name,
                                  style: GoogleFonts.inter(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDlgState(() => selectedArea = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: positionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Cargo o Rol en Oficina *',
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Horario / Turno Asignado
                    DropdownButtonFormField<String>(
                      initialValue:
                          availableScheduleNames.contains(currentSchedule)
                          ? currentSchedule
                          : availableScheduleNames.first,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Horario / Turno Asignado *',
                        prefixIcon: Icon(Icons.access_time, size: 18),
                      ),
                      items: availableScheduleNames
                          .map(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDlgState(() => currentSchedule = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Supervisor Asignado
                    TextField(
                      controller: supervisorCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Supervisor Inmediato *',
                        prefixIcon: Icon(Icons.person_pin, size: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Motivo de Asignación
                    Text(
                      'Motivo o Causal de la Asignación',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: assignmentReasons.contains(selectedReason)
                          ? selectedReason
                          : assignmentReasons.first,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Causal de Asignación *',
                        prefixIcon: Icon(Icons.info_outline, size: 18),
                      ),
                      items: assignmentReasons
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(
                                r,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDlgState(() => selectedReason = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(
                        labelText:
                            'Detalle o Justificación Adicional (opcional)',
                        hintText:
                            'Ej: Cobertura de apertura de nueva sucursal...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Guardar Asignación'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final fullReason = reasonCtrl.text.trim().isNotEmpty
                      ? '$selectedReason: ${reasonCtrl.text.trim()}'
                      : selectedReason;

                  _stateService.rotateEmployee(
                    employeeId: selectedEmp.id,
                    employeeName: selectedEmp.fullName,
                    employeeCode: selectedEmp.code,
                    type: selectedType,
                    clientCompanyId: selectedType == 'CAMPO'
                        ? selectedClient?.id
                        : null,
                    clientCompanyName: selectedType == 'CAMPO'
                        ? selectedClient?.name
                        : null,
                    contractedServiceId: selectedType == 'CAMPO'
                        ? selectedService?.id
                        : null,
                    contractedServiceName: selectedType == 'CAMPO'
                        ? selectedService?.serviceName
                        : null,
                    workplaceBranch: selectedType == 'CAMPO'
                        ? selectedService?.branchLocation
                        : 'Oficina Central',
                    officeArea: selectedType == 'OFICINA' ? selectedArea : null,
                    officeRole: selectedType == 'OFICINA'
                        ? positionCtrl.text.trim()
                        : null,
                    scheduleName: currentSchedule,
                    supervisorName: supervisorCtrl.text.trim(),
                    rotationReason: fullReason,
                    notes: notesCtrl.text.trim().isNotEmpty
                        ? notesCtrl.text.trim()
                        : null,
                  );

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Asignación registrada exitosamente para ${selectedEmp.fullName}.',
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _openNewClientDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Retail / Comercial');
    final addressCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final serviceNameCtrl = TextEditingController(text: 'Limpieza Integral');
    final branchCtrl = TextEditingController(text: 'Sede Principal');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_business,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registrar Nuevo Cliente / Empresa',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Alta de empresa contratante y servicio inicial',
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
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 480,
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.75,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Empresa Cliente *',
                    hintText: 'Ej: Hipermaxi S.A., Farmacorp...',
                    prefixIcon: Icon(Icons.business, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Rubro / Categoría *',
                    hintText: 'Ej: Retail, Salud, Industrial, Logística',
                    prefixIcon: Icon(Icons.category, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección o Ubicación Principal',
                    prefixIcon: Icon(Icons.place, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: contactCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Persona de Contacto',
                          prefixIcon: Icon(Icons.person, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono de Contacto',
                          prefixIcon: Icon(Icons.phone, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: serviceNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Servicio Contratado Inicial *',
                    hintText: 'Ej: Limpieza de Áreas Comunes, Mantenimiento...',
                    prefixIcon: Icon(Icons.room_service, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: branchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Sede Asignada al Servicio *',
                    hintText: 'Ej: Sede Central, Sucursal Norte...',
                    prefixIcon: Icon(Icons.store, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Guardar Cliente'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final newId = 'cli-${DateTime.now().millisecondsSinceEpoch}';
              final newSvc = RrhhClientContractedService(
                id: 'svc-${DateTime.now().millisecondsSinceEpoch}',
                clientId: newId,
                serviceName: serviceNameCtrl.text.trim().isNotEmpty
                    ? serviceNameCtrl.text.trim()
                    : 'Servicio General',
                branchLocation: branchCtrl.text.trim().isNotEmpty
                    ? branchCtrl.text.trim()
                    : 'Sede Principal',
                requiredStaff: 2,
                scheduleSummary: '08:00 - 16:00',
              );
              _stateService.addClientCompany(
                RrhhClientCompany(
                  id: newId,
                  name: nameCtrl.text.trim(),
                  businessCategory: categoryCtrl.text.trim(),
                  address: addressCtrl.text.trim().isNotEmpty
                      ? addressCtrl.text.trim()
                      : 'Santa Cruz de la Sierra',
                  contactPerson: contactCtrl.text.trim().isNotEmpty
                      ? contactCtrl.text.trim()
                      : 'Administración',
                  contactPhone: phoneCtrl.text.trim().isNotEmpty
                      ? phoneCtrl.text.trim()
                      : '70000000',
                  services: [newSvc],
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cliente "${nameCtrl.text.trim()}" registrado con éxito.',
                  ),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openNewScheduleDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController();
    final startCtrl = TextEditingController(text: '08:00');
    final endCtrl = TextEditingController(text: '16:00');
    final graceCtrl = TextEditingController(text: '10');
    String appliesTo = 'CAMPO';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        title: Text(
          'Crear Plantilla de Horario',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Turno (ej: Turno Tarde 14:00 - 22:00)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startCtrl,
                      decoration: const InputDecoration(labelText: 'Entrada'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: endCtrl,
                      decoration: const InputDecoration(labelText: 'Salida'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: graceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tolerancia (minutos)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: appliesTo,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Aplica a',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'CAMPO',
                          child: Text('Campo'),
                        ),
                        DropdownMenuItem(
                          value: 'OFICINA',
                          child: Text('Oficina'),
                        ),
                        DropdownMenuItem(
                          value: 'AMBOS',
                          child: Text('Ambos'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) appliesTo = val;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final startParts = startCtrl.text.trim().split(':');
              final endParts = endCtrl.text.trim().split(':');
              final startH = int.tryParse(startParts.first) ?? 8;
              final startM = startParts.length > 1
                  ? (int.tryParse(startParts[1]) ?? 0)
                  : 0;
              final endH = int.tryParse(endParts.first) ?? 16;
              final endM = endParts.length > 1
                  ? (int.tryParse(endParts[1]) ?? 0)
                  : 0;

              _stateService.addSchedule(
                RrhhWorkSchedule(
                  id: 'SCH-${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  startTime: TimeOfDay(hour: startH, minute: startM),
                  endTime: TimeOfDay(hour: endH, minute: endM),
                  gracePeriodMinutes: int.tryParse(graceCtrl.text) ?? 10,
                  workingDays: const [
                    'Lunes',
                    'Martes',
                    'Miércoles',
                    'Jueves',
                    'Viernes',
                  ],
                  employeeTypeScope: appliesTo,
                  totalWeeklyHours: 40,
                  observations: 'Horario estándar registrado por RRHH',
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Horario registrado exitosamente.'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Guardar Horario'),
          ),
        ],
      ),
    );
  }
}
