/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i2;

/// Expediente maestro del Colaborador / Empleado de Elite Multiservicios.
abstract class RrhhEmployee implements _i1.SerializableModel {
  RrhhEmployee._({
    this.id,
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
    this.areaId,
    required this.position,
    this.positionId,
    required this.specialty,
    this.specialtyId,
    required this.workplace,
    required this.supervisor,
    this.supervisorId,
    required this.realStartDate,
    required this.fiscalStartDate,
    required this.agreedSalary,
    required this.contractType,
    this.contractEndDate,
    this.observations,
    String? status,
    this.skills,
    String? availabilityStatus,
    String? paymentModality,
    String? workScheduleType,
    bool? hasCiCopy,
    bool? hasUtilityBill,
    bool? hasHomeSketch,
    bool? hasFelccRecord,
    bool? hasPhoto3x4,
    bool? hasSusInsurance,
    this.photoUrl,
    this.corporateEmail,
    this.temporaryPassword,
    this.applicantId,
    this.exitDate,
    this.exitReason,
    this.exitObservations,
    this.exitRegisteredBy,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'ACTIVO',
       availabilityStatus = availabilityStatus ?? 'DISPONIBLE',
       paymentModality = paymentModality ?? 'MENSUAL',
       workScheduleType = workScheduleType ?? 'TIEMPO_COMPLETO_48H',
       hasCiCopy = hasCiCopy ?? true,
       hasUtilityBill = hasUtilityBill ?? true,
       hasHomeSketch = hasHomeSketch ?? true,
       hasFelccRecord = hasFelccRecord ?? true,
       hasPhoto3x4 = hasPhoto3x4 ?? true,
       hasSusInsurance = hasSusInsurance ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhEmployee({
    int? id,
    required String code,
    required String fullName,
    DateTime? birthDate,
    required String birthPlace,
    required String identityCard,
    required String phone,
    required String address,
    required String occupation,
    required String personalReference,
    required String referencePhone,
    required String employeeType,
    required String area,
    int? areaId,
    required String position,
    int? positionId,
    required String specialty,
    int? specialtyId,
    required String workplace,
    required String supervisor,
    int? supervisorId,
    required DateTime realStartDate,
    required DateTime fiscalStartDate,
    required double agreedSalary,
    required String contractType,
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
    String? photoUrl,
    String? corporateEmail,
    String? temporaryPassword,
    int? applicantId,
    DateTime? exitDate,
    String? exitReason,
    String? exitObservations,
    String? exitRegisteredBy,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhEmployeeImpl;

  factory RrhhEmployee.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhEmployee(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      fullName: jsonSerialization['fullName'] as String,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      birthPlace: jsonSerialization['birthPlace'] as String,
      identityCard: jsonSerialization['identityCard'] as String,
      phone: jsonSerialization['phone'] as String,
      address: jsonSerialization['address'] as String,
      occupation: jsonSerialization['occupation'] as String,
      personalReference: jsonSerialization['personalReference'] as String,
      referencePhone: jsonSerialization['referencePhone'] as String,
      employeeType: jsonSerialization['employeeType'] as String,
      area: jsonSerialization['area'] as String,
      areaId: jsonSerialization['areaId'] as int?,
      position: jsonSerialization['position'] as String,
      positionId: jsonSerialization['positionId'] as int?,
      specialty: jsonSerialization['specialty'] as String,
      specialtyId: jsonSerialization['specialtyId'] as int?,
      workplace: jsonSerialization['workplace'] as String,
      supervisor: jsonSerialization['supervisor'] as String,
      supervisorId: jsonSerialization['supervisorId'] as int?,
      realStartDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['realStartDate'],
      ),
      fiscalStartDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['fiscalStartDate'],
      ),
      agreedSalary: (jsonSerialization['agreedSalary'] as num).toDouble(),
      contractType: jsonSerialization['contractType'] as String,
      contractEndDate: jsonSerialization['contractEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractEndDate'],
            ),
      observations: jsonSerialization['observations'] as String?,
      status: jsonSerialization['status'] as String?,
      skills: jsonSerialization['skills'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['skills'],
            ),
      availabilityStatus: jsonSerialization['availabilityStatus'] as String?,
      paymentModality: jsonSerialization['paymentModality'] as String?,
      workScheduleType: jsonSerialization['workScheduleType'] as String?,
      hasCiCopy: jsonSerialization['hasCiCopy'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasCiCopy']),
      hasUtilityBill: jsonSerialization['hasUtilityBill'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasUtilityBill']),
      hasHomeSketch: jsonSerialization['hasHomeSketch'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasHomeSketch']),
      hasFelccRecord: jsonSerialization['hasFelccRecord'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasFelccRecord']),
      hasPhoto3x4: jsonSerialization['hasPhoto3x4'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasPhoto3x4']),
      hasSusInsurance: jsonSerialization['hasSusInsurance'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['hasSusInsurance'],
            ),
      photoUrl: jsonSerialization['photoUrl'] as String?,
      corporateEmail: jsonSerialization['corporateEmail'] as String?,
      temporaryPassword: jsonSerialization['temporaryPassword'] as String?,
      applicantId: jsonSerialization['applicantId'] as int?,
      exitDate: jsonSerialization['exitDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['exitDate']),
      exitReason: jsonSerialization['exitReason'] as String?,
      exitObservations: jsonSerialization['exitObservations'] as String?,
      exitRegisteredBy: jsonSerialization['exitRegisteredBy'] as String?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Código institucional del empleado (ej: EMP-001).
  String code;

  /// Nombre completo oficial.
  String fullName;

  /// Fecha de nacimiento.
  DateTime? birthDate;

  /// Lugar de nacimiento (ej: Santa Cruz de la Sierra, La Paz).
  String birthPlace;

  /// Cédula de identidad (CI).
  String identityCard;

  /// Teléfono de contacto personal.
  String phone;

  /// Dirección de domicilio particular.
  String address;

  /// Profesión u ocupación formal.
  String occupation;

  /// Referencia personal o familiar.
  String personalReference;

  /// Teléfono de la referencia.
  String referencePhone;

  /// Clasificación laboral
  /// Tipo de entorno laboral: 'OFICINA' o 'CAMPO'.
  String employeeType;

  /// Nombre del área o departamento.
  String area;

  int? areaId;

  /// Nombre del cargo o puesto de trabajo.
  String position;

  int? positionId;

  /// Especialidad técnica (ej. Jardinería, Limpieza, Seguridad).
  String specialty;

  int? specialtyId;

  /// Sede asignada o nombre de cliente/sede.
  String workplace;

  /// Nombre del supervisor o jefe directo.
  String supervisor;

  int? supervisorId;

  /// Fechas y Contrato
  DateTime realStartDate;

  DateTime fiscalStartDate;

  double agreedSalary;

  /// Modalidad de contrato: 'Indefinido', 'Plazo Fijo', 'Servicios'.
  String contractType;

  DateTime? contractEndDate;

  String? observations;

  /// Estado laboral principal: 'ACTIVO', 'INACTIVO'.
  String status;

  /// Arquitectura Funcional: Integración Operaciones y Contabilidad
  /// Habilidades técnicas y certificaciones del trabajador.
  List<String>? skills;

  /// Estado de disponibilidad para Operaciones: 'DISPONIBLE', 'ASIGNADO', 'DE_VACACIONES', 'CON_PERMISO', 'SUSPENDIDO'.
  String availabilityStatus;

  /// Modalidad de pago para Contabilidad: 'MENSUAL', 'JORNAL', 'POR_HORAS', 'POR_PROYECTO'.
  String paymentModality;

  /// Tipo de jornada laboral: 'TIEMPO_COMPLETO_48H', 'MEDIO_TIEMPO', 'ROTATIVO_24_48', 'HORARIO_OFICINA'.
  String workScheduleType;

  /// Documentos Físicos del Expediente
  bool hasCiCopy;

  bool hasUtilityBill;

  bool hasHomeSketch;

  bool hasFelccRecord;

  bool hasPhoto3x4;

  bool hasSusInsurance;

  String? photoUrl;

  /// Credenciales Institucionales para APK de Asistencia
  String? corporateEmail;

  String? temporaryPassword;

  /// Vinculación con postulante de origen si proviene del proceso de reclutamiento
  int? applicantId;

  /// Datos de Desvinculación (si pasa a INACTIVO)
  DateTime? exitDate;

  String? exitReason;

  String? exitObservations;

  String? exitRegisteredBy;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployee copyWith({
    int? id,
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
    int? areaId,
    String? position,
    int? positionId,
    String? specialty,
    int? specialtyId,
    String? workplace,
    String? supervisor,
    int? supervisorId,
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
    String? photoUrl,
    String? corporateEmail,
    String? temporaryPassword,
    int? applicantId,
    DateTime? exitDate,
    String? exitReason,
    String? exitObservations,
    String? exitRegisteredBy,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployee',
      if (id != null) 'id': id,
      'code': code,
      'fullName': fullName,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      'birthPlace': birthPlace,
      'identityCard': identityCard,
      'phone': phone,
      'address': address,
      'occupation': occupation,
      'personalReference': personalReference,
      'referencePhone': referencePhone,
      'employeeType': employeeType,
      'area': area,
      if (areaId != null) 'areaId': areaId,
      'position': position,
      if (positionId != null) 'positionId': positionId,
      'specialty': specialty,
      if (specialtyId != null) 'specialtyId': specialtyId,
      'workplace': workplace,
      'supervisor': supervisor,
      if (supervisorId != null) 'supervisorId': supervisorId,
      'realStartDate': realStartDate.toJson(),
      'fiscalStartDate': fiscalStartDate.toJson(),
      'agreedSalary': agreedSalary,
      'contractType': contractType,
      if (contractEndDate != null) 'contractEndDate': contractEndDate?.toJson(),
      if (observations != null) 'observations': observations,
      'status': status,
      if (skills != null) 'skills': skills?.toJson(),
      'availabilityStatus': availabilityStatus,
      'paymentModality': paymentModality,
      'workScheduleType': workScheduleType,
      'hasCiCopy': hasCiCopy,
      'hasUtilityBill': hasUtilityBill,
      'hasHomeSketch': hasHomeSketch,
      'hasFelccRecord': hasFelccRecord,
      'hasPhoto3x4': hasPhoto3x4,
      'hasSusInsurance': hasSusInsurance,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (corporateEmail != null) 'corporateEmail': corporateEmail,
      if (temporaryPassword != null) 'temporaryPassword': temporaryPassword,
      if (applicantId != null) 'applicantId': applicantId,
      if (exitDate != null) 'exitDate': exitDate?.toJson(),
      if (exitReason != null) 'exitReason': exitReason,
      if (exitObservations != null) 'exitObservations': exitObservations,
      if (exitRegisteredBy != null) 'exitRegisteredBy': exitRegisteredBy,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeImpl extends RrhhEmployee {
  _RrhhEmployeeImpl({
    int? id,
    required String code,
    required String fullName,
    DateTime? birthDate,
    required String birthPlace,
    required String identityCard,
    required String phone,
    required String address,
    required String occupation,
    required String personalReference,
    required String referencePhone,
    required String employeeType,
    required String area,
    int? areaId,
    required String position,
    int? positionId,
    required String specialty,
    int? specialtyId,
    required String workplace,
    required String supervisor,
    int? supervisorId,
    required DateTime realStartDate,
    required DateTime fiscalStartDate,
    required double agreedSalary,
    required String contractType,
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
    String? photoUrl,
    String? corporateEmail,
    String? temporaryPassword,
    int? applicantId,
    DateTime? exitDate,
    String? exitReason,
    String? exitObservations,
    String? exitRegisteredBy,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         fullName: fullName,
         birthDate: birthDate,
         birthPlace: birthPlace,
         identityCard: identityCard,
         phone: phone,
         address: address,
         occupation: occupation,
         personalReference: personalReference,
         referencePhone: referencePhone,
         employeeType: employeeType,
         area: area,
         areaId: areaId,
         position: position,
         positionId: positionId,
         specialty: specialty,
         specialtyId: specialtyId,
         workplace: workplace,
         supervisor: supervisor,
         supervisorId: supervisorId,
         realStartDate: realStartDate,
         fiscalStartDate: fiscalStartDate,
         agreedSalary: agreedSalary,
         contractType: contractType,
         contractEndDate: contractEndDate,
         observations: observations,
         status: status,
         skills: skills,
         availabilityStatus: availabilityStatus,
         paymentModality: paymentModality,
         workScheduleType: workScheduleType,
         hasCiCopy: hasCiCopy,
         hasUtilityBill: hasUtilityBill,
         hasHomeSketch: hasHomeSketch,
         hasFelccRecord: hasFelccRecord,
         hasPhoto3x4: hasPhoto3x4,
         hasSusInsurance: hasSusInsurance,
         photoUrl: photoUrl,
         corporateEmail: corporateEmail,
         temporaryPassword: temporaryPassword,
         applicantId: applicantId,
         exitDate: exitDate,
         exitReason: exitReason,
         exitObservations: exitObservations,
         exitRegisteredBy: exitRegisteredBy,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployee copyWith({
    Object? id = _Undefined,
    String? code,
    String? fullName,
    Object? birthDate = _Undefined,
    String? birthPlace,
    String? identityCard,
    String? phone,
    String? address,
    String? occupation,
    String? personalReference,
    String? referencePhone,
    String? employeeType,
    String? area,
    Object? areaId = _Undefined,
    String? position,
    Object? positionId = _Undefined,
    String? specialty,
    Object? specialtyId = _Undefined,
    String? workplace,
    String? supervisor,
    Object? supervisorId = _Undefined,
    DateTime? realStartDate,
    DateTime? fiscalStartDate,
    double? agreedSalary,
    String? contractType,
    Object? contractEndDate = _Undefined,
    Object? observations = _Undefined,
    String? status,
    Object? skills = _Undefined,
    String? availabilityStatus,
    String? paymentModality,
    String? workScheduleType,
    bool? hasCiCopy,
    bool? hasUtilityBill,
    bool? hasHomeSketch,
    bool? hasFelccRecord,
    bool? hasPhoto3x4,
    bool? hasSusInsurance,
    Object? photoUrl = _Undefined,
    Object? corporateEmail = _Undefined,
    Object? temporaryPassword = _Undefined,
    Object? applicantId = _Undefined,
    Object? exitDate = _Undefined,
    Object? exitReason = _Undefined,
    Object? exitObservations = _Undefined,
    Object? exitRegisteredBy = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhEmployee(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      personalReference: personalReference ?? this.personalReference,
      referencePhone: referencePhone ?? this.referencePhone,
      employeeType: employeeType ?? this.employeeType,
      area: area ?? this.area,
      areaId: areaId is int? ? areaId : this.areaId,
      position: position ?? this.position,
      positionId: positionId is int? ? positionId : this.positionId,
      specialty: specialty ?? this.specialty,
      specialtyId: specialtyId is int? ? specialtyId : this.specialtyId,
      workplace: workplace ?? this.workplace,
      supervisor: supervisor ?? this.supervisor,
      supervisorId: supervisorId is int? ? supervisorId : this.supervisorId,
      realStartDate: realStartDate ?? this.realStartDate,
      fiscalStartDate: fiscalStartDate ?? this.fiscalStartDate,
      agreedSalary: agreedSalary ?? this.agreedSalary,
      contractType: contractType ?? this.contractType,
      contractEndDate: contractEndDate is DateTime?
          ? contractEndDate
          : this.contractEndDate,
      observations: observations is String? ? observations : this.observations,
      status: status ?? this.status,
      skills: skills is List<String>?
          ? skills
          : this.skills?.map((e0) => e0).toList(),
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      paymentModality: paymentModality ?? this.paymentModality,
      workScheduleType: workScheduleType ?? this.workScheduleType,
      hasCiCopy: hasCiCopy ?? this.hasCiCopy,
      hasUtilityBill: hasUtilityBill ?? this.hasUtilityBill,
      hasHomeSketch: hasHomeSketch ?? this.hasHomeSketch,
      hasFelccRecord: hasFelccRecord ?? this.hasFelccRecord,
      hasPhoto3x4: hasPhoto3x4 ?? this.hasPhoto3x4,
      hasSusInsurance: hasSusInsurance ?? this.hasSusInsurance,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      corporateEmail: corporateEmail is String?
          ? corporateEmail
          : this.corporateEmail,
      temporaryPassword: temporaryPassword is String?
          ? temporaryPassword
          : this.temporaryPassword,
      applicantId: applicantId is int? ? applicantId : this.applicantId,
      exitDate: exitDate is DateTime? ? exitDate : this.exitDate,
      exitReason: exitReason is String? ? exitReason : this.exitReason,
      exitObservations: exitObservations is String?
          ? exitObservations
          : this.exitObservations,
      exitRegisteredBy: exitRegisteredBy is String?
          ? exitRegisteredBy
          : this.exitRegisteredBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
