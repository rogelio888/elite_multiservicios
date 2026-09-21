import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_employee.dart';
import '../utils/rrhh_payroll_exporter.dart';

/// Modal interactivo para configurar y descargar la Planilla Oficial de Sueldos y Salarios
/// bajo el formato normativo del Ministerio de Trabajo / Contabilidad de Bolivia.
class RrhhExportPayrollDialog extends StatefulWidget {
  final List<RrhhEmployee> employees;

  const RrhhExportPayrollDialog({
    super.key,
    required this.employees,
  });

  @override
  State<RrhhExportPayrollDialog> createState() =>
      _RrhhExportPayrollDialogState();
}

class _RrhhExportPayrollDialogState extends State<RrhhExportPayrollDialog> {
  final _months = const [
    'ENERO',
    'FEBRERO',
    'MARZO',
    'ABRIL',
    'MAYO',
    'JUNIO',
    'JULIO',
    'AGOSTO',
    'SEPTIEMBRE',
    'OCTUBRE',
    'NOVIEMBRE',
    'DICIEMBRE',
  ];

  late String _selectedMonth;
  int _selectedYear = 2026;
  late TextEditingController _representativeController;
  late TextEditingController _ciController;
  late TextEditingController _cityController;

  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = _months[now.month - 1];
    _selectedYear = now.year;
    _representativeController = TextEditingController(
      text: 'ROGELIO ARANDIA ARANDIA',
    );
    _ciController = TextEditingController(text: '4444455 OR');
    _cityController = TextEditingController(text: 'La Paz');
  }

  @override
  void dispose() {
    _representativeController.dispose();
    _ciController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Métricas previas del personal filtrado/activo
    final activeEmployees = widget.employees
        .where((e) => e.status == 'ACTIVO')
        .toList();
    final count = activeEmployees.length;
    final totalSalary = activeEmployees.fold<double>(
      0,
      (sum, e) => sum + e.baseSalary,
    );
    final estGestora = totalSalary * 0.1271;
    final estLiquido = totalSalary - estGestora;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 580,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera del Diálogo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.table_view_rounded,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exportar Planilla de Sueldos y Salarios',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Formato Oficial Min. de Trabajo / OVT & Contabilidad (NIT: 4625505019)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selección Período
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes de la Planilla',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0B1324)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedMonth,
                                  isExpanded: true,
                                  dropdownColor: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  items: _months.map((m) {
                                    return DropdownMenuItem(
                                      value: m,
                                      child: Text(
                                        m,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedMonth = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Año',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0B1324)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedYear,
                                  isExpanded: true,
                                  dropdownColor: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  items: [2025, 2026, 2027].map((y) {
                                    return DropdownMenuItem(
                                      value: y,
                                      child: Text(
                                        '$y',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedYear = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Resumen Proyectado de Nómina
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1324)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Resumen de la Planilla a Generar',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricItem(
                                label: 'Colaboradores',
                                value: '$count personas',
                                isDark: isDark,
                              ),
                            ),
                            Expanded(
                              child: _buildMetricItem(
                                label: 'Total Ganado Base',
                                value: 'Bs. ${totalSalary.toStringAsFixed(2)}',
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricItem(
                                label: 'Gestora (12.71%)',
                                value: 'Bs. ${estGestora.toStringAsFixed(2)}',
                                isDark: isDark,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                            Expanded(
                              child: _buildMetricItem(
                                label: 'Líquido Estimado',
                                value: 'Bs. ${estLiquido.toStringAsFixed(2)}',
                                isDark: isDark,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Datos del Representante Legal (Pie de página oficial)
                  Text(
                    'Certificación y Representación Legal (Pie de página oficial)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _representativeController,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Representante Legal',
                            labelStyle: GoogleFonts.inter(fontSize: 11),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _ciController,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'C.I. Representante',
                            labelStyle: GoogleFonts.inter(fontSize: 11),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _cityController,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Ciudad de Emisión',
                            labelStyle: GoogleFonts.inter(fontSize: 11),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Acciones Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isExporting
                        ? null
                        : () {
                            setState(() => _isExporting = true);
                            try {
                              RrhhPayrollExporter.exportToExcel(
                                employees: activeEmployees,
                                monthName: _selectedMonth,
                                year: _selectedYear,
                                representativeName: _representativeController
                                    .text
                                    .trim(),
                                representativeCi: _ciController.text.trim(),
                                legalCity: _cityController.text.trim(),
                              );

                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF10B981),
                                  duration: const Duration(seconds: 4),
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '¡Planilla de Sueldos ($_selectedMonth $_selectedYear) descargada con éxito! Formato oficial Min. de Trabajo generado.',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              setState(() => _isExporting = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFFEF4444),
                                  content: Text(
                                    'Error al generar la planilla: $e',
                                  ),
                                ),
                              );
                            }
                          },
                    icon: _isExporting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      _isExporting
                          ? 'Generando...'
                          : 'Descargar Planilla Oficial (.xls)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildMetricItem({
    required String label,
    required String value,
    required bool isDark,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }
}
