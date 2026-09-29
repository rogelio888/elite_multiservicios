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

/// Movimiento de Kárdex Valuado para integración contable de inventario.
abstract class AccountingKardexMovement
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountingKardexMovement._({
    this.id,
    required this.itemId,
    required this.itemName,
    required this.date,
    required this.movementType,
    required this.referenceDoc,
    this.workOrderId,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    required this.balanceQuantity,
    required this.balanceTotalCost,
    this.notes,
    required this.createdAt,
  });

  factory AccountingKardexMovement({
    int? id,
    required int itemId,
    required String itemName,
    required DateTime date,
    required String movementType,
    required String referenceDoc,
    int? workOrderId,
    required double quantity,
    required double unitCost,
    required double totalCost,
    required double balanceQuantity,
    required double balanceTotalCost,
    String? notes,
    required DateTime createdAt,
  }) = _AccountingKardexMovementImpl;

  factory AccountingKardexMovement.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingKardexMovement(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      itemName: jsonSerialization['itemName'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      movementType: jsonSerialization['movementType'] as String,
      referenceDoc: jsonSerialization['referenceDoc'] as String,
      workOrderId: jsonSerialization['workOrderId'] as int?,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unitCost: (jsonSerialization['unitCost'] as num).toDouble(),
      totalCost: (jsonSerialization['totalCost'] as num).toDouble(),
      balanceQuantity: (jsonSerialization['balanceQuantity'] as num).toDouble(),
      balanceTotalCost: (jsonSerialization['balanceTotalCost'] as num)
          .toDouble(),
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AccountingKardexMovementTable();

  static const db = AccountingKardexMovementRepository._();

  @override
  int? id;

  /// ID del item de inventario relacionado (OpsInventoryItem).
  int itemId;

  /// Nombre o código del item para trazabilidad rápida.
  String itemName;

  /// Fecha del movimiento contable de inventario.
  DateTime date;

  /// Tipo: IN_PURCHASE (Compra), OUT_WORK_ORDER (Uso en OT), IN_ADJUSTMENT (Ajuste +), OUT_ADJUSTMENT (Ajuste -).
  String movementType;

  /// Documento de referencia (ej. Factura Compra #123, OT #45, Acta de Inventario).
  String referenceDoc;

  /// ID de Orden de Trabajo vinculada si aplica.
  int? workOrderId;

  /// Cantidad física que ingresa o egresa.
  double quantity;

  /// Costo unitario ponderado del movimiento.
  double unitCost;

  /// Costo total del movimiento monetario.
  double totalCost;

  /// Saldo de cantidad en inventario tras el movimiento.
  double balanceQuantity;

  /// Valoración monetaria total del inventario tras el movimiento.
  double balanceTotalCost;

  /// Notas adicionales o justificación.
  String? notes;

  /// Fechas de auditoría.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountingKardexMovement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingKardexMovement copyWith({
    int? id,
    int? itemId,
    String? itemName,
    DateTime? date,
    String? movementType,
    String? referenceDoc,
    int? workOrderId,
    double? quantity,
    double? unitCost,
    double? totalCost,
    double? balanceQuantity,
    double? balanceTotalCost,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingKardexMovement',
      if (id != null) 'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'date': date.toJson(),
      'movementType': movementType,
      'referenceDoc': referenceDoc,
      if (workOrderId != null) 'workOrderId': workOrderId,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'balanceQuantity': balanceQuantity,
      'balanceTotalCost': balanceTotalCost,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountingKardexMovement',
      if (id != null) 'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'date': date.toJson(),
      'movementType': movementType,
      'referenceDoc': referenceDoc,
      if (workOrderId != null) 'workOrderId': workOrderId,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'balanceQuantity': balanceQuantity,
      'balanceTotalCost': balanceTotalCost,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  static AccountingKardexMovementInclude include() {
    return AccountingKardexMovementInclude._();
  }

  static AccountingKardexMovementIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountingKardexMovementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingKardexMovementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingKardexMovementTable>? orderByList,
    AccountingKardexMovementInclude? include,
  }) {
    return AccountingKardexMovementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingKardexMovement.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountingKardexMovement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingKardexMovementImpl extends AccountingKardexMovement {
  _AccountingKardexMovementImpl({
    int? id,
    required int itemId,
    required String itemName,
    required DateTime date,
    required String movementType,
    required String referenceDoc,
    int? workOrderId,
    required double quantity,
    required double unitCost,
    required double totalCost,
    required double balanceQuantity,
    required double balanceTotalCost,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         itemId: itemId,
         itemName: itemName,
         date: date,
         movementType: movementType,
         referenceDoc: referenceDoc,
         workOrderId: workOrderId,
         quantity: quantity,
         unitCost: unitCost,
         totalCost: totalCost,
         balanceQuantity: balanceQuantity,
         balanceTotalCost: balanceTotalCost,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingKardexMovement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingKardexMovement copyWith({
    Object? id = _Undefined,
    int? itemId,
    String? itemName,
    DateTime? date,
    String? movementType,
    String? referenceDoc,
    Object? workOrderId = _Undefined,
    double? quantity,
    double? unitCost,
    double? totalCost,
    double? balanceQuantity,
    double? balanceTotalCost,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return AccountingKardexMovement(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      date: date ?? this.date,
      movementType: movementType ?? this.movementType,
      referenceDoc: referenceDoc ?? this.referenceDoc,
      workOrderId: workOrderId is int? ? workOrderId : this.workOrderId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      balanceQuantity: balanceQuantity ?? this.balanceQuantity,
      balanceTotalCost: balanceTotalCost ?? this.balanceTotalCost,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AccountingKardexMovementUpdateTable
    extends _i1.UpdateTable<AccountingKardexMovementTable> {
  AccountingKardexMovementUpdateTable(super.table);

  _i1.ColumnValue<int, int> itemId(int value) => _i1.ColumnValue(
    table.itemId,
    value,
  );

  _i1.ColumnValue<String, String> itemName(String value) => _i1.ColumnValue(
    table.itemName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> movementType(String value) => _i1.ColumnValue(
    table.movementType,
    value,
  );

  _i1.ColumnValue<String, String> referenceDoc(String value) => _i1.ColumnValue(
    table.referenceDoc,
    value,
  );

  _i1.ColumnValue<int, int> workOrderId(int? value) => _i1.ColumnValue(
    table.workOrderId,
    value,
  );

  _i1.ColumnValue<double, double> quantity(double value) => _i1.ColumnValue(
    table.quantity,
    value,
  );

  _i1.ColumnValue<double, double> unitCost(double value) => _i1.ColumnValue(
    table.unitCost,
    value,
  );

  _i1.ColumnValue<double, double> totalCost(double value) => _i1.ColumnValue(
    table.totalCost,
    value,
  );

  _i1.ColumnValue<double, double> balanceQuantity(double value) =>
      _i1.ColumnValue(
        table.balanceQuantity,
        value,
      );

  _i1.ColumnValue<double, double> balanceTotalCost(double value) =>
      _i1.ColumnValue(
        table.balanceTotalCost,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccountingKardexMovementTable extends _i1.Table<int?> {
  AccountingKardexMovementTable({super.tableRelation})
    : super(tableName: 'accounting_kardex_movement') {
    updateTable = AccountingKardexMovementUpdateTable(this);
    itemId = _i1.ColumnInt(
      'itemId',
      this,
    );
    itemName = _i1.ColumnString(
      'itemName',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    movementType = _i1.ColumnString(
      'movementType',
      this,
    );
    referenceDoc = _i1.ColumnString(
      'referenceDoc',
      this,
    );
    workOrderId = _i1.ColumnInt(
      'workOrderId',
      this,
    );
    quantity = _i1.ColumnDouble(
      'quantity',
      this,
    );
    unitCost = _i1.ColumnDouble(
      'unitCost',
      this,
    );
    totalCost = _i1.ColumnDouble(
      'totalCost',
      this,
    );
    balanceQuantity = _i1.ColumnDouble(
      'balanceQuantity',
      this,
    );
    balanceTotalCost = _i1.ColumnDouble(
      'balanceTotalCost',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AccountingKardexMovementUpdateTable updateTable;

  /// ID del item de inventario relacionado (OpsInventoryItem).
  late final _i1.ColumnInt itemId;

  /// Nombre o código del item para trazabilidad rápida.
  late final _i1.ColumnString itemName;

  /// Fecha del movimiento contable de inventario.
  late final _i1.ColumnDateTime date;

  /// Tipo: IN_PURCHASE (Compra), OUT_WORK_ORDER (Uso en OT), IN_ADJUSTMENT (Ajuste +), OUT_ADJUSTMENT (Ajuste -).
  late final _i1.ColumnString movementType;

  /// Documento de referencia (ej. Factura Compra #123, OT #45, Acta de Inventario).
  late final _i1.ColumnString referenceDoc;

  /// ID de Orden de Trabajo vinculada si aplica.
  late final _i1.ColumnInt workOrderId;

  /// Cantidad física que ingresa o egresa.
  late final _i1.ColumnDouble quantity;

  /// Costo unitario ponderado del movimiento.
  late final _i1.ColumnDouble unitCost;

  /// Costo total del movimiento monetario.
  late final _i1.ColumnDouble totalCost;

  /// Saldo de cantidad en inventario tras el movimiento.
  late final _i1.ColumnDouble balanceQuantity;

  /// Valoración monetaria total del inventario tras el movimiento.
  late final _i1.ColumnDouble balanceTotalCost;

  /// Notas adicionales o justificación.
  late final _i1.ColumnString notes;

  /// Fechas de auditoría.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    itemId,
    itemName,
    date,
    movementType,
    referenceDoc,
    workOrderId,
    quantity,
    unitCost,
    totalCost,
    balanceQuantity,
    balanceTotalCost,
    notes,
    createdAt,
  ];
}

class AccountingKardexMovementInclude extends _i1.IncludeObject {
  AccountingKardexMovementInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountingKardexMovement.t;
}

class AccountingKardexMovementIncludeList extends _i1.IncludeList {
  AccountingKardexMovementIncludeList._({
    _i1.WhereExpressionBuilder<AccountingKardexMovementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountingKardexMovement.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountingKardexMovement.t;
}

class AccountingKardexMovementRepository {
  const AccountingKardexMovementRepository._();

  /// Returns a list of [AccountingKardexMovement]s matching the given query parameters.
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
  Future<List<AccountingKardexMovement>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingKardexMovementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingKardexMovementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingKardexMovementTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountingKardexMovement>(
      where: where?.call(AccountingKardexMovement.t),
      orderBy: orderBy?.call(AccountingKardexMovement.t),
      orderByList: orderByList?.call(AccountingKardexMovement.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountingKardexMovement] matching the given query parameters.
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
  Future<AccountingKardexMovement?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingKardexMovementTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountingKardexMovementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountingKardexMovementTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountingKardexMovement>(
      where: where?.call(AccountingKardexMovement.t),
      orderBy: orderBy?.call(AccountingKardexMovement.t),
      orderByList: orderByList?.call(AccountingKardexMovement.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountingKardexMovement] by its [id] or null if no such row exists.
  Future<AccountingKardexMovement?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountingKardexMovement>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountingKardexMovement]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountingKardexMovement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AccountingKardexMovement>> insert(
    _i1.DatabaseSession session,
    List<AccountingKardexMovement> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AccountingKardexMovement>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AccountingKardexMovement] and returns the inserted row.
  ///
  /// The returned [AccountingKardexMovement] will have its `id` field set.
  Future<AccountingKardexMovement> insertRow(
    _i1.DatabaseSession session,
    AccountingKardexMovement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountingKardexMovement>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountingKardexMovement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountingKardexMovement>> update(
    _i1.DatabaseSession session,
    List<AccountingKardexMovement> rows, {
    _i1.ColumnSelections<AccountingKardexMovementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountingKardexMovement>(
      rows,
      columns: columns?.call(AccountingKardexMovement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingKardexMovement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountingKardexMovement> updateRow(
    _i1.DatabaseSession session,
    AccountingKardexMovement row, {
    _i1.ColumnSelections<AccountingKardexMovementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountingKardexMovement>(
      row,
      columns: columns?.call(AccountingKardexMovement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountingKardexMovement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountingKardexMovement?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountingKardexMovementUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountingKardexMovement>(
      id,
      columnValues: columnValues(AccountingKardexMovement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountingKardexMovement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountingKardexMovement>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AccountingKardexMovementUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AccountingKardexMovementTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountingKardexMovementTable>? orderBy,
    _i1.OrderByListBuilder<AccountingKardexMovementTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountingKardexMovement>(
      columnValues: columnValues(AccountingKardexMovement.t.updateTable),
      where: where(AccountingKardexMovement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountingKardexMovement.t),
      orderByList: orderByList?.call(AccountingKardexMovement.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AccountingKardexMovement]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountingKardexMovement>> delete(
    _i1.DatabaseSession session,
    List<AccountingKardexMovement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountingKardexMovement>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountingKardexMovement].
  Future<AccountingKardexMovement> deleteRow(
    _i1.DatabaseSession session,
    AccountingKardexMovement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountingKardexMovement>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountingKardexMovement>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingKardexMovementTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountingKardexMovement>(
      where: where(AccountingKardexMovement.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AccountingKardexMovementTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountingKardexMovement>(
      where: where?.call(AccountingKardexMovement.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountingKardexMovement] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AccountingKardexMovementTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountingKardexMovement>(
      where: where(AccountingKardexMovement.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
