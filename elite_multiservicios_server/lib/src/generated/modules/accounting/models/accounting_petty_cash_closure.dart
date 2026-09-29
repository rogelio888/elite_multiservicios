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

abstract class AccountingPettyCashClosure
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingPettyCashClosure._({
    this.id,
    required this.pettyCashId,
    required this.date,
    required this.openingBalance,
    required this.closingBalance,
    this.comments,
    required this.createdAt,
  });

  factory AccountingPettyCashClosure({
    int? id,
    required int pettyCashId,
    required DateTime date,
    required double openingBalance,
    required double closingBalance,
    String? comments,
    required DateTime createdAt,
  }) = _AccountingPettyCashClosureImpl;

  factory AccountingPettyCashClosure.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPettyCashClosure(
      id: jsonSerialization['id'] as int?,
      pettyCashId: jsonSerialization['pettyCashId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      openingBalance: (jsonSerialization['openingBalance'] as num).toDouble(),
      closingBalance: (jsonSerialization['closingBalance'] as num).toDouble(),
      comments: jsonSerialization['comments'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AccountingPettyCashClosureTable();

  static const db = AccountingPettyCashClosureRepository._();

  @override
  int? id;

  int pettyCashId;

  DateTime date;

  double openingBalance;

  double closingBalance;

  String? comments;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingPettyCashClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCashClosure copyWith({
    int? id,
    int? pettyCashId,
    DateTime? date,
    double? openingBalance,
    double? closingBalance,
    String? comments,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCashClosure',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'date': date.toJson(),
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      if (comments != null) 'comments': comments,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingPettyCashClosure',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'date': date.toJson(),
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      if (comments != null) 'comments': comments,
      'createdAt': createdAt.toJson(),
    };
  }

  static AccountingPettyCashClosureInclude include() {
    return AccountingPettyCashClosureInclude._();
  }

  static AccountingPettyCashClosureIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashClosureTable>? orderByList,
    AccountingPettyCashClosureInclude? include,
  }) {
    return AccountingPettyCashClosureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCashClosure.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingPettyCashClosure.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashClosureImpl extends AccountingPettyCashClosure {
  _AccountingPettyCashClosureImpl({
    int? id,
    required int pettyCashId,
    required DateTime date,
    required double openingBalance,
    required double closingBalance,
    String? comments,
    required DateTime createdAt,
  }) : super._(
         id: id,
         pettyCashId: pettyCashId,
         date: date,
         openingBalance: openingBalance,
         closingBalance: closingBalance,
         comments: comments,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingPettyCashClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCashClosure copyWith({
    Object? id = _Undefined,
    int? pettyCashId,
    DateTime? date,
    double? openingBalance,
    double? closingBalance,
    Object? comments = _Undefined,
    DateTime? createdAt,
  }) {
    return AccountingPettyCashClosure(
      id: id is int? ? id : this.id,
      pettyCashId: pettyCashId ?? this.pettyCashId,
      date: date ?? this.date,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      comments: comments is String? ? comments : this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AccountingPettyCashClosureUpdateTable
    extends _i1.UpdateTable<AccountingPettyCashClosureTable> {
  AccountingPettyCashClosureUpdateTable(super.table);

  _i1.ColumnValue<int, int> pettyCashId(int value) => _i1.ColumnValue(
    table.pettyCashId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<double, double> openingBalance(double value) =>
      _i1.ColumnValue(
        table.openingBalance,
        value,
      );

  _i1.ColumnValue<double, double> closingBalance(double value) =>
      _i1.ColumnValue(
        table.closingBalance,
        value,
      );

  _i1.ColumnValue<String, String> comments(String? value) => _i1.ColumnValue(
    table.comments,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccountingPettyCashClosureTable extends _i1.Table<int?> {
  AccountingPettyCashClosureTable({super.tableRelation})
    : super(tableName: 'accounting_petty_cash_closure') {
    updateTable = AccountingPettyCashClosureUpdateTable(this);
    pettyCashId = _i1.ColumnInt(
      'pettyCashId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    openingBalance = _i1.ColumnDouble(
      'openingBalance',
      this,
    );
    closingBalance = _i1.ColumnDouble(
      'closingBalance',
      this,
    );
    comments = _i1.ColumnString(
      'comments',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AccountingPettyCashClosureUpdateTable updateTable;

  late final _i1.ColumnInt pettyCashId;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnDouble openingBalance;

  late final _i1.ColumnDouble closingBalance;

  late final _i1.ColumnString comments;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    pettyCashId,
    date,
    openingBalance,
    closingBalance,
    comments,
    createdAt,
  ];
}

class AccountingPettyCashClosureInclude extends _i1.IncludeObject {
  AccountingPettyCashClosureInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingPettyCashClosure.t;
}

class AccountingPettyCashClosureIncludeList extends _i1.IncludeList {
  AccountingPettyCashClosureIncludeList._({
    _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingPettyCashClosure.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingPettyCashClosure.t;
}

class AccountingPettyCashClosureRepository {
  const AccountingPettyCashClosureRepository._();

  /// Returns a list of [AccountingPettyCashClosure]s matching the given query parameters.
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
  Future<List<AccountingPettyCashClosure>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashClosureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingPettyCashClosure>(
      where: where?.call(AccountingPettyCashClosure.t),
      orderBy: orderBy?.call(AccountingPettyCashClosure.t),
      orderByList: orderByList?.call(AccountingPettyCashClosure.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingPettyCashClosure] matching the given query parameters.
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
  Future<AccountingPettyCashClosure?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashClosureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingPettyCashClosure>(
      where: where?.call(AccountingPettyCashClosure.t),
      orderBy: orderBy?.call(AccountingPettyCashClosure.t),
      orderByList: orderByList?.call(AccountingPettyCashClosure.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingPettyCashClosure] by its [id] or null if no such row exists.
  Future<AccountingPettyCashClosure?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingPettyCashClosure>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingPettyCashClosure]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingPettyCashClosure]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingPettyCashClosure>> insert(
    _i1.DatabaseSession session,
    List<AccountingPettyCashClosure> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingPettyCashClosure>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingPettyCashClosure] and returns the inserted row.
  ///
  /// The returned [AccountingPettyCashClosure] will have its `id` field set.
  Future<AccountingPettyCashClosure> insertRow(
    _i1.DatabaseSession session,
    AccountingPettyCashClosure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingPettyCashClosure>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCashClosure]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingPettyCashClosure>> update(
    _i1.DatabaseSession session,
    List<AccountingPettyCashClosure> rows, {
    _i1.ColumnSelections<AccountingPettyCashClosureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingPettyCashClosure>(
      rows,
      columns: columns?.call(AccountingPettyCashClosure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCashClosure]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingPettyCashClosure> updateRow(
    _i1.DatabaseSession session,
    AccountingPettyCashClosure row, {
    _i1.ColumnSelections<AccountingPettyCashClosureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingPettyCashClosure>(
      row,
      columns: columns?.call(AccountingPettyCashClosure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCashClosure] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingPettyCashClosure?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingPettyCashClosureUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingPettyCashClosure>(
      id,
      columnValues: columnValues(AccountingPettyCashClosure.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCashClosure]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingPettyCashClosure>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingPettyCashClosureUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashClosureTable>? orderBy,
    _i1.OrderByListBuilder<AccountingPettyCashClosureTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingPettyCashClosure>(
      columnValues: columnValues(AccountingPettyCashClosure.t.updateTable),
      where: where(AccountingPettyCashClosure.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCashClosure.t),
      orderByList: orderByList?.call(AccountingPettyCashClosure.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingPettyCashClosure]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingPettyCashClosure>> delete(
    _i1.DatabaseSession session,
    List<AccountingPettyCashClosure> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingPettyCashClosure>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingPettyCashClosure].
  Future<AccountingPettyCashClosure> deleteRow(
    _i1.DatabaseSession session,
    AccountingPettyCashClosure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingPettyCashClosure>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingPettyCashClosure>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingPettyCashClosure>(
      where: where(AccountingPettyCashClosure.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingPettyCashClosure>(
      where: where?.call(AccountingPettyCashClosure.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingPettyCashClosure] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashClosureTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingPettyCashClosure>(
      where: where(AccountingPettyCashClosure.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
