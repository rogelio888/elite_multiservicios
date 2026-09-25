import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    show RrhhEmployeeBonus, RrhhEmployeeDeduction;

/// Estado de una sección individual del Expediente de Contratación.
enum RrhhDossierSectionStatus {
  pendiente,
  enProceso,
  completa;

  String get code {
    switch (this) {
      case RrhhDossierSectionStatus.pendiente:
        return 'pendiente';
      case RrhhDossierSectionStatus.enProceso:
        return 'en_proceso';
      case RrhhDossierSectionStatus.completa:
        return 'completa';
    }
  }

  static RrhhDossierSectionStatus fromCode(String code) {
    switch (code) {
      case 'completa':
        return RrhhDossierSectionStatus.completa;
      case 'en_proceso':
        return RrhhDossierSectionStatus.enProceso;
      case 'pendiente':
      default:
        return RrhhDossierSectionStatus.pendiente;
    }
  }
}

/// Documento individual en la Sección 1 del Expediente de Contratación.
class RrhhDossierDocument {
  final String code; // 'CI' | 'FELCC' | 'AVISO' | 'CROQUIS' | 'FOTO' | 'SUS' | 'TITULO' | 'LICENCIA'
  final String name;
  final bool isRequired;
  final String requirementType; // 'obligatorio' | 'condicional' | 'no_aplica'
  final String status; // 'pendiente' | 'recibido' | 'validado' | 'rechazado'
  final DateTime? receivedAt;
  final String? notes;
  final String? scannedFileUrl;

  const RrhhDossierDocument({
    required this.code,
    required this.name,
    required this.isRequired,
    required this.requirementType,
    this.status = 'pendiente',
    this.receivedAt,
    this.notes,
    this.scannedFileUrl,
  });

  bool get isValidated => status == 'validado';
  bool get isReceived => status == 'recibido';
  bool get isRejected => status == 'rechazado';
  bool get isPending => status == 'pendiente';

  RrhhDossierDocument copyWith({
    String? code,
    String? name,
    bool? isRequired,
    String? requirementType,
    String? status,
    DateTime? receivedAt,
    String? notes,
    String? scannedFileUrl,
  }) {
    return RrhhDossierDocument(
      code: code ?? this.code,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      requirementType: requirementType ?? this.requirementType,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
      notes: notes ?? this.notes,
      scannedFileUrl: scannedFileUrl ?? this.scannedFileUrl,
    );
  }

  /// Construye el checklist estándar adaptado a CAMPO vs OFICINA y el cargo.
  static Map<String, RrhhDossierDocument> defaultChecklistFor({
    required String workplaceType,
    required String targetPosition,
  }) {
    final isCampo = workplaceType.toUpperCase() == 'CAMPO';
    final posLower = targetPosition.toLowerCase();
    final isSecurity = posLower.contains('seguridad') ||
        posLower.contains('guardia') ||
        posLower.contains('vigilante') ||
        posLower.contains('custodio');
    final isProfessional = posLower.contains('lic') ||
        posLower.contains('ing') ||
        posLower.contains('contador') ||
        posLower.contains('abogad') ||
        posLower.contains('jefe') ||
        posLower.contains('coordinador') ||
        posLower.contains('analista');
    final requiresDriver = posLower.contains('chofer') ||
        posLower.contains('conductor') ||
        posLower.contains('mensajero') ||
        posLower.contains('móvil') ||
        posLower.contains('movil');

    // 1. CI
    final ci = const RrhhDossierDocument(
      code: 'CI',
      name: 'Fotocopia de Cédula de Identidad',
      isRequired: true,
      requirementType: 'obligatorio',
    );

    // 2. AVISO
    final aviso = const RrhhDossierDocument(
      code: 'AVISO',
      name: 'Aviso de luz o agua',
      isRequired: true,
      requirementType: 'obligatorio',
    );

    // 3. CROQUIS
    final croquis = const RrhhDossierDocument(
      code: 'CROQUIS',
      name: 'Croquis domiciliario',
      isRequired: true,
      requirementType: 'obligatorio',
    );

    // 4. FOTO
    final foto = const RrhhDossierDocument(
      code: 'FOTO',
      name: 'Foto 3x4 fondo rojo',
      isRequired: true,
      requirementType: 'obligatorio',
    );

    // 5. SUS
    final sus = const RrhhDossierDocument(
      code: 'SUS',
      name: 'Constancia SUS',
      isRequired: true,
      requirementType: 'obligatorio',
    );

    // 6. FELCC
    final felccRequired = isCampo;
    final felccType = isCampo
        ? 'obligatorio'
        : (isSecurity ? 'condicional' : 'no_aplica');
    final felcc = RrhhDossierDocument(
      code: 'FELCC',
      name: 'Certificado FELCC',
      isRequired: felccRequired,
      requirementType: felccType,
    );

    // 7. TITULO
    final tituloType = isCampo
        ? 'no_aplica'
        : (isProfessional ? 'condicional' : 'no_aplica');
    final titulo = RrhhDossierDocument(
      code: 'TITULO',
      name: 'Título profesional',
      isRequired: false,
      requirementType: tituloType,
    );

    // 8. LICENCIA
    final licenciaType = requiresDriver ? 'condicional' : 'no_aplica';
    final licencia = RrhhDossierDocument(
      code: 'LICENCIA',
      name: 'Licencia de conducir',
      isRequired: false,
      requirementType: licenciaType,
    );

    return {
      'CI': ci,
      'AVISO': aviso,
      'CROQUIS': croquis,
      'FOTO': foto,
      'SUS': sus,
      'FELCC': felcc,
      'TITULO': titulo,
      'LICENCIA': licencia,
    };
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'isRequired': isRequired,
        'requirementType': requirementType,
        'status': status,
        'receivedAt': receivedAt?.toIso8601String(),
        'notes': notes,
        'scannedFileUrl': scannedFileUrl,
      };

  factory RrhhDossierDocument.fromJson(Map<String, dynamic> json) =>
      RrhhDossierDocument(
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        isRequired: json['isRequired'] as bool? ?? false,
        requirementType: json['requirementType'] as String? ?? 'obligatorio',
        status: json['status'] as String? ?? 'pendiente',
        receivedAt: json['receivedAt'] != null
            ? DateTime.tryParse(json['receivedAt'] as String)
            : null,
        notes: json['notes'] as String?,
        scannedFileUrl: json['scannedFileUrl'] as String?,
      );
}

/// Modelo central del Expediente de Contratación (FASE C).
/// Conecta la etapa SELECCIONADO del reclutamiento con el alta en Nómina.
class RrhhHiringDossier {
  final int id;
  final int applicantId;
  final String applicantCode; // POST-XXX
  final String applicantName;
  final String applicantCi;
  final String applicantPhone;
  final String? applicantEmail;
  final String targetArea;
  final String targetPosition;
  final String workplaceType; // 'CAMPO' | 'OFICINA'
  final DateTime applicationDate;
  final DateTime createdAt; // Fecha en que llegó a SELECCIONADO
  final DateTime? closedAt; // Fecha en que se formalizó a empleado

  // Estado general: 'abierto' | 'pausado' | 'cerrado'
  final String status;

  // Estados por sección: 'pendiente' | 'en_proceso' | 'completa'
  final String section1Status;
  final String section2Status;
  final String section3Status;
  final String section4Status;
  final String section5Status;
  final String section6Status;

  // Contenido de la Sección 1 (Documentos)
  final Map<String, RrhhDossierDocument> documents;

  // Contenido de la Sección 2 (Afiliación a Seguridad Social)
  final String? afpId;
  final String? afpName;
  final String? afpNumber;
  final String? healthInsuranceId;
  final String? healthInsuranceName;
  final String? section2Notes;

  // Contenido de la Sección 3 (Datos Personales Complementarios)
  final String? fullAddress;
  final String? maritalStatus;
  final int? childrenCount;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;

  // Contenido de la Sección 4 (Condiciones Contractuales y Modalidad de Pago)
  final String? contractTypeId;
  final String? contractTypeName;
  final String? workdayType; // 'Completa' | 'Parcial' | 'Por horas'
  final String? paymentModalityId;
  final String? paymentModalityName;
  final double? baseSalary;
  final String? currency; // 'BOB' | 'USD'
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final List<RrhhEmployeeBonus>? bonuses;
  final List<RrhhEmployeeDeduction>? deductions;

  // Contenido de la Sección 5 (Asignación Organizacional, Turno y Sede Base)
  final String? areaId;
  final String? areaName;
  final String? positionId;
  final String? positionName;
  final String? shiftId;
  final String? shiftName;
  final String? scheduleId;
  final String? scheduleName;
  final String? baseLocation;
  final String? supervisorEmployeeId;
  final String? supervisorName;
  final DateTime? effectiveStartDate;

  const RrhhHiringDossier({
    required this.id,
    required this.applicantId,
    required this.applicantCode,
    required this.applicantName,
    required this.applicantCi,
    required this.applicantPhone,
    this.applicantEmail,
    required this.targetArea,
    required this.targetPosition,
    required this.workplaceType,
    required this.applicationDate,
    required this.createdAt,
    this.closedAt,
    this.status = 'abierto',
    this.section1Status = 'pendiente',
    this.section2Status = 'pendiente',
    this.section3Status = 'pendiente',
    this.section4Status = 'pendiente',
    this.section5Status = 'pendiente',
    this.section6Status = 'pendiente',
    this.documents = const {},
    this.afpId,
    this.afpName,
    this.afpNumber,
    this.healthInsuranceId,
    this.healthInsuranceName,
    this.section2Notes,
    this.fullAddress,
    this.maritalStatus,
    this.childrenCount,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.contractTypeId,
    this.contractTypeName,
    this.workdayType,
    this.paymentModalityId,
    this.paymentModalityName,
    this.baseSalary,
    this.currency,
    this.contractStartDate,
    this.contractEndDate,
    this.bonuses,
    this.deductions,
    this.areaId,
    this.areaName,
    this.positionId,
    this.positionName,
    this.shiftId,
    this.shiftName,
    this.scheduleId,
    this.scheduleName,
    this.baseLocation,
    this.supervisorEmployeeId,
    this.supervisorName,
    this.effectiveStartDate,
  });

  /// Número de secciones completas (0 a 6)
  int get completedSectionsCount {
    int count = 0;
    if (section1Status == 'completa') count++;
    if (section2Status == 'completa') count++;
    if (section3Status == 'completa') count++;
    if (section4Status == 'completa') count++;
    if (section5Status == 'completa') count++;
    if (section6Status == 'completa') count++;
    return count;
  }

  /// Fracción de progreso para la barra visual (0.0 a 1.0)
  double get progressFraction => completedSectionsCount / 6.0;

  /// Etiqueta visual de progreso
  String get progressLabel => '$completedSectionsCount/6 secciones completas';

  /// ¿Están todos los documentos obligatorios validados?
  bool get areAllRequiredDocumentsValidated {
    final requiredDocs = documents.values.where((d) => d.isRequired);
    if (requiredDocs.isEmpty) return false;
    return requiredDocs.every((d) => d.status == 'validado');
  }

  /// Conteo de documentos obligatorios validados vs total obligatorios
  int get validatedRequiredDocsCount =>
      documents.values.where((d) => d.isRequired && d.isValidated).length;

  int get totalRequiredDocsCount =>
      documents.values.where((d) => d.isRequired).length;

  /// Etiqueta descriptiva del estado del expediente para la tabla
  String get dossierStatusLabel {
    if (status == 'pausado') return 'Pausado';
    if (completedSectionsCount >= 5) return 'Listo para convertir';
    if (completedSectionsCount >= 1) return 'En proceso';
    return 'Documentos pendientes';
  }

  RrhhHiringDossier copyWith({
    int? id,
    int? applicantId,
    String? applicantCode,
    String? applicantName,
    String? applicantCi,
    String? applicantPhone,
    String? applicantEmail,
    String? targetArea,
    String? targetPosition,
    String? workplaceType,
    DateTime? applicationDate,
    DateTime? createdAt,
    DateTime? closedAt,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    Map<String, RrhhDossierDocument>? documents,
    String? afpId,
    String? afpName,
    String? afpNumber,
    String? healthInsuranceId,
    String? healthInsuranceName,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractTypeId,
    String? contractTypeName,
    String? workdayType,
    String? paymentModalityId,
    String? paymentModalityName,
    double? baseSalary,
    String? currency,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    String? areaId,
    String? areaName,
    String? positionId,
    String? positionName,
    String? shiftId,
    String? shiftName,
    String? scheduleId,
    String? scheduleName,
    String? baseLocation,
    String? supervisorEmployeeId,
    String? supervisorName,
    DateTime? effectiveStartDate,
  }) {
    return RrhhHiringDossier(
      id: id ?? this.id,
      applicantId: applicantId ?? this.applicantId,
      applicantCode: applicantCode ?? this.applicantCode,
      applicantName: applicantName ?? this.applicantName,
      applicantCi: applicantCi ?? this.applicantCi,
      applicantPhone: applicantPhone ?? this.applicantPhone,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      targetArea: targetArea ?? this.targetArea,
      targetPosition: targetPosition ?? this.targetPosition,
      workplaceType: workplaceType ?? this.workplaceType,
      applicationDate: applicationDate ?? this.applicationDate,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      status: status ?? this.status,
      section1Status: section1Status ?? this.section1Status,
      section2Status: section2Status ?? this.section2Status,
      section3Status: section3Status ?? this.section3Status,
      section4Status: section4Status ?? this.section4Status,
      section5Status: section5Status ?? this.section5Status,
      section6Status: section6Status ?? this.section6Status,
      documents: documents ?? this.documents,
      afpId: afpId ?? this.afpId,
      afpName: afpName ?? this.afpName,
      afpNumber: afpNumber ?? this.afpNumber,
      healthInsuranceId: healthInsuranceId ?? this.healthInsuranceId,
      healthInsuranceName: healthInsuranceName ?? this.healthInsuranceName,
      section2Notes: section2Notes ?? this.section2Notes,
      fullAddress: fullAddress ?? this.fullAddress,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      childrenCount: childrenCount ?? this.childrenCount,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
      contractTypeId: contractTypeId ?? this.contractTypeId,
      contractTypeName: contractTypeName ?? this.contractTypeName,
      workdayType: workdayType ?? this.workdayType,
      paymentModalityId: paymentModalityId ?? this.paymentModalityId,
      paymentModalityName: paymentModalityName ?? this.paymentModalityName,
      baseSalary: baseSalary ?? this.baseSalary,
      currency: currency ?? this.currency,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      bonuses: bonuses ?? this.bonuses,
      deductions: deductions ?? this.deductions,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      positionId: positionId ?? this.positionId,
      positionName: positionName ?? this.positionName,
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduleName: scheduleName ?? this.scheduleName,
      baseLocation: baseLocation ?? this.baseLocation,
      supervisorEmployeeId: supervisorEmployeeId ?? this.supervisorEmployeeId,
      supervisorName: supervisorName ?? this.supervisorName,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'applicantId': applicantId,
        'applicantCode': applicantCode,
        'applicantName': applicantName,
        'applicantCi': applicantCi,
        'applicantPhone': applicantPhone,
        'applicantEmail': applicantEmail,
        'targetArea': targetArea,
        'targetPosition': targetPosition,
        'workplaceType': workplaceType,
        'applicationDate': applicationDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'closedAt': closedAt?.toIso8601String(),
        'status': status,
        'section1Status': section1Status,
        'section2Status': section2Status,
        'section3Status': section3Status,
        'section4Status': section4Status,
        'section5Status': section5Status,
        'section6Status': section6Status,
        'documents': documents.map((k, v) => MapEntry(k, v.toJson())),
        if (afpId != null) 'afpId': afpId,
        if (afpName != null) 'afpName': afpName,
        if (afpNumber != null) 'afpNumber': afpNumber,
        if (healthInsuranceId != null) 'healthInsuranceId': healthInsuranceId,
        if (healthInsuranceName != null) 'healthInsuranceName': healthInsuranceName,
        if (section2Notes != null) 'section2Notes': section2Notes,
        if (fullAddress != null) 'fullAddress': fullAddress,
        if (maritalStatus != null) 'maritalStatus': maritalStatus,
        if (childrenCount != null) 'childrenCount': childrenCount,
        if (emergencyContactName != null) 'emergencyContactName': emergencyContactName,
        if (emergencyContactPhone != null) 'emergencyContactPhone': emergencyContactPhone,
        if (emergencyContactRelation != null) 'emergencyContactRelation': emergencyContactRelation,
        if (contractTypeId != null) 'contractTypeId': contractTypeId,
        if (contractTypeName != null) 'contractTypeName': contractTypeName,
        if (workdayType != null) 'workdayType': workdayType,
        if (paymentModalityId != null) 'paymentModalityId': paymentModalityId,
        if (paymentModalityName != null) 'paymentModalityName': paymentModalityName,
        if (baseSalary != null) 'baseSalary': baseSalary,
        if (currency != null) 'currency': currency,
        if (contractStartDate != null) 'contractStartDate': contractStartDate!.toIso8601String(),
        if (contractEndDate != null) 'contractEndDate': contractEndDate!.toIso8601String(),
        if (bonuses != null)
          'bonuses': bonuses!
              .map((b) => {
                    'code': b.code,
                    'name': b.name,
                    'type': b.type,
                    if (b.amount != null) 'amount': b.amount,
                    'isPercentage': b.isPercentage,
                    if (b.applyFrom != null) 'applyFrom': b.applyFrom!.toIso8601String(),
                    if (b.applyTo != null) 'applyTo': b.applyTo!.toIso8601String(),
                  })
              .toList(),
        if (deductions != null)
          'deductions': deductions!
              .map((d) => {
                    'code': d.code,
                    'name': d.name,
                    'type': d.type,
                    if (d.amount != null) 'amount': d.amount,
                    'isPercentage': d.isPercentage,
                    if (d.applyFrom != null) 'applyFrom': d.applyFrom!.toIso8601String(),
                    if (d.applyTo != null) 'applyTo': d.applyTo!.toIso8601String(),
                  })
              .toList(),
        if (areaId != null) 'areaId': areaId,
        if (areaName != null) 'areaName': areaName,
        if (positionId != null) 'positionId': positionId,
        if (positionName != null) 'positionName': positionName,
        if (shiftId != null) 'shiftId': shiftId,
        if (shiftName != null) 'shiftName': shiftName,
        if (scheduleId != null) 'scheduleId': scheduleId,
        if (scheduleName != null) 'scheduleName': scheduleName,
        if (baseLocation != null) 'baseLocation': baseLocation,
        if (supervisorEmployeeId != null) 'supervisorEmployeeId': supervisorEmployeeId,
        if (supervisorName != null) 'supervisorName': supervisorName,
        if (effectiveStartDate != null) 'effectiveStartDate': effectiveStartDate!.toIso8601String(),
      };

  factory RrhhHiringDossier.fromJson(Map<String, dynamic> json) =>
      RrhhHiringDossier(
        id: json['id'] as int? ?? 0,
        applicantId: json['applicantId'] as int? ?? 0,
        applicantCode: json['applicantCode'] as String? ?? '',
        applicantName: json['applicantName'] as String? ?? '',
        applicantCi: json['applicantCi'] as String? ?? '',
        applicantPhone: json['applicantPhone'] as String? ?? '',
        applicantEmail: json['applicantEmail'] as String?,
        targetArea: json['targetArea'] as String? ?? '',
        targetPosition: json['targetPosition'] as String? ?? '',
        workplaceType: json['workplaceType'] as String? ?? 'CAMPO',
        applicationDate: json['applicationDate'] != null
            ? DateTime.tryParse(json['applicationDate'] as String) ??
                DateTime.now()
            : DateTime.now(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
        closedAt: json['closedAt'] != null
            ? DateTime.tryParse(json['closedAt'] as String)
            : null,
        status: json['status'] as String? ?? 'abierto',
        section1Status: json['section1Status'] as String? ?? 'pendiente',
        section2Status: json['section2Status'] as String? ?? 'pendiente',
        section3Status: json['section3Status'] as String? ?? 'pendiente',
        section4Status: json['section4Status'] as String? ?? 'pendiente',
        section5Status: json['section5Status'] as String? ?? 'pendiente',
        section6Status: json['section6Status'] as String? ?? 'pendiente',
        documents: (json['documents'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(
                k,
                RrhhDossierDocument.fromJson(v as Map<String, dynamic>),
              ),
            ) ??
            const {},
        afpId: json['afpId'] as String?,
        afpName: json['afpName'] as String?,
        afpNumber: json['afpNumber'] as String?,
        healthInsuranceId: json['healthInsuranceId'] as String?,
        healthInsuranceName: json['healthInsuranceName'] as String?,
        section2Notes: json['section2Notes'] as String?,
        fullAddress: json['fullAddress'] as String?,
        maritalStatus: json['maritalStatus'] as String?,
        childrenCount: json['childrenCount'] as int?,
        emergencyContactName: json['emergencyContactName'] as String?,
        emergencyContactPhone: json['emergencyContactPhone'] as String?,
        emergencyContactRelation: json['emergencyContactRelation'] as String?,
        contractTypeId: json['contractTypeId'] as String?,
        contractTypeName: json['contractTypeName'] as String?,
        workdayType: json['workdayType'] as String?,
        paymentModalityId: json['paymentModalityId'] as String?,
        paymentModalityName: json['paymentModalityName'] as String?,
        baseSalary: (json['baseSalary'] as num?)?.toDouble(),
        currency: json['currency'] as String?,
        contractStartDate: json['contractStartDate'] != null
            ? DateTime.tryParse(json['contractStartDate'] as String)
            : null,
        contractEndDate: json['contractEndDate'] != null
            ? DateTime.tryParse(json['contractEndDate'] as String)
            : null,
        bonuses: (json['bonuses'] as List<dynamic>?)
            ?.map((b) => RrhhEmployeeBonus.fromJson(b as Map<String, dynamic>))
            .toList(),
        deductions: (json['deductions'] as List<dynamic>?)
            ?.map((d) => RrhhEmployeeDeduction.fromJson(d as Map<String, dynamic>))
            .toList(),
        areaId: json['areaId'] as String?,
        areaName: json['areaName'] as String?,
        positionId: json['positionId'] as String?,
        positionName: json['positionName'] as String?,
        shiftId: json['shiftId'] as String?,
        shiftName: json['shiftName'] as String?,
        scheduleId: json['scheduleId'] as String?,
        scheduleName: json['scheduleName'] as String?,
        baseLocation: json['baseLocation'] as String?,
        supervisorEmployeeId: json['supervisorEmployeeId'] as String?,
        supervisorName: json['supervisorName'] as String?,
        effectiveStartDate: json['effectiveStartDate'] != null
            ? DateTime.tryParse(json['effectiveStartDate'] as String)
            : null,
      );
}
