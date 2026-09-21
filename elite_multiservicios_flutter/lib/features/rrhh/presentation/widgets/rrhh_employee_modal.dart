import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';
import 'rrhh_shared_widgets.dart';

/// Modal para el Expediente Digital 360° del Colaborador (5 pestañas)
class RrhhEmployeeModal extends StatefulWidget {
  final RrhhEmployee employee;

  const RrhhEmployeeModal({super.key, required this.employee});

  @override
  State<RrhhEmployeeModal> createState() => _RrhhEmployeeModalState();
}

class _RrhhEmployeeModalState extends State<RrhhEmployeeModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RrhhEmployee _emp;
  bool _isEditingDocs = false;

  late bool _hasCiCopy;
  late bool _hasUtilityBill;
  late bool _hasHomeSketch;
  late bool _hasFelccRecord;
  late bool _hasPhoto3x4;
  late bool _hasSusInsurance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _emp = widget.employee;
    _initDocState();
  }

  void _initDocState() {
    _hasCiCopy = _emp.hasCiCopy;
    _hasUtilityBill = _emp.hasUtilityBill;
    _hasHomeSketch = _emp.hasHomeSketch;
    _hasFelccRecord = _emp.hasFelccRecord;
    _hasPhoto3x4 = _emp.hasPhoto3x4;
    _hasSusInsurance = _emp.hasSusInsurance;
  }

  int get _currentEditingDocsCount {
    int count = 0;
    if (_hasCiCopy) count++;
    if (_hasUtilityBill) count++;
    if (_hasHomeSketch) count++;
    if (_hasFelccRecord) count++;
    if (_hasPhoto3x4) count++;
    if (_hasSusInsurance) count++;
    return count;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emp = _emp;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Container(
        width: 780,
        height: 640,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del Expediente con Avatar, Nombre, Cargo, Sede y Estado
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(
                    0xFF2563EB,
                  ).withValues(alpha: 0.15),
                  child: Text(
                    emp.fullName.isNotEmpty
                        ? emp.fullName.substring(0, 1)
                        : '?',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              emp.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RrhhStatusChip(status: emp.status),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${emp.code} • ${emp.position}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RrhhEmployeeTypeBadge(employeeType: emp.employeeType),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // TabBar con las 5 pestañas
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF2563EB),
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.person_outline, size: 16),
                  text: 'Datos Personales',
                ),
                Tab(
                  icon: Icon(Icons.work_outline, size: 16),
                  text: 'Info Laboral',
                ),
                Tab(
                  icon: Icon(Icons.folder_open_outlined, size: 16),
                  text: 'Documentos',
                ),
                Tab(
                  icon: Icon(Icons.vpn_key_outlined, size: 16),
                  text: 'Credenciales APK',
                ),
                Tab(
                  icon: Icon(Icons.history, size: 16),
                  text: 'Historial & Trazabilidad',
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Contenido de las pestañas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalTab(emp, isDark),
                  _buildLaborTab(emp, isDark),
                  _buildDocumentsTab(emp, isDark),
                  _buildCredentialsTab(emp, isDark),
                  _buildHistoryTab(emp, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTab(RrhhEmployee emp, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('C.I. / Documento:', emp.identityCard, isDark),
          _buildDetailRow('Lugar de Nacimiento:', emp.birthPlace, isDark),
          _buildDetailRow(
            'Fecha de Nacimiento:',
            emp.birthDate != null
                ? '${emp.birthDate!.day}/${emp.birthDate!.month}/${emp.birthDate!.year}'
                : 'No registrada',
            isDark,
          ),
          _buildDetailRow('Teléfono Celular:', emp.phone, isDark),
          _buildDetailRow('Dirección Domicilio:', emp.address, isDark),
          _buildDetailRow('Ocupación / Oficio:', emp.occupation, isDark),
          _buildDetailRow(
            'Referencia Personal:',
            '${emp.personalReference} (${emp.referencePhone})',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLaborTab(RrhhEmployee emp, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Tipo de Personal:',
            emp.employeeType == 'OFICINA'
                ? 'Administrativo de Oficina Central'
                : 'Operativo en Campo / Sede Cliente',
            isDark,
          ),
          _buildDetailRow('Área Funcional:', emp.area, isDark),
          _buildDetailRow('Cargo / Función:', emp.position, isDark),
          _buildDetailRow('Especialidad:', emp.specialty, isDark),
          _buildDetailRow('Sede / Lugar de Trabajo:', emp.workplace, isDark),
          _buildDetailRow('Supervisor / Responsable:', emp.supervisor, isDark),
          _buildDetailRow(
            'Fecha Inicio Real:',
            '${emp.realStartDate.day}/${emp.realStartDate.month}/${emp.realStartDate.year}',
            isDark,
          ),
          _buildDetailRow(
            'Fecha Inicio Fiscal:',
            '${emp.fiscalStartDate.day}/${emp.fiscalStartDate.month}/${emp.fiscalStartDate.year}',
            isDark,
          ),
          _buildDetailRow(
            'Sueldo Pactado:',
            'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
            isDark,
            isHighlight: true,
          ),
          _buildDetailRow('Tipo de Contrato:', emp.contractType, isDark),
          _buildDetailRow('Observaciones:', emp.observations, isDark),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(RrhhEmployee emp, bool isDark) {
    final docsCount = _isEditingDocs
        ? _currentEditingDocsCount
        : emp.attachedDocumentsCount;
    final isComplete = docsCount == 6;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isComplete
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isComplete
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isComplete ? Icons.verified : Icons.attachment,
                  color: isComplete
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expediente Físico: $docsCount de 6 documentos presentados.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEditingDocs
                            ? 'Marcá o desmarcá los documentos físicos recepcionados en recepción:'
                            : (isComplete
                                  ? 'Documentación completa según normativa laboral boliviana.'
                                  : 'Pendiente de entrega de documentos por parte del trabajador.'),
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_isEditingDocs)
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _initDocState();
                        _isEditingDocs = true;
                      });
                    },
                    icon: const Icon(Icons.edit_document, size: 15),
                    label: const Text('Editar Documentos'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (!_isEditingDocs) ...[
            _buildDocCheckItem(
              'Fotocopia de C.I. vigente',
              emp.hasCiCopy,
              isDark,
            ),
            _buildDocCheckItem(
              'Fotocopia de Factura Luz o Agua',
              emp.hasUtilityBill,
              isDark,
            ),
            _buildDocCheckItem(
              'Croquis de Domicilio firmado',
              emp.hasHomeSketch,
              isDark,
            ),
            _buildDocCheckItem(
              'Certificado de Antecedentes FELCC',
              emp.hasFelccRecord,
              isDark,
            ),
            _buildDocCheckItem(
              'Fotografía 3x4 fondo rojo',
              emp.hasPhoto3x4,
              isDark,
            ),
            _buildDocCheckItem(
              'Seguro Universal de Salud (SUS)',
              emp.hasSusInsurance,
              isDark,
            ),
          ] else ...[
            _buildInteractiveDocItem(
              title: 'Fotocopia de C.I. vigente',
              subtitle: 'Cédula de identidad legible y vigente',
              value: _hasCiCopy,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasCiCopy = val),
            ),
            _buildInteractiveDocItem(
              title: 'Fotocopia de Factura Luz o Agua',
              subtitle: 'Comprobante de domicilio reciente (últimos 3 meses)',
              value: _hasUtilityBill,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasUtilityBill = val),
            ),
            _buildInteractiveDocItem(
              title: 'Croquis de Domicilio firmado',
              subtitle:
                  'Ubicación clara del domicilio con firma del trabajador',
              value: _hasHomeSketch,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasHomeSketch = val),
            ),
            _buildInteractiveDocItem(
              title: 'Certificado de Antecedentes FELCC',
              subtitle:
                  'Certificación policial oficial para operaciones seguras',
              value: _hasFelccRecord,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasFelccRecord = val),
            ),
            _buildInteractiveDocItem(
              title: 'Fotografía 3x4 fondo rojo',
              subtitle: 'Para credencial física y archivo del expediente',
              value: _hasPhoto3x4,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasPhoto3x4 = val),
            ),
            _buildInteractiveDocItem(
              title: 'Seguro Universal de Salud (SUS)',
              subtitle: 'Constancia de adscripción al seguro público de salud',
              value: _hasSusInsurance,
              isDark: isDark,
              onChanged: (val) => setState(() => _hasSusInsurance = val),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _initDocState();
                      _isEditingDocs = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _saveDocuments,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Guardar Documentación'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCredentialsTab(RrhhEmployee emp, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credenciales de Acceso a la APK de Asistencia',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Generadas para el marcaje móvil y control de turnos del colaborador:',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          RrhhCopyableField(
            label: 'Correo Electrónico Corporativo / Usuario:',
            value: emp.effectiveCorporateEmail,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          RrhhCopyableField(
            label: 'Contraseña Temporal Inicial:',
            value: emp.effectiveTemporaryPassword,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.copy_all, size: 16),
            label: const Text('Copiar Datos Completos para Envío'),
            onPressed: () {
              final text =
                  '*ELITE MULTISERVICIOS - CREDENCIALES APK ASISTENCIA*\n'
                  'Colaborador: ${emp.fullName} (${emp.code})\n'
                  'Sede: ${emp.workplace}\n'
                  '--------------------------------------\n'
                  'Usuario: ${emp.effectiveCorporateEmail}\n'
                  'Contraseña Temporal: ${emp.effectiveTemporaryPassword}\n'
                  '--------------------------------------\n'
                  'Ingresa a la app móvil de asistencia con estos accesos.';
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Credenciales copiadas al portapapeles.'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(RrhhEmployee emp, bool isDark) {
    if (emp.timeline.isEmpty) {
      return const Center(child: Text('Sin eventos históricos registrados'));
    }

    return ListView.builder(
      itemCount: emp.timeline.length,
      itemBuilder: (ctx, index) {
        final ev = emp.timeline[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.circle,
                  size: 8,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ev.title,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${ev.date.day}/${ev.date.month}/${ev.date.year}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ev.description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Registrado por: ${ev.registeredBy}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    bool isDark, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isHighlight
                    ? const Color(0xFF10B981)
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCheckItem(String title, bool isChecked, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.cancel,
            color: isChecked
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveDocItem({
    required String title,
    required String subtitle,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withValues(alpha: 0.5)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value
              ? const Color(0xFF10B981).withValues(alpha: 0.35)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: (val) => onChanged(val ?? false),
        activeColor: const Color(0xFF10B981),
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        secondary: Icon(
          value ? Icons.check_circle : Icons.radio_button_unchecked,
          color: value ? const Color(0xFF10B981) : Colors.grey,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }

  void _saveDocuments() {
    final updatedEmp = _emp.copyWith(
      hasCiCopy: _hasCiCopy,
      hasUtilityBill: _hasUtilityBill,
      hasHomeSketch: _hasHomeSketch,
      hasFelccRecord: _hasFelccRecord,
      hasPhoto3x4: _hasPhoto3x4,
      hasSusInsurance: _hasSusInsurance,
    );

    final newCount = updatedEmp.attachedDocumentsCount;
    final newTimeline = List<RrhhTimelineEvent>.from(updatedEmp.timeline);
    newTimeline.insert(
      0,
      RrhhTimelineEvent(
        id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        title: 'Documentación de Expediente Actualizada',
        description:
            'Se recepcionó y validó la entrega de documentos ($newCount de 6 presentados).',
        category: 'DOCUMENTACION',
        registeredBy: 'Lic. Laura Mendoza (RRHH)',
      ),
    );

    final finalEmp = updatedEmp.copyWith(timeline: newTimeline);
    RrhhStateService().updateEmployee(finalEmp);

    setState(() {
      _emp = finalEmp;
      _isEditingDocs = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Documentos de ${_emp.fullName} actualizados ($newCount/6).',
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
