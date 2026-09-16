import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/rrhh_audit_service.dart';

/// Vista de Bitácora y Auditoría de Movimientos Exclusivos de RRHH
class RrhhAuditView extends StatefulWidget {
  const RrhhAuditView({super.key});

  @override
  State<RrhhAuditView> createState() => _RrhhAuditViewState();
}

class _RrhhAuditViewState extends State<RrhhAuditView> {
  final RrhhAuditService _auditService = RrhhAuditService.instance;
  String _search = '';
  String _categoryFilter = 'TODOS';
  String _severityFilter = 'TODOS';

  @override
  void initState() {
    super.initState();
    _auditService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _auditService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  List<RrhhAuditEvent> get _filteredEvents {
    return _auditService.allEvents.where((e) {
      final q = _search.toLowerCase();
      final matchesSearch =
          _search.isEmpty ||
          e.employeeName.toLowerCase().contains(q) ||
          e.employeeCode.toLowerCase().contains(q) ||
          e.action.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q) ||
          e.performedBy.toLowerCase().contains(q);

      final matchesCategory =
          _categoryFilter == 'TODOS' || e.category == _categoryFilter;
      final matchesSeverity =
          _severityFilter == 'TODOS' || e.severity == _severityFilter;

      return matchesSearch && matchesCategory && matchesSeverity;
    }).toList();
  }

  void _showAddManualMovementModal() {
    final formKey = GlobalKey<FormState>();
    final employeeCodeCtrl = TextEditingController();
    final employeeNameCtrl = TextEditingController();
    final actionCtrl = TextEditingController();
    final detailsCtrl = TextEditingController();
    String category = 'CONTRATO_SALARIO';
    String severity = 'INFO';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
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
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.post_add_outlined,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registrar Movimiento en Bitácora',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Anotación oficial de RRHH para el historial del colaborador',
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
              content: SizedBox(
                width: 540,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: employeeCodeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Código Colaborador *',
                                  hintText: 'Ej. EMP-001',
                                  prefixIcon: Icon(Icons.tag, size: 16),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: employeeNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre y Apellidos *',
                                  hintText: 'Ej. Juan Pérez',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    size: 16,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: category,
                                decoration: const InputDecoration(
                                  labelText: 'Categoría de Movimiento',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'ALTA_PERSONAL',
                                    child: Text('Alta de Personal'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'CONTRATO_SALARIO',
                                    child: Text('Contrato / Sueldo'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'PERMISO_VACACION',
                                    child: Text('Permiso / Vacación'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'TRASLADO_SEDE',
                                    child: Text('Traslado de Sede'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BAJA_RETIRO',
                                    child: Text('Baja / Desvinculación'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'DOCUMENTOS',
                                    child: Text('Documentos Físicos'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'EXPEDIENTE',
                                    child: Text('Modificación Expediente'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => category = v);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: severity,
                                decoration: const InputDecoration(
                                  labelText: 'Severidad / Impacto',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'INFO',
                                    child: Text('Informativo (INFO)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ADVERTENCIA',
                                    child: Text('Advertencia'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'CRITICO',
                                    child: Text('Crítico / Legal'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => severity = v);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: actionCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Título o Acción del Movimiento *',
                            hintText:
                                'Ej. Firma de Adenda por Aumento Salarial',
                            prefixIcon: Icon(Icons.title, size: 16),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: detailsCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Detalle Exhaustivo del Movimiento *',
                            hintText:
                                'Describa el motivo, acuerdos, fechas o justificación del cambio...',
                            alignLabelWithHint: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Asentar en Bitácora'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      _auditService.logMovement(
                        category: category,
                        action: actionCtrl.text.trim(),
                        employeeCode: employeeCodeCtrl.text
                            .trim()
                            .toUpperCase(),
                        employeeName: employeeNameCtrl.text.trim(),
                        details: detailsCtrl.text.trim(),
                        severity: severity,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Movimiento registrado con éxito en la Bitácora de RRHH',
                          ),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEventDetails(RrhhAuditEvent ev) {
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
                  color: _getSeverityColor(ev.severity).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: _getSeverityColor(ev.severity),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ev.action,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'ID Evento: ${ev.id}',
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
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModalDetailRow(
                  'Módulo',
                  'Recursos Humanos (RRHH) - Ámbito Exclusivo',
                ),
                _buildModalDetailRow(
                  'Colaborador Afectado',
                  '${ev.employeeName} (${ev.employeeCode})',
                ),
                _buildModalDetailRow(
                  'Categoría',
                  _getCategoryLabel(ev.category),
                ),
                _buildModalDetailRow(
                  'Fecha y Hora',
                  '${ev.timestamp.day.toString().padLeft(2, '0')}/${ev.timestamp.month.toString().padLeft(2, '0')}/${ev.timestamp.year} ${ev.timestamp.hour.toString().padLeft(2, '0')}:${ev.timestamp.minute.toString().padLeft(2, '0')} hrs',
                ),
                _buildModalDetailRow('Registrado por', ev.performedBy),
                _buildModalDetailRow('Nivel de Impacto', ev.severity),
                const SizedBox(height: 14),
                Text(
                  'Descripción Detallada del Movimiento:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Text(
                    ev.details,
                    style: GoogleFonts.inter(fontSize: 13, height: 1.45),
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
          ],
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final events = _filteredEvents;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Encabezado y Garantía de Aislamiento
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bitácora de Recursos Humanos',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6366F1,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Exclusivo RRHH',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registro inmutable de movimientos, altas, contratos, vacaciones, traslados y desvinculaciones.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Registrar Movimiento',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  onPressed: _showAddManualMovementModal,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Banner de Regla de Negocio: Aislamiento Cero Fugas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 20,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AUDITORÍA EXCLUSIVA: SOLO MOVIMIENTOS DE RRHH',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Esta bitácora reporta únicamente movimientos del personal de la empresa. No contiene ni mezcla eventos de seguridad informática (logins de TI, contraseñas) ni actividades del CRM.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Tarjetas Resumen de Actividad RRHH
            Row(
              children: [
                _buildSummaryCard(
                  title: 'Total Movimientos RRHH',
                  value: '${_auditService.totalCount}',
                  icon: Icons.history,
                  color: const Color(0xFF6366F1),
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Altas de Personal',
                  value: '${_auditService.altasCount}',
                  icon: Icons.person_add_alt_1,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Permisos & Vacaciones',
                  value: '${_auditService.permisosCount}',
                  icon: Icons.event_available,
                  color: const Color(0xFF3B82F6),
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Alertas Críticas',
                  value: '${_auditService.criticalCount}',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFEF4444),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. Barra de Filtros
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
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            'Buscar por colaborador, código EMP, acción o detalle...',
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
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _categoryFilter,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'TODOS',
                        child: Text('Categoría: Todas'),
                      ),
                      DropdownMenuItem(
                        value: 'ALTA_PERSONAL',
                        child: Text('Altas de Personal'),
                      ),
                      DropdownMenuItem(
                        value: 'CONTRATO_SALARIO',
                        child: Text('Contratos & Sueldos'),
                      ),
                      DropdownMenuItem(
                        value: 'PERMISO_VACACION',
                        child: Text('Permisos & Vacaciones'),
                      ),
                      DropdownMenuItem(
                        value: 'TRASLADO_SEDE',
                        child: Text('Traslados de Sede'),
                      ),
                      DropdownMenuItem(
                        value: 'BAJA_RETIRO',
                        child: Text('Bajas & Retiros'),
                      ),
                      DropdownMenuItem(
                        value: 'DOCUMENTOS',
                        child: Text('Documentación'),
                      ),
                      DropdownMenuItem(
                        value: 'EXPEDIENTE',
                        child: Text('Expediente Digital'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _categoryFilter = v);
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _severityFilter,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'TODOS',
                        child: Text('Severidad: Todas'),
                      ),
                      DropdownMenuItem(
                        value: 'INFO',
                        child: Text('Informativos (INFO)'),
                      ),
                      DropdownMenuItem(
                        value: 'ADVERTENCIA',
                        child: Text('Advertencias'),
                      ),
                      DropdownMenuItem(
                        value: 'CRITICO',
                        child: Text('Críticos / Urgentes'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _severityFilter = v);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5. Tabla de Movimientos de la Bitácora
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
                child: events.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.filter_alt_off_outlined,
                                size: 40,
                                color: isDark
                                    ? const Color(0xFF475569)
                                    : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No se encontraron movimientos con los filtros aplicados.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (layoutCtx, constraints) {
                          final isMobile = constraints.maxWidth < 768;
                          if (isMobile) {
                            return _buildAuditMobileCardView(events, isDark);
                          }
                          return _buildAuditDesktopTable(
                            events,
                            isDark,
                            constraints.maxWidth,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditDesktopTable(
    List<RrhhAuditEvent> events,
    bool isDark,
    double maxWidth,
  ) {
    final tableWidth = max(maxWidth, 1060.0);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: tableWidth,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.6), // Fecha y Hora
            1: FlexColumnWidth(1.8), // Categoría RRHH
            2: FlexColumnWidth(2.0), // Colaborador
            3: FlexColumnWidth(2.6), // Acción Realizada
            4: FlexColumnWidth(2.0), // Registrado por
            5: FlexColumnWidth(1.2), // Severidad
            6: FlexColumnWidth(1.0), // Detalles
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Fila de Encabezado
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
                _buildAuditHeaderCell('Fecha y Hora', isDark),
                _buildAuditHeaderCell('Categoría RRHH', isDark),
                _buildAuditHeaderCell('Colaborador', isDark),
                _buildAuditHeaderCell('Acción Realizada', isDark),
                _buildAuditHeaderCell('Registrado por', isDark),
                _buildAuditHeaderCell('Severidad', isDark),
                _buildAuditHeaderCell('Detalles', isDark, alignment: Alignment.centerRight),
              ],
            ),
            // Filas de Datos
            ...events.map((ev) {
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
                  // Fecha y Hora
                  _buildAuditBodyCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${ev.timestamp.day.toString().padLeft(2, '0')}/${ev.timestamp.month.toString().padLeft(2, '0')}/${ev.timestamp.year}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${ev.timestamp.hour.toString().padLeft(2, '0')}:${ev.timestamp.minute.toString().padLeft(2, '0')} hrs',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Categoría
                  _buildAuditBodyCell(_buildCategoryBadge(ev.category)),
                  // Colaborador
                  _buildAuditBodyCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ev.employeeName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ev.employeeCode,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Acción
                  _buildAuditBodyCell(
                    Text(
                      ev.action,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Registrado por
                  _buildAuditBodyCell(
                    Text(
                      ev.performedBy,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Severidad
                  _buildAuditBodyCell(_buildSeverityBadge(ev.severity)),
                  // Detalles
                  _buildAuditBodyCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'Ver detalle del movimiento',
                        onPressed: () => _showEventDetails(ev),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditMobileCardView(
    List<RrhhAuditEvent> events,
    bool isDark,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (sepCtx, index) => const SizedBox(height: 12),
      itemBuilder: (itemCtx, index) {
        final ev = events[index];
        return Container(
          padding: const EdgeInsets.all(14),
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
                  Text(
                    '${ev.timestamp.day.toString().padLeft(2, '0')}/${ev.timestamp.month.toString().padLeft(2, '0')}/${ev.timestamp.year} ${ev.timestamp.hour.toString().padLeft(2, '0')}:${ev.timestamp.minute.toString().padLeft(2, '0')}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  _buildSeverityBadge(ev.severity),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildCategoryBadge(ev.category),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${ev.employeeName} (${ev.employeeCode})',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ev.action,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Por: ${ev.performedBy}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44, // Touch target mínimo de 44px
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Ver Detalle del Movimiento'),
                  onPressed: () => _showEventDetails(ev),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuditHeaderCell(
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

  Widget _buildAuditBodyCell(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: child,
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
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

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'CRITICO':
        return const Color(0xFFEF4444);
      case 'ADVERTENCIA':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'ALTA_PERSONAL':
        return 'Alta de Personal';
      case 'CONTRATO_SALARIO':
        return 'Contrato & Sueldo';
      case 'PERMISO_VACACION':
        return 'Permiso / Vacación';
      case 'TRASLADO_SEDE':
        return 'Traslado de Sede';
      case 'BAJA_RETIRO':
        return 'Baja / Desvinculación';
      case 'DOCUMENTOS':
        return 'Documentos Físicos';
      case 'EXPEDIENTE':
        return 'Expediente Digital';
      default:
        return category;
    }
  }

  Widget _buildCategoryBadge(String category) {
    Color color;
    IconData icon;
    switch (category) {
      case 'ALTA_PERSONAL':
        color = const Color(0xFF10B981);
        icon = Icons.person_add_outlined;
        break;
      case 'CONTRATO_SALARIO':
        color = const Color(0xFF3B82F6);
        icon = Icons.description_outlined;
        break;
      case 'PERMISO_VACACION':
        color = const Color(0xFF8B5CF6);
        icon = Icons.event_available_outlined;
        break;
      case 'TRASLADO_SEDE':
        color = const Color(0xFFF59E0B);
        icon = Icons.sync_alt_outlined;
        break;
      case 'BAJA_RETIRO':
        color = const Color(0xFFEF4444);
        icon = Icons.person_remove_outlined;
        break;
      case 'DOCUMENTOS':
        color = const Color(0xFF06B6D4);
        icon = Icons.folder_shared_outlined;
        break;
      case 'EXPEDIENTE':
        color = const Color(0xFFEC4899);
        icon = Icons.badge_outlined;
        break;
      default:
        color = const Color(0xFF64748B);
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            _getCategoryLabel(category),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    final color = _getSeverityColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        severity,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
