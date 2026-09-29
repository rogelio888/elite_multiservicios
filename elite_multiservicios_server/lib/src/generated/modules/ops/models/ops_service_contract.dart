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

abstract class OpsServiceContract
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OpsServiceContract._({
    this.id,
    required this.customerId,
    required this.serviceType,
    required this.startDate,
    this.endDate,
    String? status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending';

  factory OpsServiceContract({
    int? id,
    required int customerId,
    required String serviceType,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    required double totalAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsServiceContractImpl;

  factory OpsServiceContract.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsServiceContract(
      id: jsonSerialization['id'] as int?,
      customerId: jsonSerialization['customerId'] as int,
      serviceType: jsonSerialization['serviceType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = OpsServiceContractTable();

  static const db = OpsServiceContractRepository._();

  @override
  int? id;

  int customerId;

  String serviceType;

  DateTime startDate;

  DateTime? endDate;

  String status;

  double totalAmount;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OpsServiceContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsServiceContract copyWith({
    int? id,
    int? customerId,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsServiceContract',
      if (id != null) 'id': id,
      'customerId': customerId,
      'serviceType': serviceType,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsServiceContract',
      if (id != null) 'id': id,
      'customerId': customerId,
      'serviceType': serviceType,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static OpsServiceContractInclude include() {
    return OpsServiceContractInclude._();
  }

  static OpsServiceContractIncludeList includeList({
    _i1.WhereExpressionBuilder<OpsServiceContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsServiceContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsServiceContractTable>? orderByList,
    OpsServiceContractInclude? include,
  }) {
    return OpsServiceContractIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsServiceContract.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OpsServiceContract.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsServiceContractImpl extends OpsServiceContract {
  _OpsServiceContractImpl({
    int? id,
    required int customerId,
    required String serviceType,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    required double totalAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         customerId: customerId,
         serviceType: serviceType,
         startDate: startDate,
         endDate: endDate,
         status: status,
         totalAmount: totalAmount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsServiceContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsServiceContract copyWith({
    Object? id = _Undefined,
    int? customerId,
    String? serviceType,
    DateTime? startDate,
    Object? endDate = _Undefined,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsServiceContract(
      id: id is int? ? id : this.id,
      customerId: customerId ?? this.customerId,
      serviceType: serviceType ?? this.serviceType,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OpsServiceContractUpdateTable
    extends _i1.UpdateTable<OpsServiceContractTable> {
  OpsServiceContractUpdateTable(super.table);

  _i1.ColumnValue<int, int> customerId(int value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> serviceType(String value) => _i1.ColumnValue(
    table.serviceType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> totalAmount(double value) => _i1.ColumnValue(
    table.totalAmount,
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

class OpsServiceContractTable extends _i1.Table<int?> {
  OpsServiceContractTable({super.tableRelation})
    : super(tableName: 'ops_service_contract') {
    updateTable = OpsServiceContractUpdateTable(this);
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    serviceType = _i1.ColumnString(
      'serviceType',
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
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
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

  late final OpsServiceContractUpdateTable updateTable;

  late final _i1.ColumnInt customerId;

  late final _i1.ColumnString serviceType;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble totalAmount;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    customerId,
    serviceType,
    startDate,
    endDate,
    status,
    totalAmount,
    createdAt,
    updatedAt,
  ];
}

class OpsServiceContractInclude extends _i1.IncludeObject {
  OpsServiceContractInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OpsServiceContract.t;
}

class OpsServiceContractIncludeList extends _i1.IncludeList {
  OpsServiceContractIncludeList._({
    _i1.WhereExpressionBuilder<OpsServiceContractTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OpsServiceContract.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OpsServiceContract.t;
}

class OpsServiceContractRepository {
  const OpsServiceContractRepository._();

  /// Returns a list of [OpsServiceContract]s matching the given query parameters.
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
  Future<List<OpsServiceContract>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsServiceContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsServiceContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsServiceContractTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OpsServiceContract>(
      where: where?.call(OpsServiceContract.t),
      orderBy: orderBy?.call(OpsServiceContract.t),
      orderByList: orderByList?.call(OpsServiceContract.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OpsServiceContract] matching the given query parameters.
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
  Future<OpsServiceContract?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsServiceContractTable>? where,
    int? offset,
    _i1.OrderByBuilder<OpsServiceContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OpsServiceContractTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OpsServiceContract>(
      where: where?.call(OpsServiceContract.t),
      orderBy: orderBy?.call(OpsServiceContract.t),
      orderByList: orderByList?.call(OpsServiceContract.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OpsServiceContract] by its [id] or null if no such row exists.
  Future<OpsServiceContract?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OpsServiceContract>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OpsServiceContract]s in the list and returns the inserted rows.
  ///
  /// The returned [OpsServiceContract]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OpsServiceContract>> insert(
    _i1.DatabaseSession session,
    List<OpsServiceContract> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OpsServiceContract>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OpsServiceContract] and returns the inserted row.
  ///
  /// The returned [OpsServiceContract] will have its `id` field set.
  Future<OpsServiceContract> insertRow(
    _i1.DatabaseSession session,
    OpsServiceContract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OpsServiceContract>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OpsServiceContract]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OpsServiceContract>> update(
    _i1.DatabaseSession session,
    List<OpsServiceContract> rows, {
    _i1.ColumnSelections<OpsServiceContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OpsServiceContract>(
      rows,
      columns: columns?.call(OpsServiceContract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsServiceContract]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OpsServiceContract> updateRow(
    _i1.DatabaseSession session,
    OpsServiceContract row, {
    _i1.ColumnSelections<OpsServiceContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OpsServiceContract>(
      row,
      columns: columns?.call(OpsServiceContract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OpsServiceContract] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OpsServiceContract?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OpsServiceContractUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OpsServiceContract>(
      id,
      columnValues: columnValues(OpsServiceContract.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OpsServiceContract]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OpsServiceContract>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OpsServiceContractUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OpsServiceContractTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OpsServiceContractTable>? orderBy,
    _i1.OrderByListBuilder<OpsServiceContractTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OpsServiceContract>(
      columnValues: columnValues(OpsServiceContract.t.updateTable),
      where: where(OpsServiceContract.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OpsServiceContract.t),
      orderByList: orderByList?.call(OpsServiceContract.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OpsServiceContract]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OpsServiceContract>> delete(
    _i1.DatabaseSession session,
    List<OpsServiceContract> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OpsServiceContract>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OpsServiceContract].
  Future<OpsServiceContract> deleteRow(
    _i1.DatabaseSession session,
    OpsServiceContract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OpsServiceContract>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OpsServiceContract>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsServiceContractTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OpsServiceContract>(
      where: where(OpsServiceContract.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OpsServiceContractTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OpsServiceContract>(
      where: where?.call(OpsServiceContract.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OpsServiceContract] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OpsServiceContractTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OpsServiceContract>(
      where: where(OpsServiceContract.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
