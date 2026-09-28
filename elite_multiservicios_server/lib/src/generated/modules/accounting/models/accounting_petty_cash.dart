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

abstract class AccountingPettyCash
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingPettyCash._({
    this.id,
    required this.name,
    required this.balance,
    required this.maxLimit,
    required this.custodianId,
  });

  factory AccountingPettyCash({
    int? id,
    required String name,
    required double balance,
    required double maxLimit,
    required int custodianId,
  }) = _AccountingPettyCashImpl;

  factory AccountingPettyCash.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingPettyCash(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      balance: (jsonSerialization['balance'] as num).toDouble(),
      maxLimit: (jsonSerialization['maxLimit'] as num).toDouble(),
      custodianId: jsonSerialization['custodianId'] as int,
    );
  }

  static final t = AccountingPettyCashTable();

  static const db = AccountingPettyCashRepository._();

  @override
  int? id;

  String name;

  double balance;

  double maxLimit;

  int custodianId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingPettyCash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCash copyWith({
    int? id,
    String? name,
    double? balance,
    double? maxLimit,
    int? custodianId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCash',
      if (id != null) 'id': id,
      'name': name,
      'balance': balance,
      'maxLimit': maxLimit,
      'custodianId': custodianId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingPettyCash',
      if (id != null) 'id': id,
      'name': name,
      'balance': balance,
      'maxLimit': maxLimit,
      'custodianId': custodianId,
    };
  }

  static AccountingPettyCashInclude include() {
    return AccountingPettyCashInclude._();
  }

  static AccountingPettyCashIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingPettyCashTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTable>? orderByList,
    AccountingPettyCashInclude? include,
  }) {
    return AccountingPettyCashIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCash.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingPettyCash.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashImpl extends AccountingPettyCash {
  _AccountingPettyCashImpl({
    int? id,
    required String name,
    required double balance,
    required double maxLimit,
    required int custodianId,
  }) : super._(
         id: id,
         name: name,
         balance: balance,
         maxLimit: maxLimit,
         custodianId: custodianId,
       );

  /// Returns a shallow copy of this [AccountingPettyCash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCash copyWith({
    Object? id = _Undefined,
    String? name,
    double? balance,
    double? maxLimit,
    int? custodianId,
  }) {
    return AccountingPettyCash(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      maxLimit: maxLimit ?? this.maxLimit,
      custodianId: custodianId ?? this.custodianId,
    );
  }
}

class AccountingPettyCashUpdateTable
    extends _i1.UpdateTable<AccountingPettyCashTable> {
  AccountingPettyCashUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<double, double> balance(double value) => _i1.ColumnValue(
    table.balance,
    value,
  );

  _i1.ColumnValue<double, double> maxLimit(double value) => _i1.ColumnValue(
    table.maxLimit,
    value,
  );

  _i1.ColumnValue<int, int> custodianId(int value) => _i1.ColumnValue(
    table.custodianId,
    value,
  );
}

class AccountingPettyCashTable extends _i1.Table<int?> {
  AccountingPettyCashTable({super.tableRelation})
    : super(tableName: 'accounting_petty_cash') {
    updateTable = AccountingPettyCashUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    balance = _i1.ColumnDouble(
      'balance',
      this,
    );
    maxLimit = _i1.ColumnDouble(
      'maxLimit',
      this,
    );
    custodianId = _i1.ColumnInt(
      'custodianId',
      this,
    );
  }

  late final AccountingPettyCashUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnDouble balance;

  late final _i1.ColumnDouble maxLimit;

  late final _i1.ColumnInt custodianId;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    balance,
    maxLimit,
    custodianId,
  ];
}

class AccountingPettyCashInclude extends _i1.IncludeObject {
  AccountingPettyCashInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingPettyCash.t;
}

class AccountingPettyCashIncludeList extends _i1.IncludeList {
  AccountingPettyCashIncludeList._({
    _i1.WhereExpressionBuilder<AccountingPettyCashTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingPettyCash.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingPettyCash.t;
}

class AccountingPettyCashRepository {
  const AccountingPettyCashRepository._();

  /// Returns a list of [AccountingPettyCash]s matching the given query parameters.
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
  Future<List<AccountingPettyCash>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingPettyCash>(
      where: where?.call(AccountingPettyCash.t),
      orderBy: orderBy?.call(AccountingPettyCash.t),
      orderByList: orderByList?.call(AccountingPettyCash.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingPettyCash] matching the given query parameters.
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
  Future<AccountingPettyCash?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingPettyCash>(
      where: where?.call(AccountingPettyCash.t),
      orderBy: orderBy?.call(AccountingPettyCash.t),
      orderByList: orderByList?.call(AccountingPettyCash.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingPettyCash] by its [id] or null if no such row exists.
  Future<AccountingPettyCash?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingPettyCash>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingPettyCash]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingPettyCash]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingPettyCash>> insert(
    _i1.DatabaseSession session,
    List<AccountingPettyCash> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingPettyCash>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingPettyCash] and returns the inserted row.
  ///
  /// The returned [AccountingPettyCash] will have its `id` field set.
  Future<AccountingPettyCash> insertRow(
    _i1.DatabaseSession session,
    AccountingPettyCash row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingPettyCash>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCash]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingPettyCash>> update(
    _i1.DatabaseSession session,
    List<AccountingPettyCash> rows, {
    _i1.ColumnSelections<AccountingPettyCashTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingPettyCash>(
      rows,
      columns: columns?.call(AccountingPettyCash.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCash]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingPettyCash> updateRow(
    _i1.DatabaseSession session,
    AccountingPettyCash row, {
    _i1.ColumnSelections<AccountingPettyCashTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingPettyCash>(
      row,
      columns: columns?.call(AccountingPettyCash.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCash] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingPettyCash?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingPettyCashUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingPettyCash>(
      id,
      columnValues: columnValues(AccountingPettyCash.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCash]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingPettyCash>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingPettyCashUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingPettyCashTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTable>? orderBy,
    _i1.OrderByListBuilder<AccountingPettyCashTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingPettyCash>(
      columnValues: columnValues(AccountingPettyCash.t.updateTable),
      where: where(AccountingPettyCash.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCash.t),
      orderByList: orderByList?.call(AccountingPettyCash.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingPettyCash]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingPettyCash>> delete(
    _i1.DatabaseSession session,
    List<AccountingPettyCash> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingPettyCash>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingPettyCash].
  Future<AccountingPettyCash> deleteRow(
    _i1.DatabaseSession session,
    AccountingPettyCash row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingPettyCash>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingPettyCash>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingPettyCash>(
      where: where(AccountingPettyCash.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingPettyCash>(
      where: where?.call(AccountingPettyCash.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingPettyCash] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingPettyCash>(
      where: where(AccountingPettyCash.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
