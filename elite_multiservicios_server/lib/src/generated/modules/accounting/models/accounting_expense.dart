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

/// Gastos operativos y facturas de proveedores (Cuentas por Pagar).
abstract class AccountingExpense
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingExpense._({
    this.id,
    required this.supplierName,
    required this.date,
    required this.amount,
    this.costCenterId,
    required this.category,
    String? status,
    this.description,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending',
       isDeleted = isDeleted ?? false;

  factory AccountingExpense({
    int? id,
    required String supplierName,
    required DateTime date,
    required double amount,
    int? costCenterId,
    required String category,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingExpenseImpl;

  factory AccountingExpense.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingExpense(
      id: jsonSerialization['id'] as int?,
      supplierName: jsonSerialization['supplierName'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      costCenterId: jsonSerialization['costCenterId'] as int?,
      category: jsonSerialization['category'] as String,
      status: jsonSerialization['status'] as String?,
      description: jsonSerialization['description'] as String?,
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

  static final t = AccountingExpenseTable();

  static const db = AccountingExpenseRepository._();

  @override
  int? id;

  /// Nombre del proveedor.
  String supplierName;

  /// Fecha del gasto.
  DateTime date;

  /// Monto del gasto.
  double amount;

  /// ID del centro de costo al que se asigna (opcional).
  int? costCenterId;

  /// Categoría del gasto: Insumos, Nómina, Servicios, Transporte, etc.
  String category;

  /// Estado: Pending, Paid.
  String status;

  /// Notas o descripción.
  String? description;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingExpense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingExpense copyWith({
    int? id,
    String? supplierName,
    DateTime? date,
    double? amount,
    int? costCenterId,
    String? category,
    String? status,
    String? description,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingExpense',
      if (id != null) 'id': id,
      'supplierName': supplierName,
      'date': date.toJson(),
      'amount': amount,
      if (costCenterId != null) 'costCenterId': costCenterId,
      'category': category,
      'status': status,
      if (description != null) 'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingExpense',
      if (id != null) 'id': id,
      'supplierName': supplierName,
      'date': date.toJson(),
      'amount': amount,
      if (costCenterId != null) 'costCenterId': costCenterId,
      'category': category,
      'status': status,
      if (description != null) 'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AccountingExpenseInclude include() {
    return AccountingExpenseInclude._();
  }

  static AccountingExpenseIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingExpenseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExpenseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExpenseTable>? orderByList,
    AccountingExpenseInclude? include,
  }) {
    return AccountingExpenseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingExpense.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingExpense.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingExpenseImpl extends AccountingExpense {
  _AccountingExpenseImpl({
    int? id,
    required String supplierName,
    required DateTime date,
    required double amount,
    int? costCenterId,
    required String category,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         supplierName: supplierName,
         date: date,
         amount: amount,
         costCenterId: costCenterId,
         category: category,
         status: status,
         description: description,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingExpense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingExpense copyWith({
    Object? id = _Undefined,
    String? supplierName,
    DateTime? date,
    double? amount,
    Object? costCenterId = _Undefined,
    String? category,
    String? status,
    Object? description = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingExpense(
      id: id is int? ? id : this.id,
      supplierName: supplierName ?? this.supplierName,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      costCenterId: costCenterId is int? ? costCenterId : this.costCenterId,
      category: category ?? this.category,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AccountingExpenseUpdateTable
    extends _i1.UpdateTable<AccountingExpenseTable> {
  AccountingExpenseUpdateTable(super.table);

  _i1.ColumnValue<String, String> supplierName(String value) => _i1.ColumnValue(
    table.supplierName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<int, int> costCenterId(int? value) => _i1.ColumnValue(
    table.costCenterId,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
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

class AccountingExpenseTable extends _i1.Table<int?> {
  AccountingExpenseTable({super.tableRelation})
    : super(tableName: 'accounting_expense') {
    updateTable = AccountingExpenseUpdateTable(this);
    supplierName = _i1.ColumnString(
      'supplierName',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    costCenterId = _i1.ColumnInt(
      'costCenterId',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    description = _i1.ColumnString(
      'description',
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

  late final AccountingExpenseUpdateTable updateTable;

  /// Nombre del proveedor.
  late final _i1.ColumnString supplierName;

  /// Fecha del gasto.
  late final _i1.ColumnDateTime date;

  /// Monto del gasto.
  late final _i1.ColumnDouble amount;

  /// ID del centro de costo al que se asigna (opcional).
  late final _i1.ColumnInt costCenterId;

  /// Categoría del gasto: Insumos, Nómina, Servicios, Transporte, etc.
  late final _i1.ColumnString category;

  /// Estado: Pending, Paid.
  late final _i1.ColumnString status;

  /// Notas o descripción.
  late final _i1.ColumnString description;

  /// Eliminación lógica (Soft Delete).
  late final _i1.ColumnBool isDeleted;

  /// Fechas de auditoría.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    supplierName,
    date,
    amount,
    costCenterId,
    category,
    status,
    description,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class AccountingExpenseInclude extends _i1.IncludeObject {
  AccountingExpenseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingExpense.t;
}

class AccountingExpenseIncludeList extends _i1.IncludeList {
  AccountingExpenseIncludeList._({
    _i1.WhereExpressionBuilder<AccountingExpenseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingExpense.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingExpense.t;
}

class AccountingExpenseRepository {
  const AccountingExpenseRepository._();

  /// Returns a list of [AccountingExpense]s matching the given query parameters.
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
  Future<List<AccountingExpense>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExpenseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExpenseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExpenseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingExpense>(
      where: where?.call(AccountingExpense.t),
      orderBy: orderBy?.call(AccountingExpense.t),
      orderByList: orderByList?.call(AccountingExpense.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingExpense] matching the given query parameters.
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
  Future<AccountingExpense?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExpenseTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingExpenseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingExpenseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingExpense>(
      where: where?.call(AccountingExpense.t),
      orderBy: orderBy?.call(AccountingExpense.t),
      orderByList: orderByList?.call(AccountingExpense.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingExpense] by its [id] or null if no such row exists.
  Future<AccountingExpense?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingExpense>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingExpense]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingExpense]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingExpense>> insert(
    _i1.DatabaseSession session,
    List<AccountingExpense> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingExpense>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingExpense] and returns the inserted row.
  ///
  /// The returned [AccountingExpense] will have its `id` field set.
  Future<AccountingExpense> insertRow(
    _i1.DatabaseSession session,
    AccountingExpense row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingExpense>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingExpense]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingExpense>> update(
    _i1.DatabaseSession session,
    List<AccountingExpense> rows, {
    _i1.ColumnSelections<AccountingExpenseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingExpense>(
      rows,
      columns: columns?.call(AccountingExpense.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingExpense]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingExpense> updateRow(
    _i1.DatabaseSession session,
    AccountingExpense row, {
    _i1.ColumnSelections<AccountingExpenseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingExpense>(
      row,
      columns: columns?.call(AccountingExpense.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingExpense] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingExpense?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingExpenseUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingExpense>(
      id,
      columnValues: columnValues(AccountingExpense.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingExpense]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingExpense>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingExpenseUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingExpenseTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingExpenseTable>? orderBy,
    _i1.OrderByListBuilder<AccountingExpenseTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingExpense>(
      columnValues: columnValues(AccountingExpense.t.updateTable),
      where: where(AccountingExpense.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingExpense.t),
      orderByList: orderByList?.call(AccountingExpense.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingExpense]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingExpense>> delete(
    _i1.DatabaseSession session,
    List<AccountingExpense> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingExpense>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingExpense].
  Future<AccountingExpense> deleteRow(
    _i1.DatabaseSession session,
    AccountingExpense row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingExpense>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingExpense>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingExpenseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingExpense>(
      where: where(AccountingExpense.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingExpenseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingExpense>(
      where: where?.call(AccountingExpense.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingExpense] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingExpenseTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingExpense>(
      where: where(AccountingExpense.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
