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

/// Factura emitida a clientes (Cuentas por Cobrar).
abstract class AccountingInvoice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingInvoice._({
    this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.issueDate,
    required this.dueDate,
    required this.totalAmount,
    String? status,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending',
       isDeleted = isDeleted ?? false;

  factory AccountingInvoice({
    int? id,
    required String invoiceNumber,
    required int customerId,
    required DateTime issueDate,
    required DateTime dueDate,
    required double totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingInvoiceImpl;

  factory AccountingInvoice.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingInvoice(
      id: jsonSerialization['id'] as int?,
      invoiceNumber: jsonSerialization['invoiceNumber'] as String,
      customerId: jsonSerialization['customerId'] as int,
      issueDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['issueDate'],
      ),
      dueDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      status: jsonSerialization['status'] as String?,
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

  static final t = AccountingInvoiceTable();

  static const db = AccountingInvoiceRepository._();

  @override
  int? id;

  /// Número de factura.
  String invoiceNumber;

  /// Referencia al cliente en el módulo CRM.
  int customerId;

  /// Fecha de emisión.
  DateTime issueDate;

  /// Fecha de vencimiento.
  DateTime dueDate;

  /// Monto total de la factura.
  double totalAmount;

  /// Estado: Pending, Paid, Cancelled, Overdue.
  String status;

  /// Notas adicionales.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingInvoice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingInvoice copyWith({
    int? id,
    String? invoiceNumber,
    int? customerId,
    DateTime? issueDate,
    DateTime? dueDate,
    double? totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingInvoice',
      if (id != null) 'id': id,
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'issueDate': issueDate.toJson(),
      'dueDate': dueDate.toJson(),
      'totalAmount': totalAmount,
      'status': status,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingInvoice',
      if (id != null) 'id': id,
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'issueDate': issueDate.toJson(),
      'dueDate': dueDate.toJson(),
      'totalAmount': totalAmount,
      'status': status,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AccountingInvoiceInclude include() {
    return AccountingInvoiceInclude._();
  }

  static AccountingInvoiceIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingInvoiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingInvoiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingInvoiceTable>? orderByList,
    AccountingInvoiceInclude? include,
  }) {
    return AccountingInvoiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingInvoice.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingInvoice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingInvoiceImpl extends AccountingInvoice {
  _AccountingInvoiceImpl({
    int? id,
    required String invoiceNumber,
    required int customerId,
    required DateTime issueDate,
    required DateTime dueDate,
    required double totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         invoiceNumber: invoiceNumber,
         customerId: customerId,
         issueDate: issueDate,
         dueDate: dueDate,
         totalAmount: totalAmount,
         status: status,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingInvoice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingInvoice copyWith({
    Object? id = _Undefined,
    String? invoiceNumber,
    int? customerId,
    DateTime? issueDate,
    DateTime? dueDate,
    double? totalAmount,
    String? status,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingInvoice(
      id: id is int? ? id : this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AccountingInvoiceUpdateTable
    extends _i1.UpdateTable<AccountingInvoiceTable> {
  AccountingInvoiceUpdateTable(super.table);

  _i1.ColumnValue<String, String> invoiceNumber(String value) =>
      _i1.ColumnValue(
        table.invoiceNumber,
        value,
      );

  _i1.ColumnValue<int, int> customerId(int value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> issueDate(DateTime value) =>
      _i1.ColumnValue(
        table.issueDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dueDate(DateTime value) =>
      _i1.ColumnValue(
        table.dueDate,
        value,
      );

  _i1.ColumnValue<double, double> totalAmount(double value) => _i1.ColumnValue(
    table.totalAmount,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

class AccountingInvoiceTable extends _i1.Table<int?> {
  AccountingInvoiceTable({super.tableRelation})
    : super(tableName: 'accounting_invoice') {
    updateTable = AccountingInvoiceUpdateTable(this);
    invoiceNumber = _i1.ColumnString(
      'invoiceNumber',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    issueDate = _i1.ColumnDateTime(
      'issueDate',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
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

  late final AccountingInvoiceUpdateTable updateTable;

  /// Número de factura.
  late final _i1.ColumnString invoiceNumber;

  /// Referencia al cliente en el módulo CRM.
  late final _i1.ColumnInt customerId;

  /// Fecha de emisión.
  late final _i1.ColumnDateTime issueDate;

  /// Fecha de vencimiento.
  late final _i1.ColumnDateTime dueDate;

  /// Monto total de la factura.
  late final _i1.ColumnDouble totalAmount;

  /// Estado: Pending, Paid, Cancelled, Overdue.
  late final _i1.ColumnString status;

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
    invoiceNumber,
    customerId,
    issueDate,
    dueDate,
    totalAmount,
    status,
    notes,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class AccountingInvoiceInclude extends _i1.IncludeObject {
  AccountingInvoiceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingInvoice.t;
}

class AccountingInvoiceIncludeList extends _i1.IncludeList {
  AccountingInvoiceIncludeList._({
    _i1.WhereExpressionBuilder<AccountingInvoiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingInvoice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingInvoice.t;
}

class AccountingInvoiceRepository {
  const AccountingInvoiceRepository._();

  /// Returns a list of [AccountingInvoice]s matching the given query parameters.
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
  Future<List<AccountingInvoice>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingInvoiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingInvoiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingInvoiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingInvoice>(
      where: where?.call(AccountingInvoice.t),
      orderBy: orderBy?.call(AccountingInvoice.t),
      orderByList: orderByList?.call(AccountingInvoice.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingInvoice] matching the given query parameters.
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
  Future<AccountingInvoice?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingInvoiceTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingInvoiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingInvoiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingInvoice>(
      where: where?.call(AccountingInvoice.t),
      orderBy: orderBy?.call(AccountingInvoice.t),
      orderByList: orderByList?.call(AccountingInvoice.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingInvoice] by its [id] or null if no such row exists.
  Future<AccountingInvoice?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingInvoice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingInvoice]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingInvoice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingInvoice>> insert(
    _i1.DatabaseSession session,
    List<AccountingInvoice> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingInvoice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingInvoice] and returns the inserted row.
  ///
  /// The returned [AccountingInvoice] will have its `id` field set.
  Future<AccountingInvoice> insertRow(
    _i1.DatabaseSession session,
    AccountingInvoice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingInvoice>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingInvoice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingInvoice>> update(
    _i1.DatabaseSession session,
    List<AccountingInvoice> rows, {
    _i1.ColumnSelections<AccountingInvoiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingInvoice>(
      rows,
      columns: columns?.call(AccountingInvoice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingInvoice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingInvoice> updateRow(
    _i1.DatabaseSession session,
    AccountingInvoice row, {
    _i1.ColumnSelections<AccountingInvoiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingInvoice>(
      row,
      columns: columns?.call(AccountingInvoice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingInvoice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingInvoice?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingInvoiceUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingInvoice>(
      id,
      columnValues: columnValues(AccountingInvoice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingInvoice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingInvoice>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingInvoiceUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingInvoiceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingInvoiceTable>? orderBy,
    _i1.OrderByListBuilder<AccountingInvoiceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingInvoice>(
      columnValues: columnValues(AccountingInvoice.t.updateTable),
      where: where(AccountingInvoice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingInvoice.t),
      orderByList: orderByList?.call(AccountingInvoice.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingInvoice]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingInvoice>> delete(
    _i1.DatabaseSession session,
    List<AccountingInvoice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingInvoice>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingInvoice].
  Future<AccountingInvoice> deleteRow(
    _i1.DatabaseSession session,
    AccountingInvoice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingInvoice>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingInvoice>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingInvoiceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingInvoice>(
      where: where(AccountingInvoice.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingInvoiceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingInvoice>(
      where: where?.call(AccountingInvoice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingInvoice] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingInvoiceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingInvoice>(
      where: where(AccountingInvoice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
