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

/// Régimen disciplinario, incidentes y reconocimientos en el expediente del trabajador.
abstract class RrhhIncident
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhIncident._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.incidentType,
    required this.severity,
    required this.incidentDate,
    required this.title,
    required this.description,
    required this.actionTaken,
    bool? isJustified,
    this.recordedByUserId,
    this.documentReferenceUrl,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isJustified = isJustified ?? false,
       isDeleted = isDeleted ?? false;

  factory RrhhIncident({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhIncidentImpl;

  factory RrhhIncident.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhIncident(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      incidentType: jsonSerialization['incidentType'] as String,
      severity: jsonSerialization['severity'] as String,
      incidentDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['incidentDate'],
      ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      actionTaken: jsonSerialization['actionTaken'] as String,
      isJustified: jsonSerialization['isJustified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isJustified']),
      recordedByUserId: jsonSerialization['recordedByUserId'] as int?,
      documentReferenceUrl:
          jsonSerialization['documentReferenceUrl'] as String?,
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

  static final t = RrhhIncidentTable();

  static const db = RrhhIncidentRepository._();

  @override
  int? id;

  /// Código de incidente (ej: INC-2026-001)
  String code;

  /// Colaborador afectado / reconocido
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo: 'FALTA_INJUSTIFICADA', 'ATRASO_REITERADO', 'LLAMADO_ATENCION_LEVE', 'MEMORANDUM_GRAVE', 'SUSPENSION_TEMPORAL', 'FELICITACION', 'RECONOCIMIENTO'
  String incidentType;

  /// Severidad: 'POSITIVA', 'LEVE', 'MODERADA', 'GRAVE'
  String severity;

  /// Fecha del suceso
  DateTime incidentDate;

  /// Título y descripción
  String title;

  String description;

  /// Medida correctiva / efecto laboral
  String actionTaken;

  bool isJustified;

  /// Auditoría
  int? recordedByUserId;

  String? documentReferenceUrl;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhIncident]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhIncident copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? incidentType,
    String? severity,
    DateTime? incidentDate,
    String? title,
    String? description,
    String? actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhIncident',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'incidentType': incidentType,
      'severity': severity,
      'incidentDate': incidentDate.toJson(),
      'title': title,
      'description': description,
      'actionTaken': actionTaken,
      'isJustified': isJustified,
      if (recordedByUserId != null) 'recordedByUserId': recordedByUserId,
      if (documentReferenceUrl != null)
        'documentReferenceUrl': documentReferenceUrl,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhIncident',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'incidentType': incidentType,
      'severity': severity,
      'incidentDate': incidentDate.toJson(),
      'title': title,
      'description': description,
      'actionTaken': actionTaken,
      'isJustified': isJustified,
      if (recordedByUserId != null) 'recordedByUserId': recordedByUserId,
      if (documentReferenceUrl != null)
        'documentReferenceUrl': documentReferenceUrl,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RrhhIncidentInclude include() {
    return RrhhIncidentInclude._();
  }

  static RrhhIncidentIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhIncidentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhIncidentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhIncidentTable>? orderByList,
    RrhhIncidentInclude? include,
  }) {
    return RrhhIncidentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhIncident.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhIncident.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhIncidentImpl extends RrhhIncident {
  _RrhhIncidentImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         incidentType: incidentType,
         severity: severity,
         incidentDate: incidentDate,
         title: title,
         description: description,
         actionTaken: actionTaken,
         isJustified: isJustified,
         recordedByUserId: recordedByUserId,
         documentReferenceUrl: documentReferenceUrl,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhIncident]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhIncident copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? incidentType,
    String? severity,
    DateTime? incidentDate,
    String? title,
    String? description,
    String? actionTaken,
    bool? isJustified,
    Object? recordedByUserId = _Undefined,
    Object? documentReferenceUrl = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhIncident(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      incidentType: incidentType ?? this.incidentType,
      severity: severity ?? this.severity,
      incidentDate: incidentDate ?? this.incidentDate,
      title: title ?? this.title,
      description: description ?? this.description,
      actionTaken: actionTaken ?? this.actionTaken,
      isJustified: isJustified ?? this.isJustified,
      recordedByUserId: recordedByUserId is int?
          ? recordedByUserId
          : this.recordedByUserId,
      documentReferenceUrl: documentReferenceUrl is String?
          ? documentReferenceUrl
          : this.documentReferenceUrl,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RrhhIncidentUpdateTable extends _i1.UpdateTable<RrhhIncidentTable> {
  RrhhIncidentUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> employeeId(int value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<String, String> employeeCode(String value) => _i1.ColumnValue(
    table.employeeCode,
    value,
  );

  _i1.ColumnValue<String, String> employeeName(String value) => _i1.ColumnValue(
    table.employeeName,
    value,
  );

  _i1.ColumnValue<String, String> incidentType(String value) => _i1.ColumnValue(
    table.incidentType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> incidentDate(DateTime value) =>
      _i1.ColumnValue(
        table.incidentDate,
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

  _i1.ColumnValue<String, String> actionTaken(String value) => _i1.ColumnValue(
    table.actionTaken,
    value,
  );

  _i1.ColumnValue<bool, bool> isJustified(bool value) => _i1.ColumnValue(
    table.isJustified,
    value,
  );

  _i1.ColumnValue<int, int> recordedByUserId(int? value) => _i1.ColumnValue(
    table.recordedByUserId,
    value,
  );

  _i1.ColumnValue<String, String> documentReferenceUrl(String? value) =>
      _i1.ColumnValue(
        table.documentReferenceUrl,
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

class RrhhIncidentTable extends _i1.Table<int?> {
  RrhhIncidentTable({super.tableRelation}) : super(tableName: 'rrhh_incident') {
    updateTable = RrhhIncidentUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    employeeCode = _i1.ColumnString(
      'employeeCode',
      this,
    );
    employeeName = _i1.ColumnString(
      'employeeName',
      this,
    );
    incidentType = _i1.ColumnString(
      'incidentType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    incidentDate = _i1.ColumnDateTime(
      'incidentDate',
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
    actionTaken = _i1.ColumnString(
      'actionTaken',
      this,
    );
    isJustified = _i1.ColumnBool(
      'isJustified',
      this,
      hasDefault: true,
    );
    recordedByUserId = _i1.ColumnInt(
      'recordedByUserId',
      this,
    );
    documentReferenceUrl = _i1.ColumnString(
      'documentReferenceUrl',
      this,
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

  late final RrhhIncidentUpdateTable updateTable;

  /// Código de incidente (ej: INC-2026-001)
  late final _i1.ColumnString code;

  /// Colaborador afectado / reconocido
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  /// Tipo: 'FALTA_INJUSTIFICADA', 'ATRASO_REITERADO', 'LLAMADO_ATENCION_LEVE', 'MEMORANDUM_GRAVE', 'SUSPENSION_TEMPORAL', 'FELICITACION', 'RECONOCIMIENTO'
  late final _i1.ColumnString incidentType;

  /// Severidad: 'POSITIVA', 'LEVE', 'MODERADA', 'GRAVE'
  late final _i1.ColumnString severity;

  /// Fecha del suceso
  late final _i1.ColumnDateTime incidentDate;

  /// Título y descripción
  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  /// Medida correctiva / efecto laboral
  late final _i1.ColumnString actionTaken;

  late final _i1.ColumnBool isJustified;

  /// Auditoría
  late final _i1.ColumnInt recordedByUserId;

  late final _i1.ColumnString documentReferenceUrl;

  /// Eliminación lógica y fechas
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    employeeId,
    employeeCode,
    employeeName,
    incidentType,
    severity,
    incidentDate,
    title,
    description,
    actionTaken,
    isJustified,
    recordedByUserId,
    documentReferenceUrl,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class RrhhIncidentInclude extends _i1.IncludeObject {
  RrhhIncidentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhIncident.t;
}

class RrhhIncidentIncludeList extends _i1.IncludeList {
  RrhhIncidentIncludeList._({
    _i1.WhereExpressionBuilder<RrhhIncidentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhIncident.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhIncident.t;
}

class RrhhIncidentRepository {
  const RrhhIncidentRepository._();

  /// Returns a list of [RrhhIncident]s matching the given query parameters.
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
  Future<List<RrhhIncident>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhIncidentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhIncidentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhIncidentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhIncident>(
      where: where?.call(RrhhIncident.t),
      orderBy: orderBy?.call(RrhhIncident.t),
      orderByList: orderByList?.call(RrhhIncident.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhIncident] matching the given query parameters.
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
  Future<RrhhIncident?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhIncidentTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhIncidentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhIncidentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhIncident>(
      where: where?.call(RrhhIncident.t),
      orderBy: orderBy?.call(RrhhIncident.t),
      orderByList: orderByList?.call(RrhhIncident.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhIncident] by its [id] or null if no such row exists.
  Future<RrhhIncident?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhIncident>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhIncident]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhIncident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhIncident>> insert(
    _i1.DatabaseSession session,
    List<RrhhIncident> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhIncident>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhIncident] and returns the inserted row.
  ///
  /// The returned [RrhhIncident] will have its `id` field set.
  Future<RrhhIncident> insertRow(
    _i1.DatabaseSession session,
    RrhhIncident row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhIncident>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhIncident]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhIncident>> update(
    _i1.DatabaseSession session,
    List<RrhhIncident> rows, {
    _i1.ColumnSelections<RrhhIncidentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhIncident>(
      rows,
      columns: columns?.call(RrhhIncident.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhIncident]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhIncident> updateRow(
    _i1.DatabaseSession session,
    RrhhIncident row, {
    _i1.ColumnSelections<RrhhIncidentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhIncident>(
      row,
      columns: columns?.call(RrhhIncident.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhIncident] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhIncident?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhIncidentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhIncident>(
      id,
      columnValues: columnValues(RrhhIncident.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhIncident]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhIncident>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhIncidentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RrhhIncidentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhIncidentTable>? orderBy,
    _i1.OrderByListBuilder<RrhhIncidentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhIncident>(
      columnValues: columnValues(RrhhIncident.t.updateTable),
      where: where(RrhhIncident.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhIncident.t),
      orderByList: orderByList?.call(RrhhIncident.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhIncident]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhIncident>> delete(
    _i1.DatabaseSession session,
    List<RrhhIncident> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhIncident>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhIncident].
  Future<RrhhIncident> deleteRow(
    _i1.DatabaseSession session,
    RrhhIncident row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhIncident>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhIncident>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhIncidentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhIncident>(
      where: where(RrhhIncident.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhIncidentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhIncident>(
      where: where?.call(RrhhIncident.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhIncident] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhIncidentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhIncident>(
      where: where(RrhhIncident.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
