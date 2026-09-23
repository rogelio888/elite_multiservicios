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

/// Postulante o candidato en proceso de selección y reclutamiento laboral.
abstract class RrhhApplicant
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhApplicant._({
    this.id,
    required this.code,
    required this.fullName,
    required this.identityCard,
    required this.phone,
    this.email,
    this.address,
    this.birthDate,
    this.emergencyContact,
    this.emergencyPhone,
    this.targetArea,
    this.areaId,
    this.targetPosition,
    this.positionId,
    required this.targetType,
    this.specialty,
    this.specialtyId,
    this.education,
    this.experienceSummary,
    this.skills,
    this.referencePerson,
    this.referencePhone,
    required this.applicationDate,
    String? status,
    this.interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    this.cvUrl,
    this.discardReason,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'NUEVO',
       expectedSalary = expectedSalary ?? 0.0,
       hasCvAttached = hasCvAttached ?? true,
       hasIdentityCardCopy = hasIdentityCardCopy ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhApplicant({
    int? id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    required String targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    required DateTime applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhApplicantImpl;

  factory RrhhApplicant.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhApplicant(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      fullName: jsonSerialization['fullName'] as String,
      identityCard: jsonSerialization['identityCard'] as String,
      phone: jsonSerialization['phone'] as String,
      email: jsonSerialization['email'] as String?,
      address: jsonSerialization['address'] as String?,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      emergencyContact: jsonSerialization['emergencyContact'] as String?,
      emergencyPhone: jsonSerialization['emergencyPhone'] as String?,
      targetArea: jsonSerialization['targetArea'] as String?,
      areaId: jsonSerialization['areaId'] as int?,
      targetPosition: jsonSerialization['targetPosition'] as String?,
      positionId: jsonSerialization['positionId'] as int?,
      targetType: jsonSerialization['targetType'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      specialtyId: jsonSerialization['specialtyId'] as int?,
      education: jsonSerialization['education'] as String?,
      experienceSummary: jsonSerialization['experienceSummary'] as String?,
      skills: jsonSerialization['skills'] as String?,
      referencePerson: jsonSerialization['referencePerson'] as String?,
      referencePhone: jsonSerialization['referencePhone'] as String?,
      applicationDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['applicationDate'],
      ),
      status: jsonSerialization['status'] as String?,
      interviewNotes: jsonSerialization['interviewNotes'] as String?,
      expectedSalary: (jsonSerialization['expectedSalary'] as num?)?.toDouble(),
      hasCvAttached: jsonSerialization['hasCvAttached'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasCvAttached']),
      hasIdentityCardCopy: jsonSerialization['hasIdentityCardCopy'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['hasIdentityCardCopy'],
            ),
      cvUrl: jsonSerialization['cvUrl'] as String?,
      discardReason: jsonSerialization['discardReason'] as String?,
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

  static final t = RrhhApplicantTable();

  static const db = RrhhApplicantRepository._();

  @override
  int? id;

  /// Código identificador del postulante (ej: POST-001).
  String code;

  /// Nombre completo del postulante.
  String fullName;

  /// Documento de identidad (CI).
  String identityCard;

  /// Teléfono o celular de contacto.
  String phone;

  /// Correo electrónico de contacto.
  String? email;

  /// Dirección de domicilio.
  String? address;

  /// Fecha de nacimiento.
  DateTime? birthDate;

  /// Contacto de emergencia (nombre y parentesco).
  String? emergencyContact;

  /// Teléfono del contacto de emergencia.
  String? emergencyPhone;

  /// Área objetivo o departamento al que postula.
  String? targetArea;

  int? areaId;

  /// Cargo objetivo al que aspira.
  String? targetPosition;

  int? positionId;

  /// Tipo de entorno laboral deseado: 'OFICINA' o 'CAMPO'.
  String targetType;

  /// Especialidad técnica (ej: Jardinería, Limpieza, Climatización).
  String? specialty;

  int? specialtyId;

  /// Nivel de formación o educación alcanzada.
  String? education;

  /// Resumen de experiencia laboral previa.
  String? experienceSummary;

  /// Habilidades técnicas y competencias.
  String? skills;

  /// Persona de referencia laboral o personal.
  String? referencePerson;

  /// Teléfono de la persona de referencia.
  String? referencePhone;

  /// Fecha de postulación o recepción de hoja de vida.
  DateTime applicationDate;

  /// Estado en el embudo de selección: 'NUEVO', 'EN_EVALUACION', 'SELECCIONADO', 'RECHAZADO', 'CONTRATADO'.
  String status;

  /// Notas y observaciones de entrevista / evaluación.
  String? interviewNotes;

  /// Pretensión salarial en Bolivianos (Bs.).
  double? expectedSalary;

  /// Indicadores de documentación preliminar adjunta.
  bool hasCvAttached;

  bool hasIdentityCardCopy;

  /// Enlace a currículum digital si existe.
  String? cvUrl;

  /// Motivo de descarte en caso de rechazo.
  String? discardReason;

  /// Eliminación lógica y auditoría.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhApplicant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhApplicant copyWith({
    int? id,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    String? targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    DateTime? applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhApplicant',
      if (id != null) 'id': id,
      'code': code,
      'fullName': fullName,
      'identityCard': identityCard,
      'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (emergencyContact != null) 'emergencyContact': emergencyContact,
      if (emergencyPhone != null) 'emergencyPhone': emergencyPhone,
      if (targetArea != null) 'targetArea': targetArea,
      if (areaId != null) 'areaId': areaId,
      if (targetPosition != null) 'targetPosition': targetPosition,
      if (positionId != null) 'positionId': positionId,
      'targetType': targetType,
      if (specialty != null) 'specialty': specialty,
      if (specialtyId != null) 'specialtyId': specialtyId,
      if (education != null) 'education': education,
      if (experienceSummary != null) 'experienceSummary': experienceSummary,
      if (skills != null) 'skills': skills,
      if (referencePerson != null) 'referencePerson': referencePerson,
      if (referencePhone != null) 'referencePhone': referencePhone,
      'applicationDate': applicationDate.toJson(),
      'status': status,
      if (interviewNotes != null) 'interviewNotes': interviewNotes,
      if (expectedSalary != null) 'expectedSalary': expectedSalary,
      'hasCvAttached': hasCvAttached,
      'hasIdentityCardCopy': hasIdentityCardCopy,
      if (cvUrl != null) 'cvUrl': cvUrl,
      if (discardReason != null) 'discardReason': discardReason,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhApplicant',
      if (id != null) 'id': id,
      'code': code,
      'fullName': fullName,
      'identityCard': identityCard,
      'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (emergencyContact != null) 'emergencyContact': emergencyContact,
      if (emergencyPhone != null) 'emergencyPhone': emergencyPhone,
      if (targetArea != null) 'targetArea': targetArea,
      if (areaId != null) 'areaId': areaId,
      if (targetPosition != null) 'targetPosition': targetPosition,
      if (positionId != null) 'positionId': positionId,
      'targetType': targetType,
      if (specialty != null) 'specialty': specialty,
      if (specialtyId != null) 'specialtyId': specialtyId,
      if (education != null) 'education': education,
      if (experienceSummary != null) 'experienceSummary': experienceSummary,
      if (skills != null) 'skills': skills,
      if (referencePerson != null) 'referencePerson': referencePerson,
      if (referencePhone != null) 'referencePhone': referencePhone,
      'applicationDate': applicationDate.toJson(),
      'status': status,
      if (interviewNotes != null) 'interviewNotes': interviewNotes,
      if (expectedSalary != null) 'expectedSalary': expectedSalary,
      'hasCvAttached': hasCvAttached,
      'hasIdentityCardCopy': hasIdentityCardCopy,
      if (cvUrl != null) 'cvUrl': cvUrl,
      if (discardReason != null) 'discardReason': discardReason,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhApplicantInclude include() {
    return RrhhApplicantInclude._();
  }

  static RrhhApplicantIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhApplicantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhApplicantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhApplicantTable>? orderByList,
    RrhhApplicantInclude? include,
  }) {
    return RrhhApplicantIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhApplicant.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhApplicant.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhApplicantImpl extends RrhhApplicant {
  _RrhhApplicantImpl({
    int? id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    required String targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    required DateTime applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         fullName: fullName,
         identityCard: identityCard,
         phone: phone,
         email: email,
         address: address,
         birthDate: birthDate,
         emergencyContact: emergencyContact,
         emergencyPhone: emergencyPhone,
         targetArea: targetArea,
         areaId: areaId,
         targetPosition: targetPosition,
         positionId: positionId,
         targetType: targetType,
         specialty: specialty,
         specialtyId: specialtyId,
         education: education,
         experienceSummary: experienceSummary,
         skills: skills,
         referencePerson: referencePerson,
         referencePhone: referencePhone,
         applicationDate: applicationDate,
         status: status,
         interviewNotes: interviewNotes,
         expectedSalary: expectedSalary,
         hasCvAttached: hasCvAttached,
         hasIdentityCardCopy: hasIdentityCardCopy,
         cvUrl: cvUrl,
         discardReason: discardReason,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhApplicant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhApplicant copyWith({
    Object? id = _Undefined,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    Object? email = _Undefined,
    Object? address = _Undefined,
    Object? birthDate = _Undefined,
    Object? emergencyContact = _Undefined,
    Object? emergencyPhone = _Undefined,
    Object? targetArea = _Undefined,
    Object? areaId = _Undefined,
    Object? targetPosition = _Undefined,
    Object? positionId = _Undefined,
    String? targetType,
    Object? specialty = _Undefined,
    Object? specialtyId = _Undefined,
    Object? education = _Undefined,
    Object? experienceSummary = _Undefined,
    Object? skills = _Undefined,
    Object? referencePerson = _Undefined,
    Object? referencePhone = _Undefined,
    DateTime? applicationDate,
    String? status,
    Object? interviewNotes = _Undefined,
    Object? expectedSalary = _Undefined,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    Object? cvUrl = _Undefined,
    Object? discardReason = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhApplicant(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      email: email is String? ? email : this.email,
      address: address is String? ? address : this.address,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      emergencyContact: emergencyContact is String?
          ? emergencyContact
          : this.emergencyContact,
      emergencyPhone: emergencyPhone is String?
          ? emergencyPhone
          : this.emergencyPhone,
      targetArea: targetArea is String? ? targetArea : this.targetArea,
      areaId: areaId is int? ? areaId : this.areaId,
      targetPosition: targetPosition is String?
          ? targetPosition
          : this.targetPosition,
      positionId: positionId is int? ? positionId : this.positionId,
      targetType: targetType ?? this.targetType,
      specialty: specialty is String? ? specialty : this.specialty,
      specialtyId: specialtyId is int? ? specialtyId : this.specialtyId,
      education: education is String? ? education : this.education,
      experienceSummary: experienceSummary is String?
          ? experienceSummary
          : this.experienceSummary,
      skills: skills is String? ? skills : this.skills,
      referencePerson: referencePerson is String?
          ? referencePerson
          : this.referencePerson,
      referencePhone: referencePhone is String?
          ? referencePhone
          : this.referencePhone,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      interviewNotes: interviewNotes is String?
          ? interviewNotes
          : this.interviewNotes,
      expectedSalary: expectedSalary is double?
          ? expectedSalary
          : this.expectedSalary,
      hasCvAttached: hasCvAttached ?? this.hasCvAttached,
      hasIdentityCardCopy: hasIdentityCardCopy ?? this.hasIdentityCardCopy,
      cvUrl: cvUrl is String? ? cvUrl : this.cvUrl,
      discardReason: discardReason is String?
          ? discardReason
          : this.discardReason,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhApplicantUpdateTable extends _i1.UpdateTable<RrhhApplicantTable> {
  RrhhApplicantUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> fullName(String value) => _i1.ColumnValue(
    table.fullName,
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

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> address(String? value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> birthDate(DateTime? value) =>
      _i1.ColumnValue(
        table.birthDate,
        value,
      );

  _i1.ColumnValue<String, String> emergencyContact(String? value) =>
      _i1.ColumnValue(
        table.emergencyContact,
        value,
      );

  _i1.ColumnValue<String, String> emergencyPhone(String? value) =>
      _i1.ColumnValue(
        table.emergencyPhone,
        value,
      );

  _i1.ColumnValue<String, String> targetArea(String? value) => _i1.ColumnValue(
    table.targetArea,
    value,
  );

  _i1.ColumnValue<int, int> areaId(int? value) => _i1.ColumnValue(
    table.areaId,
    value,
  );

  _i1.ColumnValue<String, String> targetPosition(String? value) =>
      _i1.ColumnValue(
        table.targetPosition,
        value,
      );

  _i1.ColumnValue<int, int> positionId(int? value) => _i1.ColumnValue(
    table.positionId,
    value,
  );

  _i1.ColumnValue<String, String> targetType(String value) => _i1.ColumnValue(
    table.targetType,
    value,
  );

  _i1.ColumnValue<String, String> specialty(String? value) => _i1.ColumnValue(
    table.specialty,
    value,
  );

  _i1.ColumnValue<int, int> specialtyId(int? value) => _i1.ColumnValue(
    table.specialtyId,
    value,
  );

  _i1.ColumnValue<String, String> education(String? value) => _i1.ColumnValue(
    table.education,
    value,
  );

  _i1.ColumnValue<String, String> experienceSummary(String? value) =>
      _i1.ColumnValue(
        table.experienceSummary,
        value,
      );

  _i1.ColumnValue<String, String> skills(String? value) => _i1.ColumnValue(
    table.skills,
    value,
  );

  _i1.ColumnValue<String, String> referencePerson(String? value) =>
      _i1.ColumnValue(
        table.referencePerson,
        value,
      );

  _i1.ColumnValue<String, String> referencePhone(String? value) =>
      _i1.ColumnValue(
        table.referencePhone,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> applicationDate(DateTime value) =>
      _i1.ColumnValue(
        table.applicationDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> interviewNotes(String? value) =>
      _i1.ColumnValue(
        table.interviewNotes,
        value,
      );

  _i1.ColumnValue<double, double> expectedSalary(double? value) =>
      _i1.ColumnValue(
        table.expectedSalary,
        value,
      );

  _i1.ColumnValue<bool, bool> hasCvAttached(bool value) => _i1.ColumnValue(
    table.hasCvAttached,
    value,
  );

  _i1.ColumnValue<bool, bool> hasIdentityCardCopy(bool value) =>
      _i1.ColumnValue(
        table.hasIdentityCardCopy,
        value,
      );

  _i1.ColumnValue<String, String> cvUrl(String? value) => _i1.ColumnValue(
    table.cvUrl,
    value,
  );

  _i1.ColumnValue<String, String> discardReason(String? value) =>
      _i1.ColumnValue(
        table.discardReason,
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

class RrhhApplicantTable extends _i1.Table<int?> {
  RrhhApplicantTable({super.tableRelation})
    : super(tableName: 'rrhh_applicant') {
    updateTable = RrhhApplicantUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
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
    email = _i1.ColumnString(
      'email',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    birthDate = _i1.ColumnDateTime(
      'birthDate',
      this,
    );
    emergencyContact = _i1.ColumnString(
      'emergencyContact',
      this,
    );
    emergencyPhone = _i1.ColumnString(
      'emergencyPhone',
      this,
    );
    targetArea = _i1.ColumnString(
      'targetArea',
      this,
    );
    areaId = _i1.ColumnInt(
      'areaId',
      this,
    );
    targetPosition = _i1.ColumnString(
      'targetPosition',
      this,
    );
    positionId = _i1.ColumnInt(
      'positionId',
      this,
    );
    targetType = _i1.ColumnString(
      'targetType',
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
    education = _i1.ColumnString(
      'education',
      this,
    );
    experienceSummary = _i1.ColumnString(
      'experienceSummary',
      this,
    );
    skills = _i1.ColumnString(
      'skills',
      this,
    );
    referencePerson = _i1.ColumnString(
      'referencePerson',
      this,
    );
    referencePhone = _i1.ColumnString(
      'referencePhone',
      this,
    );
    applicationDate = _i1.ColumnDateTime(
      'applicationDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    interviewNotes = _i1.ColumnString(
      'interviewNotes',
      this,
    );
    expectedSalary = _i1.ColumnDouble(
      'expectedSalary',
      this,
      hasDefault: true,
    );
    hasCvAttached = _i1.ColumnBool(
      'hasCvAttached',
      this,
      hasDefault: true,
    );
    hasIdentityCardCopy = _i1.ColumnBool(
      'hasIdentityCardCopy',
      this,
      hasDefault: true,
    );
    cvUrl = _i1.ColumnString(
      'cvUrl',
      this,
    );
    discardReason = _i1.ColumnString(
      'discardReason',
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

  late final RrhhApplicantUpdateTable updateTable;

  /// Código identificador del postulante (ej: POST-001).
  late final _i1.ColumnString code;

  /// Nombre completo del postulante.
  late final _i1.ColumnString fullName;

  /// Documento de identidad (CI).
  late final _i1.ColumnString identityCard;

  /// Teléfono o celular de contacto.
  late final _i1.ColumnString phone;

  /// Correo electrónico de contacto.
  late final _i1.ColumnString email;

  /// Dirección de domicilio.
  late final _i1.ColumnString address;

  /// Fecha de nacimiento.
  late final _i1.ColumnDateTime birthDate;

  /// Contacto de emergencia (nombre y parentesco).
  late final _i1.ColumnString emergencyContact;

  /// Teléfono del contacto de emergencia.
  late final _i1.ColumnString emergencyPhone;

  /// Área objetivo o departamento al que postula.
  late final _i1.ColumnString targetArea;

  late final _i1.ColumnInt areaId;

  /// Cargo objetivo al que aspira.
  late final _i1.ColumnString targetPosition;

  late final _i1.ColumnInt positionId;

  /// Tipo de entorno laboral deseado: 'OFICINA' o 'CAMPO'.
  late final _i1.ColumnString targetType;

  /// Especialidad técnica (ej: Jardinería, Limpieza, Climatización).
  late final _i1.ColumnString specialty;

  late final _i1.ColumnInt specialtyId;

  /// Nivel de formación o educación alcanzada.
  late final _i1.ColumnString education;

  /// Resumen de experiencia laboral previa.
  late final _i1.ColumnString experienceSummary;

  /// Habilidades técnicas y competencias.
  late final _i1.ColumnString skills;

  /// Persona de referencia laboral o personal.
  late final _i1.ColumnString referencePerson;

  /// Teléfono de la persona de referencia.
  late final _i1.ColumnString referencePhone;

  /// Fecha de postulación o recepción de hoja de vida.
  late final _i1.ColumnDateTime applicationDate;

  /// Estado en el embudo de selección: 'NUEVO', 'EN_EVALUACION', 'SELECCIONADO', 'RECHAZADO', 'CONTRATADO'.
  late final _i1.ColumnString status;

  /// Notas y observaciones de entrevista / evaluación.
  late final _i1.ColumnString interviewNotes;

  /// Pretensión salarial en Bolivianos (Bs.).
  late final _i1.ColumnDouble expectedSalary;

  /// Indicadores de documentación preliminar adjunta.
  late final _i1.ColumnBool hasCvAttached;

  late final _i1.ColumnBool hasIdentityCardCopy;

  /// Enlace a currículum digital si existe.
  late final _i1.ColumnString cvUrl;

  /// Motivo de descarte en caso de rechazo.
  late final _i1.ColumnString discardReason;

  /// Eliminación lógica y auditoría.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    fullName,
    identityCard,
    phone,
    email,
    address,
    birthDate,
    emergencyContact,
    emergencyPhone,
    targetArea,
    areaId,
    targetPosition,
    positionId,
    targetType,
    specialty,
    specialtyId,
    education,
    experienceSummary,
    skills,
    referencePerson,
    referencePhone,
    applicationDate,
    status,
    interviewNotes,
    expectedSalary,
    hasCvAttached,
    hasIdentityCardCopy,
    cvUrl,
    discardReason,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhApplicantInclude extends _i1.IncludeObject {
  RrhhApplicantInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhApplicant.t;
}

class RrhhApplicantIncludeList extends _i1.IncludeList {
  RrhhApplicantIncludeList._({
    _i1.WhereExpressionBuilder<RrhhApplicantTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhApplicant.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhApplicant.t;
}

class RrhhApplicantRepository {
  const RrhhApplicantRepository._();

  /// Returns a list of [RrhhApplicant]s matching the given query parameters.
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
  Future<List<RrhhApplicant>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhApplicantTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhApplicantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhApplicantTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhApplicant>(
      where: where?.call(RrhhApplicant.t),
      orderBy: orderBy?.call(RrhhApplicant.t),
      orderByList: orderByList?.call(RrhhApplicant.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhApplicant] matching the given query parameters.
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
  Future<RrhhApplicant?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhApplicantTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhApplicantTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhApplicantTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhApplicant>(
      where: where?.call(RrhhApplicant.t),
      orderBy: orderBy?.call(RrhhApplicant.t),
      orderByList: orderByList?.call(RrhhApplicant.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhApplicant] by its [id] or null if no such row exists.
  Future<RrhhApplicant?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhApplicant>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhApplicant]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhApplicant]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhApplicant>> insert(
    _i1.DatabaseSession session,
    List<RrhhApplicant> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhApplicant>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhApplicant] and returns the inserted row.
  ///
  /// The returned [RrhhApplicant] will have its `id` field set.
  Future<RrhhApplicant> insertRow(
    _i1.DatabaseSession session,
    RrhhApplicant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhApplicant>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhApplicant]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhApplicant>> update(
    _i1.DatabaseSession session,
    List<RrhhApplicant> rows, {
    _i1.ColumnSelections<RrhhApplicantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhApplicant>(
      rows,
      columns: columns?.call(RrhhApplicant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhApplicant]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhApplicant> updateRow(
    _i1.DatabaseSession session,
    RrhhApplicant row, {
    _i1.ColumnSelections<RrhhApplicantTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhApplicant>(
      row,
      columns: columns?.call(RrhhApplicant.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhApplicant] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhApplicant?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhApplicantUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhApplicant>(
      id,
      columnValues: columnValues(RrhhApplicant.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhApplicant]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhApplicant>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhApplicantUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhApplicantTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhApplicantTable>? orderBy,
    _i1.OrderByListBuilder<RrhhApplicantTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhApplicant>(
      columnValues: columnValues(RrhhApplicant.t.updateTable),
      where: where(RrhhApplicant.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhApplicant.t),
      orderByList: orderByList?.call(RrhhApplicant.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhApplicant]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhApplicant>> delete(
    _i1.DatabaseSession session,
    List<RrhhApplicant> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhApplicant>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhApplicant].
  Future<RrhhApplicant> deleteRow(
    _i1.DatabaseSession session,
    RrhhApplicant row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhApplicant>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhApplicant>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhApplicantTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhApplicant>(
      where: where(RrhhApplicant.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhApplicantTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhApplicant>(
      where: where?.call(RrhhApplicant.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhApplicant] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhApplicantTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhApplicant>(
      where: where(RrhhApplicant.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
