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

/// Solicitudes y licencias de personal (médicas, personales, duelo, maternidad/paternidad).
abstract class RrhhLeaveRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhLeaveRequest._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.hoursCount,
    required this.reason,
    this.medicalCertificateNumber,
    this.attachmentUrl,
    String? status,
    this.resolutionNotes,
    this.resolvedByUserId,
    this.resolvedAt,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'PENDIENTE',
       isDeleted = isDeleted ?? false;

  factory RrhhLeaveRequest({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhLeaveRequestImpl;

  factory RrhhLeaveRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhLeaveRequest(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      leaveType: jsonSerialization['leaveType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      daysCount: jsonSerialization['daysCount'] as int,
      hoursCount: (jsonSerialization['hoursCount'] as num?)?.toDouble(),
      reason: jsonSerialization['reason'] as String,
      medicalCertificateNumber:
          jsonSerialization['medicalCertificateNumber'] as String?,
      attachmentUrl: jsonSerialization['attachmentUrl'] as String?,
      status: jsonSerialization['status'] as String?,
      resolutionNotes: jsonSerialization['resolutionNotes'] as String?,
      resolvedByUserId: jsonSerialization['resolvedByUserId'] as int?,
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
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

  static final t = RrhhLeaveRequestTable();

  static const db = RrhhLeaveRequestRepository._();

  @override
  int? id;

  /// Código único de solicitud (ej: LIC-2026-001)
  String code;

  /// Colaborador solicitante
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo de licencia: 'MEDICA', 'PERSONAL', 'DUELO', 'MATERNIDAD_PATERNIDAD', 'ESTUDIO', 'OTRO'
  String leaveType;

  /// Fechas de inicio y fin
  DateTime startDate;

  DateTime endDate;

  int daysCount;

  double? hoursCount;

  /// Motivo detallado
  String reason;

  /// Respaldo médico / institucional
  String? medicalCertificateNumber;

  String? attachmentUrl;

  /// Estado: 'PENDIENTE', 'APROBADO', 'RECHAZADO', 'CANCELADO'
  String status;

  /// Resolución y auditoría administrativa
  String? resolutionNotes;

  int? resolvedByUserId;

  DateTime? resolvedAt;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhLeaveRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhLeaveRequest copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    double? hoursCount,
    String? reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhLeaveRequest',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'leaveType': leaveType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysCount': daysCount,
      if (hoursCount != null) 'hoursCount': hoursCount,
      'reason': reason,
      if (medicalCertificateNumber != null)
        'medicalCertificateNumber': medicalCertificateNumber,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      'status': status,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (resolvedByUserId != null) 'resolvedByUserId': resolvedByUserId,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhLeaveRequest',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'leaveType': leaveType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysCount': daysCount,
      if (hoursCount != null) 'hoursCount': hoursCount,
      'reason': reason,
      if (medicalCertificateNumber != null)
        'medicalCertificateNumber': medicalCertificateNumber,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      'status': status,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (resolvedByUserId != null) 'resolvedByUserId': resolvedByUserId,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhLeaveRequestInclude include() {
    return RrhhLeaveRequestInclude._();
  }

  static RrhhLeaveRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhLeaveRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhLeaveRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhLeaveRequestTable>? orderByList,
    RrhhLeaveRequestInclude? include,
  }) {
    return RrhhLeaveRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhLeaveRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhLeaveRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhLeaveRequestImpl extends RrhhLeaveRequest {
  _RrhhLeaveRequestImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
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
         leaveType: leaveType,
         startDate: startDate,
         endDate: endDate,
         daysCount: daysCount,
         hoursCount: hoursCount,
         reason: reason,
         medicalCertificateNumber: medicalCertificateNumber,
         attachmentUrl: attachmentUrl,
         status: status,
         resolutionNotes: resolutionNotes,
         resolvedByUserId: resolvedByUserId,
         resolvedAt: resolvedAt,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhLeaveRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhLeaveRequest copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    Object? hoursCount = _Undefined,
    String? reason,
    Object? medicalCertificateNumber = _Undefined,
    Object? attachmentUrl = _Undefined,
    String? status,
    Object? resolutionNotes = _Undefined,
    Object? resolvedByUserId = _Undefined,
    Object? resolvedAt = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhLeaveRequest(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      hoursCount: hoursCount is double? ? hoursCount : this.hoursCount,
      reason: reason ?? this.reason,
      medicalCertificateNumber: medicalCertificateNumber is String?
          ? medicalCertificateNumber
          : this.medicalCertificateNumber,
      attachmentUrl: attachmentUrl is String?
          ? attachmentUrl
          : this.attachmentUrl,
      status: status ?? this.status,
      resolutionNotes: resolutionNotes is String?
          ? resolutionNotes
          : this.resolutionNotes,
      resolvedByUserId: resolvedByUserId is int?
          ? resolvedByUserId
          : this.resolvedByUserId,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhLeaveRequestUpdateTable
    extends _i1.UpdateTable<RrhhLeaveRequestTable> {
  RrhhLeaveRequestUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> leaveType(String value) => _i1.ColumnValue(
    table.leaveType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<int, int> daysCount(int value) => _i1.ColumnValue(
    table.daysCount,
    value,
  );

  _i1.ColumnValue<double, double> hoursCount(double? value) => _i1.ColumnValue(
    table.hoursCount,
    value,
  );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> medicalCertificateNumber(String? value) =>
      _i1.ColumnValue(
        table.medicalCertificateNumber,
        value,
      );

  _i1.ColumnValue<String, String> attachmentUrl(String? value) =>
      _i1.ColumnValue(
        table.attachmentUrl,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> resolutionNotes(String? value) =>
      _i1.ColumnValue(
        table.resolutionNotes,
        value,
      );

  _i1.ColumnValue<int, int> resolvedByUserId(int? value) => _i1.ColumnValue(
    table.resolvedByUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.resolvedAt,
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

class RrhhLeaveRequestTable extends _i1.Table<int?> {
  RrhhLeaveRequestTable({super.tableRelation})
    : super(tableName: 'rrhh_leave_request') {
    updateTable = RrhhLeaveRequestUpdateTable(this);
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
    leaveType = _i1.ColumnString(
      'leaveType',
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
    daysCount = _i1.ColumnInt(
      'daysCount',
      this,
    );
    hoursCount = _i1.ColumnDouble(
      'hoursCount',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    medicalCertificateNumber = _i1.ColumnString(
      'medicalCertificateNumber',
      this,
    );
    attachmentUrl = _i1.ColumnString(
      'attachmentUrl',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    resolutionNotes = _i1.ColumnString(
      'resolutionNotes',
      this,
    );
    resolvedByUserId = _i1.ColumnInt(
      'resolvedByUserId',
      this,
    );
    resolvedAt = _i1.ColumnDateTime(
      'resolvedAt',
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

  late final RrhhLeaveRequestUpdateTable updateTable;

  /// Código único de solicitud (ej: LIC-2026-001)
  late final _i1.ColumnString code;

  /// Colaborador solicitante
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  /// Tipo de licencia: 'MEDICA', 'PERSONAL', 'DUELO', 'MATERNIDAD_PATERNIDAD', 'ESTUDIO', 'OTRO'
  late final _i1.ColumnString leaveType;

  /// Fechas de inicio y fin
  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnInt daysCount;

  late final _i1.ColumnDouble hoursCount;

  /// Motivo detallado
  late final _i1.ColumnString reason;

  /// Respaldo médico / institucional
  late final _i1.ColumnString medicalCertificateNumber;

  late final _i1.ColumnString attachmentUrl;

  /// Estado: 'PENDIENTE', 'APROBADO', 'RECHAZADO', 'CANCELADO'
  late final _i1.ColumnString status;

  /// Resolución y auditoría administrativa
  late final _i1.ColumnString resolutionNotes;

  late final _i1.ColumnInt resolvedByUserId;

  late final _i1.ColumnDateTime resolvedAt;

  /// Eliminación lógica y fechas
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
    leaveType,
    startDate,
    endDate,
    daysCount,
    hoursCount,
    reason,
    medicalCertificateNumber,
    attachmentUrl,
    status,
    resolutionNotes,
    resolvedByUserId,
    resolvedAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhLeaveRequestInclude extends _i1.IncludeObject {
  RrhhLeaveRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhLeaveRequest.t;
}

class RrhhLeaveRequestIncludeList extends _i1.IncludeList {
  RrhhLeaveRequestIncludeList._({
    _i1.WhereExpressionBuilder<RrhhLeaveRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhLeaveRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhLeaveRequest.t;
}

class RrhhLeaveRequestRepository {
  const RrhhLeaveRequestRepository._();

  /// Returns a list of [RrhhLeaveRequest]s matching the given query parameters.
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
  Future<List<RrhhLeaveRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhLeaveRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhLeaveRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhLeaveRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhLeaveRequest>(
      where: where?.call(RrhhLeaveRequest.t),
      orderBy: orderBy?.call(RrhhLeaveRequest.t),
      orderByList: orderByList?.call(RrhhLeaveRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhLeaveRequest] matching the given query parameters.
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
  Future<RrhhLeaveRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhLeaveRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhLeaveRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhLeaveRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhLeaveRequest>(
      where: where?.call(RrhhLeaveRequest.t),
      orderBy: orderBy?.call(RrhhLeaveRequest.t),
      orderByList: orderByList?.call(RrhhLeaveRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhLeaveRequest] by its [id] or null if no such row exists.
  Future<RrhhLeaveRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhLeaveRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhLeaveRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhLeaveRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhLeaveRequest>> insert(
    _i1.DatabaseSession session,
    List<RrhhLeaveRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhLeaveRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhLeaveRequest] and returns the inserted row.
  ///
  /// The returned [RrhhLeaveRequest] will have its `id` field set.
  Future<RrhhLeaveRequest> insertRow(
    _i1.DatabaseSession session,
    RrhhLeaveRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhLeaveRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhLeaveRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhLeaveRequest>> update(
    _i1.DatabaseSession session,
    List<RrhhLeaveRequest> rows, {
    _i1.ColumnSelections<RrhhLeaveRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhLeaveRequest>(
      rows,
      columns: columns?.call(RrhhLeaveRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhLeaveRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhLeaveRequest> updateRow(
    _i1.DatabaseSession session,
    RrhhLeaveRequest row, {
    _i1.ColumnSelections<RrhhLeaveRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhLeaveRequest>(
      row,
      columns: columns?.call(RrhhLeaveRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhLeaveRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhLeaveRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhLeaveRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhLeaveRequest>(
      id,
      columnValues: columnValues(RrhhLeaveRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhLeaveRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhLeaveRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhLeaveRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhLeaveRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhLeaveRequestTable>? orderBy,
    _i1.OrderByListBuilder<RrhhLeaveRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhLeaveRequest>(
      columnValues: columnValues(RrhhLeaveRequest.t.updateTable),
      where: where(RrhhLeaveRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhLeaveRequest.t),
      orderByList: orderByList?.call(RrhhLeaveRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhLeaveRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhLeaveRequest>> delete(
    _i1.DatabaseSession session,
    List<RrhhLeaveRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhLeaveRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhLeaveRequest].
  Future<RrhhLeaveRequest> deleteRow(
    _i1.DatabaseSession session,
    RrhhLeaveRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhLeaveRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhLeaveRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhLeaveRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhLeaveRequest>(
      where: where(RrhhLeaveRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhLeaveRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhLeaveRequest>(
      where: where?.call(RrhhLeaveRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhLeaveRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhLeaveRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhLeaveRequest>(
      where: where(RrhhLeaveRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
