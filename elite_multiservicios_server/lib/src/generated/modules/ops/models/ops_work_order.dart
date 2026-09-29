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

abstract class OpsWorkOrder
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OpsWorkOrder._({
    this.id,
    required this.contractId,
    required this.date,
    this.assignedEmployeeId,
    String? status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending';

  factory OpsWorkOrder({
    int? id,
    required int contractId,
    required DateTime date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsWorkOrderImpl;

  factory OpsWorkOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsWorkOrder(
      id: jsonSerialization['id'] as int?,
      contractId: jsonSerialization['contractId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      assignedEmployeeId: jsonSerialization['assignedEmployeeId'] as int?,
      status: jsonSerialization['status'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = OpsWorkOrderTable();

  static const db = OpsWorkOrderRepository._();

  @override
  int? id;

  int contractId;

  DateTime date;

  int? assignedEmployeeId;

  String status;

  String? notes;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OpsWorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsWorkOrder copyWith({
    int? id,
    int? contractId,
    DateTime? date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsWorkOrder',
      if (id != null) 'id': id,
      'contractId': contractId,
      'date': date.toJson(),
      if (assignedEmployeeId != null) 'assignedEmployeeId': assignedEmployeeId,
      'status': status,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsWorkOrder',
      if (id != null) 'id': id,
      'contractId': contractId,
      'date': date.toJson(),
      if (assignedEmployeeId != null) 'assignedEmployeeId': assignedEmployeeId,
      'status': status,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static OpsWorkOrderInclude include() {
    return OpsWorkOrderInclude._();
  }

  static OpsWorkOrderIncludeList includeList({
    _i1.WhereExpressionBuilder<OpsWorkOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsWorkOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsWorkOrderTable>? orderByList,
    OpsWorkOrderInclude? include,
  }) {
    return OpsWorkOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsWorkOrder.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OpsWorkOrder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsWorkOrderImpl extends OpsWorkOrder {
  _OpsWorkOrderImpl({
    int? id,
    required int contractId,
    required DateTime date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contractId: contractId,
         date: date,
         assignedEmployeeId: assignedEmployeeId,
         status: status,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsWorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsWorkOrder copyWith({
    Object? id = _Undefined,
    int? contractId,
    DateTime? date,
    Object? assignedEmployeeId = _Undefined,
    String? status,
    Object? notes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsWorkOrder(
      id: id is int? ? id : this.id,
      contractId: contractId ?? this.contractId,
      date: date ?? this.date,
      assignedEmployeeId: assignedEmployeeId is int?
          ? assignedEmployeeId
          : this.assignedEmployeeId,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OpsWorkOrderUpdateTable extends _i1.UpdateTable<OpsWorkOrderTable> {
  OpsWorkOrderUpdateTable(super.table);

  _i1.ColumnValue<int, int> contractId(int value) => _i1.ColumnValue(
    table.contractId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<int, int> assignedEmployeeId(int? value) => _i1.ColumnValue(
    table.assignedEmployeeId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
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

class OpsWorkOrderTable extends _i1.Table<int?> {
  OpsWorkOrderTable({super.tableRelation})
    : super(tableName: 'ops_work_order') {
    updateTable = OpsWorkOrderUpdateTable(this);
    contractId = _i1.ColumnInt(
      'contractId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    assignedEmployeeId = _i1.ColumnInt(
      'assignedEmployeeId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    notes = _i1.ColumnString(
      'notes',
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

  late final OpsWorkOrderUpdateTable updateTable;

  late final _i1.ColumnInt contractId;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnInt assignedEmployeeId;

  late final _i1.ColumnString status;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    contractId,
    date,
    assignedEmployeeId,
    status,
    notes,
    createdAt,
    updatedAt,
  ];
}

class OpsWorkOrderInclude extends _i1.IncludeObject {
  OpsWorkOrderInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OpsWorkOrder.t;
}

class OpsWorkOrderIncludeList extends _i1.IncludeList {
  OpsWorkOrderIncludeList._({
    _i1.WhereExpressionBuilder<OpsWorkOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OpsWorkOrder.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OpsWorkOrder.t;
}

class OpsWorkOrderRepository {
  const OpsWorkOrderRepository._();

  /// Returns a list of [OpsWorkOrder]s matching the given query parameters.
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
  Future<List<OpsWorkOrder>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsWorkOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsWorkOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsWorkOrderTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OpsWorkOrder>(
      where: where?.call(OpsWorkOrder.t),
      orderBy: orderBy?.call(OpsWorkOrder.t),
      orderByList: orderByList?.call(OpsWorkOrder.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OpsWorkOrder] matching the given query parameters.
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
  Future<OpsWorkOrder?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsWorkOrderTable>? where,
    int? offset,
    _i1.OrderByBuilder<OpsWorkOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsWorkOrderTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OpsWorkOrder>(
      where: where?.call(OpsWorkOrder.t),
      orderBy: orderBy?.call(OpsWorkOrder.t),
      orderByList: orderByList?.call(OpsWorkOrder.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OpsWorkOrder] by its [id] or null if no such row exists.
  Future<OpsWorkOrder?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OpsWorkOrder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OpsWorkOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [OpsWorkOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OpsWorkOrder>> insert(
    _i1.DatabaseSession session,
    List<OpsWorkOrder> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OpsWorkOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OpsWorkOrder] and returns the inserted row.
  ///
  /// The returned [OpsWorkOrder] will have its `id` field set.
  Future<OpsWorkOrder> insertRow(
    _i1.DatabaseSession session,
    OpsWorkOrder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OpsWorkOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OpsWorkOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OpsWorkOrder>> update(
    _i1.DatabaseSession session,
    List<OpsWorkOrder> rows, {
    _i1.ColumnSelections<OpsWorkOrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OpsWorkOrder>(
      rows,
      columns: columns?.call(OpsWorkOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsWorkOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OpsWorkOrder> updateRow(
    _i1.DatabaseSession session,
    OpsWorkOrder row, {
    _i1.ColumnSelections<OpsWorkOrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OpsWorkOrder>(
      row,
      columns: columns?.call(OpsWorkOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsWorkOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OpsWorkOrder?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OpsWorkOrderUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OpsWorkOrder>(
      id,
      columnValues: columnValues(OpsWorkOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OpsWorkOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OpsWorkOrder>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OpsWorkOrderUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OpsWorkOrderTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsWorkOrderTable>? orderBy,
    _i1.OrderByListBuilder<OpsWorkOrderTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OpsWorkOrder>(
      columnValues: columnValues(OpsWorkOrder.t.updateTable),
      where: where(OpsWorkOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsWorkOrder.t),
      orderByList: orderByList?.call(OpsWorkOrder.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OpsWorkOrder]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OpsWorkOrder>> delete(
    _i1.DatabaseSession session,
    List<OpsWorkOrder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OpsWorkOrder>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OpsWorkOrder].
  Future<OpsWorkOrder> deleteRow(
    _i1.DatabaseSession session,
    OpsWorkOrder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OpsWorkOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OpsWorkOrder>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsWorkOrderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OpsWorkOrder>(
      where: where(OpsWorkOrder.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsWorkOrderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OpsWorkOrder>(
      where: where?.call(OpsWorkOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OpsWorkOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsWorkOrderTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OpsWorkOrder>(
      where: where(OpsWorkOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
