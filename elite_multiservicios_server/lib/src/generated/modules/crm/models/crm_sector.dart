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

/// Sector o Rubro industrial objetivo de clientes corporativos.
abstract class CrmSector
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmSector._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmSector({
    int? id,
    required String code,
    required String name,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmSectorImpl;

  factory CrmSector.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmSector(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CrmSectorTable();

  static const db = CrmSectorRepository._();

  @override
  int? id;

  /// Código único identificador (ej: SEC-SALUD, SEC-CORP, SEC-COND).
  String code;

  /// Nombre del rubro (ej: Clínicas y centros médicos).
  String name;

  /// Descripción detallada del perfil industrial.
  String? description;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmSector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmSector copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmSector',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmSector',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmSectorInclude include() {
    return CrmSectorInclude._();
  }

  static CrmSectorIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmSectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmSectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmSectorTable>? orderByList,
    CrmSectorInclude? include,
  }) {
    return CrmSectorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmSector.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmSector.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmSectorImpl extends CrmSector {
  _CrmSectorImpl({
    int? id,
    required String code,
    required String name,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmSector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmSector copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmSector(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmSectorUpdateTable extends _i1.UpdateTable<CrmSectorTable> {
  CrmSectorUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<bool, bool> isDeleted(bool value) => _i1.ColumnValue(
    table.isDeleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
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

class CrmSectorTable extends _i1.Table<int?> {
  CrmSectorTable({super.tableRelation}) : super(tableName: 'crm_sector') {
    updateTable = CrmSectorUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
      hasDefault: true,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
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

  late final CrmSectorUpdateTable updateTable;

  /// Código único identificador (ej: SEC-SALUD, SEC-CORP, SEC-COND).
  late final _i1.ColumnString code;

  /// Nombre del rubro (ej: Clínicas y centros médicos).
  late final _i1.ColumnString name;

  /// Descripción detallada del perfil industrial.
  late final _i1.ColumnString description;

  /// Estado operativo.
  late final _i1.ColumnBool isActive;

  /// Eliminación lógica y auditoría temporal.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    name,
    description,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class CrmSectorInclude extends _i1.IncludeObject {
  CrmSectorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmSector.t;
}

class CrmSectorIncludeList extends _i1.IncludeList {
  CrmSectorIncludeList._({
    _i1.WhereExpressionBuilder<CrmSectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmSector.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmSector.t;
}

class CrmSectorRepository {
  const CrmSectorRepository._();

  /// Returns a list of [CrmSector]s matching the given query parameters.
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
  Future<List<CrmSector>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmSectorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmSectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmSectorTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmSector>(
      where: where?.call(CrmSector.t),
      orderBy: orderBy?.call(CrmSector.t),
      orderByList: orderByList?.call(CrmSector.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmSector] matching the given query parameters.
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
  Future<CrmSector?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmSectorTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmSectorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmSectorTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmSector>(
      where: where?.call(CrmSector.t),
      orderBy: orderBy?.call(CrmSector.t),
      orderByList: orderByList?.call(CrmSector.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmSector] by its [id] or null if no such row exists.
  Future<CrmSector?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmSector>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmSector]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmSector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmSector>> insert(
    _i1.DatabaseSession session,
    List<CrmSector> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmSector>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmSector] and returns the inserted row.
  ///
  /// The returned [CrmSector] will have its `id` field set.
  Future<CrmSector> insertRow(
    _i1.DatabaseSession session,
    CrmSector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmSector>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmSector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmSector>> update(
    _i1.DatabaseSession session,
    List<CrmSector> rows, {
    _i1.ColumnSelections<CrmSectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmSector>(
      rows,
      columns: columns?.call(CrmSector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmSector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmSector> updateRow(
    _i1.DatabaseSession session,
    CrmSector row, {
    _i1.ColumnSelections<CrmSectorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmSector>(
      row,
      columns: columns?.call(CrmSector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmSector] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmSector?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmSectorUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmSector>(
      id,
      columnValues: columnValues(CrmSector.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmSector]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmSector>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmSectorUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmSectorTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmSectorTable>? orderBy,
    _i1.OrderByListBuilder<CrmSectorTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmSector>(
      columnValues: columnValues(CrmSector.t.updateTable),
      where: where(CrmSector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmSector.t),
      orderByList: orderByList?.call(CrmSector.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmSector]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmSector>> delete(
    _i1.DatabaseSession session,
    List<CrmSector> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmSector>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmSector].
  Future<CrmSector> deleteRow(
    _i1.DatabaseSession session,
    CrmSector row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmSector>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmSector>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmSectorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmSector>(
      where: where(CrmSector.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmSectorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmSector>(
      where: where?.call(CrmSector.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmSector] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmSectorTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmSector>(
      where: where(CrmSector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
