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

/// Registro inmutable de desvinculación formal (egreso laboral sin borrado físico).
abstract class RrhhTermination
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhTermination._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.employeeCi,
    required this.contractType,
    required this.entryDate,
    required this.terminationDate,
    required this.lastWorkingDay,
    required this.reason,
    required this.detailedReason,
    required this.yearsOfService,
    this.severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    this.processedByUserId,
    this.handoverNotes,
    required this.createdAt,
  }) : clearanceCompleted = clearanceCompleted ?? false,
       isEligibleForRehire = isEligibleForRehire ?? true;

  factory RrhhTermination({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String employeeCi,
    required String contractType,
    required DateTime entryDate,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    required double yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    required DateTime createdAt,
  }) = _RrhhTerminationImpl;

  factory RrhhTermination.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhTermination(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      employeeCi: jsonSerialization['employeeCi'] as String,
      contractType: jsonSerialization['contractType'] as String,
      entryDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['entryDate'],
      ),
      terminationDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['terminationDate'],
      ),
      lastWorkingDay: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastWorkingDay'],
      ),
      reason: jsonSerialization['reason'] as String,
      detailedReason: jsonSerialization['detailedReason'] as String,
      yearsOfService: (jsonSerialization['yearsOfService'] as num).toDouble(),
      severanceAmount: (jsonSerialization['severanceAmount'] as num?)
          ?.toDouble(),
      clearanceCompleted: jsonSerialization['clearanceCompleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['clearanceCompleted'],
            ),
      isEligibleForRehire: jsonSerialization['isEligibleForRehire'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isEligibleForRehire'],
            ),
      processedByUserId: jsonSerialization['processedByUserId'] as int?,
      handoverNotes: jsonSerialization['handoverNotes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RrhhTerminationTable();

  static const db = RrhhTerminationRepository._();

  @override
  int? id;

  /// Código de desvinculación (ej: DESV-2026-001)
  String code;

  /// Colaborador desvinculado (se mantiene intacto en rrhh_employee como INACTIVO)
  int employeeId;

  String employeeCode;

  String employeeName;

  String employeeCi;

  /// Régimen de contratación y antigüedad
  String contractType;

  DateTime entryDate;

  DateTime terminationDate;

  DateTime lastWorkingDay;

  /// Motivo: 'RENUNCIA_VOLUNTARIA', 'FIN_DE_CONTRATO', 'DESPIDO_JUSTIFICADO', 'DESPIDO_INJUSTIFICADO', 'MUTUO_ACUERDO', 'JUBILACION'
  String reason;

  String detailedReason;

  double yearsOfService;

  /// Liquidación y entrega de activos
  double? severanceAmount;

  bool clearanceCompleted;

  bool isEligibleForRehire;

  /// Auditoría administrativa
  int? processedByUserId;

  String? handoverNotes;

  /// Fecha inmutable de registro
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhTermination]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhTermination copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? employeeCi,
    String? contractType,
    DateTime? entryDate,
    DateTime? terminationDate,
    DateTime? lastWorkingDay,
    String? reason,
    String? detailedReason,
    double? yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhTermination',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'employeeCi': employeeCi,
      'contractType': contractType,
      'entryDate': entryDate.toJson(),
      'terminationDate': terminationDate.toJson(),
      'lastWorkingDay': lastWorkingDay.toJson(),
      'reason': reason,
      'detailedReason': detailedReason,
      'yearsOfService': yearsOfService,
      if (severanceAmount != null) 'severanceAmount': severanceAmount,
      'clearanceCompleted': clearanceCompleted,
      'isEligibleForRehire': isEligibleForRehire,
      if (processedByUserId != null) 'processedByUserId': processedByUserId,
      if (handoverNotes != null) 'handoverNotes': handoverNotes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhTermination',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'employeeCi': employeeCi,
      'contractType': contractType,
      'entryDate': entryDate.toJson(),
      'terminationDate': terminationDate.toJson(),
      'lastWorkingDay': lastWorkingDay.toJson(),
      'reason': reason,
      'detailedReason': detailedReason,
      'yearsOfService': yearsOfService,
      if (severanceAmount != null) 'severanceAmount': severanceAmount,
      'clearanceCompleted': clearanceCompleted,
      'isEligibleForRehire': isEligibleForRehire,
      if (processedByUserId != null) 'processedByUserId': processedByUserId,
      if (handoverNotes != null) 'handoverNotes': handoverNotes,
      'createdAt': createdAt.toJson(),
    };
  }

  static RrhhTerminationInclude include() {
    return RrhhTerminationInclude._();
  }

  static RrhhTerminationIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhTerminationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTerminationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTerminationTable>? orderByList,
    RrhhTerminationInclude? include,
  }) {
    return RrhhTerminationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhTermination.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhTermination.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhTerminationImpl extends RrhhTermination {
  _RrhhTerminationImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String employeeCi,
    required String contractType,
    required DateTime entryDate,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    required double yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         employeeCi: employeeCi,
         contractType: contractType,
         entryDate: entryDate,
         terminationDate: terminationDate,
         lastWorkingDay: lastWorkingDay,
         reason: reason,
         detailedReason: detailedReason,
         yearsOfService: yearsOfService,
         severanceAmount: severanceAmount,
         clearanceCompleted: clearanceCompleted,
         isEligibleForRehire: isEligibleForRehire,
         processedByUserId: processedByUserId,
         handoverNotes: handoverNotes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhTermination]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhTermination copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? employeeCi,
    String? contractType,
    DateTime? entryDate,
    DateTime? terminationDate,
    DateTime? lastWorkingDay,
    String? reason,
    String? detailedReason,
    double? yearsOfService,
    Object? severanceAmount = _Undefined,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    Object? processedByUserId = _Undefined,
    Object? handoverNotes = _Undefined,
    DateTime? createdAt,
  }) {
    return RrhhTermination(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      employeeCi: employeeCi ?? this.employeeCi,
      contractType: contractType ?? this.contractType,
      entryDate: entryDate ?? this.entryDate,
      terminationDate: terminationDate ?? this.terminationDate,
      lastWorkingDay: lastWorkingDay ?? this.lastWorkingDay,
      reason: reason ?? this.reason,
      detailedReason: detailedReason ?? this.detailedReason,
      yearsOfService: yearsOfService ?? this.yearsOfService,
      severanceAmount: severanceAmount is double?
          ? severanceAmount
          : this.severanceAmount,
      clearanceCompleted: clearanceCompleted ?? this.clearanceCompleted,
      isEligibleForRehire: isEligibleForRehire ?? this.isEligibleForRehire,
      processedByUserId: processedByUserId is int?
          ? processedByUserId
          : this.processedByUserId,
      handoverNotes: handoverNotes is String?
          ? handoverNotes
          : this.handoverNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RrhhTerminationUpdateTable extends _i1.UpdateTable<RrhhTerminationTable> {
  RrhhTerminationUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> employeeCi(String value) => _i1.ColumnValue(
    table.employeeCi,
    value,
  );

  _i1.ColumnValue<String, String> contractType(String value) => _i1.ColumnValue(
    table.contractType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> entryDate(DateTime value) =>
      _i1.ColumnValue(
        table.entryDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> terminationDate(DateTime value) =>
      _i1.ColumnValue(
        table.terminationDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastWorkingDay(DateTime value) =>
      _i1.ColumnValue(
        table.lastWorkingDay,
        value,
      );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<String, String> detailedReason(String value) =>
      _i1.ColumnValue(
        table.detailedReason,
        value,
      );

  _i1.ColumnValue<double, double> yearsOfService(double value) =>
      _i1.ColumnValue(
        table.yearsOfService,
        value,
      );

  _i1.ColumnValue<double, double> severanceAmount(double? value) =>
      _i1.ColumnValue(
        table.severanceAmount,
        value,
      );

  _i1.ColumnValue<bool, bool> clearanceCompleted(bool value) => _i1.ColumnValue(
    table.clearanceCompleted,
    value,
  );

  _i1.ColumnValue<bool, bool> isEligibleForRehire(bool value) =>
      _i1.ColumnValue(
        table.isEligibleForRehire,
        value,
      );

  _i1.ColumnValue<int, int> processedByUserId(int? value) => _i1.ColumnValue(
    table.processedByUserId,
    value,
  );

  _i1.ColumnValue<String, String> handoverNotes(String? value) =>
      _i1.ColumnValue(
        table.handoverNotes,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RrhhTerminationTable extends _i1.Table<int?> {
  RrhhTerminationTable({super.tableRelation})
    : super(tableName: 'rrhh_termination') {
    updateTable = RrhhTerminationUpdateTable(this);
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
    employeeCi = _i1.ColumnString(
      'employeeCi',
      this,
    );
    contractType = _i1.ColumnString(
      'contractType',
      this,
    );
    entryDate = _i1.ColumnDateTime(
      'entryDate',
      this,
    );
    terminationDate = _i1.ColumnDateTime(
      'terminationDate',
      this,
    );
    lastWorkingDay = _i1.ColumnDateTime(
      'lastWorkingDay',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    detailedReason = _i1.ColumnString(
      'detailedReason',
      this,
    );
    yearsOfService = _i1.ColumnDouble(
      'yearsOfService',
      this,
    );
    severanceAmount = _i1.ColumnDouble(
      'severanceAmount',
      this,
    );
    clearanceCompleted = _i1.ColumnBool(
      'clearanceCompleted',
      this,
      hasDefault: true,
    );
    isEligibleForRehire = _i1.ColumnBool(
      'isEligibleForRehire',
      this,
      hasDefault: true,
    );
    processedByUserId = _i1.ColumnInt(
      'processedByUserId',
      this,
    );
    handoverNotes = _i1.ColumnString(
      'handoverNotes',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RrhhTerminationUpdateTable updateTable;

  /// Código de desvinculación (ej: DESV-2026-001)
  late final _i1.ColumnString code;

  /// Colaborador desvinculado (se mantiene intacto en rrhh_employee como INACTIVO)
  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString employeeCode;

  late final _i1.ColumnString employeeName;

  late final _i1.ColumnString employeeCi;

  /// Régimen de contratación y antigüedad
  late final _i1.ColumnString contractType;

  late final _i1.ColumnDateTime entryDate;

  late final _i1.ColumnDateTime terminationDate;

  late final _i1.ColumnDateTime lastWorkingDay;

  /// Motivo: 'RENUNCIA_VOLUNTARIA', 'FIN_DE_CONTRATO', 'DESPIDO_JUSTIFICADO', 'DESPIDO_INJUSTIFICADO', 'MUTUO_ACUERDO', 'JUBILACION'
  late final _i1.ColumnString reason;

  late final _i1.ColumnString detailedReason;

  late final _i1.ColumnDouble yearsOfService;

  /// Liquidación y entrega de activos
  late final _i1.ColumnDouble severanceAmount;

  late final _i1.ColumnBool clearanceCompleted;

  late final _i1.ColumnBool isEligibleForRehire;

  /// Auditoría administrativa
  late final _i1.ColumnInt processedByUserId;

  late final _i1.ColumnString handoverNotes;

  /// Fecha inmutable de registro
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    employeeId,
    employeeCode,
    employeeName,
    employeeCi,
    contractType,
    entryDate,
    terminationDate,
    lastWorkingDay,
    reason,
    detailedReason,
    yearsOfService,
    severanceAmount,
    clearanceCompleted,
    isEligibleForRehire,
    processedByUserId,
    handoverNotes,
    createdAt,
  ];
}

class RrhhTerminationInclude extends _i1.IncludeObject {
  RrhhTerminationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhTermination.t;
}

class RrhhTerminationIncludeList extends _i1.IncludeList {
  RrhhTerminationIncludeList._({
    _i1.WhereExpressionBuilder<RrhhTerminationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhTermination.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhTermination.t;
}

class RrhhTerminationRepository {
  const RrhhTerminationRepository._();

  /// Returns a list of [RrhhTermination]s matching the given query parameters.
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
  Future<List<RrhhTermination>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTerminationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTerminationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTerminationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhTermination>(
      where: where?.call(RrhhTermination.t),
      orderBy: orderBy?.call(RrhhTermination.t),
      orderByList: orderByList?.call(RrhhTermination.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhTermination] matching the given query parameters.
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
  Future<RrhhTermination?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTerminationTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhTerminationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhTerminationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhTermination>(
      where: where?.call(RrhhTermination.t),
      orderBy: orderBy?.call(RrhhTermination.t),
      orderByList: orderByList?.call(RrhhTermination.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhTermination] by its [id] or null if no such row exists.
  Future<RrhhTermination?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhTermination>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhTermination]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhTermination]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhTermination>> insert(
    _i1.DatabaseSession session,
    List<RrhhTermination> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhTermination>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhTermination] and returns the inserted row.
  ///
  /// The returned [RrhhTermination] will have its `id` field set.
  Future<RrhhTermination> insertRow(
    _i1.DatabaseSession session,
    RrhhTermination row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhTermination>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhTermination]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhTermination>> update(
    _i1.DatabaseSession session,
    List<RrhhTermination> rows, {
    _i1.ColumnSelections<RrhhTerminationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhTermination>(
      rows,
      columns: columns?.call(RrhhTermination.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhTermination]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhTermination> updateRow(
    _i1.DatabaseSession session,
    RrhhTermination row, {
    _i1.ColumnSelections<RrhhTerminationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhTermination>(
      row,
      columns: columns?.call(RrhhTermination.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhTermination] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhTermination?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhTerminationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhTermination>(
      id,
      columnValues: columnValues(RrhhTermination.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhTermination]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhTermination>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhTerminationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhTerminationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhTerminationTable>? orderBy,
    _i1.OrderByListBuilder<RrhhTerminationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhTermination>(
      columnValues: columnValues(RrhhTermination.t.updateTable),
      where: where(RrhhTermination.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhTermination.t),
      orderByList: orderByList?.call(RrhhTermination.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhTermination]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhTermination>> delete(
    _i1.DatabaseSession session,
    List<RrhhTermination> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhTermination>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhTermination].
  Future<RrhhTermination> deleteRow(
    _i1.DatabaseSession session,
    RrhhTermination row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhTermination>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhTermination>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhTerminationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhTermination>(
      where: where(RrhhTermination.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhTerminationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhTermination>(
      where: where?.call(RrhhTermination.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhTermination] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhTerminationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhTermination>(
      where: where(RrhhTermination.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
