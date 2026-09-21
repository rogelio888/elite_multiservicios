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

/// Línea de servicio prestado por la empresa (ej: Limpieza Hospitalaria, Seguridad).
abstract class CrmServiceLine
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmServiceLine._({
    this.id,
    required this.code,
    required this.name,
    required this.category,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmServiceLine({
    int? id,
    required String code,
    required String name,
    required String category,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmServiceLineImpl;

  factory CrmServiceLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmServiceLine(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
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

  static final t = CrmServiceLineTable();

  static const db = CrmServiceLineRepository._();

  @override
  int? id;

  /// Código único de la línea de servicio (ej: SRV-LIMP-HOSP, SRV-SEG-247).
  String code;

  /// Nombre de la línea de servicio.
  String name;

  /// Categoría principal: Personal, Limpieza, Mantenimiento, Equipamiento, Tecnología.
  String category;

  /// Descripción detallada del alcance técnico.
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

  /// Returns a shallow copy of this [CrmServiceLine]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmServiceLine copyWith({
    int? id,
    String? code,
    String? name,
    String? category,
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
      '__className__': 'CrmServiceLine',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'category': category,
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
      '__className__': 'CrmServiceLine',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'category': category,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmServiceLineInclude include() {
    return CrmServiceLineInclude._();
  }

  static CrmServiceLineIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmServiceLineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmServiceLineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmServiceLineTable>? orderByList,
    CrmServiceLineInclude? include,
  }) {
    return CrmServiceLineIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmServiceLine.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmServiceLine.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmServiceLineImpl extends CrmServiceLine {
  _CrmServiceLineImpl({
    int? id,
    required String code,
    required String name,
    required String category,
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
         category: category,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmServiceLine]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmServiceLine copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? category,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmServiceLine(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmServiceLineUpdateTable extends _i1.UpdateTable<CrmServiceLineTable> {
  CrmServiceLineUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
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

class CrmServiceLineTable extends _i1.Table<int?> {
  CrmServiceLineTable({super.tableRelation})
    : super(tableName: 'crm_service_line') {
    updateTable = CrmServiceLineUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    category = _i1.ColumnString(
      'category',
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

  late final CrmServiceLineUpdateTable updateTable;

  /// Código único de la línea de servicio (ej: SRV-LIMP-HOSP, SRV-SEG-247).
  late final _i1.ColumnString code;

  /// Nombre de la línea de servicio.
  late final _i1.ColumnString name;

  /// Categoría principal: Personal, Limpieza, Mantenimiento, Equipamiento, Tecnología.
  late final _i1.ColumnString category;

  /// Descripción detallada del alcance técnico.
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
    category,
    description,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class CrmServiceLineInclude extends _i1.IncludeObject {
  CrmServiceLineInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmServiceLine.t;
}

class CrmServiceLineIncludeList extends _i1.IncludeList {
  CrmServiceLineIncludeList._({
    _i1.WhereExpressionBuilder<CrmServiceLineTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmServiceLine.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmServiceLine.t;
}

class CrmServiceLineRepository {
  const CrmServiceLineRepository._();

  /// Returns a list of [CrmServiceLine]s matching the given query parameters.
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
  Future<List<CrmServiceLine>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmServiceLineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmServiceLineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmServiceLineTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmServiceLine>(
      where: where?.call(CrmServiceLine.t),
      orderBy: orderBy?.call(CrmServiceLine.t),
      orderByList: orderByList?.call(CrmServiceLine.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmServiceLine] matching the given query parameters.
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
  Future<CrmServiceLine?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmServiceLineTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmServiceLineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmServiceLineTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmServiceLine>(
      where: where?.call(CrmServiceLine.t),
      orderBy: orderBy?.call(CrmServiceLine.t),
      orderByList: orderByList?.call(CrmServiceLine.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmServiceLine] by its [id] or null if no such row exists.
  Future<CrmServiceLine?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmServiceLine>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmServiceLine]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmServiceLine]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmServiceLine>> insert(
    _i1.DatabaseSession session,
    List<CrmServiceLine> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmServiceLine>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmServiceLine] and returns the inserted row.
  ///
  /// The returned [CrmServiceLine] will have its `id` field set.
  Future<CrmServiceLine> insertRow(
    _i1.DatabaseSession session,
    CrmServiceLine row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmServiceLine>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmServiceLine]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmServiceLine>> update(
    _i1.DatabaseSession session,
    List<CrmServiceLine> rows, {
    _i1.ColumnSelections<CrmServiceLineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmServiceLine>(
      rows,
      columns: columns?.call(CrmServiceLine.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmServiceLine]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmServiceLine> updateRow(
    _i1.DatabaseSession session,
    CrmServiceLine row, {
    _i1.ColumnSelections<CrmServiceLineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmServiceLine>(
      row,
      columns: columns?.call(CrmServiceLine.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmServiceLine] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmServiceLine?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmServiceLineUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmServiceLine>(
      id,
      columnValues: columnValues(CrmServiceLine.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmServiceLine]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmServiceLine>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmServiceLineUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmServiceLineTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmServiceLineTable>? orderBy,
    _i1.OrderByListBuilder<CrmServiceLineTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmServiceLine>(
      columnValues: columnValues(CrmServiceLine.t.updateTable),
      where: where(CrmServiceLine.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmServiceLine.t),
      orderByList: orderByList?.call(CrmServiceLine.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmServiceLine]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmServiceLine>> delete(
    _i1.DatabaseSession session,
    List<CrmServiceLine> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmServiceLine>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmServiceLine].
  Future<CrmServiceLine> deleteRow(
    _i1.DatabaseSession session,
    CrmServiceLine row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmServiceLine>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmServiceLine>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmServiceLineTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmServiceLine>(
      where: where(CrmServiceLine.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmServiceLineTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmServiceLine>(
      where: where?.call(CrmServiceLine.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmServiceLine] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmServiceLineTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmServiceLine>(
      where: where(CrmServiceLine.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
