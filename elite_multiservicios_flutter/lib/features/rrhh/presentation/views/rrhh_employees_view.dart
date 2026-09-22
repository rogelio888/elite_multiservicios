import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/rrhh_audit_service.dart';
import '../../data/rrhh_company_service.dart';
import '../widgets/rrhh_shared_widgets.dart';

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

  // Credenciales institucionales para acceso a APK móvil de Asistencia
  final String? corporateEmail;
  final String? temporaryPassword;

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
    this.corporateEmail,
    this.temporaryPassword,
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

  /// Correo corporativo efectivo para inicio de sesión en APK de Asistencia
  String get effectiveCorporateEmail {
    if (corporateEmail != null && corporateEmail!.trim().isNotEmpty) {
      return corporateEmail!.trim();
    }
    final parts = fullName.trim().toLowerCase().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final cleanFirst = parts[0].replaceAll(RegExp(r'[^a-z0-9]'), '');
      final cleanLast = parts[1].replaceAll(RegExp(r'[^a-z0-9]'), '');
      return '$cleanFirst.$cleanLast@elitemultiservicios.com';
    } else if (parts.isNotEmpty) {
      final clean = parts[0].replaceAll(RegExp(r'[^a-z0-9]'), '');
      return '$clean@elitemultiservicios.com';
    }
    return '${code.toLowerCase()}@elitemultiservicios.com';
  }

  /// Contraseña temporal efectiva para primer acceso a APK de Asistencia
  String get effectiveTemporaryPassword {
    if (temporaryPassword != null && temporaryPassword!.trim().isNotEmpty) {
      return temporaryPassword!.trim();
    }
    final cleanCode = code.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return 'Elite.$cleanCode.2026!';
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
  // Lista inicial de demostración: 6 de oficina (Marketing, Diseño, RRHH, Logística, Contabilidad, Ventas B2B) y 29 de campo (Multiservicios)
  final List<EmployeeItem> _employees = [
    // ------------------ 6 COLABORADORES DE OFICINA (ADMINISTRATIVOS) ------------------
    EmployeeItem(
      id: 'emp-4',
      code: 'EMP-004',
      fullName: 'Andrea Soliz Arteaga',
      birthDate: DateTime(1996, 2, 14),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '7823901 SCZ',
      phone: '+591 78451200',
      address: 'Equipetrol Norte, Calle 8 #12',
      occupation: 'Licenciada en Marketing y Comunicación',
      personalReference: 'Roberto Soliz (Padre)',
      referencePhone: '+591 78499881',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Encargada de Marketing Digital & Branding',
      department: 'Marketing y Comunicación',
      realStartDate: DateTime(2023, 11, 20),
      fiscalStartDate: DateTime(2023, 12, 1),
      agreedSalary: 5200.0,
      contractType: 'Indefinido',
      observations:
          'Estrategia de marca, pauta publicitaria en Meta/Google Ads y posicionamiento de servicios B2B.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-5',
      code: 'EMP-005',
      fullName: 'Mariana Céspedes Banegas',
      birthDate: DateTime(1998, 6, 25),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '8923410 SCZ',
      phone: '+591 72183901',
      address: 'Av. Beni, Calle Los Tajibos #45',
      occupation: 'Diseñadora Gráfica Multimedia',
      personalReference: 'Carmen Banegas (Madre)',
      referencePhone: '+591 72100992',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Diseñadora Gráfica & Creación de Contenido',
      department: 'Marketing y Comunicación',
      realStartDate: DateTime(2024, 2, 1),
      fiscalStartDate: DateTime(2024, 2, 1),
      agreedSalary: 4500.0,
      contractType: 'Indefinido',
      observations:
          'Producción de catálogos digitales de multiservicios, fotografía en campo y piezas publicitarias.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-6',
      code: 'EMP-006',
      fullName: 'Ricardo Montaño Justiniano',
      birthDate: DateTime(1991, 9, 12),
      birthPlace: 'Montero',
      identityCard: '6239102 SCZ',
      phone: '+591 73654129',
      address: 'Barrio Hamacas, Calle 6 #88',
      occupation: 'Ingeniero Industrial / Logístico',
      personalReference: 'Carlos Montaño (Hermano)',
      referencePhone: '+591 73699011',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Coordinador de Operaciones y Logística',
      department: 'Operaciones',
      realStartDate: DateTime(2022, 5, 10),
      fiscalStartDate: DateTime(2022, 6, 1),
      agreedSalary: 6000.0,
      contractType: 'Indefinido',
      observations:
          'Coordinación de cuadrillas operativas, asignación de vehículos, suministros químicos y maquinarias.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-7',
      code: 'EMP-007',
      fullName: 'Paola Andrea Torrico Vaca',
      birthDate: DateTime(1994, 3, 30),
      birthPlace: 'Cochabamba',
      identityCard: '5912834 CBBA',
      phone: '+591 77234901',
      address: 'Av. Busch y 3er Anillo Interno #310',
      occupation: 'Licenciada en Recursos Humanos',
      personalReference: 'Walter Torrico (Padre)',
      referencePhone: '+591 77200119',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Encargada de Recursos Humanos y Bienestar',
      department: 'Recursos Humanos',
      realStartDate: DateTime(2023, 1, 15),
      fiscalStartDate: DateTime(2023, 2, 1),
      agreedSalary: 5500.0,
      contractType: 'Indefinido',
      observations:
          'Control de asistencia biométrica, altas/bajas ministeriales, inducción de personal y planillas.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-8',
      code: 'EMP-008',
      fullName: 'Gonzalo Morales Hurtado',
      birthDate: DateTime(1990, 7, 18),
      birthPlace: 'La Paz',
      identityCard: '4829103 LPZ',
      phone: '+591 78912340',
      address: 'Barrio Sirari, Calle Los Claveles #14',
      occupation: 'Contador Público Autorizado',
      personalReference: 'Elena Hurtado (Madre)',
      referencePhone: '+591 78999812',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Asistente Contable, Facturación y Cobranzas',
      department: 'Administración y Finanzas',
      realStartDate: DateTime(2023, 4, 1),
      fiscalStartDate: DateTime(2023, 4, 1),
      agreedSalary: 4800.0,
      contractType: 'Indefinido',
      observations:
          'Facturación electrónica SIAT para contratos cliente corporativos y conciliaciones bancarias.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-9',
      code: 'EMP-009',
      fullName: 'Fernando Roca Salvatierra',
      birthDate: DateTime(1988, 10, 5),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '5192830 SCZ',
      phone: '+591 76390124',
      address: 'Av. Las Américas, Condominio El Bosque D-2',
      occupation: 'Ingeniero Comercial',
      personalReference: 'Lorena Salvatierra (Hermana)',
      referencePhone: '+591 76311029',
      workplace: 'Oficina Central Elite',
      employeeType: 'ADMINISTRATIVO',
      position: 'Ejecutivo Comercial & Licitaciones B2B',
      department: 'Comercial',
      realStartDate: DateTime(2022, 8, 15),
      fiscalStartDate: DateTime(2022, 9, 1),
      agreedSalary: 5800.0,
      contractType: 'Indefinido',
      observations:
          'Licitaciones corporativas, presupuestos de servicios de limpieza, mantenimiento y jardinería.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),

    // ------------------ 29 COLABORADORES DE CAMPO (OPERATIVOS) ------------------
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
      position: 'Técnico de Mantenimiento Electromecánico',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 3, 1),
      fiscalStartDate: DateTime(2023, 3, 15),
      agreedSalary: 4500.0,
      contractType: 'Indefinido',
      observations:
          'Turno mañana. Responsable de mantenimiento preventivo de bombas y tableros.',
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
      position: 'Supervisora de Limpieza y Sanitización',
      department: 'Supervisión',
      realStartDate: DateTime(2023, 7, 1),
      fiscalStartDate: DateTime(2023, 7, 1),
      agreedSalary: 4200.0,
      contractType: 'Indefinido',
      observations: 'A cargo de cuadrilla de 6 operarios en mall comercial.',
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
      occupation: 'Auxiliar de Limpieza Hospitalaria',
      personalReference: 'Sonia Aguilera (Hermana)',
      referencePhone: '+591 75022334',
      workplace: 'Kinesis',
      employeeType: 'OPERATIVO',
      position: 'Operario de Limpieza y Desinfección Hospitalaria',
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
      id: 'emp-10',
      code: 'EMP-010',
      fullName: 'Roberto Carlos Vaca Flores',
      birthDate: DateTime(1987, 5, 19),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '4782910 SCZ',
      phone: '+591 71329012',
      address: 'Villa 1ro de Mayo, Calle 7 #41',
      occupation: 'Técnico en Climatización y Refrigeración',
      personalReference: 'Carlos Vaca (Hijo)',
      referencePhone: '+591 71300991',
      workplace: 'Segomeit',
      employeeType: 'OPERATIVO',
      position: 'Técnico en Refrigeración y Aire Acondicionado',
      department: 'Mantenimiento',
      realStartDate: DateTime(2022, 10, 1),
      fiscalStartDate: DateTime(2022, 10, 1),
      agreedSalary: 4600.0,
      contractType: 'Indefinido',
      observations:
          'Mantenimiento preventivo y correctivo de chillers y splits industriales.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-11',
      code: 'EMP-011',
      fullName: 'Lucía Méndez Aguilera',
      birthDate: DateTime(1993, 8, 14),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '6291024 SCZ',
      phone: '+591 76045129',
      address: 'Pampa de la Isla, Calle 3 #15',
      occupation: 'Operaria de Limpieza',
      personalReference: 'Juana Aguilera (Madre)',
      referencePhone: '+591 76099881',
      workplace: 'Ventura Mall',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza y Limpieza de Cristales',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 6, 15),
      fiscalStartDate: DateTime(2023, 7, 1),
      agreedSalary: 3500.0,
      contractType: 'Indefinido',
      observations: 'Turno tarde en pasillos comerciales y vitrinas.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-12',
      code: 'EMP-012',
      fullName: 'Mario Alberto Cuéllar',
      birthDate: DateTime(1985, 12, 3),
      birthPlace: 'Trinidad',
      identityCard: '3920192 BEN',
      phone: '+591 75012390',
      address: 'Los Lotes, Calle 10 #102',
      occupation: 'Jardinero Profesional / Paisajista',
      personalReference: 'Ana Cuéllar (Esposa)',
      referencePhone: '+591 75088219',
      workplace: 'Acegal',
      employeeType: 'OPERATIVO',
      position: 'Especialista en Jardinería y Paisajismo',
      department: 'Jardinería',
      realStartDate: DateTime(2021, 9, 1),
      fiscalStartDate: DateTime(2021, 9, 15),
      agreedSalary: 3900.0,
      contractType: 'Indefinido',
      observations:
          'Manejo de podadoras industriales y diseño de jardines corporativos.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-13',
      code: 'EMP-013',
      fullName: 'Patricia Romero Suárez',
      birthDate: DateTime(1997, 4, 28),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '7192038 SCZ',
      phone: '+591 72190341',
      address: 'Barrio El Trompillo, Calle Los Tajibos #145',
      occupation: 'Auxiliar de Servicios Generales',
      personalReference: 'María Elena Suárez (Madre)',
      referencePhone: '+591 72155442',
      workplace: 'Kolping - Central',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza Institucional',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 9, 1),
      fiscalStartDate: DateTime(2023, 9, 15),
      agreedSalary: 3500.0,
      contractType: 'Indefinido',
      observations: 'Mantenimiento de consultorios y auditorio principal.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-14',
      code: 'EMP-014',
      fullName: 'Juan David Paredes',
      birthDate: DateTime(1990, 1, 17),
      birthPlace: 'Sucre',
      identityCard: '4192049 CHQ',
      phone: '+591 76329014',
      address: 'Barrio Lazareto, Calle 2 #67',
      occupation: 'Electricista Industrial',
      personalReference: 'Pedro Paredes (Hermano)',
      referencePhone: '+591 76300122',
      workplace: 'Segomeit',
      employeeType: 'OPERATIVO',
      position: 'Técnico Electricista Industrial',
      department: 'Mantenimiento',
      realStartDate: DateTime(2022, 11, 10),
      fiscalStartDate: DateTime(2022, 12, 1),
      agreedSalary: 4700.0,
      contractType: 'Indefinido',
      observations:
          'Revisión de tableros trifásicos, canalizaciones y luminarias LED.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-15',
      code: 'EMP-015',
      fullName: 'Daniela Ortiz Chavez',
      birthDate: DateTime(1999, 10, 11),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '9012481 SCZ',
      phone: '+591 78045912',
      address: 'Plan 3000, Barrio Cooper #56',
      occupation: 'Operaria de Limpieza y Desinfección',
      personalReference: 'Rosa Chavez (Madre)',
      referencePhone: '+591 78099120',
      workplace: 'Kinesis',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Desinfección y Aseo Profundo',
      department: 'Operaciones',
      realStartDate: DateTime(2024, 3, 1),
      fiscalStartDate: DateTime(2024, 3, 1),
      agreedSalary: 3500.0,
      contractType: 'Plazo Fijo',
      observations:
          'Capacitada en protocolos de bioseguridad y residuos hospitalarios.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-16',
      code: 'EMP-016',
      fullName: 'Miguel Ángel Zurita',
      birthDate: DateTime(1991, 6, 9),
      birthPlace: 'Cochabamba',
      identityCard: '5120394 CBBA',
      phone: '+591 74019283',
      address: 'Villa 1ro de Mayo, Barrio Guapurú #89',
      occupation: 'Especialista en Trabajos en Altura',
      personalReference: 'Javier Zurita (Hermano)',
      referencePhone: '+591 74099812',
      workplace: 'Ventura Mall',
      employeeType: 'OPERATIVO',
      position: 'Operario de Limpieza de Fachadas y Altura',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 5, 20),
      fiscalStartDate: DateTime(2023, 6, 1),
      agreedSalary: 4800.0,
      contractType: 'Indefinido',
      observations:
          'Certificación de trabajo seguro en alturas y uso de andamios suspendidos.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-17',
      code: 'EMP-017',
      fullName: 'Rosa Elena Melgar',
      birthDate: DateTime(1986, 3, 21),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '4102938 SCZ',
      phone: '+591 71629304',
      address: 'Barrio Ramafa, Calle 5 #23',
      occupation: 'Auxiliar de Limpieza y Cocina',
      personalReference: 'Guillermo Melgar (Esposo)',
      referencePhone: '+591 71600129',
      workplace: 'Kolping - Central',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza y Cafetería',
      department: 'Operaciones',
      realStartDate: DateTime(2022, 1, 15),
      fiscalStartDate: DateTime(2022, 2, 1),
      agreedSalary: 3500.0,
      contractType: 'Indefinido',
      observations:
          'Atención de cafetería corporativa y limpieza de salas de reuniones.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-18',
      code: 'EMP-018',
      fullName: 'Cristian Salazar Pinto',
      birthDate: DateTime(1993, 11, 14),
      birthPlace: 'Oruro',
      identityCard: '5719203 ORU',
      phone: '+591 75920391',
      address: 'Barrio Estación Argentina, Calle 8 #34',
      occupation: 'Técnico Sanitario / Plomero',
      personalReference: 'Raúl Salazar (Padre)',
      referencePhone: '+591 75911002',
      workplace: 'Kolping - Central',
      employeeType: 'OPERATIVO',
      position: 'Técnico Plomero e Hidrosanitario',
      department: 'Mantenimiento',
      realStartDate: DateTime(2023, 4, 10),
      fiscalStartDate: DateTime(2023, 4, 15),
      agreedSalary: 4300.0,
      contractType: 'Indefinido',
      observations:
          'Mantenimiento de tuberías, bombas de agua y sistemas de drenaje.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-19',
      code: 'EMP-019',
      fullName: 'Sonia Camacho Arancibia',
      birthDate: DateTime(1995, 7, 7),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '6810293 SCZ',
      phone: '+591 78102934',
      address: 'Pampa de la Isla, Barrio Montecristo #71',
      occupation: 'Operaria de Aseo',
      personalReference: 'Mario Camacho (Hermano)',
      referencePhone: '+591 78199021',
      workplace: 'Ventura Mall',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza y Manejo de Residuos',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 8, 1),
      fiscalStartDate: DateTime(2023, 8, 1),
      agreedSalary: 3500.0,
      contractType: 'Indefinido',
      observations:
          'Recolección diferenciada y desinfección de depósitos de residuos.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-20',
      code: 'EMP-020',
      fullName: 'Diego Armando Gutiérrez',
      birthDate: DateTime(1994, 9, 30),
      birthPlace: 'Yacuiba',
      identityCard: '6019283 TJA',
      phone: '+591 73829104',
      address: 'Los Lotes, Barrio Nuevo Horizonte #99',
      occupation: 'Operario de Maquinaria de Jardinería',
      personalReference: 'Estela Gutiérrez (Madre)',
      referencePhone: '+591 73800192',
      workplace: 'Acegal',
      employeeType: 'OPERATIVO',
      position: 'Operario de Desmalezado y Áreas Verdes',
      department: 'Jardinería',
      realStartDate: DateTime(2023, 10, 5),
      fiscalStartDate: DateTime(2023, 10, 15),
      agreedSalary: 3600.0,
      contractType: 'Indefinido',
      observations:
          'Operador de desmalezadoras a combustión y motosierras de poda.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-21',
      code: 'EMP-021',
      fullName: 'Gabriela Viveros Rojas',
      birthDate: DateTime(1989, 2, 18),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '5091823 SCZ',
      phone: '+591 76910283',
      address: 'Av. Mutualista, 3er Anillo Interno #112',
      occupation: 'Agrónoma Técnica / Supervisora',
      personalReference: 'Daniel Viveros (Padre)',
      referencePhone: '+591 76900281',
      workplace: 'Acegal',
      employeeType: 'OPERATIVO',
      position: 'Supervisora de Cuadrilla de Jardinería',
      department: 'Jardinería',
      realStartDate: DateTime(2022, 3, 1),
      fiscalStartDate: DateTime(2022, 3, 1),
      agreedSalary: 4300.0,
      contractType: 'Indefinido',
      observations:
          'Supervisión de fertilización, riego automático y mantenimiento de césped.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-22',
      code: 'EMP-022',
      fullName: 'Hernán Castro Villagómez',
      birthDate: DateTime(1988, 8, 12),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '4891029 SCZ',
      phone: '+591 71920384',
      address: 'Barrio Petrolero, Calle 3 #45',
      occupation: 'Pintor Profesional de Obras',
      personalReference: 'Teresa Castro (Hermana)',
      referencePhone: '+591 71911928',
      workplace: 'Segomeit',
      employeeType: 'OPERATIVO',
      position: 'Técnico de Mantenimiento y Pintura de Exteriores',
      department: 'Mantenimiento',
      realStartDate: DateTime(2023, 2, 10),
      fiscalStartDate: DateTime(2023, 3, 1),
      agreedSalary: 4100.0,
      contractType: 'Indefinido',
      observations:
          'Pintura electrostática, epóxica para pisos industriales y fachadas.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-23',
      code: 'EMP-023',
      fullName: 'Carmen Julia Tórrez',
      birthDate: DateTime(1996, 12, 1),
      birthPlace: 'Potosí',
      identityCard: '6291038 POT',
      phone: '+591 75102938',
      address: 'Barrio San Carlos, Calle 9 #12',
      occupation: 'Auxiliar de Limpieza Técnica',
      personalReference: 'Felipe Tórrez (Padre)',
      referencePhone: '+591 75188102',
      workplace: 'Kinesis',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza en Áreas Quirúrgicas',
      department: 'Operaciones',
      realStartDate: DateTime(2023, 11, 1),
      fiscalStartDate: DateTime(2023, 11, 15),
      agreedSalary: 3700.0,
      contractType: 'Indefinido',
      observations:
          'Desinfección de quirófanos y salas de recuperación con amonio cuaternario.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-24',
      code: 'EMP-024',
      fullName: 'Pablo Andrés Ribera',
      birthDate: DateTime(1990, 5, 23),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '5192039 SCZ',
      phone: '+591 72019283',
      address: 'Villa 1ro de Mayo, Calle 15 #30',
      occupation: 'Chofer Profesional Categoría C',
      personalReference: 'Ana Ribera (Madre)',
      referencePhone: '+591 72088192',
      workplace: 'Kolping - Central',
      employeeType: 'OPERATIVO',
      position: 'Chofer de Logística y Traslado de Cuadrillas',
      department: 'Operaciones',
      realStartDate: DateTime(2022, 7, 1),
      fiscalStartDate: DateTime(2022, 7, 15),
      agreedSalary: 4200.0,
      contractType: 'Indefinido',
      observations:
          'Conducción de camioneta institucional para traslado de insumos y equipos.',
      status: 'ACTIVO',
      hasCiCopy: true,
      hasUtilityBill: true,
      hasHomeSketch: true,
      hasFelccRecord: true,
      hasPhoto3x4: true,
      hasSusInsurance: true,
    ),
    EmployeeItem(
      id: 'emp-25',
      code: 'EMP-025',
      fullName: 'Roxana Siles Mercado',
      birthDate: DateTime(1998, 1, 9),
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: '8091283 SCZ',
      phone: '+591 78901238',
      address: 'Plan 3000, Barrio San Jorge #44',
      occupation: 'Operaria de Aseo',
      personalReference: 'Silvia Mercado (Madre)',
      referencePhone: '+591 78900192',
      workplace: 'Ventura Mall',
      employeeType: 'OPERATIVO',
      position: 'Operaria de Limpieza en Áreas Comunes',
      department: 'Operaciones',
      realStartDate: DateTime(2024, 1, 5),
      fiscalStartDate: DateTime(2024, 1, 5),
      agreedSalary: 3500.0,
      contractType: 'Plazo Fijo',
      observations: 'Turno rotativo en patio de comidas y sanitarios públicos.',
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

                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    '4. ACCESO A APK DE ASISTENCIA (MARCAJE MÓVIL)',
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.alternate_email,
                              size: 16,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Correo: ${emp.effectiveCorporateEmail}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 14),
                              tooltip: 'Copiar correo',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: emp.effectiveCorporateEmail,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Correo corporativo copiado al portapapeles.',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.key_outlined,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Contraseña: ${emp.effectiveTemporaryPassword}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 14),
                              tooltip: 'Copiar contraseña',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: emp.effectiveTemporaryPassword,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Contraseña temporal copiada al portapapeles.',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (emp.observations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionHeader('5. OBSERVACIONES'),
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
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.badge_outlined, size: 15),
              label: const Text('Credenciales APK'),
              onPressed: () =>
                  _showAttendanceCredentialsModal(context, emp, isDark),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceCredentialsModal(
    BuildContext context,
    EmployeeItem emp,
    bool isDark,
  ) {
    bool obscurePassword = false;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (stCtx, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.smartphone_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credenciales para APK de Asistencia',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Alta oficial en nómina completada con éxito',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
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
                    // Resumen de Colaborador
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
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.15),
                            child: Text(
                              emp.fullName.isNotEmpty
                                  ? emp.fullName.substring(0, 1)
                                  : '?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
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
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${emp.code} • ${emp.position} (${emp.workplace})',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'ACCESOS GENERADOS PARA EL MARCAJE MÓVIL',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tarjeta de credenciales (correo + pass)
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Correo institucional
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2563EB,
                                    ).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.alternate_email,
                                    size: 18,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Correo de Empresa (Usuario)',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      SelectableText(
                                        emp.effectiveCorporateEmail,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  tooltip: 'Copiar correo',
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: emp.effectiveCorporateEmail,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Correo de empresa copiado al portapapeles.',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),

                          // Contraseña temporal
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.key_outlined,
                                    size: 18,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contraseña Temporal de Acceso',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      SelectableText(
                                        obscurePassword
                                            ? '••••••••••••••••'
                                            : emp.effectiveTemporaryPassword,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: const Color(0xFF64748B),
                                  ),
                                  tooltip: obscurePassword
                                      ? 'Mostrar'
                                      : 'Ocultar',
                                  onPressed: () {
                                    setModalState(
                                      () => obscurePassword = !obscurePassword,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  tooltip: 'Copiar contraseña temporal',
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: emp.effectiveTemporaryPassword,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Contraseña temporal copiada al portapapeles.',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Aviso explicativo de la APK de Asistencia
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF0284C7),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Estas credenciales permiten al colaborador iniciar sesión en la APK Móvil de Asistencia de Elite Multiservicios para el registro biométrico y de turnos. Se le solicitará cambiar la contraseña en su primer inicio de sesión.',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                height: 1.4,
                                color: isDark
                                    ? const Color(0xFFBAE6FD)
                                    : const Color(0xFF0369A1),
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
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.copy_all, size: 16),
                  label: const Text('Copiar Todo para Envío'),
                  onPressed: () {
                    final summary =
                        '*ELITE MULTISERVICIOS - ACCESO A APK DE ASISTENCIA*\n'
                        'Colaborador: ${emp.fullName}\n'
                        'Código: ${emp.code}\n'
                        'Sede: ${emp.workplace}\n'
                        '-----------------------------------\n'
                        'Usuario / Correo: ${emp.effectiveCorporateEmail}\n'
                        'Contraseña Temporal: ${emp.effectiveTemporaryPassword}\n'
                        '-----------------------------------\n'
                        'Ingresa con estos accesos a la APK de Asistencia. Deberás actualizar tu contraseña al ingresar.';
                    Clipboard.setData(ClipboardData(text: summary));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Accesos completos copiados en formato mensaje.',
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Entendido / Finalizar'),
                  onPressed: () => Navigator.pop(dialogCtx),
                ),
              ],
            );
          },
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
      text: 'EMP-${(_employees.length + 1).toString().padLeft(3, '0')}',
    );
    final nameCtrl = TextEditingController();
    final birthPlaceCtrl = TextEditingController();
    final ciCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final occupationCtrl = TextEditingController();
    final refNameCtrl = TextEditingController();
    final refPhoneCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final obsCtrl = TextEditingController();

    String selectedType = 'OPERATIVO';
    String selectedWorkplace = 'Kolping - Central';
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
                                  hintText: 'Ej. Santa Cruz',
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
                              child: RrhhAdaptiveSelector<String>(
                                key: ValueKey(selectedWorkplace),
                                label: 'Lugar de Trabajo / Empresa *',
                                hintText: 'Buscar o seleccionar sede...',
                                initialValue:
                                    _companyService.companyNames.contains(
                                      selectedWorkplace,
                                    )
                                    ? selectedWorkplace
                                    : (_companyService.companyNames.isNotEmpty
                                          ? _companyService.companyNames.first
                                          : null),
                                items: _companyService.companyNames,
                                itemLabel: (name) => name,
                                itemIcon: Icons.business,
                                prefixIcon: Icons.location_city,
                                onChanged: (v) {
                                  if (v != null) {
                                    setModalState(() => selectedWorkplace = v);
                                  }
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
                                  hintText: 'Ej. 3500',
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Requerido';
                                  }
                                  final num = double.tryParse(v.trim());
                                  if (num == null || num < 0) {
                                    return 'Monto no válido';
                                  }
                                  return null;
                                },
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
                                controller: positionCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Cargo Asignado *',
                                  hintText: 'Ej. Personal de Limpieza',
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
                                    locale: const Locale('es', 'ES'),
                                    helpText:
                                        'SELECCIONAR FECHA DE INICIO REAL',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Aceptar',
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
                                    locale: const Locale('es', 'ES'),
                                    helpText:
                                        'SELECCIONAR FECHA DE INICIO FISCAL',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Aceptar',
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
                          '4. ACCESO A APK DE ASISTENCIA (CORREO CORPORATIVO & TEMPORAL)',
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2563EB,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.smartphone_rounded,
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
                                      'Alta en Nómina con Generación de Accesos',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Al guardar el expediente, se generará automáticamente el correo institucional (@elitemultiservicios.com) y contraseña temporal para el marcaje en la APK de Asistencia.',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          '5. DOCUMENTOS ADJUNTOS (CHECKLIST DE RECEPCIÓN)',
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
                        _buildSectionHeader('6. OBSERVACIONES'),
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
                      final empCode = codeCtrl.text.trim().toUpperCase();
                      final empName = nameCtrl.text.trim();

                      // Generar correo de empresa y contraseña temporal para la APK
                      final parts = empName.toLowerCase().split(RegExp(r'\s+'));
                      String genEmail;
                      if (parts.length >= 2) {
                        final cleanFirst = parts[0].replaceAll(
                          RegExp(r'[^a-z0-9]'),
                          '',
                        );
                        final cleanLast = parts[1].replaceAll(
                          RegExp(r'[^a-z0-9]'),
                          '',
                        );
                        genEmail =
                            '$cleanFirst.$cleanLast@elitemultiservicios.com';
                      } else if (parts.isNotEmpty) {
                        final clean = parts[0].replaceAll(
                          RegExp(r'[^a-z0-9]'),
                          '',
                        );
                        genEmail = '$clean@elitemultiservicios.com';
                      } else {
                        genEmail =
                            '${empCode.toLowerCase()}@elitemultiservicios.com';
                      }
                      final cleanCode = empCode.replaceAll(
                        RegExp(r'[^A-Z0-9]'),
                        '',
                      );
                      final genPassword = 'Elite.$cleanCode.2026!';

                      final newEmployee = EmployeeItem(
                        id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
                        code: empCode,
                        fullName: empName,
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
                        position: positionCtrl.text.trim().isEmpty
                            ? 'Personal Operativo'
                            : positionCtrl.text.trim(),
                        department: selectedDept,
                        realStartDate: realStartDate,
                        fiscalStartDate: fiscalStartDate,
                        agreedSalary:
                            double.tryParse(salaryCtrl.text.trim()) ?? 0.0,
                        contractType: selectedContract,
                        observations: obsCtrl.text.trim(),
                        status: 'ACTIVO',
                        hasCiCopy: hasCiCopy,
                        hasUtilityBill: hasUtilityBill,
                        hasHomeSketch: hasHomeSketch,
                        hasFelccRecord: hasFelccRecord,
                        hasPhoto3x4: hasPhoto3x4,
                        hasSusInsurance: hasSusInsurance,
                        corporateEmail: genEmail,
                        temporaryPassword: genPassword,
                      );

                      setState(() {
                        _employees.insert(0, newEmployee);
                        RrhhAuditService.instance.logMovement(
                          category: 'ALTA_PERSONAL',
                          action:
                              'Registro Oficial en Nómina & Credenciales APK',
                          employeeCode: empCode,
                          employeeName: empName,
                          details:
                              'Alta oficial en nómina en "$selectedWorkplace". Correo institucional: $genEmail. Habilitado para APK de Asistencia.',
                          severity: 'INFO',
                        );
                      });
                      Navigator.pop(ctx);

                      // Abrir modal con las credenciales corporativas para la APK de Asistencia
                      _showAttendanceCredentialsModal(
                        context,
                        newEmployee,
                        isDark,
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
                        value:
                            _companyService.companyNames.contains(
                              _workplaceFilter,
                            )
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

            // Vista Adaptativa (Card View < 768px / Full-Width Table >= 768px)
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 768;
                if (isMobile) {
                  return _buildMobileCardView(_filteredEmployees, isDark);
                }
                return _buildDesktopTable(
                  context,
                  _filteredEmployees,
                  isDark,
                  constraints.maxWidth,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    List<EmployeeItem> employees,
    bool isDark,
    double maxWidth,
  ) {
    if (employees.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final tableWidth = max(maxWidth, 1180.0);

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
                0: FlexColumnWidth(2.7), // Colaborador (flex)
                1: FixedColumnWidth(120), // CI / Documento (fijo)
                2: FlexColumnWidth(2.5), // Cargo / Función (flex)
                3: FlexColumnWidth(2.3), // Sucursal Asignada (flex)
                4: FixedColumnWidth(135), // Sueldo Pactado (fijo)
                5: FixedColumnWidth(125), // Expediente Físico (fijo)
                6: FixedColumnWidth(100), // Estado (fijo)
                7: FixedColumnWidth(125), // Acciones (fijo)
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
                    _buildHeaderCell('CI / Documento', isDark),
                    _buildHeaderCell('Cargo / Función', isDark),
                    _buildHeaderCell('Sucursal Asignada', isDark),
                    _buildHeaderCell('Sueldo Pactado', isDark),
                    _buildHeaderCell('Expediente', isDark),
                    _buildHeaderCell('Estado', isDark),
                    _buildHeaderCell(
                      'Acciones',
                      isDark,
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
                // Filas de datos
                ...employees.map((emp) {
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
                      // 0: Colaborador
                      _buildBodyCell(
                        Row(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emp.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                    emp.code,
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
                      ),
                      // 1: CI / Documento
                      _buildBodyCell(
                        Text(
                          emp.identityCard,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      // 2: Cargo / Función
                      _buildBodyCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emp.position,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (emp.employeeType == 'ADMINISTRATIVO'
                                            ? const Color(0xFF8B5CF6)
                                            : const Color(0xFF06B6D4))
                                        .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                emp.employeeType == 'ADMINISTRATIVO'
                                    ? 'Oficina'
                                    : 'Campo / Operativo',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: emp.employeeType == 'ADMINISTRATIVO'
                                      ? const Color(0xFF8B5CF6)
                                      : const Color(0xFF06B6D4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 3: Sucursal Asignada
                      _buildBodyCell(
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    (isDark
                                            ? const Color(0xFF3B82F6)
                                            : const Color(0xFF2563EB))
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                emp.employeeType == 'ADMINISTRATIVO'
                                    ? Icons.corporate_fare_outlined
                                    : Icons.storefront_outlined,
                                size: 14,
                                color: isDark
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    emp.workplace,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Sede de trabajo',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 4: Sueldo Pactado
                      _buildBodyCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              emp.contractType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 5: Expediente Físico
                      _buildBodyCell(
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
                            border: Border.all(
                              color: emp.attachedDocumentsCount == 6
                                  ? const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.3)
                                  : const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.3),
                            ),
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
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  '${emp.attachedDocumentsCount}/6 docs',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: emp.attachedDocumentsCount == 6
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 6: Estado
                      _buildBodyCell(_buildStatusChip(emp.status)),
                      // 7: Acciones
                      _buildBodyCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: child,
    );
  }

  Widget _buildMobileCardView(
    List<EmployeeItem> employees,
    bool isDark,
  ) {
    if (employees.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      separatorBuilder: (sepCtx, index) => const SizedBox(height: 12),
      itemBuilder: (itemCtx, index) {
        final emp = employees[index];
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
                    child: Row(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emp.fullName,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${emp.code} • C.I. ${emp.identityCard}',
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
                  ),
                  _buildStatusChip(emp.status),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                height: 1,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cargo / Función',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          emp.position,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sueldo Pactado',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Bs. ${emp.agreedSalary.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sucursal de Trabajo',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          emp.workplace,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Área / Tipo',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          emp.employeeType == 'ADMINISTRATIVO'
                              ? 'Oficina'
                              : 'Campo / Operativo',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: emp.employeeType == 'ADMINISTRATIVO'
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF06B6D4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: emp.attachedDocumentsCount == 6
                          ? const Color(0xFF10B981).withValues(alpha: 0.12)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          emp.attachedDocumentsCount == 6
                              ? Icons.verified
                              : Icons.attachment,
                          size: 13,
                          color: emp.attachedDocumentsCount == 6
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
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
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    icon: const Icon(Icons.folder_open, size: 14),
                    label: const Text(
                      'Expediente',
                      style: TextStyle(fontSize: 11),
                    ),
                    onPressed: () => _showEmployeeDetailsModal(emp),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            'No se encontraron colaboradores',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intente cambiar los criterios de búsqueda o los filtros de tipo y estado.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
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
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
