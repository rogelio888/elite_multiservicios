import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_applicant.dart';
import '../../data/models/rrhh_employee.dart';
import '../../data/services/rrhh_state_service.dart';

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

  // Controladores de datos personales
  late final TextEditingController _fullNameController;
  late final TextEditingController _idCardController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _salaryController;
  late final TextEditingController _codeController;
  late final TextEditingController _observationsController;

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

  // Contrato
  String _contractType = 'Indefinido';

  @override
  void initState() {
    super.initState();
    final app = widget.initialApplicant;
    _employeeType = app?.targetType ?? 'CAMPO';

    _fullNameController = TextEditingController(text: app?.fullName ?? '');
    _idCardController = TextEditingController(text: app?.identityCard ?? '');
    _phoneController = TextEditingController(text: app?.phone ?? '');
    _addressController = TextEditingController(text: app?.address ?? '');
    _salaryController = TextEditingController(
      text: (app?.expectedSalary ?? 3500.0).toStringAsFixed(2),
    );
    _codeController = TextEditingController(
      text:
          'EMP-${(_rrhhService.totalEmployeesCount + 1).toString().padLeft(3, '0')}',
    );
    _observationsController = TextEditingController(
      text: app != null
          ? 'Contratado tras proceso de selección. Postulación: ${app.code}.'
          : 'Nuevo ingreso en nómina.',
    );

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
    _idCardController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _codeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _onEmployeeTypeChanged(String newType) {
    setState(() {
      _employeeType = newType;
    });
  }

  void _submitHire() {
    if (!_formKey.currentState!.validate()) return;

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
      );
    } else {
      newEmployee = RrhhEmployee(
        id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
        code: code,
        fullName: _fullNameController.text.trim(),
        birthPlace: 'Bolivia',
        identityCard: _idCardController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        occupation: _employeeType == 'OFICINA'
            ? _selectedPosition
            : _selectedService,
        personalReference: 'Familiar Directo',
        referencePhone: _phoneController.text.trim(),
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
        realStartDate: DateTime.now(),
        fiscalStartDate: DateTime.now(),
        agreedSalary: salary,
        contractType: _contractType,
        observations: _observationsController.text.trim(),
        status: 'ACTIVO',
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
          maxWidth: 680,
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
                child: SingleChildScrollView(
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

                      // Datos Personales
                      Text(
                        '2. DATOS GENERALES DEL TRABAJADOR:',
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
                                labelText: 'Nombre Completo *',
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
                            child: TextFormField(
                              controller: _idCardController,
                              decoration: const InputDecoration(
                                labelText: 'C.I. / Documento *',
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
                                labelText: 'Teléfono Celular *',
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
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección Domiciliaria *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Requerido' : null,
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
                                            (p) => p.employeeType == 'OFICINA',
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
                                  return valid.contains(_selectedOfficeSchedule)
                                      ? _selectedOfficeSchedule
                                      : (valid.isNotEmpty ? valid.first : null);
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
                        DropdownButtonFormField<String>(
                          initialValue:
                              _rrhhService.clients.any(
                                (c) => c.name == _selectedClient,
                              )
                              ? _selectedClient
                              : (_rrhhService.clients.isNotEmpty
                                    ? _rrhhService.clients.first.name
                                    : null),
                          decoration: const InputDecoration(
                            labelText: 'Empresa Cliente Asignada *',
                            border: OutlineInputBorder(),
                          ),
                          items: _rrhhService.clients
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.name,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(
                            () => _selectedClient = v ?? _selectedClient,
                          ),
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
                                onChanged: (v) => _selectedFieldSupervisor = v,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: () {
                                  final valid = _rrhhService.schedules
                                      .where(
                                        (s) => s.employeeTypeScope != 'OFICINA',
                                      )
                                      .map(
                                        (s) =>
                                            '${s.name} (${s.formattedTimeRange})',
                                      )
                                      .toList();
                                  return valid.contains(_selectedFieldSchedule)
                                      ? _selectedFieldSchedule
                                      : (valid.isNotEmpty ? valid.first : null);
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
                      // Sueldo y Tipo de Contrato
                      Text(
                        '4. CONDICIONES LABORALES & CONTRATO:',
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
                            child: TextFormField(
                              controller: _salaryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Sueldo Pactado (Bs.) *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || double.tryParse(v.trim()) == null
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
                      const SizedBox(height: 12),
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
}
