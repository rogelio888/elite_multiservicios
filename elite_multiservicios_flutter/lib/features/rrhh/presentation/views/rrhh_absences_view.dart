import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de Solicitud de Permiso o Vacación
class AbsenceRequestItem {
  final String id;
  final String employeeName;
  final String
  leaveType; // 'Vacación Anual', 'Permiso Médico', 'Duelo Familiar', 'Paternidad'
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sync_alt,
                        size: 16,
                        color: Color(0xFF3B82F6),
                      ),
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
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Banner informativo de configuración flexible
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFBBF7D0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF10B981),
                    size: 22,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Catálogo configurable: Los tipos de permisos (médico, duelo, paternidad, etc.) son parametrizables sin alterar código fuente, permitiendo adaptar días y remuneración según validación legal.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tabla de Solicitudes
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 64,
                    headingRowHeight: 48,
                    horizontalMargin: 16,
                    columnSpacing: 24,
                    headingRowColor: WidgetStatePropertyAll(
                      isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF8FAFC),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Colaborador',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tipo de Permiso',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Fechas',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Días',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Remunerado',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Estado',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Motivo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    rows: _requests.map((req) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              req.employeeName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              req.leaveType,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${req.startDate.day}/${req.startDate.month} - ${req.endDate.day}/${req.endDate.month}',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${req.daysCount} d',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Icon(
                              req.isPaid ? Icons.check_circle : Icons.cancel,
                              color: req.isPaid
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF94A3B8),
                              size: 16,
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (req.status == 'Aprobado'
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
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 240),
                              child: Text(
                                req.reason,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
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
      ),
    );
  }
}
