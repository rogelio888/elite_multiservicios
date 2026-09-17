import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_labor_management.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Vista de Gestión Laboral: Permisos, Vacaciones, Incidencias de Asistencia, Movimientos y Bajas.
class RrhhLaborView extends StatefulWidget {
  const RrhhLaborView({super.key});

  @override
  State<RrhhLaborView> createState() => _RrhhLaborViewState();
}

class _RrhhLaborViewState extends State<RrhhLaborView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _stateService = RrhhStateService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        final leaves = _stateService.leaves.where((l) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return l.employeeName.toLowerCase().contains(q) ||
              l.leaveType.toLowerCase().contains(q);
        }).toList();

        final vacations = _stateService.vacations.where((v) {
          if (_searchQuery.isEmpty) return true;
          return v.employeeName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
        }).toList();

        final incidents = _stateService.incidents.where((i) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return i.employeeName.toLowerCase().contains(q) ||
              i.title.toLowerCase().contains(q) ||
              i.type.toLowerCase().contains(q);
        }).toList();

        final movements = _stateService.movements.where((m) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return m.employeeName.toLowerCase().contains(q) ||
              m.type.toLowerCase().contains(q);
        }).toList();

        final exits = _stateService.exits.where((e) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return e.employeeName.toLowerCase().contains(q) ||
              e.reason.toLowerCase().contains(q);
        }).toList();

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // Header con TabBar
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
                              0xFFF59E0B,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.fact_check_outlined,
                            color: Color(0xFFF59E0B),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gestión Laboral & Novedades',
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
                                'Control de Permisos, Vacaciones, Telemetría de Asistencia (Atrasos/Memos), Trazabilidad y Desvinculaciones',
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
                          onPressed: () => _openActionDialog(context),
                          icon: Icon(
                            _tabController.index == 4
                                ? Icons.person_remove_outlined
                                : Icons.add,
                            size: 18,
                          ),
                          label: Text(
                            _getActionLabel(),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: _tabController.index == 4
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFF59E0B),
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
                          flex: 3,
                          child: TabBar(
                            controller: _tabController,
                            onTap: (_) => setState(() {}),
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: const Color(0xFFF59E0B),
                            unselectedLabelColor: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            indicatorColor: const Color(0xFFF59E0B),
                            indicatorWeight: 3,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: [
                              Tab(
                                text:
                                    'Permisos (${leaves.where((l) => l.status == "PENDIENTE").length} pend.)',
                              ),
                              Tab(
                                text:
                                    'Vacaciones (${vacations.where((v) => v.status == "PENDIENTE").length} pend.)',
                              ),
                              Tab(
                                text:
                                    'Incidencias / Memos (${incidents.length})',
                              ),
                              Tab(
                                text: 'Movimientos (${movements.length})',
                              ),
                              Tab(
                                text: 'Desvinculaciones (${exits.length})',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
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
                              hintText: 'Buscar colaborador...',
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
                    _buildLeavesList(leaves, isDark),
                    _buildVacationsList(vacations, isDark),
                    _buildIncidentsList(incidents, isDark),
                    _buildMovementsList(movements, isDark),
                    _buildExitsList(exits, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getActionLabel() {
    switch (_tabController.index) {
      case 0:
        return 'Solicitar Permiso';
      case 1:
        return 'Programar Vacaciones';
      case 2:
        return 'Registrar Incidencia';
      case 3:
        return 'Registrar Movimiento';
      case 4:
        return 'Registrar Desvinculación';
      default:
        return 'Nuevo Registro';
    }
  }

  // 1. Permisos
  Widget _buildLeavesList(List<RrhhLeaveRequest> list, bool isDark) {
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay permisos registrados',
        message: 'No se encontraron solicitudes de permisos o licencias.',
        icon: Icons.event_available,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        final isPending = req.status == 'PENDIENTE';

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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(
                    0xFFF59E0B,
                  ).withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.time_to_leave_outlined,
                    color: Color(0xFFF59E0B),
                    size: 20,
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
                            req.employeeName,
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
                            label: req.leaveType,
                            statusType: StatusType.info,
                          ),
                          const SizedBox(width: 8),
                          RrhhStatusChip(
                            label: req.status,
                            statusType: req.status == 'APROBADO'
                                ? StatusType.success
                                : (req.status == 'RECHAZADO'
                                      ? StatusType.danger
                                      : StatusType.warning),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Período: ${_formatDate(req.startDate)} al ${_formatDate(req.endDate)}  •  Duración: ${req.daysCount} día(s)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Motivo: ${req.reason}',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPending) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                    ),
                    tooltip: 'Aprobar Permiso',
                    onPressed: () {
                      _stateService.reviewLeave(req.id, 'APROBADO');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permiso Aprobado.'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFEF4444),
                    ),
                    tooltip: 'Rechazar Permiso',
                    onPressed: () {
                      _stateService.reviewLeave(req.id, 'RECHAZADO');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permiso Rechazado.'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Vacaciones
  Widget _buildVacationsList(List<RrhhVacationRequest> list, bool isDark) {
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay solicitudes de vacaciones',
        message: 'No se encontraron programaciones activas.',
        icon: Icons.beach_access_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        final isPending = req.status == 'PENDIENTE';

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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(
                    0xFF3B82F6,
                  ).withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.beach_access,
                    color: Color(0xFF3B82F6),
                    size: 20,
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
                            req.employeeName,
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
                            label: req.status,
                            statusType: req.status == 'APROBADO'
                                ? StatusType.success
                                : (req.status == 'RECHAZADO'
                                      ? StatusType.danger
                                      : StatusType.warning),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Período: ${_formatDate(req.startDate)} al ${_formatDate(req.endDate)}  •  Días Solicitados: ${req.daysRequested} días',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Saldo restante tras aprobación: ${req.remainingBalanceDays} días disponibles',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPending) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                    ),
                    tooltip: 'Aprobar Vacaciones',
                    onPressed: () {
                      _stateService.reviewVacation(req.id, 'APROBADO');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vacaciones Aprobadas.'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFEF4444),
                    ),
                    tooltip: 'Rechazar Vacaciones',
                    onPressed: () {
                      _stateService.reviewVacation(req.id, 'RECHAZADO');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vacaciones Rechazadas.'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. Incidencias y Telemetría Asistencia
  Widget _buildIncidentsList(List<RrhhIncident> list, bool isDark) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.sensors,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Telemetría de Asistencia: Los atrasos e inasistencias provienen de las marcaciones registradas '
                  'en la APK móvil del personal con geocercas y biometría.',
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
          child: list.isEmpty
              ? const RrhhEmptyState(
                  title: 'No hay incidencias registradas',
                  message:
                      'No se detectaron atrasos ni sanciones este período.',
                  icon: Icons.check_circle_outline,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final inc = list[index];
                    final isAtraso = inc.type == 'ATRASO';
                    final isFalta = inc.type == 'FALTA';

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
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isAtraso
                                    ? const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.12)
                                    : (isFalta
                                          ? const Color(
                                              0xFFEF4444,
                                            ).withValues(alpha: 0.12)
                                          : const Color(
                                              0xFF8B5CF6,
                                            ).withValues(alpha: 0.12)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isAtraso
                                    ? Icons.alarm_off
                                    : (isFalta
                                          ? Icons.person_off
                                          : Icons.warning_amber),
                                color: isAtraso
                                    ? const Color(0xFFF59E0B)
                                    : (isFalta
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF8B5CF6)),
                                size: 20,
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
                                        inc.employeeName,
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
                                        label: inc.type,
                                        statusType: isFalta
                                            ? StatusType.danger
                                            : StatusType.warning,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Gravedad: ${inc.severity}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${inc.title} — ${inc.description}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fecha: ${_formatDate(inc.date)}  •  Reportado por: ${inc.reportedBy}',
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

  // 4. Movimientos y Trazabilidad
  Widget _buildMovementsList(List<RrhhLaborMovement> list, bool isDark) {
    if (list.isEmpty) {
      return const RrhhEmptyState(
        title: 'No hay movimientos registrados',
        message: 'No se encontraron promociones ni cambios salariales.',
        icon: Icons.history,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final m = list[index];

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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(
                    0xFF2563EB,
                  ).withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF2563EB),
                    size: 20,
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
                            m.employeeName,
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
                            label: m.type,
                            statusType: StatusType.info,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.description,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Efectivo desde: ${_formatDate(m.date)}  •  Autorizado por: ${m.approvedBy}',
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
              ],
            ),
          ),
        );
      },
    );
  }

  // 5. Desvinculaciones (Bajas - Sin eliminación física)
  Widget _buildExitsList(List<RrhhExitRecord> list, bool isDark) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Garantía de Trazabilidad: Ningún registro de personal es eliminado. '
                  'Las desvinculaciones cambian el estado del colaborador a "INACTIVO" preservando su expediente, contratos, finiquito y antecedentes legales.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const RrhhEmptyState(
                  title: 'No hay desvinculaciones registradas',
                  message:
                      'No existen registros de bajas en el archivo histórico.',
                  icon: Icons.person_off_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final e = list[index];

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
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.12),
                              child: const Icon(
                                Icons.person_off,
                                color: Color(0xFFEF4444),
                                size: 20,
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
                                        e.employeeName,
                                        style: GoogleFonts.inter(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const RrhhStatusChip(
                                        label: 'INACTIVO',
                                        statusType: StatusType.danger,
                                      ),
                                      const SizedBox(width: 8),
                                      RrhhStatusChip(
                                        label: e.reason,
                                        statusType: StatusType.neutral,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Observaciones: ${e.exitInterviewNotes}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fecha de Baja: ${_formatDate(e.exitDate)}  •  Finiquito Estimado: Bs. ${e.severancePay.toStringAsFixed(2)}  •  Procesado por: ${e.processedBy}',
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

  void _openActionDialog(BuildContext context) {
    final currentTab = _tabController.index;
    if (currentTab == 4) {
      _openTerminationDialog(context);
    } else if (currentTab == 0) {
      _openLeaveDialog(context);
    } else if (currentTab == 1) {
      _openVacationDialog(context);
    } else if (currentTab == 2) {
      _openIncidentDialog(context);
    } else {
      _openMovementDialog(context);
    }
  }

  void _openTerminationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actives = _stateService.activeEmployees;
    if (actives.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay empleados activos para desvincular.'),
        ),
      );
      return;
    }

    String selectedEmpId = actives.first.id;
    String reason = 'Renuncia voluntaria';
    final notesCtrl = TextEditingController(
      text: 'Entrega de puesto y finiquito en regla.',
    );
    final severanceCtrl = TextEditingController(text: '4500.00');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.person_remove, color: Color(0xFFEF4444)),
              const SizedBox(width: 8),
              Text(
                'Registrar Desvinculación Laboral',
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
                DropdownButtonFormField<String>(
                  initialValue: selectedEmpId,
                  decoration: const InputDecoration(
                    labelText: 'Colaborador a Desvincular',
                  ),
                  items: actives
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.fullName} (${e.code})'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedEmpId = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: reason,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de Baja',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Renuncia voluntaria',
                      child: Text('Renuncia voluntaria'),
                    ),
                    DropdownMenuItem(
                      value: 'Fin de contrato a plazo fijo',
                      child: Text('Fin de contrato a plazo fijo'),
                    ),
                    DropdownMenuItem(
                      value: 'Despido justificado (Art. 16 LGT)',
                      child: Text('Despido justificado (Art. 16 LGT)'),
                    ),
                    DropdownMenuItem(
                      value: 'Mutuo acuerdo de partes',
                      child: Text('Mutuo acuerdo de partes'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => reason = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: severanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Finiquito / Liquidación estimada (Bs.)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones / Entrega de activos',
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
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () {
                _stateService.terminateEmployee(
                  employeeId: selectedEmpId,
                  reason: reason,
                  exitNotes: notesCtrl.text.trim(),
                  severancePay: double.tryParse(severanceCtrl.text) ?? 0,
                  processedBy: 'Lic. Laura Mendoza (RRHH)',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Desvinculación registrada. El colaborador pasó a estado INACTIVO sin pérdida de historial.',
                    ),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Procesar Baja'),
            ),
          ],
        ),
      ),
    );
  }

  void _openLeaveDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actives = _stateService.activeEmployees;
    if (actives.isEmpty) return;

    String selectedEmpId = actives.first.id;
    String leaveType = 'Médico';
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            'Solicitar Permiso / Licencia',
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
                DropdownButtonFormField<String>(
                  initialValue: selectedEmpId,
                  decoration: const InputDecoration(labelText: 'Colaborador'),
                  items: actives
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedEmpId = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: leaveType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Permiso',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Médico',
                      child: Text('Médico / Baja CPS'),
                    ),
                    DropdownMenuItem(
                      value: 'Personal',
                      child: Text('Asunto Personal'),
                    ),
                    DropdownMenuItem(
                      value: 'Duelo',
                      child: Text('Duelo Familiar'),
                    ),
                    DropdownMenuItem(
                      value: 'Matrimonio',
                      child: Text('Matrimonio'),
                    ),
                    DropdownMenuItem(
                      value: 'Capacitación',
                      child: Text('Capacitación / Estudio'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => leaveType = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Motivo del permiso',
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
                final emp = actives.firstWhere((e) => e.id == selectedEmpId);
                _stateService.requestLeave(
                  RrhhLeaveRequest(
                    id: 'LEV-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.fullName,
                    employeeCode: emp.code,
                    leaveType: leaveType,
                    startDate: DateTime.now().add(const Duration(days: 1)),
                    endDate: DateTime.now().add(const Duration(days: 2)),
                    totalDays: 1,
                    reason: reasonCtrl.text.trim().isNotEmpty
                        ? reasonCtrl.text.trim()
                        : 'Solicitud ordinaria de permiso',
                    status: 'PENDIENTE',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solicitud de permiso enviada a aprobación.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Enviar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }

  void _openVacationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actives = _stateService.activeEmployees;
    if (actives.isEmpty) return;

    String selectedEmpId = actives.first.id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            'Programar Vacaciones',
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
                DropdownButtonFormField<String>(
                  initialValue: selectedEmpId,
                  decoration: const InputDecoration(labelText: 'Colaborador'),
                  items: actives
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedEmpId = val);
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Período: 5 días hábiles a partir de la próxima semana.',
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
                final emp = actives.firstWhere((e) => e.id == selectedEmpId);
                _stateService.requestVacation(
                  RrhhVacationRequest(
                    id: 'VAC-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.fullName,
                    employeeCode: emp.code,
                    startDate: DateTime.now().add(const Duration(days: 7)),
                    endDate: DateTime.now().add(const Duration(days: 12)),
                    requestedDays: 5,
                    availableDaysBalance: 10,
                    status: 'PENDIENTE',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vacaciones programadas para revisión.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Programar'),
            ),
          ],
        ),
      ),
    );
  }

  void _openIncidentDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actives = _stateService.activeEmployees;
    if (actives.isEmpty) return;

    String selectedEmpId = actives.first.id;
    String type = 'MEMORANDUM';
    final titleCtrl = TextEditingController(
      text: 'Llamada de atención por atrasos reiterados',
    );
    final descCtrl = TextEditingController(
      text: 'Se detectaron atrasos mayores a 15 min en la APK.',
    );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            'Registrar Incidencia / Memorándum',
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
                DropdownButtonFormField<String>(
                  initialValue: selectedEmpId,
                  decoration: const InputDecoration(labelText: 'Colaborador'),
                  items: actives
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedEmpId = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Incidencia',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'MEMORANDUM',
                      child: Text('Memorándum Formal'),
                    ),
                    DropdownMenuItem(
                      value: 'ATRASO',
                      child: Text('Atraso Justificado/Observado'),
                    ),
                    DropdownMenuItem(
                      value: 'FALTA',
                      child: Text('Inasistencia Injustificada'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => type = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción de los hechos',
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
                final emp = actives.firstWhere((e) => e.id == selectedEmpId);
                _stateService.addIncident(
                  RrhhIncident(
                    id: 'INC-${DateTime.now().millisecondsSinceEpoch}',
                    employeeId: emp.id,
                    employeeName: emp.fullName,
                    employeeCode: emp.code,
                    date: DateTime.now(),
                    incidentType: type,
                    severity: 'MEDIA',
                    description: descCtrl.text.trim(),
                    administrativeResolution: titleCtrl.text.trim(),
                    registeredBy: 'Supervisión de Operaciones',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Incidencia guardada en el expediente.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Guardar Incidencia'),
            ),
          ],
        ),
      ),
    );
  }

  void _openMovementDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Los movimientos se generan automáticamente al reasignar puestos o modificar salarios en el expediente.',
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
