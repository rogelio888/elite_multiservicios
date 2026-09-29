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

abstract class OpsInventoryUsage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OpsInventoryUsage._({
    this.id,
    required this.workOrderId,
    required this.itemId,
    required this.quantityUsed,
    required this.totalCost,
    required this.createdAt,
  });

  factory OpsInventoryUsage({
    int? id,
    required int workOrderId,
    required int itemId,
    required double quantityUsed,
    required double totalCost,
    required DateTime createdAt,
  }) = _OpsInventoryUsageImpl;

  factory OpsInventoryUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsInventoryUsage(
      id: jsonSerialization['id'] as int?,
      workOrderId: jsonSerialization['workOrderId'] as int,
      itemId: jsonSerialization['itemId'] as int,
      quantityUsed: (jsonSerialization['quantityUsed'] as num).toDouble(),
      totalCost: (jsonSerialization['totalCost'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = OpsInventoryUsageTable();

  static const db = OpsInventoryUsageRepository._();

  @override
  int? id;

  int workOrderId;

  int itemId;

  double quantityUsed;

  double totalCost;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OpsInventoryUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsInventoryUsage copyWith({
    int? id,
    int? workOrderId,
    int? itemId,
    double? quantityUsed,
    double? totalCost,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsInventoryUsage',
      if (id != null) 'id': id,
      'workOrderId': workOrderId,
      'itemId': itemId,
      'quantityUsed': quantityUsed,
      'totalCost': totalCost,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsInventoryUsage',
      if (id != null) 'id': id,
      'workOrderId': workOrderId,
      'itemId': itemId,
      'quantityUsed': quantityUsed,
      'totalCost': totalCost,
      'createdAt': createdAt.toJson(),
    };
  }

  static OpsInventoryUsageInclude include() {
    return OpsInventoryUsageInclude._();
  }

  static OpsInventoryUsageIncludeList includeList({
    _i1.WhereExpressionBuilder<OpsInventoryUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryUsageTable>? orderByList,
    OpsInventoryUsageInclude? include,
  }) {
    return OpsInventoryUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsInventoryUsage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OpsInventoryUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsInventoryUsageImpl extends OpsInventoryUsage {
  _OpsInventoryUsageImpl({
    int? id,
    required int workOrderId,
    required int itemId,
    required double quantityUsed,
    required double totalCost,
    required DateTime createdAt,
  }) : super._(
         id: id,
         workOrderId: workOrderId,
         itemId: itemId,
         quantityUsed: quantityUsed,
         totalCost: totalCost,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OpsInventoryUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsInventoryUsage copyWith({
    Object? id = _Undefined,
    int? workOrderId,
    int? itemId,
    double? quantityUsed,
    double? totalCost,
    DateTime? createdAt,
  }) {
    return OpsInventoryUsage(
      id: id is int? ? id : this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      itemId: itemId ?? this.itemId,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      totalCost: totalCost ?? this.totalCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OpsInventoryUsageUpdateTable
    extends _i1.UpdateTable<OpsInventoryUsageTable> {
  OpsInventoryUsageUpdateTable(super.table);

  _i1.ColumnValue<int, int> workOrderId(int value) => _i1.ColumnValue(
    table.workOrderId,
    value,
  );

  _i1.ColumnValue<int, int> itemId(int value) => _i1.ColumnValue(
    table.itemId,
    value,
  );

  _i1.ColumnValue<double, double> quantityUsed(double value) => _i1.ColumnValue(
    table.quantityUsed,
    value,
  );

  _i1.ColumnValue<double, double> totalCost(double value) => _i1.ColumnValue(
    table.totalCost,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class OpsInventoryUsageTable extends _i1.Table<int?> {
  OpsInventoryUsageTable({super.tableRelation})
    : super(tableName: 'ops_inventory_usage') {
    updateTable = OpsInventoryUsageUpdateTable(this);
    workOrderId = _i1.ColumnInt(
      'workOrderId',
      this,
    );
    itemId = _i1.ColumnInt(
      'itemId',
      this,
    );
    quantityUsed = _i1.ColumnDouble(
      'quantityUsed',
      this,
    );
    totalCost = _i1.ColumnDouble(
      'totalCost',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final OpsInventoryUsageUpdateTable updateTable;

  late final _i1.ColumnInt workOrderId;

  late final _i1.ColumnInt itemId;

  late final _i1.ColumnDouble quantityUsed;

  late final _i1.ColumnDouble totalCost;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    workOrderId,
    itemId,
    quantityUsed,
    totalCost,
    createdAt,
  ];
}

class OpsInventoryUsageInclude extends _i1.IncludeObject {
  OpsInventoryUsageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OpsInventoryUsage.t;
}

class OpsInventoryUsageIncludeList extends _i1.IncludeList {
  OpsInventoryUsageIncludeList._({
    _i1.WhereExpressionBuilder<OpsInventoryUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OpsInventoryUsage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OpsInventoryUsage.t;
}

class OpsInventoryUsageRepository {
  const OpsInventoryUsageRepository._();

  /// Returns a list of [OpsInventoryUsage]s matching the given query parameters.
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
  Future<List<OpsInventoryUsage>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryUsageTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OpsInventoryUsage>(
      where: where?.call(OpsInventoryUsage.t),
      orderBy: orderBy?.call(OpsInventoryUsage.t),
      orderByList: orderByList?.call(OpsInventoryUsage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OpsInventoryUsage] matching the given query parameters.
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
  Future<OpsInventoryUsage?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryUsageTable>? where,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryUsageTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OpsInventoryUsage>(
      where: where?.call(OpsInventoryUsage.t),
      orderBy: orderBy?.call(OpsInventoryUsage.t),
      orderByList: orderByList?.call(OpsInventoryUsage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OpsInventoryUsage] by its [id] or null if no such row exists.
  Future<OpsInventoryUsage?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OpsInventoryUsage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OpsInventoryUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [OpsInventoryUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OpsInventoryUsage>> insert(
    _i1.DatabaseSession session,
    List<OpsInventoryUsage> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OpsInventoryUsage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OpsInventoryUsage] and returns the inserted row.
  ///
  /// The returned [OpsInventoryUsage] will have its `id` field set.
  Future<OpsInventoryUsage> insertRow(
    _i1.DatabaseSession session,
    OpsInventoryUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OpsInventoryUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OpsInventoryUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OpsInventoryUsage>> update(
    _i1.DatabaseSession session,
    List<OpsInventoryUsage> rows, {
    _i1.ColumnSelections<OpsInventoryUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OpsInventoryUsage>(
      rows,
      columns: columns?.call(OpsInventoryUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsInventoryUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OpsInventoryUsage> updateRow(
    _i1.DatabaseSession session,
    OpsInventoryUsage row, {
    _i1.ColumnSelections<OpsInventoryUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OpsInventoryUsage>(
      row,
      columns: columns?.call(OpsInventoryUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsInventoryUsage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OpsInventoryUsage?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OpsInventoryUsageUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OpsInventoryUsage>(
      id,
      columnValues: columnValues(OpsInventoryUsage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OpsInventoryUsage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OpsInventoryUsage>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OpsInventoryUsageUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OpsInventoryUsageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryUsageTable>? orderBy,
    _i1.OrderByListBuilder<OpsInventoryUsageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OpsInventoryUsage>(
      columnValues: columnValues(OpsInventoryUsage.t.updateTable),
      where: where(OpsInventoryUsage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsInventoryUsage.t),
      orderByList: orderByList?.call(OpsInventoryUsage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OpsInventoryUsage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OpsInventoryUsage>> delete(
    _i1.DatabaseSession session,
    List<OpsInventoryUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OpsInventoryUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OpsInventoryUsage].
  Future<OpsInventoryUsage> deleteRow(
    _i1.DatabaseSession session,
    OpsInventoryUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OpsInventoryUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OpsInventoryUsage>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsInventoryUsageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OpsInventoryUsage>(
      where: where(OpsInventoryUsage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryUsageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OpsInventoryUsage>(
      where: where?.call(OpsInventoryUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OpsInventoryUsage] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsInventoryUsageTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OpsInventoryUsage>(
      where: where(OpsInventoryUsage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
