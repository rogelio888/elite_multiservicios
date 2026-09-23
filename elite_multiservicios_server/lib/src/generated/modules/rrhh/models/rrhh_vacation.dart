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

/// Control y registro de vacaciones del colaborador conforme a Ley Laboral.
abstract class RrhhVacation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhVacation._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.periodYear,
    required this.startDate,
    required this.endDate,
    required this.daysRequested,
    required this.totalAccruedDays,
    required this.remainingBalanceDays,
    String? status,
    this.approvedByUserId,
    this.approvedAt,
    this.notes,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'SOLICITADA',
       isDeleted = isDeleted ?? false;

  factory RrhhVacation({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    required int totalAccruedDays,
    required int remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhVacationImpl;

  factory RrhhVacation.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhVacation(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      periodYear: jsonSerialization['periodYear'] as int,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      daysRequested: jsonSerialization['daysRequested'] as int,
      totalAccruedDays: jsonSerialization['totalAccruedDays'] as int,
      remainingBalanceDays: jsonSerialization['remainingBalanceDays'] as int,
      status: jsonSerialization['status'] as String?,
      approvedByUserId: jsonSerialization['approvedByUserId'] as int?,
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
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

  static final t = RrhhVacationTable();

  static const db = RrhhVacationRepository._();

  @override
  int? id;

  /// Código de solicitud de vacación (ej: VAC-2026-001)
  String code;

  /// Colaborador solicitante
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Período y vigencia
  int periodYear;

  DateTime startDate;

  DateTime endDate;

  int daysRequested;

  /// Saldo computado a la fecha de solicitud
  int totalAccruedDays;

  int remainingBalanceDays;

  /// Estado: 'SOLICITADA', 'APROBADA', 'EN_CURSO', 'COMPLETADA', 'RECHAZADA'
  String status;

  /// Aprobación
  int? approvedByUserId;

  DateTime? approvedAt;

  String? notes;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhVacation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhVacation copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    int? periodYear,
    DateTime? startDate,
    DateTime? endDate,
    int? daysRequested,
    int? totalAccruedDays,
    int? remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhVacation',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'periodYear': periodYear,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysRequested': daysRequested,
      'totalAccruedDays': totalAccruedDays,
      'remainingBalanceDays': remainingBalanceDays,
      'status': status,
      if (approvedByUserId != null) 'approvedByUserId': approvedByUserId,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
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
      '__className__': 'RrhhVacation',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'periodYear': periodYear,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysRequested': daysRequested,
      'totalAccruedDays': totalAccruedDays,
      'remainingBalanceDays': remainingBalanceDays,
      'status': status,
      if (approvedByUserId != null) 'approvedByUserId': approvedByUserId,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhVacationInclude include() {
    return RrhhVacationInclude._();
  }

  static RrhhVacationIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhVacationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhVacationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhVacationTable>? orderByList,
    RrhhVacationInclude? include,
  }) {
    return RrhhVacationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhVacation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhVacation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhVacationImpl extends RrhhVacation {
  _RrhhVacationImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    required int totalAccruedDays,
    required int remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
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
         periodYear: periodYear,
         startDate: startDate,
         endDate: endDate,
         daysRequested: daysRequested,
         totalAccruedDays: totalAccruedDays,
         remainingBalanceDays: remainingBalanceDays,
         status: status,
         approvedByUserId: approvedByUserId,
         approvedAt: approvedAt,
         notes: notes,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhVacation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhVacation copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    int? periodYear,
    DateTime? startDate,
    DateTime? endDate,
    int? daysRequested,
    int? totalAccruedDays,
    int? remainingBalanceDays,
    String? status,
    Object? approvedByUserId = _Undefined,
    Object? approvedAt = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhVacation(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      periodYear: periodYear ?? this.periodYear,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysRequested: daysRequested ?? this.daysRequested,
      totalAccruedDays: totalAccruedDays ?? this.totalAccruedDays,
      remainingBalanceDays: remainingBalanceDays ?? this.remainingBalanceDays,
      status: status ?? this.status,
      approvedByUserId: approvedByUserId is int?
          ? approvedByUserId
          : this.approvedByUserId,
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhVacationUpdateTable extends _i1.UpdateTable<RrhhVacationTable> {
  RrhhVacationUpdateTable(super.table);

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

  _i1.ColumnValue<int, int> periodYear(int value) => _i1.ColumnValue(
    table.periodYear,
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

  _i1.ColumnValue<int, int> daysRequested(int value) => _i1.ColumnValue(
    table.daysRequested,
    value,
  );

  _i1.ColumnValue<int, int> totalAccruedDays(int value) => _i1.ColumnValue(
    table.totalAccruedDays,
    value,
  );

  _i1.ColumnValue<int, int> remainingBalanceDays(int value) => _i1.ColumnValue(
    table.remainingBalanceDays,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> approvedByUserId(int? value) => _i1.ColumnValue(
    table.approvedByUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> approvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.approvedAt,
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

class RrhhVacationTable extends _i1.Table<int?> {
  RrhhVacationTable({super.tableRelation}) : super(tableName: 'rrhh_vacation') {
    updateTable = RrhhVacationUpdateTable(this);
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
    periodYear = _i1.ColumnInt(
      'periodYear',
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
    daysRequested = _i1.ColumnInt(
      'daysRequested',
      this,
    );
    totalAccruedDays = _i1.ColumnInt(
      'totalAccruedDays',
      this,
    );
    remainingBalanceDays = _i1.ColumnInt(
      'remainingBalanceDays',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    approvedByUserId = _i1.ColumnInt(
      'approvedByUserId',
      this,
    );
    approvedAt = _i1.ColumnDateTime(
      'approvedAt',
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

  late final RrhhVacationUpdateTable updateTable;

  /// Código de solicitud de vacación (ej: VAC-2026-001)
  late final _i1.ColumnString code;

  /// Colaborador solicitante
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  /// Período y vigencia
  late final _i1.ColumnInt periodYear;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnInt daysRequested;

  /// Saldo computado a la fecha de solicitud
  late final _i1.ColumnInt totalAccruedDays;

  late final _i1.ColumnInt remainingBalanceDays;

  /// Estado: 'SOLICITADA', 'APROBADA', 'EN_CURSO', 'COMPLETADA', 'RECHAZADA'
  late final _i1.ColumnString status;

  /// Aprobación
  late final _i1.ColumnInt approvedByUserId;

  late final _i1.ColumnDateTime approvedAt;

  late final _i1.ColumnString notes;

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
    periodYear,
    startDate,
    endDate,
    daysRequested,
    totalAccruedDays,
    remainingBalanceDays,
    status,
    approvedByUserId,
    approvedAt,
    notes,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhVacationInclude extends _i1.IncludeObject {
  RrhhVacationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhVacation.t;
}

class RrhhVacationIncludeList extends _i1.IncludeList {
  RrhhVacationIncludeList._({
    _i1.WhereExpressionBuilder<RrhhVacationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhVacation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhVacation.t;
}

class RrhhVacationRepository {
  const RrhhVacationRepository._();

  /// Returns a list of [RrhhVacation]s matching the given query parameters.
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
  Future<List<RrhhVacation>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhVacationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhVacationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhVacationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhVacation>(
      where: where?.call(RrhhVacation.t),
      orderBy: orderBy?.call(RrhhVacation.t),
      orderByList: orderByList?.call(RrhhVacation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhVacation] matching the given query parameters.
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
  Future<RrhhVacation?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhVacationTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhVacationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhVacationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhVacation>(
      where: where?.call(RrhhVacation.t),
      orderBy: orderBy?.call(RrhhVacation.t),
      orderByList: orderByList?.call(RrhhVacation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhVacation] by its [id] or null if no such row exists.
  Future<RrhhVacation?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhVacation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhVacation]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhVacation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhVacation>> insert(
    _i1.DatabaseSession session,
    List<RrhhVacation> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhVacation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhVacation] and returns the inserted row.
  ///
  /// The returned [RrhhVacation] will have its `id` field set.
  Future<RrhhVacation> insertRow(
    _i1.DatabaseSession session,
    RrhhVacation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhVacation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhVacation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhVacation>> update(
    _i1.DatabaseSession session,
    List<RrhhVacation> rows, {
    _i1.ColumnSelections<RrhhVacationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhVacation>(
      rows,
      columns: columns?.call(RrhhVacation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhVacation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhVacation> updateRow(
    _i1.DatabaseSession session,
    RrhhVacation row, {
    _i1.ColumnSelections<RrhhVacationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhVacation>(
      row,
      columns: columns?.call(RrhhVacation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhVacation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhVacation?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhVacationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhVacation>(
      id,
      columnValues: columnValues(RrhhVacation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhVacation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhVacation>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhVacationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhVacationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhVacationTable>? orderBy,
    _i1.OrderByListBuilder<RrhhVacationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhVacation>(
      columnValues: columnValues(RrhhVacation.t.updateTable),
      where: where(RrhhVacation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhVacation.t),
      orderByList: orderByList?.call(RrhhVacation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhVacation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhVacation>> delete(
    _i1.DatabaseSession session,
    List<RrhhVacation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhVacation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhVacation].
  Future<RrhhVacation> deleteRow(
    _i1.DatabaseSession session,
    RrhhVacation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhVacation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhVacation>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhVacationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhVacation>(
      where: where(RrhhVacation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhVacationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhVacation>(
      where: where?.call(RrhhVacation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhVacation] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhVacationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhVacation>(
      where: where(RrhhVacation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
