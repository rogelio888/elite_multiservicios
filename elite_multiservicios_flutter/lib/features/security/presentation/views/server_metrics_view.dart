import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Vista ejecutiva minimalista de Telemetría y Estado del Servidor
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 32,
            vertical: isNarrow ? 20 : 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Ejecutiva
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 20),

              // 2. Banner de Error si aplica
              if (_errorMessage != null) ...[
                _buildErrorBanner(isDark),
                const SizedBox(height: 20),
              ],

              // 3. Estado de Carga Inicial
              if (_isLoading && _metrics == null)
                _buildLoadingState(isDark)
              else if (_metrics != null) ...[
                // 4. Tarjetas KPI Principales
                _buildKpisGrid(isDark),
                const SizedBox(height: 20),

                // 5. Panel de Información & Runtime
                _buildRuntimePanel(isDark, isNarrow),
              ],
            ],
          ),
        );
      },
    );
  }

  // --- CABECERA ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final infoCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: [
            Text(
              'Telemetría y Estado del Servidor',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 18 : 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'SISTEMA ONLINE',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Supervisión de rendimiento del núcleo backend, latencia PostgreSQL y carga de sockets en tiempo real.',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 12.5 : 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final actionsRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Switch de auto-refresh
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Auto 30s',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 4),
            Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _autoRefreshEnabled,
                activeThumbColor: const Color(0xFF2563EB),
                onChanged: (v) {
                  setState(() => _autoRefreshEnabled = v);
                  _setupAutoRefresh();
                },
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF475569),
            side: BorderSide(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _fetchMetrics(),
          icon: const Icon(Icons.refresh, size: 15),
          label: Text(
            'Actualizar',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 24,
        vertical: isNarrow ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoCol,
                const SizedBox(height: 14),
                actionsRow,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoCol),
                const SizedBox(width: 16),
                actionsRow,
              ],
            ),
    );
  }

  // --- BANNER DE ERROR ---
  Widget _buildErrorBanner(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF7F1D1D)
        : const Color(0xFFFECACA);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFEF4444),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ERROR CONEXIÓN',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEF4444),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFF991B1B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () => _fetchMetrics(),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: Text(
              'Reintentar',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GRID DE 5 KPIS ---
  Widget _buildKpisGrid(bool isDark) {
    final m = _metrics!;
    final memMb = (m.memoryRssBytes / (1024 * 1024)).toStringAsFixed(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1050;
        final cardWidth = isWide
            ? (constraints.maxWidth - (12 * 4)) / 5
            : (constraints.maxWidth >= 640
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth);

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildKpiCard(
              title: 'Tiempo de Actividad',
              value: _formatUptime(m.uptimeSeconds),
              statusText: 'Normal',
              statusColor: const Color(0xFF10B981),
              icon: Icons.timer_outlined,
              width: cardWidth,
              isDark: isDark,
            ),
            _buildKpiCard(
              title: 'Memoria RSS en Uso',
              value: '$memMb MB',
              statusText: 'Normal',
              statusColor: const Color(0xFF2563EB),
              icon: Icons.memory_outlined,
              width: cardWidth,
              isDark: isDark,
            ),
            _buildKpiCard(
              title: 'Latencia de Base de Datos',
              value: '${m.databaseLatencyMs} ms',
              statusText: m.databaseLatencyMs < 20 ? 'Óptima' : 'Alerta',
              statusColor: m.databaseLatencyMs < 20
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              icon: Icons.storage_outlined,
              width: cardWidth,
              isDark: isDark,
            ),
            _buildKpiCard(
              title: 'Sesiones Activas',
              value: '${m.activeSessionsCount}',
              statusText: 'Conexiones',
              statusColor: const Color(0xFF8B5CF6),
              icon: Icons.devices_outlined,
              width: cardWidth,
              isDark: isDark,
            ),
            _buildKpiCard(
              title: 'Logins Fallidos (24h)',
              value: '${m.failedLoginsLast24h}',
              statusText: m.failedLoginsLast24h == 0
                  ? 'Sin fallos'
                  : 'Monitoreado',
              statusColor: m.failedLoginsLast24h == 0
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              icon: Icons.shield_outlined,
              width: cardWidth,
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String statusText,
    required Color statusColor,
    required IconData icon,
    required double width,
    required bool isDark,
  }) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                statusText,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- PANEL DE RUNTIME ---
  Widget _buildRuntimePanel(bool isDark, bool isNarrow) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final m = _metrics!;

    final formattedDate =
        '${m.serverTimestamp.day.toString().padLeft(2, '0')}/${m.serverTimestamp.month.toString().padLeft(2, '0')}/${m.serverTimestamp.year} ${m.serverTimestamp.hour.toString().padLeft(2, '0')}:${m.serverTimestamp.minute.toString().padLeft(2, '0')}:${m.serverTimestamp.second.toString().padLeft(2, '0')} UTC';

    final runtimeItems = [
      _buildRuntimeItem(
        'Versión del Sistema',
        'v${m.serverVersion}',
        Icons.verified_outlined,
        isDark,
      ),
      _buildRuntimeItem(
        'Motor de Ejecución',
        'Serverpod / Dart VM',
        Icons.code_outlined,
        isDark,
      ),
      _buildRuntimeItem(
        'Estado del Servicio',
        'Operativo (Saludable)',
        Icons.check_circle_outline,
        isDark,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.all(isNarrow ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'Información del Servidor & Runtime',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  formattedDate,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 16),

          if (isNarrow)
            Column(
              children: [
                runtimeItems[0],
                const SizedBox(height: 12),
                runtimeItems[1],
                const SizedBox(height: 12),
                runtimeItems[2],
              ],
            )
          else
            Row(
              children: [
                Expanded(child: runtimeItems[0]),
                Expanded(child: runtimeItems[1]),
                Expanded(child: runtimeItems[2]),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRuntimeItem(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return const Padding(
      padding: EdgeInsets.all(60),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF2563EB),
          ),
        ),
      ),
    );
  }
}
