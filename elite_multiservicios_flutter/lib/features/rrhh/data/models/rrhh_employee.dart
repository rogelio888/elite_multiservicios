/// Evento o hito en la línea de tiempo del colaborador
class RrhhTimelineEvent {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String
  category; // 'CONTRATACION', 'ASIGNACION', 'HORARIO', 'PERMISO', 'INCIDENCIA', 'DESVINCULACION'
  final String registeredBy;

  const RrhhTimelineEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.category,
    required this.registeredBy,
  });
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
  final String
  specialty; // Especialidad (Jardinería, Limpieza, Seguridad, etc.)
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

  // Datos de Desvinculación (si está INACTIVO)
  final DateTime? exitDate;
  final String? exitReason;
  final String? exitObservations;
  final String? exitRegisteredBy;

  // Línea de tiempo / Historial laboral conservado
  final List<RrhhTimelineEvent> timeline;

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
    this.timeline = const [],
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
    List<RrhhTimelineEvent>? timeline,
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
      timeline: timeline ?? this.timeline,
    );
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
}
