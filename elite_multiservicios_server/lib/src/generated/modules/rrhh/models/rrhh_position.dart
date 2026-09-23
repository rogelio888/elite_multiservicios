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

/// Cargo o Puesto de Trabajo dentro de un Área Organizacional.
abstract class RrhhPosition
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhPosition._({
    this.id,
    required this.code,
    required this.areaId,
    required this.name,
    required this.workplaceType,
    double? suggestedSalary,
    this.description,
    this.requirements,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : suggestedSalary = suggestedSalary ?? 0.0,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhPosition({
    int? id,
    required String code,
    required int areaId,
    required String name,
    required String workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhPositionImpl;

  factory RrhhPosition.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhPosition(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      areaId: jsonSerialization['areaId'] as int,
      name: jsonSerialization['name'] as String,
      workplaceType: jsonSerialization['workplaceType'] as String,
      suggestedSalary: (jsonSerialization['suggestedSalary'] as num?)
          ?.toDouble(),
      description: jsonSerialization['description'] as String?,
      requirements: jsonSerialization['requirements'] as String?,
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

  static final t = RrhhPositionTable();

  static const db = RrhhPositionRepository._();

  @override
  int? id;

  /// Código identificador del puesto (ej: CARGO-JARD, CARGO-EJEC-VENTAS).
  String code;

  /// Área a la que pertenece el cargo.
  int areaId;

  /// Título del cargo (ej: Jardinero, Ejecutivo de Ventas, Guardia de Seguridad).
  String name;

  /// Tipo de entorno laboral principal: 'Oficina' o 'Campo'.
  String workplaceType;

  /// Salario base de referencia sugerido en Bolivianos (Bs.).
  double? suggestedSalary;

  /// Perfil o responsabilidades del puesto.
  String? description;

  /// Requisitos mínimos de contratación o formación requerida.
  String? requirements;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhPosition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhPosition copyWith({
    int? id,
    String? code,
    int? areaId,
    String? name,
    String? workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhPosition',
      if (id != null) 'id': id,
      'code': code,
      'areaId': areaId,
      'name': name,
      'workplaceType': workplaceType,
      if (suggestedSalary != null) 'suggestedSalary': suggestedSalary,
      if (description != null) 'description': description,
      if (requirements != null) 'requirements': requirements,
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
      '__className__': 'RrhhPosition',
      if (id != null) 'id': id,
      'code': code,
      'areaId': areaId,
      'name': name,
      'workplaceType': workplaceType,
      if (suggestedSalary != null) 'suggestedSalary': suggestedSalary,
      if (description != null) 'description': description,
      if (requirements != null) 'requirements': requirements,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhPositionInclude include() {
    return RrhhPositionInclude._();
  }

  static RrhhPositionIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhPositionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhPositionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhPositionTable>? orderByList,
    RrhhPositionInclude? include,
  }) {
    return RrhhPositionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhPosition.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhPosition.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhPositionImpl extends RrhhPosition {
  _RrhhPositionImpl({
    int? id,
    required String code,
    required int areaId,
    required String name,
    required String workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         areaId: areaId,
         name: name,
         workplaceType: workplaceType,
         suggestedSalary: suggestedSalary,
         description: description,
         requirements: requirements,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhPosition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhPosition copyWith({
    Object? id = _Undefined,
    String? code,
    int? areaId,
    String? name,
    String? workplaceType,
    Object? suggestedSalary = _Undefined,
    Object? description = _Undefined,
    Object? requirements = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhPosition(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      workplaceType: workplaceType ?? this.workplaceType,
      suggestedSalary: suggestedSalary is double?
          ? suggestedSalary
          : this.suggestedSalary,
      description: description is String? ? description : this.description,
      requirements: requirements is String? ? requirements : this.requirements,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhPositionUpdateTable extends _i1.UpdateTable<RrhhPositionTable> {
  RrhhPositionUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> areaId(int value) => _i1.ColumnValue(
    table.areaId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> workplaceType(String value) =>
      _i1.ColumnValue(
        table.workplaceType,
        value,
      );

  _i1.ColumnValue<double, double> suggestedSalary(double? value) =>
      _i1.ColumnValue(
        table.suggestedSalary,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> requirements(String? value) =>
      _i1.ColumnValue(
        table.requirements,
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

class RrhhPositionTable extends _i1.Table<int?> {
  RrhhPositionTable({super.tableRelation}) : super(tableName: 'rrhh_position') {
    updateTable = RrhhPositionUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    areaId = _i1.ColumnInt(
      'areaId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    workplaceType = _i1.ColumnString(
      'workplaceType',
      this,
    );
    suggestedSalary = _i1.ColumnDouble(
      'suggestedSalary',
      this,
      hasDefault: true,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    requirements = _i1.ColumnString(
      'requirements',
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

  late final RrhhPositionUpdateTable updateTable;

  /// Código identificador del puesto (ej: CARGO-JARD, CARGO-EJEC-VENTAS).
  late final _i1.ColumnString code;

  /// Área a la que pertenece el cargo.
  late final _i1.ColumnInt areaId;

  /// Título del cargo (ej: Jardinero, Ejecutivo de Ventas, Guardia de Seguridad).
  late final _i1.ColumnString name;

  /// Tipo de entorno laboral principal: 'Oficina' o 'Campo'.
  late final _i1.ColumnString workplaceType;

  /// Salario base de referencia sugerido en Bolivianos (Bs.).
  late final _i1.ColumnDouble suggestedSalary;

  /// Perfil o responsabilidades del puesto.
  late final _i1.ColumnString description;

  /// Requisitos mínimos de contratación o formación requerida.
  late final _i1.ColumnString requirements;

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
    areaId,
    name,
    workplaceType,
    suggestedSalary,
    description,
    requirements,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhPositionInclude extends _i1.IncludeObject {
  RrhhPositionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhPosition.t;
}

class RrhhPositionIncludeList extends _i1.IncludeList {
  RrhhPositionIncludeList._({
    _i1.WhereExpressionBuilder<RrhhPositionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhPosition.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhPosition.t;
}

class RrhhPositionRepository {
  const RrhhPositionRepository._();

  /// Returns a list of [RrhhPosition]s matching the given query parameters.
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
  Future<List<RrhhPosition>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhPositionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhPositionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhPositionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhPosition>(
      where: where?.call(RrhhPosition.t),
      orderBy: orderBy?.call(RrhhPosition.t),
      orderByList: orderByList?.call(RrhhPosition.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhPosition] matching the given query parameters.
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
  Future<RrhhPosition?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhPositionTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhPositionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhPositionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhPosition>(
      where: where?.call(RrhhPosition.t),
      orderBy: orderBy?.call(RrhhPosition.t),
      orderByList: orderByList?.call(RrhhPosition.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhPosition] by its [id] or null if no such row exists.
  Future<RrhhPosition?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhPosition>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhPosition]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhPosition]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhPosition>> insert(
    _i1.DatabaseSession session,
    List<RrhhPosition> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhPosition>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhPosition] and returns the inserted row.
  ///
  /// The returned [RrhhPosition] will have its `id` field set.
  Future<RrhhPosition> insertRow(
    _i1.DatabaseSession session,
    RrhhPosition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhPosition>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhPosition]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhPosition>> update(
    _i1.DatabaseSession session,
    List<RrhhPosition> rows, {
    _i1.ColumnSelections<RrhhPositionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhPosition>(
      rows,
      columns: columns?.call(RrhhPosition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhPosition]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhPosition> updateRow(
    _i1.DatabaseSession session,
    RrhhPosition row, {
    _i1.ColumnSelections<RrhhPositionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhPosition>(
      row,
      columns: columns?.call(RrhhPosition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhPosition] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhPosition?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhPositionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhPosition>(
      id,
      columnValues: columnValues(RrhhPosition.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhPosition]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhPosition>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhPositionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhPositionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhPositionTable>? orderBy,
    _i1.OrderByListBuilder<RrhhPositionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhPosition>(
      columnValues: columnValues(RrhhPosition.t.updateTable),
      where: where(RrhhPosition.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhPosition.t),
      orderByList: orderByList?.call(RrhhPosition.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhPosition]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhPosition>> delete(
    _i1.DatabaseSession session,
    List<RrhhPosition> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhPosition>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhPosition].
  Future<RrhhPosition> deleteRow(
    _i1.DatabaseSession session,
    RrhhPosition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhPosition>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhPosition>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhPositionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhPosition>(
      where: where(RrhhPosition.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhPositionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhPosition>(
      where: where?.call(RrhhPosition.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhPosition] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhPositionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhPosition>(
      where: where(RrhhPosition.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
