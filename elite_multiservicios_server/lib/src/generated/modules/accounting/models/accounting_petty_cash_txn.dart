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

abstract class AccountingPettyCashTransaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingPettyCashTransaction._({
    this.id,
    required this.pettyCashId,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.hasInvoice,
    required this.isFixedPayment,
    this.fiscalCredit,
    this.fiscalDebit,
  });

  factory AccountingPettyCashTransaction({
    int? id,
    required int pettyCashId,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required bool hasInvoice,
    required bool isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  }) = _AccountingPettyCashTransactionImpl;

  factory AccountingPettyCashTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPettyCashTransaction(
      id: jsonSerialization['id'] as int?,
      pettyCashId: jsonSerialization['pettyCashId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      hasInvoice: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasInvoice'],
      ),
      isFixedPayment: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFixedPayment'],
      ),
      fiscalCredit: (jsonSerialization['fiscalCredit'] as num?)?.toDouble(),
      fiscalDebit: (jsonSerialization['fiscalDebit'] as num?)?.toDouble(),
    );
  }

  static final t = AccountingPettyCashTransactionTable();

  static const db = AccountingPettyCashTransactionRepository._();

  @override
  int? id;

  int pettyCashId;

  double amount;

  String type;

  String description;

  DateTime date;

  bool hasInvoice;

  bool isFixedPayment;

  double? fiscalCredit;

  double? fiscalDebit;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingPettyCashTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCashTransaction copyWith({
    int? id,
    int? pettyCashId,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    bool? hasInvoice,
    bool? isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCashTransaction',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toJson(),
      'hasInvoice': hasInvoice,
      'isFixedPayment': isFixedPayment,
      if (fiscalCredit != null) 'fiscalCredit': fiscalCredit,
      if (fiscalDebit != null) 'fiscalDebit': fiscalDebit,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingPettyCashTransaction',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toJson(),
      'hasInvoice': hasInvoice,
      'isFixedPayment': isFixedPayment,
      if (fiscalCredit != null) 'fiscalCredit': fiscalCredit,
      if (fiscalDebit != null) 'fiscalDebit': fiscalDebit,
    };
  }

  static AccountingPettyCashTransactionInclude include() {
    return AccountingPettyCashTransactionInclude._();
  }

  static AccountingPettyCashTransactionIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTransactionTable>? orderByList,
    AccountingPettyCashTransactionInclude? include,
  }) {
    return AccountingPettyCashTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCashTransaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingPettyCashTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashTransactionImpl
    extends AccountingPettyCashTransaction {
  _AccountingPettyCashTransactionImpl({
    int? id,
    required int pettyCashId,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required bool hasInvoice,
    required bool isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  }) : super._(
         id: id,
         pettyCashId: pettyCashId,
         amount: amount,
         type: type,
         description: description,
         date: date,
         hasInvoice: hasInvoice,
         isFixedPayment: isFixedPayment,
         fiscalCredit: fiscalCredit,
         fiscalDebit: fiscalDebit,
       );

  /// Returns a shallow copy of this [AccountingPettyCashTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCashTransaction copyWith({
    Object? id = _Undefined,
    int? pettyCashId,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    bool? hasInvoice,
    bool? isFixedPayment,
    Object? fiscalCredit = _Undefined,
    Object? fiscalDebit = _Undefined,
  }) {
    return AccountingPettyCashTransaction(
      id: id is int? ? id : this.id,
      pettyCashId: pettyCashId ?? this.pettyCashId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      hasInvoice: hasInvoice ?? this.hasInvoice,
      isFixedPayment: isFixedPayment ?? this.isFixedPayment,
      fiscalCredit: fiscalCredit is double? ? fiscalCredit : this.fiscalCredit,
      fiscalDebit: fiscalDebit is double? ? fiscalDebit : this.fiscalDebit,
    );
  }
}

class AccountingPettyCashTransactionUpdateTable
    extends _i1.UpdateTable<AccountingPettyCashTransactionTable> {
  AccountingPettyCashTransactionUpdateTable(super.table);

  _i1.ColumnValue<int, int> pettyCashId(int value) => _i1.ColumnValue(
    table.pettyCashId,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<bool, bool> hasInvoice(bool value) => _i1.ColumnValue(
    table.hasInvoice,
    value,
  );

  _i1.ColumnValue<bool, bool> isFixedPayment(bool value) => _i1.ColumnValue(
    table.isFixedPayment,
    value,
  );

  _i1.ColumnValue<double, double> fiscalCredit(double? value) =>
      _i1.ColumnValue(
        table.fiscalCredit,
        value,
      );

  _i1.ColumnValue<double, double> fiscalDebit(double? value) => _i1.ColumnValue(
    table.fiscalDebit,
    value,
  );
}

class AccountingPettyCashTransactionTable extends _i1.Table<int?> {
  AccountingPettyCashTransactionTable({super.tableRelation})
    : super(tableName: 'accounting_petty_cash_txn') {
    updateTable = AccountingPettyCashTransactionUpdateTable(this);
    pettyCashId = _i1.ColumnInt(
      'pettyCashId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    hasInvoice = _i1.ColumnBool(
      'hasInvoice',
      this,
    );
    isFixedPayment = _i1.ColumnBool(
      'isFixedPayment',
      this,
    );
    fiscalCredit = _i1.ColumnDouble(
      'fiscalCredit',
      this,
    );
    fiscalDebit = _i1.ColumnDouble(
      'fiscalDebit',
      this,
    );
  }

  late final AccountingPettyCashTransactionUpdateTable updateTable;

  late final _i1.ColumnInt pettyCashId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString type;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnBool hasInvoice;

  late final _i1.ColumnBool isFixedPayment;

  late final _i1.ColumnDouble fiscalCredit;

  late final _i1.ColumnDouble fiscalDebit;

  @override
  List<_i1.Column> get columns => [
    id,
    pettyCashId,
    amount,
    type,
    description,
    date,
    hasInvoice,
    isFixedPayment,
    fiscalCredit,
    fiscalDebit,
  ];
}

class AccountingPettyCashTransactionInclude extends _i1.IncludeObject {
  AccountingPettyCashTransactionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingPettyCashTransaction.t;
}

class AccountingPettyCashTransactionIncludeList extends _i1.IncludeList {
  AccountingPettyCashTransactionIncludeList._({
    _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingPettyCashTransaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingPettyCashTransaction.t;
}

class AccountingPettyCashTransactionRepository {
  const AccountingPettyCashTransactionRepository._();

  /// Returns a list of [AccountingPettyCashTransaction]s matching the given query parameters.
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
  Future<List<AccountingPettyCashTransaction>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingPettyCashTransaction>(
      where: where?.call(AccountingPettyCashTransaction.t),
      orderBy: orderBy?.call(AccountingPettyCashTransaction.t),
      orderByList: orderByList?.call(AccountingPettyCashTransaction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingPettyCashTransaction] matching the given query parameters.
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
  Future<AccountingPettyCashTransaction?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPettyCashTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingPettyCashTransaction>(
      where: where?.call(AccountingPettyCashTransaction.t),
      orderBy: orderBy?.call(AccountingPettyCashTransaction.t),
      orderByList: orderByList?.call(AccountingPettyCashTransaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingPettyCashTransaction] by its [id] or null if no such row exists.
  Future<AccountingPettyCashTransaction?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingPettyCashTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingPettyCashTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingPettyCashTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingPettyCashTransaction>> insert(
    _i1.DatabaseSession session,
    List<AccountingPettyCashTransaction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingPettyCashTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingPettyCashTransaction] and returns the inserted row.
  ///
  /// The returned [AccountingPettyCashTransaction] will have its `id` field set.
  Future<AccountingPettyCashTransaction> insertRow(
    _i1.DatabaseSession session,
    AccountingPettyCashTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingPettyCashTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCashTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingPettyCashTransaction>> update(
    _i1.DatabaseSession session,
    List<AccountingPettyCashTransaction> rows, {
    _i1.ColumnSelections<AccountingPettyCashTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingPettyCashTransaction>(
      rows,
      columns: columns?.call(AccountingPettyCashTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCashTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingPettyCashTransaction> updateRow(
    _i1.DatabaseSession session,
    AccountingPettyCashTransaction row, {
    _i1.ColumnSelections<AccountingPettyCashTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingPettyCashTransaction>(
      row,
      columns: columns?.call(AccountingPettyCashTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPettyCashTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingPettyCashTransaction?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<
      AccountingPettyCashTransactionUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingPettyCashTransaction>(
      id,
      columnValues: columnValues(AccountingPettyCashTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPettyCashTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingPettyCashTransaction>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      AccountingPettyCashTransactionUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPettyCashTransactionTable>? orderBy,
    _i1.OrderByListBuilder<AccountingPettyCashTransactionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingPettyCashTransaction>(
      columnValues: columnValues(AccountingPettyCashTransaction.t.updateTable),
      where: where(AccountingPettyCashTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPettyCashTransaction.t),
      orderByList: orderByList?.call(AccountingPettyCashTransaction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingPettyCashTransaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingPettyCashTransaction>> delete(
    _i1.DatabaseSession session,
    List<AccountingPettyCashTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingPettyCashTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingPettyCashTransaction].
  Future<AccountingPettyCashTransaction> deleteRow(
    _i1.DatabaseSession session,
    AccountingPettyCashTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingPettyCashTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingPettyCashTransaction>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingPettyCashTransaction>(
      where: where(AccountingPettyCashTransaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingPettyCashTransaction>(
      where: where?.call(AccountingPettyCashTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingPettyCashTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPettyCashTransactionTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingPettyCashTransaction>(
      where: where(AccountingPettyCashTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
