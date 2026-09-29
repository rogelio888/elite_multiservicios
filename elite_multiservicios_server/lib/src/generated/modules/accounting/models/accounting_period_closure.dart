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

/// Registro y control de Cierres de Periodo Contable (Mes / Año) y Bloqueo de Modificaciones.
abstract class AccountingPeriodClosure
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingPeriodClosure._({
    this.id,
    required this.periodName,
    required this.periodType,
    required this.startDate,
    required this.endDate,
    String? status,
    required this.totalIncome,
    required this.totalExpense,
    required this.netResult,
    this.closedBy,
    required this.closedAt,
    this.closureNotes,
    bool? isLocked,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'CLOSED',
       isLocked = isLocked ?? true;

  factory AccountingPeriodClosure({
    int? id,
    required String periodName,
    required String periodType,
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    required double totalIncome,
    required double totalExpense,
    required double netResult,
    String? closedBy,
    required DateTime closedAt,
    String? closureNotes,
    bool? isLocked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingPeriodClosureImpl;

  factory AccountingPeriodClosure.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPeriodClosure(
      id: jsonSerialization['id'] as int?,
      periodName: jsonSerialization['periodName'] as String,
      periodType: jsonSerialization['periodType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      totalIncome: (jsonSerialization['totalIncome'] as num).toDouble(),
      totalExpense: (jsonSerialization['totalExpense'] as num).toDouble(),
      netResult: (jsonSerialization['netResult'] as num).toDouble(),
      closedBy: jsonSerialization['closedBy'] as String?,
      closedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['closedAt'],
      ),
      closureNotes: jsonSerialization['closureNotes'] as String?,
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AccountingPeriodClosureTable();

  static const db = AccountingPeriodClosureRepository._();

  @override
  int? id;

  /// Nombre del periodo (ej. "Septiembre 2026", "Cierre Anual 2025").
  String periodName;

  /// Tipo de periodo: MONTHLY, ANNUAL.
  String periodType;

  /// Fecha de inicio del periodo contable.
  DateTime startDate;

  /// Fecha de fin del periodo contable.
  DateTime endDate;

  /// Estado: CLOSED, AUDITED, REOPENED.
  String status;

  /// Total de ingresos reconocidos en el periodo.
  double totalIncome;

  /// Total de egresos/gastos en el periodo.
  double totalExpense;

  /// Resultado neto del ejercicio (Utilidad o Pérdida).
  double netResult;

  /// Usuario que ejecutó el cierre.
  String? closedBy;

  /// Fecha y hora exacta de ejecución del cierre.
  DateTime closedAt;

  /// Notas u observaciones del cierre.
  String? closureNotes;

  /// Bloqueo activo para impedir crear/editar transacciones en el rango de fechas.
  bool isLocked;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingPeriodClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPeriodClosure copyWith({
    int? id,
    String? periodName,
    String? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalIncome,
    double? totalExpense,
    double? netResult,
    String? closedBy,
    DateTime? closedAt,
    String? closureNotes,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPeriodClosure',
      if (id != null) 'id': id,
      'periodName': periodName,
      'periodType': periodType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'status': status,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netResult': netResult,
      if (closedBy != null) 'closedBy': closedBy,
      'closedAt': closedAt.toJson(),
      if (closureNotes != null) 'closureNotes': closureNotes,
      'isLocked': isLocked,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingPeriodClosure',
      if (id != null) 'id': id,
      'periodName': periodName,
      'periodType': periodType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'status': status,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netResult': netResult,
      if (closedBy != null) 'closedBy': closedBy,
      'closedAt': closedAt.toJson(),
      if (closureNotes != null) 'closureNotes': closureNotes,
      'isLocked': isLocked,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AccountingPeriodClosureInclude include() {
    return AccountingPeriodClosureInclude._();
  }

  static AccountingPeriodClosureIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingPeriodClosureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPeriodClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPeriodClosureTable>? orderByList,
    AccountingPeriodClosureInclude? include,
  }) {
    return AccountingPeriodClosureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPeriodClosure.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingPeriodClosure.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPeriodClosureImpl extends AccountingPeriodClosure {
  _AccountingPeriodClosureImpl({
    int? id,
    required String periodName,
    required String periodType,
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    required double totalIncome,
    required double totalExpense,
    required double netResult,
    String? closedBy,
    required DateTime closedAt,
    String? closureNotes,
    bool? isLocked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         periodName: periodName,
         periodType: periodType,
         startDate: startDate,
         endDate: endDate,
         status: status,
         totalIncome: totalIncome,
         totalExpense: totalExpense,
         netResult: netResult,
         closedBy: closedBy,
         closedAt: closedAt,
         closureNotes: closureNotes,
         isLocked: isLocked,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingPeriodClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPeriodClosure copyWith({
    Object? id = _Undefined,
    String? periodName,
    String? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalIncome,
    double? totalExpense,
    double? netResult,
    Object? closedBy = _Undefined,
    DateTime? closedAt,
    Object? closureNotes = _Undefined,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingPeriodClosure(
      id: id is int? ? id : this.id,
      periodName: periodName ?? this.periodName,
      periodType: periodType ?? this.periodType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netResult: netResult ?? this.netResult,
      closedBy: closedBy is String? ? closedBy : this.closedBy,
      closedAt: closedAt ?? this.closedAt,
      closureNotes: closureNotes is String? ? closureNotes : this.closureNotes,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AccountingPeriodClosureUpdateTable
    extends _i1.UpdateTable<AccountingPeriodClosureTable> {
  AccountingPeriodClosureUpdateTable(super.table);

  _i1.ColumnValue<String, String> periodName(String value) => _i1.ColumnValue(
    table.periodName,
    value,
  );

  _i1.ColumnValue<String, String> periodType(String value) => _i1.ColumnValue(
    table.periodType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> totalIncome(double value) => _i1.ColumnValue(
    table.totalIncome,
    value,
  );

  _i1.ColumnValue<double, double> totalExpense(double value) => _i1.ColumnValue(
    table.totalExpense,
    value,
  );

  _i1.ColumnValue<double, double> netResult(double value) => _i1.ColumnValue(
    table.netResult,
    value,
  );

  _i1.ColumnValue<String, String> closedBy(String? value) => _i1.ColumnValue(
    table.closedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> closedAt(DateTime value) =>
      _i1.ColumnValue(
        table.closedAt,
        value,
      );

  _i1.ColumnValue<String, String> closureNotes(String? value) =>
      _i1.ColumnValue(
        table.closureNotes,
        value,
      );

  _i1.ColumnValue<bool, bool> isLocked(bool value) => _i1.ColumnValue(
    table.isLocked,
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

class AccountingPeriodClosureTable extends _i1.Table<int?> {
  AccountingPeriodClosureTable({super.tableRelation})
    : super(tableName: 'accounting_period_closure') {
    updateTable = AccountingPeriodClosureUpdateTable(this);
    periodName = _i1.ColumnString(
      'periodName',
      this,
    );
    periodType = _i1.ColumnString(
      'periodType',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    totalIncome = _i1.ColumnDouble(
      'totalIncome',
      this,
    );
    totalExpense = _i1.ColumnDouble(
      'totalExpense',
      this,
    );
    netResult = _i1.ColumnDouble(
      'netResult',
      this,
    );
    closedBy = _i1.ColumnString(
      'closedBy',
      this,
    );
    closedAt = _i1.ColumnDateTime(
      'closedAt',
      this,
    );
    closureNotes = _i1.ColumnString(
      'closureNotes',
      this,
    );
    isLocked = _i1.ColumnBool(
      'isLocked',
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

  late final AccountingPeriodClosureUpdateTable updateTable;

  /// Nombre del periodo (ej. "Septiembre 2026", "Cierre Anual 2025").
  late final _i1.ColumnString periodName;

  /// Tipo de periodo: MONTHLY, ANNUAL.
  late final _i1.ColumnString periodType;

  /// Fecha de inicio del periodo contable.
  late final _i1.ColumnDateTime startDate;

  /// Fecha de fin del periodo contable.
  late final _i1.ColumnDateTime endDate;

  /// Estado: CLOSED, AUDITED, REOPENED.
  late final _i1.ColumnString status;

  /// Total de ingresos reconocidos en el periodo.
  late final _i1.ColumnDouble totalIncome;

  /// Total de egresos/gastos en el periodo.
  late final _i1.ColumnDouble totalExpense;

  /// Resultado neto del ejercicio (Utilidad o Pérdida).
  late final _i1.ColumnDouble netResult;

  /// Usuario que ejecutó el cierre.
  late final _i1.ColumnString closedBy;

  /// Fecha y hora exacta de ejecución del cierre.
  late final _i1.ColumnDateTime closedAt;

  /// Notas u observaciones del cierre.
  late final _i1.ColumnString closureNotes;

  /// Bloqueo activo para impedir crear/editar transacciones en el rango de fechas.
  late final _i1.ColumnBool isLocked;

  /// Fechas de auditoría.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    periodName,
    periodType,
    startDate,
    endDate,
    status,
    totalIncome,
    totalExpense,
    netResult,
    closedBy,
    closedAt,
    closureNotes,
    isLocked,
    createdAt,
    updatedAt,
  ];
}

class AccountingPeriodClosureInclude extends _i1.IncludeObject {
  AccountingPeriodClosureInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingPeriodClosure.t;
}

class AccountingPeriodClosureIncludeList extends _i1.IncludeList {
  AccountingPeriodClosureIncludeList._({
    _i1.WhereExpressionBuilder<AccountingPeriodClosureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingPeriodClosure.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingPeriodClosure.t;
}

class AccountingPeriodClosureRepository {
  const AccountingPeriodClosureRepository._();

  /// Returns a list of [AccountingPeriodClosure]s matching the given query parameters.
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
  Future<List<AccountingPeriodClosure>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPeriodClosureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPeriodClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPeriodClosureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingPeriodClosure>(
      where: where?.call(AccountingPeriodClosure.t),
      orderBy: orderBy?.call(AccountingPeriodClosure.t),
      orderByList: orderByList?.call(AccountingPeriodClosure.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingPeriodClosure] matching the given query parameters.
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
  Future<AccountingPeriodClosure?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPeriodClosureTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingPeriodClosureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingPeriodClosureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingPeriodClosure>(
      where: where?.call(AccountingPeriodClosure.t),
      orderBy: orderBy?.call(AccountingPeriodClosure.t),
      orderByList: orderByList?.call(AccountingPeriodClosure.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingPeriodClosure] by its [id] or null if no such row exists.
  Future<AccountingPeriodClosure?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingPeriodClosure>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingPeriodClosure]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingPeriodClosure]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingPeriodClosure>> insert(
    _i1.DatabaseSession session,
    List<AccountingPeriodClosure> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingPeriodClosure>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingPeriodClosure] and returns the inserted row.
  ///
  /// The returned [AccountingPeriodClosure] will have its `id` field set.
  Future<AccountingPeriodClosure> insertRow(
    _i1.DatabaseSession session,
    AccountingPeriodClosure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingPeriodClosure>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPeriodClosure]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingPeriodClosure>> update(
    _i1.DatabaseSession session,
    List<AccountingPeriodClosure> rows, {
    _i1.ColumnSelections<AccountingPeriodClosureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingPeriodClosure>(
      rows,
      columns: columns?.call(AccountingPeriodClosure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPeriodClosure]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingPeriodClosure> updateRow(
    _i1.DatabaseSession session,
    AccountingPeriodClosure row, {
    _i1.ColumnSelections<AccountingPeriodClosureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingPeriodClosure>(
      row,
      columns: columns?.call(AccountingPeriodClosure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingPeriodClosure] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingPeriodClosure?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingPeriodClosureUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingPeriodClosure>(
      id,
      columnValues: columnValues(AccountingPeriodClosure.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingPeriodClosure]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingPeriodClosure>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingPeriodClosureUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingPeriodClosureTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingPeriodClosureTable>? orderBy,
    _i1.OrderByListBuilder<AccountingPeriodClosureTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingPeriodClosure>(
      columnValues: columnValues(AccountingPeriodClosure.t.updateTable),
      where: where(AccountingPeriodClosure.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingPeriodClosure.t),
      orderByList: orderByList?.call(AccountingPeriodClosure.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingPeriodClosure]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingPeriodClosure>> delete(
    _i1.DatabaseSession session,
    List<AccountingPeriodClosure> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingPeriodClosure>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingPeriodClosure].
  Future<AccountingPeriodClosure> deleteRow(
    _i1.DatabaseSession session,
    AccountingPeriodClosure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingPeriodClosure>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingPeriodClosure>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPeriodClosureTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingPeriodClosure>(
      where: where(AccountingPeriodClosure.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingPeriodClosureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingPeriodClosure>(
      where: where?.call(AccountingPeriodClosure.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingPeriodClosure] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingPeriodClosureTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingPeriodClosure>(
      where: where(AccountingPeriodClosure.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
