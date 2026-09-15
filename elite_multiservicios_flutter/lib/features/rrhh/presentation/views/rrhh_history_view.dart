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
  final String
  reason; // 'Renuncia Voluntaria', 'Fin de Contrato', 'Mutuo Acuerdo'
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
                'Se reactivará la ficha de ${record.employeeName} (${record.employeeCode}) conservando su histórico anterior e iniciando un nuevo periodo contractual.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF334155),
                ),
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
                child: Text(
                  'Regla inquebrantable: No se duplica la persona en la base de datos. Se genera un nuevo Contrato vinculado al mismo identificador.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Proceso de recontratación iniciado para ${record.employeeName}.',
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                      const Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
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
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tabla de Bajas
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
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 72,
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
                          'Ex-Colaborador',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Último Cargo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Fecha de Baja',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Motivo de Salida',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Registrado Por',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Acciones',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    rows: _records.map((rec) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  rec.employeeName,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  rec.employeeCode,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              rec.lastPosition,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${rec.terminationDate.day}/${rec.terminationDate.month}/${rec.terminationDate.year}',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFEF4444,
                                ).withValues(alpha: 0.12),
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
                          ),
                          DataCell(
                            Text(
                              rec.registeredBy,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          DataCell(
                            FilledButton.tonalIcon(
                              style: FilledButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                              ),
                              icon: const Icon(Icons.refresh, size: 14),
                              label: const Text(
                                'Recontratar',
                                style: TextStyle(fontSize: 11),
                              ),
                              onPressed: () => _showRehireDialog(rec),
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
