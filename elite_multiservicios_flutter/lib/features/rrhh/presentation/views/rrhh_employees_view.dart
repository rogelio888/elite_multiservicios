import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/rrhh_audit_service.dart';
import '../../data/rrhh_company_service.dart';

/// Modelo en memoria para Colaborador / Ficha Completa Digital
/// Mapeado 1:1 con la ficha física de "DATOS DEL PERSONAL" de Elite Multiservicios.
class EmployeeItem {
  final String id;
  final String code; // Ej: EMP-001
  final String fullName; // NOMBRE Y APELLIDOS
  final DateTime? birthDate; // FECHA DE NACIMIENTO
  final String birthPlace; // LUGAR DE NACIMIENTO
  final String identityCard; // N° DE CI
  final String phone; // N° DE TELEFONO
  final String address; // DIRECCION
  final String occupation; // OCUPACION/PROFESION
  final String personalReference; // REFERENCIA PERSONAL
  final String referencePhone; // N° TELF. REF.
  final String
  workplace; // LUGAR DE TRABAJO (ej. Kolping Central, Ventura Mall)
  final String employeeType; // 'ADMINISTRATIVO', 'OPERATIVO'
  final String position; // Cargo / Función
  final String department; // Área funcional
  final DateTime fiscalStartDate; // FECHA DE INICIO FISCAL
  final DateTime realStartDate; // FECHA DE INICIO REAL
  final double agreedSalary; // SUELDO PACTADO BS.
  final String
  contractType; // TIPO DE CONTRATO (Indefinido, Plazo Fijo, Servicios)
  final String observations; // OBSERVACIONES
  final String status; // 'ACTIVO', 'SUSPENDIDO', 'BAJA'

  // Documentos adjuntos físicos recibidos
  final bool hasCiCopy; // FOTOCOPIA CI
  final bool hasUtilityBill; // FOT. AVISO LUZ/AGUA
  final bool hasHomeSketch; // CROQUIS DOM.
  final bool hasFelccRecord; // ANTECEDENTES FELCC
  final bool hasPhoto3x4; // FOTO 3X4
  final bool hasSusInsurance; // SEGURO DE SUS

  const EmployeeItem({
    required this.id,
    required this.code,
    required this.fullName,
    this.birthDate,
    required this.birthPlace,
    required this.identityCard,
    required this.phone,
    required this.address,
    required this.occupation,
    required this.personalReference,
    required this.referencePhone,
    required this.workplace,
    required this.employeeType,
    required this.position,
    required this.department,
    required this.fiscalStartDate,
    required this.realStartDate,
    required this.agreedSalary,
    required this.contractType,
    required this.observations,
    required this.status,
    required this.hasCiCopy,
    required this.hasUtilityBill,
    required this.hasHomeSketch,
    required this.hasFelccRecord,
    required this.hasPhoto3x4,
    required this.hasSusInsurance,
  });

  int get attachedDocumentsCount {
    int count = 0;
    if (hasCiCopy) count++;
    if (hasUtilityBill) count++;
    if (hasHomeSketch) count++;
    if (hasFelccRecord) count++;
    if (hasPhoto3x4) count++;
    if (hasSusInsurance) count++;
    return count;
  }
}

/// Vista de Colaboradores y Expediente Digital de Personal
class RrhhEmployeesView extends StatefulWidget {
  const RrhhEmployeesView({super.key});

  @override
  State<RrhhEmployeesView> createState() => _RrhhEmployeesViewState();
}

class _RrhhEmployeesViewState extends State<RrhhEmployeesView> {
  final RrhhCompanyService _companyService = RrhhCompanyService.instance;
  String _searchQuery = '';
  String _typeFilter = 'TODOS'; // 'TODOS', 'ADMINISTRATIVO', 'OPERATIVO'
  String _statusFilter = 'TODOS';
  String _workplaceFilter = 'TODOS';

  @override
  void initState() {
    super.initState();
    _companyService.addListener(_onCompanyUpdated);
  }

  @override
  void dispose() {
    _companyService.removeListener(_onCompanyUpdated);
    super.dispose();
  }

  void _onCompanyUpdated() {
    if (mounted) setState(() {});
  }

  // Lista inicial de demostración con datos reales de la estructura de Elite Multiservicios
  final List<EmployeeItem> _employees = [
    EmployeeItem(
      id: 'emp-1',
      code: 'EMP-001',
      fullName: 'Carlos Mendoza Rios',
      birthDate: DateTime(1992, 4, 18),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '5489214 SCZ',
      phone: '+591 71092834',
      address: 'Barrio Los Sauces, Calle 4 #120',
      occupation: 'Técnico Electromecánico',
      personalReference: 'Mario Mendoza (Padre)',
      referencePhone: '+591 71098877',
      workplace: 'Kolping - Central',
      employeeType: 'OPERATIVO',
      position: 'Técnico de Mantenimiento',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 3, 1),
      fiscalStartDate: DateTime(2023, 3, 15),
      agreedSalary: 4500.0,
      contractType: 'Indefinido',
      observations:
          'Turno mañana. Responsable de mantenimiento preventivo de bombas.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-2',
      code: 'EMP-002',
      fullName: 'Valeria Justiniano Paz',
      birthDate: DateTime(1995, 8, 22),
      birthPlace: 'La Paz',
      identityCard: '6821473 LPZ',
      phone: '+591 76023419',
      address: 'Av. Santos Dumont, 5to Anillo #45',
      occupation: 'Supervisora de Servicios',
      personalReference: 'Carmen Paz (Madre)',
      referencePhone: '+591 76099112',
      workplace: 'Ventura Mall',
      employeeType: 'OPERATIVO',
      position: 'Supervisora de Limpieza',
      department: 'Supervisión',
      realStartDate: DateTime(2023, 7, 1),
      fiscalStartDate: DateTime(2023, 7, 1),
      agreedSalary: 4200.0,
      contractType: 'Indefinido',
      observations: 'A cargo de cuadrilla nocturna de 6 operarios.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: false,
    ),
    EmployeeItem(
      id: 'emp-3',
      code: 'EMP-003',
      fullName: 'Jorge Luis Aguilera',
      birthDate: DateTime(1989, 11, 5),
      birthPlace: 'Cochabamba',
      identityCard: '4912038 CBBA',
      phone: '+591 75089123',
      address: 'Plan 3000, B/ El Triunfo #32',
      occupation: 'Guardia de Seguridad Privada',
      personalReference: 'Sonia Aguilera (Hermana)',
      referencePhone: '+591 75022334',
      workplace: 'Kinesis',
      employeeType: 'OPERATIVO',
      position: 'Guardia de Seguridad',
      department: 'Operaciones',
      realStartDate: DateTime(2024, 1, 10),
      fiscalStartDate: DateTime(2024, 1, 10),
      agreedSalary: 3800.0,
      contractType: 'Plazo Fijo',
      observations: 'En reposo médico temporal por contingencia física.',
      status: 'SUSPENDIDO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: false,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-4',
      code: 'EMP-004',
      fullName: 'Andrea Soliz Arteaga',
      birthDate: DateTime(1996, 2, 14),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '7823901 SCZ',
      phone: '+591 78451200',
      address: 'Equipetrol Norte, Calle 8 #12',
      occupation: 'Licenciada en Administración',
      personalReference: 'Roberto Soliz (Padre)',
      referencePhone: '+591 78499881',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Encargada de Compras y Almacén',
      department: 'Administración',
      realStartDate: DateTime(2023, 11, 20),
      fiscalStartDate: DateTime(2023, 12, 1),
      agreedSalary: 4000.0,
      contractType: 'Indefinido',
      observations:
          'Personal interno de oficina administrativa de Elite Multiservicios.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
  ];

  List<EmployeeItem> get _filteredEmployees {
    return _employees.where((emp) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          emp.fullName.toLowerCase().contains(q) ||
          emp.code.toLowerCase().contains(q) ||
          emp.identityCard.toLowerCase().contains(q) ||
          emp.position.toLowerCase().contains(q) ||
          emp.workplace.toLowerCase().contains(q);

      final matchesType =
          _typeFilter == 'TODOS' || emp.employeeType == _typeFilter;
      final matchesStatus =
          _statusFilter == 'TODOS' || emp.status == _statusFilter;
      final matchesWorkplace =
          _workplaceFilter == 'TODOS' || emp.workplace == _workplaceFilter;

      return matchesSearch && matchesType && matchesStatus && matchesWorkplace;
    }).toList();
  }

  void _showEmployeeDetailsModal(EmployeeItem emp) {
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
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(
                  0xFF2563EB,
                ).withValues(alpha: 0.15),
                child: Text(
                  emp.fullName.isNotEmpty ? emp.fullName.substring(0, 1) : '?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp.fullName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Ficha: ${emp.code} • C.I.: ${emp.identityCard}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(emp.status),
            ],
          ),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('1. DATOS PERSONALES & CONTACTO'),
                  _buildDetailRow(
                    'Fecha de Nacimiento',
                    emp.birthDate != null
                        ? '${emp.birthDate!.day}/${emp.birthDate!.month}/${emp.birthDate!.year}'
                        : 'No registrado',
                  ),
                  _buildDetailRow('Lugar de Nacimiento', emp.birthPlace),
                  _buildDetailRow('Ocupación / Profesión', emp.occupation),
                  _buildDetailRow('Dirección Domiciliaria', emp.address),
                  _buildDetailRow('Teléfono Personal', emp.phone),
                  _buildDetailRow(
                    'Referencia Personal',
                    '${emp.personalReference} (${emp.referencePhone})',
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    '2. CONDICIONES LABORALES Y LUGAR DE TRABAJO',
                  ),
                  _buildDetailRow(
                    'Tipo de Personal',
                    emp.employeeType == 'ADMINISTRATIVO'
                        ? 'Oficina / Administrativo'
                        : 'Campo / Operativo',
                  ),
                  _buildDetailRow('Lugar de Trabajo / Sede', emp.workplace),
                  _buildDetailRow('Cargo Asignado', emp.position),
                  _buildDetailRow(
                    'Sueldo Pactado',
                    'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow('Tipo de Contrato', emp.contractType),
                  _buildDetailRow(
                    'Fecha de Inicio Real',
                    '${emp.realStartDate.day}/${emp.realStartDate.month}/${emp.realStartDate.year}',
                  ),
                  _buildDetailRow(
                    'Fecha de Inicio Fiscal',
                    '${emp.fiscalStartDate.day}/${emp.fiscalStartDate.month}/${emp.fiscalStartDate.year}',
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    '3. DOCUMENTOS ADJUNTOS FÍSICOS (${emp.attachedDocumentsCount}/6)',
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDocBadge('Fotocopia C.I.', emp.hasCiCopy),
                      _buildDocBadge('Aviso Luz/Agua', emp.hasUtilityBill),
                      _buildDocBadge('Croquis Dom.', emp.hasHomeSketch),
                      _buildDocBadge('Antecedentes FELCC', emp.hasFelccRecord),
                      _buildDocBadge('Foto 3x4', emp.hasPhoto3x4),
                      _buildDocBadge('Seguro SUS', emp.hasSusInsurance),
                    ],
                  ),

                  if (emp.observations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionHeader('4. OBSERVACIONES'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        emp.observations,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2563EB),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
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

  Widget _buildDocBadge(String label, bool isAttached) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isAttached
            ? const Color(0xFF10B981).withValues(alpha: 0.12)
            : const Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isAttached
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : const Color(0xFFEF4444).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAttached ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isAttached
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isAttached
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateEmployeeModal() {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(
      text: 'EMP-00${_employees.length + 1}',
    );
    final nameCtrl = TextEditingController();
    final birthPlaceCtrl = TextEditingController(text: 'Santa Cruz');
    final ciCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final occupationCtrl = TextEditingController();
    final refNameCtrl = TextEditingController();
    final refPhoneCtrl = TextEditingController();
    final salaryCtrl = TextEditingController(text: '3500');
    final obsCtrl = TextEditingController();

    String selectedType = 'OPERATIVO';
    String selectedWorkplace = 'Kolping - Central';
    String selectedPosition = 'Personal de Limpieza';
    String selectedDept = 'Operaciones';
    String selectedContract = 'Indefinido';

    DateTime realStartDate = DateTime.now();
    DateTime fiscalStartDate = DateTime.now();
    DateTime? birthDate;

    // Checkboxes de documentos
    bool hasCiCopy = true;
    bool hasUtilityBill = false;
    bool hasHomeSketch = false;
    bool hasFelccRecord = false;
    bool hasPhoto3x4 = false;
    bool hasSusInsurance = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registro de Datos del Personal',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'Mapeado con el formulario físico oficial de RRHH de Elite Multiservicios',
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
                width: 680,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('1. DATOS DEL PERSONAL'),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre y Apellidos Completos *',
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
                                controller: ciCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'N° de C.I. * (ej: 5489214 SCZ)',
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
                                controller: birthPlaceCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Lugar de Nacimiento',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: occupationCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Ocupación / Profesión',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: phoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'N° de Teléfono *',
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
                          controller: addressCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Dirección Domiciliaria Exacta',
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          '2. REFERENCIAS Y CONTACTO DE EMERGENCIA',
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: refNameCtrl,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Referencia Personal (Nombre y Parentesco)',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: refPhoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'N° Telf. Referencia',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          '3. LUGAR DE TRABAJO Y CONDICIÓN LABORAL',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedType,
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de Personal',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'OPERATIVO',
                                    child: Text('Operativo (En Cliente)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ADMINISTRATIVO',
                                    child: Text('Administrativo (Oficina)'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setModalState(() {
                                      selectedType = v;
                                      if (v == 'ADMINISTRATIVO') {
                                        selectedWorkplace =
                                            'Oficina Central Elite';
                                        selectedDept = 'Administración';
                                      } else {
                                        selectedWorkplace = 'Kolping - Central';
                                        selectedDept = 'Operaciones';
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      key: ValueKey(selectedWorkplace),
                                      initialValue: _companyService.companyNames.contains(selectedWorkplace)
                                          ? selectedWorkplace
                                          : (_companyService.companyNames.isNotEmpty
                                              ? _companyService.companyNames.first
                                              : null),
                                      decoration: const InputDecoration(
                                        labelText: 'Lugar de Trabajo / Empresa *',
                                      ),
                                      items: _companyService.companyNames.map((name) {
                                        return DropdownMenuItem(
                                          value: name,
                                          child: Text(name),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          setModalState(() => selectedWorkplace = v);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filledTonal(
                                    icon: const Icon(Icons.domain_add_outlined, size: 20),
                                    tooltip: 'Ingresar Nueva Empresa / Sede',
                                    onPressed: () async {
                                      await _showCompanyManagementModal(
                                        openDirectlyToCreate: true,
                                      );
                                      setModalState(() {
                                        if (_companyService.companyNames.isNotEmpty) {
                                          selectedWorkplace = _companyService.companyNames.first;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: salaryCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Sueldo Pactado Bs. *',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedContract,
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de Contrato',
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
                                    value: 'Prestación de Servicios',
                                    child: Text('Servicios'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setModalState(() => selectedContract = v);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                initialValue: selectedPosition,
                                decoration: const InputDecoration(
                                  labelText: 'Cargo Asignado',
                                ),
                                onChanged: (v) => selectedPosition = v,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.event, size: 16),
                                label: Text(
                                  'Inicio Real: ${realStartDate.day}/${realStartDate.month}/${realStartDate.year}',
                                ),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: realStartDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setModalState(() => realStartDate = picked);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(
                                  Icons.event_available,
                                  size: 16,
                                ),
                                label: Text(
                                  'Inicio Fiscal: ${fiscalStartDate.day}/${fiscalStartDate.month}/${fiscalStartDate.year}',
                                ),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: fiscalStartDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setModalState(
                                      () => fiscalStartDate = picked,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          '4. DOCUMENTOS ADJUNTOS (CHECKLIST DE RECEPCIÓN)',
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                dense: true,
                                title: const Text('FOTOCOPIA C.I.'),
                                value: hasCiCopy,
                                onChanged: (v) =>
                                    setModalState(() => hasCiCopy = v ?? false),
                              ),
                              CheckboxListTile(
                                dense: true,
                                title: const Text('FOT. AVISO LUZ / AGUA'),
                                value: hasUtilityBill,
                                onChanged: (v) => setModalState(
                                  () => hasUtilityBill = v ?? false,
                                ),
                              ),
                              CheckboxListTile(
                                dense: true,
                                title: const Text('CROQUIS DOMICILIARIO'),
                                value: hasHomeSketch,
                                onChanged: (v) => setModalState(
                                  () => hasHomeSketch = v ?? false,
                                ),
                              ),
                              CheckboxListTile(
                                dense: true,
                                title: const Text('ANTECEDENTES FELCC'),
                                value: hasFelccRecord,
                                onChanged: (v) => setModalState(
                                  () => hasFelccRecord = v ?? false,
                                ),
                              ),
                              CheckboxListTile(
                                dense: true,
                                title: const Text('FOTO 3X4'),
                                value: hasPhoto3x4,
                                onChanged: (v) => setModalState(
                                  () => hasPhoto3x4 = v ?? false,
                                ),
                              ),
                              CheckboxListTile(
                                dense: true,
                                title: const Text('SEGURO DE SUS'),
                                value: hasSusInsurance,
                                onChanged: (v) => setModalState(
                                  () => hasSusInsurance = v ?? false,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader('5. OBSERVACIONES'),
                        TextFormField(
                          controller: obsCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText:
                                'Anotaciones adicionales sobre turnos, condiciones especiales o acuerdos...',
                          ),
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
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Guardar Expediente'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _employees.insert(
                          0,
                          EmployeeItem(
                            id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
                            code: codeCtrl.text.trim(),
                            fullName: nameCtrl.text.trim(),
                            birthDate: birthDate,
                            birthPlace: birthPlaceCtrl.text.trim(),
                            identityCard: ciCtrl.text.trim(),
                            phone: phoneCtrl.text.trim(),
                            address: addressCtrl.text.trim(),
                            occupation: occupationCtrl.text.trim(),
                            personalReference: refNameCtrl.text.trim(),
                            referencePhone: refPhoneCtrl.text.trim(),
                            workplace: selectedWorkplace,
                            employeeType: selectedType,
                            position: selectedPosition,
                            department: selectedDept,
                            realStartDate: realStartDate,
                            fiscalStartDate: fiscalStartDate,
                            agreedSalary:
                                double.tryParse(salaryCtrl.text.trim()) ??
                                3500.0,
                            contractType: selectedContract,
                            observations: obsCtrl.text.trim(),
                            status: 'ACTIVO',
                            hasCiCopy: hasCiCopy,
                            hasUtilityBill: hasUtilityBill,
                            hasHomeSketch: hasHomeSketch,
                            hasFelccRecord: hasFelccRecord,
                            hasPhoto3x4: hasPhoto3x4,
                            hasSusInsurance: hasSusInsurance,
                          ),
                        );
                        RrhhAuditService.instance.logMovement(
                          category: 'ALTA_PERSONAL',
                          action: 'Registro de Nuevo Colaborador',
                          employeeCode: codeCtrl.text.trim().toUpperCase(),
                          employeeName: nameCtrl.text.trim(),
                          details:
                              'Asignado a la empresa/sede "$selectedWorkplace" en cargo de $selectedPosition con sueldo pactado Bs. ${salaryCtrl.text.trim()}.',
                          severity: 'INFO',
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Colaborador "${nameCtrl.text.trim()}" registrado en el expediente digital.',
                          ),
                          backgroundColor: const Color(0xFF10B981),
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

  Future<void> _showCompanyManagementModal({
    bool openDirectlyToCreate = false,
    WorkplaceCompanyItem? initialCompanyToEdit,
  }) async {
    final formKey = GlobalKey<FormState>();
    bool isFormView = openDirectlyToCreate || initialCompanyToEdit != null;
    WorkplaceCompanyItem? editingCompany = initialCompanyToEdit;

    final nameCtrl =
        TextEditingController(text: initialCompanyToEdit?.name ?? '');
    final addressCtrl =
        TextEditingController(text: initialCompanyToEdit?.address ?? '');
    final contactNameCtrl =
        TextEditingController(text: initialCompanyToEdit?.contactPerson ?? '');
    final contactPhoneCtrl =
        TextEditingController(text: initialCompanyToEdit?.contactPhone ?? '');
    final notesCtrl =
        TextEditingController(text: initialCompanyToEdit?.notes ?? '');
    String serviceCategory =
        initialCompanyToEdit?.serviceCategory ?? 'Limpieza';

    void resetForm(WorkplaceCompanyItem? comp) {
      editingCompany = comp;
      nameCtrl.text = comp?.name ?? '';
      addressCtrl.text = comp?.address ?? '';
      contactNameCtrl.text = comp?.contactPerson ?? '';
      contactPhoneCtrl.text = comp?.contactPhone ?? '';
      notesCtrl.text = comp?.notes ?? '';
      serviceCategory = comp?.serviceCategory ?? 'Limpieza';
    }

    await showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            final isEditing = editingCompany != null;

            return AlertDialog(
              backgroundColor:
                  isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: isFormView
                  ? Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          tooltip: 'Volver a la lista de empresas',
                          onPressed: () {
                            setDialogState(() {
                              isFormView = false;
                              resetForm(null);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing
                                    ? 'Editar Empresa: ${editingCompany!.name}'
                                    : 'Registrar Nueva Empresa / Sede',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                isEditing
                                    ? 'Modificación de datos con registro en bitácora'
                                    : 'Empresa cliente asignada a servicios de Elite Multiservicios',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.apartment_outlined,
                                color: Color(0xFF6366F1),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Empresas y Sedes Cliente',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${_companyService.allCompanies.length} empresas registradas',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(
                            'Nueva Empresa',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            setDialogState(() {
                              resetForm(null);
                              isFormView = true;
                            });
                          },
                        ),
                      ],
                    ),
              content: SizedBox(
                width: 580,
                child: isFormView
                    ? Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: nameCtrl,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Nombre de la Empresa o Sede Cliente *',
                                  hintText:
                                      'Ej. Banco FIE - Sucursal Norte / Condominio La Riviera',
                                  prefixIcon:
                                      Icon(Icons.business_outlined, size: 18),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Campo requerido'
                                        : null,
                              ),
                              const SizedBox(height: 14),
                              DropdownButtonFormField<String>(
                                key: ValueKey(serviceCategory),
                                initialValue: serviceCategory,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Tipo de Servicio Prestado por Elite *',
                                  prefixIcon:
                                      Icon(Icons.category_outlined, size: 18),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Limpieza',
                                    child: Text(
                                        'Limpieza y Desinfección Operativa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Jardinería',
                                    child: Text(
                                        'Jardinería y Mantenimiento de Áreas Verdes'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sistemas',
                                    child: Text(
                                        'Sistemas, Soporte TI y Telecomunicaciones'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Mantenimiento',
                                    child: Text(
                                        'Mantenimiento Técnico y Electromecánico'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Seguridad',
                                    child: Text(
                                        'Seguridad y Vigilancia Operativa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Multiservicios',
                                    child: Text('Multiservicios Integral'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => serviceCategory = v);
                                  }
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: addressCtrl,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Dirección o Ubicación de la Sede *',
                                  hintText:
                                      'Ej. 4to Anillo y Av. San Martín, Equipetrol',
                                  prefixIcon:
                                      Icon(Icons.place_outlined, size: 18),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Campo requerido'
                                        : null,
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: contactNameCtrl,
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Persona de Contacto / Supervisor',
                                        hintText: 'Ej. Ing. Carlos Suárez',
                                        prefixIcon:
                                            Icon(Icons.person_outline, size: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: contactPhoneCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Teléfono de Contacto',
                                        hintText: 'Ej. +591 76543210',
                                        prefixIcon:
                                            Icon(Icons.phone_outlined, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: notesCtrl,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Observaciones / Requerimientos de Turno',
                                  hintText:
                                      'Ej. Turnos 24/7, cuadrilla de operarios con EPP especializado.',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 380,
                        child: _companyService.allCompanies.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.business_outlined,
                                      size: 48,
                                      color: isDark
                                          ? const Color(0xFF475569)
                                          : const Color(0xFF94A3B8),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No hay empresas cliente registradas aún.',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount:
                                    _companyService.allCompanies.length,
                                separatorBuilder: (sepCtx, index) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (itemCtx, index) {
                                  final comp =
                                      _companyService.allCompanies[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF8FAFC),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6366F1)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.business,
                                            size: 18,
                                            color: Color(0xFF6366F1),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      comp.name,
                                                      style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 7,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFF6366F1)
                                                          .withValues(
                                                              alpha: 0.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Text(
                                                      comp.serviceCategory,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xFF6366F1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.place_outlined,
                                                    size: 13,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      comp.address,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        color: const Color(
                                                            0xFF64748B),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (comp.contactPerson !=
                                                          'No especificado' &&
                                                      comp.contactPerson
                                                          .isNotEmpty) ...[
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                      Icons.person_outline,
                                                      size: 13,
                                                      color:
                                                          Color(0xFF64748B),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      comp.contactPerson,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        color: const Color(
                                                            0xFF64748B),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            side: BorderSide(
                                              color: isDark
                                                  ? const Color(0xFF475569)
                                                  : const Color(0xFFCBD5E1),
                                            ),
                                          ),
                                          icon: const Icon(Icons.edit_outlined,
                                              size: 14),
                                          label: Text(
                                            'Editar',
                                            style:
                                                GoogleFonts.inter(fontSize: 11),
                                          ),
                                          onPressed: () {
                                            setDialogState(() {
                                              resetForm(comp);
                                              isFormView = true;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
              actions: isFormView
                  ? [
                      TextButton(
                        onPressed: () {
                          setDialogState(() {
                            isFormView = false;
                            resetForm(null);
                          });
                        },
                        child: const Text('Atrás'),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(
                          isEditing
                              ? 'Actualizar Empresa'
                              : 'Guardar Empresa',
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final newName = nameCtrl.text.trim();
                            if (isEditing) {
                              final oldName = editingCompany!.name;
                              _companyService.updateCompany(
                                id: editingCompany!.id,
                                name: newName,
                                serviceCategory: serviceCategory,
                                address: addressCtrl.text.trim().isEmpty
                                    ? 'Santa Cruz de la Sierra'
                                    : addressCtrl.text.trim(),
                                contactPerson:
                                    contactNameCtrl.text.trim().isEmpty
                                        ? 'No especificado'
                                        : contactNameCtrl.text.trim(),
                                contactPhone:
                                    contactPhoneCtrl.text.trim().isEmpty
                                        ? 'S/N'
                                        : contactPhoneCtrl.text.trim(),
                                notes: notesCtrl.text.trim(),
                              );

                              // Si cambió el nombre, actualizar referencias de colaboradores
                              if (oldName != newName) {
                                setState(() {
                                  for (int i = 0;
                                      i < _employees.length;
                                      i++) {
                                    if (_employees[i].workplace ==
                                        oldName) {
                                      final cur = _employees[i];
                                      _employees[i] = EmployeeItem(
                                        id: cur.id,
                                        code: cur.code,
                                        fullName: cur.fullName,
                                        birthDate: cur.birthDate,
                                        birthPlace: cur.birthPlace,
                                        identityCard: cur.identityCard,
                                        phone: cur.phone,
                                        address: cur.address,
                                        occupation: cur.occupation,
                                        personalReference:
                                            cur.personalReference,
                                        referencePhone: cur.referencePhone,
                                        workplace: newName,
                                        employeeType: cur.employeeType,
                                        position: cur.position,
                                        department: cur.department,
                                        fiscalStartDate:
                                            cur.fiscalStartDate,
                                        realStartDate: cur.realStartDate,
                                        agreedSalary: cur.agreedSalary,
                                        contractType: cur.contractType,
                                        observations: cur.observations,
                                        status: cur.status,
                                        hasCiCopy: cur.hasCiCopy,
                                        hasUtilityBill:
                                            cur.hasUtilityBill,
                                        hasHomeSketch: cur.hasHomeSketch,
                                        hasFelccRecord:
                                            cur.hasFelccRecord,
                                        hasPhoto3x4: cur.hasPhoto3x4,
                                        hasSusInsurance:
                                            cur.hasSusInsurance,
                                      );
                                    }
                                  }
                                });
                              }

                              setState(() {});
                              setDialogState(() {
                                isFormView = false;
                                resetForm(null);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Datos de la empresa "$newName" actualizados exitosamente.',
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            } else {
                              _companyService.addCompany(
                                name: newName,
                                serviceCategory: serviceCategory,
                                address: addressCtrl.text.trim().isEmpty
                                    ? 'Santa Cruz de la Sierra'
                                    : addressCtrl.text.trim(),
                                contactPerson:
                                    contactNameCtrl.text.trim().isEmpty
                                        ? 'No especificado'
                                        : contactNameCtrl.text.trim(),
                                contactPhone:
                                    contactPhoneCtrl.text.trim().isEmpty
                                        ? 'S/N'
                                        : contactPhoneCtrl.text.trim(),
                                notes: notesCtrl.text.trim(),
                              );

                              setState(() {});
                              setDialogState(() {
                                isFormView = false;
                                resetForm(null);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Empresa "$newName" registrada y habilitada para asignación de personal.',
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ]
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cerrar'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalActivos = _employees.where((e) => e.status == 'ACTIVO').length;
    final totalOperativos = _employees
        .where((e) => e.employeeType == 'OPERATIVO' && e.status == 'ACTIVO')
        .length;
    final totalAdministrativos = _employees
        .where(
          (e) => e.employeeType == 'ADMINISTRATIVO' && e.status == 'ACTIVO',
        )
        .length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y botón de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Directorio de Personal',
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
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_filteredEmployees.length} registros',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestión centralizada del expediente de los colaboradores de Elite Multiservicios.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? const Color(0xFF818CF8)
                            : const Color(0xFF4F46E5),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF4F46E5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.domain_outlined, size: 18),
                      label: Text(
                        'Empresas / Sedes',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () => _showCompanyManagementModal(),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 18),
                      label: Text(
                        'Nuevo Colaborador',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: _showCreateEmployeeModal,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tarjetas KPI Rápidas
            Row(
              children: [
                _buildKpiCard(
                  title: 'Total Activos',
                  value: '$totalActivos',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildKpiCard(
                  title: 'Personal Operativo (Campo)',
                  value: '$totalOperativos',
                  icon: Icons.handshake_outlined,
                  color: const Color(0xFF06B6D4),
                  isDark: isDark,
                ),
                const SizedBox(width: 16),
                _buildKpiCard(
                  title: 'Personal de Oficina (Admin)',
                  value: '$totalAdministrativos',
                  icon: Icons.business_center_outlined,
                  color: const Color(0xFF8B5CF6),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Barra de Filtros y Búsqueda Segmentada
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                'Buscar por nombre, CI, cargo, código o cliente...',
                            prefixIcon: const Icon(Icons.search, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1),
                              ),
                            ),
                          ),
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _typeFilter,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'TODOS',
                            child: Text('Tipo: Todos'),
                          ),
                          DropdownMenuItem(
                            value: 'OPERATIVO',
                            child: Text('Operativo (Campo)'),
                          ),
                          DropdownMenuItem(
                            value: 'ADMINISTRATIVO',
                            child: Text('Administrativo (Oficina)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _typeFilter = val);
                        },
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _companyService.companyNames.contains(_workplaceFilter)
                            ? _workplaceFilter
                            : 'TODOS',
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(
                            value: 'TODOS',
                            child: Text('Lugar: Todos'),
                          ),
                          ..._companyService.companyNames.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _workplaceFilter = val);
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _statusFilter,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'TODOS',
                            child: Text('Estado: Todos'),
                          ),
                          DropdownMenuItem(
                            value: 'ACTIVO',
                            child: Text('Activos'),
                          ),
                          DropdownMenuItem(
                            value: 'SUSPENDIDO',
                            child: Text('Suspendidos'),
                          ),
                          DropdownMenuItem(value: 'BAJA', child: Text('Bajas')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _statusFilter = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tabla de Colaboradores sin RenderFlex Overflows
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
                          'CI / Documento',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Lugar de Trabajo / Tipo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Cargo y Sueldo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Expediente Físico',
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
                          'Contacto / Ref.',
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
                    rows: _filteredEmployees.map((emp) {
                      return DataRow(
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(
                                      0xFF2563EB,
                                    ).withValues(alpha: 0.15),
                                    child: Text(
                                      emp.fullName.isNotEmpty
                                          ? emp.fullName.substring(0, 1)
                                          : '?',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          emp.fullName,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          emp.code,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: isDark
                                                ? const Color(0xFF64748B)
                                                : const Color(0xFF94A3B8),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              emp.identityCard,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emp.workplace,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    emp.employeeType == 'ADMINISTRATIVO'
                                        ? 'Oficina'
                                        : 'Campo / Operativo',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color:
                                          emp.employeeType == 'ADMINISTRATIVO'
                                          ? const Color(0xFF8B5CF6)
                                          : const Color(0xFF06B6D4),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emp.position,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF10B981),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: emp.attachedDocumentsCount == 6
                                    ? const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.12)
                                    : const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    emp.attachedDocumentsCount == 6
                                        ? Icons.verified
                                        : Icons.attachment,
                                    size: 14,
                                    color: emp.attachedDocumentsCount == 6
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${emp.attachedDocumentsCount}/6 docs',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: emp.attachedDocumentsCount == 6
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(_buildStatusChip(emp.status)),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 180),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emp.phone,
                                    style: GoogleFonts.inter(fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Ref: ${emp.referencePhone}',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
                              icon: const Icon(Icons.folder_open, size: 14),
                              label: const Text(
                                'Expediente',
                                style: TextStyle(fontSize: 11),
                              ),
                              onPressed: () => _showEmployeeDetailsModal(emp),
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
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'ACTIVO':
        bg = const Color(0xFF10B981).withValues(alpha: 0.15);
        fg = const Color(0xFF10B981);
        label = 'Activo';
        break;
      case 'SUSPENDIDO':
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        fg = const Color(0xFFF59E0B);
        label = 'Suspendido';
        break;
      case 'BAJA':
        bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        fg = const Color(0xFFEF4444);
        label = 'Baja';
        break;
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
