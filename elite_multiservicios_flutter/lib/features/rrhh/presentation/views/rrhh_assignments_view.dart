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
          if (a.status != 'ACTIVA') return false;
          if (_filterType != 'TODOS' && a.type != _filterType) return false;
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return a.employeeName.toLowerCase().contains(q) ||
              a.employeeCode.toLowerCase().contains(q) ||
              (a.clientCompanyName?.toLowerCase().contains(q) ?? false) ||
              (a.contractedServiceName?.toLowerCase().contains(q) ?? false) ||
              (a.officeArea?.toLowerCase().contains(q) ?? false) ||
              (a.originDescription?.toLowerCase().contains(q) ?? false);
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
                          const SizedBox(width: 8),
                          if (a.rotationNumber > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sync_alt,
                                    size: 12,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Rotación #${a.rotationNumber}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF64748B,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(
                                    0xFF64748B,
                                  ).withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.flag_outlined,
                                    size: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Puesto Inicial',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                      if (a.originDescription != null && a.rotationNumber > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.alt_route,
                                size: 14,
                                color: Color(0xFF3B82F6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Rotó desde: ',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  a.originDescription!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                              if (a.rotationReason != null &&
                                  a.rotationReason!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '• Motivo: ${a.rotationReason}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
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
                            onPressed: () =>
                                _openRotationHistoryDialog(context, a),
                            icon: const Icon(
                              Icons.history,
                              size: 14,
                              color: Color(0xFF3B82F6),
                            ),
                            label: Text(
                              _stateService
                                          .getRotationHistory(a.employeeId)
                                          .length >
                                      1
                                  ? 'Historial (${_stateService.getRotationHistory(a.employeeId).length})'
                                  : 'Ver Historial',
                              style: const TextStyle(color: Color(0xFF3B82F6)),
                            ),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(color: Color(0xFF3B82F6)),
                              textStyle: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonalIcon(
                            onPressed: () => _openReassignDialog(context, a),
                            icon: const Icon(Icons.swap_horiz, size: 14),
                            label: const Text('Rotar Destino / Turno'),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              textStyle: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
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
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cerrar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openReassignDialog(context, a);
                    },
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text('Rotar a Nuevo Destino'),
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
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.78,
            ),
            child: SingleChildScrollView(
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
                    // Dropdown de Empresa Cliente
                    DropdownButtonFormField<RrhhClientCompany>(
                      initialValue: selectedClient,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Empresa Cliente Destino *',
                      ),
                      items: clients
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
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
                        initialValue: selectedService,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Servicio Contratado y Sede *',
                        ),
                        items: selectedClient!.services
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  '${s.serviceName} (${s.branchLocation})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (s) {
                          setDlgState(() => selectedService = s);
                        },
                      ),
                  ] else ...[
                    // Dropdown de Área de Oficina
                    DropdownButtonFormField<String>(
                      initialValue: selectedArea,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Área en Oficina Central *',
                      ),
                      items: areas
                          .map(
                            (ar) => DropdownMenuItem(
                              value: ar.name,
                              child: Text(
                                ar.name,
                                overflow: TextOverflow.ellipsis,
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

                  // Nuevo Horario
                  DropdownButtonFormField<String>(
                    initialValue: currentSchedule,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Horario / Turno Asignado *',
                    ),
                    items: availableScheduleNames
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
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
                  DropdownButtonFormField<String>(
                    initialValue: selectedQuickReason,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Causal de Rotación *',
                    ),
                    items: quickReasons
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r,
                              overflow: TextOverflow.ellipsis,
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
