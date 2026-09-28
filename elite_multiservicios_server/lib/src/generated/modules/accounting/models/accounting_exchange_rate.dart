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

abstract class AccountingExchangeRate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingExchangeRate._({
    this.id,
    required this.date,
    required this.currency,
    required this.rateToBob,
    required this.createdAt,
  });

  factory AccountingExchangeRate({
    int? id,
    required DateTime date,
    required String currency,
    required double rateToBob,
    required DateTime createdAt,
  }) = _AccountingExchangeRateImpl;

  factory AccountingExchangeRate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingExchangeRate(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      currency: jsonSerialization['currency'] as String,
      rateToBob: (jsonSerialization['rateToBob'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AccountingExchangeRateTable();

  static const db = AccountingExchangeRateRepository._();

  @override
  int? id;

  DateTime date;

  String currency;

  double rateToBob;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingExchangeRate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingExchangeRate copyWith({
    int? id,
    DateTime? date,
    String? currency,
    double? rateToBob,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingExchangeRate',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'currency': currency,
      'rateToBob': rateToBob,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingExchangeRate',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'currency': currency,
      'rateToBob': rateToBob,
      'createdAt': createdAt.toJson(),
    };
  }

  static AccountingExchangeRateInclude include() {
    return AccountingExchangeRateInclude._();
  }

  static AccountingExchangeRateIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingExchangeRateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExchangeRateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExchangeRateTable>? orderByList,
    AccountingExchangeRateInclude? include,
  }) {
    return AccountingExchangeRateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingExchangeRate.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingExchangeRate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingExchangeRateImpl extends AccountingExchangeRate {
  _AccountingExchangeRateImpl({
    int? id,
    required DateTime date,
    required String currency,
    required double rateToBob,
    required DateTime createdAt,
  }) : super._(
         id: id,
         date: date,
         currency: currency,
         rateToBob: rateToBob,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingExchangeRate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingExchangeRate copyWith({
    Object? id = _Undefined,
    DateTime? date,
    String? currency,
    double? rateToBob,
    DateTime? createdAt,
  }) {
    return AccountingExchangeRate(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      rateToBob: rateToBob ?? this.rateToBob,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AccountingExchangeRateUpdateTable
    extends _i1.UpdateTable<AccountingExchangeRateTable> {
  AccountingExchangeRateUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<double, double> rateToBob(double value) => _i1.ColumnValue(
    table.rateToBob,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccountingExchangeRateTable extends _i1.Table<int?> {
  AccountingExchangeRateTable({super.tableRelation})
    : super(tableName: 'accounting_exchange_rate') {
    updateTable = AccountingExchangeRateUpdateTable(this);
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    rateToBob = _i1.ColumnDouble(
      'rateToBob',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AccountingExchangeRateUpdateTable updateTable;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDouble rateToBob;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    date,
    currency,
    rateToBob,
    createdAt,
  ];
}

class AccountingExchangeRateInclude extends _i1.IncludeObject {
  AccountingExchangeRateInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingExchangeRate.t;
}

class AccountingExchangeRateIncludeList extends _i1.IncludeList {
  AccountingExchangeRateIncludeList._({
    _i1.WhereExpressionBuilder<AccountingExchangeRateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingExchangeRate.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingExchangeRate.t;
}

class AccountingExchangeRateRepository {
  const AccountingExchangeRateRepository._();

  /// Returns a list of [AccountingExchangeRate]s matching the given query parameters.
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
  Future<List<AccountingExchangeRate>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExchangeRateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExchangeRateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExchangeRateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingExchangeRate>(
      where: where?.call(AccountingExchangeRate.t),
      orderBy: orderBy?.call(AccountingExchangeRate.t),
      orderByList: orderByList?.call(AccountingExchangeRate.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingExchangeRate] matching the given query parameters.
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
  Future<AccountingExchangeRate?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExchangeRateTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingExchangeRateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExchangeRateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingExchangeRate>(
      where: where?.call(AccountingExchangeRate.t),
      orderBy: orderBy?.call(AccountingExchangeRate.t),
      orderByList: orderByList?.call(AccountingExchangeRate.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingExchangeRate] by its [id] or null if no such row exists.
  Future<AccountingExchangeRate?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingExchangeRate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingExchangeRate]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingExchangeRate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingExchangeRate>> insert(
    _i1.DatabaseSession session,
    List<AccountingExchangeRate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingExchangeRate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingExchangeRate] and returns the inserted row.
  ///
  /// The returned [AccountingExchangeRate] will have its `id` field set.
  Future<AccountingExchangeRate> insertRow(
    _i1.DatabaseSession session,
    AccountingExchangeRate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingExchangeRate>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingExchangeRate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingExchangeRate>> update(
    _i1.DatabaseSession session,
    List<AccountingExchangeRate> rows, {
    _i1.ColumnSelections<AccountingExchangeRateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingExchangeRate>(
      rows,
      columns: columns?.call(AccountingExchangeRate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingExchangeRate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingExchangeRate> updateRow(
    _i1.DatabaseSession session,
    AccountingExchangeRate row, {
    _i1.ColumnSelections<AccountingExchangeRateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingExchangeRate>(
      row,
      columns: columns?.call(AccountingExchangeRate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingExchangeRate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingExchangeRate?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingExchangeRateUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingExchangeRate>(
      id,
      columnValues: columnValues(AccountingExchangeRate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingExchangeRate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingExchangeRate>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingExchangeRateUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingExchangeRateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExchangeRateTable>? orderBy,
    _i1.OrderByListBuilder<AccountingExchangeRateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingExchangeRate>(
      columnValues: columnValues(AccountingExchangeRate.t.updateTable),
      where: where(AccountingExchangeRate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingExchangeRate.t),
      orderByList: orderByList?.call(AccountingExchangeRate.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingExchangeRate]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingExchangeRate>> delete(
    _i1.DatabaseSession session,
    List<AccountingExchangeRate> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingExchangeRate>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingExchangeRate].
  Future<AccountingExchangeRate> deleteRow(
    _i1.DatabaseSession session,
    AccountingExchangeRate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingExchangeRate>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingExchangeRate>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingExchangeRateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingExchangeRate>(
      where: where(AccountingExchangeRate.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExchangeRateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingExchangeRate>(
      where: where?.call(AccountingExchangeRate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingExchangeRate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingExchangeRateTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingExchangeRate>(
      where: where(AccountingExchangeRate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
