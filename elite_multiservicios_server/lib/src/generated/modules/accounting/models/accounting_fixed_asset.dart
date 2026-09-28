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

abstract class AccountingFixedAsset
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingFixedAsset._({
    this.id,
    required this.name,
    required this.category,
    required this.purchaseValue,
    required this.purchaseDate,
    required this.usefulLifeMonths,
    required this.accumulatedDepreciation,
    required this.isFullyDepreciated,
    this.lastDepreciationDate,
  });

  factory AccountingFixedAsset({
    int? id,
    required String name,
    required String category,
    required double purchaseValue,
    required DateTime purchaseDate,
    required int usefulLifeMonths,
    required double accumulatedDepreciation,
    required bool isFullyDepreciated,
    DateTime? lastDepreciationDate,
  }) = _AccountingFixedAssetImpl;

  factory AccountingFixedAsset.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingFixedAsset(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      purchaseValue: (jsonSerialization['purchaseValue'] as num).toDouble(),
      purchaseDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['purchaseDate'],
      ),
      usefulLifeMonths: jsonSerialization['usefulLifeMonths'] as int,
      accumulatedDepreciation:
          (jsonSerialization['accumulatedDepreciation'] as num).toDouble(),
      isFullyDepreciated: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFullyDepreciated'],
      ),
      lastDepreciationDate: jsonSerialization['lastDepreciationDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDepreciationDate'],
            ),
    );
  }

  static final t = AccountingFixedAssetTable();

  static const db = AccountingFixedAssetRepository._();

  @override
  int? id;

  String name;

  String category;

  double purchaseValue;

  DateTime purchaseDate;

  int usefulLifeMonths;

  double accumulatedDepreciation;

  bool isFullyDepreciated;

  DateTime? lastDepreciationDate;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingFixedAsset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingFixedAsset copyWith({
    int? id,
    String? name,
    String? category,
    double? purchaseValue,
    DateTime? purchaseDate,
    int? usefulLifeMonths,
    double? accumulatedDepreciation,
    bool? isFullyDepreciated,
    DateTime? lastDepreciationDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingFixedAsset',
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'purchaseValue': purchaseValue,
      'purchaseDate': purchaseDate.toJson(),
      'usefulLifeMonths': usefulLifeMonths,
      'accumulatedDepreciation': accumulatedDepreciation,
      'isFullyDepreciated': isFullyDepreciated,
      if (lastDepreciationDate != null)
        'lastDepreciationDate': lastDepreciationDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingFixedAsset',
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'purchaseValue': purchaseValue,
      'purchaseDate': purchaseDate.toJson(),
      'usefulLifeMonths': usefulLifeMonths,
      'accumulatedDepreciation': accumulatedDepreciation,
      'isFullyDepreciated': isFullyDepreciated,
      if (lastDepreciationDate != null)
        'lastDepreciationDate': lastDepreciationDate?.toJson(),
    };
  }

  static AccountingFixedAssetInclude include() {
    return AccountingFixedAssetInclude._();
  }

  static AccountingFixedAssetIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingFixedAssetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingFixedAssetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingFixedAssetTable>? orderByList,
    AccountingFixedAssetInclude? include,
  }) {
    return AccountingFixedAssetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingFixedAsset.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingFixedAsset.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingFixedAssetImpl extends AccountingFixedAsset {
  _AccountingFixedAssetImpl({
    int? id,
    required String name,
    required String category,
    required double purchaseValue,
    required DateTime purchaseDate,
    required int usefulLifeMonths,
    required double accumulatedDepreciation,
    required bool isFullyDepreciated,
    DateTime? lastDepreciationDate,
  }) : super._(
         id: id,
         name: name,
         category: category,
         purchaseValue: purchaseValue,
         purchaseDate: purchaseDate,
         usefulLifeMonths: usefulLifeMonths,
         accumulatedDepreciation: accumulatedDepreciation,
         isFullyDepreciated: isFullyDepreciated,
         lastDepreciationDate: lastDepreciationDate,
       );

  /// Returns a shallow copy of this [AccountingFixedAsset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingFixedAsset copyWith({
    Object? id = _Undefined,
    String? name,
    String? category,
    double? purchaseValue,
    DateTime? purchaseDate,
    int? usefulLifeMonths,
    double? accumulatedDepreciation,
    bool? isFullyDepreciated,
    Object? lastDepreciationDate = _Undefined,
  }) {
    return AccountingFixedAsset(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      purchaseValue: purchaseValue ?? this.purchaseValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      usefulLifeMonths: usefulLifeMonths ?? this.usefulLifeMonths,
      accumulatedDepreciation:
          accumulatedDepreciation ?? this.accumulatedDepreciation,
      isFullyDepreciated: isFullyDepreciated ?? this.isFullyDepreciated,
      lastDepreciationDate: lastDepreciationDate is DateTime?
          ? lastDepreciationDate
          : this.lastDepreciationDate,
    );
  }
}

class AccountingFixedAssetUpdateTable
    extends _i1.UpdateTable<AccountingFixedAssetTable> {
  AccountingFixedAssetUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<double, double> purchaseValue(double value) =>
      _i1.ColumnValue(
        table.purchaseValue,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> purchaseDate(DateTime value) =>
      _i1.ColumnValue(
        table.purchaseDate,
        value,
      );

  _i1.ColumnValue<int, int> usefulLifeMonths(int value) => _i1.ColumnValue(
    table.usefulLifeMonths,
    value,
  );

  _i1.ColumnValue<double, double> accumulatedDepreciation(double value) =>
      _i1.ColumnValue(
        table.accumulatedDepreciation,
        value,
      );

  _i1.ColumnValue<bool, bool> isFullyDepreciated(bool value) => _i1.ColumnValue(
    table.isFullyDepreciated,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastDepreciationDate(DateTime? value) =>
      _i1.ColumnValue(
        table.lastDepreciationDate,
        value,
      );
}

class AccountingFixedAssetTable extends _i1.Table<int?> {
  AccountingFixedAssetTable({super.tableRelation})
    : super(tableName: 'accounting_fixed_asset') {
    updateTable = AccountingFixedAssetUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    purchaseValue = _i1.ColumnDouble(
      'purchaseValue',
      this,
    );
    purchaseDate = _i1.ColumnDateTime(
      'purchaseDate',
      this,
    );
    usefulLifeMonths = _i1.ColumnInt(
      'usefulLifeMonths',
      this,
    );
    accumulatedDepreciation = _i1.ColumnDouble(
      'accumulatedDepreciation',
      this,
    );
    isFullyDepreciated = _i1.ColumnBool(
      'isFullyDepreciated',
      this,
    );
    lastDepreciationDate = _i1.ColumnDateTime(
      'lastDepreciationDate',
      this,
    );
  }

  late final AccountingFixedAssetUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString category;

  late final _i1.ColumnDouble purchaseValue;

  late final _i1.ColumnDateTime purchaseDate;

  late final _i1.ColumnInt usefulLifeMonths;

  late final _i1.ColumnDouble accumulatedDepreciation;

  late final _i1.ColumnBool isFullyDepreciated;

  late final _i1.ColumnDateTime lastDepreciationDate;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    category,
    purchaseValue,
    purchaseDate,
    usefulLifeMonths,
    accumulatedDepreciation,
    isFullyDepreciated,
    lastDepreciationDate,
  ];
}

class AccountingFixedAssetInclude extends _i1.IncludeObject {
  AccountingFixedAssetInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingFixedAsset.t;
}

class AccountingFixedAssetIncludeList extends _i1.IncludeList {
  AccountingFixedAssetIncludeList._({
    _i1.WhereExpressionBuilder<AccountingFixedAssetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingFixedAsset.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingFixedAsset.t;
}

class AccountingFixedAssetRepository {
  const AccountingFixedAssetRepository._();

  /// Returns a list of [AccountingFixedAsset]s matching the given query parameters.
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
  Future<List<AccountingFixedAsset>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingFixedAssetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingFixedAssetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingFixedAssetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingFixedAsset>(
      where: where?.call(AccountingFixedAsset.t),
      orderBy: orderBy?.call(AccountingFixedAsset.t),
      orderByList: orderByList?.call(AccountingFixedAsset.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingFixedAsset] matching the given query parameters.
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
  Future<AccountingFixedAsset?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingFixedAssetTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingFixedAssetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingFixedAssetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingFixedAsset>(
      where: where?.call(AccountingFixedAsset.t),
      orderBy: orderBy?.call(AccountingFixedAsset.t),
      orderByList: orderByList?.call(AccountingFixedAsset.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingFixedAsset] by its [id] or null if no such row exists.
  Future<AccountingFixedAsset?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingFixedAsset>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingFixedAsset]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingFixedAsset]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingFixedAsset>> insert(
    _i1.DatabaseSession session,
    List<AccountingFixedAsset> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingFixedAsset>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingFixedAsset] and returns the inserted row.
  ///
  /// The returned [AccountingFixedAsset] will have its `id` field set.
  Future<AccountingFixedAsset> insertRow(
    _i1.DatabaseSession session,
    AccountingFixedAsset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingFixedAsset>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingFixedAsset]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingFixedAsset>> update(
    _i1.DatabaseSession session,
    List<AccountingFixedAsset> rows, {
    _i1.ColumnSelections<AccountingFixedAssetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingFixedAsset>(
      rows,
      columns: columns?.call(AccountingFixedAsset.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingFixedAsset]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingFixedAsset> updateRow(
    _i1.DatabaseSession session,
    AccountingFixedAsset row, {
    _i1.ColumnSelections<AccountingFixedAssetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingFixedAsset>(
      row,
      columns: columns?.call(AccountingFixedAsset.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingFixedAsset] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingFixedAsset?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingFixedAssetUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingFixedAsset>(
      id,
      columnValues: columnValues(AccountingFixedAsset.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingFixedAsset]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingFixedAsset>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingFixedAssetUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingFixedAssetTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingFixedAssetTable>? orderBy,
    _i1.OrderByListBuilder<AccountingFixedAssetTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingFixedAsset>(
      columnValues: columnValues(AccountingFixedAsset.t.updateTable),
      where: where(AccountingFixedAsset.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingFixedAsset.t),
      orderByList: orderByList?.call(AccountingFixedAsset.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingFixedAsset]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingFixedAsset>> delete(
    _i1.DatabaseSession session,
    List<AccountingFixedAsset> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingFixedAsset>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingFixedAsset].
  Future<AccountingFixedAsset> deleteRow(
    _i1.DatabaseSession session,
    AccountingFixedAsset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingFixedAsset>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingFixedAsset>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingFixedAssetTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingFixedAsset>(
      where: where(AccountingFixedAsset.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingFixedAssetTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingFixedAsset>(
      where: where?.call(AccountingFixedAsset.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingFixedAsset] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingFixedAssetTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingFixedAsset>(
      where: where(AccountingFixedAsset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
