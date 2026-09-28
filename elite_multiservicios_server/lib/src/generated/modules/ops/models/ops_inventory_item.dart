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

abstract class OpsInventoryItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OpsInventoryItem._({
    this.id,
    required this.name,
    this.description,
    required this.unit,
    double? quantityInStock,
    double? averageCost,
    required this.createdAt,
    required this.updatedAt,
  }) : quantityInStock = quantityInStock ?? 0.0,
       averageCost = averageCost ?? 0.0;

  factory OpsInventoryItem({
    int? id,
    required String name,
    String? description,
    required String unit,
    double? quantityInStock,
    double? averageCost,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsInventoryItemImpl;

  factory OpsInventoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsInventoryItem(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      unit: jsonSerialization['unit'] as String,
      quantityInStock: (jsonSerialization['quantityInStock'] as num?)
          ?.toDouble(),
      averageCost: (jsonSerialization['averageCost'] as num?)?.toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = OpsInventoryItemTable();

  static const db = OpsInventoryItemRepository._();

  @override
  int? id;

  String name;

  String? description;

  String unit;

  double quantityInStock;

  double averageCost;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OpsInventoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsInventoryItem copyWith({
    int? id,
    String? name,
    String? description,
    String? unit,
    double? quantityInStock,
    double? averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsInventoryItem',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'unit': unit,
      'quantityInStock': quantityInStock,
      'averageCost': averageCost,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsInventoryItem',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'unit': unit,
      'quantityInStock': quantityInStock,
      'averageCost': averageCost,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static OpsInventoryItemInclude include() {
    return OpsInventoryItemInclude._();
  }

  static OpsInventoryItemIncludeList includeList({
    _i1.WhereExpressionBuilder<OpsInventoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryItemTable>? orderByList,
    OpsInventoryItemInclude? include,
  }) {
    return OpsInventoryItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsInventoryItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OpsInventoryItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsInventoryItemImpl extends OpsInventoryItem {
  _OpsInventoryItemImpl({
    int? id,
    required String name,
    String? description,
    required String unit,
    double? quantityInStock,
    double? averageCost,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         unit: unit,
         quantityInStock: quantityInStock,
         averageCost: averageCost,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsInventoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsInventoryItem copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? unit,
    double? quantityInStock,
    double? averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsInventoryItem(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      unit: unit ?? this.unit,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      averageCost: averageCost ?? this.averageCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OpsInventoryItemUpdateTable
    extends _i1.UpdateTable<OpsInventoryItemTable> {
  OpsInventoryItemUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> unit(String value) => _i1.ColumnValue(
    table.unit,
    value,
  );

  _i1.ColumnValue<double, double> quantityInStock(double value) =>
      _i1.ColumnValue(
        table.quantityInStock,
        value,
      );

  _i1.ColumnValue<double, double> averageCost(double value) => _i1.ColumnValue(
    table.averageCost,
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

class OpsInventoryItemTable extends _i1.Table<int?> {
  OpsInventoryItemTable({super.tableRelation})
    : super(tableName: 'ops_inventory_item') {
    updateTable = OpsInventoryItemUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    quantityInStock = _i1.ColumnDouble(
      'quantityInStock',
      this,
      hasDefault: true,
    );
    averageCost = _i1.ColumnDouble(
      'averageCost',
      this,
      hasDefault: true,
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

  late final OpsInventoryItemUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString unit;

  late final _i1.ColumnDouble quantityInStock;

  late final _i1.ColumnDouble averageCost;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    unit,
    quantityInStock,
    averageCost,
    createdAt,
    updatedAt,
  ];
}

class OpsInventoryItemInclude extends _i1.IncludeObject {
  OpsInventoryItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OpsInventoryItem.t;
}

class OpsInventoryItemIncludeList extends _i1.IncludeList {
  OpsInventoryItemIncludeList._({
    _i1.WhereExpressionBuilder<OpsInventoryItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OpsInventoryItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OpsInventoryItem.t;
}

class OpsInventoryItemRepository {
  const OpsInventoryItemRepository._();

  /// Returns a list of [OpsInventoryItem]s matching the given query parameters.
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
  Future<List<OpsInventoryItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OpsInventoryItem>(
      where: where?.call(OpsInventoryItem.t),
      orderBy: orderBy?.call(OpsInventoryItem.t),
      orderByList: orderByList?.call(OpsInventoryItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OpsInventoryItem] matching the given query parameters.
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
  Future<OpsInventoryItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsInventoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OpsInventoryItem>(
      where: where?.call(OpsInventoryItem.t),
      orderBy: orderBy?.call(OpsInventoryItem.t),
      orderByList: orderByList?.call(OpsInventoryItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OpsInventoryItem] by its [id] or null if no such row exists.
  Future<OpsInventoryItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OpsInventoryItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OpsInventoryItem]s in the list and returns the inserted rows.
  ///
  /// The returned [OpsInventoryItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OpsInventoryItem>> insert(
    _i1.DatabaseSession session,
    List<OpsInventoryItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OpsInventoryItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OpsInventoryItem] and returns the inserted row.
  ///
  /// The returned [OpsInventoryItem] will have its `id` field set.
  Future<OpsInventoryItem> insertRow(
    _i1.DatabaseSession session,
    OpsInventoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OpsInventoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OpsInventoryItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OpsInventoryItem>> update(
    _i1.DatabaseSession session,
    List<OpsInventoryItem> rows, {
    _i1.ColumnSelections<OpsInventoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OpsInventoryItem>(
      rows,
      columns: columns?.call(OpsInventoryItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsInventoryItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OpsInventoryItem> updateRow(
    _i1.DatabaseSession session,
    OpsInventoryItem row, {
    _i1.ColumnSelections<OpsInventoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OpsInventoryItem>(
      row,
      columns: columns?.call(OpsInventoryItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsInventoryItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OpsInventoryItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OpsInventoryItemUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OpsInventoryItem>(
      id,
      columnValues: columnValues(OpsInventoryItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OpsInventoryItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OpsInventoryItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OpsInventoryItemUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OpsInventoryItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsInventoryItemTable>? orderBy,
    _i1.OrderByListBuilder<OpsInventoryItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OpsInventoryItem>(
      columnValues: columnValues(OpsInventoryItem.t.updateTable),
      where: where(OpsInventoryItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsInventoryItem.t),
      orderByList: orderByList?.call(OpsInventoryItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OpsInventoryItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OpsInventoryItem>> delete(
    _i1.DatabaseSession session,
    List<OpsInventoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OpsInventoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OpsInventoryItem].
  Future<OpsInventoryItem> deleteRow(
    _i1.DatabaseSession session,
    OpsInventoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OpsInventoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OpsInventoryItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsInventoryItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OpsInventoryItem>(
      where: where(OpsInventoryItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsInventoryItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OpsInventoryItem>(
      where: where?.call(OpsInventoryItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OpsInventoryItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsInventoryItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OpsInventoryItem>(
      where: where(OpsInventoryItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
