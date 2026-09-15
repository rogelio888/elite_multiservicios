import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String _searchQuery = '';
  String _typeFilter = 'TODOS'; // 'TODOS', 'ADMINISTRATIVO', 'OPERATIVO'
  String _statusFilter = 'TODOS';
  String _workplaceFilter = 'TODOS';

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
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedWorkplace,
                                decoration: const InputDecoration(
                                  labelText: 'Lugar de Trabajo / Sede',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Kolping - Central',
                                    child: Text('Kolping - Central'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Kolping - 15 de Diciembre',
                                    child: Text('Kolping - 15 Dic'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Kolping - Los Chacos',
                                    child: Text('Kolping - Los Chacos'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Ventura Mall',
                                    child: Text('Ventura Mall'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Kinesis',
                                    child: Text('Kinesis'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Segomeit',
                                    child: Text('Segomeit'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Acegal',
                                    child: Text('Acegal'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Alianza Bravsa',
                                    child: Text('Alianza Bravsa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Oficina Central Elite',
                                    child: Text('Oficina Central Elite'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null)
                                    setModalState(() => selectedWorkplace = v);
                                },
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
                                  if (v != null)
                                    setModalState(() => selectedContract = v);
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
                                  if (picked != null)
                                    setModalState(() => realStartDate = picked);
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
                                  if (picked != null)
                                    setModalState(
                                      () => fiscalStartDate = picked,
                                    );
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
                        value: _workplaceFilter,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'TODOS',
                            child: Text('Lugar: Todos'),
                          ),
                          DropdownMenuItem(
                            value: 'Kolping - Central',
                            child: Text('Kolping Central'),
                          ),
                          DropdownMenuItem(
                            value: 'Ventura Mall',
                            child: Text('Ventura Mall'),
                          ),
                          DropdownMenuItem(
                            value: 'Kinesis',
                            child: Text('Kinesis'),
                          ),
                          DropdownMenuItem(
                            value: 'Oficina Central Elite',
                            child: Text('Oficina Central'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null)
                            setState(() => _workplaceFilter = val);
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
