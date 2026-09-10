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

/// Permiso granular del sistema.
abstract class AppPermission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppPermission._({
    this.id,
    required this.code,
    required this.module,
    required this.description,
  });

  factory AppPermission({
    int? id,
    required String code,
    required String module,
    required String description,
  }) = _AppPermissionImpl;

  factory AppPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppPermission(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      module: jsonSerialization['module'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  static final t = AppPermissionTable();

  static const db = AppPermissionRepository._();

  @override
  int? id;

  /// Código canónico único del permiso (ej. users.create, audit.view).
  String code;

  /// Módulo al que pertenece el permiso (ej. users, rbac, audit).
  String module;

  /// Descripción de la operación autorizada.
  String description;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppPermission copyWith({
    int? id,
    String? code,
    String? module,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppPermission',
      if (id != null) 'id': id,
      'code': code,
      'module': module,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppPermission',
      if (id != null) 'id': id,
      'code': code,
      'module': module,
      'description': description,
    };
  }

  static AppPermissionInclude include() {
    return AppPermissionInclude._();
  }

  static AppPermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<AppPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppPermissionTable>? orderByList,
    AppPermissionInclude? include,
  }) {
    return AppPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppPermission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppPermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppPermissionImpl extends AppPermission {
  _AppPermissionImpl({
    int? id,
    required String code,
    required String module,
    required String description,
  }) : super._(
         id: id,
         code: code,
         module: module,
         description: description,
       );

  /// Returns a shallow copy of this [AppPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppPermission copyWith({
    Object? id = _Undefined,
    String? code,
    String? module,
    String? description,
  }) {
    return AppPermission(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      module: module ?? this.module,
      description: description ?? this.description,
    );
  }
}

class AppPermissionUpdateTable extends _i1.UpdateTable<AppPermissionTable> {
  AppPermissionUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> module(String value) => _i1.ColumnValue(
    table.module,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );
}

class AppPermissionTable extends _i1.Table<int?> {
  AppPermissionTable({super.tableRelation})
    : super(tableName: 'app_permission') {
    updateTable = AppPermissionUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    module = _i1.ColumnString(
      'module',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
  }

  late final AppPermissionUpdateTable updateTable;

  /// Código canónico único del permiso (ej. users.create, audit.view).
  late final _i1.ColumnString code;

  /// Módulo al que pertenece el permiso (ej. users, rbac, audit).
  late final _i1.ColumnString module;

  /// Descripción de la operación autorizada.
  late final _i1.ColumnString description;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    module,
    description,
  ];
}

class AppPermissionInclude extends _i1.IncludeObject {
  AppPermissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppPermission.t;
}

class AppPermissionIncludeList extends _i1.IncludeList {
  AppPermissionIncludeList._({
    _i1.WhereExpressionBuilder<AppPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppPermission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppPermission.t;
}

class AppPermissionRepository {
  const AppPermissionRepository._();

  /// Returns a list of [AppPermission]s matching the given query parameters.
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
  Future<List<AppPermission>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppPermissionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppPermission>(
      where: where?.call(AppPermission.t),
      orderBy: orderBy?.call(AppPermission.t),
      orderByList: orderByList?.call(AppPermission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppPermission] matching the given query parameters.
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
  Future<AppPermission?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppPermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppPermissionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppPermission>(
      where: where?.call(AppPermission.t),
      orderBy: orderBy?.call(AppPermission.t),
      orderByList: orderByList?.call(AppPermission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppPermission] by its [id] or null if no such row exists.
  Future<AppPermission?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppPermission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [AppPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AppPermission>> insert(
    _i1.DatabaseSession session,
    List<AppPermission> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AppPermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AppPermission] and returns the inserted row.
  ///
  /// The returned [AppPermission] will have its `id` field set.
  Future<AppPermission> insertRow(
    _i1.DatabaseSession session,
    AppPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppPermission>> update(
    _i1.DatabaseSession session,
    List<AppPermission> rows, {
    _i1.ColumnSelections<AppPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppPermission>(
      rows,
      columns: columns?.call(AppPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppPermission> updateRow(
    _i1.DatabaseSession session,
    AppPermission row, {
    _i1.ColumnSelections<AppPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppPermission>(
      row,
      columns: columns?.call(AppPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppPermission?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AppPermissionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppPermission>(
      id,
      columnValues: columnValues(AppPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppPermission>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppPermissionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppPermissionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppPermissionTable>? orderBy,
    _i1.OrderByListBuilder<AppPermissionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppPermission>(
      columnValues: columnValues(AppPermission.t.updateTable),
      where: where(AppPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppPermission.t),
      orderByList: orderByList?.call(AppPermission.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppPermission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppPermission>> delete(
    _i1.DatabaseSession session,
    List<AppPermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppPermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppPermission].
  Future<AppPermission> deleteRow(
    _i1.DatabaseSession session,
    AppPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppPermission>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppPermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppPermission>(
      where: where(AppPermission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppPermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppPermission>(
      where: where?.call(AppPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppPermission] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppPermissionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppPermission>(
      where: where(AppPermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
