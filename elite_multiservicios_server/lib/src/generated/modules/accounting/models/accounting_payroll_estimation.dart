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

abstract class AccountingPayrollEstimation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingPayrollEstimation._({
    this.id,
    required this.userId,
    required this.baseSalary,
    required this.bonuses,
    required this.estimatedTotal,
    required this.month,
    required this.year,
  });

  factory AccountingPayrollEstimation({
    int? id,
    required int userId,
    required double baseSalary,
    required double bonuses,
    required double estimatedTotal,
    required int month,
    required int year,
  }) = _AccountingPayrollEstimationImpl;

  factory AccountingPayrollEstimation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPayrollEstimation(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      bonuses: (jsonSerialization['bonuses'] as num).toDouble(),
      estimatedTotal: (jsonSerialization['estimatedTotal'] as num).toDouble(),
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
    );
  }

  static final t = AccountingPayrollEstimationTable();

  static const db = AccountingPayrollEstimationRepository._();

  @override
  int? id;

  int userId;

  double baseSalary;

  double bonuses;

  double estimatedTotal;

  int month;

  int year;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingPayrollEstimation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPayrollEstimation copyWith({
    int? id,
    int? userId,
    double? baseSalary,
    double? bonuses,
    double? estimatedTotal,
    int? month,
    int? year,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPayrollEstimation',
      if (id != null) 'id': id,
      'userId': userId,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'estimatedTotal': estimatedTotal,
      'month': month,
      'year': year,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingPayrollEstimation',
      if (id != null) 'id': id,
      'userId': userId,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'estimatedTotal': estimatedTotal,
      'month': month,
      'year': year,
    };
  }

  static AccountingPayrollEstimationInclude include() {
    return AccountingPayrollEstimationInclude._();
  }

  static AccountingPayrollEstimationIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPayrollEstimationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPayrollEstimationTable>? orderByList,
    AccountingPayrollEstimationInclude? include,
  }) {
    return AccountingPayrollEstimationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPayrollEstimation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingPayrollEstimation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPayrollEstimationImpl extends AccountingPayrollEstimation {
  _AccountingPayrollEstimationImpl({
    int? id,
    required int userId,
    required double baseSalary,
    required double bonuses,
    required double estimatedTotal,
    required int month,
    required int year,
  }) : super._(
         id: id,
         userId: userId,
         baseSalary: baseSalary,
         bonuses: bonuses,
         estimatedTotal: estimatedTotal,
         month: month,
         year: year,
       );

  /// Returns a shallow copy of this [AccountingPayrollEstimation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPayrollEstimation copyWith({
    Object? id = _Undefined,
    int? userId,
    double? baseSalary,
    double? bonuses,
    double? estimatedTotal,
    int? month,
    int? year,
  }) {
    return AccountingPayrollEstimation(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      baseSalary: baseSalary ?? this.baseSalary,
      bonuses: bonuses ?? this.bonuses,
      estimatedTotal: estimatedTotal ?? this.estimatedTotal,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}

class AccountingPayrollEstimationUpdateTable
    extends _i1.UpdateTable<AccountingPayrollEstimationTable> {
  AccountingPayrollEstimationUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<double, double> baseSalary(double value) => _i1.ColumnValue(
    table.baseSalary,
    value,
  );

  _i1.ColumnValue<double, double> bonuses(double value) => _i1.ColumnValue(
    table.bonuses,
    value,
  );

  _i1.ColumnValue<double, double> estimatedTotal(double value) =>
      _i1.ColumnValue(
        table.estimatedTotal,
        value,
      );

  _i1.ColumnValue<int, int> month(int value) => _i1.ColumnValue(
    table.month,
    value,
  );

  _i1.ColumnValue<int, int> year(int value) => _i1.ColumnValue(
    table.year,
    value,
  );
}

class AccountingPayrollEstimationTable extends _i1.Table<int?> {
  AccountingPayrollEstimationTable({super.tableRelation})
    : super(tableName: 'accounting_payroll_est') {
    updateTable = AccountingPayrollEstimationUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    baseSalary = _i1.ColumnDouble(
      'baseSalary',
      this,
    );
    bonuses = _i1.ColumnDouble(
      'bonuses',
      this,
    );
    estimatedTotal = _i1.ColumnDouble(
      'estimatedTotal',
      this,
    );
    month = _i1.ColumnInt(
      'month',
      this,
    );
    year = _i1.ColumnInt(
      'year',
      this,
    );
  }

  late final AccountingPayrollEstimationUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnDouble baseSalary;

  late final _i1.ColumnDouble bonuses;

  late final _i1.ColumnDouble estimatedTotal;

  late final _i1.ColumnInt month;

  late final _i1.ColumnInt year;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    baseSalary,
    bonuses,
    estimatedTotal,
    month,
    year,
  ];
}

class AccountingPayrollEstimationInclude extends _i1.IncludeObject {
  AccountingPayrollEstimationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingPayrollEstimation.t;
}

class AccountingPayrollEstimationIncludeList extends _i1.IncludeList {
  AccountingPayrollEstimationIncludeList._({
    _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingPayrollEstimation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingPayrollEstimation.t;
}

class AccountingPayrollEstimationRepository {
  const AccountingPayrollEstimationRepository._();

  /// Returns a list of [AccountingPayrollEstimation]s matching the given query parameters.
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
  Future<List<AccountingPayrollEstimation>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPayrollEstimationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPayrollEstimationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingPayrollEstimation>(
      where: where?.call(AccountingPayrollEstimation.t),
      orderBy: orderBy?.call(AccountingPayrollEstimation.t),
      orderByList: orderByList?.call(AccountingPayrollEstimation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingPayrollEstimation] matching the given query parameters.
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
  Future<AccountingPayrollEstimation?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingPayrollEstimationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPayrollEstimationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingPayrollEstimation>(
      where: where?.call(AccountingPayrollEstimation.t),
      orderBy: orderBy?.call(AccountingPayrollEstimation.t),
      orderByList: orderByList?.call(AccountingPayrollEstimation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingPayrollEstimation] by its [id] or null if no such row exists.
  Future<AccountingPayrollEstimation?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingPayrollEstimation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingPayrollEstimation]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingPayrollEstimation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingPayrollEstimation>> insert(
    _i1.DatabaseSession session,
    List<AccountingPayrollEstimation> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingPayrollEstimation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingPayrollEstimation] and returns the inserted row.
  ///
  /// The returned [AccountingPayrollEstimation] will have its `id` field set.
  Future<AccountingPayrollEstimation> insertRow(
    _i1.DatabaseSession session,
    AccountingPayrollEstimation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingPayrollEstimation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPayrollEstimation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingPayrollEstimation>> update(
    _i1.DatabaseSession session,
    List<AccountingPayrollEstimation> rows, {
    _i1.ColumnSelections<AccountingPayrollEstimationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingPayrollEstimation>(
      rows,
      columns: columns?.call(AccountingPayrollEstimation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPayrollEstimation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingPayrollEstimation> updateRow(
    _i1.DatabaseSession session,
    AccountingPayrollEstimation row, {
    _i1.ColumnSelections<AccountingPayrollEstimationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingPayrollEstimation>(
      row,
      columns: columns?.call(AccountingPayrollEstimation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPayrollEstimation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingPayrollEstimation?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingPayrollEstimationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingPayrollEstimation>(
      id,
      columnValues: columnValues(AccountingPayrollEstimation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPayrollEstimation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingPayrollEstimation>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingPayrollEstimationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPayrollEstimationTable>? orderBy,
    _i1.OrderByListBuilder<AccountingPayrollEstimationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingPayrollEstimation>(
      columnValues: columnValues(AccountingPayrollEstimation.t.updateTable),
      where: where(AccountingPayrollEstimation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPayrollEstimation.t),
      orderByList: orderByList?.call(AccountingPayrollEstimation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingPayrollEstimation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingPayrollEstimation>> delete(
    _i1.DatabaseSession session,
    List<AccountingPayrollEstimation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingPayrollEstimation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingPayrollEstimation].
  Future<AccountingPayrollEstimation> deleteRow(
    _i1.DatabaseSession session,
    AccountingPayrollEstimation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingPayrollEstimation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingPayrollEstimation>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingPayrollEstimation>(
      where: where(AccountingPayrollEstimation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingPayrollEstimation>(
      where: where?.call(AccountingPayrollEstimation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingPayrollEstimation] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPayrollEstimationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingPayrollEstimation>(
      where: where(AccountingPayrollEstimation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
