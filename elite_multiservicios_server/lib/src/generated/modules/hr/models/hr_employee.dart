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

abstract class HrEmployee
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HrEmployee._({
    this.id,
    required this.name,
    required this.position,
    required this.baseSalary,
    required this.joinDate,
    bool? isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true;

  factory HrEmployee({
    int? id,
    required String name,
    required String position,
    required double baseSalary,
    required DateTime joinDate,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrEmployeeImpl;

  factory HrEmployee.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      position: jsonSerialization['position'] as String,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      joinDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinDate'],
      ),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = HrEmployeeTable();

  static const db = HrEmployeeRepository._();

  @override
  int? id;

  String name;

  String position;

  double baseSalary;

  DateTime joinDate;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HrEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrEmployee copyWith({
    int? id,
    String? name,
    String? position,
    double? baseSalary,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrEmployee',
      if (id != null) 'id': id,
      'name': name,
      'position': position,
      'baseSalary': baseSalary,
      'joinDate': joinDate.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HrEmployee',
      if (id != null) 'id': id,
      'name': name,
      'position': position,
      'baseSalary': baseSalary,
      'joinDate': joinDate.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static HrEmployeeInclude include() {
    return HrEmployeeInclude._();
  }

  static HrEmployeeIncludeList includeList({
    _i1.WhereExpressionBuilder<HrEmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrEmployeeTable>? orderByList,
    HrEmployeeInclude? include,
  }) {
    return HrEmployeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrEmployee.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HrEmployee.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HrEmployeeImpl extends HrEmployee {
  _HrEmployeeImpl({
    int? id,
    required String name,
    required String position,
    required double baseSalary,
    required DateTime joinDate,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         position: position,
         baseSalary: baseSalary,
         joinDate: joinDate,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    String? position,
    double? baseSalary,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      baseSalary: baseSalary ?? this.baseSalary,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HrEmployeeUpdateTable extends _i1.UpdateTable<HrEmployeeTable> {
  HrEmployeeUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> position(String value) => _i1.ColumnValue(
    table.position,
    value,
  );

  _i1.ColumnValue<double, double> baseSalary(double value) => _i1.ColumnValue(
    table.baseSalary,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> joinDate(DateTime value) =>
      _i1.ColumnValue(
        table.joinDate,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
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

class HrEmployeeTable extends _i1.Table<int?> {
  HrEmployeeTable({super.tableRelation}) : super(tableName: 'hr_employee') {
    updateTable = HrEmployeeUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    position = _i1.ColumnString(
      'position',
      this,
    );
    baseSalary = _i1.ColumnDouble(
      'baseSalary',
      this,
    );
    joinDate = _i1.ColumnDateTime(
      'joinDate',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
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

  late final HrEmployeeUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString position;

  late final _i1.ColumnDouble baseSalary;

  late final _i1.ColumnDateTime joinDate;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    position,
    baseSalary,
    joinDate,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class HrEmployeeInclude extends _i1.IncludeObject {
  HrEmployeeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HrEmployee.t;
}

class HrEmployeeIncludeList extends _i1.IncludeList {
  HrEmployeeIncludeList._({
    _i1.WhereExpressionBuilder<HrEmployeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HrEmployee.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HrEmployee.t;
}

class HrEmployeeRepository {
  const HrEmployeeRepository._();

  /// Returns a list of [HrEmployee]s matching the given query parameters.
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
  Future<List<HrEmployee>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrEmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrEmployeeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HrEmployee>(
      where: where?.call(HrEmployee.t),
      orderBy: orderBy?.call(HrEmployee.t),
      orderByList: orderByList?.call(HrEmployee.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HrEmployee] matching the given query parameters.
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
  Future<HrEmployee?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrEmployeeTable>? where,
    int? offset,
    _i1.OrderByBuilder<HrEmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HrEmployeeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HrEmployee>(
      where: where?.call(HrEmployee.t),
      orderBy: orderBy?.call(HrEmployee.t),
      orderByList: orderByList?.call(HrEmployee.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HrEmployee] by its [id] or null if no such row exists.
  Future<HrEmployee?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HrEmployee>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HrEmployee]s in the list and returns the inserted rows.
  ///
  /// The returned [HrEmployee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HrEmployee>> insert(
    _i1.DatabaseSession session,
    List<HrEmployee> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HrEmployee>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HrEmployee] and returns the inserted row.
  ///
  /// The returned [HrEmployee] will have its `id` field set.
  Future<HrEmployee> insertRow(
    _i1.DatabaseSession session,
    HrEmployee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HrEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HrEmployee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HrEmployee>> update(
    _i1.DatabaseSession session,
    List<HrEmployee> rows, {
    _i1.ColumnSelections<HrEmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HrEmployee>(
      rows,
      columns: columns?.call(HrEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrEmployee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HrEmployee> updateRow(
    _i1.DatabaseSession session,
    HrEmployee row, {
    _i1.ColumnSelections<HrEmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HrEmployee>(
      row,
      columns: columns?.call(HrEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HrEmployee] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HrEmployee?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HrEmployeeUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HrEmployee>(
      id,
      columnValues: columnValues(HrEmployee.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HrEmployee]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HrEmployee>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HrEmployeeUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<HrEmployeeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HrEmployeeTable>? orderBy,
    _i1.OrderByListBuilder<HrEmployeeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HrEmployee>(
      columnValues: columnValues(HrEmployee.t.updateTable),
      where: where(HrEmployee.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HrEmployee.t),
      orderByList: orderByList?.call(HrEmployee.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HrEmployee]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HrEmployee>> delete(
    _i1.DatabaseSession session,
    List<HrEmployee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HrEmployee>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HrEmployee].
  Future<HrEmployee> deleteRow(
    _i1.DatabaseSession session,
    HrEmployee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HrEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HrEmployee>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrEmployeeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HrEmployee>(
      where: where(HrEmployee.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HrEmployeeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HrEmployee>(
      where: where?.call(HrEmployee.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HrEmployee] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HrEmployeeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HrEmployee>(
      where: where(HrEmployee.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
