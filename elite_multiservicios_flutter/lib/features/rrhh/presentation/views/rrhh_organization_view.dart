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

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        final area = areas[index];
        final positionsCount = _stateService.positions
            .where((p) => p.areaId == area.id)
            .length;
        final employeesCount = _stateService.activeEmployees
            .where((e) => e.area == area.name)
            .length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      area.code,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
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
                            area.name,
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
                            label: area.type,
                            statusType: area.type == 'CAMPO'
                                ? StatusType.success
                                : (area.type == 'OFICINA'
                                      ? StatusType.info
                                      : StatusType.warning),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        area.description,
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatPill(
                      label: 'Cargos',
                      value: '$positionsCount',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _buildStatPill(
                      label: 'Colaboradores',
                      value: '$employeesCount',
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
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

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final pos = positions[index];
        final empCount = _stateService.activeEmployees
            .where((e) => e.position == pos.title)
            .length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      pos.code,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
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
                            pos.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RrhhStatusChip(
                            label: pos.areaName,
                            statusType: StatusType.info,
                          ),
                          if (pos.requiresSpecialty) ...[
                            const SizedBox(width: 6),
                            const RrhhStatusChip(
                              label: 'Requiere Especialidad',
                              statusType: StatusType.warning,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rango Salarial: Bs. ${pos.minSalary.toStringAsFixed(0)} - Bs. ${pos.maxSalary.toStringAsFixed(0)}  •  Nivel: ${pos.level}',
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
                const SizedBox(width: 16),
                _buildStatPill(
                  label: 'Colaboradores',
                  value: '$empCount',
                  isDark: isDark,
                ),
              ],
            ),
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

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final spec = specialties[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      spec.code,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
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
                            spec.name,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          if (spec.requiresCertification) ...[
                            const SizedBox(width: 8),
                            const RrhhStatusChip(
                              label: 'Certificación Obligatoria',
                              statusType: StatusType.danger,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec.description,
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
    );
  }

  Widget _buildStatPill({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
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
