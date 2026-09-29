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

abstract class HrPayroll
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HrPayroll._({
    this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.baseSalary,
    double? bonuses,
    double? deductions,
    required this.netPay,
    bool? isPaid,
    this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
  }) : bonuses = bonuses ?? 0.0,
       deductions = deductions ?? 0.0,
       isPaid = isPaid ?? false;

  factory HrPayroll({
    int? id,
    required int employeeId,
    required int month,
    required int year,
    required double baseSalary,
    double? bonuses,
    double? deductions,
    required double netPay,
    bool? isPaid,
    DateTime? paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrPayrollImpl;

  factory HrPayroll.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrPayroll(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      bonuses: (jsonSerialization['bonuses'] as num?)?.toDouble(),
      deductions: (jsonSerialization['deductions'] as num?)?.toDouble(),
      netPay: (jsonSerialization['netPay'] as num).toDouble(),
      isPaid: jsonSerialization['isPaid'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPaid']),
      paymentDate: jsonSerialization['paymentDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['paymentDate'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = HrPayrollTable();

  static const db = HrPayrollRepository._();

  @override
  int? id;

  int employeeId;

  int month;

  int year;

  double baseSalary;

  double bonuses;

  double deductions;

  double netPay;

  bool isPaid;

  DateTime? paymentDate;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HrPayroll]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrPayroll copyWith({
    int? id,
    int? employeeId,
    int? month,
    int? year,
    double? baseSalary,
    double? bonuses,
    double? deductions,
    double? netPay,
    bool? isPaid,
    DateTime? paymentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrPayroll',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'deductions': deductions,
      'netPay': netPay,
      'isPaid': isPaid,
      if (paymentDate != null) 'paymentDate': paymentDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HrPayroll',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'deductions': deductions,
      'netPay': netPay,
      'isPaid': isPaid,
      if (paymentDate != null) 'paymentDate': paymentDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static HrPayrollInclude include() {
    return HrPayrollInclude._();
  }

  static HrPayrollIncludeList includeList({
    _i1.WhereExpressionBuilder<HrPayrollTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrPayrollTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrPayrollTable>? orderByList,
    HrPayrollInclude? include,
  }) {
    return HrPayrollIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrPayroll.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HrPayroll.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HrPayrollImpl extends HrPayroll {
  _HrPayrollImpl({
    int? id,
    required int employeeId,
    required int month,
    required int year,
    required double baseSalary,
    double? bonuses,
    double? deductions,
    required double netPay,
    bool? isPaid,
    DateTime? paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         month: month,
         year: year,
         baseSalary: baseSalary,
         bonuses: bonuses,
         deductions: deductions,
         netPay: netPay,
         isPaid: isPaid,
         paymentDate: paymentDate,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrPayroll]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrPayroll copyWith({
    Object? id = _Undefined,
    int? employeeId,
    int? month,
    int? year,
    double? baseSalary,
    double? bonuses,
    double? deductions,
    double? netPay,
    bool? isPaid,
    Object? paymentDate = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrPayroll(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      month: month ?? this.month,
      year: year ?? this.year,
      baseSalary: baseSalary ?? this.baseSalary,
      bonuses: bonuses ?? this.bonuses,
      deductions: deductions ?? this.deductions,
      netPay: netPay ?? this.netPay,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate is DateTime? ? paymentDate : this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HrPayrollUpdateTable extends _i1.UpdateTable<HrPayrollTable> {
  HrPayrollUpdateTable(super.table);

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
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

  _i1.ColumnValue<double, double> baseSalary(double value) => _i1.ColumnValue(
    table.baseSalary,
    value,
  );

  _i1.ColumnValue<double, double> bonuses(double value) => _i1.ColumnValue(
    table.bonuses,
    value,
  );

  _i1.ColumnValue<double, double> deductions(double value) => _i1.ColumnValue(
    table.deductions,
    value,
  );

  _i1.ColumnValue<double, double> netPay(double value) => _i1.ColumnValue(
    table.netPay,
    value,
  );

  _i1.ColumnValue<bool, bool> isPaid(bool value) => _i1.ColumnValue(
    table.isPaid,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> paymentDate(DateTime? value) =>
      _i1.ColumnValue(
        table.paymentDate,
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

class HrPayrollTable extends _i1.Table<int?> {
  HrPayrollTable({super.tableRelation}) : super(tableName: 'hr_payroll') {
    updateTable = HrPayrollUpdateTable(this);
    employeeId = _i1.ColumnInt(
      'employeeId',
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
    baseSalary = _i1.ColumnDouble(
      'baseSalary',
      this,
    );
    bonuses = _i1.ColumnDouble(
      'bonuses',
      this,
      hasDefault: true,
    );
    deductions = _i1.ColumnDouble(
      'deductions',
      this,
      hasDefault: true,
    );
    netPay = _i1.ColumnDouble(
      'netPay',
      this,
    );
    isPaid = _i1.ColumnBool(
      'isPaid',
      this,
      hasDefault: true,
    );
    paymentDate = _i1.ColumnDateTime(
      'paymentDate',
      this,
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

  late final HrPayrollUpdateTable updateTable;

  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnInt month;

  late final _i1.ColumnInt year;

  late final _i1.ColumnDouble baseSalary;

  late final _i1.ColumnDouble bonuses;

  late final _i1.ColumnDouble deductions;

  late final _i1.ColumnDouble netPay;

  late final _i1.ColumnBool isPaid;

  late final _i1.ColumnDateTime paymentDate;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    employeeId,
    month,
    year,
    baseSalary,
    bonuses,
    deductions,
    netPay,
    isPaid,
    paymentDate,
    createdAt,
    updatedAt,
  ];
}

class HrPayrollInclude extends _i1.IncludeObject {
  HrPayrollInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HrPayroll.t;
}

class HrPayrollIncludeList extends _i1.IncludeList {
  HrPayrollIncludeList._({
    _i1.WhereExpressionBuilder<HrPayrollTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HrPayroll.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HrPayroll.t;
}

class HrPayrollRepository {
  const HrPayrollRepository._();

  /// Returns a list of [HrPayroll]s matching the given query parameters.
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
  Future<List<HrPayroll>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrPayrollTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrPayrollTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrPayrollTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HrPayroll>(
      where: where?.call(HrPayroll.t),
      orderBy: orderBy?.call(HrPayroll.t),
      orderByList: orderByList?.call(HrPayroll.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HrPayroll] matching the given query parameters.
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
  Future<HrPayroll?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrPayrollTable>? where,
    int? offset,
    _i1.OrderByBuilder<HrPayrollTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrPayrollTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HrPayroll>(
      where: where?.call(HrPayroll.t),
      orderBy: orderBy?.call(HrPayroll.t),
      orderByList: orderByList?.call(HrPayroll.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HrPayroll] by its [id] or null if no such row exists.
  Future<HrPayroll?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HrPayroll>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HrPayroll]s in the list and returns the inserted rows.
  ///
  /// The returned [HrPayroll]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HrPayroll>> insert(
    _i1.DatabaseSession session,
    List<HrPayroll> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HrPayroll>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HrPayroll] and returns the inserted row.
  ///
  /// The returned [HrPayroll] will have its `id` field set.
  Future<HrPayroll> insertRow(
    _i1.DatabaseSession session,
    HrPayroll row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HrPayroll>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HrPayroll]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HrPayroll>> update(
    _i1.DatabaseSession session,
    List<HrPayroll> rows, {
    _i1.ColumnSelections<HrPayrollTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HrPayroll>(
      rows,
      columns: columns?.call(HrPayroll.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrPayroll]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HrPayroll> updateRow(
    _i1.DatabaseSession session,
    HrPayroll row, {
    _i1.ColumnSelections<HrPayrollTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HrPayroll>(
      row,
      columns: columns?.call(HrPayroll.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrPayroll] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HrPayroll?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HrPayrollUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HrPayroll>(
      id,
      columnValues: columnValues(HrPayroll.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HrPayroll]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HrPayroll>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HrPayrollUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<HrPayrollTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrPayrollTable>? orderBy,
    _i1.OrderByListBuilder<HrPayrollTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HrPayroll>(
      columnValues: columnValues(HrPayroll.t.updateTable),
      where: where(HrPayroll.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrPayroll.t),
      orderByList: orderByList?.call(HrPayroll.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HrPayroll]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HrPayroll>> delete(
    _i1.DatabaseSession session,
    List<HrPayroll> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HrPayroll>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HrPayroll].
  Future<HrPayroll> deleteRow(
    _i1.DatabaseSession session,
    HrPayroll row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HrPayroll>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HrPayroll>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrPayrollTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HrPayroll>(
      where: where(HrPayroll.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrPayrollTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HrPayroll>(
      where: where?.call(HrPayroll.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HrPayroll] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrPayrollTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HrPayroll>(
      where: where(HrPayroll.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
