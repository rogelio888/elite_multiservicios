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

/// Centro de Costo (Cost Center) para medir rentabilidad por contrato o unidad.
abstract class AccountingCostCenter
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingCostCenter._({
    this.id,
    required this.name,
    this.contractId,
    String? status,
    this.description,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Activo',
       isDeleted = isDeleted ?? false;

  factory AccountingCostCenter({
    int? id,
    required String name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingCostCenterImpl;

  factory AccountingCostCenter.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingCostCenter(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      contractId: jsonSerialization['contractId'] as int?,
      status: jsonSerialization['status'] as String?,
      description: jsonSerialization['description'] as String?,
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

  static final t = AccountingCostCenterTable();

  static const db = AccountingCostCenterRepository._();

  @override
  int? id;

  /// Nombre del centro de costo (ej. 'Condominio Las Palmas - Jardinería').
  String name;

  /// ID del contrato asociado en el CRM (opcional, si es para un contrato específico).
  int? contractId;

  /// Estado operativo: Activo, Cerrado.
  String status;

  /// Descripción detallada del centro de costo.
  String? description;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingCostCenter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingCostCenter copyWith({
    int? id,
    String? name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingCostCenter',
      if (id != null) 'id': id,
      'name': name,
      if (contractId != null) 'contractId': contractId,
      'status': status,
      if (description != null) 'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingCostCenter',
      if (id != null) 'id': id,
      'name': name,
      if (contractId != null) 'contractId': contractId,
      'status': status,
      if (description != null) 'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AccountingCostCenterInclude include() {
    return AccountingCostCenterInclude._();
  }

  static AccountingCostCenterIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingCostCenterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingCostCenterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingCostCenterTable>? orderByList,
    AccountingCostCenterInclude? include,
  }) {
    return AccountingCostCenterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingCostCenter.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingCostCenter.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingCostCenterImpl extends AccountingCostCenter {
  _AccountingCostCenterImpl({
    int? id,
    required String name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         contractId: contractId,
         status: status,
         description: description,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingCostCenter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingCostCenter copyWith({
    Object? id = _Undefined,
    String? name,
    Object? contractId = _Undefined,
    String? status,
    Object? description = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingCostCenter(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      contractId: contractId is int? ? contractId : this.contractId,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AccountingCostCenterUpdateTable
    extends _i1.UpdateTable<AccountingCostCenterTable> {
  AccountingCostCenterUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<int, int> contractId(int? value) => _i1.ColumnValue(
    table.contractId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
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

class AccountingCostCenterTable extends _i1.Table<int?> {
  AccountingCostCenterTable({super.tableRelation})
    : super(tableName: 'accounting_cost_center') {
    updateTable = AccountingCostCenterUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    contractId = _i1.ColumnInt(
      'contractId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    description = _i1.ColumnString(
      'description',
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

  late final AccountingCostCenterUpdateTable updateTable;

  /// Nombre del centro de costo (ej. 'Condominio Las Palmas - Jardinería').
  late final _i1.ColumnString name;

  /// ID del contrato asociado en el CRM (opcional, si es para un contrato específico).
  late final _i1.ColumnInt contractId;

  /// Estado operativo: Activo, Cerrado.
  late final _i1.ColumnString status;

  /// Descripción detallada del centro de costo.
  late final _i1.ColumnString description;

  /// Eliminación lógica (Soft Delete).
  late final _i1.ColumnBool isDeleted;

  /// Fechas de auditoría.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    contractId,
    status,
    description,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class AccountingCostCenterInclude extends _i1.IncludeObject {
  AccountingCostCenterInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingCostCenter.t;
}

class AccountingCostCenterIncludeList extends _i1.IncludeList {
  AccountingCostCenterIncludeList._({
    _i1.WhereExpressionBuilder<AccountingCostCenterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingCostCenter.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingCostCenter.t;
}

class AccountingCostCenterRepository {
  const AccountingCostCenterRepository._();

  /// Returns a list of [AccountingCostCenter]s matching the given query parameters.
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
  Future<List<AccountingCostCenter>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingCostCenterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingCostCenterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingCostCenterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingCostCenter>(
      where: where?.call(AccountingCostCenter.t),
      orderBy: orderBy?.call(AccountingCostCenter.t),
      orderByList: orderByList?.call(AccountingCostCenter.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingCostCenter] matching the given query parameters.
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
  Future<AccountingCostCenter?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingCostCenterTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingCostCenterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingCostCenterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingCostCenter>(
      where: where?.call(AccountingCostCenter.t),
      orderBy: orderBy?.call(AccountingCostCenter.t),
      orderByList: orderByList?.call(AccountingCostCenter.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingCostCenter] by its [id] or null if no such row exists.
  Future<AccountingCostCenter?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingCostCenter>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingCostCenter]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingCostCenter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingCostCenter>> insert(
    _i1.DatabaseSession session,
    List<AccountingCostCenter> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingCostCenter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingCostCenter] and returns the inserted row.
  ///
  /// The returned [AccountingCostCenter] will have its `id` field set.
  Future<AccountingCostCenter> insertRow(
    _i1.DatabaseSession session,
    AccountingCostCenter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingCostCenter>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingCostCenter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingCostCenter>> update(
    _i1.DatabaseSession session,
    List<AccountingCostCenter> rows, {
    _i1.ColumnSelections<AccountingCostCenterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingCostCenter>(
      rows,
      columns: columns?.call(AccountingCostCenter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingCostCenter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingCostCenter> updateRow(
    _i1.DatabaseSession session,
    AccountingCostCenter row, {
    _i1.ColumnSelections<AccountingCostCenterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingCostCenter>(
      row,
      columns: columns?.call(AccountingCostCenter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingCostCenter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingCostCenter?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingCostCenterUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingCostCenter>(
      id,
      columnValues: columnValues(AccountingCostCenter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingCostCenter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingCostCenter>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingCostCenterUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingCostCenterTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingCostCenterTable>? orderBy,
    _i1.OrderByListBuilder<AccountingCostCenterTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingCostCenter>(
      columnValues: columnValues(AccountingCostCenter.t.updateTable),
      where: where(AccountingCostCenter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingCostCenter.t),
      orderByList: orderByList?.call(AccountingCostCenter.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingCostCenter]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingCostCenter>> delete(
    _i1.DatabaseSession session,
    List<AccountingCostCenter> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingCostCenter>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingCostCenter].
  Future<AccountingCostCenter> deleteRow(
    _i1.DatabaseSession session,
    AccountingCostCenter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingCostCenter>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingCostCenter>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingCostCenterTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingCostCenter>(
      where: where(AccountingCostCenter.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingCostCenterTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingCostCenter>(
      where: where?.call(AccountingCostCenter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingCostCenter] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingCostCenterTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingCostCenter>(
      where: where(AccountingCostCenter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
