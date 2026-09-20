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

/// Compromiso o tarea comercial agendada en el CRM.
abstract class CrmTask
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmTask._({
    this.id,
    required this.code,
    required this.title,
    required this.taskType,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.scheduledAt,
    required this.scheduledTimeText,
    String? priority,
    String? status,
    this.callContext,
    this.notes,
    this.leadId,
    this.opportunityId,
    this.customerId,
    this.contractId,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : priority = priority ?? 'Media',
       status = status ?? 'Pendiente',
       isDeleted = isDeleted ?? false;

  factory CrmTask({
    int? id,
    required String code,
    required String title,
    required String taskType,
    required String clientName,
    required String contactPerson,
    required String phone,
    required DateTime scheduledAt,
    required String scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmTaskImpl;

  factory CrmTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmTask(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      taskType: jsonSerialization['taskType'] as String,
      clientName: jsonSerialization['clientName'] as String,
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      scheduledAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      scheduledTimeText: jsonSerialization['scheduledTimeText'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      callContext: jsonSerialization['callContext'] as String?,
      notes: jsonSerialization['notes'] as String?,
      leadId: jsonSerialization['leadId'] as int?,
      opportunityId: jsonSerialization['opportunityId'] as int?,
      customerId: jsonSerialization['customerId'] as int?,
      contractId: jsonSerialization['contractId'] as int?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CrmTaskTable();

  static const db = CrmTaskRepository._();

  @override
  int? id;

  /// Código de seguimiento de la tarea (ej. TSK-001).
  String code;

  /// Título descriptivo del compromiso comercial.
  String title;

  /// Tipo de tarea: Llamada de Seguimiento, Enviar Cotización, Visita Técnica, Reunión Presencial / Virtual, Mensaje WhatsApp, Cobro / Seguimiento de Anticipo, Postventa / Control de Calidad, Renovación de Contrato.
  String taskType;

  /// Nombre del cliente o prospecto asociado.
  String clientName;

  /// Persona o contacto decisor.
  String contactPerson;

  /// Teléfono de contacto.
  String phone;

  /// Fecha programada de ejecución.
  DateTime scheduledAt;

  /// Texto de hora programada (ej. '10:00', '16:30').
  String scheduledTimeText;

  /// Prioridad: Alta / Urgente, Media, Normal.
  String priority;

  /// Estado: Pendiente, Completada, Pospuesta, Vencida.
  String status;

  /// Contexto de llamada o recordatorio operativo.
  String? callContext;

  /// Notas u observaciones posteriores a la gestión.
  String? notes;

  /// Enlaces transversales con otros submódulos
  int? leadId;

  int? opportunityId;

  int? customerId;

  int? contractId;

  /// Eliminación lógica y auditoría temporal
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmTask copyWith({
    int? id,
    String? code,
    String? title,
    String? taskType,
    String? clientName,
    String? contactPerson,
    String? phone,
    DateTime? scheduledAt,
    String? scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmTask',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'taskType': taskType,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'scheduledAt': scheduledAt.toJson(),
      'scheduledTimeText': scheduledTimeText,
      'priority': priority,
      'status': status,
      if (callContext != null) 'callContext': callContext,
      if (notes != null) 'notes': notes,
      if (leadId != null) 'leadId': leadId,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (customerId != null) 'customerId': customerId,
      if (contractId != null) 'contractId': contractId,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmTask',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'taskType': taskType,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'scheduledAt': scheduledAt.toJson(),
      'scheduledTimeText': scheduledTimeText,
      'priority': priority,
      'status': status,
      if (callContext != null) 'callContext': callContext,
      if (notes != null) 'notes': notes,
      if (leadId != null) 'leadId': leadId,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (customerId != null) 'customerId': customerId,
      if (contractId != null) 'contractId': contractId,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmTaskInclude include() {
    return CrmTaskInclude._();
  }

  static CrmTaskIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmTaskTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmTaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmTaskTable>? orderByList,
    CrmTaskInclude? include,
  }) {
    return CrmTaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmTask.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmTask.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmTaskImpl extends CrmTask {
  _CrmTaskImpl({
    int? id,
    required String code,
    required String title,
    required String taskType,
    required String clientName,
    required String contactPerson,
    required String phone,
    required DateTime scheduledAt,
    required String scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         title: title,
         taskType: taskType,
         clientName: clientName,
         contactPerson: contactPerson,
         phone: phone,
         scheduledAt: scheduledAt,
         scheduledTimeText: scheduledTimeText,
         priority: priority,
         status: status,
         callContext: callContext,
         notes: notes,
         leadId: leadId,
         opportunityId: opportunityId,
         customerId: customerId,
         contractId: contractId,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmTask copyWith({
    Object? id = _Undefined,
    String? code,
    String? title,
    String? taskType,
    String? clientName,
    String? contactPerson,
    String? phone,
    DateTime? scheduledAt,
    String? scheduledTimeText,
    String? priority,
    String? status,
    Object? callContext = _Undefined,
    Object? notes = _Undefined,
    Object? leadId = _Undefined,
    Object? opportunityId = _Undefined,
    Object? customerId = _Undefined,
    Object? contractId = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmTask(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      taskType: taskType ?? this.taskType,
      clientName: clientName ?? this.clientName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      scheduledTimeText: scheduledTimeText ?? this.scheduledTimeText,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      callContext: callContext is String? ? callContext : this.callContext,
      notes: notes is String? ? notes : this.notes,
      leadId: leadId is int? ? leadId : this.leadId,
      opportunityId: opportunityId is int? ? opportunityId : this.opportunityId,
      customerId: customerId is int? ? customerId : this.customerId,
      contractId: contractId is int? ? contractId : this.contractId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmTaskUpdateTable extends _i1.UpdateTable<CrmTaskTable> {
  CrmTaskUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> taskType(String value) => _i1.ColumnValue(
    table.taskType,
    value,
  );

  _i1.ColumnValue<String, String> clientName(String value) => _i1.ColumnValue(
    table.clientName,
    value,
  );

  _i1.ColumnValue<String, String> contactPerson(String value) =>
      _i1.ColumnValue(
        table.contactPerson,
        value,
      );

  _i1.ColumnValue<String, String> phone(String value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<String, String> scheduledTimeText(String value) =>
      _i1.ColumnValue(
        table.scheduledTimeText,
        value,
      );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> callContext(String? value) => _i1.ColumnValue(
    table.callContext,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<int, int> leadId(int? value) => _i1.ColumnValue(
    table.leadId,
    value,
  );

  _i1.ColumnValue<int, int> opportunityId(int? value) => _i1.ColumnValue(
    table.opportunityId,
    value,
  );

  _i1.ColumnValue<int, int> customerId(int? value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<int, int> contractId(int? value) => _i1.ColumnValue(
    table.contractId,
    value,
  );

  _i1.ColumnValue<bool, bool> isDeleted(bool value) => _i1.ColumnValue(
    table.isDeleted,
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

class CrmTaskTable extends _i1.Table<int?> {
  CrmTaskTable({super.tableRelation}) : super(tableName: 'crm_task') {
    updateTable = CrmTaskUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    taskType = _i1.ColumnString(
      'taskType',
      this,
    );
    clientName = _i1.ColumnString(
      'clientName',
      this,
    );
    contactPerson = _i1.ColumnString(
      'contactPerson',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
    );
    scheduledTimeText = _i1.ColumnString(
      'scheduledTimeText',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    callContext = _i1.ColumnString(
      'callContext',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    leadId = _i1.ColumnInt(
      'leadId',
      this,
    );
    opportunityId = _i1.ColumnInt(
      'opportunityId',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    contractId = _i1.ColumnInt(
      'contractId',
      this,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
      hasDefault: true,
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

  late final CrmTaskUpdateTable updateTable;

  /// Código de seguimiento de la tarea (ej. TSK-001).
  late final _i1.ColumnString code;

  /// Título descriptivo del compromiso comercial.
  late final _i1.ColumnString title;

  /// Tipo de tarea: Llamada de Seguimiento, Enviar Cotización, Visita Técnica, Reunión Presencial / Virtual, Mensaje WhatsApp, Cobro / Seguimiento de Anticipo, Postventa / Control de Calidad, Renovación de Contrato.
  late final _i1.ColumnString taskType;

  /// Nombre del cliente o prospecto asociado.
  late final _i1.ColumnString clientName;

  /// Persona o contacto decisor.
  late final _i1.ColumnString contactPerson;

  /// Teléfono de contacto.
  late final _i1.ColumnString phone;

  /// Fecha programada de ejecución.
  late final _i1.ColumnDateTime scheduledAt;

  /// Texto de hora programada (ej. '10:00', '16:30').
  late final _i1.ColumnString scheduledTimeText;

  /// Prioridad: Alta / Urgente, Media, Normal.
  late final _i1.ColumnString priority;

  /// Estado: Pendiente, Completada, Pospuesta, Vencida.
  late final _i1.ColumnString status;

  /// Contexto de llamada o recordatorio operativo.
  late final _i1.ColumnString callContext;

  /// Notas u observaciones posteriores a la gestión.
  late final _i1.ColumnString notes;

  /// Enlaces transversales con otros submódulos
  late final _i1.ColumnInt leadId;

  late final _i1.ColumnInt opportunityId;

  late final _i1.ColumnInt customerId;

  late final _i1.ColumnInt contractId;

  /// Eliminación lógica y auditoría temporal
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    title,
    taskType,
    clientName,
    contactPerson,
    phone,
    scheduledAt,
    scheduledTimeText,
    priority,
    status,
    callContext,
    notes,
    leadId,
    opportunityId,
    customerId,
    contractId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmTaskInclude extends _i1.IncludeObject {
  CrmTaskInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmTask.t;
}

class CrmTaskIncludeList extends _i1.IncludeList {
  CrmTaskIncludeList._({
    _i1.WhereExpressionBuilder<CrmTaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmTask.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmTask.t;
}

class CrmTaskRepository {
  const CrmTaskRepository._();

  /// Returns a list of [CrmTask]s matching the given query parameters.
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
  Future<List<CrmTask>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmTaskTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmTaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmTaskTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmTask>(
      where: where?.call(CrmTask.t),
      orderBy: orderBy?.call(CrmTask.t),
      orderByList: orderByList?.call(CrmTask.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmTask] matching the given query parameters.
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
  Future<CrmTask?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmTaskTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmTaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmTaskTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmTask>(
      where: where?.call(CrmTask.t),
      orderBy: orderBy?.call(CrmTask.t),
      orderByList: orderByList?.call(CrmTask.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmTask] by its [id] or null if no such row exists.
  Future<CrmTask?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmTask>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmTask]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmTask>> insert(
    _i1.DatabaseSession session,
    List<CrmTask> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmTask>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmTask] and returns the inserted row.
  ///
  /// The returned [CrmTask] will have its `id` field set.
  Future<CrmTask> insertRow(
    _i1.DatabaseSession session,
    CrmTask row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmTask>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmTask]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmTask>> update(
    _i1.DatabaseSession session,
    List<CrmTask> rows, {
    _i1.ColumnSelections<CrmTaskTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmTask>(
      rows,
      columns: columns?.call(CrmTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmTask]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmTask> updateRow(
    _i1.DatabaseSession session,
    CrmTask row, {
    _i1.ColumnSelections<CrmTaskTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmTask>(
      row,
      columns: columns?.call(CrmTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmTask] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmTask?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmTaskUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmTask>(
      id,
      columnValues: columnValues(CrmTask.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmTask]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmTask>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmTaskUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmTaskTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmTaskTable>? orderBy,
    _i1.OrderByListBuilder<CrmTaskTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmTask>(
      columnValues: columnValues(CrmTask.t.updateTable),
      where: where(CrmTask.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmTask.t),
      orderByList: orderByList?.call(CrmTask.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmTask]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmTask>> delete(
    _i1.DatabaseSession session,
    List<CrmTask> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmTask>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmTask].
  Future<CrmTask> deleteRow(
    _i1.DatabaseSession session,
    CrmTask row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmTask>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmTask>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmTaskTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmTask>(
      where: where(CrmTask.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmTaskTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmTask>(
      where: where?.call(CrmTask.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmTask] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmTaskTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmTask>(
      where: where(CrmTask.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
