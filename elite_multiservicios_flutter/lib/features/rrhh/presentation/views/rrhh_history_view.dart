import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de Historial de Bajas y Retiros
class TerminationRecord {
  final String id;
  final String employeeCode;
  final String employeeName;
  final String lastPosition;
  final DateTime hireDate;
  final DateTime terminationDate;
  final String reason; // 'Renuncia Voluntaria', 'Fin de Contrato', 'Mutuo Acuerdo'
  final String registeredBy;
  final String notes;

  const TerminationRecord({
    required this.id,
    required this.employeeCode,
    required this.employeeName,
    required this.lastPosition,
    required this.hireDate,
    required this.terminationDate,
    required this.reason,
    required this.registeredBy,
    required this.notes,
  });
}

/// Vista de Bajas, Retiros e Historial Laboral / Recontratación
class RrhhHistoryView extends StatefulWidget {
  const RrhhHistoryView({super.key});

  @override
  State<RrhhHistoryView> createState() => _RrhhHistoryViewState();
}

class _RrhhHistoryViewState extends State<RrhhHistoryView> {
  String _search = '';

  final List<TerminationRecord> _records = [
    TerminationRecord(
      id: 'term-001',
      employeeCode: 'EMP-012',
      employeeName: 'Martín Paredes Choque',
      lastPosition: 'Auxiliar de Limpieza Hospitalaria',
      hireDate: DateTime(2022, 5, 10),
      terminationDate: DateTime(2023, 12, 31),
      reason: 'Fin de Contrato Plazo Fijo',
      registeredBy: 'admin@elitemultiservicios.com',
      notes:
          'Culminó periodo acordado para obra hospitalaria. Cumplió con entrega de implementos.',
    ),
    TerminationRecord(
      id: 'term-002',
      employeeCode: 'EMP-018',
      employeeName: 'Lucía Fernández Ramos',
      lastPosition: 'Recepcionista y Atención al Cliente',
      hireDate: DateTime(2023, 1, 15),
      terminationDate: DateTime(2024, 2, 28),
      reason: 'Renuncia Voluntaria',
      registeredBy: 'admin@elitemultiservicios.com',
      notes:
          'Renuncia por motivos de estudio universitario. Expediente en orden para recontratación futura.',
    ),
  ];

  void _showRehireDialog(TerminationRecord record) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recontratar Colaborador',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Desea iniciar el proceso de reactivación/recontratación para ${record.employeeName} (${record.employeeCode})?',
                style: GoogleFonts.inter(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Último cargo: ${record.lastPosition}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Motivo de salida: ${record.reason}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Observaciones previas: ${record.notes}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Se ha iniciado el expediente de recontratación para ${record.employeeName}.',
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Iniciar Nuevo Periodo Laboral'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _records.where((r) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return r.employeeName.toLowerCase().contains(q) ||
          r.employeeCode.toLowerCase().contains(q) ||
          r.lastPosition.toLowerCase().contains(q) ||
          r.reason.toLowerCase().contains(q);
    }).toList();

    final totalBajas = _records.length;
    final totalRenuncias = _records.where((r) => r.reason.contains('Renuncia')).length;
    final totalFinContrato = _records.where((r) => r.reason.contains('Fin de Contrato')).length;

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
                        'Bajas & Historial Laboral',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Auditoría y trazabilidad histórica de desvinculaciones.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildZeroLossBadge(),
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
                            'Bajas & Historial Laboral',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Auditoría y trazabilidad histórica de desvinculaciones y recontrataciones sin pérdida de datos.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      _buildZeroLossBadge(),
                    ],
                  ),

                const SizedBox(height: 20),

                // Tarjetas KPI Rápidas
                if (isMobile)
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildKpiCard('Total Bajas Registradas', '$totalBajas', Icons.history_outlined, const Color(0xFFEF4444), isDark),
                          const SizedBox(width: 12),
                          _buildKpiCard('Renuncias Voluntarias', '$totalRenuncias', Icons.person_off_outlined, const Color(0xFFF59E0B), isDark),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildKpiCard('Fin de Contrato', '$totalFinContrato', Icons.event_busy_outlined, const Color(0xFF3B82F6), isDark),
                          const SizedBox(width: 12),
                          _buildKpiCard('Expedientes Aptos Reingreso', '$totalBajas', Icons.how_to_reg_outlined, const Color(0xFF10B981), isDark),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildKpiCard('Total Bajas Registradas', '$totalBajas', Icons.history_outlined, const Color(0xFFEF4444), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Renuncias Voluntarias', '$totalRenuncias', Icons.person_off_outlined, const Color(0xFFF59E0B), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Fin de Contrato', '$totalFinContrato', Icons.event_busy_outlined, const Color(0xFF3B82F6), isDark),
                      const SizedBox(width: 16),
                      _buildKpiCard('Expedientes Aptos Reingreso', '$totalBajas', Icons.how_to_reg_outlined, const Color(0xFF10B981), isDark),
                    ],
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
                      hintText: 'Buscar por ex-colaborador, código de ficha o motivo de salida...',
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

  Widget _buildZeroLossBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Text(
            'POLÍTICA ZERO DATA LOSS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF10B981),
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
    List<TerminationRecord> records,
    bool isDark,
    double maxWidth,
  ) {
    if (records.isEmpty) {
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
                0: FlexColumnWidth(2.3), // Ex-Colaborador
                1: FlexColumnWidth(2.3), // Último Cargo
                2: FlexColumnWidth(1.6), // Fecha de Baja
                3: FlexColumnWidth(2.0), // Motivo de Salida
                4: FlexColumnWidth(2.2), // Registrado Por
                5: FlexColumnWidth(1.4), // Acciones
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
                    _buildHeaderCell('Ex-Colaborador', isDark),
                    _buildHeaderCell('Último Cargo', isDark),
                    _buildHeaderCell('Fecha de Baja', isDark),
                    _buildHeaderCell('Motivo de Salida', isDark),
                    _buildHeaderCell('Registrado Por', isDark),
                    _buildHeaderCell('Acciones', isDark, alignment: Alignment.centerRight),
                  ],
                ),
                // Rows
                ...records.map((rec) {
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
                      // Ex-Colaborador
                      _buildBodyCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              rec.employeeName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rec.employeeCode,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Último Cargo
                      _buildBodyCell(
                        Text(
                          rec.lastPosition,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // Fecha de Baja
                      _buildBodyCell(
                        Text(
                          '${rec.terminationDate.day}/${rec.terminationDate.month}/${rec.terminationDate.year}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Motivo
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              rec.reason,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Registrado Por
                      _buildBodyCell(
                        Text(
                          rec.registeredBy,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      // Acciones
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            icon: const Icon(Icons.refresh, size: 14),
                            label: const Text(
                              'Recontratar',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => _showRehireDialog(rec),
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
    List<TerminationRecord> records,
    bool isDark,
  ) {
    if (records.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      separatorBuilder: (sepCtx, index) => const SizedBox(height: 12),
      itemBuilder: (itemCtx, index) {
        final rec = records[index];
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.employeeName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          rec.employeeCode,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rec.reason,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMobileRow(Icons.work_outline, 'Último Cargo', rec.lastPosition, isDark),
              _buildMobileRow(
                Icons.calendar_today_outlined,
                'Periodo Laboral',
                '${rec.hireDate.day}/${rec.hireDate.month}/${rec.hireDate.year} al ${rec.terminationDate.day}/${rec.terminationDate.month}/${rec.terminationDate.year}',
                isDark,
              ),
              _buildMobileRow(Icons.person_outline, 'Registrado Por', rec.registeredBy, isDark),
              _buildMobileRow(Icons.notes_outlined, 'Observaciones', rec.notes, isDark),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44, // Touch target mínimo de 44px
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Iniciar Recontratación'),
                  onPressed: () => _showRehireDialog(rec),
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
            'No se encontraron registros de bajas coincidentes',
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
}
