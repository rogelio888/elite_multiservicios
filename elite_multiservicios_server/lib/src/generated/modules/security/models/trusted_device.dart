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

abstract class TrustedDevice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TrustedDevice._({
    this.id,
    required this.userId,
    required this.deviceToken,
    this.deviceInfo,
    this.ipAddress,
    required this.expiresAt,
    required this.createdAt,
  });

  factory TrustedDevice({
    int? id,
    required int userId,
    required String deviceToken,
    String? deviceInfo,
    String? ipAddress,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _TrustedDeviceImpl;

  factory TrustedDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return TrustedDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      deviceToken: jsonSerialization['deviceToken'] as String,
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TrustedDeviceTable();

  static const db = TrustedDeviceRepository._();

  @override
  int? id;

  int userId;

  String deviceToken;

  String? deviceInfo;

  String? ipAddress;

  DateTime expiresAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TrustedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TrustedDevice copyWith({
    int? id,
    int? userId,
    String? deviceToken,
    String? deviceInfo,
    String? ipAddress,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TrustedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceToken': deviceToken,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TrustedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceToken': deviceToken,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static TrustedDeviceInclude include() {
    return TrustedDeviceInclude._();
  }

  static TrustedDeviceIncludeList includeList({
    _i1.WhereExpressionBuilder<TrustedDeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrustedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrustedDeviceTable>? orderByList,
    TrustedDeviceInclude? include,
  }) {
    return TrustedDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TrustedDevice.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TrustedDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrustedDeviceImpl extends TrustedDevice {
  _TrustedDeviceImpl({
    int? id,
    required int userId,
    required String deviceToken,
    String? deviceInfo,
    String? ipAddress,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         deviceToken: deviceToken,
         deviceInfo: deviceInfo,
         ipAddress: ipAddress,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TrustedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TrustedDevice copyWith({
    Object? id = _Undefined,
    int? userId,
    String? deviceToken,
    Object? deviceInfo = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return TrustedDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TrustedDeviceUpdateTable extends _i1.UpdateTable<TrustedDeviceTable> {
  TrustedDeviceUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> deviceToken(String value) => _i1.ColumnValue(
    table.deviceToken,
    value,
  );

  _i1.ColumnValue<String, String> deviceInfo(String? value) => _i1.ColumnValue(
    table.deviceInfo,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TrustedDeviceTable extends _i1.Table<int?> {
  TrustedDeviceTable({super.tableRelation})
    : super(tableName: 'trusted_device') {
    updateTable = TrustedDeviceUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    deviceToken = _i1.ColumnString(
      'deviceToken',
      this,
    );
    deviceInfo = _i1.ColumnString(
      'deviceInfo',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TrustedDeviceUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString deviceToken;

  late final _i1.ColumnString deviceInfo;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    deviceToken,
    deviceInfo,
    ipAddress,
    expiresAt,
    createdAt,
  ];
}

class TrustedDeviceInclude extends _i1.IncludeObject {
  TrustedDeviceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TrustedDevice.t;
}

class TrustedDeviceIncludeList extends _i1.IncludeList {
  TrustedDeviceIncludeList._({
    _i1.WhereExpressionBuilder<TrustedDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TrustedDevice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TrustedDevice.t;
}

class TrustedDeviceRepository {
  const TrustedDeviceRepository._();

  /// Returns a list of [TrustedDevice]s matching the given query parameters.
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
  Future<List<TrustedDevice>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TrustedDeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrustedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrustedDeviceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TrustedDevice>(
      where: where?.call(TrustedDevice.t),
      orderBy: orderBy?.call(TrustedDevice.t),
      orderByList: orderByList?.call(TrustedDevice.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TrustedDevice] matching the given query parameters.
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
  Future<TrustedDevice?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TrustedDeviceTable>? where,
    int? offset,
    _i1.OrderByBuilder<TrustedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrustedDeviceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TrustedDevice>(
      where: where?.call(TrustedDevice.t),
      orderBy: orderBy?.call(TrustedDevice.t),
      orderByList: orderByList?.call(TrustedDevice.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TrustedDevice] by its [id] or null if no such row exists.
  Future<TrustedDevice?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TrustedDevice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TrustedDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [TrustedDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<TrustedDevice>> insert(
    _i1.DatabaseSession session,
    List<TrustedDevice> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<TrustedDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [TrustedDevice] and returns the inserted row.
  ///
  /// The returned [TrustedDevice] will have its `id` field set.
  Future<TrustedDevice> insertRow(
    _i1.DatabaseSession session,
    TrustedDevice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TrustedDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TrustedDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TrustedDevice>> update(
    _i1.DatabaseSession session,
    List<TrustedDevice> rows, {
    _i1.ColumnSelections<TrustedDeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TrustedDevice>(
      rows,
      columns: columns?.call(TrustedDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TrustedDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TrustedDevice> updateRow(
    _i1.DatabaseSession session,
    TrustedDevice row, {
    _i1.ColumnSelections<TrustedDeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TrustedDevice>(
      row,
      columns: columns?.call(TrustedDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TrustedDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TrustedDevice?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<TrustedDeviceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TrustedDevice>(
      id,
      columnValues: columnValues(TrustedDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TrustedDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TrustedDevice>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<TrustedDeviceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TrustedDeviceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrustedDeviceTable>? orderBy,
    _i1.OrderByListBuilder<TrustedDeviceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TrustedDevice>(
      columnValues: columnValues(TrustedDevice.t.updateTable),
      where: where(TrustedDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TrustedDevice.t),
      orderByList: orderByList?.call(TrustedDevice.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TrustedDevice]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TrustedDevice>> delete(
    _i1.DatabaseSession session,
    List<TrustedDevice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TrustedDevice>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TrustedDevice].
  Future<TrustedDevice> deleteRow(
    _i1.DatabaseSession session,
    TrustedDevice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TrustedDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TrustedDevice>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TrustedDeviceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TrustedDevice>(
      where: where(TrustedDevice.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TrustedDeviceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TrustedDevice>(
      where: where?.call(TrustedDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TrustedDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TrustedDeviceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TrustedDevice>(
      where: where(TrustedDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
