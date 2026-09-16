import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de Solicitud de Permiso o Vacación
class AbsenceRequestItem {
  final String id;
  final String employeeName;
  final String leaveType; // 'Vacación Anual', 'Permiso Médico', 'Duelo Familiar', 'Paternidad'
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final bool isPaid; // Remunerado
  final String status; // 'Aprobado', 'Pendiente', 'Rechazado'
  final String reason;

  const AbsenceRequestItem({
    required this.id,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.isPaid,
    required this.status,
    required this.reason,
  });
}

/// Vista de Gestión de Permisos, Licencias y Vacaciones
class RrhhAbsencesView extends StatefulWidget {
  const RrhhAbsencesView({super.key});

  @override
  State<RrhhAbsencesView> createState() => _RrhhAbsencesViewState();
}

class _RrhhAbsencesViewState extends State<RrhhAbsencesView> {
  String _search = '';

  final List<AbsenceRequestItem> _requests = [
    AbsenceRequestItem(
      id: 'abs-001',
      employeeName: 'Carlos Mendoza Rios',
      leaveType: 'Vacación Anual',
      startDate: DateTime(2024, 10, 5),
      endDate: DateTime(2024, 10, 15),
      daysCount: 10,
      isPaid: true,
      status: 'Aprobado',
      reason: 'Periodo reglamentario de descanso vacacional.',
    ),
    AbsenceRequestItem(
      id: 'abs-002',
      employeeName: 'Valeria Justiniano Paz',
      leaveType: 'Permiso Médico',
      startDate: DateTime(2024, 9, 20),
      endDate: DateTime(2024, 9, 21),
      daysCount: 2,
      isPaid: true,
      status: 'Pendiente',
      reason: 'Atención y reposo médico con certificado de la CNS.',
    ),
    AbsenceRequestItem(
      id: 'abs-003',
      employeeName: 'Jorge Luis Aguilera',
      leaveType: 'Asunto Personal',
      startDate: DateTime(2024, 9, 12),
      endDate: DateTime(2024, 9, 12),
      daysCount: 1,
      isPaid: false,
      status: 'Aprobado',
      reason: 'Trámite personal no justificado por ley (sin goce de haberes).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _requests.where((r) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return r.employeeName.toLowerCase().contains(q) ||
          r.leaveType.toLowerCase().contains(q) ||
          r.reason.toLowerCase().contains(q);
    }).toList();

    final totalAprobados = _requests.where((r) => r.status == 'Aprobado').length;
    final totalPendientes = _requests.where((r) => r.status == 'Pendiente').length;
    final totalDias = _requests.fold<int>(0, (sum, r) => sum + r.daysCount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permisos & Vacaciones',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gestión de ausencias justificadas y control de licencias.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSyncBadge(),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Permisos & Vacaciones',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gestión de ausencias justificadas sincronizables con el módulo de Asistencia.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      _buildSyncBadge(),
                    ],
                  ),

                const SizedBox(height: 20),

                // Tarjetas KPI Rápidas
                if (isMobile)
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildKpiCard('Total Solicitudes', '${_requests.length}', Icons.list_alt_outlined, const Color(0xFF3B82F6), isDark),
                          const SizedBox(width: 12),
                          _buildKpiCard('Aprobadas', '$totalAprobados', Icons.check_circle_outline, const Color(0xFF10B981), isDark),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildKpiCard('Pendientes', '$totalPendientes', Icons.pending_outlined, const Color(0xFFF59E0B), isDark),
                          const SizedBox(width: 12),
                          _buildKpiCard('Días Acumulados', '$totalDias d', Icons.calendar_month_outlined, const Color(0xFF8B5CF6), isDark),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildKpiCard('Total Solicitudes', '${_requests.length}', Icons.list_alt_outlined, const Color(0xFF3B82F6), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Aprobadas', '$totalAprobados', Icons.check_circle_outline, const Color(0xFF10B981), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Pendientes de Aprobación', '$totalPendientes', Icons.pending_outlined, const Color(0xFFF59E0B), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Días Computados', '$totalDias d', Icons.calendar_month_outlined, const Color(0xFF8B5CF6), isDark),
                    ],
                  ),

                const SizedBox(height: 20),

                // Banner informativo de configuración flexible
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Catálogo configurable: Los tipos de permisos (médico, duelo, paternidad, etc.) son parametrizables sin alterar código fuente, adaptando días y remuneración según validación legal.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Buscador
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por colaborador, tipo de permiso o motivo...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),

                const SizedBox(height: 20),

                // Vista de Datos: Card View en móvil, Tabla Proporcional 100% en Desktop
                if (isMobile)
                  _buildMobileCardView(filtered, isDark)
                else
                  _buildDesktopTable(filtered, isDark, constraints.maxWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sync_alt, size: 16, color: Color(0xFF3B82F6)),
          const SizedBox(width: 8),
          Text(
            'Sincroniza con Módulo de Asistencia',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(
    List<AbsenceRequestItem> requests,
    bool isDark,
    double maxWidth,
  ) {
    if (requests.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final tableWidth = max(maxWidth, 920.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.2), // Colaborador
                1: FlexColumnWidth(1.8), // Tipo de Permiso
                2: FlexColumnWidth(1.6), // Fechas
                3: FlexColumnWidth(0.9), // Días
                4: FlexColumnWidth(1.2), // Remunerado
                5: FlexColumnWidth(1.2), // Estado
                6: FlexColumnWidth(2.3), // Motivo
                7: FlexColumnWidth(1.1), // Acciones
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    _buildHeaderCell('Colaborador', isDark),
                    _buildHeaderCell('Tipo de Permiso', isDark),
                    _buildHeaderCell('Fechas', isDark),
                    _buildHeaderCell('Días', isDark),
                    _buildHeaderCell('Remunerado', isDark),
                    _buildHeaderCell('Estado', isDark),
                    _buildHeaderCell('Motivo', isDark),
                    _buildHeaderCell('Acciones', isDark, alignment: Alignment.centerRight),
                  ],
                ),
                // Rows
                ...requests.map((req) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      // Colaborador
                      _buildBodyCell(
                        Text(
                          req.employeeName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Tipo
                      _buildBodyCell(
                        Text(
                          req.leaveType,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // Fechas
                      _buildBodyCell(
                        Text(
                          '${req.startDate.day}/${req.startDate.month} - ${req.endDate.day}/${req.endDate.month}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // Días
                      _buildBodyCell(
                        Text(
                          '${req.daysCount} d',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Remunerado
                      _buildBodyCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              req.isPaid ? Icons.check_circle : Icons.cancel,
                              color: req.isPaid ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              req.isPaid ? 'Sí' : 'No',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: req.isPaid ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Estado
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (req.status == 'Aprobado'
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B))
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: (req.status == 'Aprobado'
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B))
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              req.status,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: req.status == 'Aprobado'
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Motivo
                      _buildBodyCell(
                        Text(
                          req.reason,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Acciones
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            icon: const Icon(Icons.visibility_outlined, size: 14),
                            label: Text(
                              'Detalle',
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => _showAbsenceDetailModal(context, req, isDark),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String text,
    bool isDark, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildBodyCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: child,
    );
  }

  Widget _buildMobileCardView(
    List<AbsenceRequestItem> requests,
    bool isDark,
  ) {
    if (requests.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (sepCtx, index) => const SizedBox(height: 12),
      itemBuilder: (itemCtx, index) {
        final req = requests[index];
        return Container(
          padding: const EdgeInsets.all(16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      req.employeeName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (req.status == 'Aprobado'
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      req.status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: req.status == 'Aprobado'
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMobileRow(Icons.category_outlined, 'Tipo', req.leaveType, isDark),
              _buildMobileRow(
                Icons.date_range_outlined,
                'Fechas',
                '${req.startDate.day}/${req.startDate.month} al ${req.endDate.day}/${req.endDate.month} (${req.daysCount} días)',
                isDark,
              ),
              _buildMobileRow(
                Icons.attach_money_outlined,
                'Remunerado',
                req.isPaid ? 'Con goce de haberes' : 'Sin goce de haberes',
                isDark,
              ),
              _buildMobileRow(Icons.notes_outlined, 'Motivo', req.reason, isDark),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44, // Touch target mínimo de 44px
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Ver Detalle de Permiso'),
                  onPressed: () => _showAbsenceDetailModal(context, req, isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 40,
            color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontraron solicitudes de permiso',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intente con otro término o limpie el buscador.',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _showAbsenceDetailModal(
    BuildContext context,
    AbsenceRequestItem req,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.event_note, color: Color(0xFF10B981), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ficha de Ausencia / Permiso',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      req.employeeName,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModalDetailRow('Tipo de Permiso', req.leaveType, isDark),
                _buildModalDetailRow(
                  'Periodo',
                  '${req.startDate.day}/${req.startDate.month}/${req.startDate.year} al ${req.endDate.day}/${req.endDate.month}/${req.endDate.year}',
                  isDark,
                ),
                _buildModalDetailRow('Total Días', '${req.daysCount} días hábiles', isDark),
                _buildModalDetailRow(
                  'Remuneración',
                  req.isPaid ? 'Con goce de haberes (Remunerado)' : 'Sin goce de haberes',
                  isDark,
                ),
                _buildModalDetailRow('Estado de Aprobación', req.status, isDark),
                _buildModalDetailRow('Justificación / Motivo', req.reason, isDark),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
