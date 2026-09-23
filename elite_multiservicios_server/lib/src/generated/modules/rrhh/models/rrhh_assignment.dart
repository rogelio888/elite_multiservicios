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

/// Asignación de Personal a Sede de Cliente (Campo) o Área Corporativa (Oficina).
abstract class RrhhAssignment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhAssignment._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.assignmentType,
    this.officeAreaId,
    this.officeAreaName,
    this.officeRole,
    this.customerId,
    this.customerCompanyName,
    this.workplaceBranch,
    this.contractedServiceName,
    required this.supervisorName,
    this.supervisorEmployeeId,
    required this.scheduleId,
    required this.scheduleName,
    required this.startDate,
    this.endDate,
    String? status,
    int? rotationNumber,
    this.originDescription,
    this.rotationReason,
    this.notes,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'ACTIVA',
       rotationNumber = rotationNumber ?? 0,
       isDeleted = isDeleted ?? false;

  factory RrhhAssignment({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    required String supervisorName,
    int? supervisorEmployeeId,
    required int scheduleId,
    required String scheduleName,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhAssignmentImpl;

  factory RrhhAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhAssignment(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      assignmentType: jsonSerialization['assignmentType'] as String,
      officeAreaId: jsonSerialization['officeAreaId'] as int?,
      officeAreaName: jsonSerialization['officeAreaName'] as String?,
      officeRole: jsonSerialization['officeRole'] as String?,
      customerId: jsonSerialization['customerId'] as int?,
      customerCompanyName: jsonSerialization['customerCompanyName'] as String?,
      workplaceBranch: jsonSerialization['workplaceBranch'] as String?,
      contractedServiceName:
          jsonSerialization['contractedServiceName'] as String?,
      supervisorName: jsonSerialization['supervisorName'] as String,
      supervisorEmployeeId: jsonSerialization['supervisorEmployeeId'] as int?,
      scheduleId: jsonSerialization['scheduleId'] as int,
      scheduleName: jsonSerialization['scheduleName'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      rotationNumber: jsonSerialization['rotationNumber'] as int?,
      originDescription: jsonSerialization['originDescription'] as String?,
      rotationReason: jsonSerialization['rotationReason'] as String?,
      notes: jsonSerialization['notes'] as String?,
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

  static final t = RrhhAssignmentTable();

  static const db = RrhhAssignmentRepository._();

  @override
  int? id;

  /// Código institucional de la asignación (ej: ASG-001).
  String code;

  /// Colaborador asignado
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Modalidad de la asignación: 'OFICINA' o 'CAMPO'
  String assignmentType;

  /// Modalidad Oficina: Área y Rol Interno
  int? officeAreaId;

  String? officeAreaName;

  String? officeRole;

  /// Modalidad Campo: Referencias a CRM y Sedes de Clientes
  int? customerId;

  String? customerCompanyName;

  String? workplaceBranch;

  String? contractedServiceName;

  /// Supervisión y Turno
  String supervisorName;

  int? supervisorEmployeeId;

  int scheduleId;

  String scheduleName;

  /// Fechas y Vigencia
  DateTime startDate;

  DateTime? endDate;

  /// Estado de la asignación: 'ACTIVA', 'FINALIZADA', 'CANCELADA'
  String status;

  /// Rotación Histórica Inmutable (Prohibido sobreescribir)
  /// Número de rotación (0 = Puesto Inicial, 1 = Rotación #1, etc.)
  int rotationNumber;

  /// Descripción del destino anterior antes de rotar
  String? originDescription;

  /// Motivo o justificación de la rotación
  String? rotationReason;

  String? notes;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhAssignment copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    String? supervisorName,
    int? supervisorEmployeeId,
    int? scheduleId,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhAssignment',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'assignmentType': assignmentType,
      if (officeAreaId != null) 'officeAreaId': officeAreaId,
      if (officeAreaName != null) 'officeAreaName': officeAreaName,
      if (officeRole != null) 'officeRole': officeRole,
      if (customerId != null) 'customerId': customerId,
      if (customerCompanyName != null)
        'customerCompanyName': customerCompanyName,
      if (workplaceBranch != null) 'workplaceBranch': workplaceBranch,
      if (contractedServiceName != null)
        'contractedServiceName': contractedServiceName,
      'supervisorName': supervisorName,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      'scheduleId': scheduleId,
      'scheduleName': scheduleName,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'rotationNumber': rotationNumber,
      if (originDescription != null) 'originDescription': originDescription,
      if (rotationReason != null) 'rotationReason': rotationReason,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhAssignment',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'assignmentType': assignmentType,
      if (officeAreaId != null) 'officeAreaId': officeAreaId,
      if (officeAreaName != null) 'officeAreaName': officeAreaName,
      if (officeRole != null) 'officeRole': officeRole,
      if (customerId != null) 'customerId': customerId,
      if (customerCompanyName != null)
        'customerCompanyName': customerCompanyName,
      if (workplaceBranch != null) 'workplaceBranch': workplaceBranch,
      if (contractedServiceName != null)
        'contractedServiceName': contractedServiceName,
      'supervisorName': supervisorName,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      'scheduleId': scheduleId,
      'scheduleName': scheduleName,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'rotationNumber': rotationNumber,
      if (originDescription != null) 'originDescription': originDescription,
      if (rotationReason != null) 'rotationReason': rotationReason,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhAssignmentInclude include() {
    return RrhhAssignmentInclude._();
  }

  static RrhhAssignmentIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhAssignmentTable>? orderByList,
    RrhhAssignmentInclude? include,
  }) {
    return RrhhAssignmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhAssignment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhAssignment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhAssignmentImpl extends RrhhAssignment {
  _RrhhAssignmentImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    required String supervisorName,
    int? supervisorEmployeeId,
    required int scheduleId,
    required String scheduleName,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         assignmentType: assignmentType,
         officeAreaId: officeAreaId,
         officeAreaName: officeAreaName,
         officeRole: officeRole,
         customerId: customerId,
         customerCompanyName: customerCompanyName,
         workplaceBranch: workplaceBranch,
         contractedServiceName: contractedServiceName,
         supervisorName: supervisorName,
         supervisorEmployeeId: supervisorEmployeeId,
         scheduleId: scheduleId,
         scheduleName: scheduleName,
         startDate: startDate,
         endDate: endDate,
         status: status,
         rotationNumber: rotationNumber,
         originDescription: originDescription,
         rotationReason: rotationReason,
         notes: notes,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhAssignment copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? assignmentType,
    Object? officeAreaId = _Undefined,
    Object? officeAreaName = _Undefined,
    Object? officeRole = _Undefined,
    Object? customerId = _Undefined,
    Object? customerCompanyName = _Undefined,
    Object? workplaceBranch = _Undefined,
    Object? contractedServiceName = _Undefined,
    String? supervisorName,
    Object? supervisorEmployeeId = _Undefined,
    int? scheduleId,
    String? scheduleName,
    DateTime? startDate,
    Object? endDate = _Undefined,
    String? status,
    int? rotationNumber,
    Object? originDescription = _Undefined,
    Object? rotationReason = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhAssignment(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      assignmentType: assignmentType ?? this.assignmentType,
      officeAreaId: officeAreaId is int? ? officeAreaId : this.officeAreaId,
      officeAreaName: officeAreaName is String?
          ? officeAreaName
          : this.officeAreaName,
      officeRole: officeRole is String? ? officeRole : this.officeRole,
      customerId: customerId is int? ? customerId : this.customerId,
      customerCompanyName: customerCompanyName is String?
          ? customerCompanyName
          : this.customerCompanyName,
      workplaceBranch: workplaceBranch is String?
          ? workplaceBranch
          : this.workplaceBranch,
      contractedServiceName: contractedServiceName is String?
          ? contractedServiceName
          : this.contractedServiceName,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorEmployeeId: supervisorEmployeeId is int?
          ? supervisorEmployeeId
          : this.supervisorEmployeeId,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      status: status ?? this.status,
      rotationNumber: rotationNumber ?? this.rotationNumber,
      originDescription: originDescription is String?
          ? originDescription
          : this.originDescription,
      rotationReason: rotationReason is String?
          ? rotationReason
          : this.rotationReason,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhAssignmentUpdateTable extends _i1.UpdateTable<RrhhAssignmentTable> {
  RrhhAssignmentUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<String, String> employeeCode(String value) => _i1.ColumnValue(
    table.employeeCode,
    value,
  );

  _i1.ColumnValue<String, String> employeeName(String value) => _i1.ColumnValue(
    table.employeeName,
    value,
  );

  _i1.ColumnValue<String, String> assignmentType(String value) =>
      _i1.ColumnValue(
        table.assignmentType,
        value,
      );

  _i1.ColumnValue<int, int> officeAreaId(int? value) => _i1.ColumnValue(
    table.officeAreaId,
    value,
  );

  _i1.ColumnValue<String, String> officeAreaName(String? value) =>
      _i1.ColumnValue(
        table.officeAreaName,
        value,
      );

  _i1.ColumnValue<String, String> officeRole(String? value) => _i1.ColumnValue(
    table.officeRole,
    value,
  );

  _i1.ColumnValue<int, int> customerId(int? value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> customerCompanyName(String? value) =>
      _i1.ColumnValue(
        table.customerCompanyName,
        value,
      );

  _i1.ColumnValue<String, String> workplaceBranch(String? value) =>
      _i1.ColumnValue(
        table.workplaceBranch,
        value,
      );

  _i1.ColumnValue<String, String> contractedServiceName(String? value) =>
      _i1.ColumnValue(
        table.contractedServiceName,
        value,
      );

  _i1.ColumnValue<String, String> supervisorName(String value) =>
      _i1.ColumnValue(
        table.supervisorName,
        value,
      );

  _i1.ColumnValue<int, int> supervisorEmployeeId(int? value) => _i1.ColumnValue(
    table.supervisorEmployeeId,
    value,
  );

  _i1.ColumnValue<int, int> scheduleId(int value) => _i1.ColumnValue(
    table.scheduleId,
    value,
  );

  _i1.ColumnValue<String, String> scheduleName(String value) => _i1.ColumnValue(
    table.scheduleName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> rotationNumber(int value) => _i1.ColumnValue(
    table.rotationNumber,
    value,
  );

  _i1.ColumnValue<String, String> originDescription(String? value) =>
      _i1.ColumnValue(
        table.originDescription,
        value,
      );

  _i1.ColumnValue<String, String> rotationReason(String? value) =>
      _i1.ColumnValue(
        table.rotationReason,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
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

class RrhhAssignmentTable extends _i1.Table<int?> {
  RrhhAssignmentTable({super.tableRelation})
    : super(tableName: 'rrhh_assignment') {
    updateTable = RrhhAssignmentUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    employeeCode = _i1.ColumnString(
      'employeeCode',
      this,
    );
    employeeName = _i1.ColumnString(
      'employeeName',
      this,
    );
    assignmentType = _i1.ColumnString(
      'assignmentType',
      this,
    );
    officeAreaId = _i1.ColumnInt(
      'officeAreaId',
      this,
    );
    officeAreaName = _i1.ColumnString(
      'officeAreaName',
      this,
    );
    officeRole = _i1.ColumnString(
      'officeRole',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    customerCompanyName = _i1.ColumnString(
      'customerCompanyName',
      this,
    );
    workplaceBranch = _i1.ColumnString(
      'workplaceBranch',
      this,
    );
    contractedServiceName = _i1.ColumnString(
      'contractedServiceName',
      this,
    );
    supervisorName = _i1.ColumnString(
      'supervisorName',
      this,
    );
    supervisorEmployeeId = _i1.ColumnInt(
      'supervisorEmployeeId',
      this,
    );
    scheduleId = _i1.ColumnInt(
      'scheduleId',
      this,
    );
    scheduleName = _i1.ColumnString(
      'scheduleName',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    rotationNumber = _i1.ColumnInt(
      'rotationNumber',
      this,
      hasDefault: true,
    );
    originDescription = _i1.ColumnString(
      'originDescription',
      this,
    );
    rotationReason = _i1.ColumnString(
      'rotationReason',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
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

  late final RrhhAssignmentUpdateTable updateTable;

  /// Código institucional de la asignación (ej: ASG-001).
  late final _i1.ColumnString code;

  /// Colaborador asignado
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  /// Modalidad de la asignación: 'OFICINA' o 'CAMPO'
  late final _i1.ColumnString assignmentType;

  /// Modalidad Oficina: Área y Rol Interno
  late final _i1.ColumnInt officeAreaId;

  late final _i1.ColumnString officeAreaName;

  late final _i1.ColumnString officeRole;

  /// Modalidad Campo: Referencias a CRM y Sedes de Clientes
  late final _i1.ColumnInt customerId;

  late final _i1.ColumnString customerCompanyName;

  late final _i1.ColumnString workplaceBranch;

  late final _i1.ColumnString contractedServiceName;

  /// Supervisión y Turno
  late final _i1.ColumnString supervisorName;

  late final _i1.ColumnInt supervisorEmployeeId;

  late final _i1.ColumnInt scheduleId;

  late final _i1.ColumnString scheduleName;

  /// Fechas y Vigencia
  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  /// Estado de la asignación: 'ACTIVA', 'FINALIZADA', 'CANCELADA'
  late final _i1.ColumnString status;

  /// Rotación Histórica Inmutable (Prohibido sobreescribir)
  /// Número de rotación (0 = Puesto Inicial, 1 = Rotación #1, etc.)
  late final _i1.ColumnInt rotationNumber;

  /// Descripción del destino anterior antes de rotar
  late final _i1.ColumnString originDescription;

  /// Motivo o justificación de la rotación
  late final _i1.ColumnString rotationReason;

  late final _i1.ColumnString notes;

  /// Eliminación lógica y auditoría
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    employeeId,
    employeeCode,
    employeeName,
    assignmentType,
    officeAreaId,
    officeAreaName,
    officeRole,
    customerId,
    customerCompanyName,
    workplaceBranch,
    contractedServiceName,
    supervisorName,
    supervisorEmployeeId,
    scheduleId,
    scheduleName,
    startDate,
    endDate,
    status,
    rotationNumber,
    originDescription,
    rotationReason,
    notes,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhAssignmentInclude extends _i1.IncludeObject {
  RrhhAssignmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhAssignment.t;
}

class RrhhAssignmentIncludeList extends _i1.IncludeList {
  RrhhAssignmentIncludeList._({
    _i1.WhereExpressionBuilder<RrhhAssignmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhAssignment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhAssignment.t;
}

class RrhhAssignmentRepository {
  const RrhhAssignmentRepository._();

  /// Returns a list of [RrhhAssignment]s matching the given query parameters.
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
  Future<List<RrhhAssignment>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhAssignment>(
      where: where?.call(RrhhAssignment.t),
      orderBy: orderBy?.call(RrhhAssignment.t),
      orderByList: orderByList?.call(RrhhAssignment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhAssignment] matching the given query parameters.
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
  Future<RrhhAssignment?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhAssignmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhAssignment>(
      where: where?.call(RrhhAssignment.t),
      orderBy: orderBy?.call(RrhhAssignment.t),
      orderByList: orderByList?.call(RrhhAssignment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhAssignment] by its [id] or null if no such row exists.
  Future<RrhhAssignment?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhAssignment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhAssignment]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhAssignment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhAssignment>> insert(
    _i1.DatabaseSession session,
    List<RrhhAssignment> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhAssignment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhAssignment] and returns the inserted row.
  ///
  /// The returned [RrhhAssignment] will have its `id` field set.
  Future<RrhhAssignment> insertRow(
    _i1.DatabaseSession session,
    RrhhAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhAssignment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhAssignment>> update(
    _i1.DatabaseSession session,
    List<RrhhAssignment> rows, {
    _i1.ColumnSelections<RrhhAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhAssignment>(
      rows,
      columns: columns?.call(RrhhAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhAssignment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhAssignment> updateRow(
    _i1.DatabaseSession session,
    RrhhAssignment row, {
    _i1.ColumnSelections<RrhhAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhAssignment>(
      row,
      columns: columns?.call(RrhhAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhAssignment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhAssignment?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhAssignmentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhAssignment>(
      id,
      columnValues: columnValues(RrhhAssignment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhAssignment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhAssignment>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhAssignmentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhAssignmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhAssignmentTable>? orderBy,
    _i1.OrderByListBuilder<RrhhAssignmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhAssignment>(
      columnValues: columnValues(RrhhAssignment.t.updateTable),
      where: where(RrhhAssignment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhAssignment.t),
      orderByList: orderByList?.call(RrhhAssignment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhAssignment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhAssignment>> delete(
    _i1.DatabaseSession session,
    List<RrhhAssignment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhAssignment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhAssignment].
  Future<RrhhAssignment> deleteRow(
    _i1.DatabaseSession session,
    RrhhAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhAssignment>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhAssignmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhAssignment>(
      where: where(RrhhAssignment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhAssignmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhAssignment>(
      where: where?.call(RrhhAssignment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhAssignment] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhAssignmentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhAssignment>(
      where: where(RrhhAssignment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
