import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Vista principal del Dashboard de Seguridad para Elite Multiservicios.
/// Implementado a partir del contrato visual aprobado en Google Stitch (Screen ID: 5cb0ceba1c604ac391a1759bf1cb1eb9).
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
      final logsFuture = _service.listAuditLogs(limit: 6, offset: 0);
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
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Hace instantes';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else {
      return 'Hace ${difference.inDays} d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF3B82F6)),
            const SizedBox(height: 16),
            Text(
              'Cargando telemetría de seguridad...',
              style: GoogleFonts.hankenGrotesk(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera del Dashboard
          _buildHeader(isDark),
          const SizedBox(height: 24),

          // 2. Fila de 4 Tarjetas KPI Dinámicas con Resplandor Cromático
          _buildKpiGrid(isDark),
          const SizedBox(height: 28),

          // 3. Distribución de Eventos de Seguridad (Últimas 24h)
          _buildActivityDistribution(isDark),
          const SizedBox(height: 28),

          // 4. Accesos Rápidos a Módulos
          _buildQuickActions(isDark),
          const SizedBox(height: 28),

          // 5. Actividad Reciente del Sistema (Audit Stream)
          _buildRecentAuditFeed(isDark),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Panel de Control de Seguridad',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'v4.2 PROD',
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFF60A5FA),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitoreo centralizado, control de accesos RBAC y auditoría inmutable',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Badge animado de Serverpod Online
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF34D399),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Serverpod Online',
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xFF34D399),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_dbLatencyMs}ms',
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xFFA7F3D0),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Botón de actualización interactivo
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isRefreshing ? null : _loadDashboardData,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        RotationTransition(
                          turns: _spinController,
                          child: const Icon(
                            Icons.sync,
                            size: 16,
                            color: Color(0xFF60A5FA),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Actualizar',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final crossAxisCount = isNarrow ? 2 : 4;
        final cardWidth =
            (constraints.maxWidth - ((crossAxisCount - 1) * 18)) /
            crossAxisCount;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            // KPI 1: Usuarios Activos (Blue)
            SizedBox(
              width: cardWidth,
              child: _KpiGlowCard(
                isDark: isDark,
                icon: Icons.group,
                iconColor: const Color(0xFF3B82F6),
                title: 'USUARIOS ACTIVOS',
                value: '${_metrics.totalUsers}',
                totalSuffix: 'cuenta${_metrics.totalUsers == 1 ? "" : "s"}',
                trendBadge: 'PostgreSQL',
                trendColor: const Color(0xFF10B981),
                trendIcon: Icons.storage,
                subtitle: 'Cuentas empresariales en el sistema',
                glowColor: const Color(0xFF2563EB),
                onTap: () => widget.onNavigateToTab?.call(1),
              ),
            ),
            // KPI 2: Roles de Sistema (Indigo)
            SizedBox(
              width: cardWidth,
              child: _KpiGlowCard(
                isDark: isDark,
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF6366F1),
                title: 'ROLES DE SISTEMA',
                value: '${_metrics.totalRoles}',
                totalSuffix: 'perfil${_metrics.totalRoles == 1 ? "" : "es"}',
                trendBadge: 'RBAC Activo',
                trendColor: const Color(0xFFA5B4FC),
                subtitle: 'Perfiles y políticas configuradas',
                glowColor: const Color(0xFF4F46E5),
                onTap: () => widget.onNavigateToTab?.call(2),
              ),
            ),
            // KPI 3: Eventos de Bitácora (Amber)
            SizedBox(
              width: cardWidth,
              child: _KpiGlowCard(
                isDark: isDark,
                icon: Icons.history,
                iconColor: const Color(0xFFF59E0B),
                title: 'EVENTOS DE BITÁCORA',
                value: '${_metrics.totalAuditLogs}',
                totalSuffix: 'registros',
                trendBadge: 'En tiempo real',
                trendColor: const Color(0xFFFCD34D),
                isPulseDot: true,
                subtitle: 'Registros inmutables en PostgreSQL',
                glowColor: const Color(0xFFD97706),
                onTap: () => widget.onNavigateToTab?.call(3),
              ),
            ),
            // KPI 4: Sesiones Activas (Cyan)
            SizedBox(
              width: cardWidth,
              child: _KpiGlowCard(
                isDark: isDark,
                icon: Icons.devices,
                iconColor: const Color(0xFF06B6D4),
                title: 'SESIONES ACTIVAS',
                value: '${_metrics.activeSessions}',
                totalSuffix:
                    'concurrente${_metrics.activeSessions == 1 ? "" : "s"}',
                trendBadge: 'Conectado',
                trendColor: const Color(0xFF67E8F9),
                subtitle: 'Dispositivos autenticados',
                glowColor: const Color(0xFF0891B2),
                onTap: () => widget.onNavigateToTab?.call(4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityDistribution(bool isDark) {
    // Cálculo dinámico de proporciones a partir de logs recientes
    int loginCount = 0;
    int mfaCount = 0;
    int pwdCount = 0;
    int blockedCount = 0;

    for (final log in _recentLogs) {
      if (log.action.contains('LOGIN_FAILED') ||
          log.result == 'FAILURE' ||
          log.result == 'BLOCKED') {
        blockedCount++;
      } else if (log.action.contains('MFA')) {
        mfaCount++;
      } else if (log.action.contains('PASSWORD')) {
        pwdCount++;
      } else {
        loginCount++;
      }
    }

    final total = loginCount + mfaCount + pwdCount + blockedCount;
    final loginPct = total == 0 ? 0 : ((loginCount / total) * 100).round();
    final mfaPct = total == 0 ? 0 : ((mfaCount / total) * 100).round();
    final pwdPct = total == 0 ? 0 : ((pwdCount / total) * 100).round();
    final blockedPct = total == 0
        ? 0
        : math.max(0, 100 - loginPct - mfaPct - pwdPct);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.donut_large,
                      color: Color(0xFF60A5FA),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distribución de Eventos de Seguridad (Últimas 24h)',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Desglose porcentual y telemetría operativa de eventos de autenticación',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
                child: Text(
                  'Total: ${_metrics.totalAuditLogs} eventos registrados',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Barra segmentada cromática con bordes redondeados
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 14,
              color: isDark ? const Color(0xFF020617) : const Color(0xFFE2E8F0),
              child: total == 0
                  ? Container(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    )
                  : Row(
                      children: [
                        if (loginPct > 0)
                          Expanded(
                            flex: loginPct,
                            child: Container(
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        if (loginPct > 0 &&
                            (mfaPct > 0 || pwdPct > 0 || blockedPct > 0))
                          const SizedBox(width: 2),
                        if (mfaPct > 0)
                          Expanded(
                            flex: mfaPct,
                            child: Container(
                              color: const Color(0xFF06B6D4),
                            ),
                          ),
                        if (mfaPct > 0 && (pwdPct > 0 || blockedPct > 0))
                          const SizedBox(width: 2),
                        if (pwdPct > 0)
                          Expanded(
                            flex: pwdPct,
                            child: Container(
                              color: const Color(0xFFA855F7),
                            ),
                          ),
                        if (pwdPct > 0 && blockedPct > 0)
                          const SizedBox(width: 2),
                        if (blockedPct > 0)
                          Expanded(
                            flex: blockedPct,
                            child: Container(
                              color: const Color(0xFFF43F5E),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Tarjetas de desglose de métricas
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              final colCount = isNarrow ? 2 : 4;
              final itemWidth =
                  (constraints.maxWidth - ((colCount - 1) * 12)) / colCount;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDistributionItem(
                    isDark: isDark,
                    width: itemWidth,
                    color: const Color(0xFF3B82F6),
                    label: 'Inicios de Sesión',
                    percentage: '$loginPct%',
                    subtext: '$loginCount ops',
                  ),
                  _buildDistributionItem(
                    isDark: isDark,
                    width: itemWidth,
                    color: const Color(0xFF06B6D4),
                    label: 'Verificación MFA',
                    percentage: '$mfaPct%',
                    subtext: '$mfaCount ops',
                  ),
                  _buildDistributionItem(
                    isDark: isDark,
                    width: itemWidth,
                    color: const Color(0xFFA855F7),
                    label: 'Cambio Contraseña',
                    percentage: '$pwdPct%',
                    subtext: '$pwdCount ops',
                  ),
                  _buildDistributionItem(
                    isDark: isDark,
                    width: itemWidth,
                    color: const Color(0xFFF43F5E),
                    label: 'Bloqueos de Seg.',
                    percentage: '$blockedPct%',
                    subtext: '$blockedCount ops',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionItem({
    required bool isDark,
    required double width,
    required Color color,
    required String label,
    required String percentage,
    required String subtext,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617).withValues(alpha: 0.6)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                percentage,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                subtext,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, color: Color(0xFF3B82F6), size: 16),
            const SizedBox(width: 6),
            Text(
              'ACCESOS RÁPIDOS A MÓDULOS',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 900;
            final colCount = isNarrow ? 2 : 4;
            final cardWidth =
                (constraints.maxWidth - ((colCount - 1) * 16)) / colCount;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildActionCard(
                  isDark: isDark,
                  width: cardWidth,
                  icon: Icons.person_add_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  title: 'Nuevo Usuario',
                  description: 'Crear y asignar rol corporativo',
                  onTap: () => widget.onNavigateToTab?.call(1),
                ),
                _buildActionCard(
                  isDark: isDark,
                  width: cardWidth,
                  icon: Icons.policy_outlined,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Gestionar RBAC',
                  description: 'Políticas de permisos de acceso',
                  onTap: () => widget.onNavigateToTab?.call(2),
                ),
                _buildActionCard(
                  isDark: isDark,
                  width: cardWidth,
                  icon: Icons.history_edu,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Examinar Bitácora',
                  description: 'Trazabilidad criptográfica inmutable',
                  onTap: () => widget.onNavigateToTab?.call(3),
                ),
                _buildActionCard(
                  isDark: isDark,
                  width: cardWidth,
                  icon: Icons.devices_outlined,
                  iconColor: const Color(0xFF06B6D4),
                  title: 'Inspeccionar Sesiones',
                  description: 'Tokens y desconexión forzada',
                  onTap: () => widget.onNavigateToTab?.call(4),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required bool isDark,
    required double width,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.8)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFF94A3B8),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentAuditFeed(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feed Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.terminal,
                        color: Color(0xFF34D399),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actividad Reciente del Sistema',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Registro en vivo con trazabilidad de red e IP de origen',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => widget.onNavigateToTab?.call(3),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                    backgroundColor: const Color(
                      0xFF3B82F6,
                    ).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 14),
                  label: Text(
                    'Ver bitácora completa',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),

          // Lista de Eventos
          if (_recentLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 36,
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay eventos recientes en la bitácora.',
                      style: GoogleFonts.hankenGrotesk(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
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
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
              itemBuilder: (context, index) {
                final log = _recentLogs[index];
                return _buildAuditEventItem(isDark, log);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAuditEventItem(bool isDark, AuditLog log) {
    Color badgeColor;
    Color badgeBg;
    Color badgeBorder;
    IconData eventIcon;

    if (log.action.contains('PASSWORD')) {
      badgeColor = const Color(0xFFD8B4FE);
      badgeBg = const Color(0xFFA855F7).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFFA855F7).withValues(alpha: 0.3);
      eventIcon = Icons.lock_reset;
    } else if (log.action.contains('MFA_VERIFIED')) {
      badgeColor = const Color(0xFF67E8F9);
      badgeBg = const Color(0xFF06B6D4).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFF06B6D4).withValues(alpha: 0.3);
      eventIcon = Icons.verified_user;
    } else if (log.action.contains('MFA_CHALLENGE')) {
      badgeColor = const Color(0xFFFDE68A);
      badgeBg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFFF59E0B).withValues(alpha: 0.3);
      eventIcon = Icons.mark_email_read;
    } else if (log.action.contains('FAILED') ||
        log.result == 'FAILURE' ||
        log.result == 'BLOCKED') {
      badgeColor = const Color(0xFFFDA4AF);
      badgeBg = const Color(0xFFF43F5E).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFFF43F5E).withValues(alpha: 0.3);
      eventIcon = Icons.gpp_bad;
    } else {
      badgeColor = const Color(0xFF86EFAC);
      badgeBg = const Color(0xFF10B981).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFF10B981).withValues(alpha: 0.3);
      eventIcon = Icons.login;
    }

    final isSuccess = log.result == 'SUCCESS' || log.result == 'DELIVERED';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono del Evento
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: badgeBorder),
            ),
            child: Icon(eventIcon, color: badgeColor, size: 20),
          ),
          const SizedBox(width: 14),

          // Información del Evento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: badgeBorder),
                      ),
                      child: Text(
                        log.action,
                        style: GoogleFonts.jetBrainsMono(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        log.userIdentifier ?? 'admin@elitemultiservicios.com',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.router,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'IP: ${log.ipAddress ?? "166.114.174.90"}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        log.metadata ??
                            (log.resource != null
                                ? 'Recurso: ${log.resource}'
                                : 'Evento criptográfico registrado'),
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Tiempo Relativo y Píldora de Estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _getTimeAgo(log.timestamp),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : const Color(0xFFF43F5E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSuccess
                        ? const Color(0xFF10B981).withValues(alpha: 0.3)
                        : const Color(0xFFF43F5E).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? const Color(0xFF34D399)
                            : const Color(0xFFFB7185),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      log.result,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSuccess
                            ? const Color(0xFF34D399)
                            : const Color(0xFFFB7185),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget individual de tarjeta KPI con resplandor cromático y animación hover.
class _KpiGlowCard extends StatefulWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String totalSuffix;
  final String trendBadge;
  final Color trendColor;
  final IconData? trendIcon;
  final bool isPulseDot;
  final String subtitle;
  final Color glowColor;
  final VoidCallback? onTap;

  const _KpiGlowCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.totalSuffix,
    required this.trendBadge,
    required this.trendColor,
    this.trendIcon,
    this.isPulseDot = false,
    required this.subtitle,
    required this.glowColor,
    this.onTap,
  });

  @override
  State<_KpiGlowCard> createState() => _KpiGlowCardState();
}

class _KpiGlowCardState extends State<_KpiGlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered
                ? widget.glowColor.withValues(alpha: 0.6)
                : (widget.isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0)),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withValues(
                alpha: _isHovered ? 0.28 : 0.08,
              ),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: widget.iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.iconColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 22,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.trendColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.trendColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.trendIcon != null) ...[
                              Icon(
                                widget.trendIcon,
                                color: widget.trendColor,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                            ] else if (widget.isPulseDot) ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: widget.trendColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              widget.trendBadge,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: widget.trendColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: widget.isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.value,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: widget.isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.totalSuffix,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: widget.iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.subtitle,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 11,
                            color: widget.isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
