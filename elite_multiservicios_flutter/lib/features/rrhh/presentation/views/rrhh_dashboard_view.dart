import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/rrhh_api_service.dart';
import '../../data/services/rrhh_state_service.dart';

/// Dashboard Ejecutivo de Recursos Humanos para Elite Multiservicios.
/// Diseñado bajo principios de minimalismo formal, precisión suiza y alta densidad de valor.
class RrhhDashboardView extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;

  const RrhhDashboardView({super.key, this.onNavigateToTab});

  @override
  State<RrhhDashboardView> createState() => _RrhhDashboardViewState();
}

class _RrhhDashboardViewState extends State<RrhhDashboardView>
    with SingleTickerProviderStateMixin {
  final _rrhhService = RrhhStateService();
  final _apiService = RrhhApiService();
  RrhhDashboardMetricsResponse? _metrics;
  List<RrhhRecentMovementDto>? _serverMovements;
  bool _isRefreshing = false;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _rrhhService.addListener(_onStateChange);
    _loadBackendData();
  }

  Future<void> _loadBackendData() async {
    try {
      final metrics = await _apiService.getDashboardMetrics();
      final movements = await _apiService.getRecentMovements(limit: 10);
      if (mounted) {
        setState(() {
          _metrics = metrics;
          _serverMovements = movements;
        });
      }
    } catch (_) {
      // Manejo silencioso con fallback local
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _rrhhService.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    _spinController.repeat();
    await _loadBackendData();
    if (mounted) {
      setState(() => _isRefreshing = false);
      _spinController.stop();
      _spinController.reset();
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'Hace instantes';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
    return 'Hace ${difference.inDays}d';
  }

  String _humanizeMovementType(String type) {
    switch (type) {
      case 'ALTA_PERSONAL':
        return 'Alta y Contratación de Personal';
      case 'REASIGNACION_SEDE':
        return 'Reasignación de Sede Operativa';
      case 'CAMBIO_CARGO':
        return 'Promoción o Cambio de Cargo';
      case 'INCREMENTO_SALARIAL':
        return 'Ajuste e Incremento Salarial';
      case 'BAJA_PERSONAL':
        return 'Desvinculación / Baja Registrada';
      case 'PERMISO_APROBADO':
        return 'Licencia / Permiso Concedido';
      default:
        return type.replaceAll('_', ' ').toLowerCase();
    }
  }

  Color _getMovementColor(String type) {
    switch (type) {
      case 'ALTA_PERSONAL':
      case 'INCREMENTO_SALARIAL':
        return const Color(0xFF10B981);
      case 'REASIGNACION_SEDE':
      case 'CAMBIO_CARGO':
        return const Color(0xFF3B82F6);
      case 'BAJA_PERSONAL':
        return const Color(0xFFEF4444);
      case 'PERMISO_APROBADO':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 36,
            vertical: isNarrow ? 20 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Ejecutiva Responsiva (Estilo Imagen 2)
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 24),

              // 2. Cuadrícula de 4 Métricas Esenciales (KPI Grid)
              _buildKpiGrid(isDark),
              const SizedBox(height: 20),

              // 3. Cinta de Requerimientos y Alertas Administrativas (Discreta y Prolija)
              _buildAlertsBar(isDark),
              const SizedBox(height: 24),

              // 4. Bloque Asimétrico Central (Trazabilidad Laboral + Gestión y Operaciones)
              LayoutBuilder(
                builder: (context, boxConstraints) {
                  final isBlockNarrow = boxConstraints.maxWidth < 1000;
                  if (isBlockNarrow) {
                    return Column(
                      children: [
                        _buildRecentMovementsSection(isDark),
                        const SizedBox(height: 24),
                        _buildGovernanceSection(isDark),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 62,
                        child: _buildRecentMovementsSection(isDark),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 38,
                        child: _buildGovernanceSection(isDark),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // 5. Fila Inferior: Distribución por Áreas y Telemetría de Asistencia
              LayoutBuilder(
                builder: (context, boxConstraints) {
                  final isLowerNarrow = boxConstraints.maxWidth < 1000;
                  if (isLowerNarrow) {
                    return Column(
                      children: [
                        _buildDistributionCard(isDark),
                        const SizedBox(height: 20),
                        _buildAttendanceTelemetryCard(isDark),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildDistributionCard(isDark),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: _buildAttendanceTelemetryCard(isDark),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // --- 1. CABECERA EJECUTIVA (ESTILO IMAGEN 2) ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard de Recursos Humanos',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 22 : 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Supervisión de personal, asignaciones operativas y ciclo laboral de colaboradores.',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 12.5 : 14,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final statusPill = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Indicador de estado operativo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'En nómina',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_rrhhService.activeEmployeesCount} activos',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Botón de sincronización manual
        Tooltip(
          message: 'Actualizar métricas',
          child: InkWell(
            onTap: _isRefreshing ? null : _handleRefresh,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF111827)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: _isRefreshing
                  ? RotationTransition(
                      turns: _spinController,
                      child: const Icon(
                        Icons.refresh,
                        size: 16,
                        color: Color(0xFF6366F1),
                      ),
                    )
                  : Icon(
                      Icons.refresh,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
            ),
          ),
        ),
      ],
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleCol,
          const SizedBox(height: 14),
          statusPill,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: titleCol),
        const SizedBox(width: 24),
        statusPill,
      ],
    );
  }

  // --- 2. GRID DE 4 KPIS ESENCIALES (ESTILO IMAGEN 2) ---
  Widget _buildKpiGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colCount = constraints.maxWidth < 480
            ? 1
            : (constraints.maxWidth < 800 ? 2 : 4);
        final cardWidth =
            (constraints.maxWidth - ((colCount - 1) * 16)) / colCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'PERSONAL ACTIVO',
              value:
                  '${_metrics?.activeEmployeesCount ?? _rrhhService.activeEmployeesCount}',
              subtext:
                  '${_metrics?.totalEmployeesCount ?? _rrhhService.totalEmployeesCount} en registro histórico',
              icon: Icons.people_outline,
              onTap: () => widget.onNavigateToTab?.call(11),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'PERSONAL EN CAMPO',
              value:
                  '${_metrics?.fieldEmployeesCount ?? _rrhhService.fieldEmployeesCount}',
              subtext: 'Asignados en sedes de clientes',
              icon: Icons.storefront_outlined,
              onTap: () => widget.onNavigateToTab?.call(13),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'PERSONAL EN OFICINA',
              value:
                  '${_metrics?.officeEmployeesCount ?? _rrhhService.officeEmployeesCount}',
              subtext: 'Sede central administrativa',
              icon: Icons.corporate_fare_outlined,
              onTap: () => widget.onNavigateToTab?.call(11),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'POSTULANTES ACTIVOS',
              value:
                  '${_metrics?.pendingApplicantsCount ?? _rrhhService.pendingApplicantsCount}',
              subtext:
                  '${_metrics?.selectedApplicantsCount ?? _rrhhService.selectedApplicants.length} seleccionados para contrato',
              icon: Icons.person_search_outlined,
              onTap: () => widget.onNavigateToTab?.call(11),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required bool isDark,
    required double width,
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return _MinimalHoverCard(
      isDark: isDark,
      width: width,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  icon,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.0,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtext,
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
    );
  }

  // --- 3. BARRA DISCRETA DE REQUERIMIENTOS Y ALERTAS (PROLIJA Y COMPACTA) ---
  Widget _buildAlertsBar(bool isDark) {
    final pendingLeavesCount = _rrhhService.pendingLeaves.length;
    final expiringCount = _rrhhService.contractsExpiringSoonCount;
    final pendingDocsCount = _rrhhService.pendingDocumentsEmployeesCount;
    final unassignedCount = _rrhhService.unassignedFieldEmployeesCount;

    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notification_important_outlined,
                size: 15,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 6),
              Text(
                'Requerimientos:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                ),
              ),
            ],
          ),
          _buildAlertChip(
            label: 'Permisos por Aprobar',
            count: pendingLeavesCount,
            color: pendingLeavesCount > 0
                ? const Color(0xFFF59E0B)
                : const Color(0xFF10B981),
            isDark: isDark,
            onTap: () => widget.onNavigateToTab?.call(14),
          ),
          _buildAlertChip(
            label: 'Contratos por Vencer (<45d)',
            count: expiringCount,
            color: expiringCount > 0
                ? const Color(0xFFEF4444)
                : const Color(0xFF10B981),
            isDark: isDark,
            onTap: () => widget.onNavigateToTab?.call(11),
          ),
          _buildAlertChip(
            label: 'Expedientes Incompletos',
            count: pendingDocsCount,
            color: pendingDocsCount > 0
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF10B981),
            isDark: isDark,
            onTap: () => widget.onNavigateToTab?.call(11),
          ),
          _buildAlertChip(
            label: 'Campo sin Asignación',
            count: unassignedCount,
            color: unassignedCount > 0
                ? const Color(0xFF06B6D4)
                : const Color(0xFF10B981),
            isDark: isDark,
            onTap: () => widget.onNavigateToTab?.call(13),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertChip({
    required String label,
    required int count,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final bg = isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: count > 0
                    ? color
                    : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. ACTIVIDAD RECIENTE Y TRAZABILIDAD (ESTILO IMAGEN 2) ---
  Widget _buildRecentMovementsSection(bool isDark) {
    final serverList = _serverMovements;
    final hasServer = serverList != null && serverList.isNotEmpty;
    final localList = _rrhhService.movements;
    final itemCount = hasServer
        ? (serverList.length > 5 ? 5 : serverList.length)
        : (localList.length > 5 ? 5 : localList.length);

    return Container(
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
          // Header de sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividad Reciente y Trazabilidad Laboral',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Últimos cambios de puesto, asignaciones y eventos de personal',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => widget.onNavigateToTab?.call(14),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver bitácora',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 13),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),

          // Lista de eventos
          if (itemCount == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'No hay movimientos laborales registrados recientemente.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (ctx, index) => Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final type = hasServer
                    ? serverList[index].type
                    : localList[index].movementType;
                final statusColor = _getMovementColor(type);
                final employeeName = hasServer
                    ? serverList[index].employeeName
                    : localList[index].employeeName;
                final employeeCode = hasServer
                    ? serverList[index].employeeCode
                    : localList[index].employeeCode;
                final detail = hasServer
                    ? serverList[index].description
                    : 'Justificación: ${localList[index].justification}';
                final rightCol = hasServer
                    ? serverList[index].workplace
                    : localList[index].newValue;
                final timestamp = hasServer
                    ? serverList[index].timestamp
                    : localList[index].effectiveDate;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Punto discreto de estado
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Descripción y colaborador
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _humanizeMovementType(type),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$employeeName ($employeeCode) • $detail',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Valor anterior / nuevo valor o sede
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          rightCol,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),

                      // Tiempo relativo
                      Text(
                        _getTimeAgo(timestamp),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // --- 5. SECCIÓN DE GESTIÓN & OPERACIONES (ESTILO IMAGEN 2) ---
  Widget _buildGovernanceSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta de Accesos Rápidos
        Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Text(
                  'Gestión y Operaciones RRHH',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.badge_outlined,
                title: 'Directorio de Personal',
                subtitle: 'Expedientes digitales y contratación',
                onTap: () => widget.onNavigateToTab?.call(11),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.account_tree_outlined,
                title: 'Estructura Organizacional',
                subtitle: 'Áreas, cargos y organigrama',
                onTap: () => widget.onNavigateToTab?.call(12),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.assignment_ind_outlined,
                title: 'Asignaciones a Clientes',
                subtitle: 'Personal en campo por sede/empresa',
                onTap: () => widget.onNavigateToTab?.call(13),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.event_note_outlined,
                title: 'Permisos y Bajas Laborales',
                subtitle: 'Licencias, rotaciones y desvinculaciones',
                onTap: () => widget.onNavigateToTab?.call(14),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.analytics_outlined,
                title: 'Centro de Reportes & Nómina',
                subtitle: 'Planillas oficiales de sueldos y salarios',
                onTap: () => widget.onNavigateToTab?.call(15),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tarjeta de Conformidad Legal (Idéntica a la tarjeta inferior de Imagen 2)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conformidad Laboral y OVT',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Planillas y contratos generados conforme a la Ley General del Trabajo y normativas de la plataforma OVT del Ministerio de Trabajo.',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGovernanceItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. DISTRIBUCIÓN POR ÁREAS ORGANIZACIONALES ---
  // --- 6. DISTRIBUCIÓN POR ÁREAS ORGANIZACIONALES (ESTILO IMAGEN 2) ---
  Widget _buildDistributionCard(bool isDark) {
    final areas = _rrhhService.areas;
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección con divider idéntico a Imagen 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distribución por Áreas Organizacionales',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dotación activa y porcentaje por departamento operativo',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pie_chart_outline,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),

          // Lista de áreas estilizadas
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: areas.map((area) {
                final percent = _rrhhService.activeEmployeesCount > 0
                    ? (area.activeEmployeesCount /
                          _rrhhService.activeEmployeesCount)
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: area.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(area.icon, size: 13, color: area.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              area.name,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${area.activeEmployeesCount} colab.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: area.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(percent * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: area.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: percent.clamp(0.0, 1.0),
                          backgroundColor: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(area.color),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- 7. TELEMETRÍA DE ASISTENCIA (STREAM LINEAL ESTILO IMAGEN 2) ---
  Widget _buildAttendanceTelemetryCard(bool isDark) {
    final incidents = _rrhhService.incidents;
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección con pill idéntico a Imagen 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Telemetría Recibida de Asistencia',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Eventos de faltas, atrasos y méritos para resolución RIT',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF06B6D4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sincronizado',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF06B6D4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),

          // Lista en stream lineal sin cajas toscas (idéntico a Imagen 2)
          if (incidents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text(
                  'Sin reportes de asistencia pendientes.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length > 3 ? 3 : incidents.length,
              separatorBuilder: (ctx, index) => Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final inc = incidents[index];
                final isFalta = inc.incidentType == 'FALTA_INJUSTIFICADA';
                final isAtraso = inc.incidentType == 'ATRASO_REITERADO';
                final statusColor = isFalta
                    ? const Color(0xFFEF4444)
                    : (isAtraso
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF10B981));

                final badgeLabel = isFalta
                    ? 'Falta'
                    : (isAtraso ? 'Demora' : 'Mérito');

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Punto indicador discreto
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Detalles del evento
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  inc.employeeName,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFFF1F5F9)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: statusColor.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    badgeLabel,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${inc.date.day}/${inc.date.month}/${inc.date.year}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: isDark
                                        ? const Color(0xFF475569)
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              inc.description,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.gavel_outlined,
                                  size: 12,
                                  color: Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Resolución: ${inc.administrativeResolution}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6366F1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Widget para tarjetas minimalistas con micro-interacción al hover.
class _MinimalHoverCard extends StatefulWidget {
  final bool isDark;
  final double width;
  final Widget child;
  final VoidCallback onTap;

  const _MinimalHoverCard({
    required this.isDark,
    required this.width,
    required this.child,
    required this.onTap,
  });

  @override
  State<_MinimalHoverCard> createState() => _MinimalHoverCardState();
}

class _MinimalHoverCardState extends State<_MinimalHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        width: widget.width,
        transform: Matrix4.translationValues(0.0, _isHovered ? -2.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? (widget.isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1))
                : (widget.isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0)),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.25 : 0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(10),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
