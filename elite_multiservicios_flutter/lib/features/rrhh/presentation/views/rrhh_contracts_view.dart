import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo en memoria de Contrato o Asignación Laboral
class ContractItem {
  final String id;
  final String employeeCode;
  final String employeeName;
  final String
  contractType; // 'Indefinido', 'Plazo Fijo (1 año)', 'Prestación de Servicios'
  final String position;
  final String workplace; // Sucursal o Sede Operativa
  final DateTime startDate;
  final DateTime? endDate;
  final double wage;
  final String status; // 'Vigente', 'Vencido', 'En Renovación'

  const ContractItem({
    required this.id,
    required this.employeeCode,
    required this.employeeName,
    required this.contractType,
    required this.position,
    required this.workplace,
    required this.startDate,
    this.endDate,
    required this.wage,
    required this.status,
  });
}

/// Vista de Gestión de Contratos y Asignaciones Laborales
class RrhhContractsView extends StatefulWidget {
  const RrhhContractsView({super.key});

  @override
  State<RrhhContractsView> createState() => _RrhhContractsViewState();
}

class _RrhhContractsViewState extends State<RrhhContractsView> {
  String _search = '';

  final List<ContractItem> _contracts = [
    ContractItem(
      id: 'cnt-101',
      employeeCode: 'EMP-001',
      employeeName: 'Carlos Mendoza Rios',
      contractType: 'Contrato Indefinido',
      position: 'Técnico Especialista en Mantenimiento',
      workplace: 'Sede Central Santa Cruz',
      startDate: DateTime(2023, 3, 15),
      wage: 4500.0,
      status: 'Vigente',
    ),
    ContractItem(
      id: 'cnt-102',
      employeeCode: 'EMP-002',
      employeeName: 'Valeria Justiniano Paz',
      contractType: 'Contrato Indefinido',
      position: 'Supervisora de Operaciones',
      workplace: 'Sede Operativa Norte',
      startDate: DateTime(2023, 7, 1),
      wage: 4200.0,
      status: 'Vigente',
    ),
    ContractItem(
      id: 'cnt-103',
      employeeCode: 'EMP-003',
      employeeName: 'Jorge Luis Aguilera',
      contractType: 'Plazo Fijo (1 Año)',
      position: 'Operador de Maquinaria Industrial',
      workplace: 'Planta Industrial Warnes',
      startDate: DateTime(2024, 1, 10),
      endDate: DateTime(2025, 1, 9),
      wage: 3800.0,
      status: 'En Renovación',
    ),
    ContractItem(
      id: 'cnt-104',
      employeeCode: 'EMP-004',
      employeeName: 'Andrea Soliz Arteaga',
      contractType: 'Prestación de Servicios',
      position: 'Encargada de Compras y Almacén',
      workplace: 'Oficina Administrativa',
      startDate: DateTime(2023, 11, 20),
      wage: 4000.0,
      status: 'Vigente',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _contracts.where((c) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return c.employeeName.toLowerCase().contains(q) ||
          c.employeeCode.toLowerCase().contains(q) ||
          c.contractType.toLowerCase().contains(q) ||
          c.position.toLowerCase().contains(q);
    }).toList();

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
                      'Contratos & Asignaciones',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Control de periodos laborales, vigencia de contratos y cargos por sede.',
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
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.gavel_outlined,
                        size: 16,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'REQUIERE VALIDACIÓN LEGAL/CONTABLE',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Buscador
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText:
                      'Buscar por colaborador, código de ficha o tipo de contrato...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),

            const SizedBox(height: 20),

            // Tabla de Contratos
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
                          'Colaborador',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tipo de Contrato',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Cargo / Sede',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Vigencia',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Salario Base',
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
                    ],
                    rows: filtered.map((cnt) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cnt.employeeName,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  cnt.employeeCode,
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
                              cnt.contractType,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cnt.position,
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                                Text(
                                  cnt.workplace,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              cnt.endDate != null
                                  ? '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} - ${cnt.endDate!.day}/${cnt.endDate!.month}/${cnt.endDate!.year}'
                                  : '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} (Indefinido)',
                              style: GoogleFonts.inter(fontSize: 11),
                            ),
                          ),
                          DataCell(
                            Text(
                              'Bs. ${cnt.wage.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
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
                                    (cnt.status == 'Vigente'
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFF59E0B))
                                        .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                cnt.status,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: cnt.status == 'Vigente'
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                ),
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
