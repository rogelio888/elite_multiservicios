import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

/// Vista ejecutiva de Bitácora de Auditoría del Sistema conforme a Executive Precision.
/// Incluye búsqueda contextual, filtros por acción/resultado/fechas, paginación real
/// y visor detallado de metadatos de eventos de seguridad.
class AuditLogView extends StatefulWidget {
  final SecurityApiService? service;

  const AuditLogView({super.key, this.service});

  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  late final SecurityApiService _service;
  bool _isLoading = true;

  // Estado de datos
  List<AuditLog> _logs = [];
  int _page = 1;
  int _pageSize = 25;
  int _totalCount = 0;
  int _totalPages = 1;

  // Filtros
  final _searchController = TextEditingController();
  String _selectedAction = 'TODAS';
  String _selectedResult = 'TODOS';
  DateTimeRange? _selectedDateRange;

  final _actionOptions = const [
    'TODAS',
    'LOGIN_SUCCESS',
    'LOGIN_FAILED',
    'MFA_VERIFIED',
    'PASSWORD_CHANGED',
    'USER_CREATED',
    'USER_UPDATED',
    'USER_DISABLED',
    'ROLE_UPDATED',
    'SESSION_REVOKED',
  ];

  final _resultOptions = const [
    'TODOS',
    'SUCCESS',
    'FAILURE',
    'BLOCKED',
  ];

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? SecurityApiService();
    _loadLogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs({int? newPage}) async {
    final pageToLoad = newPage ?? _page;
    setState(() => _isLoading = true);

    try {
      final actionFilter = _selectedAction == 'TODAS' ? null : _selectedAction;
      final resultFilter = _selectedResult == 'TODOS' ? null : _selectedResult;
      final searchFilter = _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim();

      final pageResponse = await _service.listAuditLogsPaged(
        page: pageToLoad,
        pageSize: _pageSize,
        action: actionFilter,
        result: resultFilter,
        fromDate: _selectedDateRange?.start.toUtc(),
        toDate: _selectedDateRange?.end
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1))
            .toUtc(),
        search: searchFilter,
      );

      if (mounted) {
        setState(() {
          _logs = pageResponse.items;
          _totalCount = pageResponse.totalCount;
          _totalPages = pageResponse.totalPages;
          _page = pageResponse.page;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedAction = 'TODAS';
      _selectedResult = 'TODOS';
      _selectedDateRange = null;
      _page = 1;
    });
    _loadLogs(newPage: 1);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      helpText: 'Seleccionar rango de auditoría',
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _page = 1;
      });
      _loadLogs(newPage: 1);
    }
  }

  void _showLogDetail(AuditLog log) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String prettyJson = log.metadata ?? '';
    if (log.metadata != null && log.metadata!.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(log.metadata!);
        const encoder = JsonEncoder.withIndent('  ');
        prettyJson = encoder.convert(decoded);
      } catch (_) {
        prettyJson = log.metadata!;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_outlined,
                color: Color(0xFF1E3A8A),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Detalle de Evento: ${log.action}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 540,
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                const Text(
                  'Metadatos Estructurados (JSON):',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1120)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: SelectableText(
                    prettyJson.isNotEmpty
                        ? prettyJson
                        : 'Sin metadatos adicionales.',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prettyJson));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Metadatos copiados al portapapeles'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copiar JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
            ),
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
            width: 130,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  BadgeVariant _getBadgeVariant(String result) {
    final r = result.toUpperCase();
    if (r == 'SUCCESS') return BadgeVariant.success;
    if (r == 'FAILURE') return BadgeVariant.danger;
    if (r == 'BLOCKED') return BadgeVariant.warning;
    return BadgeVariant.neutral;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final startItem = _totalCount == 0 ? 0 : (_page - 1) * _pageSize + 1;
    final endItem = (_page * _pageSize) > _totalCount
        ? _totalCount
        : (_page * _pageSize);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
              FilledButton.icon(
                onPressed: () => _loadLogs(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Actualizar'),
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

          const SizedBox(height: 20),

          // Barra de Búsqueda y Filtros
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                // Fila 1: Buscador y Filtros desplegables
                Row(
                  children: [
                    // Buscador
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (_) => _loadLogs(newPage: 1),
                        decoration: InputDecoration(
                          hintText:
                              'Buscar por usuario, IP, recurso o acción...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () {
                                    _searchController.clear();
                                    _loadLogs(newPage: 1);
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Dropdown Acción
                    DropdownButton<String>(
                      value: _selectedAction,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(8),
                      items: _actionOptions.map((a) {
                        return DropdownMenuItem(
                          value: a,
                          child: Text(
                            a == 'TODAS' ? 'Acción: Todas' : a,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedAction = val);
                          _loadLogs(newPage: 1);
                        }
                      },
                    ),
                    const SizedBox(width: 12),

                    // Dropdown Resultado
                    DropdownButton<String>(
                      value: _selectedResult,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(8),
                      items: _resultOptions.map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Text(
                            r == 'TODOS' ? 'Resultado: Todos' : r,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedResult = val);
                          _loadLogs(newPage: 1);
                        }
                      },
                    ),
                    const SizedBox(width: 12),

                    // Selector de Rango de Fechas
                    OutlinedButton.icon(
                      onPressed: _pickDateRange,
                      icon: const Icon(Icons.calendar_today_outlined, size: 16),
                      label: Text(
                        _selectedDateRange == null
                            ? 'Fechas'
                            : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Botón Limpiar Filtros
                    if (_selectedAction != 'TODAS' ||
                        _selectedResult != 'TODOS' ||
                        _selectedDateRange != null ||
                        _searchController.text.isNotEmpty)
                      IconButton(
                        tooltip: 'Limpiar filtros',
                        icon: const Icon(Icons.filter_alt_off, size: 18),
                        onPressed: _clearFilters,
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tabla de Bitácora
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(60),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _logs.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(60),
                        child: Center(
                          child: Text(
                            'No hay eventos de auditoría para mostrar.',
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 22,
                            horizontalMargin: 20,
                            headingRowColor: WidgetStateProperty.all(
                              isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF8FAFC),
                            ),
                            columns: const [
                              DataColumn(label: Text('Fecha y Hora (UTC)')),
                              DataColumn(label: Text('Usuario / Actor')),
                              DataColumn(label: Text('Acción')),
                              DataColumn(label: Text('Recurso')),
                              DataColumn(label: Text('Dirección IP')),
                              DataColumn(label: Text('Resultado')),
                              DataColumn(label: Text('Detalle')),
                            ],
                            rows: _logs.map((log) {
                              final formattedDate =
                                  '${log.timestamp.day.toString().padLeft(2, '0')}/${log.timestamp.month.toString().padLeft(2, '0')}/${log.timestamp.year} ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}';

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: const Color(
                                            0xFF1E3A8A,
                                          ).withAlpha(40),
                                          child: Text(
                                            (log.userIdentifier ?? 'A')[0]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E3A8A),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(log.userIdentifier ?? 'Anónimo'),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF0F172A)
                                            : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        log.action,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(log.resource ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      log.ipAddress ?? '127.0.0.1',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    StatusBadge(
                                      label: log.result,
                                      variant: _getBadgeVariant(log.result),
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 18,
                                      ),
                                      tooltip: 'Ver detalle completo',
                                      onPressed: () => _showLogDetail(log),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                // Footer de Paginación
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mostrando $startItem a $endItem de $_totalCount registros',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      Row(
                        children: [
                          // Selector de tamaño de página
                          DropdownButton<int>(
                            value: _pageSize,
                            underline: const SizedBox(),
                            items: const [10, 25, 50].map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(
                                  '$size / pág',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (newSize) {
                              if (newSize != null) {
                                setState(() {
                                  _pageSize = newSize;
                                  _page = 1;
                                });
                                _loadLogs(newPage: 1);
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 20),
                            onPressed: _page > 1
                                ? () => _loadLogs(newPage: _page - 1)
                                : null,
                          ),
                          Text(
                            '$_page / $_totalPages',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 20),
                            onPressed: _page < _totalPages
                                ? () => _loadLogs(newPage: _page + 1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
