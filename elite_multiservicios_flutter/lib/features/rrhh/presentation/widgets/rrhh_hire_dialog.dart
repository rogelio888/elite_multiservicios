import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_applicant.dart';
import '../../data/models/rrhh_assignment.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';
import 'rrhh_shared_widgets.dart';

/// Diálogo inteligente para contratar a un postulante o registrar un nuevo colaborador
class RrhhHireDialog extends StatefulWidget {
  final RrhhApplicant? initialApplicant;

  const RrhhHireDialog({super.key, this.initialApplicant});

  @override
  State<RrhhHireDialog> createState() => _RrhhHireDialogState();
}

class _RrhhHireDialogState extends State<RrhhHireDialog> {
  final _rrhhService = RrhhStateService();
  final _formKey = GlobalKey<FormState>();

  // Tipo de Trabajador: OFICINA vs CAMPO
  late String _employeeType;

  // Controladores de datos personales (DATOS DEL PERSONAL)
  late final TextEditingController _fullNameController;
  late final TextEditingController _codeController;
  DateTime? _birthDate;
  late final TextEditingController _birthPlaceController;
  late final TextEditingController _idCardController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _occupationController;
  late final TextEditingController _personalRefController;
  late final TextEditingController _refPhoneController;
  late final TextEditingController _salaryController;
  late final TextEditingController _observationsController;

  // Fechas del Expediente
  late DateTime _realStartDate;
  late DateTime _fiscalStartDate;

  // Documentos Físicos Adjuntos (Checklist Oficial)
  bool _hasCiCopy = true;
  bool _hasUtilityBill = false;
  bool _hasHomeSketch = false;
  bool _hasFelccRecord = false;
  bool _hasPhoto3x4 = false;
  bool _hasSusInsurance = false;

  // Variables específicas de Oficina
  late String _selectedArea;
  late String _selectedPosition;
  late String _selectedSupervisor;
  late String _selectedOfficeSchedule;

  // Variables específicas de Campo
  late String _selectedClient;
  late String _selectedService;
  late String _selectedFieldSupervisor;
  late String _selectedFieldSchedule;

  // Scroll Controller
  late final ScrollController _scrollController;

  // Contrato
  String _contractType = 'Indefinido';

  /// Determina si el cargo/servicio/área actual corresponde al área de seguridad o guardia
  bool get _isSecurityRole {
    final occ = _occupationController.text.toLowerCase();
    if (_employeeType == 'CAMPO') {
      final s = _selectedService.toLowerCase();
      return s.contains('seguridad') ||
          s.contains('guardia') ||
          s.contains('vigilancia') ||
          s.contains('control de acceso') ||
          occ.contains('seguridad') ||
          occ.contains('guardia') ||
          occ.contains('vigilancia');
    } else {
      final pos = _selectedPosition.toLowerCase();
      final area = _selectedArea.toLowerCase();
      return pos.contains('seguridad') ||
          pos.contains('guardia') ||
          pos.contains('vigilancia') ||
          area.contains('seguridad') ||
          occ.contains('seguridad') ||
          occ.contains('guardia') ||
          occ.contains('vigilancia');
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Seleccionar fecha';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF2563EB),
                    onPrimary: Colors.white,
                    surface: Color(0xFF0F172A),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF2563EB),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF0F172A),
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final app = widget.initialApplicant;
    _employeeType = app?.targetType ?? 'CAMPO';

    _fullNameController = TextEditingController(text: app?.fullName ?? '');
    _codeController = TextEditingController(
      text:
          'EMP-${(_rrhhService.totalEmployeesCount + 1).toString().padLeft(3, '0')}',
    );
    _birthDate = app?.birthDate ?? DateTime(1996, 4, 12);
    _birthPlaceController = TextEditingController(text: 'Santa Cruz, Bolivia');
    _idCardController = TextEditingController(text: app?.identityCard ?? '');
    _phoneController = TextEditingController(text: app?.phone ?? '');
    _addressController = TextEditingController(text: app?.address ?? '');
    _occupationController = TextEditingController(
      text:
          app?.targetPosition ??
          (_employeeType == 'OFICINA'
              ? 'Administrativo'
              : 'Operario de Servicios'),
    );
    _occupationController.addListener(() => setState(() {}));
    _personalRefController = TextEditingController(
      text: app?.referencePerson ?? 'Familiar Directo',
    );
    _refPhoneController = TextEditingController(
      text: app?.referencePhone ?? '',
    );
    _salaryController = TextEditingController(
      text: (app?.expectedSalary ?? 3500.0).toStringAsFixed(2),
    );
    _observationsController = TextEditingController(
      text: app != null
          ? 'Contratado tras proceso de selección. Postulación: ${app.code}.'
          : 'Nuevo ingreso en nómina oficial.',
    );

    _realStartDate = DateTime.now();
    _fiscalStartDate = DateTime.now();

    _hasCiCopy = app?.hasIdentityCardCopy ?? true;
    _hasUtilityBill = false;
    _hasHomeSketch = false;
    _hasFelccRecord = false;
    _hasPhoto3x4 = false;
    _hasSusInsurance = false;

    // Valores iniciales para Oficina
    _selectedArea = _rrhhService.areas.isNotEmpty
        ? _rrhhService.areas.first.name
        : 'Marketing & Comunicación';
    final officePositions = _rrhhService.positions
        .where((p) => p.employeeType == 'OFICINA')
        .toList();
    _selectedPosition = officePositions.isNotEmpty
        ? officePositions.first.title
        : 'Encargada de Marketing Digital & Branding';
    _selectedSupervisor = 'Gerencia General';
    final officeSchedules = _rrhhService.schedules
        .where((s) => s.employeeTypeScope != 'CAMPO')
        .toList();
    _selectedOfficeSchedule = officeSchedules.isNotEmpty
        ? '${officeSchedules.first.name} (${officeSchedules.first.formattedTimeRange})'
        : 'Administrativo Central (08:30 - 17:30)';

    // Valores iniciales para Campo
    _selectedClient = _rrhhService.clients.isNotEmpty
        ? _rrhhService.clients.first.name
        : 'Kolping Bolivia';
    _selectedService = _rrhhService.specialties.isNotEmpty
        ? _rrhhService.specialties.first.name
        : 'Limpieza Integral & Hospitalaria';
    _selectedFieldSupervisor = 'Ricardo Montaño Justiniano';
    final fieldSchedules = _rrhhService.schedules
        .where((s) => s.employeeTypeScope != 'OFICINA')
        .toList();
    _selectedFieldSchedule = fieldSchedules.isNotEmpty
        ? '${fieldSchedules.first.name} (${fieldSchedules.first.formattedTimeRange})'
        : 'Operativo Mañana (Campo) (07:00 - 15:00)';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _codeController.dispose();
    _birthPlaceController.dispose();
    _idCardController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    _personalRefController.dispose();
    _refPhoneController.dispose();
    _salaryController.dispose();
    _observationsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onEmployeeTypeChanged(String newType) {
    setState(() {
      _employeeType = newType;
    });
  }

  void _submitHire() {
    if (!_formKey.currentState!.validate()) return;

    // VALIDACIÓN ESTRICTA: Guardia / Área de Seguridad exige antecedentes FELCC
    if (_isSecurityRole && !_hasFelccRecord) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Bloqueo de seguridad: Para personal del área de Seguridad / Guardia, el Certificado de Antecedentes (FELCC) es OBLIGATORIO por normativa legal.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'MARCAR FELCC',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _hasFelccRecord = true;
              });
            },
          ),
        ),
      );
      return;
    }

    final salary = double.tryParse(_salaryController.text.trim()) ?? 3500.0;
    final code = _codeController.text.trim();

    RrhhEmployee newEmployee;
    if (widget.initialApplicant != null) {
      newEmployee = _rrhhService.hireApplicant(
        applicant: widget.initialApplicant!,
        code: code,
        employeeType: _employeeType,
        area: _employeeType == 'OFICINA'
            ? _selectedArea
            : 'Operaciones & Servicios en Campo',
        position: _employeeType == 'OFICINA'
            ? _selectedPosition
            : _selectedService,
        specialty: _employeeType == 'CAMPO'
            ? _selectedService
            : 'Administrativo',
        workplace: _employeeType == 'OFICINA'
            ? 'Oficina Central Elite'
            : _selectedClient,
        supervisor: _employeeType == 'OFICINA'
            ? _selectedSupervisor
            : _selectedFieldSupervisor,
        agreedSalary: salary,
        contractType: _contractType,
        scheduleName: _employeeType == 'OFICINA'
            ? _selectedOfficeSchedule
            : _selectedFieldSchedule,
        observations: _observationsController.text.trim(),
        processedBy: 'Paola Andrea Torrico Vaca',
        birthDate: _birthDate,
        birthPlace: _birthPlaceController.text.trim().isNotEmpty
            ? _birthPlaceController.text.trim()
            : 'Santa Cruz, Bolivia',
        occupation: _occupationController.text.trim().isNotEmpty
            ? _occupationController.text.trim()
            : (_employeeType == 'OFICINA'
                  ? _selectedPosition
                  : _selectedService),
        personalReference: _personalRefController.text.trim().isNotEmpty
            ? _personalRefController.text.trim()
            : 'Familiar Directo',
        referencePhone: _refPhoneController.text.trim().isNotEmpty
            ? _refPhoneController.text.trim()
            : _phoneController.text.trim(),
        realStartDate: _realStartDate,
        fiscalStartDate: _fiscalStartDate,
        hasCiCopy: _hasCiCopy,
        hasUtilityBill: _hasUtilityBill,
        hasHomeSketch: _hasHomeSketch,
        hasFelccRecord: _hasFelccRecord,
        hasPhoto3x4: _hasPhoto3x4,
        hasSusInsurance: _hasSusInsurance,
      );
    } else {
      newEmployee = RrhhEmployee(
        id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
        code: code,
        fullName: _fullNameController.text.trim(),
        birthDate: _birthDate,
        birthPlace: _birthPlaceController.text.trim().isNotEmpty
            ? _birthPlaceController.text.trim()
            : 'Santa Cruz, Bolivia',
        identityCard: _idCardController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        occupation: _occupationController.text.trim().isNotEmpty
            ? _occupationController.text.trim()
            : (_employeeType == 'OFICINA'
                  ? _selectedPosition
                  : _selectedService),
        personalReference: _personalRefController.text.trim().isNotEmpty
            ? _personalRefController.text.trim()
            : 'Familiar Directo',
        referencePhone: _refPhoneController.text.trim().isNotEmpty
            ? _refPhoneController.text.trim()
            : _phoneController.text.trim(),
        employeeType: _employeeType,
        area: _employeeType == 'OFICINA'
            ? _selectedArea
            : 'Operaciones & Servicios en Campo',
        position: _employeeType == 'OFICINA'
            ? _selectedPosition
            : _selectedService,
        specialty: _employeeType == 'CAMPO'
            ? _selectedService
            : 'Administrativo',
        workplace: _employeeType == 'OFICINA'
            ? 'Oficina Central Elite'
            : _selectedClient,
        supervisor: _employeeType == 'OFICINA'
            ? _selectedSupervisor
            : _selectedFieldSupervisor,
        realStartDate: _realStartDate,
        fiscalStartDate: _fiscalStartDate,
        agreedSalary: salary,
        contractType: _contractType,
        observations: _observationsController.text.trim(),
        status: 'ACTIVO',
        hasCiCopy: _hasCiCopy,
        hasUtilityBill: _hasUtilityBill,
        hasHomeSketch: _hasHomeSketch,
        hasFelccRecord: _hasFelccRecord,
        hasPhoto3x4: _hasPhoto3x4,
        hasSusInsurance: _hasSusInsurance,
      );
      _rrhhService.addEmployee(newEmployee);
    }

    Navigator.pop(context);
    _showCredentialsModal(newEmployee);
  }

  void _showCredentialsModal(RrhhEmployee emp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: Color(0xFF10B981),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credenciales de APK de Asistencia',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Generadas automáticamente al registrar en nómina',
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
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark
                        ? const Color(0xFF161F30)
                        : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            emp.fullName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            emp.code,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            emp.employeeType == 'OFICINA'
                                ? Icons.corporate_fare
                                : Icons.storefront,
                            size: 14,
                            color: const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${emp.position} • ${emp.workplace}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCopyableRow(
                  ctx,
                  'Correo Corporativo / Usuario:',
                  emp.effectiveCorporateEmail,
                  isDark,
                ),
                const SizedBox(height: 10),
                _buildCopyableRow(
                  ctx,
                  'Contraseña Temporal:',
                  emp.effectiveTemporaryPassword,
                  isDark,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'El colaborador podrá ingresar a la APK de Asistencia con estas credenciales. Deberá cambiar su contraseña en su primer inicio de sesión.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFFE2E8F0)
                                : const Color(0xFF334155),
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
            OutlinedButton.icon(
              icon: const Icon(Icons.copy_all, size: 15),
              label: const Text('Copiar Todo para Envío'),
              onPressed: () {
                final text =
                    '*ELITE MULTISERVICIOS - CREDENCIALES APK ASISTENCIA*\n'
                    'Colaborador: ${emp.fullName} (${emp.code})\n'
                    'Sede: ${emp.workplace}\n'
                    '--------------------------------------\n'
                    'Usuario: ${emp.effectiveCorporateEmail}\n'
                    'Contraseña Temporal: ${emp.effectiveTemporaryPassword}\n'
                    '--------------------------------------\n'
                    'Ingresa con estos accesos a la app de asistencia de la empresa.';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Accesos copiados al portapapeles.'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Entendido / Finalizar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCopyableRow(
    BuildContext ctx,
    String label,
    String value,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 15),
            tooltip: 'Copiar',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text('$value copiado al portapapeles'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 720,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.initialApplicant != null
                            ? 'Contratar Postulante Seleccionado'
                            : 'Registrar Nuevo Colaborador Oficial',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Formulario inteligente según modalidad (Oficina o Campo)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                height: 1,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      right: 18,
                      top: 4,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selector de Modalidad: OFICINA vs CAMPO
                        Text(
                          '1. SELECCIONA LA MODALIDAD LABORAL:',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTypeRadio(
                                title: 'Personal de Oficina',
                                subtitle:
                                    'Sede Central (Administración, RRHH, Marketing, Ventas)',
                                type: 'OFICINA',
                                icon: Icons.corporate_fare,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeRadio(
                                title: 'Personal de Campo',
                                subtitle:
                                    'Operativo en sedes de clientes (Limpieza, Jardinería, etc.)',
                                type: 'CAMPO',
                                icon: Icons.storefront,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Datos Personales (Hoja Oficial: DATOS DEL PERSONAL)
                        Text(
                          '2. DATOS GENERALES DEL TRABAJADOR (EXPEDIENTE OFICIAL):',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre y Apellidos *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _codeController,
                                decoration: const InputDecoration(
                                  labelText: 'Código Interno *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
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
                              child: _buildDateField(
                                context: context,
                                label: 'Fecha de Nacimiento *',
                                date: _birthDate,
                                isDark: isDark,
                                onTap: () => _pickDate(
                                  context: context,
                                  initialDate:
                                      _birthDate ?? DateTime(1996, 4, 12),
                                  firstDate: DateTime(1940),
                                  lastDate: DateTime.now(),
                                  onPicked: (d) =>
                                      setState(() => _birthDate = d),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _birthPlaceController,
                                decoration: const InputDecoration(
                                  labelText: 'Lugar de Nacimiento *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
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
                              child: TextFormField(
                                controller: _idCardController,
                                decoration: const InputDecoration(
                                  labelText: 'N° de C.I. *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'N° de Teléfono *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
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
                              child: TextFormField(
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Dirección Domiciliaria *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _occupationController,
                                decoration: const InputDecoration(
                                  labelText: 'Ocupación / Profesión *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
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
                              child: TextFormField(
                                controller: _personalRefController,
                                decoration: const InputDecoration(
                                  labelText: 'Referencia Personal *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _refPhoneController,
                                decoration: const InputDecoration(
                                  labelText: 'N° Telf. Referencia *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Campos Dinámicos Inteligentes (Oficina vs Campo)
                        Text(
                          _employeeType == 'OFICINA'
                              ? '3. ASIGNACIÓN INTERNA (OFICINA CENTRAL):'
                              : '3. ASIGNACIÓN OPERATIVA (CLIENTE & SERVICIO EN CAMPO):',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (_employeeType == 'OFICINA') ...[
                          // Campos de Oficina
                          DropdownButtonFormField<String>(
                            initialValue:
                                _rrhhService.areas.any(
                                  (a) => a.name == _selectedArea,
                                )
                                ? _selectedArea
                                : (_rrhhService.areas.isNotEmpty
                                      ? _rrhhService.areas.first.name
                                      : null),
                            decoration: const InputDecoration(
                              labelText: 'Área Organizacional *',
                              border: OutlineInputBorder(),
                            ),
                            items: _rrhhService.areas
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a.name,
                                    child: Text(a.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(
                              () => _selectedArea = v ?? _selectedArea,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue:
                                _rrhhService.positions
                                    .where((p) => p.employeeType == 'OFICINA')
                                    .any((p) => p.title == _selectedPosition)
                                ? _selectedPosition
                                : (_rrhhService.positions.any(
                                        (p) => p.employeeType == 'OFICINA',
                                      )
                                      ? _rrhhService.positions
                                            .firstWhere(
                                              (p) =>
                                                  p.employeeType == 'OFICINA',
                                            )
                                            .title
                                      : null),
                            decoration: const InputDecoration(
                              labelText: 'Cargo Administrativo *',
                              border: OutlineInputBorder(),
                            ),
                            items: _rrhhService.positions
                                .where((p) => p.employeeType == 'OFICINA')
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p.title,
                                    child: Text(p.title),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(
                              () => _selectedPosition = v ?? _selectedPosition,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _selectedSupervisor,
                                  decoration: const InputDecoration(
                                    labelText: 'Responsable / Jefe Inmediato *',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (v) => _selectedSupervisor = v,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: () {
                                    final valid = _rrhhService.schedules
                                        .where(
                                          (s) => s.employeeTypeScope != 'CAMPO',
                                        )
                                        .map(
                                          (s) =>
                                              '${s.name} (${s.formattedTimeRange})',
                                        )
                                        .toList();
                                    return valid.contains(
                                          _selectedOfficeSchedule,
                                        )
                                        ? _selectedOfficeSchedule
                                        : (valid.isNotEmpty
                                              ? valid.first
                                              : null);
                                  }(),
                                  decoration: const InputDecoration(
                                    labelText: 'Horario *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _rrhhService.schedules
                                      .where(
                                        (s) => s.employeeTypeScope != 'CAMPO',
                                      )
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value:
                                              '${s.name} (${s.formattedTimeRange})',
                                          child: Text(s.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(
                                    () => _selectedOfficeSchedule =
                                        v ?? _selectedOfficeSchedule,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // Campos de Campo
                          // Selector adaptativo de Empresa Cliente (5 empresas <= 7 -> Selector normal; >= 8 -> Búsqueda tipo Google)
                          RrhhAdaptiveSelector<RrhhClientCompany>(
                            label: 'Empresa Cliente Asignada *',
                            hintText: 'Buscar o escribir empresa...',
                            initialValue: _rrhhService.clients
                                .cast<RrhhClientCompany?>()
                                .firstWhere(
                                  (c) => c?.name == _selectedClient,
                                  orElse: () => _rrhhService.clients.isNotEmpty
                                      ? _rrhhService.clients.first
                                      : null,
                                ),
                            items: _rrhhService.clients,
                            itemLabel: (c) => c.name,
                            itemSubtitle: (c) =>
                                '${c.services.length} servicio(s) contratado(s)',
                            itemIcon: Icons.business,
                            prefixIcon: Icons.location_city,
                            onChanged: (c) {
                              if (c != null) {
                                setState(() => _selectedClient = c.name);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue:
                                _rrhhService.specialties.any(
                                  (s) => s.name == _selectedService,
                                )
                                ? _selectedService
                                : (_rrhhService.specialties.isNotEmpty
                                      ? _rrhhService.specialties.first.name
                                      : null),
                            decoration: const InputDecoration(
                              labelText: 'Servicio Contratado / Especialidad *',
                              border: OutlineInputBorder(),
                            ),
                            items: _rrhhService.specialties
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.name,
                                    child: Text(s.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(
                              () => _selectedService = v ?? _selectedService,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _selectedFieldSupervisor,
                                  decoration: const InputDecoration(
                                    labelText: 'Supervisor de Cuadrilla *',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (v) =>
                                      _selectedFieldSupervisor = v,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: () {
                                    final valid = _rrhhService.schedules
                                        .where(
                                          (s) =>
                                              s.employeeTypeScope != 'OFICINA',
                                        )
                                        .map(
                                          (s) =>
                                              '${s.name} (${s.formattedTimeRange})',
                                        )
                                        .toList();
                                    return valid.contains(
                                          _selectedFieldSchedule,
                                        )
                                        ? _selectedFieldSchedule
                                        : (valid.isNotEmpty
                                              ? valid.first
                                              : null);
                                  }(),
                                  decoration: const InputDecoration(
                                    labelText: 'Turno / Horario Operativo *',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _rrhhService.schedules
                                      .where(
                                        (s) => s.employeeTypeScope != 'OFICINA',
                                      )
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value:
                                              '${s.name} (${s.formattedTimeRange})',
                                          child: Text(s.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(
                                    () => _selectedFieldSchedule =
                                        v ?? _selectedFieldSchedule,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 20),
                        // Sueldo y Tipo de Contrato (Hoja Oficial)
                        Text(
                          '4. CONDICIONES LABORALES & FECHAS DE INICIO:',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                context: context,
                                label: 'Fecha de Inicio Fiscal *',
                                date: _fiscalStartDate,
                                isDark: isDark,
                                onTap: () => _pickDate(
                                  context: context,
                                  initialDate: _fiscalStartDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                  onPicked: (d) =>
                                      setState(() => _fiscalStartDate = d),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateField(
                                context: context,
                                label: 'Fecha de Inicio Real *',
                                date: _realStartDate,
                                isDark: isDark,
                                onTap: () => _pickDate(
                                  context: context,
                                  initialDate: _realStartDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                  onPicked: (d) =>
                                      setState(() => _realStartDate = d),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _salaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Sueldo Pactado (Bs.) *',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    v == null ||
                                        double.tryParse(v.trim()) == null
                                    ? 'Ingresa un monto válido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue:
                                    const [
                                      'Indefinido',
                                      'Plazo Fijo',
                                      'Servicios',
                                    ].contains(_contractType)
                                    ? _contractType
                                    : 'Indefinido',
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de Contrato *',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Indefinido',
                                    child: Text('Indefinido'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Plazo Fijo',
                                    child: Text('Plazo Fijo'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Servicios',
                                    child: Text('Servicios'),
                                  ),
                                ],
                                onChanged: (v) => setState(
                                  () => _contractType = v ?? _contractType,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        // Expediente y Documentos Adjuntos
                        Row(
                          children: [
                            Text(
                              '5. DOCUMENTOS ADJUNTOS (CHECKLIST DE EXPEDIENTE):',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2563EB,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Hoja Física Oficial',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Alerta especial si es de seguridad
                        if (_isSecurityRole) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFDC2626,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFFDC2626,
                                ).withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFDC2626,
                                    ).withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shield,
                                    color: Color(0xFFDC2626),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Requisito Excluyente para Personal de Seguridad',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFDC2626),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Por disposición reglamentaria y normativa de seguridad, todo postulante a Guardia de Seguridad o Vigilancia debe presentar OBLIGATORIAMENTE el Certificado de Antecedentes FELCC para su contratación.',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: isDark
                                              ? const Color(0xFFFCA5A5)
                                              : const Color(0xFF991B1B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Checkbox Grid / Rows
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'FOTOCOPIA CI',
                                value: _hasCiCopy,
                                onChanged: (v) =>
                                    setState(() => _hasCiCopy = v),
                                isDark: isDark,
                                icon: Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'FOT. AVISO LUZ/AGUA',
                                value: _hasUtilityBill,
                                onChanged: (v) =>
                                    setState(() => _hasUtilityBill = v),
                                isDark: isDark,
                                icon: Icons.receipt_long_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'CROQUIS DOM.',
                                value: _hasHomeSketch,
                                onChanged: (v) =>
                                    setState(() => _hasHomeSketch = v),
                                isDark: isDark,
                                icon: Icons.map_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'ANTECEDENTES FELCC',
                                value: _hasFelccRecord,
                                onChanged: (v) =>
                                    setState(() => _hasFelccRecord = v),
                                isDark: isDark,
                                isRequired: _isSecurityRole,
                                icon: Icons.verified_user_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'FOTO 3X4',
                                value: _hasPhoto3x4,
                                onChanged: (v) =>
                                    setState(() => _hasPhoto3x4 = v),
                                isDark: isDark,
                                icon: Icons.portrait_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDocCheckbox(
                                title: 'SEGURO DE SUS',
                                value: _hasSusInsurance,
                                onChanged: (v) =>
                                    setState(() => _hasSusInsurance = v),
                                isDark: isDark,
                                icon: Icons.medical_services_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Text(
                          '6. OBSERVACIONES:',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _observationsController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Observaciones Iniciales',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Guardar y Entregar Accesos APK'),
                    onPressed: _submitHire,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeRadio({
    required String title,
    required String subtitle,
    required String type,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _employeeType == type;
    final color = type == 'OFICINA'
        ? const Color(0xFF8B5CF6)
        : const Color(0xFF06B6D4);

    return InkWell(
      onTap: () => _onEmployeeTypeChanged(type),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF64748B),
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

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required bool isDark,
    IconData icon = Icons.calendar_today_outlined,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: Icon(icon, size: 18),
        ),
        child: Text(
          _formatDate(date),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: date != null
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildDocCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    bool isRequired = false,
    IconData icon = Icons.description_outlined,
  }) {
    final activeBorderColor = isRequired && !value
        ? const Color(0xFFEF4444)
        : (value
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)));
    final activeBgColor = isRequired && !value
        ? const Color(0xFFEF4444).withValues(alpha: 0.08)
        : (value
              ? const Color(0xFF10B981).withValues(alpha: 0.08)
              : (isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC)));

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: activeBgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: activeBorderColor,
            width: isRequired && !value ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: const Color(0xFF10B981),
            ),
            Icon(
              icon,
              size: 18,
              color: value
                  ? const Color(0xFF10B981)
                  : (isRequired
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  if (isRequired)
                    Text(
                      value
                          ? '✓ Presentado (Obligatorio)'
                          : '⚠️ Faltante Obligatorio',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: value
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
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
}
