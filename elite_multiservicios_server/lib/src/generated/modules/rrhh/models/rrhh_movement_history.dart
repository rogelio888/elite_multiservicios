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

/// Bitácora inmutable de cambios y movimientos de personal.
abstract class RrhhMovementHistory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhMovementHistory._({
    this.id,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.movementType,
    this.previousValue,
    required this.newValue,
    required this.effectiveDate,
    required this.reason,
    required this.authorizedBy,
    required this.createdAt,
  });

  factory RrhhMovementHistory({
    int? id,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
    required DateTime createdAt,
  }) = _RrhhMovementHistoryImpl;

  factory RrhhMovementHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhMovementHistory(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      movementType: jsonSerialization['movementType'] as String,
      previousValue: jsonSerialization['previousValue'] as String?,
      newValue: jsonSerialization['newValue'] as String,
      effectiveDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['effectiveDate'],
      ),
      reason: jsonSerialization['reason'] as String,
      authorizedBy: jsonSerialization['authorizedBy'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RrhhMovementHistoryTable();

  static const db = RrhhMovementHistoryRepository._();

  @override
  int? id;

  /// Colaborador afectado
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo: 'INGRESO', 'ASCENSO', 'TRASLADO_AREA', 'ROTACION_SEDE', 'AJUSTE_SALARIAL', 'CAMBIO_TURNO', 'SUSPENSION', 'DESVINCULACION', 'REINCORPORACION'
  String movementType;

  /// Valores previos y nuevos
  String? previousValue;

  String newValue;

  /// Fecha efectiva y justificación
  DateTime effectiveDate;

  String reason;

  String authorizedBy;

  /// Auditoría inmutable
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhMovementHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhMovementHistory copyWith({
    int? id,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? movementType,
    String? previousValue,
    String? newValue,
    DateTime? effectiveDate,
    String? reason,
    String? authorizedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhMovementHistory',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'movementType': movementType,
      if (previousValue != null) 'previousValue': previousValue,
      'newValue': newValue,
      'effectiveDate': effectiveDate.toJson(),
      'reason': reason,
      'authorizedBy': authorizedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhMovementHistory',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'movementType': movementType,
      if (previousValue != null) 'previousValue': previousValue,
      'newValue': newValue,
      'effectiveDate': effectiveDate.toJson(),
      'reason': reason,
      'authorizedBy': authorizedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static RrhhMovementHistoryInclude include() {
    return RrhhMovementHistoryInclude._();
  }

  static RrhhMovementHistoryIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhMovementHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhMovementHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhMovementHistoryTable>? orderByList,
    RrhhMovementHistoryInclude? include,
  }) {
    return RrhhMovementHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhMovementHistory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhMovementHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhMovementHistoryImpl extends RrhhMovementHistory {
  _RrhhMovementHistoryImpl({
    int? id,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         movementType: movementType,
         previousValue: previousValue,
         newValue: newValue,
         effectiveDate: effectiveDate,
         reason: reason,
         authorizedBy: authorizedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhMovementHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhMovementHistory copyWith({
    Object? id = _Undefined,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? movementType,
    Object? previousValue = _Undefined,
    String? newValue,
    DateTime? effectiveDate,
    String? reason,
    String? authorizedBy,
    DateTime? createdAt,
  }) {
    return RrhhMovementHistory(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      movementType: movementType ?? this.movementType,
      previousValue: previousValue is String?
          ? previousValue
          : this.previousValue,
      newValue: newValue ?? this.newValue,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      reason: reason ?? this.reason,
      authorizedBy: authorizedBy ?? this.authorizedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RrhhMovementHistoryUpdateTable
    extends _i1.UpdateTable<RrhhMovementHistoryTable> {
  RrhhMovementHistoryUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> movementType(String value) => _i1.ColumnValue(
    table.movementType,
    value,
  );

  _i1.ColumnValue<String, String> previousValue(String? value) =>
      _i1.ColumnValue(
        table.previousValue,
        value,
      );

  _i1.ColumnValue<String, String> newValue(String value) => _i1.ColumnValue(
    table.newValue,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> effectiveDate(DateTime value) =>
      _i1.ColumnValue(
        table.effectiveDate,
        value,
      );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> authorizedBy(String value) => _i1.ColumnValue(
    table.authorizedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RrhhMovementHistoryTable extends _i1.Table<int?> {
  RrhhMovementHistoryTable({super.tableRelation})
    : super(tableName: 'rrhh_movement_history') {
    updateTable = RrhhMovementHistoryUpdateTable(this);
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
    movementType = _i1.ColumnString(
      'movementType',
      this,
    );
    previousValue = _i1.ColumnString(
      'previousValue',
      this,
    );
    newValue = _i1.ColumnString(
      'newValue',
      this,
    );
    effectiveDate = _i1.ColumnDateTime(
      'effectiveDate',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    authorizedBy = _i1.ColumnString(
      'authorizedBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RrhhMovementHistoryUpdateTable updateTable;

  /// Colaborador afectado
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  /// Tipo: 'INGRESO', 'ASCENSO', 'TRASLADO_AREA', 'ROTACION_SEDE', 'AJUSTE_SALARIAL', 'CAMBIO_TURNO', 'SUSPENSION', 'DESVINCULACION', 'REINCORPORACION'
  late final _i1.ColumnString movementType;

  /// Valores previos y nuevos
  late final _i1.ColumnString previousValue;

  late final _i1.ColumnString newValue;

  /// Fecha efectiva y justificación
  late final _i1.ColumnDateTime effectiveDate;

  late final _i1.ColumnString reason;

  late final _i1.ColumnString authorizedBy;

  /// Auditoría inmutable
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    employeeId,
    employeeCode,
    employeeName,
    movementType,
    previousValue,
    newValue,
    effectiveDate,
    reason,
    authorizedBy,
    createdAt,
  ];
}

class RrhhMovementHistoryInclude extends _i1.IncludeObject {
  RrhhMovementHistoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhMovementHistory.t;
}

class RrhhMovementHistoryIncludeList extends _i1.IncludeList {
  RrhhMovementHistoryIncludeList._({
    _i1.WhereExpressionBuilder<RrhhMovementHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhMovementHistory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhMovementHistory.t;
}

class RrhhMovementHistoryRepository {
  const RrhhMovementHistoryRepository._();

  /// Returns a list of [RrhhMovementHistory]s matching the given query parameters.
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
  Future<List<RrhhMovementHistory>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhMovementHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhMovementHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhMovementHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhMovementHistory>(
      where: where?.call(RrhhMovementHistory.t),
      orderBy: orderBy?.call(RrhhMovementHistory.t),
      orderByList: orderByList?.call(RrhhMovementHistory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhMovementHistory] matching the given query parameters.
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
  Future<RrhhMovementHistory?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhMovementHistoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhMovementHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhMovementHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhMovementHistory>(
      where: where?.call(RrhhMovementHistory.t),
      orderBy: orderBy?.call(RrhhMovementHistory.t),
      orderByList: orderByList?.call(RrhhMovementHistory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhMovementHistory] by its [id] or null if no such row exists.
  Future<RrhhMovementHistory?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhMovementHistory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhMovementHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhMovementHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhMovementHistory>> insert(
    _i1.DatabaseSession session,
    List<RrhhMovementHistory> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhMovementHistory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhMovementHistory] and returns the inserted row.
  ///
  /// The returned [RrhhMovementHistory] will have its `id` field set.
  Future<RrhhMovementHistory> insertRow(
    _i1.DatabaseSession session,
    RrhhMovementHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhMovementHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhMovementHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhMovementHistory>> update(
    _i1.DatabaseSession session,
    List<RrhhMovementHistory> rows, {
    _i1.ColumnSelections<RrhhMovementHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhMovementHistory>(
      rows,
      columns: columns?.call(RrhhMovementHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhMovementHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhMovementHistory> updateRow(
    _i1.DatabaseSession session,
    RrhhMovementHistory row, {
    _i1.ColumnSelections<RrhhMovementHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhMovementHistory>(
      row,
      columns: columns?.call(RrhhMovementHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhMovementHistory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhMovementHistory?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhMovementHistoryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhMovementHistory>(
      id,
      columnValues: columnValues(RrhhMovementHistory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhMovementHistory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhMovementHistory>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhMovementHistoryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhMovementHistoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhMovementHistoryTable>? orderBy,
    _i1.OrderByListBuilder<RrhhMovementHistoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhMovementHistory>(
      columnValues: columnValues(RrhhMovementHistory.t.updateTable),
      where: where(RrhhMovementHistory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhMovementHistory.t),
      orderByList: orderByList?.call(RrhhMovementHistory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhMovementHistory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhMovementHistory>> delete(
    _i1.DatabaseSession session,
    List<RrhhMovementHistory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhMovementHistory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhMovementHistory].
  Future<RrhhMovementHistory> deleteRow(
    _i1.DatabaseSession session,
    RrhhMovementHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhMovementHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhMovementHistory>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhMovementHistoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhMovementHistory>(
      where: where(RrhhMovementHistory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhMovementHistoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhMovementHistory>(
      where: where?.call(RrhhMovementHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhMovementHistory] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhMovementHistoryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhMovementHistory>(
      where: where(RrhhMovementHistory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
