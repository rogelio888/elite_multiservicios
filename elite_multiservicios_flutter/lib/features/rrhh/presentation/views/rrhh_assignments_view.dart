import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_assignment.dart';
import '../../data/models/rrhh_schedule.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista de Asignaciones, Clientes con Multi-Servicio y Horarios/Turnos.
class RrhhAssignmentsView extends StatefulWidget {
  const RrhhAssignmentsView({super.key});

  @override
  State<RrhhAssignmentsView> createState() => _RrhhAssignmentsViewState();
}

class _RrhhAssignmentsViewState extends State<RrhhAssignmentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();
  String _searchQuery = '';
  String _filterType = 'TODOS'; // TODOS, OFICINA, CAMPO

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
        final assignments = _stateService.assignments.where((a) {
          if (_filterType != 'TODOS' && a.type != _filterType) return false;
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return a.employeeName.toLowerCase().contains(q) ||
              a.employeeCode.toLowerCase().contains(q) ||
              (a.clientCompanyName?.toLowerCase().contains(q) ?? false) ||
              (a.contractedServiceName?.toLowerCase().contains(q) ?? false) ||
              (a.officeArea?.toLowerCase().contains(q) ?? false);
        }).toList();

        final clients = _stateService.clientCompanies.where((c) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return c.name.toLowerCase().contains(q) ||
              c.industry.toLowerCase().contains(q);
        }).toList();

        final schedules = _stateService.schedules.where((s) {
          if (_searchQuery.isEmpty) return true;
          return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // Header Principal
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
                              0xFF10B981,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.work_history_outlined,
                            color: Color(0xFF10B981),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Asignaciones & Horarios',
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
                                'Destinos Oficina vs Campo (Clientes y Servicios contratados) y Gestión de Turnos',
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
                                ? 'Nueva Asignación'
                                : (_tabController.index == 1
                                      ? 'Nuevo Cliente / Servicio'
                                      : 'Nuevo Horario'),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
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
                            labelColor: const Color(0xFF10B981),
                            unselectedLabelColor: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            indicatorColor: const Color(0xFF10B981),
                            indicatorWeight: 3,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: [
                              Tab(
                                text:
                                    'Asignaciones de Personal (${assignments.length})',
                              ),
                              Tab(
                                text:
                                    'Clientes & Servicios (${clients.length})',
                              ),
                              Tab(
                                text: 'Horarios & Turnos (${schedules.length})',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (_tabController.index == 0) ...[
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'TODOS',
                                label: Text('Todos'),
                              ),
                              ButtonSegment(
                                value: 'OFICINA',
                                label: Text('Oficina'),
                              ),
                              ButtonSegment(
                                value: 'CAMPO',
                                label: Text('Campo'),
                              ),
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
                          const SizedBox(width: 12),
                        ],
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
                              hintText: 'Buscar colaborador, cliente...',
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
                    _buildAssignmentsList(assignments, isDark),
                    _buildClientsList(clients, isDark),
                    _buildSchedulesList(schedules, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssignmentsList(List<RrhhAssignment> list, bool isDark) {
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay asignaciones registradas',
        message:
            'No se encontraron asignaciones que coincidan con los filtros.',
        icon: Icons.assignment_late_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final a = list[index];
        final isOficina = a.type == 'OFICINA';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isOficina
                      ? const Color(0xFF2563EB).withValues(alpha: 0.12)
                      : const Color(0xFF10B981).withValues(alpha: 0.12),
                  child: Text(
                    a.employeeName.isNotEmpty ? a.employeeName[0] : '?',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: isOficina
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF10B981),
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
                            a.employeeName,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${a.employeeCode})',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RrhhEmployeeTypeBadge(type: a.type),
                          const Spacer(),
                          RrhhStatusChip(
                            label: a.status,
                            statusType: a.status == 'ACTIVA'
                                ? StatusType.success
                                : StatusType.neutral,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0B1324)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isOficina
                                  ? Icons.business
                                  : Icons.location_city_outlined,
                              size: 16,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isOficina
                                    ? 'Oficina Central: Área ${a.officeArea ?? "General"} • Cargo: ${a.officeRole ?? "Operativo"}'
                                    : 'Empresa Cliente: ${a.clientCompanyName ?? "N/A"}  •  Servicio: ${a.contractedServiceName ?? "General"}  •  Sede: ${a.workplaceBranch ?? "Principal"}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Horario: ${a.scheduleName}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(
                            Icons.supervisor_account,
                            size: 14,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Supervisor: ${a.supervisorName}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () => _openReassignDialog(context, a),
                            icon: const Icon(Icons.swap_horiz, size: 14),
                            label: const Text('Reasignar Destino / Turno'),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              textStyle: GoogleFonts.inter(fontSize: 11),
                            ),
                          ),
                        ],
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

  Widget _buildClientsList(List<RrhhClientCompany> clients, bool isDark) {
    if (clients.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay empresas cliente registradas',
        message: 'No se encontraron empresas con servicios contratados.',
        icon: Icons.corporate_fare_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
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
    return Column(
      children: [
        // Banner aclaratorio de delimitación con la APK de asistencia
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  void _openReassignDialog(BuildContext context, RrhhAssignment a) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Construir lista única de horarios disponibles
    final availableScheduleNames = <String>{};
    for (final s in _stateService.schedules) {
      availableScheduleNames.add('${s.name} (${s.formattedTimeRange})');
    }

    // Resolver initialValue garantizando que exista exactamente en items
    String initialSchedule;
    if (availableScheduleNames.contains(a.scheduleName)) {
      initialSchedule = a.scheduleName;
    } else {
      final match = _stateService.schedules.where(
        (s) => s.name == a.scheduleName || a.scheduleName.startsWith(s.name),
      );
      if (match.isNotEmpty) {
        initialSchedule =
            '${match.first.name} (${match.first.formattedTimeRange})';
      } else if (a.scheduleName.isNotEmpty) {
        availableScheduleNames.add(a.scheduleName);
        initialSchedule = a.scheduleName;
      } else if (availableScheduleNames.isNotEmpty) {
        initialSchedule = availableScheduleNames.first;
      } else {
        initialSchedule = 'Administrativo Central (08:30 - 17:30)';
        availableScheduleNames.add(initialSchedule);
      }
    }

    String currentSchedule = initialSchedule;
    final supervisorCtrl = TextEditingController(text: a.supervisorName);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            'Reasignar Horario y Supervisor',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Colaborador: ${a.employeeName}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: currentSchedule,
                  decoration: const InputDecoration(labelText: 'Nuevo Horario'),
                  items: availableScheduleNames
                      .map(
                        (name) => DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => currentSchedule = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: supervisorCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Supervisor Asignado',
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
                _stateService.assignEmployee(
                  employeeId: a.employeeId,
                  employeeName: a.employeeName,
                  employeeCode: a.employeeCode,
                  type: a.type,
                  clientCompanyId: a.clientCompanyId,
                  clientCompanyName: a.clientCompanyName,
                  contractedServiceName: a.contractedServiceName,
                  officeArea: a.officeArea,
                  officeRole: a.officeRole,
                  workplaceBranch: a.workplaceBranch,
                  scheduleName: currentSchedule,
                  supervisorName: supervisorCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reasignación guardada exitosamente.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Confirmar Reasignación'),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTab = _tabController.index;

    if (currentTab == 2) {
      // Nuevo Horario
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
                    labelText:
                        'Nombre del Turno (ej: Turno Tarde 14:00 - 22:00)',
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para asignar personal nuevo, utilice el botón "Contratar" en la sección de Personal o seleccione "Reasignar Destino".',
          ),
        ),
      );
    }
  }
}
