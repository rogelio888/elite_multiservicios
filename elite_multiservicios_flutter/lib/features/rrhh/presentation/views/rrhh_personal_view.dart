import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_applicant.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_applicant_modal.dart';
import '../widgets/rrhh_edit_employee_dialog.dart';
import '../widgets/rrhh_employee_modal.dart';
import '../widgets/rrhh_hire_dialog.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista núcleo de Personal & Postulantes (Todos, Activos, Inactivos, Postulantes)
/// Rediseñada con estética ejecutiva, prolija y minimalista (estilo Imagen 1 y 2).
class RrhhPersonalView extends StatefulWidget {
  const RrhhPersonalView({super.key});

  @override
  State<RrhhPersonalView> createState() => _RrhhPersonalViewState();
}

class _RrhhPersonalViewState extends State<RrhhPersonalView>
    with SingleTickerProviderStateMixin {
  final _rrhhService = RrhhStateService();
  late TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedTypeFilter = 'TODOS'; // 'TODOS', 'OFICINA', 'CAMPO'
  String _selectedCompany = 'TODAS'; // 'TODAS' o nombre de empresa/sede

  late final ScrollController _employeesScrollController;
  late final ScrollController _applicantsScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _employeesScrollController = ScrollController();
    _applicantsScrollController = ScrollController();
    _rrhhService.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _employeesScrollController.dispose();
    _applicantsScrollController.dispose();
    _searchController.dispose();
    _rrhhService.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  List<String> _getAvailableCompanies() {
    final set = <String>{};
    for (final e in _rrhhService.employees) {
      if (e.workplace.trim().isNotEmpty) {
        set.add(e.workplace.trim());
      }
    }
    for (final c in _rrhhService.clientCompanies) {
      if (c.name.trim().isNotEmpty) {
        set.add(c.name.trim());
      }
    }
    final sorted = set.toList()..sort();
    if (sorted.contains('Oficina Central Elite')) {
      sorted.remove('Oficina Central Elite');
      sorted.insert(0, 'Oficina Central Elite');
    }
    return ['TODAS', ...sorted];
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

      // Filtro por empresa
      if (_selectedCompany != 'TODAS') {
        final comp = emp.workplace.trim();
        if (!comp.toLowerCase().contains(_selectedCompany.toLowerCase())) {
          return false;
        }
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

  void _openEditEmployeeDialog(RrhhEmployee emp) {
    showDialog(
      context: context,
      builder: (ctx) => RrhhEditEmployeeDialog(employee: emp),
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
    final availableCompanies = _getAvailableCompanies();
    if (!availableCompanies.contains(_selectedCompany)) {
      _selectedCompany = 'TODAS';
    }

    return LayoutBuilder(
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
              // 1. Encabezado Ejecutivo Limpio
              _buildHeader(isDark, isMobile),
              const SizedBox(height: 16),

              // 2. Barra de Filtro Unificada y Prolija (Estilo Imagen 1 con Regla 7/8+)
              _buildUnifiedFilterBar(isDark, availableCompanies),
              const SizedBox(height: 14),

              // 3. Pestañas: Todos | Activos | Inactivos | Postulantes
              _buildTabsBar(isDark),
              const SizedBox(height: 14),

              // 4. TabBarView con Tablas Ejecutivas
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
                'Directorio de Personal & Postulantes',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expedientes digitales, colaboradores activos/inactivos y banco de candidatos.',
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
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: const Text('Contratar / Registrar'),
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
          onPressed: () => _openHireDialog(),
        ),
      ],
    );
  }

  // --- 2. BARRA DE FILTRO UNIFICADA Y PROLIJA (ESTILO IMAGEN 1) ---
  Widget _buildUnifiedFilterBar(
    bool isDark,
    List<String> availableCompanies,
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
          hintText: 'Buscar por colaborador, código, C.I., cargo o sede...',
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
      selectedValue: _selectedTypeFilter,
      onSelected: (val) => setState(() => _selectedTypeFilter = val),
      isDark: isDark,
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
                  ],
                ),
        );
      },
    );
  }

  // --- REGLA 7 vs 8+: SELECTOR ADAPTATIVO DE EMPRESAS/SEDES ---
  Widget _buildAdaptiveCompanySelector(
    bool isDark,
    List<String> companies,
  ) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    // Regla estricta:
    // Si tiene hasta 7 registros: selector estándar normal limpio.
    // Si tiene 8 o más registros: habilitar selector con búsqueda/autocompletado interactivo.
    final bool enableSearch = companies.length >= 8;

    if (!enableSearch) {
      // 1. Hasta 7 registros: Selector Dropdown estándar normal
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
                      ? _rrhhService.employees.length
                      : _rrhhService.employees
                            .where(
                              (e) =>
                                  e.workplace.trim().toLowerCase() ==
                                  comp.trim().toLowerCase(),
                            )
                            .length;
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

    // 2. 8 o más registros: Selector interactivo tipo Google con Autocompletado y Búsqueda
    final selectedCount = _selectedCompany == 'TODAS'
        ? _rrhhService.employees.length
        : _rrhhService.employees
              .where(
                (e) =>
                    e.workplace.trim().toLowerCase() ==
                    _selectedCompany.trim().toLowerCase(),
              )
              .length;

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

  // Diálogo interactivo de autocompletado y búsqueda rápida de empresas
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
                      children: [
                        const Icon(
                          Icons.search,
                          size: 18,
                          color: Color(0xFF6366F1),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Buscar Empresa o Sede Asignada',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          splashRadius: 16,
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Input de búsqueda en vivo con autofocus
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0B1120)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: TextField(
                        autofocus: true,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        onChanged: (v) {
                          setDialogState(() => filter = v.trim());
                        },
                        decoration: InputDecoration(
                          hintText: 'Escriba el nombre de la empresa...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                          prefixIcon: const Icon(
                            Icons.business_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${filtered.length} empresas encontradas:',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Lista de opciones filtradas
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
                              ? _rrhhService.employees.length
                              : _rrhhService.employees
                                    .where(
                                      (e) =>
                                          e.workplace.trim().toLowerCase() ==
                                          comp.trim().toLowerCase(),
                                    )
                                    .length;

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
                                    ? const Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.12)
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

  // Segmented Buttons estilo pastilla compacta (Idéntico a Imagen 1)
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

  // --- 4. TABLA DE COLABORADORES ---
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

    final tableWidth = max(maxWidth - 48, 1140.0);
    const columnWidths = {
      0: FlexColumnWidth(2.6), // Colaborador
      1: FixedColumnWidth(115), // CI
      2: FlexColumnWidth(2.4), // Cargo & Tipo
      3: FlexColumnWidth(2.2), // Sucursal / Sede
      4: FixedColumnWidth(120), // Sueldo
      5: FixedColumnWidth(115), // Expediente
      6: FixedColumnWidth(135), // Estado
      7: FixedColumnWidth(165), // Acciones (Editar + Expediente)
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
                        controller: _employeesScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _employeesScrollController,
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
                                            0xFF6366F1,
                                          ).withValues(alpha: 0.15),
                                          child: Text(
                                            emp.fullName.isNotEmpty
                                                ? emp.fullName.substring(0, 1)
                                                : '?',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF6366F1),
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
                                                style:
                                                    GoogleFonts.jetBrainsMono(
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
                                      style: GoogleFonts.jetBrainsMono(
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
                                          color: const Color(0xFF6366F1),
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
                                          style: GoogleFonts.jetBrainsMono(
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
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              size: 16,
                                            ),
                                            tooltip:
                                                'Editar Datos & Documentos',
                                            onPressed: () =>
                                                _openEditEmployeeDialog(emp),
                                          ),
                                          const SizedBox(width: 4),
                                          FilledButton.tonalIcon(
                                            style: FilledButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              backgroundColor: const Color(
                                                0xFF6366F1,
                                              ).withValues(alpha: 0.12),
                                              foregroundColor: const Color(
                                                0xFF6366F1,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
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

  // --- 5. TABLA DE POSTULANTES ---
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

    final tableWidth = max(maxWidth - 48, 1020.0);
    const columnWidths = {
      0: FlexColumnWidth(2.6), // Postulante
      1: FixedColumnWidth(115), // CI
      2: FlexColumnWidth(2.4), // Cargo & Especialidad
      3: FixedColumnWidth(120), // Pretensión
      4: FixedColumnWidth(125), // Fecha Postulación
      5: FixedColumnWidth(155), // Etapa
      6: FixedColumnWidth(130), // Acciones
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
                        controller: _applicantsScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _applicantsScrollController,
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
                                                style:
                                                    GoogleFonts.jetBrainsMono(
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
                                          style: GoogleFonts.jetBrainsMono(
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
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        color: const Color(0xFF10B981),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _buildBodyCell(
                                    Text(
                                      '${app.applicationDate.day}/${app.applicationDate.month}/${app.applicationDate.year}',
                                      style: GoogleFonts.jetBrainsMono(
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
                  0xFF6366F1,
                ).withValues(alpha: 0.15),
                child: Text(
                  emp.fullName.isNotEmpty ? emp.fullName[0] : '?',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6366F1),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _openEditEmployeeDialog(emp),
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Editar', style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () => _openEmployeeModal(emp),
                child: const Text('Expediente', style: TextStyle(fontSize: 11)),
              ),
            ],
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
