import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

class ActiveSessionsView extends StatefulWidget {
  const ActiveSessionsView({super.key});

  @override
  State<ActiveSessionsView> createState() => _ActiveSessionsViewState();
}

class _ActiveSessionsViewState extends State<ActiveSessionsView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<UserSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    try {
      // Monitoreo de sesiones de usuario en sesión actual (ej. ID 1 o general)
      final sessions = await _service.listUserSessions(1);
      if (mounted) {
        setState(() {
          _sessions = sessions;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _revokeSession(UserSession session) async {
    if (session.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revocar Sesión Remota'),
        content: Text(
          '¿Está seguro de que desea cerrar forzosamente la sesión desde la IP ${session.ipAddress ?? "desconocida"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revocar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.revokeSession(session.id!);
      if (success) {
        _loadSessions();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesión revocada exitosamente.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monitoreo de Sesiones Activas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Control en tiempo real de concurrencia, dispositivos y revocación inmediata',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Actualizar sesiones',
                onPressed: _loadSessions,
              ),
            ],
          ),

          const SizedBox(height: 28),

          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _sessions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.devices,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('No hay sesiones concurrentes activas.'),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sessions.length,
                    separatorBuilder: (ctx, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final sess = _sessions[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFF059669,
                          ).withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.laptop,
                            color: Color(0xFF059669),
                            size: 20,
                          ),
                        ),
                        title: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              sess.deviceInfo ??
                                  'Navegador Web / Cliente Desktop',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const StatusBadge(
                              label: 'En Línea',
                              variant: BadgeVariant.success,
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'IP: ${sess.ipAddress ?? "127.0.0.1"} • Última actividad: ${sess.lastActivityAt.toLocal()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        trailing: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                          ),
                          onPressed: () => _revokeSession(sess),
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text('Revocar'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
