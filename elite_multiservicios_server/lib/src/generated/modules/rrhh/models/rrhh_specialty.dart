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

/// Especialidad operativa y técnica (ej: Jardinería, Limpieza, Seguridad, Climatización).
abstract class RrhhSpecialty
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhSpecialty._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    this.colorTag,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhSpecialty({
    int? id,
    required String code,
    required String name,
    String? description,
    String? colorTag,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhSpecialtyImpl;

  factory RrhhSpecialty.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhSpecialty(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      colorTag: jsonSerialization['colorTag'] as String?,
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

  static final t = RrhhSpecialtyTable();

  static const db = RrhhSpecialtyRepository._();

  @override
  int? id;

  /// Código único de especialidad (ej: ESP-JARD, ESP-LIMP, ESP-SEG).
  String code;

  /// Nombre de la especialidad técnica.
  String name;

  /// Descripción detallada del alcance técnico y certificaciones asociadas.
  String? description;

  /// Color identificador (#HEX) para badges y filtros rápidos en planillas y turnos.
  String? colorTag;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhSpecialty]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhSpecialty copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? colorTag,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhSpecialty',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (colorTag != null) 'colorTag': colorTag,
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
      '__className__': 'RrhhSpecialty',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (colorTag != null) 'colorTag': colorTag,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhSpecialtyInclude include() {
    return RrhhSpecialtyInclude._();
  }

  static RrhhSpecialtyIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhSpecialtyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhSpecialtyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhSpecialtyTable>? orderByList,
    RrhhSpecialtyInclude? include,
  }) {
    return RrhhSpecialtyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhSpecialty.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhSpecialty.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhSpecialtyImpl extends RrhhSpecialty {
  _RrhhSpecialtyImpl({
    int? id,
    required String code,
    required String name,
    String? description,
    String? colorTag,
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
         colorTag: colorTag,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhSpecialty]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhSpecialty copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    Object? description = _Undefined,
    Object? colorTag = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhSpecialty(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      colorTag: colorTag is String? ? colorTag : this.colorTag,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhSpecialtyUpdateTable extends _i1.UpdateTable<RrhhSpecialtyTable> {
  RrhhSpecialtyUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> colorTag(String? value) => _i1.ColumnValue(
    table.colorTag,
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

class RrhhSpecialtyTable extends _i1.Table<int?> {
  RrhhSpecialtyTable({super.tableRelation})
    : super(tableName: 'rrhh_specialty') {
    updateTable = RrhhSpecialtyUpdateTable(this);
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
    colorTag = _i1.ColumnString(
      'colorTag',
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

  late final RrhhSpecialtyUpdateTable updateTable;

  /// Código único de especialidad (ej: ESP-JARD, ESP-LIMP, ESP-SEG).
  late final _i1.ColumnString code;

  /// Nombre de la especialidad técnica.
  late final _i1.ColumnString name;

  /// Descripción detallada del alcance técnico y certificaciones asociadas.
  late final _i1.ColumnString description;

  /// Color identificador (#HEX) para badges y filtros rápidos en planillas y turnos.
  late final _i1.ColumnString colorTag;

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
    colorTag,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhSpecialtyInclude extends _i1.IncludeObject {
  RrhhSpecialtyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhSpecialty.t;
}

class RrhhSpecialtyIncludeList extends _i1.IncludeList {
  RrhhSpecialtyIncludeList._({
    _i1.WhereExpressionBuilder<RrhhSpecialtyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhSpecialty.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhSpecialty.t;
}

class RrhhSpecialtyRepository {
  const RrhhSpecialtyRepository._();

  /// Returns a list of [RrhhSpecialty]s matching the given query parameters.
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
  Future<List<RrhhSpecialty>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhSpecialtyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhSpecialtyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhSpecialtyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhSpecialty>(
      where: where?.call(RrhhSpecialty.t),
      orderBy: orderBy?.call(RrhhSpecialty.t),
      orderByList: orderByList?.call(RrhhSpecialty.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhSpecialty] matching the given query parameters.
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
  Future<RrhhSpecialty?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhSpecialtyTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhSpecialtyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhSpecialtyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhSpecialty>(
      where: where?.call(RrhhSpecialty.t),
      orderBy: orderBy?.call(RrhhSpecialty.t),
      orderByList: orderByList?.call(RrhhSpecialty.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhSpecialty] by its [id] or null if no such row exists.
  Future<RrhhSpecialty?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhSpecialty>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhSpecialty]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhSpecialty]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhSpecialty>> insert(
    _i1.DatabaseSession session,
    List<RrhhSpecialty> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhSpecialty>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhSpecialty] and returns the inserted row.
  ///
  /// The returned [RrhhSpecialty] will have its `id` field set.
  Future<RrhhSpecialty> insertRow(
    _i1.DatabaseSession session,
    RrhhSpecialty row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhSpecialty>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhSpecialty]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhSpecialty>> update(
    _i1.DatabaseSession session,
    List<RrhhSpecialty> rows, {
    _i1.ColumnSelections<RrhhSpecialtyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhSpecialty>(
      rows,
      columns: columns?.call(RrhhSpecialty.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhSpecialty]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhSpecialty> updateRow(
    _i1.DatabaseSession session,
    RrhhSpecialty row, {
    _i1.ColumnSelections<RrhhSpecialtyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhSpecialty>(
      row,
      columns: columns?.call(RrhhSpecialty.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhSpecialty] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhSpecialty?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhSpecialtyUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhSpecialty>(
      id,
      columnValues: columnValues(RrhhSpecialty.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhSpecialty]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhSpecialty>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhSpecialtyUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhSpecialtyTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhSpecialtyTable>? orderBy,
    _i1.OrderByListBuilder<RrhhSpecialtyTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhSpecialty>(
      columnValues: columnValues(RrhhSpecialty.t.updateTable),
      where: where(RrhhSpecialty.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhSpecialty.t),
      orderByList: orderByList?.call(RrhhSpecialty.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhSpecialty]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhSpecialty>> delete(
    _i1.DatabaseSession session,
    List<RrhhSpecialty> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhSpecialty>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhSpecialty].
  Future<RrhhSpecialty> deleteRow(
    _i1.DatabaseSession session,
    RrhhSpecialty row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhSpecialty>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhSpecialty>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhSpecialtyTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhSpecialty>(
      where: where(RrhhSpecialty.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhSpecialtyTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhSpecialty>(
      where: where?.call(RrhhSpecialty.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhSpecialty] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhSpecialtyTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhSpecialty>(
      where: where(RrhhSpecialty.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
