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

abstract class HrAttendance
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HrAttendance._({
    this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HrAttendance({
    int? id,
    required int employeeId,
    required DateTime date,
    DateTime? checkIn,
    DateTime? checkOut,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrAttendanceImpl;

  factory HrAttendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrAttendance(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      checkIn: jsonSerialization['checkIn'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkIn']),
      checkOut: jsonSerialization['checkOut'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkOut']),
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = HrAttendanceTable();

  static const db = HrAttendanceRepository._();

  @override
  int? id;

  int employeeId;

  DateTime date;

  DateTime? checkIn;

  DateTime? checkOut;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HrAttendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrAttendance copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrAttendance',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      if (checkIn != null) 'checkIn': checkIn?.toJson(),
      if (checkOut != null) 'checkOut': checkOut?.toJson(),
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HrAttendance',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      if (checkIn != null) 'checkIn': checkIn?.toJson(),
      if (checkOut != null) 'checkOut': checkOut?.toJson(),
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static HrAttendanceInclude include() {
    return HrAttendanceInclude._();
  }

  static HrAttendanceIncludeList includeList({
    _i1.WhereExpressionBuilder<HrAttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrAttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrAttendanceTable>? orderByList,
    HrAttendanceInclude? include,
  }) {
    return HrAttendanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrAttendance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HrAttendance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HrAttendanceImpl extends HrAttendance {
  _HrAttendanceImpl({
    int? id,
    required int employeeId,
    required DateTime date,
    DateTime? checkIn,
    DateTime? checkOut,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         date: date,
         checkIn: checkIn,
         checkOut: checkOut,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrAttendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrAttendance copyWith({
    Object? id = _Undefined,
    int? employeeId,
    DateTime? date,
    Object? checkIn = _Undefined,
    Object? checkOut = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrAttendance(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn is DateTime? ? checkIn : this.checkIn,
      checkOut: checkOut is DateTime? ? checkOut : this.checkOut,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HrAttendanceUpdateTable extends _i1.UpdateTable<HrAttendanceTable> {
  HrAttendanceUpdateTable(super.table);

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> checkIn(DateTime? value) =>
      _i1.ColumnValue(
        table.checkIn,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> checkOut(DateTime? value) =>
      _i1.ColumnValue(
        table.checkOut,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

class HrAttendanceTable extends _i1.Table<int?> {
  HrAttendanceTable({super.tableRelation}) : super(tableName: 'hr_attendance') {
    updateTable = HrAttendanceUpdateTable(this);
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    checkIn = _i1.ColumnDateTime(
      'checkIn',
      this,
    );
    checkOut = _i1.ColumnDateTime(
      'checkOut',
      this,
    );
    status = _i1.ColumnString(
      'status',
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

  late final HrAttendanceUpdateTable updateTable;

  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnDateTime checkIn;

  late final _i1.ColumnDateTime checkOut;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    employeeId,
    date,
    checkIn,
    checkOut,
    status,
    createdAt,
    updatedAt,
  ];
}

class HrAttendanceInclude extends _i1.IncludeObject {
  HrAttendanceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HrAttendance.t;
}

class HrAttendanceIncludeList extends _i1.IncludeList {
  HrAttendanceIncludeList._({
    _i1.WhereExpressionBuilder<HrAttendanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HrAttendance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HrAttendance.t;
}

class HrAttendanceRepository {
  const HrAttendanceRepository._();

  /// Returns a list of [HrAttendance]s matching the given query parameters.
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
  Future<List<HrAttendance>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrAttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrAttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrAttendanceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HrAttendance>(
      where: where?.call(HrAttendance.t),
      orderBy: orderBy?.call(HrAttendance.t),
      orderByList: orderByList?.call(HrAttendance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HrAttendance] matching the given query parameters.
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
  Future<HrAttendance?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrAttendanceTable>? where,
    int? offset,
    _i1.OrderByBuilder<HrAttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrAttendanceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HrAttendance>(
      where: where?.call(HrAttendance.t),
      orderBy: orderBy?.call(HrAttendance.t),
      orderByList: orderByList?.call(HrAttendance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HrAttendance] by its [id] or null if no such row exists.
  Future<HrAttendance?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HrAttendance>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HrAttendance]s in the list and returns the inserted rows.
  ///
  /// The returned [HrAttendance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HrAttendance>> insert(
    _i1.DatabaseSession session,
    List<HrAttendance> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HrAttendance>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HrAttendance] and returns the inserted row.
  ///
  /// The returned [HrAttendance] will have its `id` field set.
  Future<HrAttendance> insertRow(
    _i1.DatabaseSession session,
    HrAttendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HrAttendance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HrAttendance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HrAttendance>> update(
    _i1.DatabaseSession session,
    List<HrAttendance> rows, {
    _i1.ColumnSelections<HrAttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HrAttendance>(
      rows,
      columns: columns?.call(HrAttendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrAttendance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HrAttendance> updateRow(
    _i1.DatabaseSession session,
    HrAttendance row, {
    _i1.ColumnSelections<HrAttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HrAttendance>(
      row,
      columns: columns?.call(HrAttendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrAttendance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HrAttendance?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HrAttendanceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HrAttendance>(
      id,
      columnValues: columnValues(HrAttendance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HrAttendance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HrAttendance>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HrAttendanceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<HrAttendanceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrAttendanceTable>? orderBy,
    _i1.OrderByListBuilder<HrAttendanceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HrAttendance>(
      columnValues: columnValues(HrAttendance.t.updateTable),
      where: where(HrAttendance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrAttendance.t),
      orderByList: orderByList?.call(HrAttendance.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HrAttendance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HrAttendance>> delete(
    _i1.DatabaseSession session,
    List<HrAttendance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HrAttendance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HrAttendance].
  Future<HrAttendance> deleteRow(
    _i1.DatabaseSession session,
    HrAttendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HrAttendance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HrAttendance>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrAttendanceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HrAttendance>(
      where: where(HrAttendance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrAttendanceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HrAttendance>(
      where: where?.call(HrAttendance.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HrAttendance] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrAttendanceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HrAttendance>(
      where: where(HrAttendance.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
