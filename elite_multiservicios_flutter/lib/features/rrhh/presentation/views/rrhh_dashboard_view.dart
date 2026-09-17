import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/rrhh_state_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

/// Dashboard ejecutivo de Recursos Humanos
class RrhhDashboardView extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;

  const RrhhDashboardView({super.key, this.onNavigateToTab});

  @override
  State<RrhhDashboardView> createState() => _RrhhDashboardViewState();
}

class _RrhhDashboardViewState extends State<RrhhDashboardView> {
  final _rrhhService = RrhhStateService();

  @override
  void initState() {
    super.initState();
    _rrhhService.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _rrhhService.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado de bienvenida
              _buildHeader(isDark, isMobile),
              const SizedBox(height: 20),

              // Fila 1: KPIs Principales de Talento
              _buildMainKpis(isDark, isMobile),
              const SizedBox(height: 20),

              // Fila 2: Alertas y Avisos Prioritarios
              _buildAlertsSection(isDark, isMobile),
              const SizedBox(height: 24),

              // Fila 3: Distribución Operativa (Oficina vs Campo) y Telemetría de Asistencia
              if (isMobile) ...[
                _buildDistributionCard(isDark),
                const SizedBox(height: 16),
                _buildAttendanceTelemetryCard(isDark),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildDistributionCard(isDark)),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: _buildAttendanceTelemetryCard(isDark),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              // Fila 4: Actividad Reciente y Bitácora
              _buildRecentIncidentsAndMovements(isDark),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panel Ejecutivo de Recursos Humanos',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Visión general del personal de Elite Multiservicios, asignaciones, alertas contractuales y gestión laboral.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainKpis(bool isDark, bool isMobile) {
    final kpiCards = [
      RrhhKpiCard(
        title: 'Personal Activo',
        value: '${_rrhhService.activeEmployeesCount}',
        subtitle: '${_rrhhService.totalEmployeesCount} en registro histórico',
        icon: Icons.people_outline,
        color: const Color(0xFF2563EB),
        isDark: isDark,
      ),
      RrhhKpiCard(
        title: 'Personal en Campo',
        value: '${_rrhhService.fieldEmployeesCount}',
        subtitle: 'Asignados en sedes de clientes',
        icon: Icons.storefront_outlined,
        color: const Color(0xFF06B6D4),
        isDark: isDark,
      ),
      RrhhKpiCard(
        title: 'Personal en Oficina',
        value: '${_rrhhService.officeEmployeesCount}',
        subtitle: 'Sede central administrativa',
        icon: Icons.corporate_fare_outlined,
        color: const Color(0xFF8B5CF6),
        isDark: isDark,
      ),
      RrhhKpiCard(
        title: 'Postulantes Activos',
        value: '${_rrhhService.pendingApplicantsCount}',
        subtitle:
            '${_rrhhService.selectedApplicants.length} seleccionados para contratar',
        icon: Icons.person_search_outlined,
        color: const Color(0xFF10B981),
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Column(
        children: kpiCards
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: c,
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: kpiCards
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAlertsSection(bool isDark, bool isMobile) {
    final expiringCount = _rrhhService.contractsExpiringSoonCount;
    final pendingDocsCount = _rrhhService.pendingDocumentsEmployeesCount;
    final pendingLeavesCount = _rrhhService.pendingLeaves.length;
    final unassignedCount = _rrhhService.unassignedFieldEmployeesCount;

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
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Alertas y Requerimientos Administrativos Prioritarios',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildAlertBadge(
                icon: Icons.pending_actions,
                label: '$pendingLeavesCount Permisos pendientes de aprobación',
                color: pendingLeavesCount > 0
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981),
                isDark: isDark,
              ),
              _buildAlertBadge(
                icon: Icons.event_busy_outlined,
                label: '$expiringCount Contratos próximos a vencer (<45 días)',
                color: expiringCount > 0
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
                isDark: isDark,
              ),
              _buildAlertBadge(
                icon: Icons.folder_open_outlined,
                label:
                    '$pendingDocsCount Colaboradores con expediente físico incompleto',
                color: pendingDocsCount > 0
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF10B981),
                isDark: isDark,
              ),
              _buildAlertBadge(
                icon: Icons.person_pin_circle_outlined,
                label:
                    '$unassignedCount Personal operativo de campo disponible sin asignación',
                color: unassignedCount > 0
                    ? const Color(0xFF06B6D4)
                    : const Color(0xFF10B981),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBadge({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(bool isDark) {
    final areas = _rrhhService.areas;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distribución por Áreas Organizacionales',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Icon(
                Icons.pie_chart_outline,
                size: 18,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...areas.map((area) {
            final percent = _rrhhService.activeEmployeesCount > 0
                ? (area.activeEmployeesCount /
                      _rrhhService.activeEmployeesCount)
                : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(area.icon, size: 14, color: area.color),
                          const SizedBox(width: 6),
                          Text(
                            area.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${area.activeEmployeesCount} empleados (${(percent * 100).toStringAsFixed(0)}%)',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent.clamp(0.0, 1.0),
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(area.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttendanceTelemetryCard(bool isDark) {
    final incidents = _rrhhService.incidents;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sync_alt,
                    size: 18,
                    color: Color(0xFF06B6D4),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Telemetría Recibida de Asistencia (Mock)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Sincronizado',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF06B6D4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'RRHH no realiza el control de marcaciones biométricas, pero recibe los eventos de faltas y atrasos para resolución administrativa:',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),
          if (incidents.isEmpty)
            const Center(child: Text('Sin reportes de asistencia'))
          else
            ...incidents.take(3).map((inc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF161F30)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      inc.incidentType == 'FALTA_INJUSTIFICADA'
                          ? Icons.highlight_off
                          : inc.incidentType == 'ATRASO_REITERADO'
                          ? Icons.alarm_off
                          : Icons.verified,
                      size: 18,
                      color: inc.incidentType == 'FALTA_INJUSTIFICADA'
                          ? const Color(0xFFEF4444)
                          : inc.incidentType == 'ATRASO_REITERADO'
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                inc.employeeName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${inc.date.day}/${inc.date.month}/${inc.date.year}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            inc.description,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Resolución: ${inc.administrativeResolution}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecentIncidentsAndMovements(bool isDark) {
    final movements = _rrhhService.movements;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Últimos Movimientos y Trazabilidad Laboral',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Icon(
                Icons.timeline,
                size: 18,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (movements.isEmpty)
            const Text('Sin movimientos registrados.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movements.length,
              separatorBuilder: (sepCtx, index) => Divider(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                height: 16,
              ),
              itemBuilder: (ctx, index) {
                final mov = movements[index];
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.published_with_changes,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${mov.employeeName} (${mov.employeeCode})',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${mov.effectiveDate.day}/${mov.effectiveDate.month}/${mov.effectiveDate.year}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${mov.movementType.replaceAll('_', ' ')}: De "${mov.previousValue}" ➔ "${mov.newValue}".',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF334155),
                            ),
                          ),
                          Text(
                            'Justificación: ${mov.justification} (Autorizado por ${mov.authorizedBy})',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
