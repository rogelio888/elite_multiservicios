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
import 'package:elite_multiservicios_server/src/generated/protocol.dart' as _i2;

/// Catálogo de Horarios y Turnos Operativos / Administrativos de RRHH.
abstract class RrhhSchedule
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhSchedule._({
    this.id,
    required this.code,
    required this.name,
    String? targetType,
    required this.startTime,
    required this.endTime,
    required this.workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : targetType = targetType ?? 'AMBOS',
       toleranceMinutes = toleranceMinutes ?? 10,
       isNightShift = isNightShift ?? false,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhSchedule({
    int? id,
    required String code,
    required String name,
    String? targetType,
    required String startTime,
    required String endTime,
    required List<int> workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhScheduleImpl;

  factory RrhhSchedule.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhSchedule(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      targetType: jsonSerialization['targetType'] as String?,
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      workDays: _i2.Protocol().deserialize<List<int>>(
        jsonSerialization['workDays'],
      ),
      toleranceMinutes: jsonSerialization['toleranceMinutes'] as int?,
      isNightShift: jsonSerialization['isNightShift'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isNightShift']),
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

  static final t = RrhhScheduleTable();

  static const db = RrhhScheduleRepository._();

  @override
  int? id;

  /// Código de turno (ej: SCH-001, SCH-ADM, SCH-OP-MAN).
  String code;

  /// Nombre descriptivo del turno (ej: Administrativo Central, Operativo Mañana).
  String name;

  /// Tipo de entorno al que aplica: 'OFICINA', 'CAMPO', 'AMBOS'.
  String targetType;

  /// Hora de inicio en formato HH:mm (ej: "08:30", "07:00", "22:00").
  String startTime;

  /// Hora de finalización en formato HH:mm (ej: "17:30", "15:00", "06:00").
  String endTime;

  /// Días laborales (1=Lunes, 2=Martes, ..., 7=Domingo).
  List<int> workDays;

  /// Tolerancia de atraso en minutos (ej: 15, 10, 5).
  int toleranceMinutes;

  /// Indica si es turno nocturno para recargos legales.
  bool isNightShift;

  /// Descripción opcional del turno o sede sugerida.
  String? description;

  /// Estado activo del turno en catálogo.
  bool isActive;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhSchedule copyWith({
    int? id,
    String? code,
    String? name,
    String? targetType,
    String? startTime,
    String? endTime,
    List<int>? workDays,
    int? toleranceMinutes,
    bool? isNightShift,
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
      '__className__': 'RrhhSchedule',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'targetType': targetType,
      'startTime': startTime,
      'endTime': endTime,
      'workDays': workDays.toJson(),
      'toleranceMinutes': toleranceMinutes,
      'isNightShift': isNightShift,
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
      '__className__': 'RrhhSchedule',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'targetType': targetType,
      'startTime': startTime,
      'endTime': endTime,
      'workDays': workDays.toJson(),
      'toleranceMinutes': toleranceMinutes,
      'isNightShift': isNightShift,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhScheduleInclude include() {
    return RrhhScheduleInclude._();
  }

  static RrhhScheduleIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhScheduleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhScheduleTable>? orderByList,
    RrhhScheduleInclude? include,
  }) {
    return RrhhScheduleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhSchedule.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhSchedule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhScheduleImpl extends RrhhSchedule {
  _RrhhScheduleImpl({
    int? id,
    required String code,
    required String name,
    String? targetType,
    required String startTime,
    required String endTime,
    required List<int> workDays,
    int? toleranceMinutes,
    bool? isNightShift,
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
         targetType: targetType,
         startTime: startTime,
         endTime: endTime,
         workDays: workDays,
         toleranceMinutes: toleranceMinutes,
         isNightShift: isNightShift,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhSchedule copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? targetType,
    String? startTime,
    String? endTime,
    List<int>? workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhSchedule(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      targetType: targetType ?? this.targetType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workDays: workDays ?? this.workDays.map((e0) => e0).toList(),
      toleranceMinutes: toleranceMinutes ?? this.toleranceMinutes,
      isNightShift: isNightShift ?? this.isNightShift,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhScheduleUpdateTable extends _i1.UpdateTable<RrhhScheduleTable> {
  RrhhScheduleUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> targetType(String value) => _i1.ColumnValue(
    table.targetType,
    value,
  );

  _i1.ColumnValue<String, String> startTime(String value) => _i1.ColumnValue(
    table.startTime,
    value,
  );

  _i1.ColumnValue<String, String> endTime(String value) => _i1.ColumnValue(
    table.endTime,
    value,
  );

  _i1.ColumnValue<List<int>, List<int>> workDays(List<int> value) =>
      _i1.ColumnValue(
        table.workDays,
        value,
      );

  _i1.ColumnValue<int, int> toleranceMinutes(int value) => _i1.ColumnValue(
    table.toleranceMinutes,
    value,
  );

  _i1.ColumnValue<bool, bool> isNightShift(bool value) => _i1.ColumnValue(
    table.isNightShift,
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

class RrhhScheduleTable extends _i1.Table<int?> {
  RrhhScheduleTable({super.tableRelation}) : super(tableName: 'rrhh_schedule') {
    updateTable = RrhhScheduleUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    targetType = _i1.ColumnString(
      'targetType',
      this,
      hasDefault: true,
    );
    startTime = _i1.ColumnString(
      'startTime',
      this,
    );
    endTime = _i1.ColumnString(
      'endTime',
      this,
    );
    workDays = _i1.ColumnSerializable<List<int>>(
      'workDays',
      this,
    );
    toleranceMinutes = _i1.ColumnInt(
      'toleranceMinutes',
      this,
      hasDefault: true,
    );
    isNightShift = _i1.ColumnBool(
      'isNightShift',
      this,
      hasDefault: true,
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

  late final RrhhScheduleUpdateTable updateTable;

  /// Código de turno (ej: SCH-001, SCH-ADM, SCH-OP-MAN).
  late final _i1.ColumnString code;

  /// Nombre descriptivo del turno (ej: Administrativo Central, Operativo Mañana).
  late final _i1.ColumnString name;

  /// Tipo de entorno al que aplica: 'OFICINA', 'CAMPO', 'AMBOS'.
  late final _i1.ColumnString targetType;

  /// Hora de inicio en formato HH:mm (ej: "08:30", "07:00", "22:00").
  late final _i1.ColumnString startTime;

  /// Hora de finalización en formato HH:mm (ej: "17:30", "15:00", "06:00").
  late final _i1.ColumnString endTime;

  /// Días laborales (1=Lunes, 2=Martes, ..., 7=Domingo).
  late final _i1.ColumnSerializable<List<int>> workDays;

  /// Tolerancia de atraso en minutos (ej: 15, 10, 5).
  late final _i1.ColumnInt toleranceMinutes;

  /// Indica si es turno nocturno para recargos legales.
  late final _i1.ColumnBool isNightShift;

  /// Descripción opcional del turno o sede sugerida.
  late final _i1.ColumnString description;

  /// Estado activo del turno en catálogo.
  late final _i1.ColumnBool isActive;

  /// Eliminación lógica y auditoría
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    name,
    targetType,
    startTime,
    endTime,
    workDays,
    toleranceMinutes,
    isNightShift,
    description,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhScheduleInclude extends _i1.IncludeObject {
  RrhhScheduleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhSchedule.t;
}

class RrhhScheduleIncludeList extends _i1.IncludeList {
  RrhhScheduleIncludeList._({
    _i1.WhereExpressionBuilder<RrhhScheduleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhSchedule.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhSchedule.t;
}

class RrhhScheduleRepository {
  const RrhhScheduleRepository._();

  /// Returns a list of [RrhhSchedule]s matching the given query parameters.
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
  Future<List<RrhhSchedule>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhScheduleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhScheduleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhSchedule>(
      where: where?.call(RrhhSchedule.t),
      orderBy: orderBy?.call(RrhhSchedule.t),
      orderByList: orderByList?.call(RrhhSchedule.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhSchedule] matching the given query parameters.
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
  Future<RrhhSchedule?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhScheduleTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhScheduleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhScheduleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhSchedule>(
      where: where?.call(RrhhSchedule.t),
      orderBy: orderBy?.call(RrhhSchedule.t),
      orderByList: orderByList?.call(RrhhSchedule.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhSchedule] by its [id] or null if no such row exists.
  Future<RrhhSchedule?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhSchedule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhSchedule]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhSchedule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhSchedule>> insert(
    _i1.DatabaseSession session,
    List<RrhhSchedule> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhSchedule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhSchedule] and returns the inserted row.
  ///
  /// The returned [RrhhSchedule] will have its `id` field set.
  Future<RrhhSchedule> insertRow(
    _i1.DatabaseSession session,
    RrhhSchedule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhSchedule>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhSchedule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhSchedule>> update(
    _i1.DatabaseSession session,
    List<RrhhSchedule> rows, {
    _i1.ColumnSelections<RrhhScheduleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhSchedule>(
      rows,
      columns: columns?.call(RrhhSchedule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhSchedule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhSchedule> updateRow(
    _i1.DatabaseSession session,
    RrhhSchedule row, {
    _i1.ColumnSelections<RrhhScheduleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhSchedule>(
      row,
      columns: columns?.call(RrhhSchedule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhSchedule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhSchedule?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhScheduleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhSchedule>(
      id,
      columnValues: columnValues(RrhhSchedule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhSchedule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhSchedule>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhScheduleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhScheduleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhScheduleTable>? orderBy,
    _i1.OrderByListBuilder<RrhhScheduleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhSchedule>(
      columnValues: columnValues(RrhhSchedule.t.updateTable),
      where: where(RrhhSchedule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhSchedule.t),
      orderByList: orderByList?.call(RrhhSchedule.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhSchedule]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhSchedule>> delete(
    _i1.DatabaseSession session,
    List<RrhhSchedule> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhSchedule>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhSchedule].
  Future<RrhhSchedule> deleteRow(
    _i1.DatabaseSession session,
    RrhhSchedule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhSchedule>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhSchedule>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhScheduleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhSchedule>(
      where: where(RrhhSchedule.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhScheduleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhSchedule>(
      where: where?.call(RrhhSchedule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhSchedule] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhScheduleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhSchedule>(
      where: where(RrhhSchedule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
