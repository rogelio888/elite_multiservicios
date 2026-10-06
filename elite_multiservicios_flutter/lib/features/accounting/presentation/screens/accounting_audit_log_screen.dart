import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingAuditLogScreen extends StatefulWidget {
  const AccountingAuditLogScreen({super.key});

  @override
  State<AccountingAuditLogScreen> createState() =>
      _AccountingAuditLogScreenState();
}

class _AccountingAuditLogScreenState extends State<AccountingAuditLogScreen> {
  String _quickView = 'todos';
  String _selectedModule = 'Todos los Módulos';
  String _selectedSeverity = 'Todas las Severidades';
  String _selectedUser = 'Todos los Usuarios';
  int? _selectedRowIndex;

  static const Color _dark = Color(0xFFFFFFFF);
  static const Color _indigo = Color(0xFF4F46E5);

  final List<Map<String, dynamic>> _events = const [
    {
      'timestamp': '31/10/2024\n14:18:02.491',
      'initials': 'HE',
      'user': 'Harold Eastman',
      'role': 'CFO',
      'ip': '190.181.42.12 [LPZ]',
      'module': 'Activos Fijos',
      'moduleColor': Color(0xFF6366F1),
      'action': 'Reversión de depreciación\nDell PowerEdge R750',
      'severity': 'critico',
      'eventId': 'EVT-2024-1031-9842',
      'description': 'Ajuste manual de Vida Útil y Reversión de Cuota Mensual',
      'asset': 'Servidor Dell PowerEdge R750 (Tag: ACT-2024-001)',
    },
    {
      'timestamp': '31/10/2024\n12:00:15.182',
      'initials': 'SYS',
      'user': 'Cron Job Daemon',
      'role': 'SYSTEM',
      'ip': '127.0.0.1 [Local]',
      'module': 'Activos Fijos',
      'moduleColor': Color(0xFF6366F1),
      'action': 'Corrida masiva de depreciación\nCierre preventivo mensual',
      'severity': 'normal',
      'eventId': 'EVT-2024-1031-9841',
      'description': 'Ejecución automática de batch de depreciación mensual',
      'asset': 'Múltiples activos (lote 47)',
    },
    {
      'timestamp': '31/10/2024\n11:45:30.822',
      'initials': 'PW',
      'user': 'Auditor Ext. PwC',
      'role': 'AUDIT',
      'ip': '186.22.10.95',
      'module': 'Cuentas por Pagar',
      'moduleColor': Color(0xFFF59E0B),
      'action': 'Intento de edición denegado\nPermiso denegado sobre asiento',
      'severity': 'advertencia',
      'eventId': 'EVT-2024-1031-9840',
      'description':
          'Intento de modificación de asiento contable sin permiso RLS',
      'asset': 'Asiento #4521-B',
    },
    {
      'timestamp': '31/10/2024\n09:12:44.019',
      'initials': 'LV',
      'user': 'Lucía Vega',
      'role': 'SR CONT',
      'ip': '190.181.42.18',
      'module': 'Activos Fijos',
      'moduleColor': Color(0xFF6366F1),
      'action': 'Baja de activo ACT-2024-047\nDictamen técnico e indemnización',
      'severity': 'normal',
      'eventId': 'EVT-2024-1031-9839',
      'description': 'Baja definitiva de activo fijo por obsolescencia',
      'asset': 'ACT-2024-047 - Monitor 24"',
    },
    {
      'timestamp': '30/10/2024\n18:33:10.554',
      'initials': 'CM',
      'user': 'Carlos Mendoza',
      'role': 'CONT JR',
      'ip': '190.181.42.20',
      'module': 'Asientos Contables',
      'moduleColor': Color(0xFF10B981),
      'action': 'Carga masiva extracción XML\n572 asientos importados',
      'severity': 'normal',
      'eventId': 'EVT-2024-1030-9838',
      'description': 'Importación masiva de asientos desde sistema externo',
      'asset': 'Lote XML-2024-10-30',
    },
    {
      'timestamp': '30/10/2024\n15:21:05.003',
      'initials': 'HE',
      'user': 'Harold Eastman',
      'role': 'CFO',
      'ip': '190.181.42.12 [LPZ]',
      'module': 'Activos Fijos',
      'moduleColor': Color(0xFF6366F1),
      'action': 'Revaluación técnica aprobada\nIncremento de valor contable',
      'severity': 'normal',
      'eventId': 'EVT-2024-1030-9837',
      'description':
          'Aprobación de revaluación técnica de maquinaria industrial',
      'asset': 'Compresor Industrial CI-2022-003',
    },
    {
      'timestamp': '30/10/2024\n09:05:58.771',
      'initials': 'AD',
      'user': 'Sistema Admin',
      'role': 'SYSADM',
      'ip': '127.0.0.1 [Local]',
      'module': 'Configuración',
      'moduleColor': Color(0xFF8B5CF6),
      'action': 'Modificación de política RLS\nTabla: fixed_assets',
      'severity': 'critico',
      'eventId': 'EVT-2024-1030-9836',
      'description':
          'Cambio en reglas de seguridad a nivel de fila en tabla crítica',
      'asset': 'Tabla: public.fixed_assets',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    switch (_quickView) {
      case 'criticos':
        return _events.where((e) => e['severity'] == 'critico').toList();
      case 'activos':
        return _events.where((e) => e['module'] == 'Activos Fijos').toList();
      case 'asientos':
        return _events
            .where((e) => e['module'] == 'Asientos Contables')
            .toList();
      case 'rls':
        return _events.where((e) => e['severity'] == 'advertencia').toList();
      default:
        return _events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetricCards(isMobile),
                        const SizedBox(height: 16),
                        _buildFilterBar(isMobile),
                        const SizedBox(height: 12),
                        _buildQuickViews(),
                        const SizedBox(height: 12),
                        _buildTable(isMobile),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedRowIndex != null)
            _buildInspectionPanel(_filteredEvents[_selectedRowIndex!]),
        ],
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Bitácora de Auditoría &\nTrazabilidad Contable',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: _dark,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _badge(
                              'INMUTABLE\n(WORM)',
                              const Color(0xFF1E293B),
                              Colors.white,
                            ),
                            const SizedBox(height: 4),
                            _badge(
                              'Supabase Audit\nLog v2.4',
                              const Color(0xFFDBEAFE),
                              const Color(0xFF2563EB),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registro criptográfico de transacciones, modificaciones de estados contables, '
                      'accesos y firmas digitales bajo estricto cumplimiento Sarbanes-Oxley (SOX Act §404) y NIIF / IAS 8.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionBtn(
                Icons.download_outlined,
                'Exportar Log Firmado (SHA-256)',
                false,
              ),
              _actionBtn(
                Icons.shield_outlined,
                'Configurar Políticas RLS',
                false,
              ),
              _actionBtn(Icons.add, '+ Generar Reporte de Cumplimiento', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: fg,
      ),
    ),
  );

  Widget _actionBtn(IconData icon, String label, bool filled) => Material(
    color: filled ? _indigo : Colors.white,
    borderRadius: BorderRadius.circular(7),
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: filled ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: filled ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // ─── METRIC CARDS ────────────────────────────────────────────────────────────
  Widget _buildMetricCards(bool isMobile) {
    final cards = [
      {
        'title': 'TOTAL EVENTOS\nREGISTRADOS',
        'badgeText': '100%\nIndexado',
        'badgeBg': const Color(0xFF6366F1),
        'badgeFg': Colors.white,
        'value': '14,290',
        'unit': 'eventos',
        'sub': '↑+12.4% vs. mes anterior (Octubre 2024)',
        'subColor': const Color(0xFF10B981),
        'valueColor': _dark,
      },
      {
        'title': 'ACCIONES CRÍTICAS\n/ REVERSIONES',
        'badgeText': 'Requiere\n⚠ Visto\nBueno',
        'badgeBg': const Color(0xFFFEF3C7),
        'badgeFg': const Color(0xFF92400E),
        'value': '3',
        'unit': 'alertas de ledger',
        'sub': '2 reversiones contables autorizadas...',
        'subColor': const Color(0xFF94A3B8),
        'valueColor': const Color(0xFFEF4444),
      },
      {
        'title': 'SESIONES ACTIVAS\n& CUSTODIOS',
        'badgeText': 'VPN / IP\nWhitelist',
        'badgeBg': const Color(0xFFDBEAFE),
        'badgeFg': const Color(0xFF1E40AF),
        'value': '8',
        'unit': 'usuarios autenticados',
        'sub': '● Harold E. (CFO), Carlos M. (IT Lead),...',
        'subColor': const Color(0xFF10B981),
        'valueColor': _dark,
      },
      {
        'title': 'INTEGRIDAD DE\nBASE DE DATOS',
        'badgeText': '⊙ Válida',
        'badgeBg': const Color(0xFFDCFCE7),
        'badgeFg': const Color(0xFF166534),
        'value': '100%',
        'unit': 'Criptográficamente\níntegro',
        'sub': 'Root Block: 0x7... ✓ WAL Synced',
        'subColor': const Color(0xFF94A3B8),
        'valueColor': const Color(0xFF10B981),
      },
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: cards.map((c) {
        return Container(
          width: isMobile ? double.infinity : 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      c['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c['badgeBg'] as Color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      c['badgeText'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: c['badgeFg'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                c['value'] as String,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: c['valueColor'] as Color,
                ),
              ),
              Text(
                c['unit'] as String,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                c['sub'] as String,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: c['subColor'] as Color,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── FILTER BAR ──────────────────────────────────────────────────────────────
  Widget _buildFilterBar(bool isMobile) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _filterChip(
          Icons.calendar_today_outlined,
          '01/10/2024 – 31/10/2024  Mes',
        ),
        _filterDrop('Módulo: $_selectedModule', [
          'Todos los Módulos',
          'Activos Fijos',
          'Cuentas por Pagar',
          'Asientos Contables',
        ], (v) => setState(() => _selectedModule = v!)),
        _filterDrop('Severidad: $_selectedSeverity', [
          'Todas las Severidades',
          'Crítico',
          'Advertencia',
          'Normal',
        ], (v) => setState(() => _selectedSeverity = v!)),
        _filterDrop('Usuario: $_selectedUser', [
          'Todos los Usuarios',
          'Harold Eastman',
          'Lucía Vega',
          'Carlos Mendoza',
        ], (v) => setState(() => _selectedUser = v!)),
        _filterChip(Icons.filter_list, 'Filtrar por IP, UUID o Tag...'),
      ],
    );
  }

  Widget _filterChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    ),
  );

  Widget _filterDrop(
    String label,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(7),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: items.first,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.inter(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down, size: 14),
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
        isDense: true,
      ),
    ),
  );

  // ─── QUICK VIEWS ─────────────────────────────────────────────────────────────
  Widget _buildQuickViews() {
    final tabs = [
      ('todos', 'Todos', _events.length, null as Color?),
      (
        'criticos',
        'Críticos & Reversiones',
        _events.where((e) => e['severity'] == 'critico').length,
        const Color(0xFFEF4444) as Color?,
      ),
      (
        'activos',
        'Activos Fijos',
        _events.where((e) => e['module'] == 'Activos Fijos').length,
        null,
      ),
      (
        'asientos',
        'Asientos Contables',
        _events.where((e) => e['module'] == 'Asientos Contables').length,
        null,
      ),
      (
        'rls',
        'RLS Violations (Bloqueados)',
        1,
        const Color(0xFFF59E0B) as Color?,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'VISTAS RÁPIDAS:',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          ...tabs.map((t) {
            final isSelected = _quickView == t.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => setState(() {
                  _quickView = t.$1;
                  _selectedRowIndex = null;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _indigo : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? _indigo : const Color(0xFF334155),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (t.$4 != null) ...[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: t.$4,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        t.$2,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${t.$3}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── TABLE ───────────────────────────────────────────────────────────────────
  Widget _buildTable(bool isMobile) {
    final events = _filteredEvents;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Text(
                  'Transacciones Registradas en Ledger',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'CADENA ACTIVA',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.refresh, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                const Icon(
                  Icons.open_in_full,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
          // Column headers
          if (!isMobile)
            Container(
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(width: 115, child: _colHdr('TIMESTAMP (UTC-4)')),
                  SizedBox(width: 185, child: _colHdr('USUARIO & ROL')),
                  SizedBox(width: 140, child: _colHdr('MÓDULO')),
                  Expanded(child: _colHdr('ACCIÓN REALIZADA')),
                ],
              ),
            ),
          // Rows
          ...events.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return _buildRow(e, i, _selectedRowIndex == i, isMobile);
          }),
          // Pagination
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Filas por página:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '7',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '1 de 572',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 8),
                ...[
                  Icons.first_page,
                  Icons.chevron_left,
                  Icons.chevron_right,
                  Icons.last_page,
                ].map(
                  (ic) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          ic,
                          size: 16,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colHdr(String label) => Text(
    label,
    style: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF94A3B8),
      letterSpacing: 0.5,
    ),
  );

  Widget _buildRow(
    Map<String, dynamic> e,
    int i,
    bool isSelected,
    bool isMobile,
  ) {
    final Color dot = e['severity'] == 'critico'
        ? const Color(0xFFEF4444)
        : (e['severity'] == 'advertencia'
              ? const Color(0xFFF59E0B)
              : const Color(0xFF10B981));

    return GestureDetector(
      onTap: () => setState(() => _selectedRowIndex = isSelected ? null : i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            bottom: const BorderSide(color: Color(0xFFE2E8F0)),
            left: isSelected
                ? const BorderSide(color: Color(0xFF6366F1), width: 3)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: isMobile ? _rowMobile(e, dot) : _rowDesktop(e, dot),
      ),
    );
  }

  Widget _rowDesktop(Map<String, dynamic> e, Color dot) => Row(
    children: [
      SizedBox(
        width: 115,
        child: Text(
          e['timestamp'] as String,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.5,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ),
      SizedBox(
        width: 185,
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _indigo,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  e['initials'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e['user'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _dark,
                    ),
                  ),
                  Text(
                    '${e['role']}  •  ${e['ip']}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF94A3B8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 140,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (e['moduleColor'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            e['module'] as String,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: e['moduleColor'] as Color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Expanded(
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                e['action'] as String,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _dark,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _rowMobile(Map<String, dynamic> e, Color dot) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            e['user'] as String,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _dark,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: (e['moduleColor'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              e['module'] as String,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: e['moduleColor'] as Color,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        e['action'] as String,
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
      ),
      const SizedBox(height: 2),
      Text(
        e['timestamp'] as String,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: const Color(0xFF94A3B8),
        ),
      ),
    ],
  );

  // ─── INSPECTION PANEL ────────────────────────────────────────────────────────
  Widget _buildInspectionPanel(Map<String, dynamic> e) {
    return Container(
      width: 295,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inspección de Modificación Contable',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'EVENTO ID: ${e['eventId']} (CRÍTICO)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _selectedRowIndex = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'METADATOS DEL EVENTO',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 10,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'WORM Validado',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFFED7AA)),
                    ),
                    child: Text(
                      e['description'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Activo: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: e['asset'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '31 Oct 2024  •  14:18:02  UTC-4',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Harold Eastman (CFO)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'IP Origen: 190.181.42.12\n(VPN Corporativa Sucursal La Paz)',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _panelBtn(
                          Icons.download_outlined,
                          'Descargar Certificado',
                          false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _panelBtn(
                          Icons.account_tree_outlined,
                          'Auditar Cadena',
                          false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _panelBtn(
                    Icons.undo,
                    'Revertir Cambio (Rollback Seguro Asistido)',
                    true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelBtn(IconData icon, String label, bool isDanger) => Material(
    color: isDanger ? const Color(0xFFFEF2F2) : Colors.white,
    borderRadius: BorderRadius.circular(7),
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isDanger ? const Color(0xFFFCA5A5) : const Color(0xFF334155),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: isDanger
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDanger
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
