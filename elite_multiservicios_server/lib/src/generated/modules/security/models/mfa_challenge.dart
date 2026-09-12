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

abstract class MfaChallenge
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MfaChallenge._({
    this.id,
    required this.userId,
    required this.challengeId,
    required this.codeHash,
    int? attempts,
    bool? isUsed,
    required this.expiresAt,
    required this.createdAt,
  }) : attempts = attempts ?? 0,
       isUsed = isUsed ?? false;

  factory MfaChallenge({
    int? id,
    required int userId,
    required String challengeId,
    required String codeHash,
    int? attempts,
    bool? isUsed,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _MfaChallengeImpl;

  factory MfaChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return MfaChallenge(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      challengeId: jsonSerialization['challengeId'] as String,
      codeHash: jsonSerialization['codeHash'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      isUsed: jsonSerialization['isUsed'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isUsed']),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = MfaChallengeTable();

  static const db = MfaChallengeRepository._();

  @override
  int? id;

  int userId;

  String challengeId;

  String codeHash;

  int attempts;

  bool isUsed;

  DateTime expiresAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MfaChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MfaChallenge copyWith({
    int? id,
    int? userId,
    String? challengeId,
    String? codeHash,
    int? attempts,
    bool? isUsed,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MfaChallenge',
      if (id != null) 'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'codeHash': codeHash,
      'attempts': attempts,
      'isUsed': isUsed,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MfaChallenge',
      if (id != null) 'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'codeHash': codeHash,
      'attempts': attempts,
      'isUsed': isUsed,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static MfaChallengeInclude include() {
    return MfaChallengeInclude._();
  }

  static MfaChallengeIncludeList includeList({
    _i1.WhereExpressionBuilder<MfaChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MfaChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MfaChallengeTable>? orderByList,
    MfaChallengeInclude? include,
  }) {
    return MfaChallengeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MfaChallenge.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MfaChallenge.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MfaChallengeImpl extends MfaChallenge {
  _MfaChallengeImpl({
    int? id,
    required int userId,
    required String challengeId,
    required String codeHash,
    int? attempts,
    bool? isUsed,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         challengeId: challengeId,
         codeHash: codeHash,
         attempts: attempts,
         isUsed: isUsed,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MfaChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MfaChallenge copyWith({
    Object? id = _Undefined,
    int? userId,
    String? challengeId,
    String? codeHash,
    int? attempts,
    bool? isUsed,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return MfaChallenge(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      codeHash: codeHash ?? this.codeHash,
      attempts: attempts ?? this.attempts,
      isUsed: isUsed ?? this.isUsed,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MfaChallengeUpdateTable extends _i1.UpdateTable<MfaChallengeTable> {
  MfaChallengeUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> challengeId(String value) => _i1.ColumnValue(
    table.challengeId,
    value,
  );

  _i1.ColumnValue<String, String> codeHash(String value) => _i1.ColumnValue(
    table.codeHash,
    value,
  );

  _i1.ColumnValue<int, int> attempts(int value) => _i1.ColumnValue(
    table.attempts,
    value,
  );

  _i1.ColumnValue<bool, bool> isUsed(bool value) => _i1.ColumnValue(
    table.isUsed,
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

class MfaChallengeTable extends _i1.Table<int?> {
  MfaChallengeTable({super.tableRelation}) : super(tableName: 'mfa_challenge') {
    updateTable = MfaChallengeUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    challengeId = _i1.ColumnString(
      'challengeId',
      this,
    );
    codeHash = _i1.ColumnString(
      'codeHash',
      this,
    );
    attempts = _i1.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    isUsed = _i1.ColumnBool(
      'isUsed',
      this,
      hasDefault: true,
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

  late final MfaChallengeUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString challengeId;

  late final _i1.ColumnString codeHash;

  late final _i1.ColumnInt attempts;

  late final _i1.ColumnBool isUsed;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    challengeId,
    codeHash,
    attempts,
    isUsed,
    expiresAt,
    createdAt,
  ];
}

class MfaChallengeInclude extends _i1.IncludeObject {
  MfaChallengeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MfaChallenge.t;
}

class MfaChallengeIncludeList extends _i1.IncludeList {
  MfaChallengeIncludeList._({
    _i1.WhereExpressionBuilder<MfaChallengeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MfaChallenge.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MfaChallenge.t;
}

class MfaChallengeRepository {
  const MfaChallengeRepository._();

  /// Returns a list of [MfaChallenge]s matching the given query parameters.
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
  Future<List<MfaChallenge>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MfaChallengeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MfaChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MfaChallengeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MfaChallenge>(
      where: where?.call(MfaChallenge.t),
      orderBy: orderBy?.call(MfaChallenge.t),
      orderByList: orderByList?.call(MfaChallenge.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MfaChallenge] matching the given query parameters.
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
  Future<MfaChallenge?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MfaChallengeTable>? where,
    int? offset,
    _i1.OrderByBuilder<MfaChallengeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MfaChallengeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MfaChallenge>(
      where: where?.call(MfaChallenge.t),
      orderBy: orderBy?.call(MfaChallenge.t),
      orderByList: orderByList?.call(MfaChallenge.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MfaChallenge] by its [id] or null if no such row exists.
  Future<MfaChallenge?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MfaChallenge>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MfaChallenge]s in the list and returns the inserted rows.
  ///
  /// The returned [MfaChallenge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<MfaChallenge>> insert(
    _i1.DatabaseSession session,
    List<MfaChallenge> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<MfaChallenge>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [MfaChallenge] and returns the inserted row.
  ///
  /// The returned [MfaChallenge] will have its `id` field set.
  Future<MfaChallenge> insertRow(
    _i1.DatabaseSession session,
    MfaChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MfaChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MfaChallenge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MfaChallenge>> update(
    _i1.DatabaseSession session,
    List<MfaChallenge> rows, {
    _i1.ColumnSelections<MfaChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MfaChallenge>(
      rows,
      columns: columns?.call(MfaChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MfaChallenge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MfaChallenge> updateRow(
    _i1.DatabaseSession session,
    MfaChallenge row, {
    _i1.ColumnSelections<MfaChallengeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MfaChallenge>(
      row,
      columns: columns?.call(MfaChallenge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MfaChallenge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MfaChallenge?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<MfaChallengeUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MfaChallenge>(
      id,
      columnValues: columnValues(MfaChallenge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MfaChallenge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MfaChallenge>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<MfaChallengeUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MfaChallengeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MfaChallengeTable>? orderBy,
    _i1.OrderByListBuilder<MfaChallengeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MfaChallenge>(
      columnValues: columnValues(MfaChallenge.t.updateTable),
      where: where(MfaChallenge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MfaChallenge.t),
      orderByList: orderByList?.call(MfaChallenge.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MfaChallenge]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MfaChallenge>> delete(
    _i1.DatabaseSession session,
    List<MfaChallenge> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MfaChallenge>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MfaChallenge].
  Future<MfaChallenge> deleteRow(
    _i1.DatabaseSession session,
    MfaChallenge row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MfaChallenge>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MfaChallenge>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MfaChallengeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MfaChallenge>(
      where: where(MfaChallenge.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MfaChallengeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MfaChallenge>(
      where: where?.call(MfaChallenge.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MfaChallenge] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MfaChallengeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MfaChallenge>(
      where: where(MfaChallenge.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
