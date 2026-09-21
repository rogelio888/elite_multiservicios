import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_organization.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista de Estructura Organizacional: Áreas, Cargos y Especialidades.
/// Rediseñada con estética ejecutiva, prolija, moderna y limpia.
class RrhhOrganizationView extends StatefulWidget {
  const RrhhOrganizationView({super.key});

  @override
  State<RrhhOrganizationView> createState() => _RrhhOrganizationViewState();
}

class _RrhhOrganizationViewState extends State<RrhhOrganizationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedAreaFilter = 'TODAS';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _stateService,
      builder: (context, _) {
        final query = _searchQuery.trim().toLowerCase();

        final areas = _stateService.areas.where((a) {
          if (query.isEmpty) return true;
          return a.name.toLowerCase().contains(query) ||
              a.code.toLowerCase().contains(query) ||
              a.description.toLowerCase().contains(query);
        }).toList();

        final positions = _stateService.positions.where((p) {
          final matchesArea =
              _selectedAreaFilter == 'TODAS' || p.areaId == _selectedAreaFilter;
          if (!matchesArea) return false;
          if (query.isEmpty) return true;
          return p.title.toLowerCase().contains(query) ||
              p.code.toLowerCase().contains(query) ||
              p.areaName.toLowerCase().contains(query);
        }).toList();

        final specialties = _stateService.specialties.where((s) {
          if (query.isEmpty) return true;
          return s.name.toLowerCase().contains(query) ||
              s.code.toLowerCase().contains(query) ||
              s.description.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // 1. Header Principal Corporativo
              _buildHeader(isDark),

              // 2. Barra Unificada de Filtros y Navegación
              _buildUnifiedToolbar(isDark),

              // 3. Contenido Dinámico según Tab
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAreasList(areas, isDark),
                    _buildPositionsList(positions, isDark),
                    _buildSpecialtiesList(specialties, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 1. HEADER PRINCIPAL
  // ===========================================================================
  Widget _buildHeader(bool isDark) {
    final tabIndex = _tabController.index;
    final actionLabel = tabIndex == 0
        ? 'Nueva Área'
        : (tabIndex == 1 ? 'Nuevo Cargo' : 'Nueva Especialidad');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          // Icono con halo suave
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.account_tree_outlined,
              color: Color(0xFF3B82F6),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Títulos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Organización & Estructura',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Definición de Áreas departamentales, Cargos jerárquicos y Especialidades técnicas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: 16),
          // Botón Primario de Creación
          FilledButton.icon(
            onPressed: () => _openCreationDialog(context),
            icon: const Icon(Icons.add, size: 17),
            label: Text(
              actionLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. BARRA UNIFICADA DE FILTROS & TABS
  // ===========================================================================
  Widget _buildUnifiedToolbar(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 800;

          final tabPills = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabPill(0, 'Áreas', _stateService.areas.length, isDark),
              const SizedBox(width: 8),
              _buildTabPill(
                1,
                'Cargos',
                _stateService.positions.length,
                isDark,
              ),
              const SizedBox(width: 8),
              _buildTabPill(
                2,
                'Especialidades',
                _stateService.specialties.length,
                isDark,
              ),
            ],
          );

          final searchBox = SizedBox(
            height: 38,
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Buscar en catálogo...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 17,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 15),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF0B1120)
                    : const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                ),
              ),
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: tabPills,
                ),
                const SizedBox(height: 10),
                searchBox,
              ],
            );
          }

          return Row(
            children: [
              tabPills,
              const Spacer(),
              // En pestaña de Cargos mostramos el selector adaptativo de área
              if (_tabController.index == 1) ...[
                _buildAdaptiveAreaFilter(isDark),
                const SizedBox(width: 10),
              ],
              SizedBox(width: 260, child: searchBox),
            ],
          );
        },
      ),
    );
  }

  // Segmented Pill Tab
  Widget _buildTabPill(int index, String title, int count, bool isDark) {
    final isSelected = _tabController.index == index;

    final bgColor = isSelected
        ? const Color(0xFF2563EB)
        : (isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9));
    final fgColor = isSelected
        ? Colors.white
        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569));
    final badgeBg = isSelected
        ? Colors.white.withValues(alpha: 0.25)
        : (isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0));
    final badgeFg = isSelected
        ? Colors.white
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: fgColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: badgeFg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REGLA 7 vs 8+: SELECTOR ADAPTATIVO DE FILTRO POR ÁREA ---
  Widget _buildAdaptiveAreaFilter(bool isDark) {
    final areas = _stateService.areas;
    final enableSearch = areas.length >= 8;
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    if (!enableSearch) {
      // Hasta 7 áreas: Selector limpio desplegable estándar
      return Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.domain_outlined,
              size: 15,
              color: Color(0xFF3B82F6),
            ),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedAreaFilter,
                dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                items: [
                  const DropdownMenuItem(
                    value: 'TODAS',
                    child: Text('Todas las Áreas'),
                  ),
                  ...areas.map(
                    (a) => DropdownMenuItem(
                      value: a.id,
                      child: Text(a.name),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAreaFilter = val);
                },
              ),
            ),
          ],
        ),
      );
    }

    // 8 o más áreas: Selector interactivo con buscador/autocompletado
    String label = 'Todas las Áreas';
    if (_selectedAreaFilter != 'TODAS') {
      final found = areas.where((a) => a.id == _selectedAreaFilter);
      if (found.isNotEmpty) label = found.first.name;
    }

    return InkWell(
      onTap: () => _openAreaSearchModal(isDark, areas),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.domain_outlined,
              size: 15,
              color: Color(0xFF3B82F6),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.search, size: 14, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  void _openAreaSearchModal(bool isDark, List<RrhhArea> areas) {
    showDialog(
      context: context,
      builder: (ctx) {
        String filter = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = areas.where((a) {
              if (filter.isEmpty) return true;
              return a.name.toLowerCase().contains(filter.toLowerCase()) ||
                  a.code.toLowerCase().contains(filter.toLowerCase());
            }).toList();

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Seleccionar Área (${areas.length} registradas)',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: SizedBox(
                width: 380,
                height: 360,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (v) => setModalState(() => filter = v),
                      decoration: InputDecoration(
                        hintText: 'Buscar área por nombre o código...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.apps, size: 18),
                            title: const Text('Todas las Áreas'),
                            selected: _selectedAreaFilter == 'TODAS',
                            onTap: () {
                              setState(() => _selectedAreaFilter = 'TODAS');
                              Navigator.pop(ctx);
                            },
                          ),
                          ...filtered.map(
                            (a) => ListTile(
                              dense: true,
                              leading: Text(
                                a.code,
                                style: GoogleFonts.jetBrainsMono(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                              title: Text(a.name),
                              selected: _selectedAreaFilter == a.id,
                              onTap: () {
                                setState(() => _selectedAreaFilter = a.id);
                                Navigator.pop(ctx);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // 3. TAB 1: ÁREAS DEPARTAMENTALES
  // ===========================================================================
  Widget _buildAreasList(List<RrhhArea> areas, bool isDark) {
    if (areas.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay áreas registradas',
        message: 'No se encontraron áreas departamentales que coincidan.',
        icon: Icons.corporate_fare_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1150
            ? 3
            : (constraints.maxWidth > 720 ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 195,
          ),
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final area = areas[index];
            final positionsCount = _stateService.positions
                .where((p) => p.areaId == area.id)
                .length;
            final employeesCount = _stateService.activeEmployees
                .where((e) => e.area == area.name)
                .length;

            return _buildAreaCard(
              area: area,
              positionsCount: positionsCount,
              employeesCount: employeesCount,
              isDark: isDark,
            );
          },
        );
      },
    );
  }

  Widget _buildAreaCard({
    required RrhhArea area,
    required int positionsCount,
    required int employeesCount,
    required bool isDark,
  }) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header del Card: Código y Tipo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  area.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B82F6),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              RrhhStatusChip(
                label: area.type,
                statusType: area.type == 'CAMPO'
                    ? StatusType.success
                    : (area.type == 'OFICINA'
                          ? StatusType.info
                          : StatusType.warning),
              ),
            ],
          ),

          // Título y Descripción
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area.name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                area.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.35,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Footer: Indicadores Prolijos
          Row(
            children: [
              _buildMetricBadge(
                icon: Icons.work_outline,
                count: positionsCount,
                label: 'Cargos',
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildMetricBadge(
                icon: Icons.people_outline,
                count: employeesCount,
                label: 'Colaboradores',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. TAB 2: CARGOS Y PUESTOS JERÁRQUICOS
  // ===========================================================================
  Widget _buildPositionsList(List<RrhhPosition> positions, bool isDark) {
    if (positions.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay cargos registrados',
        message: 'No se encontraron puestos que coincidan con la búsqueda.',
        icon: Icons.work_outline,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1150
            ? 3
            : (constraints.maxWidth > 720 ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 205,
          ),
          itemCount: positions.length,
          itemBuilder: (context, index) {
            final pos = positions[index];
            final empCount = _stateService.activeEmployees
                .where((e) => e.position == pos.title)
                .length;

            return _buildPositionCard(pos, empCount, isDark);
          },
        );
      },
    );
  }

  Widget _buildPositionCard(
    RrhhPosition pos,
    int empCount,
    bool isDark,
  ) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Código y Área
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  pos.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const Spacer(),
              RrhhStatusChip(
                label: pos.areaName,
                statusType: StatusType.info,
              ),
            ],
          ),

          // Título y Rango Salarial
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pos.title,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 13,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Bs. ${pos.minSalary.toStringAsFixed(0)} - ${pos.maxSalary.toStringAsFixed(0)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• Nivel: ${pos.level}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Footer: Métricas y Requisitos
          Row(
            children: [
              _buildMetricBadge(
                icon: Icons.people_outline,
                count: empCount,
                label: 'Colaboradores',
                isDark: isDark,
              ),
              if (pos.requiresSpecialty) ...[
                const SizedBox(width: 8),
                const RrhhStatusChip(
                  label: 'Esp. Requerida',
                  statusType: StatusType.warning,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 5. TAB 3: ESPECIALIDADES TÉCNICAS
  // ===========================================================================
  Widget _buildSpecialtiesList(List<RrhhSpecialty> specialties, bool isDark) {
    if (specialties.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay especialidades registradas',
        message: 'No se encontraron habilidades técnicas registradas.',
        icon: Icons.psychology_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1150
            ? 3
            : (constraints.maxWidth > 720 ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 185,
          ),
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            final spec = specialties[index];
            return _buildSpecCard(spec, isDark);
          },
        );
      },
    );
  }

  Widget _buildSpecCard(RrhhSpecialty spec, bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Código y Certificación
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  spec.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
              const Spacer(),
              if (spec.requiresCertification)
                const RrhhStatusChip(
                  label: 'Certificación Req.',
                  statusType: StatusType.danger,
                )
              else
                const RrhhStatusChip(
                  label: 'Técnico General',
                  statusType: StatusType.neutral,
                ),
            ],
          ),

          // Título y Descripción
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spec.name,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                spec.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.35,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Footer
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 14,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 5),
              Text(
                'Especialidad Activa',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGETS AUXILIARES
  // ===========================================================================
  Widget _buildMetricBadge({
    required IconData icon,
    required int count,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 5),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DIÁLOGOS DE CREACIÓN (CON REGLA ADAPTATIVA 7 vs 8+)
  // ===========================================================================
  void _openCreationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTab = _tabController.index;

    if (currentTab == 0) {
      _openAreaDialog(context, isDark);
    } else if (currentTab == 1) {
      _openPositionDialog(context, isDark);
    } else {
      _openSpecialtyDialog(context, isDark);
    }
  }

  // 1. Modal Nueva Área
  void _openAreaDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String type = 'OFICINA';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.corporate_fare_outlined,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Nueva Área Organizacional',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Código de Área (ej: ADM, OPR, LIM)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Área',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Área Operativa',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'OFICINA',
                      child: Text('Personal de Oficina Central'),
                    ),
                    DropdownMenuItem(
                      value: 'CAMPO',
                      child: Text('Personal Operativo de Campo'),
                    ),
                    DropdownMenuItem(
                      value: 'MIXTO',
                      child: Text('Mixto (Oficina y Campo)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => type = val);
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / Responsabilidad',
                    border: OutlineInputBorder(),
                  ),
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
                _stateService.addArea(
                  RrhhArea(
                    id: 'AREA-${DateTime.now().millisecondsSinceEpoch}',
                    code: codeCtrl.text.trim().toUpperCase(),
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    type: type,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Área creada exitosamente.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text('Guardar Área'),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Modal Nuevo Cargo con Selector Adaptativo de Área (Regla 7 vs 8+)
  void _openPositionDialog(BuildContext context, bool isDark) {
    final titleCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final minSalCtrl = TextEditingController(text: '2800');
    final maxSalCtrl = TextEditingController(text: '4500');
    final areas = _stateService.areas;
    String selectedArea = areas.isNotEmpty ? areas.first.id : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) {
          final enableSearch = areas.length >= 8;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
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
                    Icons.work_outline,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Nuevo Cargo / Puesto',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: codeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Código de Puesto (ej: CAR-010)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título del Cargo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // SELECTOR ADAPTATIVO: 7 o menos = Dropdown normal, 8 o más = Búsqueda interactiva
                  if (!enableSearch)
                    DropdownButtonFormField<String>(
                      initialValue: selectedArea,
                      decoration: const InputDecoration(
                        labelText: 'Área Perteneciente',
                        border: OutlineInputBorder(),
                      ),
                      items: areas
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDlgState(() => selectedArea = val);
                      },
                    )
                  else
                    InkWell(
                      onTap: () {
                        _openAreaSearchModalForDialog(
                          isDark,
                          areas,
                          (newId) => setDlgState(() => selectedArea = newId),
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText:
                              'Área Perteneciente (Selector con Búsqueda)',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search, size: 20),
                        ),
                        child: Text(
                          areas
                              .firstWhere(
                                (a) => a.id == selectedArea,
                                orElse: () => areas.first,
                              )
                              .name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minSalCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Salario Mín (Bs.)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: maxSalCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Salario Máx (Bs.)',
                            border: OutlineInputBorder(),
                          ),
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
                  if (titleCtrl.text.trim().isEmpty) return;
                  final areaObj = areas.firstWhere(
                    (a) => a.id == selectedArea,
                    orElse: () => areas.first,
                  );
                  _stateService.addPosition(
                    RrhhPosition(
                      id: 'POS-${DateTime.now().millisecondsSinceEpoch}',
                      code: codeCtrl.text.trim().toUpperCase(),
                      title: titleCtrl.text.trim(),
                      areaId: selectedArea,
                      areaName: areaObj.name,
                      minSalary: double.tryParse(minSalCtrl.text) ?? 2500,
                      maxSalary: double.tryParse(maxSalCtrl.text) ?? 4000,
                      level: 'OPERATIVO',
                    ),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cargo creado exitosamente.'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                ),
                child: const Text('Guardar Cargo'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openAreaSearchModalForDialog(
    bool isDark,
    List<RrhhArea> areas,
    ValueChanged<String> onSelected,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        String filter = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = areas.where((a) {
              if (filter.isEmpty) return true;
              return a.name.toLowerCase().contains(filter.toLowerCase()) ||
                  a.code.toLowerCase().contains(filter.toLowerCase());
            }).toList();

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              title: const Text('Buscar Área Perteneciente'),
              content: SizedBox(
                width: 360,
                height: 320,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (v) => setModalState(() => filter = v),
                      decoration: const InputDecoration(
                        hintText: 'Filtrar por nombre...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: filtered
                            .map(
                              (a) => ListTile(
                                leading: Text(
                                  a.code,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                title: Text(a.name),
                                onTap: () {
                                  onSelected(a.id);
                                  Navigator.pop(ctx);
                                },
                              ),
                            )
                            .toList(),
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

  // 3. Modal Nueva Especialidad
  void _openSpecialtyDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Nueva Especialidad Técnica',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Código (ej: ESP-005)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Especialidad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción / Habilidades requeridas',
                  border: OutlineInputBorder(),
                ),
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
              _stateService.addSpecialty(
                RrhhSpecialty(
                  id: 'ESP-${DateTime.now().millisecondsSinceEpoch}',
                  code: codeCtrl.text.trim().toUpperCase(),
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                ),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Especialidad registrada exitosamente.'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
            ),
            child: const Text('Guardar Especialidad'),
          ),
        ],
      ),
    );
  }
}
