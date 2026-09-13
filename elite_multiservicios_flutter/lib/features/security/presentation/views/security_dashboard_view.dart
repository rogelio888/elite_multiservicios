import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Dashboard Ejecutivo de Seguridad para Elite Multiservicios.
/// Diseñado bajo principios de minimalismo formal, precisión suiza y alta densidad de valor.
class SecurityDashboardView extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const SecurityDashboardView({super.key, this.onNavigateToTab});

  @override
  State<SecurityDashboardView> createState() => _SecurityDashboardViewState();
}

class _SecurityDashboardViewState extends State<SecurityDashboardView>
    with SingleTickerProviderStateMixin {
  final _service = SecurityApiService();
  bool _isLoading = true;
  bool _isRefreshing = false;

  SecurityDashboardMetrics _metrics = const SecurityDashboardMetrics(
    totalUsers: 0,
    totalRoles: 0,
    totalAuditLogs: 0,
    activeSessions: 0,
  );
  List<AuditLog> _recentLogs = [];
  int _dbLatencyMs = 38;

  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadDashboardData();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    _spinController.repeat();

    try {
      final metricsFuture = _service.getDashboardMetrics();
      final logsFuture = _service.listAuditLogs(limit: 7, offset: 0);
      final serverMetricsFuture = _service.getServerMetrics();

      final results = await Future.wait([
        metricsFuture,
        logsFuture,
        serverMetricsFuture,
      ]);

      final metrics = results[0] as SecurityDashboardMetrics;
      final logs = results[1] as List<AuditLog>;
      final serverMetrics = results[2] as ServerMetricsResponse?;

      if (mounted) {
        setState(() {
          _metrics = metrics;
          _recentLogs = logs;
          if (serverMetrics != null && serverMetrics.databaseLatencyMs > 0) {
            _dbLatencyMs = serverMetrics.databaseLatencyMs;
          }
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } finally {
      if (mounted && _spinController.isAnimating) {
        _spinController.stop();
        _spinController.reset();
      }
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'Hace instantes';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
    return 'Hace ${difference.inDays}d';
  }

  String _humanizeAction(String action) {
    if (action.contains('LOGIN_SUCCESS')) {
      return 'Inicio de sesión exitoso';
    }
    if (action.contains('LOGIN_FAILED')) {
      return 'Intento fallido de autenticación';
    }
    if (action.contains('MFA_VERIFIED')) {
      return 'Segundo factor validado (MFA)';
    }
    if (action.contains('MFA_CHALLENGE')) {
      return 'Desafío 2FA emitido';
    }
    if (action.contains('PASSWORD_RESET') ||
        action.contains('PASSWORD_CHANGED')) {
      return 'Actualización de credenciales';
    }
    if (action.contains('USER_CREATED')) return 'Usuario registrado en sistema';
    if (action.contains('USER_UPDATED')) return 'Perfil de usuario modificado';
    if (action.contains('ROLE')) return 'Modificación de permisos RBAC';
    return action.replaceAll('_', ' ').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? Colors.white70 : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sincronizando estado operativo...',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

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
              // 1. Header Minimalista Responsivo
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 24),

              // 2. Cuadrícula de 4 Métricas Esenciales
              _buildKpiGrid(isDark),
              const SizedBox(height: 28),

              // 3. Bloque Central Asimétrico (Actividad Reciente + Gobernanza)
              LayoutBuilder(
                builder: (context, boxConstraints) {
                  final isBlockNarrow = boxConstraints.maxWidth < 1000;
                  if (isBlockNarrow) {
                    return Column(
                      children: [
                        _buildRecentActivitySection(isDark),
                        const SizedBox(height: 28),
                        _buildGovernanceSection(isDark),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 62,
                        child: _buildRecentActivitySection(isDark),
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        flex: 38,
                        child: _buildGovernanceSection(isDark),
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

  // --- 1. CABECERA EJECUTIVA ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard de Seguridad',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 22 : 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Supervisión de accesos, sesiones concurrentes y trazabilidad inmutable.',
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
        // Indicador de estado operativo en línea
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
                'En línea',
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
                '${_dbLatencyMs}ms',
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
          message: 'Actualizar telemetría',
          child: InkWell(
            onTap: _isRefreshing ? null : _loadDashboardData,
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
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
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

  // --- 2. GRID DE 4 KPIS ESENCIALES ---
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
              label: 'USUARIOS REGISTRADOS',
              value: '${_metrics.totalUsers}',
              subtext: 'Cuentas corporativas',
              icon: Icons.person_outline,
              onTap: () => widget.onNavigateToTab?.call(1),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'SESIONES CONCURRENTES',
              value: '${_metrics.activeSessions}',
              subtext: 'Dispositivos autenticados',
              icon: Icons.devices,
              onTap: () => widget.onNavigateToTab?.call(4),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'EVENTOS EN BITÁCORA',
              value: '${_metrics.totalAuditLogs}',
              subtext: 'Trazabilidad SHA-256',
              icon: Icons.shield_outlined,
              onTap: () => widget.onNavigateToTab?.call(3),
            ),
            _buildKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'MATRIZ DE ROLES',
              value: '${_metrics.totalRoles}',
              subtext: 'Políticas RBAC',
              icon: Icons.admin_panel_settings_outlined,
              onTap: () => widget.onNavigateToTab?.call(2),
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

  // --- 3. ACTIVIDAD RECIENTE (STREAM LINEAL) ---
  Widget _buildRecentActivitySection(bool isDark) {
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
                        'Actividad Reciente del Sistema',
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
                        'Últimos eventos autenticados y registrados en PostgreSQL',
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
                  onPressed: () => widget.onNavigateToTab?.call(3),
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
          if (_recentLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'No hay eventos registrados recientemente.',
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
              itemCount: _recentLogs.length,
              separatorBuilder: (ctx, index) => Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final log = _recentLogs[index];
                return _buildEventRow(isDark, log);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEventRow(bool isDark, AuditLog log) {
    final isFailure =
        log.result == 'FAILURE' ||
        log.result == 'BLOCKED' ||
        log.action.contains('FAILED');

    final statusColor = isFailure
        ? const Color(0xFFEF4444)
        : const Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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

          // Descripción y usuario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _humanizeAction(log.action),
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
                  log.userIdentifier ?? 'Sistema interno',
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

          // IP de origen
          if (log.ipAddress != null && log.ipAddress!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                log.ipAddress == '::1' ? 'Local' : log.ipAddress!,
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
            _getTimeAgo(log.timestamp),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. SECCIÓN DE GOBERNANZA & RESUMEN ---
  Widget _buildGovernanceSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta de Navegación Rápida
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
                  'Gestión y Gobernanza',
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
                icon: Icons.people_outline,
                title: 'Directorio de Usuarios',
                subtitle: 'Aprovisionamiento y credenciales',
                onTap: () => widget.onNavigateToTab?.call(1),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.admin_panel_settings_outlined,
                title: 'Políticas y Permisos RBAC',
                subtitle: 'Matriz canónica de autorización',
                onTap: () => widget.onNavigateToTab?.call(2),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.devices,
                title: 'Control de Sesiones',
                subtitle: 'Inspección y terminación forzada',
                onTap: () => widget.onNavigateToTab?.call(4),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildGovernanceItem(
                isDark: isDark,
                icon: Icons.speed_outlined,
                title: 'Telemetría del Servidor',
                subtitle: 'Rendimiento y consumo de recursos',
                onTap: () => widget.onNavigateToTab?.call(5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tarjeta de Integridad Criptográfica
        Container(
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
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF10B981)
                        : const Color(0xFF059669),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Integridad de Registro',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Cada evento de auditoría cuenta con firma SHA-256 inmutable almacenada en PostgreSQL.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
