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

abstract class AccountingBudget
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingBudget._({
    this.id,
    required this.month,
    required this.year,
    required this.projectedIncome,
    required this.executedIncome,
    required this.projectedExpenses,
    required this.executedExpenses,
    required this.estimatedBalance,
  });

  factory AccountingBudget({
    int? id,
    required int month,
    required int year,
    required double projectedIncome,
    required double executedIncome,
    required double projectedExpenses,
    required double executedExpenses,
    required double estimatedBalance,
  }) = _AccountingBudgetImpl;

  factory AccountingBudget.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingBudget(
      id: jsonSerialization['id'] as int?,
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
      projectedIncome: (jsonSerialization['projectedIncome'] as num).toDouble(),
      executedIncome: (jsonSerialization['executedIncome'] as num).toDouble(),
      projectedExpenses: (jsonSerialization['projectedExpenses'] as num)
          .toDouble(),
      executedExpenses: (jsonSerialization['executedExpenses'] as num)
          .toDouble(),
      estimatedBalance: (jsonSerialization['estimatedBalance'] as num)
          .toDouble(),
    );
  }

  static final t = AccountingBudgetTable();

  static const db = AccountingBudgetRepository._();

  @override
  int? id;

  int month;

  int year;

  double projectedIncome;

  double executedIncome;

  double projectedExpenses;

  double executedExpenses;

  double estimatedBalance;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingBudget]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingBudget copyWith({
    int? id,
    int? month,
    int? year,
    double? projectedIncome,
    double? executedIncome,
    double? projectedExpenses,
    double? executedExpenses,
    double? estimatedBalance,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingBudget',
      if (id != null) 'id': id,
      'month': month,
      'year': year,
      'projectedIncome': projectedIncome,
      'executedIncome': executedIncome,
      'projectedExpenses': projectedExpenses,
      'executedExpenses': executedExpenses,
      'estimatedBalance': estimatedBalance,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingBudget',
      if (id != null) 'id': id,
      'month': month,
      'year': year,
      'projectedIncome': projectedIncome,
      'executedIncome': executedIncome,
      'projectedExpenses': projectedExpenses,
      'executedExpenses': executedExpenses,
      'estimatedBalance': estimatedBalance,
    };
  }

  static AccountingBudgetInclude include() {
    return AccountingBudgetInclude._();
  }

  static AccountingBudgetIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingBudgetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingBudgetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingBudgetTable>? orderByList,
    AccountingBudgetInclude? include,
  }) {
    return AccountingBudgetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingBudget.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingBudget.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingBudgetImpl extends AccountingBudget {
  _AccountingBudgetImpl({
    int? id,
    required int month,
    required int year,
    required double projectedIncome,
    required double executedIncome,
    required double projectedExpenses,
    required double executedExpenses,
    required double estimatedBalance,
  }) : super._(
         id: id,
         month: month,
         year: year,
         projectedIncome: projectedIncome,
         executedIncome: executedIncome,
         projectedExpenses: projectedExpenses,
         executedExpenses: executedExpenses,
         estimatedBalance: estimatedBalance,
       );

  /// Returns a shallow copy of this [AccountingBudget]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingBudget copyWith({
    Object? id = _Undefined,
    int? month,
    int? year,
    double? projectedIncome,
    double? executedIncome,
    double? projectedExpenses,
    double? executedExpenses,
    double? estimatedBalance,
  }) {
    return AccountingBudget(
      id: id is int? ? id : this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      projectedIncome: projectedIncome ?? this.projectedIncome,
      executedIncome: executedIncome ?? this.executedIncome,
      projectedExpenses: projectedExpenses ?? this.projectedExpenses,
      executedExpenses: executedExpenses ?? this.executedExpenses,
      estimatedBalance: estimatedBalance ?? this.estimatedBalance,
    );
  }
}

class AccountingBudgetUpdateTable
    extends _i1.UpdateTable<AccountingBudgetTable> {
  AccountingBudgetUpdateTable(super.table);

  _i1.ColumnValue<int, int> month(int value) => _i1.ColumnValue(
    table.month,
    value,
  );

  _i1.ColumnValue<int, int> year(int value) => _i1.ColumnValue(
    table.year,
    value,
  );

  _i1.ColumnValue<double, double> projectedIncome(double value) =>
      _i1.ColumnValue(
        table.projectedIncome,
        value,
      );

  _i1.ColumnValue<double, double> executedIncome(double value) =>
      _i1.ColumnValue(
        table.executedIncome,
        value,
      );

  _i1.ColumnValue<double, double> projectedExpenses(double value) =>
      _i1.ColumnValue(
        table.projectedExpenses,
        value,
      );

  _i1.ColumnValue<double, double> executedExpenses(double value) =>
      _i1.ColumnValue(
        table.executedExpenses,
        value,
      );

  _i1.ColumnValue<double, double> estimatedBalance(double value) =>
      _i1.ColumnValue(
        table.estimatedBalance,
        value,
      );
}

class AccountingBudgetTable extends _i1.Table<int?> {
  AccountingBudgetTable({super.tableRelation})
    : super(tableName: 'accounting_budget') {
    updateTable = AccountingBudgetUpdateTable(this);
    month = _i1.ColumnInt(
      'month',
      this,
    );
    year = _i1.ColumnInt(
      'year',
      this,
    );
    projectedIncome = _i1.ColumnDouble(
      'projectedIncome',
      this,
    );
    executedIncome = _i1.ColumnDouble(
      'executedIncome',
      this,
    );
    projectedExpenses = _i1.ColumnDouble(
      'projectedExpenses',
      this,
    );
    executedExpenses = _i1.ColumnDouble(
      'executedExpenses',
      this,
    );
    estimatedBalance = _i1.ColumnDouble(
      'estimatedBalance',
      this,
    );
  }

  late final AccountingBudgetUpdateTable updateTable;

  late final _i1.ColumnInt month;

  late final _i1.ColumnInt year;

  late final _i1.ColumnDouble projectedIncome;

  late final _i1.ColumnDouble executedIncome;

  late final _i1.ColumnDouble projectedExpenses;

  late final _i1.ColumnDouble executedExpenses;

  late final _i1.ColumnDouble estimatedBalance;

  @override
  List<_i1.Column> get columns => [
    id,
    month,
    year,
    projectedIncome,
    executedIncome,
    projectedExpenses,
    executedExpenses,
    estimatedBalance,
  ];
}

class AccountingBudgetInclude extends _i1.IncludeObject {
  AccountingBudgetInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingBudget.t;
}

class AccountingBudgetIncludeList extends _i1.IncludeList {
  AccountingBudgetIncludeList._({
    _i1.WhereExpressionBuilder<AccountingBudgetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingBudget.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingBudget.t;
}

class AccountingBudgetRepository {
  const AccountingBudgetRepository._();

  /// Returns a list of [AccountingBudget]s matching the given query parameters.
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
  Future<List<AccountingBudget>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingBudgetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingBudgetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingBudgetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingBudget>(
      where: where?.call(AccountingBudget.t),
      orderBy: orderBy?.call(AccountingBudget.t),
      orderByList: orderByList?.call(AccountingBudget.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingBudget] matching the given query parameters.
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
  Future<AccountingBudget?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingBudgetTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingBudgetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingBudgetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingBudget>(
      where: where?.call(AccountingBudget.t),
      orderBy: orderBy?.call(AccountingBudget.t),
      orderByList: orderByList?.call(AccountingBudget.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingBudget] by its [id] or null if no such row exists.
  Future<AccountingBudget?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingBudget>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingBudget]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingBudget]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingBudget>> insert(
    _i1.DatabaseSession session,
    List<AccountingBudget> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingBudget>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingBudget] and returns the inserted row.
  ///
  /// The returned [AccountingBudget] will have its `id` field set.
  Future<AccountingBudget> insertRow(
    _i1.DatabaseSession session,
    AccountingBudget row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingBudget>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingBudget]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingBudget>> update(
    _i1.DatabaseSession session,
    List<AccountingBudget> rows, {
    _i1.ColumnSelections<AccountingBudgetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingBudget>(
      rows,
      columns: columns?.call(AccountingBudget.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingBudget]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingBudget> updateRow(
    _i1.DatabaseSession session,
    AccountingBudget row, {
    _i1.ColumnSelections<AccountingBudgetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingBudget>(
      row,
      columns: columns?.call(AccountingBudget.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingBudget] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingBudget?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingBudgetUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingBudget>(
      id,
      columnValues: columnValues(AccountingBudget.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingBudget]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingBudget>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingBudgetUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingBudgetTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingBudgetTable>? orderBy,
    _i1.OrderByListBuilder<AccountingBudgetTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingBudget>(
      columnValues: columnValues(AccountingBudget.t.updateTable),
      where: where(AccountingBudget.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingBudget.t),
      orderByList: orderByList?.call(AccountingBudget.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingBudget]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingBudget>> delete(
    _i1.DatabaseSession session,
    List<AccountingBudget> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingBudget>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingBudget].
  Future<AccountingBudget> deleteRow(
    _i1.DatabaseSession session,
    AccountingBudget row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingBudget>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingBudget>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingBudgetTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingBudget>(
      where: where(AccountingBudget.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingBudgetTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingBudget>(
      where: where?.call(AccountingBudget.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingBudget] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingBudgetTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingBudget>(
      where: where(AccountingBudget.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
