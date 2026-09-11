import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/security_stat_card.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

class SecurityDashboardView extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const SecurityDashboardView({super.key, this.onNavigateToTab});

  @override
  State<SecurityDashboardView> createState() => _SecurityDashboardViewState();
}

class _SecurityDashboardViewState extends State<SecurityDashboardView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  SecurityDashboardMetrics _metrics = const SecurityDashboardMetrics(
    totalUsers: 0,
    totalRoles: 0,
    totalAuditLogs: 0,
    activeSessions: 0,
  );
  List<AuditLog> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final metrics = await _service.getDashboardMetrics();
      final logs = await _service.listAuditLogs(limit: 5, offset: 0);

      if (mounted) {
        setState(() {
          _metrics = metrics;
          _recentLogs = logs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de Bienvenida y Estado del Servidor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel de Control de Seguridad',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitoreo centralizado, control de accesos RBAC y auditoría inmutable',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const StatusBadge(
                    label: 'Serverpod Online',
                    variant: BadgeVariant.success,
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Recargar métricas',
                    onPressed: _loadDashboardData,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Grid de KPIs
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              final crossAxisCount = isNarrow ? 2 : 4;
              final cardWidth =
                  (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
                  crossAxisCount;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: SecurityStatCard(
                      title: 'Usuarios Activos',
                      value: '${_metrics.totalUsers}',
                      subtitle: 'Cuentas empresariales',
                      icon: Icons.people_outline,
                      iconColor: const Color(0xFF1E3A8A),
                      onTap: () => widget.onNavigateToTab?.call(1),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: SecurityStatCard(
                      title: 'Roles de Sistema',
                      value: '${_metrics.totalRoles}',
                      subtitle: 'Perfiles configurados',
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: const Color(0xFF4F46E5),
                      onTap: () => widget.onNavigateToTab?.call(2),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: SecurityStatCard(
                      title: 'Eventos de Bitácora',
                      value: '${_metrics.totalAuditLogs}',
                      subtitle: 'Registros inmutables en PostgreSQL',
                      icon: Icons.history_edu_outlined,
                      iconColor: const Color(0xFF059669),
                      onTap: () => widget.onNavigateToTab?.call(3),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: SecurityStatCard(
                      title: 'Sesiones Activas',
                      value: '${_metrics.activeSessions}',
                      subtitle: 'Concurrencia en tiempo real',
                      icon: Icons.devices_outlined,
                      iconColor: const Color(0xFFD97706),
                      onTap: () => widget.onNavigateToTab?.call(4),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 36),

          // Actividad Reciente de Auditoría
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actividad Reciente del Sistema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => widget.onNavigateToTab?.call(3),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Ver bitácora completa'),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (_recentLogs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Aún no hay eventos registrados en la bitácora de auditoría.',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentLogs.length,
                    separatorBuilder: (ctx, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final log = _recentLogs[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFF1E3A8A,
                          ).withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.event_note,
                            color: Color(0xFF1E3A8A),
                            size: 18,
                          ),
                        ),
                        title: Text(
                          log.action,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Usuario: ${log.userIdentifier ?? "Anónimo"} • Recurso: ${log.resource ?? "General"} • IP: ${log.ipAddress ?? "127.0.0.1"}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        trailing: StatusBadge(
                          label: log.result,
                          variant: log.result == 'SUCCESS'
                              ? BadgeVariant.success
                              : BadgeVariant.danger,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
