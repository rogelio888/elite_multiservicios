import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

class AuditLogView extends StatefulWidget {
  const AuditLogView({super.key});

  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<AuditLog> _logs = [];
  String? _selectedActionFilter;

  final _commonActions = [
    'TODAS',
    'USER_CREATED',
    'USER_UPDATED',
    'USER_DISABLED',
    'ROLE_UPDATED',
    'PERMISSION_CHANGED',
    'SESSION_REVOKED',
  ];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final filter = _selectedActionFilter == 'TODAS'
          ? null
          : _selectedActionFilter;
      final logs = await _service.listAuditLogs(
        limit: 100,
        offset: 0,
        action: filter,
      );

      if (mounted) {
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLogDetail(AuditLog log) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Detalle de Evento: ${log.action}'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('ID Registro', '${log.id}'),
              _detailRow('Acción', log.action),
              _detailRow('Usuario / Actor', log.userIdentifier ?? 'Anónimo'),
              _detailRow('Recurso', log.resource ?? 'N/A'),
              _detailRow('Dirección IP', log.ipAddress ?? '127.0.0.1'),
              _detailRow('Resultado', log.result),
              _detailRow('Fecha (UTC)', log.timestamp.toIso8601String()),
              if (log.metadata != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Metadatos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    log.metadata!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
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
                      'Bitácora de Auditoría del Sistema',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Registro inmutable de trazabilidad y operaciones en PostgreSQL',
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
                tooltip: 'Actualizar bitácora',
                onPressed: _loadLogs,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Filtros por Acción
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _commonActions.map((action) {
                final isSelected = (_selectedActionFilter ?? 'TODAS') == action;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(action),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedActionFilter = action);
                      _loadLogs();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Tabla de Bitácora
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
                : _logs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(
                      child: Text('No hay eventos de auditoría para mostrar.'),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 20,
                        columns: const [
                          DataColumn(label: Text('Evento')),
                          DataColumn(label: Text('Usuario')),
                          DataColumn(label: Text('Recurso')),
                          DataColumn(label: Text('Resultado')),
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Detalle')),
                        ],
                        rows: _logs.map((log) {
                          BadgeVariant variant;
                          if (log.result == 'SUCCESS') {
                            variant = BadgeVariant.success;
                          } else if (log.result == 'DENIED') {
                            variant = BadgeVariant.warning;
                          } else {
                            variant = BadgeVariant.danger;
                          }

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  log.action,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              DataCell(Text(log.userIdentifier ?? 'Anónimo')),
                              DataCell(Text(log.resource ?? '-')),
                              DataCell(
                                StatusBadge(
                                  label: log.result,
                                  variant: variant,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')} - ${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.info_outline,
                                    size: 18,
                                  ),
                                  onPressed: () => _showLogDetail(log),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
