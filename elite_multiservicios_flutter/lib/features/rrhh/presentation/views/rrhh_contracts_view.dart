import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo en memoria de Contrato o Asignación Laboral
class ContractItem {
  final String id;
  final String employeeCode;
  final String employeeName;
  final String contractType; // 'Indefinido', 'Plazo Fijo (1 año)', 'Prestación de Servicios'
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
      contractType: 'Contrato Indefinido',
      position: 'Encargada de Marketing Digital & Branding',
      workplace: 'Oficina Central Elite',
      startDate: DateTime(2023, 11, 20),
      wage: 5200.0,
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
          c.position.toLowerCase().contains(q) ||
          c.workplace.toLowerCase().contains(q);
    }).toList();

    final totalActivos = _contracts.where((c) => c.status == 'Vigente').length;
    final totalIndefinidos = _contracts.where((c) => c.contractType.contains('Indefinido')).length;
    final totalPlazoFijo = _contracts.where((c) => !c.contractType.contains('Indefinido')).length;
    final totalRenovacion = _contracts.where((c) => c.status == 'En Renovación').length;

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
                // Encabezado adaptable
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contratos & Asignaciones',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Control de periodos laborales y asignaciones de cargo.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLegalBadge(),
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
                      _buildLegalBadge(),
                    ],
                  ),

                const SizedBox(height: 20),

                // Tarjetas KPI Rápidas
                if (isMobile)
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildKpiCard(
                            title: 'Total Vigentes',
                            value: '$totalActivos',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF10B981),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          _buildKpiCard(
                            title: 'Indefinidos',
                            value: '$totalIndefinidos',
                            icon: Icons.assignment_turned_in_outlined,
                            color: const Color(0xFF3B82F6),
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildKpiCard(
                            title: 'Plazo Fijo / Serv.',
                            value: '$totalPlazoFijo',
                            icon: Icons.timelapse_outlined,
                            color: const Color(0xFF8B5CF6),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          _buildKpiCard(
                            title: 'En Renovación',
                            value: '$totalRenovacion',
                            icon: Icons.pending_actions_outlined,
                            color: const Color(0xFFF59E0B),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildKpiCard(
                        title: 'Total Vigentes',
                        value: '$totalActivos',
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildKpiCard(
                        title: 'Contratos Indefinidos',
                        value: '$totalIndefinidos',
                        icon: Icons.assignment_turned_in_outlined,
                        color: const Color(0xFF3B82F6),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildKpiCard(
                        title: 'Plazo Fijo / Servicios',
                        value: '$totalPlazoFijo',
                        icon: Icons.timelapse_outlined,
                        color: const Color(0xFF8B5CF6),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildKpiCard(
                        title: 'En Renovación',
                        value: '$totalRenovacion',
                        icon: Icons.pending_actions_outlined,
                        color: const Color(0xFFF59E0B),
                        isDark: isDark,
                      ),
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
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildLegalBadge() {
    return Container(
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
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
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
    List<ContractItem> contracts,
    bool isDark,
    double maxWidth,
  ) {
    if (contracts.isEmpty) {
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
                0: FlexColumnWidth(2.3), // Colaborador
                1: FlexColumnWidth(1.8), // Tipo de Contrato
                2: FlexColumnWidth(2.3), // Cargo / Sede
                3: FlexColumnWidth(1.8), // Vigencia
                4: FlexColumnWidth(1.3), // Salario Base
                5: FlexColumnWidth(1.1), // Estado
                6: FlexColumnWidth(1.1), // Acciones
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Fila de encabezado
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF161F30)
                        : const Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    _buildHeaderCell('Colaborador', isDark),
                    _buildHeaderCell('Tipo de Contrato', isDark),
                    _buildHeaderCell('Cargo / Sede', isDark),
                    _buildHeaderCell('Vigencia', isDark),
                    _buildHeaderCell('Salario Base', isDark),
                    _buildHeaderCell('Estado', isDark),
                    _buildHeaderCell(
                      'Acciones',
                      isDark,
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
                // Filas de datos
                ...contracts.map((cnt) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      // Colaborador
                      _buildBodyCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cnt.employeeName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cnt.employeeCode,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tipo de Contrato
                      _buildBodyCell(
                        Text(
                          cnt.contractType,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // Cargo / Sede
                      _buildBodyCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cnt.position,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cnt.workplace,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Vigencia
                      _buildBodyCell(
                        Text(
                          cnt.endDate != null
                              ? '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} - ${cnt.endDate!.day}/${cnt.endDate!.month}/${cnt.endDate!.year}'
                              : '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} (Indefinido)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // Salario Base
                      _buildBodyCell(
                        Text(
                          'Bs. ${cnt.wage.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Estado
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: (cnt.status == 'Vigente'
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B))
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: (cnt.status == 'Vigente'
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B))
                                    .withValues(alpha: 0.3),
                              ),
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
                      ),
                      // Acciones
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              visualDensity: VisualDensity.compact,
                              side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                            icon: const Icon(Icons.description_outlined, size: 14),
                            label: Text(
                              'Ficha',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => _showContractDetailsModal(
                              context,
                              cnt,
                              isDark,
                            ),
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
    List<ContractItem> contracts,
    bool isDark,
  ) {
    if (contracts.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contracts.length,
      separatorBuilder: (sepCtx, index) => const SizedBox(height: 12),
      itemBuilder: (itemCtx, index) {
        final cnt = contracts[index];
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
                          cnt.employeeName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          cnt.employeeCode,
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
                      color: (cnt.status == 'Vigente'
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
                ],
              ),
              const SizedBox(height: 12),
              _buildMobileItemRow(Icons.badge_outlined, 'Tipo', cnt.contractType, isDark),
              _buildMobileItemRow(Icons.business_outlined, 'Cargo', '${cnt.position} (${cnt.workplace})', isDark),
              _buildMobileItemRow(
                Icons.calendar_today_outlined,
                'Vigencia',
                cnt.endDate != null
                    ? '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} - ${cnt.endDate!.day}/${cnt.endDate!.month}/${cnt.endDate!.year}'
                    : '${cnt.startDate.day}/${cnt.startDate.month}/${cnt.startDate.year} (Indefinido)',
                isDark,
              ),
              _buildMobileItemRow(Icons.payments_outlined, 'Salario', 'Bs. ${cnt.wage.toStringAsFixed(2)}', isDark),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44, // Touch target óptimo para móvil
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('Ver Ficha Contractual'),
                  onPressed: () => _showContractDetailsModal(context, cnt, isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileItemRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              overflow: TextOverflow.ellipsis,
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
            'No se encontraron contratos coincidentes',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intente con otro término de búsqueda o limpie el filtro.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showContractDetailsModal(
    BuildContext context,
    ContractItem contract,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
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
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF3B82F6),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ficha Contractual & Asignación',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${contract.employeeName} (${contract.employeeCode})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (contract.status == 'Vigente'
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B))
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  contract.status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: contract.status == 'Vigente'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Tipo de Contrato', contract.contractType, isDark),
                _buildDetailRow('Cargo Oficial', contract.position, isDark),
                _buildDetailRow('Sede / Ubicación', contract.workplace, isDark),
                _buildDetailRow(
                  'Periodo de Vigencia',
                  contract.endDate != null
                      ? '${contract.startDate.day}/${contract.startDate.month}/${contract.startDate.year} al ${contract.endDate!.day}/${contract.endDate!.month}/${contract.endDate!.year}'
                      : 'Desde ${contract.startDate.day}/${contract.startDate.month}/${contract.startDate.year} (Indefinido)',
                  isDark,
                ),
                _buildDetailRow(
                  'Salario Mensual Pactado',
                  'Bs. ${contract.wage.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Contrato respaldado bajo la Ley General del Trabajo y validado por Asesoría Legal de Elite Multiservicios.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cerrar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              icon: const Icon(Icons.print_outlined, size: 16),
              label: const Text('Imprimir Ficha'),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Generando copia legal para ${contract.employeeName}...',
                    ),
                    backgroundColor: const Color(0xFF2563EB),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
