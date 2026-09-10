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

/// Sesión activa de usuario para monitoreo y control de concurrencia.
abstract class UserSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserSession._({
    this.id,
    required this.userId,
    required this.sessionTokenHash,
    this.ipAddress,
    this.deviceInfo,
    required this.isRevoked,
    required this.createdAt,
    required this.lastActivityAt,
    required this.expiresAt,
  });

  factory UserSession({
    int? id,
    required int userId,
    required String sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    required bool isRevoked,
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      sessionTokenHash: jsonSerialization['sessionTokenHash'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      isRevoked: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRevoked']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastActivityAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastActivityAt'],
      ),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  static final t = UserSessionTable();

  static const db = UserSessionRepository._();

  @override
  int? id;

  /// ID del usuario propietario de la sesión.
  int userId;

  /// Hash criptográfico del token de sesión (nunca el token plano).
  String sessionTokenHash;

  /// Dirección IP asociada a la sesión.
  String? ipAddress;

  /// Información de cliente/dispositivo (User-Agent).
  String? deviceInfo;

  /// Indicador de si la sesión ha sido revocada remotamente.
  bool isRevoked;

  /// Momento de inicio de sesión.
  DateTime createdAt;

  /// Momento de última actividad registrada.
  DateTime lastActivityAt;

  /// Momento límite de expiración de la sesión.
  DateTime expiresAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSession copyWith({
    int? id,
    int? userId,
    String? sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    bool? isRevoked,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'sessionTokenHash': sessionTokenHash,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'isRevoked': isRevoked,
      'createdAt': createdAt.toJson(),
      'lastActivityAt': lastActivityAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'sessionTokenHash': sessionTokenHash,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'isRevoked': isRevoked,
      'createdAt': createdAt.toJson(),
      'lastActivityAt': lastActivityAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  static UserSessionInclude include() {
    return UserSessionInclude._();
  }

  static UserSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    UserSessionInclude? include,
  }) {
    return UserSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
    int? id,
    required int userId,
    required String sessionTokenHash,
    String? ipAddress,
    String? deviceInfo,
    required bool isRevoked,
    required DateTime createdAt,
    required DateTime lastActivityAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         userId: userId,
         sessionTokenHash: sessionTokenHash,
         ipAddress: ipAddress,
         deviceInfo: deviceInfo,
         isRevoked: isRevoked,
         createdAt: createdAt,
         lastActivityAt: lastActivityAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    int? userId,
    String? sessionTokenHash,
    Object? ipAddress = _Undefined,
    Object? deviceInfo = _Undefined,
    bool? isRevoked,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
  }) {
    return UserSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sessionTokenHash: sessionTokenHash ?? this.sessionTokenHash,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      isRevoked: isRevoked ?? this.isRevoked,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class UserSessionUpdateTable extends _i1.UpdateTable<UserSessionTable> {
  UserSessionUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> sessionTokenHash(String value) =>
      _i1.ColumnValue(
        table.sessionTokenHash,
        value,
      );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<String, String> deviceInfo(String? value) => _i1.ColumnValue(
    table.deviceInfo,
    value,
  );

  _i1.ColumnValue<bool, bool> isRevoked(bool value) => _i1.ColumnValue(
    table.isRevoked,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastActivityAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastActivityAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );
}

class UserSessionTable extends _i1.Table<int?> {
  UserSessionTable({super.tableRelation}) : super(tableName: 'user_session') {
    updateTable = UserSessionUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    sessionTokenHash = _i1.ColumnString(
      'sessionTokenHash',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    deviceInfo = _i1.ColumnString(
      'deviceInfo',
      this,
    );
    isRevoked = _i1.ColumnBool(
      'isRevoked',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastActivityAt = _i1.ColumnDateTime(
      'lastActivityAt',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
  }

  late final UserSessionUpdateTable updateTable;

  /// ID del usuario propietario de la sesión.
  late final _i1.ColumnInt userId;

  /// Hash criptográfico del token de sesión (nunca el token plano).
  late final _i1.ColumnString sessionTokenHash;

  /// Dirección IP asociada a la sesión.
  late final _i1.ColumnString ipAddress;

  /// Información de cliente/dispositivo (User-Agent).
  late final _i1.ColumnString deviceInfo;

  /// Indicador de si la sesión ha sido revocada remotamente.
  late final _i1.ColumnBool isRevoked;

  /// Momento de inicio de sesión.
  late final _i1.ColumnDateTime createdAt;

  /// Momento de última actividad registrada.
  late final _i1.ColumnDateTime lastActivityAt;

  /// Momento límite de expiración de la sesión.
  late final _i1.ColumnDateTime expiresAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    sessionTokenHash,
    ipAddress,
    deviceInfo,
    isRevoked,
    createdAt,
    lastActivityAt,
    expiresAt,
  ];
}

class UserSessionInclude extends _i1.IncludeObject {
  UserSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserSession.t;
}

class UserSessionIncludeList extends _i1.IncludeList {
  UserSessionIncludeList._({
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserSession.t;
}

class UserSessionRepository {
  const UserSessionRepository._();

  /// Returns a list of [UserSession]s matching the given query parameters.
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
  Future<List<UserSession>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserSession] matching the given query parameters.
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
  Future<UserSession?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserSession] by its [id] or null if no such row exists.
  Future<UserSession?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserSession]s in the list and returns the inserted rows.
  ///
  /// The returned [UserSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserSession>> insert(
    _i1.DatabaseSession session,
    List<UserSession> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserSession] and returns the inserted row.
  ///
  /// The returned [UserSession] will have its `id` field set.
  Future<UserSession> insertRow(
    _i1.DatabaseSession session,
    UserSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserSession>> update(
    _i1.DatabaseSession session,
    List<UserSession> rows, {
    _i1.ColumnSelections<UserSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserSession>(
      rows,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserSession> updateRow(
    _i1.DatabaseSession session,
    UserSession row, {
    _i1.ColumnSelections<UserSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserSession>(
      row,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserSession?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserSession>(
      id,
      columnValues: columnValues(UserSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserSession>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserSession>(
      columnValues: columnValues(UserSession.t.updateTable),
      where: where(UserSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserSession>> delete(
    _i1.DatabaseSession session,
    List<UserSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserSession].
  Future<UserSession> deleteRow(
    _i1.DatabaseSession session,
    UserSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserSession>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserSession>(
      where: where(UserSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserSession>(
      where: where?.call(UserSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserSession] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserSessionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserSession>(
      where: where(UserSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
