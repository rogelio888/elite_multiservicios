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

/// Rol de usuario para control de acceso (RBAC).
abstract class AppRole
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppRole._({
    this.id,
    required this.name,
    required this.description,
    required this.isSystemRole,
    required this.createdAt,
  });

  factory AppRole({
    int? id,
    required String name,
    required String description,
    required bool isSystemRole,
    required DateTime createdAt,
  }) = _AppRoleImpl;

  factory AppRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppRole(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      isSystemRole: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isSystemRole'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AppRoleTable();

  static const db = AppRoleRepository._();

  @override
  int? id;

  /// Nombre identificador del rol (ej. Administrador, Supervisor).
  String name;

  /// Descripción funcional de las responsabilidades del rol.
  String description;

  /// Indica si es un rol de sistema protegido contra edición o eliminación.
  bool isSystemRole;

  /// Fecha de registro.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppRole copyWith({
    int? id,
    String? name,
    String? description,
    bool? isSystemRole,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppRole',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'isSystemRole': isSystemRole,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppRole',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'isSystemRole': isSystemRole,
      'createdAt': createdAt.toJson(),
    };
  }

  static AppRoleInclude include() {
    return AppRoleInclude._();
  }

  static AppRoleIncludeList includeList({
    _i1.WhereExpressionBuilder<AppRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppRoleTable>? orderByList,
    AppRoleInclude? include,
  }) {
    return AppRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppRole.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppRoleImpl extends AppRole {
  _AppRoleImpl({
    int? id,
    required String name,
    required String description,
    required bool isSystemRole,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         isSystemRole: isSystemRole,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppRole copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    bool? isSystemRole,
    DateTime? createdAt,
  }) {
    return AppRole(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isSystemRole: isSystemRole ?? this.isSystemRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AppRoleUpdateTable extends _i1.UpdateTable<AppRoleTable> {
  AppRoleUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isSystemRole(bool value) => _i1.ColumnValue(
    table.isSystemRole,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AppRoleTable extends _i1.Table<int?> {
  AppRoleTable({super.tableRelation}) : super(tableName: 'app_role') {
    updateTable = AppRoleUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isSystemRole = _i1.ColumnBool(
      'isSystemRole',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AppRoleUpdateTable updateTable;

  /// Nombre identificador del rol (ej. Administrador, Supervisor).
  late final _i1.ColumnString name;

  /// Descripción funcional de las responsabilidades del rol.
  late final _i1.ColumnString description;

  /// Indica si es un rol de sistema protegido contra edición o eliminación.
  late final _i1.ColumnBool isSystemRole;

  /// Fecha de registro.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    isSystemRole,
    createdAt,
  ];
}

class AppRoleInclude extends _i1.IncludeObject {
  AppRoleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppRole.t;
}

class AppRoleIncludeList extends _i1.IncludeList {
  AppRoleIncludeList._({
    _i1.WhereExpressionBuilder<AppRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppRole.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppRole.t;
}

class AppRoleRepository {
  const AppRoleRepository._();

  /// Returns a list of [AppRole]s matching the given query parameters.
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
  Future<List<AppRole>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppRoleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppRole>(
      where: where?.call(AppRole.t),
      orderBy: orderBy?.call(AppRole.t),
      orderByList: orderByList?.call(AppRole.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppRole] matching the given query parameters.
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
  Future<AppRole?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppRoleTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppRoleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppRole>(
      where: where?.call(AppRole.t),
      orderBy: orderBy?.call(AppRole.t),
      orderByList: orderByList?.call(AppRole.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppRole] by its [id] or null if no such row exists.
  Future<AppRole?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppRole>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppRole]s in the list and returns the inserted rows.
  ///
  /// The returned [AppRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AppRole>> insert(
    _i1.DatabaseSession session,
    List<AppRole> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AppRole>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AppRole] and returns the inserted row.
  ///
  /// The returned [AppRole] will have its `id` field set.
  Future<AppRole> insertRow(
    _i1.DatabaseSession session,
    AppRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppRole>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppRole>> update(
    _i1.DatabaseSession session,
    List<AppRole> rows, {
    _i1.ColumnSelections<AppRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppRole>(
      rows,
      columns: columns?.call(AppRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppRole> updateRow(
    _i1.DatabaseSession session,
    AppRole row, {
    _i1.ColumnSelections<AppRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppRole>(
      row,
      columns: columns?.call(AppRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppRole?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AppRoleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppRole>(
      id,
      columnValues: columnValues(AppRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppRole>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppRoleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppRoleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppRoleTable>? orderBy,
    _i1.OrderByListBuilder<AppRoleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppRole>(
      columnValues: columnValues(AppRole.t.updateTable),
      where: where(AppRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppRole.t),
      orderByList: orderByList?.call(AppRole.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppRole]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppRole>> delete(
    _i1.DatabaseSession session,
    List<AppRole> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppRole>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppRole].
  Future<AppRole> deleteRow(
    _i1.DatabaseSession session,
    AppRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppRole>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppRole>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppRoleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppRole>(
      where: where(AppRole.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppRoleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppRole>(
      where: where?.call(AppRole.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppRole] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppRoleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppRole>(
      where: where(AppRole.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
