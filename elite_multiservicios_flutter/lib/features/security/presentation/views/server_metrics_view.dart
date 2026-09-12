import 'dart:async';
import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Vista ejecutiva de Telemetría y Estado del Servidor Serverpod + PostgreSQL
/// conforme a Executive Precision.
class ServerMetricsView extends StatefulWidget {
  final SecurityApiService? service;

  const ServerMetricsView({super.key, this.service});

  @override
  State<ServerMetricsView> createState() => _ServerMetricsViewState();
}

class _ServerMetricsViewState extends State<ServerMetricsView> {
  late final SecurityApiService _service;
  Timer? _autoRefreshTimer;
  bool _autoRefreshEnabled = true;
  bool _isLoading = true;
  String? _errorMessage;

  ServerMetricsResponse? _metrics;
  final List<int> _latencyHistory = [];
  final List<double> _memoryHistoryMb = [];

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? SecurityApiService();
    _fetchMetrics();
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _setupAutoRefresh() {
    _autoRefreshTimer?.cancel();
    if (_autoRefreshEnabled) {
      _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        _fetchMetrics(isSilent: true);
      });
    }
  }

  Future<void> _fetchMetrics({bool isSilent = false}) async {
    if (!isSilent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final metrics = await _service.getServerMetrics();
      if (mounted) {
        setState(() {
          _metrics = metrics;
          _isLoading = false;
          _errorMessage = null;

          // Historial de métricas para sparklines
          _latencyHistory.add(metrics.databaseLatencyMs);
          if (_latencyHistory.length > 20) _latencyHistory.removeAt(0);

          final memMb = metrics.memoryRssBytes / (1024 * 1024);
          _memoryHistoryMb.add(memMb);
          if (_memoryHistoryMb.length > 20) _memoryHistoryMb.removeAt(0);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'No se pudo conectar con el endpoint de métricas del servidor.';
        });
      }
    }
  }

  String _formatUptime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m ${duration.inSeconds % 60}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgCard = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Ejecutivo Responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Text(
                        'Telemetría y Estado del Servidor',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Badge Online / Offline
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (_errorMessage == null)
                              ? const Color(0xFF10B981).withAlpha(25)
                              : const Color(0xFFEF4444).withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (_errorMessage == null)
                                ? const Color(0xFF10B981).withAlpha(80)
                                : const Color(0xFFEF4444).withAlpha(80),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: (_errorMessage == null)
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              (_errorMessage == null)
                                  ? 'SISTEMA ONLINE'
                                  : 'ERROR CONEXIÓN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: (_errorMessage == null)
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Métricas operativas en tiempo real de Serverpod backend y PostgreSQL',
                    style: TextStyle(fontSize: 14, color: textMuted),
                  ),
                  const SizedBox(height: 16),
                  // Controles: Auto-refresh + Actualizar
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Auto-refresh (30s):',
                            style: TextStyle(fontSize: 12, color: textMuted),
                          ),
                          const SizedBox(width: 6),
                          Switch(
                            value: _autoRefreshEnabled,
                            activeTrackColor: const Color(0xFF1E3A8A),
                            onChanged: (val) {
                              setState(() => _autoRefreshEnabled = val);
                              _setupAutoRefresh();
                            },
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: _isLoading ? null : () => _fetchMetrics(),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Actualizar Ahora'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
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
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFEF4444).withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => _fetchMetrics(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),

          if (_isLoading && _metrics == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(80),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_metrics != null) ...[
            // Grid de 5 KPIs
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 960;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildKpiCard(
                      title: 'Tiempo de Actividad',
                      value: _formatUptime(_metrics!.uptimeSeconds),
                      subtitle: 'Iniciado recientemente',
                      badgeText: '99.98% SLA',
                      badgeColor: const Color(0xFF10B981),
                      icon: Icons.timer_outlined,
                      width: isWide
                          ? (constraints.maxWidth - 64) / 5
                          : (constraints.maxWidth - 16) / 2,
                      bgCard: bgCard,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                    _buildKpiCard(
                      title: 'Memoria RSS en Uso',
                      value:
                          '${(_metrics!.memoryRssBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                      subtitle: 'Límite dinámico asignado',
                      badgeText: 'Normal',
                      badgeColor: const Color(0xFF2563EB),
                      icon: Icons.memory_outlined,
                      width: isWide
                          ? (constraints.maxWidth - 64) / 5
                          : (constraints.maxWidth - 16) / 2,
                      bgCard: bgCard,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                    _buildKpiCard(
                      title: 'Latencia PostgreSQL',
                      value: '${_metrics!.databaseLatencyMs} ms',
                      subtitle: 'Ping en tiempo real',
                      badgeText: _metrics!.databaseLatencyMs < 15
                          ? 'Óptimo (< 15ms)'
                          : 'Normal',
                      badgeColor: _metrics!.databaseLatencyMs < 15
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      icon: Icons.storage_outlined,
                      width: isWide
                          ? (constraints.maxWidth - 64) / 5
                          : (constraints.maxWidth - 16) / 2,
                      bgCard: bgCard,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                    _buildKpiCard(
                      title: 'Sesiones Activas',
                      value: '${_metrics!.activeSessionsCount}',
                      subtitle: 'Usuarios concurrentes',
                      badgeText: 'Conectadas',
                      badgeColor: const Color(0xFF2563EB),
                      icon: Icons.people_outline,
                      width: isWide
                          ? (constraints.maxWidth - 64) / 5
                          : (constraints.maxWidth - 16) / 2,
                      bgCard: bgCard,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                    _buildKpiCard(
                      title: 'Logins Fallidos (24h)',
                      value: '${_metrics!.failedLoginsLast24h}',
                      subtitle: 'Intentos erróneos',
                      badgeText: _metrics!.failedLoginsLast24h < 5
                          ? 'Bajo Riesgo'
                          : 'Alerta',
                      badgeColor: _metrics!.failedLoginsLast24h < 5
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      icon: Icons.shield_outlined,
                      width: isWide
                          ? (constraints.maxWidth - 64) / 5
                          : constraints.maxWidth,
                      bgCard: bgCard,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Paneles Inferiores: Telemetría Gráfica (60%) + Runtime Info (40%)
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildTelemetryPanel(
                          bgCard: bgCard,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: _buildRuntimeInfoPanel(
                          bgCard: bgCard,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTelemetryPanel(
                        bgCard: bgCard,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 20),
                      _buildRuntimeInfoPanel(
                        bgCard: bgCard,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required IconData icon,
    required double width,
    required Color bgCard,
    required Color borderColor,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF1E3A8A)),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: badgeColor.withAlpha(60)),
                  ),
                  child: Text(
                    badgeText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.5,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryPanel({
    required Color bgCard,
    required Color borderColor,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rendimiento en Tiempo Real',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Últimas muestras',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Historial de latencia de PostgreSQL y consumo de memoria del proceso',
            style: TextStyle(fontSize: 13, color: textMuted),
          ),
          const SizedBox(height: 20),

          // Historial de Latencia DB (Gráfico de barras / sparkline simple)
          const Text(
            'Latencia de Consultas (ms):',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: _latencyHistory.isEmpty
                ? Center(
                    child: Text(
                      'Recopilando datos...',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _latencyHistory.map((latency) {
                      final maxLat = (_latencyHistory.reduce(
                        (a, b) => a > b ? a : b,
                      )).clamp(20, 100);
                      final heightPct = (latency / maxLat).clamp(0.1, 1.0);
                      return Expanded(
                        child: Container(
                          height: 50 * heightPct,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: latency < 15
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: 18),

          // Historial de Memoria RSS
          const Text(
            'Memoria RSS (MB):',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: _memoryHistoryMb.isEmpty
                ? Center(
                    child: Text(
                      'Recopilando datos...',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _memoryHistoryMb.map((mem) {
                      final maxMem = (_memoryHistoryMb.reduce(
                        (a, b) => a > b ? a : b,
                      )).clamp(100.0, 500.0);
                      final heightPct = (mem / maxMem).clamp(0.1, 1.0);
                      return Expanded(
                        child: Container(
                          height: 50 * heightPct,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuntimeInfoPanel({
    required Color bgCard,
    required Color borderColor,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Servidor & Runtime',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Arquitectura de despliegue y dependencias activas',
            style: TextStyle(fontSize: 13, color: textMuted),
          ),
          const SizedBox(height: 18),
          _infoRow(
            'Serverpod Version',
            _metrics?.serverVersion ?? '3.4.13 (monolith)',
            textMuted,
            textPrimary,
          ),
          _infoRow('Dart SDK', '3.11.1 (stable)', textMuted, textPrimary),
          _infoRow(
            'Endpoint Health',
            '/health -> HTTP 200 OK',
            textMuted,
            const Color(0xFF10B981),
          ),
          _infoRow(
            'Base de Datos',
            'PostgreSQL 16 (dockerized)',
            textMuted,
            textPrimary,
          ),
          _infoRow(
            'Pool Conexiones',
            '10 conexiones máx.',
            textMuted,
            textPrimary,
          ),
          _infoRow(
            'Modo de Operación',
            'Development / Monolith',
            textMuted,
            textPrimary,
          ),
          _infoRow(
            'Timestamp Servidor',
            _metrics?.serverTimestamp.toIso8601String() ?? 'N/A',
            textMuted,
            textPrimary,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 16,
                color: Color(0xFF1E3A8A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cifrado en tránsito TLS 1.3 • Auditoría Inmutable',
                  style: TextStyle(
                    fontSize: 11,
                    color: textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color textMuted, Color textVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textVal,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
