import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';

/// Diálogo completo para editar datos del colaborador y completar su expediente físico
class RrhhEditEmployeeDialog extends StatefulWidget {
  final RrhhEmployee employee;

  const RrhhEditEmployeeDialog({super.key, required this.employee});

  @override
  State<RrhhEditEmployeeDialog> createState() => _RrhhEditEmployeeDialogState();
}

class _RrhhEditEmployeeDialogState extends State<RrhhEditEmployeeDialog> {
  final _stateService = RrhhStateService();

  // Controladores de texto
  late TextEditingController _nameCtrl;
  late TextEditingController _ciCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _refPersonCtrl;
  late TextEditingController _refPhoneCtrl;

  // Laboral
  late TextEditingController _positionCtrl;
  late TextEditingController _workplaceCtrl;
  late TextEditingController _salaryCtrl;
  late String _status;
  late String _employeeType;

  // Documentos Físicos del Expediente
  late bool _hasCiCopy;
  late bool _hasUtilityBill;
  late bool _hasHomeSketch;
  late bool _hasFelccRecord;
  late bool _hasPhoto3x4;
  late bool _hasSusInsurance;

  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    final e = widget.employee;

    _nameCtrl = TextEditingController(text: e.fullName);
    _ciCtrl = TextEditingController(text: e.identityCard);
    _phoneCtrl = TextEditingController(text: e.phone);
    _addressCtrl = TextEditingController(text: e.address);
    _refPersonCtrl = TextEditingController(text: e.personalReference);
    _refPhoneCtrl = TextEditingController(text: e.referencePhone);

    _positionCtrl = TextEditingController(text: e.position);
    _workplaceCtrl = TextEditingController(text: e.workplace);
    _salaryCtrl = TextEditingController(
      text: e.agreedSalary.toStringAsFixed(2),
    );
    _status = e.status;
    _employeeType = e.employeeType;

    _hasCiCopy = e.hasCiCopy;
    _hasUtilityBill = e.hasUtilityBill;
    _hasHomeSketch = e.hasHomeSketch;
    _hasFelccRecord = e.hasFelccRecord;
    _hasPhoto3x4 = e.hasPhoto3x4;
    _hasSusInsurance = e.hasSusInsurance;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ciCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _refPersonCtrl.dispose();
    _refPhoneCtrl.dispose();
    _positionCtrl.dispose();
    _workplaceCtrl.dispose();
    _salaryCtrl.dispose();
    super.dispose();
  }

  int get _docCount {
    int c = 0;
    if (_hasCiCopy) c++;
    if (_hasUtilityBill) c++;
    if (_hasHomeSketch) c++;
    if (_hasFelccRecord) c++;
    if (_hasPhoto3x4) c++;
    if (_hasSusInsurance) c++;
    return c;
  }

  void _saveChanges() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre del colaborador es obligatorio.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final salary =
        double.tryParse(_salaryCtrl.text.trim()) ??
        widget.employee.agreedSalary;

    final updatedEmployee = widget.employee.copyWith(
      fullName: _nameCtrl.text.trim(),
      identityCard: _ciCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      personalReference: _refPersonCtrl.text.trim(),
      referencePhone: _refPhoneCtrl.text.trim(),
      position: _positionCtrl.text.trim(),
      workplace: _workplaceCtrl.text.trim(),
      agreedSalary: salary,
      status: _status,
      employeeType: _employeeType,
      hasCiCopy: _hasCiCopy,
      hasUtilityBill: _hasUtilityBill,
      hasHomeSketch: _hasHomeSketch,
      hasFelccRecord: _hasFelccRecord,
      hasPhoto3x4: _hasPhoto3x4,
      hasSusInsurance: _hasSusInsurance,
    );

    _stateService.updateEmployee(updatedEmployee);

    Navigator.pop(context, updatedEmployee);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ficha y expediente de ${updatedEmployee.fullName} actualizados ($_docCount/6 documentos).',
        ),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  Widget _buildTabButton(
    int index,
    String title,
    IconData icon,
    bool isDark, {
    String? badge,
    Color? badgeColor,
  }) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _currentTab = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? const Color(0xFF2563EB) : Colors.white)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF2563EB))
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF0F172A))
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? const Color(0xFF2563EB)).withValues(
                        alpha: isSelected ? 0.25 : 0.15,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Container(
        width: 700,
        height: 640,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del modal
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
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
                        'Editar Colaborador / Completar Expediente',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '${widget.employee.code} • ${widget.employee.fullName}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
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

            // Segmented Tab Selector (sin slide, sin desborde, instantáneo)
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildTabButton(
                    0,
                    'Datos Personales',
                    Icons.person_outline,
                    isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildTabButton(
                    1,
                    'Información Laboral',
                    Icons.work_outline,
                    isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildTabButton(
                    2,
                    'Documentos Físicos',
                    Icons.folder_open_outlined,
                    isDark,
                    badge: '$_docCount/6',
                    badgeColor: _docCount == 6
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contenido instantáneo sin deslizamiento lento ni desborde
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildPersonalTab(),
                  _buildLaborTab(),
                  _buildDocumentsTab(isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Acciones Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Guardar Cambios'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 18, left: 4, right: 4, bottom: 16),
      child: Column(
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre Completo y Apellidos',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ciCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cédula de Identidad (CI)',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono Móvil',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressCtrl,
            decoration: const InputDecoration(
              labelText: 'Dirección Domiciliaria',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _refPersonCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Referencia Personal (Nombre)',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _refPhoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono de Referencia',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLaborTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 18, left: 4, right: 4, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _positionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cargo / Puesto',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _employeeType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Empleado',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'OFICINA', child: Text('OFICINA')),
                    DropdownMenuItem(value: 'CAMPO', child: Text('CAMPO')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _employeeType = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _workplaceCtrl,
            decoration: const InputDecoration(
              labelText: 'Sede Asignada / Empresa Cliente',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _salaryCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sueldo Pactado (Bs.)',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Estado del Colaborador',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ACTIVO', child: Text('ACTIVO')),
                    DropdownMenuItem(
                      value: 'INACTIVO',
                      child: Text('INACTIVO'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _status = val);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, left: 4, right: 4, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _docCount == 6
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _docCount == 6
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _docCount == 6 ? Icons.verified : Icons.attachment,
                  color: _docCount == 6
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Expediente Físico: $_docCount de 6 documentos presentados.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Marca los documentos físicos que el colaborador ya presentó:',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          _buildCheckItem(
            'Fotocopia de C.I. vigente',
            _hasCiCopy,
            (v) => setState(() => _hasCiCopy = v ?? false),
            isDark,
          ),
          _buildCheckItem(
            'Fotocopia de Factura Luz o Agua',
            _hasUtilityBill,
            (v) => setState(() => _hasUtilityBill = v ?? false),
            isDark,
          ),
          _buildCheckItem(
            'Croquis de Domicilio firmado',
            _hasHomeSketch,
            (v) => setState(() => _hasHomeSketch = v ?? false),
            isDark,
          ),
          _buildCheckItem(
            'Certificado de Antecedentes FELCC',
            _hasFelccRecord,
            (v) => setState(() => _hasFelccRecord = v ?? false),
            isDark,
          ),
          _buildCheckItem(
            'Fotografía 3×4 fondo rojo',
            _hasPhoto3x4,
            (v) => setState(() => _hasPhoto3x4 = v ?? false),
            isDark,
          ),
          _buildCheckItem(
            'Seguro Universal de Salud (SUS)',
            _hasSusInsurance,
            (v) => setState(() => _hasSusInsurance = v ?? false),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: CheckboxListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        value: value,
        activeColor: const Color(0xFF10B981),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: value ? FontWeight.w600 : FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          value ? 'Documento entregado' : 'Documento pendiente',
          style: GoogleFonts.inter(
            fontSize: 10,
            color: value ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
        ),
        secondary: Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          size: 18,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
