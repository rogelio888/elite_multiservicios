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

/// Partida individual de cotización o presupuesto de un contrato.
abstract class CrmContractBudgetItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmContractBudgetItem._({
    this.id,
    required this.contractId,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isDeleted = isDeleted ?? false;

  factory CrmContractBudgetItem({
    int? id,
    required int contractId,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmContractBudgetItemImpl;

  factory CrmContractBudgetItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmContractBudgetItem(
      id: jsonSerialization['id'] as int?,
      contractId: jsonSerialization['contractId'] as int,
      description: jsonSerialization['description'] as String,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
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

  static final t = CrmContractBudgetItemTable();

  static const db = CrmContractBudgetItemRepository._();

  @override
  int? id;

  /// ID del contrato al que pertenece la partida.
  int contractId;

  /// Descripción detallada del ítem o servicio.
  String description;

  /// Cantidad requerida.
  double quantity;

  /// Unidad de medida (Mes, Puesto, Global, Horas, m², Unidad, Visita).
  String unit;

  /// Precio unitario en Bs.
  double unitPrice;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmContractBudgetItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmContractBudgetItem copyWith({
    int? id,
    int? contractId,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmContractBudgetItem',
      if (id != null) 'id': id,
      'contractId': contractId,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmContractBudgetItem',
      if (id != null) 'id': id,
      'contractId': contractId,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmContractBudgetItemInclude include() {
    return CrmContractBudgetItemInclude._();
  }

  static CrmContractBudgetItemIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmContractBudgetItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmContractBudgetItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmContractBudgetItemTable>? orderByList,
    CrmContractBudgetItemInclude? include,
  }) {
    return CrmContractBudgetItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmContractBudgetItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmContractBudgetItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmContractBudgetItemImpl extends CrmContractBudgetItem {
  _CrmContractBudgetItemImpl({
    int? id,
    required int contractId,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contractId: contractId,
         description: description,
         quantity: quantity,
         unit: unit,
         unitPrice: unitPrice,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmContractBudgetItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmContractBudgetItem copyWith({
    Object? id = _Undefined,
    int? contractId,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmContractBudgetItem(
      id: id is int? ? id : this.id,
      contractId: contractId ?? this.contractId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmContractBudgetItemUpdateTable
    extends _i1.UpdateTable<CrmContractBudgetItemTable> {
  CrmContractBudgetItemUpdateTable(super.table);

  _i1.ColumnValue<int, int> contractId(int value) => _i1.ColumnValue(
    table.contractId,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> quantity(double value) => _i1.ColumnValue(
    table.quantity,
    value,
  );

  _i1.ColumnValue<String, String> unit(String value) => _i1.ColumnValue(
    table.unit,
    value,
  );

  _i1.ColumnValue<double, double> unitPrice(double value) => _i1.ColumnValue(
    table.unitPrice,
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

class CrmContractBudgetItemTable extends _i1.Table<int?> {
  CrmContractBudgetItemTable({super.tableRelation})
    : super(tableName: 'crm_contract_budget_item') {
    updateTable = CrmContractBudgetItemUpdateTable(this);
    contractId = _i1.ColumnInt(
      'contractId',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    quantity = _i1.ColumnDouble(
      'quantity',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    unitPrice = _i1.ColumnDouble(
      'unitPrice',
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

  late final CrmContractBudgetItemUpdateTable updateTable;

  /// ID del contrato al que pertenece la partida.
  late final _i1.ColumnInt contractId;

  /// Descripción detallada del ítem o servicio.
  late final _i1.ColumnString description;

  /// Cantidad requerida.
  late final _i1.ColumnDouble quantity;

  /// Unidad de medida (Mes, Puesto, Global, Horas, m², Unidad, Visita).
  late final _i1.ColumnString unit;

  /// Precio unitario en Bs.
  late final _i1.ColumnDouble unitPrice;

  /// Eliminación lógica y auditoría temporal.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    contractId,
    description,
    quantity,
    unit,
    unitPrice,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmContractBudgetItemInclude extends _i1.IncludeObject {
  CrmContractBudgetItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmContractBudgetItem.t;
}

class CrmContractBudgetItemIncludeList extends _i1.IncludeList {
  CrmContractBudgetItemIncludeList._({
    _i1.WhereExpressionBuilder<CrmContractBudgetItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmContractBudgetItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmContractBudgetItem.t;
}

class CrmContractBudgetItemRepository {
  const CrmContractBudgetItemRepository._();

  /// Returns a list of [CrmContractBudgetItem]s matching the given query parameters.
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
  Future<List<CrmContractBudgetItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmContractBudgetItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmContractBudgetItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmContractBudgetItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmContractBudgetItem>(
      where: where?.call(CrmContractBudgetItem.t),
      orderBy: orderBy?.call(CrmContractBudgetItem.t),
      orderByList: orderByList?.call(CrmContractBudgetItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmContractBudgetItem] matching the given query parameters.
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
  Future<CrmContractBudgetItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmContractBudgetItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmContractBudgetItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmContractBudgetItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmContractBudgetItem>(
      where: where?.call(CrmContractBudgetItem.t),
      orderBy: orderBy?.call(CrmContractBudgetItem.t),
      orderByList: orderByList?.call(CrmContractBudgetItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmContractBudgetItem] by its [id] or null if no such row exists.
  Future<CrmContractBudgetItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmContractBudgetItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmContractBudgetItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmContractBudgetItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmContractBudgetItem>> insert(
    _i1.DatabaseSession session,
    List<CrmContractBudgetItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmContractBudgetItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmContractBudgetItem] and returns the inserted row.
  ///
  /// The returned [CrmContractBudgetItem] will have its `id` field set.
  Future<CrmContractBudgetItem> insertRow(
    _i1.DatabaseSession session,
    CrmContractBudgetItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmContractBudgetItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmContractBudgetItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmContractBudgetItem>> update(
    _i1.DatabaseSession session,
    List<CrmContractBudgetItem> rows, {
    _i1.ColumnSelections<CrmContractBudgetItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmContractBudgetItem>(
      rows,
      columns: columns?.call(CrmContractBudgetItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmContractBudgetItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmContractBudgetItem> updateRow(
    _i1.DatabaseSession session,
    CrmContractBudgetItem row, {
    _i1.ColumnSelections<CrmContractBudgetItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmContractBudgetItem>(
      row,
      columns: columns?.call(CrmContractBudgetItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmContractBudgetItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmContractBudgetItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmContractBudgetItemUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmContractBudgetItem>(
      id,
      columnValues: columnValues(CrmContractBudgetItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmContractBudgetItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmContractBudgetItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmContractBudgetItemUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CrmContractBudgetItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmContractBudgetItemTable>? orderBy,
    _i1.OrderByListBuilder<CrmContractBudgetItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmContractBudgetItem>(
      columnValues: columnValues(CrmContractBudgetItem.t.updateTable),
      where: where(CrmContractBudgetItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmContractBudgetItem.t),
      orderByList: orderByList?.call(CrmContractBudgetItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmContractBudgetItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmContractBudgetItem>> delete(
    _i1.DatabaseSession session,
    List<CrmContractBudgetItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmContractBudgetItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmContractBudgetItem].
  Future<CrmContractBudgetItem> deleteRow(
    _i1.DatabaseSession session,
    CrmContractBudgetItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmContractBudgetItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmContractBudgetItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmContractBudgetItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmContractBudgetItem>(
      where: where(CrmContractBudgetItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmContractBudgetItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmContractBudgetItem>(
      where: where?.call(CrmContractBudgetItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmContractBudgetItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmContractBudgetItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmContractBudgetItem>(
      where: where(CrmContractBudgetItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
