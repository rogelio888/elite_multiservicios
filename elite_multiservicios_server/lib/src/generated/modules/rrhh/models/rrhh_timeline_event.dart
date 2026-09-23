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

/// Evento o hito histórico en la línea de tiempo del colaborador (RRHH).
abstract class RrhhTimelineEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhTimelineEvent._({
    this.id,
    required this.employeeId,
    required this.date,
    required this.title,
    required this.description,
    required this.category,
    required this.registeredBy,
    required this.createdAt,
  });

  factory RrhhTimelineEvent({
    int? id,
    required int employeeId,
    required DateTime date,
    required String title,
    required String description,
    required String category,
    required String registeredBy,
    required DateTime createdAt,
  }) = _RrhhTimelineEventImpl;

  factory RrhhTimelineEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhTimelineEvent(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      registeredBy: jsonSerialization['registeredBy'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RrhhTimelineEventTable();

  static const db = RrhhTimelineEventRepository._();

  @override
  int? id;

  /// Empleado al que corresponde el evento.
  int employeeId;

  /// Fecha del suceso.
  DateTime date;

  /// Título del hito (ej: Contratación Inicial, Ascenso, Traslado).
  String title;

  /// Detalle o descripción del hecho.
  String description;

  /// Categoría del evento: 'CONTRATACION', 'ASIGNACION', 'HORARIO', 'PERMISO', 'INCIDENCIA', 'DESVINCULACION'.
  String category;

  /// Usuario o responsable que registró el evento.
  String registeredBy;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhTimelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhTimelineEvent copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    String? title,
    String? description,
    String? category,
    String? registeredBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhTimelineEvent',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      'title': title,
      'description': description,
      'category': category,
      'registeredBy': registeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhTimelineEvent',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      'title': title,
      'description': description,
      'category': category,
      'registeredBy': registeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static RrhhTimelineEventInclude include() {
    return RrhhTimelineEventInclude._();
  }

  static RrhhTimelineEventIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhTimelineEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTimelineEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTimelineEventTable>? orderByList,
    RrhhTimelineEventInclude? include,
  }) {
    return RrhhTimelineEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhTimelineEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhTimelineEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhTimelineEventImpl extends RrhhTimelineEvent {
  _RrhhTimelineEventImpl({
    int? id,
    required int employeeId,
    required DateTime date,
    required String title,
    required String description,
    required String category,
    required String registeredBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         date: date,
         title: title,
         description: description,
         category: category,
         registeredBy: registeredBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhTimelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhTimelineEvent copyWith({
    Object? id = _Undefined,
    int? employeeId,
    DateTime? date,
    String? title,
    String? description,
    String? category,
    String? registeredBy,
    DateTime? createdAt,
  }) {
    return RrhhTimelineEvent(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      registeredBy: registeredBy ?? this.registeredBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RrhhTimelineEventUpdateTable
    extends _i1.UpdateTable<RrhhTimelineEventTable> {
  RrhhTimelineEventUpdateTable(super.table);

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> registeredBy(String value) => _i1.ColumnValue(
    table.registeredBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RrhhTimelineEventTable extends _i1.Table<int?> {
  RrhhTimelineEventTable({super.tableRelation})
    : super(tableName: 'rrhh_timeline_event') {
    updateTable = RrhhTimelineEventUpdateTable(this);
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    registeredBy = _i1.ColumnString(
      'registeredBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RrhhTimelineEventUpdateTable updateTable;

  /// Empleado al que corresponde el evento.
  late final _i1.ColumnInt employeeId;

  /// Fecha del suceso.
  late final _i1.ColumnDateTime date;

  /// Título del hito (ej: Contratación Inicial, Ascenso, Traslado).
  late final _i1.ColumnString title;

  /// Detalle o descripción del hecho.
  late final _i1.ColumnString description;

  /// Categoría del evento: 'CONTRATACION', 'ASIGNACION', 'HORARIO', 'PERMISO', 'INCIDENCIA', 'DESVINCULACION'.
  late final _i1.ColumnString category;

  /// Usuario o responsable que registró el evento.
  late final _i1.ColumnString registeredBy;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    employeeId,
    date,
    title,
    description,
    category,
    registeredBy,
    createdAt,
  ];
}

class RrhhTimelineEventInclude extends _i1.IncludeObject {
  RrhhTimelineEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhTimelineEvent.t;
}

class RrhhTimelineEventIncludeList extends _i1.IncludeList {
  RrhhTimelineEventIncludeList._({
    _i1.WhereExpressionBuilder<RrhhTimelineEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhTimelineEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhTimelineEvent.t;
}

class RrhhTimelineEventRepository {
  const RrhhTimelineEventRepository._();

  /// Returns a list of [RrhhTimelineEvent]s matching the given query parameters.
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
  Future<List<RrhhTimelineEvent>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTimelineEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTimelineEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTimelineEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhTimelineEvent>(
      where: where?.call(RrhhTimelineEvent.t),
      orderBy: orderBy?.call(RrhhTimelineEvent.t),
      orderByList: orderByList?.call(RrhhTimelineEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhTimelineEvent] matching the given query parameters.
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
  Future<RrhhTimelineEvent?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTimelineEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhTimelineEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTimelineEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhTimelineEvent>(
      where: where?.call(RrhhTimelineEvent.t),
      orderBy: orderBy?.call(RrhhTimelineEvent.t),
      orderByList: orderByList?.call(RrhhTimelineEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhTimelineEvent] by its [id] or null if no such row exists.
  Future<RrhhTimelineEvent?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhTimelineEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhTimelineEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhTimelineEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhTimelineEvent>> insert(
    _i1.DatabaseSession session,
    List<RrhhTimelineEvent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhTimelineEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhTimelineEvent] and returns the inserted row.
  ///
  /// The returned [RrhhTimelineEvent] will have its `id` field set.
  Future<RrhhTimelineEvent> insertRow(
    _i1.DatabaseSession session,
    RrhhTimelineEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhTimelineEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhTimelineEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhTimelineEvent>> update(
    _i1.DatabaseSession session,
    List<RrhhTimelineEvent> rows, {
    _i1.ColumnSelections<RrhhTimelineEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhTimelineEvent>(
      rows,
      columns: columns?.call(RrhhTimelineEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhTimelineEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhTimelineEvent> updateRow(
    _i1.DatabaseSession session,
    RrhhTimelineEvent row, {
    _i1.ColumnSelections<RrhhTimelineEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhTimelineEvent>(
      row,
      columns: columns?.call(RrhhTimelineEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhTimelineEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhTimelineEvent?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhTimelineEventUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhTimelineEvent>(
      id,
      columnValues: columnValues(RrhhTimelineEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhTimelineEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhTimelineEvent>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhTimelineEventUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhTimelineEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTimelineEventTable>? orderBy,
    _i1.OrderByListBuilder<RrhhTimelineEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhTimelineEvent>(
      columnValues: columnValues(RrhhTimelineEvent.t.updateTable),
      where: where(RrhhTimelineEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhTimelineEvent.t),
      orderByList: orderByList?.call(RrhhTimelineEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhTimelineEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhTimelineEvent>> delete(
    _i1.DatabaseSession session,
    List<RrhhTimelineEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhTimelineEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhTimelineEvent].
  Future<RrhhTimelineEvent> deleteRow(
    _i1.DatabaseSession session,
    RrhhTimelineEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhTimelineEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhTimelineEvent>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhTimelineEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhTimelineEvent>(
      where: where(RrhhTimelineEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTimelineEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhTimelineEvent>(
      where: where?.call(RrhhTimelineEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhTimelineEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhTimelineEventTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhTimelineEvent>(
      where: where(RrhhTimelineEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
