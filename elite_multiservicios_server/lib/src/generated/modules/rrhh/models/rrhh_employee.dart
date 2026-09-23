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

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:elite_multiservicios_server/src/generated/protocol.dart' as _i2;

/// Expediente maestro del Colaborador / Empleado de Elite Multiservicios.
abstract class RrhhEmployee
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = RrhhEmployeeTable();

  static const db = RrhhEmployeeRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static RrhhEmployeeInclude include() {
    return RrhhEmployeeInclude._();
  }

  static RrhhEmployeeIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhEmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeTable>? orderByList,
    RrhhEmployeeInclude? include,
  }) {
    return RrhhEmployeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhEmployee.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhEmployee.t),
      include: include,
    );
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

class RrhhEmployeeUpdateTable extends _i1.UpdateTable<RrhhEmployeeTable> {
  RrhhEmployeeUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> fullName(String value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> birthDate(DateTime? value) =>
      _i1.ColumnValue(
        table.birthDate,
        value,
      );

  _i1.ColumnValue<String, String> birthPlace(String value) => _i1.ColumnValue(
    table.birthPlace,
    value,
  );

  _i1.ColumnValue<String, String> identityCard(String value) => _i1.ColumnValue(
    table.identityCard,
    value,
  );

  _i1.ColumnValue<String, String> phone(String value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> occupation(String value) => _i1.ColumnValue(
    table.occupation,
    value,
  );

  _i1.ColumnValue<String, String> personalReference(String value) =>
      _i1.ColumnValue(
        table.personalReference,
        value,
      );

  _i1.ColumnValue<String, String> referencePhone(String value) =>
      _i1.ColumnValue(
        table.referencePhone,
        value,
      );

  _i1.ColumnValue<String, String> employeeType(String value) => _i1.ColumnValue(
    table.employeeType,
    value,
  );

  _i1.ColumnValue<String, String> area(String value) => _i1.ColumnValue(
    table.area,
    value,
  );

  _i1.ColumnValue<int, int> areaId(int? value) => _i1.ColumnValue(
    table.areaId,
    value,
  );

  _i1.ColumnValue<String, String> position(String value) => _i1.ColumnValue(
    table.position,
    value,
  );

  _i1.ColumnValue<int, int> positionId(int? value) => _i1.ColumnValue(
    table.positionId,
    value,
  );

  _i1.ColumnValue<String, String> specialty(String value) => _i1.ColumnValue(
    table.specialty,
    value,
  );

  _i1.ColumnValue<int, int> specialtyId(int? value) => _i1.ColumnValue(
    table.specialtyId,
    value,
  );

  _i1.ColumnValue<String, String> workplace(String value) => _i1.ColumnValue(
    table.workplace,
    value,
  );

  _i1.ColumnValue<String, String> supervisor(String value) => _i1.ColumnValue(
    table.supervisor,
    value,
  );

  _i1.ColumnValue<int, int> supervisorId(int? value) => _i1.ColumnValue(
    table.supervisorId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> realStartDate(DateTime value) =>
      _i1.ColumnValue(
        table.realStartDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> fiscalStartDate(DateTime value) =>
      _i1.ColumnValue(
        table.fiscalStartDate,
        value,
      );

  _i1.ColumnValue<double, double> agreedSalary(double value) => _i1.ColumnValue(
    table.agreedSalary,
    value,
  );

  _i1.ColumnValue<String, String> contractType(String value) => _i1.ColumnValue(
    table.contractType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> contractEndDate(DateTime? value) =>
      _i1.ColumnValue(
        table.contractEndDate,
        value,
      );

  _i1.ColumnValue<String, String> observations(String? value) =>
      _i1.ColumnValue(
        table.observations,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> skills(List<String>? value) =>
      _i1.ColumnValue(
        table.skills,
        value,
      );

  _i1.ColumnValue<String, String> availabilityStatus(String value) =>
      _i1.ColumnValue(
        table.availabilityStatus,
        value,
      );

  _i1.ColumnValue<String, String> paymentModality(String value) =>
      _i1.ColumnValue(
        table.paymentModality,
        value,
      );

  _i1.ColumnValue<String, String> workScheduleType(String value) =>
      _i1.ColumnValue(
        table.workScheduleType,
        value,
      );

  _i1.ColumnValue<bool, bool> hasCiCopy(bool value) => _i1.ColumnValue(
    table.hasCiCopy,
    value,
  );

  _i1.ColumnValue<bool, bool> hasUtilityBill(bool value) => _i1.ColumnValue(
    table.hasUtilityBill,
    value,
  );

  _i1.ColumnValue<bool, bool> hasHomeSketch(bool value) => _i1.ColumnValue(
    table.hasHomeSketch,
    value,
  );

  _i1.ColumnValue<bool, bool> hasFelccRecord(bool value) => _i1.ColumnValue(
    table.hasFelccRecord,
    value,
  );

  _i1.ColumnValue<bool, bool> hasPhoto3x4(bool value) => _i1.ColumnValue(
    table.hasPhoto3x4,
    value,
  );

  _i1.ColumnValue<bool, bool> hasSusInsurance(bool value) => _i1.ColumnValue(
    table.hasSusInsurance,
    value,
  );

  _i1.ColumnValue<String, String> photoUrl(String? value) => _i1.ColumnValue(
    table.photoUrl,
    value,
  );

  _i1.ColumnValue<String, String> corporateEmail(String? value) =>
      _i1.ColumnValue(
        table.corporateEmail,
        value,
      );

  _i1.ColumnValue<String, String> temporaryPassword(String? value) =>
      _i1.ColumnValue(
        table.temporaryPassword,
        value,
      );

  _i1.ColumnValue<int, int> applicantId(int? value) => _i1.ColumnValue(
    table.applicantId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> exitDate(DateTime? value) =>
      _i1.ColumnValue(
        table.exitDate,
        value,
      );

  _i1.ColumnValue<String, String> exitReason(String? value) => _i1.ColumnValue(
    table.exitReason,
    value,
  );

  _i1.ColumnValue<String, String> exitObservations(String? value) =>
      _i1.ColumnValue(
        table.exitObservations,
        value,
      );

  _i1.ColumnValue<String, String> exitRegisteredBy(String? value) =>
      _i1.ColumnValue(
        table.exitRegisteredBy,
        value,
      );

  _i1.ColumnValue<bool, bool> isDeleted(bool value) => _i1.ColumnValue(
    table.isDeleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class RrhhEmployeeTable extends _i1.Table<int?> {
  RrhhEmployeeTable({super.tableRelation}) : super(tableName: 'rrhh_employee') {
    updateTable = RrhhEmployeeUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    birthDate = _i1.ColumnDateTime(
      'birthDate',
      this,
    );
    birthPlace = _i1.ColumnString(
      'birthPlace',
      this,
    );
    identityCard = _i1.ColumnString(
      'identityCard',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    occupation = _i1.ColumnString(
      'occupation',
      this,
    );
    personalReference = _i1.ColumnString(
      'personalReference',
      this,
    );
    referencePhone = _i1.ColumnString(
      'referencePhone',
      this,
    );
    employeeType = _i1.ColumnString(
      'employeeType',
      this,
    );
    area = _i1.ColumnString(
      'area',
      this,
    );
    areaId = _i1.ColumnInt(
      'areaId',
      this,
    );
    position = _i1.ColumnString(
      'position',
      this,
    );
    positionId = _i1.ColumnInt(
      'positionId',
      this,
    );
    specialty = _i1.ColumnString(
      'specialty',
      this,
    );
    specialtyId = _i1.ColumnInt(
      'specialtyId',
      this,
    );
    workplace = _i1.ColumnString(
      'workplace',
      this,
    );
    supervisor = _i1.ColumnString(
      'supervisor',
      this,
    );
    supervisorId = _i1.ColumnInt(
      'supervisorId',
      this,
    );
    realStartDate = _i1.ColumnDateTime(
      'realStartDate',
      this,
    );
    fiscalStartDate = _i1.ColumnDateTime(
      'fiscalStartDate',
      this,
    );
    agreedSalary = _i1.ColumnDouble(
      'agreedSalary',
      this,
    );
    contractType = _i1.ColumnString(
      'contractType',
      this,
    );
    contractEndDate = _i1.ColumnDateTime(
      'contractEndDate',
      this,
    );
    observations = _i1.ColumnString(
      'observations',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    skills = _i1.ColumnSerializable<List<String>>(
      'skills',
      this,
    );
    availabilityStatus = _i1.ColumnString(
      'availabilityStatus',
      this,
      hasDefault: true,
    );
    paymentModality = _i1.ColumnString(
      'paymentModality',
      this,
      hasDefault: true,
    );
    workScheduleType = _i1.ColumnString(
      'workScheduleType',
      this,
      hasDefault: true,
    );
    hasCiCopy = _i1.ColumnBool(
      'hasCiCopy',
      this,
      hasDefault: true,
    );
    hasUtilityBill = _i1.ColumnBool(
      'hasUtilityBill',
      this,
      hasDefault: true,
    );
    hasHomeSketch = _i1.ColumnBool(
      'hasHomeSketch',
      this,
      hasDefault: true,
    );
    hasFelccRecord = _i1.ColumnBool(
      'hasFelccRecord',
      this,
      hasDefault: true,
    );
    hasPhoto3x4 = _i1.ColumnBool(
      'hasPhoto3x4',
      this,
      hasDefault: true,
    );
    hasSusInsurance = _i1.ColumnBool(
      'hasSusInsurance',
      this,
      hasDefault: true,
    );
    photoUrl = _i1.ColumnString(
      'photoUrl',
      this,
    );
    corporateEmail = _i1.ColumnString(
      'corporateEmail',
      this,
    );
    temporaryPassword = _i1.ColumnString(
      'temporaryPassword',
      this,
    );
    applicantId = _i1.ColumnInt(
      'applicantId',
      this,
    );
    exitDate = _i1.ColumnDateTime(
      'exitDate',
      this,
    );
    exitReason = _i1.ColumnString(
      'exitReason',
      this,
    );
    exitObservations = _i1.ColumnString(
      'exitObservations',
      this,
    );
    exitRegisteredBy = _i1.ColumnString(
      'exitRegisteredBy',
      this,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
      hasDefault: true,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final RrhhEmployeeUpdateTable updateTable;

  /// Código institucional del empleado (ej: EMP-001).
  late final _i1.ColumnString code;

  /// Nombre completo oficial.
  late final _i1.ColumnString fullName;

  /// Fecha de nacimiento.
  late final _i1.ColumnDateTime birthDate;

  /// Lugar de nacimiento (ej: Santa Cruz de la Sierra, La Paz).
  late final _i1.ColumnString birthPlace;

  /// Cédula de identidad (CI).
  late final _i1.ColumnString identityCard;

  /// Teléfono de contacto personal.
  late final _i1.ColumnString phone;

  /// Dirección de domicilio particular.
  late final _i1.ColumnString address;

  /// Profesión u ocupación formal.
  late final _i1.ColumnString occupation;

  /// Referencia personal o familiar.
  late final _i1.ColumnString personalReference;

  /// Teléfono de la referencia.
  late final _i1.ColumnString referencePhone;

  /// Clasificación laboral
  /// Tipo de entorno laboral: 'OFICINA' o 'CAMPO'.
  late final _i1.ColumnString employeeType;

  /// Nombre del área o departamento.
  late final _i1.ColumnString area;

  late final _i1.ColumnInt areaId;

  /// Nombre del cargo o puesto de trabajo.
  late final _i1.ColumnString position;

  late final _i1.ColumnInt positionId;

  /// Especialidad técnica (ej. Jardinería, Limpieza, Seguridad).
  late final _i1.ColumnString specialty;

  late final _i1.ColumnInt specialtyId;

  /// Sede asignada o nombre de cliente/sede.
  late final _i1.ColumnString workplace;

  /// Nombre del supervisor o jefe directo.
  late final _i1.ColumnString supervisor;

  late final _i1.ColumnInt supervisorId;

  /// Fechas y Contrato
  late final _i1.ColumnDateTime realStartDate;

  late final _i1.ColumnDateTime fiscalStartDate;

  late final _i1.ColumnDouble agreedSalary;

  /// Modalidad de contrato: 'Indefinido', 'Plazo Fijo', 'Servicios'.
  late final _i1.ColumnString contractType;

  late final _i1.ColumnDateTime contractEndDate;

  late final _i1.ColumnString observations;

  /// Estado laboral principal: 'ACTIVO', 'INACTIVO'.
  late final _i1.ColumnString status;

  /// Arquitectura Funcional: Integración Operaciones y Contabilidad
  /// Habilidades técnicas y certificaciones del trabajador.
  late final _i1.ColumnSerializable<List<String>> skills;

  /// Estado de disponibilidad para Operaciones: 'DISPONIBLE', 'ASIGNADO', 'DE_VACACIONES', 'CON_PERMISO', 'SUSPENDIDO'.
  late final _i1.ColumnString availabilityStatus;

  /// Modalidad de pago para Contabilidad: 'MENSUAL', 'JORNAL', 'POR_HORAS', 'POR_PROYECTO'.
  late final _i1.ColumnString paymentModality;

  /// Tipo de jornada laboral: 'TIEMPO_COMPLETO_48H', 'MEDIO_TIEMPO', 'ROTATIVO_24_48', 'HORARIO_OFICINA'.
  late final _i1.ColumnString workScheduleType;

  /// Documentos Físicos del Expediente
  late final _i1.ColumnBool hasCiCopy;

  late final _i1.ColumnBool hasUtilityBill;

  late final _i1.ColumnBool hasHomeSketch;

  late final _i1.ColumnBool hasFelccRecord;

  late final _i1.ColumnBool hasPhoto3x4;

  late final _i1.ColumnBool hasSusInsurance;

  late final _i1.ColumnString photoUrl;

  /// Credenciales Institucionales para APK de Asistencia
  late final _i1.ColumnString corporateEmail;

  late final _i1.ColumnString temporaryPassword;

  /// Vinculación con postulante de origen si proviene del proceso de reclutamiento
  late final _i1.ColumnInt applicantId;

  /// Datos de Desvinculación (si pasa a INACTIVO)
  late final _i1.ColumnDateTime exitDate;

  late final _i1.ColumnString exitReason;

  late final _i1.ColumnString exitObservations;

  late final _i1.ColumnString exitRegisteredBy;

  /// Eliminación lógica y auditoría
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    fullName,
    birthDate,
    birthPlace,
    identityCard,
    phone,
    address,
    occupation,
    personalReference,
    referencePhone,
    employeeType,
    area,
    areaId,
    position,
    positionId,
    specialty,
    specialtyId,
    workplace,
    supervisor,
    supervisorId,
    realStartDate,
    fiscalStartDate,
    agreedSalary,
    contractType,
    contractEndDate,
    observations,
    status,
    skills,
    availabilityStatus,
    paymentModality,
    workScheduleType,
    hasCiCopy,
    hasUtilityBill,
    hasHomeSketch,
    hasFelccRecord,
    hasPhoto3x4,
    hasSusInsurance,
    photoUrl,
    corporateEmail,
    temporaryPassword,
    applicantId,
    exitDate,
    exitReason,
    exitObservations,
    exitRegisteredBy,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhEmployeeInclude extends _i1.IncludeObject {
  RrhhEmployeeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhEmployee.t;
}

class RrhhEmployeeIncludeList extends _i1.IncludeList {
  RrhhEmployeeIncludeList._({
    _i1.WhereExpressionBuilder<RrhhEmployeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhEmployee.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhEmployee.t;
}

class RrhhEmployeeRepository {
  const RrhhEmployeeRepository._();

  /// Returns a list of [RrhhEmployee]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<RrhhEmployee>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhEmployee>(
      where: where?.call(RrhhEmployee.t),
      orderBy: orderBy?.call(RrhhEmployee.t),
      orderByList: orderByList?.call(RrhhEmployee.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhEmployee] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<RrhhEmployee?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhEmployeeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhEmployee>(
      where: where?.call(RrhhEmployee.t),
      orderBy: orderBy?.call(RrhhEmployee.t),
      orderByList: orderByList?.call(RrhhEmployee.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhEmployee] by its [id] or null if no such row exists.
  Future<RrhhEmployee?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhEmployee>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhEmployee]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhEmployee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhEmployee>> insert(
    _i1.DatabaseSession session,
    List<RrhhEmployee> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhEmployee>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhEmployee] and returns the inserted row.
  ///
  /// The returned [RrhhEmployee] will have its `id` field set.
  Future<RrhhEmployee> insertRow(
    _i1.DatabaseSession session,
    RrhhEmployee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhEmployee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhEmployee>> update(
    _i1.DatabaseSession session,
    List<RrhhEmployee> rows, {
    _i1.ColumnSelections<RrhhEmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhEmployee>(
      rows,
      columns: columns?.call(RrhhEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhEmployee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhEmployee> updateRow(
    _i1.DatabaseSession session,
    RrhhEmployee row, {
    _i1.ColumnSelections<RrhhEmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhEmployee>(
      row,
      columns: columns?.call(RrhhEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhEmployee] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhEmployee?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhEmployeeUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhEmployee>(
      id,
      columnValues: columnValues(RrhhEmployee.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhEmployee]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhEmployee>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhEmployeeUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhEmployeeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhEmployeeTable>? orderBy,
    _i1.OrderByListBuilder<RrhhEmployeeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhEmployee>(
      columnValues: columnValues(RrhhEmployee.t.updateTable),
      where: where(RrhhEmployee.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhEmployee.t),
      orderByList: orderByList?.call(RrhhEmployee.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhEmployee]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhEmployee>> delete(
    _i1.DatabaseSession session,
    List<RrhhEmployee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhEmployee>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhEmployee].
  Future<RrhhEmployee> deleteRow(
    _i1.DatabaseSession session,
    RrhhEmployee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhEmployee>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhEmployeeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhEmployee>(
      where: where(RrhhEmployee.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhEmployeeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhEmployee>(
      where: where?.call(RrhhEmployee.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhEmployee] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhEmployeeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhEmployee>(
      where: where(RrhhEmployee.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
