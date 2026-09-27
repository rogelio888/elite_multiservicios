import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    show RrhhEmployeeBonus, RrhhEmployeeDeduction;

export 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    show RrhhEmployeeBonus, RrhhEmployeeDeduction, RrhhEmployeeContractData;

/// Evento o hito en la línea de tiempo del colaborador
class RrhhTimelineEvent {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String
  category; // 'CONTRATACION', 'ASIGNACION', 'HORARIO', 'PERMISO', 'INCIDENCIA', 'DESVINCULACION'
  final String registeredBy;
  final DateTime createdAt;

  const RrhhTimelineEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.category,
    required this.registeredBy,
    required this.createdAt,
  });

  factory RrhhTimelineEvent.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final parsedDate = json['date'] != null
        ? DateTime.tryParse(json['date'] as String) ?? now
        : now;
    return RrhhTimelineEvent(
      id: json['id'] as String? ?? '',
      date: parsedDate,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'CONTRATACION',
      registeredBy: json['registeredBy'] as String? ?? 'RRHH',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? parsedDate
          : parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'category': category,
      'registeredBy': registeredBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Elemento o ítem del checklist documental del empleado
class RrhhEmployeeDocumentItem {
  final String code;
  final String name;
  final String status; // 'pendiente' | 'recibido' | 'validado' | 'rechazado'
  final DateTime? receivedAt;
  final String? notes;
  final String? scannedFileUrl;

  const RrhhEmployeeDocumentItem({
    required this.code,
    required this.name,
    this.status = 'pendiente',
    this.receivedAt,
    this.notes,
    this.scannedFileUrl,
  });

  static const List<MapEntry<String, String>> standardDocuments = [
    MapEntry('CI', 'Fotocopia CI'),
    MapEntry('FELCC', 'Certificado FELCC'),
    MapEntry('AVISO', 'Aviso luz/agua'),
    MapEntry('CROQUIS', 'Croquis domiciliario'),
    MapEntry('FOTO', 'Foto 3x4 fondo rojo'),
    MapEntry('SUS', 'Constancia SUS'),
    MapEntry('TITULO', 'Título profesional'),
    MapEntry('LICENCIA', 'Licencia de conducir'),
  ];

  factory RrhhEmployeeDocumentItem.fromJson(Map<String, dynamic> json) {
    return RrhhEmployeeDocumentItem(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'pendiente',
      receivedAt: json['receivedAt'] != null
          ? DateTime.tryParse(json['receivedAt'] as String)
          : null,
      notes: json['notes'] as String?,
      scannedFileUrl: json['scannedFileUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'status': status,
      if (receivedAt != null) 'receivedAt': receivedAt!.toIso8601String(),
      if (notes != null) 'notes': notes,
      if (scannedFileUrl != null) 'scannedFileUrl': scannedFileUrl,
    };
  }
}

/// Modelo central de Colaborador / Empleado de Elite Multiservicios
class RrhhEmployee {
  final String id;
  final String code; // Ej: EMP-001
  final String fullName;
  final DateTime? birthDate;
  final String birthPlace;
  final String identityCard;
  final String phone;
  final String address;
  final String occupation;
  final String personalReference;
  final String referencePhone;

  // Clasificación laboral
  final String employeeType; // 'OFICINA' o 'CAMPO'
  final String area; // Área o departamento (ej. Operaciones, Marketing, Ventas)
  final String position; // Cargo (ej. Encargada de Marketing, Jardinero)
  final String specialty; // Especialidad (Jardinería, Limpieza, Seguridad, etc.)
  final String workplace; // Sede asignada o nombre de cliente/sede
  final String supervisor; // Jefe directo o supervisor asignado

  // Fechas y Contrato
  final DateTime realStartDate;
  final DateTime fiscalStartDate;
  final double agreedSalary;
  final String contractType; // 'Indefinido', 'Plazo Fijo', 'Servicios'
  final DateTime? contractEndDate;
  final String observations;
  final String status; // 'ACTIVO', 'INACTIVO'

  // Arquitectura Funcional: Integración Operaciones y Contabilidad
  final List<String> skills; // Habilidades / Capacidades (Operaciones Pág 4.2)
  final String
  availabilityStatus; // 'DISPONIBLE', 'ASIGNADO', 'DE_VACACIONES', 'CON_PERMISO', 'SUSPENDIDO'
  final String
  paymentModality; // 'MENSUAL', 'JORNAL', 'POR_HORAS', 'POR_PROYECTO' (Contabilidad Pág 6.1)
  final String
  workScheduleType; // 'TIEMPO_COMPLETO_48H', 'MEDIO_TIEMPO', 'ROTATIVO_24_48', 'HORARIO_OFICINA'

  // Documentos Físicos del Expediente
  final bool hasCiCopy;
  final bool hasUtilityBill;
  final bool hasHomeSketch;
  final bool hasFelccRecord;
  final bool hasPhoto3x4;
  final bool hasSusInsurance;

  // Credenciales Institucionales para APK de Asistencia
  final String? corporateEmail;
  final String? temporaryPassword;

  // Datos de Desvinculación (si está INACTIVO / BAJA)
  final DateTime? exitDate;
  final String? exitReason;
  final String? exitObservations;
  final String? exitRegisteredBy;
  final DateTime? terminationDate;
  final String? terminationType;
  final int? terminationRecordId;

  // Línea de tiempo / Historial laboral conservado
  final List<RrhhTimelineEvent> timeline;

  // ───────────────────────────────────────────────────────────────────────────
  // NUEVOS CAMPOS FASE B: EXPEDIENTE DE CONTRATACIÓN (NULLABLE / RETROCOMPATIBLES)
  // ───────────────────────────────────────────────────────────────────────────

  // Datos bancarios
  final String? bankName;
  final String? accountType; // 'Ahorro' | 'Corriente'
  final String? accountNumber;

  // Seguridad social
  final String? afpName;
  final String? afpNumber;
  final String? healthInsurance;

  // Datos personales complementarios
  final String? fullAddress;
  final String? maritalStatus; // 'Soltero' | 'Casado' | 'Divorciado' | 'Viudo' | 'Unión Libre'
  final int? childrenCount;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;

  // Datos contractuales complementarios
  final String? workdayType; // 'Completa' | 'Parcial' | 'Por horas'
  final DateTime? contractStartDate;
  final String? contractSignedPdfUrl;

  // Bonificaciones y descuentos
  final List<RrhhEmployeeBonus>? bonuses;
  final List<RrhhEmployeeDeduction>? deductions;

  // Asignación organizacional
  final String? shiftId;
  final String? baseLocation;
  final String? supervisorEmployeeId;

  // Documentos (Checklist mapeado de código -> estado)
  final Map<String, String>? documentChecklist;

  const RrhhEmployee({
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
    required this.employeeType,
    required this.area,
    required this.position,
    required this.specialty,
    required this.workplace,
    required this.supervisor,
    required this.realStartDate,
    required this.fiscalStartDate,
    required this.agreedSalary,
    required this.contractType,
    this.contractEndDate,
    required this.observations,
    required this.status,
    this.skills = const [],
    this.availabilityStatus = 'DISPONIBLE',
    this.paymentModality = 'MENSUAL',
    this.workScheduleType = 'TIEMPO_COMPLETO_48H',
    this.hasCiCopy = true,
    this.hasUtilityBill = true,
    this.hasHomeSketch = true,
    this.hasFelccRecord = true,
    this.hasPhoto3x4 = true,
    this.hasSusInsurance = true,
    this.corporateEmail,
    this.temporaryPassword,
    this.exitDate,
    this.exitReason,
    this.exitObservations,
    this.exitRegisteredBy,
    this.terminationDate,
    this.terminationType,
    this.terminationRecordId,
    this.timeline = const [],
    // Nuevos campos opcionales Fase B
    this.bankName,
    this.accountType,
    this.accountNumber,
    this.afpName,
    this.afpNumber,
    this.healthInsurance,
    this.fullAddress,
    this.maritalStatus,
    this.childrenCount,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.workdayType,
    this.contractStartDate,
    this.contractSignedPdfUrl,
    this.bonuses,
    this.deductions,
    this.shiftId,
    this.baseLocation,
    this.supervisorEmployeeId,
    this.documentChecklist,
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

  String get effectiveCorporateEmail {
    if (corporateEmail != null && corporateEmail!.trim().isNotEmpty) {
      return corporateEmail!.trim().toLowerCase();
    }
    final clean = fullName
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '');
    final parts = clean
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts[0]}.${parts[1]}@elitemultiservicios.com';
    } else if (parts.isNotEmpty) {
      return '${parts[0]}@elitemultiservicios.com';
    }
    return '${code.toLowerCase().replaceAll('-', '')}@elitemultiservicios.com';
  }

  String get effectiveTemporaryPassword {
    if (temporaryPassword != null && temporaryPassword!.trim().isNotEmpty) {
      return temporaryPassword!.trim();
    }
    final cleanCode = code.toUpperCase().replaceAll(' ', '');
    return 'Elite.$cleanCode.2026!';
  }

  String get type => employeeType;
  double get baseSalary => agreedSalary;
  String? get clientCompanyName => employeeType == 'CAMPO' ? workplace : null;
  String? get workplaceBranch => workplace;

  String get availabilityLabel {
    switch (availabilityStatus) {
      case 'ASIGNADO':
        return 'Asignado en Campo';
      case 'DE_VACACIONES':
        return 'De Vacaciones';
      case 'CON_PERMISO':
        return 'Con Permiso';
      case 'SUSPENDIDO':
        return 'Suspendido';
      case 'DISPONIBLE':
      default:
        return 'Disponible';
    }
  }

  String get paymentModalityLabel {
    switch (paymentModality) {
      case 'JORNAL':
        return 'Jornal / Día';
      case 'POR_HORAS':
        return 'Por Horas';
      case 'POR_PROYECTO':
        return 'Por Proyecto';
      case 'MENSUAL':
      default:
        return 'Sueldo Fijo Mensual';
    }
  }

  String get scheduleTypeLabel {
    switch (workScheduleType) {
      case 'MEDIO_TIEMPO':
        return 'Medio Tiempo (24h)';
      case 'ROTATIVO_24_48':
        return 'Turno 24/48';
      case 'HORARIO_OFICINA':
        return 'Oficina (08:00 - 17:00)';
      case 'TIEMPO_COMPLETO_48H':
      default:
        return 'Tiempo Completo (48h)';
    }
  }

  RrhhEmployee copyWith({
    String? id,
    String? code,
    String? fullName,
    DateTime? birthDate,
    String? birthPlace,
    String? identityCard,
    String? phone,
    String? address,
    String? occupation,
    String? personalReference,
    String? referencePhone,
    String? employeeType,
    String? area,
    String? position,
    String? specialty,
    String? workplace,
    String? supervisor,
    DateTime? realStartDate,
    DateTime? fiscalStartDate,
    double? agreedSalary,
    String? contractType,
    DateTime? contractEndDate,
    String? observations,
    String? status,
    List<String>? skills,
    String? availabilityStatus,
    String? paymentModality,
    String? workScheduleType,
    bool? hasCiCopy,
    bool? hasUtilityBill,
    bool? hasHomeSketch,
    bool? hasFelccRecord,
    bool? hasPhoto3x4,
    bool? hasSusInsurance,
    String? corporateEmail,
    String? temporaryPassword,
    DateTime? exitDate,
    String? exitReason,
    String? exitObservations,
    String? exitRegisteredBy,
    DateTime? terminationDate,
    String? terminationType,
    int? terminationRecordId,
    List<RrhhTimelineEvent>? timeline,
    // Nuevos campos Fase B
    String? bankName,
    String? accountType,
    String? accountNumber,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? workdayType,
    DateTime? contractStartDate,
    String? contractSignedPdfUrl,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
    Map<String, String>? documentChecklist,
  }) {
    return RrhhEmployee(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      personalReference: personalReference ?? this.personalReference,
      referencePhone: referencePhone ?? this.referencePhone,
      employeeType: employeeType ?? this.employeeType,
      area: area ?? this.area,
      position: position ?? this.position,
      specialty: specialty ?? this.specialty,
      workplace: workplace ?? this.workplace,
      supervisor: supervisor ?? this.supervisor,
      realStartDate: realStartDate ?? this.realStartDate,
      fiscalStartDate: fiscalStartDate ?? this.fiscalStartDate,
      agreedSalary: agreedSalary ?? this.agreedSalary,
      contractType: contractType ?? this.contractType,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      skills: skills ?? this.skills,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      paymentModality: paymentModality ?? this.paymentModality,
      workScheduleType: workScheduleType ?? this.workScheduleType,
      hasCiCopy: hasCiCopy ?? this.hasCiCopy,
      hasUtilityBill: hasUtilityBill ?? this.hasUtilityBill,
      hasHomeSketch: hasHomeSketch ?? this.hasHomeSketch,
      hasFelccRecord: hasFelccRecord ?? this.hasFelccRecord,
      hasPhoto3x4: hasPhoto3x4 ?? this.hasPhoto3x4,
      hasSusInsurance: hasSusInsurance ?? this.hasSusInsurance,
      corporateEmail: corporateEmail ?? this.corporateEmail,
      temporaryPassword: temporaryPassword ?? this.temporaryPassword,
      exitDate: exitDate ?? this.exitDate,
      exitReason: exitReason ?? this.exitReason,
      exitObservations: exitObservations ?? this.exitObservations,
      exitRegisteredBy: exitRegisteredBy ?? this.exitRegisteredBy,
      terminationDate: terminationDate ?? this.terminationDate,
      terminationType: terminationType ?? this.terminationType,
      terminationRecordId: terminationRecordId ?? this.terminationRecordId,
      timeline: timeline ?? this.timeline,
      bankName: bankName ?? this.bankName,
      accountType: accountType ?? this.accountType,
      accountNumber: accountNumber ?? this.accountNumber,
      afpName: afpName ?? this.afpName,
      afpNumber: afpNumber ?? this.afpNumber,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      fullAddress: fullAddress ?? this.fullAddress,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      childrenCount: childrenCount ?? this.childrenCount,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
      workdayType: workdayType ?? this.workdayType,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractSignedPdfUrl: contractSignedPdfUrl ?? this.contractSignedPdfUrl,
      bonuses: bonuses ?? this.bonuses,
      deductions: deductions ?? this.deductions,
      shiftId: shiftId ?? this.shiftId,
      baseLocation: baseLocation ?? this.baseLocation,
      supervisorEmployeeId: supervisorEmployeeId ?? this.supervisorEmployeeId,
      documentChecklist: documentChecklist ?? this.documentChecklist,
    );
  }

  factory RrhhEmployee.fromJson(Map<String, dynamic> json) {
    return RrhhEmployee(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'] as String)
          : null,
      birthPlace: json['birthPlace'] as String? ?? '',
      identityCard: json['identityCard'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      personalReference: json['personalReference'] as String? ?? '',
      referencePhone: json['referencePhone'] as String? ?? '',
      employeeType: json['employeeType'] as String? ?? 'OFICINA',
      area: json['area'] as String? ?? '',
      position: json['position'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      workplace: json['workplace'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      realStartDate: json['realStartDate'] != null
          ? DateTime.tryParse(json['realStartDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      fiscalStartDate: json['fiscalStartDate'] != null
          ? DateTime.tryParse(json['fiscalStartDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      agreedSalary: (json['agreedSalary'] as num?)?.toDouble() ?? 0.0,
      contractType: json['contractType'] as String? ?? 'Indefinido',
      contractEndDate: json['contractEndDate'] != null
          ? DateTime.tryParse(json['contractEndDate'] as String)
          : null,
      observations: json['observations'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVO',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availabilityStatus:
          json['availabilityStatus'] as String? ?? 'DISPONIBLE',
      paymentModality: json['paymentModality'] as String? ?? 'MENSUAL',
      workScheduleType:
          json['workScheduleType'] as String? ?? 'TIEMPO_COMPLETO_48H',
      hasCiCopy: json['hasCiCopy'] as bool? ?? true,
      hasUtilityBill: json['hasUtilityBill'] as bool? ?? true,
      hasHomeSketch: json['hasHomeSketch'] as bool? ?? true,
      hasFelccRecord: json['hasFelccRecord'] as bool? ?? true,
      hasPhoto3x4: json['hasPhoto3x4'] as bool? ?? true,
      hasSusInsurance: json['hasSusInsurance'] as bool? ?? true,
      corporateEmail: json['corporateEmail'] as String?,
      temporaryPassword: json['temporaryPassword'] as String?,
      exitDate: json['exitDate'] != null
          ? DateTime.tryParse(json['exitDate'] as String)
          : null,
      exitReason: json['exitReason'] as String?,
      exitObservations: json['exitObservations'] as String?,
      exitRegisteredBy: json['exitRegisteredBy'] as String?,
      terminationDate: json['terminationDate'] != null
          ? DateTime.tryParse(json['terminationDate'] as String)
          : null,
      terminationType: json['terminationType'] as String?,
      terminationRecordId: json['terminationRecordId'] as int?,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => RrhhTimelineEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bankName: json['bankName'] as String?,
      accountType: json['accountType'] as String?,
      accountNumber: json['accountNumber'] as String?,
      afpName: json['afpName'] as String?,
      afpNumber: json['afpNumber'] as String?,
      healthInsurance: json['healthInsurance'] as String?,
      fullAddress: json['fullAddress'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      childrenCount: json['childrenCount'] as int?,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
      emergencyContactRelation: json['emergencyContactRelation'] as String?,
      workdayType: json['workdayType'] as String?,
      contractStartDate: json['contractStartDate'] != null
          ? DateTime.tryParse(json['contractStartDate'] as String)
          : null,
      contractSignedPdfUrl: json['contractSignedPdfUrl'] as String?,
      bonuses: (json['bonuses'] as List<dynamic>?)
          ?.map((e) => RrhhEmployeeBonus.fromJson(e as Map<String, dynamic>))
          .toList(),
      deductions: (json['deductions'] as List<dynamic>?)
          ?.map((e) => RrhhEmployeeDeduction.fromJson(e as Map<String, dynamic>))
          .toList(),
      shiftId: json['shiftId'] as String?,
      baseLocation: json['baseLocation'] as String?,
      supervisorEmployeeId: json['supervisorEmployeeId'] as String?,
      documentChecklist: (json['documentChecklist'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'fullName': fullName,
      if (birthDate != null) 'birthDate': birthDate!.toIso8601String(),
      'birthPlace': birthPlace,
      'identityCard': identityCard,
      'phone': phone,
      'address': address,
      'occupation': occupation,
      'personalReference': personalReference,
      'referencePhone': referencePhone,
      'employeeType': employeeType,
      'area': area,
      'position': position,
      'specialty': specialty,
      'workplace': workplace,
      'supervisor': supervisor,
      'realStartDate': realStartDate.toIso8601String(),
      'fiscalStartDate': fiscalStartDate.toIso8601String(),
      'agreedSalary': agreedSalary,
      'contractType': contractType,
      if (contractEndDate != null)
        'contractEndDate': contractEndDate!.toIso8601String(),
      'observations': observations,
      'status': status,
      'skills': skills,
      'availabilityStatus': availabilityStatus,
      'paymentModality': paymentModality,
      'workScheduleType': workScheduleType,
      'hasCiCopy': hasCiCopy,
      'hasUtilityBill': hasUtilityBill,
      'hasHomeSketch': hasHomeSketch,
      'hasFelccRecord': hasFelccRecord,
      'hasPhoto3x4': hasPhoto3x4,
      'hasSusInsurance': hasSusInsurance,
      if (corporateEmail != null) 'corporateEmail': corporateEmail,
      if (temporaryPassword != null) 'temporaryPassword': temporaryPassword,
      if (exitDate != null) 'exitDate': exitDate!.toIso8601String(),
      if (exitReason != null) 'exitReason': exitReason,
      if (exitObservations != null) 'exitObservations': exitObservations,
      if (exitRegisteredBy != null) 'exitRegisteredBy': exitRegisteredBy,
      if (terminationDate != null)
        'terminationDate': terminationDate!.toIso8601String(),
      if (terminationType != null) 'terminationType': terminationType,
      if (terminationRecordId != null)
        'terminationRecordId': terminationRecordId,
      'timeline': timeline.map((e) => e.toJson()).toList(),
      if (bankName != null) 'bankName': bankName,
      if (accountType != null) 'accountType': accountType,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (afpName != null) 'afpName': afpName,
      if (afpNumber != null) 'afpNumber': afpNumber,
      if (healthInsurance != null) 'healthInsurance': healthInsurance,
      if (fullAddress != null) 'fullAddress': fullAddress,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (childrenCount != null) 'childrenCount': childrenCount,
      if (emergencyContactName != null)
        'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergencyContactPhone': emergencyContactPhone,
      if (emergencyContactRelation != null)
        'emergencyContactRelation': emergencyContactRelation,
      if (workdayType != null) 'workdayType': workdayType,
      if (contractStartDate != null)
        'contractStartDate': contractStartDate!.toIso8601String(),
      if (contractSignedPdfUrl != null)
        'contractSignedPdfUrl': contractSignedPdfUrl,
      if (bonuses != null)
        'bonuses': bonuses!.map((e) => e.toJson()).toList(),
      if (deductions != null)
        'deductions': deductions!.map((e) => e.toJson()).toList(),
      if (shiftId != null) 'shiftId': shiftId,
      if (baseLocation != null) 'baseLocation': baseLocation,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      if (documentChecklist != null) 'documentChecklist': documentChecklist,
    };
  }
}

/// Novedad o ajuste salarial autorizado por RRHH para Contabilidad (Sección 6.1)
class RrhhSalaryAdjustment {
  final String id;
  final String employeeId;
  final String employeeName;
  final String
  type; // 'BONO', 'DESCUENTO_AUTORIZADO', 'ANTICIPO', 'HORAS_EXTRA'
  final double amount;
  final String concept;
  final String authorizedBy;
  final DateTime date;
  final String status; // 'AUTORIZADO', 'LIQUIDADO_CONTABILIDAD'

  const RrhhSalaryAdjustment({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.amount,
    required this.concept,
    required this.authorizedBy,
    required this.date,
    this.status = 'AUTORIZADO',
  });

  factory RrhhSalaryAdjustment.fromJson(Map<String, dynamic> json) {
    return RrhhSalaryAdjustment(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      employeeName: json['employeeName'] as String? ?? '',
      type: json['type'] as String? ?? 'BONO',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      concept: json['concept'] as String? ?? '',
      authorizedBy: json['authorizedBy'] as String? ?? 'RRHH',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'AUTORIZADO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'type': type,
      'amount': amount,
      'concept': concept,
      'authorizedBy': authorizedBy,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
