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

/// Transacciones financieras (Ingresos y Egresos reales en banco o caja).
abstract class AccountingTransaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingTransaction._({
    this.id,
    required this.date,
    required this.amount,
    required this.type,
    this.referenceId,
    this.account,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isDeleted = isDeleted ?? false;

  factory AccountingTransaction({
    int? id,
    required DateTime date,
    required double amount,
    required String type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingTransactionImpl;

  factory AccountingTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingTransaction(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      referenceId: jsonSerialization['referenceId'] as int?,
      account: jsonSerialization['account'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AccountingTransactionTable();

  static const db = AccountingTransactionRepository._();

  @override
  int? id;

  /// Fecha de la transacción.
  DateTime date;

  /// Monto de la transacción.
  double amount;

  /// Tipo de transacción: Income (Ingreso), Expense (Egreso).
  String type;

  /// Referencia a ID de Factura (si es ingreso) o Gasto (si es egreso).
  int? referenceId;

  /// Origen/Destino de los fondos (ej. Cuenta Bancaria, Caja Chica).
  String? account;

  /// Notas adicionales.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingTransaction copyWith({
    int? id,
    DateTime? date,
    double? amount,
    String? type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingTransaction',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'amount': amount,
      'type': type,
      if (referenceId != null) 'referenceId': referenceId,
      if (account != null) 'account': account,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingTransaction',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'amount': amount,
      'type': type,
      if (referenceId != null) 'referenceId': referenceId,
      if (account != null) 'account': account,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AccountingTransactionInclude include() {
    return AccountingTransactionInclude._();
  }

  static AccountingTransactionIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTransactionTable>? orderByList,
    AccountingTransactionInclude? include,
  }) {
    return AccountingTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingTransaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingTransactionImpl extends AccountingTransaction {
  _AccountingTransactionImpl({
    int? id,
    required DateTime date,
    required double amount,
    required String type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         date: date,
         amount: amount,
         type: type,
         referenceId: referenceId,
         account: account,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingTransaction copyWith({
    Object? id = _Undefined,
    DateTime? date,
    double? amount,
    String? type,
    Object? referenceId = _Undefined,
    Object? account = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingTransaction(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      referenceId: referenceId is int? ? referenceId : this.referenceId,
      account: account is String? ? account : this.account,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AccountingTransactionUpdateTable
    extends _i1.UpdateTable<AccountingTransactionTable> {
  AccountingTransactionUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
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

  _i1.ColumnValue<int, int> referenceId(int? value) => _i1.ColumnValue(
    table.referenceId,
    value,
  );

  _i1.ColumnValue<String, String> account(String? value) => _i1.ColumnValue(
    table.account,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<bool, bool> isDeleted(bool value) => _i1.ColumnValue(
    table.isDeleted,
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

class AccountingTransactionTable extends _i1.Table<int?> {
  AccountingTransactionTable({super.tableRelation})
    : super(tableName: 'accounting_transaction') {
    updateTable = AccountingTransactionUpdateTable(this);
    date = _i1.ColumnDateTime(
      'date',
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
    referenceId = _i1.ColumnInt(
      'referenceId',
      this,
    );
    account = _i1.ColumnString(
      'account',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
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

  late final AccountingTransactionUpdateTable updateTable;

  /// Fecha de la transacción.
  late final _i1.ColumnDateTime date;

  /// Monto de la transacción.
  late final _i1.ColumnDouble amount;

  /// Tipo de transacción: Income (Ingreso), Expense (Egreso).
  late final _i1.ColumnString type;

  /// Referencia a ID de Factura (si es ingreso) o Gasto (si es egreso).
  late final _i1.ColumnInt referenceId;

  /// Origen/Destino de los fondos (ej. Cuenta Bancaria, Caja Chica).
  late final _i1.ColumnString account;

  /// Notas adicionales.
  late final _i1.ColumnString notes;

  /// Eliminación lógica (Soft Delete).
  late final _i1.ColumnBool isDeleted;

  /// Fechas de auditoría.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    date,
    amount,
    type,
    referenceId,
    account,
    notes,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class AccountingTransactionInclude extends _i1.IncludeObject {
  AccountingTransactionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingTransaction.t;
}

class AccountingTransactionIncludeList extends _i1.IncludeList {
  AccountingTransactionIncludeList._({
    _i1.WhereExpressionBuilder<AccountingTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingTransaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingTransaction.t;
}

class AccountingTransactionRepository {
  const AccountingTransactionRepository._();

  /// Returns a list of [AccountingTransaction]s matching the given query parameters.
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
  Future<List<AccountingTransaction>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingTransaction>(
      where: where?.call(AccountingTransaction.t),
      orderBy: orderBy?.call(AccountingTransaction.t),
      orderByList: orderByList?.call(AccountingTransaction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingTransaction] matching the given query parameters.
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
  Future<AccountingTransaction?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTransactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingTransaction>(
      where: where?.call(AccountingTransaction.t),
      orderBy: orderBy?.call(AccountingTransaction.t),
      orderByList: orderByList?.call(AccountingTransaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingTransaction] by its [id] or null if no such row exists.
  Future<AccountingTransaction?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingTransaction>> insert(
    _i1.DatabaseSession session,
    List<AccountingTransaction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingTransaction] and returns the inserted row.
  ///
  /// The returned [AccountingTransaction] will have its `id` field set.
  Future<AccountingTransaction> insertRow(
    _i1.DatabaseSession session,
    AccountingTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingTransaction>> update(
    _i1.DatabaseSession session,
    List<AccountingTransaction> rows, {
    _i1.ColumnSelections<AccountingTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingTransaction>(
      rows,
      columns: columns?.call(AccountingTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingTransaction> updateRow(
    _i1.DatabaseSession session,
    AccountingTransaction row, {
    _i1.ColumnSelections<AccountingTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingTransaction>(
      row,
      columns: columns?.call(AccountingTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingTransaction?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingTransactionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingTransaction>(
      id,
      columnValues: columnValues(AccountingTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingTransaction>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingTransactionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingTransactionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingTransactionTable>? orderBy,
    _i1.OrderByListBuilder<AccountingTransactionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingTransaction>(
      columnValues: columnValues(AccountingTransaction.t.updateTable),
      where: where(AccountingTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingTransaction.t),
      orderByList: orderByList?.call(AccountingTransaction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingTransaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingTransaction>> delete(
    _i1.DatabaseSession session,
    List<AccountingTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingTransaction].
  Future<AccountingTransaction> deleteRow(
    _i1.DatabaseSession session,
    AccountingTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingTransaction>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingTransactionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingTransaction>(
      where: where(AccountingTransaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingTransactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingTransaction>(
      where: where?.call(AccountingTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingTransactionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingTransaction>(
      where: where(AccountingTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
