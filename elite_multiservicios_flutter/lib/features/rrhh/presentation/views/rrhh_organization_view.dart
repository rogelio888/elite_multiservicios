import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_organization.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista de Estructura Organizacional: Áreas, Cargos y Especialidades.
class RrhhOrganizationView extends StatefulWidget {
  const RrhhOrganizationView({super.key});

  @override
  State<RrhhOrganizationView> createState() => _RrhhOrganizationViewState();
}

class _RrhhOrganizationViewState extends State<RrhhOrganizationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();
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
        final areas = _stateService.areas.where((a) {
          if (_searchQuery.isEmpty) return true;
          return a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.description.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        final positions = _stateService.positions.where((p) {
          if (_searchQuery.isEmpty) return true;
          return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.areaName.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        final specialties = _stateService.specialties.where((s) {
          if (_searchQuery.isEmpty) return true;
          return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.description.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // Header con buscador y tabs
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
                              0xFF2563EB,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_tree_outlined,
                            color: Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organización & Estructura',
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
                                'Definición de Áreas departamentales, Cargos jerárquicos y Especialidades técnicas',
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
                        FilledButton.icon(
                          onPressed: () => _openCreationDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            _tabController.index == 0
                                ? 'Nueva Área'
                                : (_tabController.index == 1
                                      ? 'Nuevo Cargo'
                                      : 'Nueva Especialidad'),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TabBar(
                            controller: _tabController,
                            onTap: (_) => setState(() {}),
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: const Color(0xFF2563EB),
                            unselectedLabelColor: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            indicatorColor: const Color(0xFF2563EB),
                            indicatorWeight: 3,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: [
                              Tab(
                                text: 'Áreas (${_stateService.areas.length})',
                              ),
                              Tab(
                                text:
                                    'Cargos (${_stateService.positions.length})',
                              ),
                              Tab(
                                text:
                                    'Especialidades (${_stateService.specialties.length})',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
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
                              hintText: 'Buscar en catálogo...',
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

              // Contenido con TabBarView
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

  Widget _buildAreasList(List<RrhhArea> areas, bool isDark) {
    if (areas.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay áreas registradas',
        message: 'No se encontraron áreas que coincidan con la búsqueda.',
        icon: Icons.corporate_fare_outlined,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 460,
        mainAxisExtent: 185,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cabecera: Avatar + Título y Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    child: const Center(
                      child: Icon(
                        Icons.apartment_rounded,
                        color: Color(0xFF2563EB),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          area.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(
                                        0xFF2563EB,
                                      ).withValues(alpha: 0.14)
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(
                                          0xFF2563EB,
                                        ).withValues(alpha: 0.3)
                                      : const Color(0xFFBFDBFE),
                                ),
                              ),
                              child: Text(
                                area.code,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
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
                      ],
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                area.description,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Separador y Métricas inferiores
              Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem(
                        icon: Icons.work_outline,
                        value: '$positionsCount',
                        label: 'Cargos',
                        color: const Color(0xFF6366F1),
                        isDark: isDark,
                      ),
                      _buildMetricItem(
                        icon: Icons.people_outline,
                        value: '$employeesCount',
                        label: 'Colaboradores',
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionsList(List<RrhhPosition> positions, bool isDark) {
    if (positions.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay cargos registrados',
        message: 'No se encontraron puestos que coincidan con la búsqueda.',
        icon: Icons.work_outline,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 460,
        mainAxisExtent: 220,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final pos = positions[index];
        final empCount = _stateService.activeEmployees
            .where((e) => e.position == pos.title)
            .length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cabecera: Avatar + Cargo y Área
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.badge_outlined,
                        color: Color(0xFF10B981),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pos.title,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.14)
                                    : const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(
                                          0xFF10B981,
                                        ).withValues(alpha: 0.3)
                                      : const Color(0xFFA7F3D0),
                                ),
                              ),
                              child: Text(
                                pos.code,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: RrhhStatusChip(
                                label: pos.areaName,
                                statusType: StatusType.info,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (pos.requiresSpecialty)
                    Tooltip(
                      message: 'Requiere Especialidad Técnica',
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF59E0B,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                ],
              ),

              // Fila Media: Rango Salarial & Nivel Jerárquico
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
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
                          Icons.payments_outlined,
                          size: 15,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Bs. ${pos.minSalary.toStringAsFixed(0)} - ${pos.maxSalary.toStringAsFixed(0)}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFF34D399)
                                : const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pos.level,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Pie de tarjeta
              Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.group_outlined,
                            size: 15,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$empCount Colaboradores activos',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: empCount > 0
                              ? const Color(0xFF10B981)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecialtiesList(List<RrhhSpecialty> specialties, bool isDark) {
    if (specialties.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay especialidades registradas',
        message: 'No se encontraron habilidades técnicas registradas.',
        icon: Icons.psychology_outlined,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 460,
        mainAxisExtent: 185,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final spec = specialties[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cabecera: Avatar + Nombre y Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        color: Color(0xFFF59E0B),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spec.name,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.14)
                                    : const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(
                                          0xFFF59E0B,
                                        ).withValues(alpha: 0.3)
                                      : const Color(0xFFFDE68A),
                                ),
                              ),
                              child: Text(
                                spec.code,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFD97706),
                                ),
                              ),
                            ),
                            if (spec.requiresCertification) ...[
                              const SizedBox(width: 6),
                              const Flexible(
                                child: RrhhStatusChip(
                                  label: 'Certificación Obligatoria',
                                  statusType: StatusType.danger,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Descripción
              Text(
                spec.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Pie
              Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Requisito de competencia laboral',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openCreationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTab = _tabController.index;

    if (currentTab == 0) {
      // Dialog Nueva Área
      final nameCtrl = TextEditingController();
      final codeCtrl = TextEditingController();
      final descCtrl = TextEditingController();
      String type = 'OFICINA';

      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDlgState) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            title: Text(
              'Nueva Área Organizacional',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Área',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Área',
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Descripción / Responsabilidad',
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
                child: const Text('Guardar Área'),
              ),
            ],
          ),
        ),
      );
    } else if (currentTab == 1) {
      // Dialog Nuevo Cargo
      final titleCtrl = TextEditingController();
      final codeCtrl = TextEditingController();
      final minSalCtrl = TextEditingController(text: '2800');
      final maxSalCtrl = TextEditingController(text: '4500');
      String selectedArea = _stateService.areas.first.id;

      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDlgState) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            title: Text(
              'Nuevo Cargo / Puesto',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título del Cargo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedArea,
                    decoration: const InputDecoration(
                      labelText: 'Área Perteneciente',
                    ),
                    items: _stateService.areas
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
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minSalCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Salario Mín (Bs.)',
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
                  final areaObj = _stateService.areas.firstWhere(
                    (a) => a.id == selectedArea,
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
                child: const Text('Guardar Cargo'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Dialog Nueva Especialidad
      final nameCtrl = TextEditingController();
      final codeCtrl = TextEditingController();
      final descCtrl = TextEditingController();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            'Nueva Especialidad Técnica',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
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
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Especialidad',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / Habilidades requeridas',
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
              child: const Text('Guardar Especialidad'),
            ),
          ],
        ),
      );
    }
  }
}
