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

/// Partida o línea de cotización dentro de una oportunidad comercial.
abstract class CrmQuoteItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmQuoteItem._({
    this.id,
    required this.opportunityId,
    this.catalogItemId,
    this.catalogVersion,
    required this.category,
    required this.concept,
    String? calculationType,
    required this.unitType,
    required this.quantity,
    required this.unitPrice,
    this.metadata,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : calculationType = calculationType ?? 'PER_UNIT',
       isDeleted = isDeleted ?? false;

  factory CrmQuoteItem({
    int? id,
    required int opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    required String category,
    required String concept,
    String? calculationType,
    required String unitType,
    required double quantity,
    required double unitPrice,
    String? metadata,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmQuoteItemImpl;

  factory CrmQuoteItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmQuoteItem(
      id: jsonSerialization['id'] as int?,
      opportunityId: jsonSerialization['opportunityId'] as int,
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      catalogVersion: jsonSerialization['catalogVersion'] as int?,
      category: jsonSerialization['category'] as String,
      concept: jsonSerialization['concept'] as String,
      calculationType: jsonSerialization['calculationType'] as String?,
      unitType: jsonSerialization['unitType'] as String,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      metadata: jsonSerialization['metadata'] as String?,
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

  static final t = CrmQuoteItemTable();

  static const db = CrmQuoteItemRepository._();

  @override
  int? id;

  /// ID de la oportunidad a la que pertenece la cotización.
  int opportunityId;

  /// ID opcional de la partida de catálogo de origen (sin join estricto obligatorio).
  int? catalogItemId;

  /// Versión de la partida al momento de cotizar.
  int? catalogVersion;

  /// Categoría: Personal, Limpieza, Mantenimiento, Equipamiento, Materiales, Tecnología.
  String category;

  /// Concepto descriptivo del servicio o insumo.
  String concept;

  /// Tipo de cálculo congelado al cotizar.
  String calculationType;

  /// Tipo de unidad: Puesto 24/7, Puesto 12h, Operario, Global, m², Unid., Servicio, Kit, Tanque.
  String unitType;

  /// Cantidad requerida.
  double quantity;

  /// Precio unitario congelado en Bs.
  double unitPrice;

  /// Parámetros auxiliares congelados en formato JSON.
  String? metadata;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmQuoteItem copyWith({
    int? id,
    int? opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    String? category,
    String? concept,
    String? calculationType,
    String? unitType,
    double? quantity,
    double? unitPrice,
    String? metadata,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmQuoteItem',
      if (id != null) 'id': id,
      'opportunityId': opportunityId,
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      if (catalogVersion != null) 'catalogVersion': catalogVersion,
      'category': category,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'quantity': quantity,
      'unitPrice': unitPrice,
      if (metadata != null) 'metadata': metadata,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmQuoteItem',
      if (id != null) 'id': id,
      'opportunityId': opportunityId,
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      if (catalogVersion != null) 'catalogVersion': catalogVersion,
      'category': category,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'quantity': quantity,
      'unitPrice': unitPrice,
      if (metadata != null) 'metadata': metadata,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmQuoteItemInclude include() {
    return CrmQuoteItemInclude._();
  }

  static CrmQuoteItemIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmQuoteItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmQuoteItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmQuoteItemTable>? orderByList,
    CrmQuoteItemInclude? include,
  }) {
    return CrmQuoteItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmQuoteItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmQuoteItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmQuoteItemImpl extends CrmQuoteItem {
  _CrmQuoteItemImpl({
    int? id,
    required int opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    required String category,
    required String concept,
    String? calculationType,
    required String unitType,
    required double quantity,
    required double unitPrice,
    String? metadata,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         opportunityId: opportunityId,
         catalogItemId: catalogItemId,
         catalogVersion: catalogVersion,
         category: category,
         concept: concept,
         calculationType: calculationType,
         unitType: unitType,
         quantity: quantity,
         unitPrice: unitPrice,
         metadata: metadata,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmQuoteItem copyWith({
    Object? id = _Undefined,
    int? opportunityId,
    Object? catalogItemId = _Undefined,
    Object? catalogVersion = _Undefined,
    String? category,
    String? concept,
    String? calculationType,
    String? unitType,
    double? quantity,
    double? unitPrice,
    Object? metadata = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmQuoteItem(
      id: id is int? ? id : this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      catalogItemId: catalogItemId is int? ? catalogItemId : this.catalogItemId,
      catalogVersion: catalogVersion is int?
          ? catalogVersion
          : this.catalogVersion,
      category: category ?? this.category,
      concept: concept ?? this.concept,
      calculationType: calculationType ?? this.calculationType,
      unitType: unitType ?? this.unitType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      metadata: metadata is String? ? metadata : this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmQuoteItemUpdateTable extends _i1.UpdateTable<CrmQuoteItemTable> {
  CrmQuoteItemUpdateTable(super.table);

  _i1.ColumnValue<int, int> opportunityId(int value) => _i1.ColumnValue(
    table.opportunityId,
    value,
  );

  _i1.ColumnValue<int, int> catalogItemId(int? value) => _i1.ColumnValue(
    table.catalogItemId,
    value,
  );

  _i1.ColumnValue<int, int> catalogVersion(int? value) => _i1.ColumnValue(
    table.catalogVersion,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> concept(String value) => _i1.ColumnValue(
    table.concept,
    value,
  );

  _i1.ColumnValue<String, String> calculationType(String value) =>
      _i1.ColumnValue(
        table.calculationType,
        value,
      );

  _i1.ColumnValue<String, String> unitType(String value) => _i1.ColumnValue(
    table.unitType,
    value,
  );

  _i1.ColumnValue<double, double> quantity(double value) => _i1.ColumnValue(
    table.quantity,
    value,
  );

  _i1.ColumnValue<double, double> unitPrice(double value) => _i1.ColumnValue(
    table.unitPrice,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
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

class CrmQuoteItemTable extends _i1.Table<int?> {
  CrmQuoteItemTable({super.tableRelation})
    : super(tableName: 'crm_quote_item') {
    updateTable = CrmQuoteItemUpdateTable(this);
    opportunityId = _i1.ColumnInt(
      'opportunityId',
      this,
    );
    catalogItemId = _i1.ColumnInt(
      'catalogItemId',
      this,
    );
    catalogVersion = _i1.ColumnInt(
      'catalogVersion',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    concept = _i1.ColumnString(
      'concept',
      this,
    );
    calculationType = _i1.ColumnString(
      'calculationType',
      this,
      hasDefault: true,
    );
    unitType = _i1.ColumnString(
      'unitType',
      this,
    );
    quantity = _i1.ColumnDouble(
      'quantity',
      this,
    );
    unitPrice = _i1.ColumnDouble(
      'unitPrice',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
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

  late final CrmQuoteItemUpdateTable updateTable;

  /// ID de la oportunidad a la que pertenece la cotización.
  late final _i1.ColumnInt opportunityId;

  /// ID opcional de la partida de catálogo de origen (sin join estricto obligatorio).
  late final _i1.ColumnInt catalogItemId;

  /// Versión de la partida al momento de cotizar.
  late final _i1.ColumnInt catalogVersion;

  /// Categoría: Personal, Limpieza, Mantenimiento, Equipamiento, Materiales, Tecnología.
  late final _i1.ColumnString category;

  /// Concepto descriptivo del servicio o insumo.
  late final _i1.ColumnString concept;

  /// Tipo de cálculo congelado al cotizar.
  late final _i1.ColumnString calculationType;

  /// Tipo de unidad: Puesto 24/7, Puesto 12h, Operario, Global, m², Unid., Servicio, Kit, Tanque.
  late final _i1.ColumnString unitType;

  /// Cantidad requerida.
  late final _i1.ColumnDouble quantity;

  /// Precio unitario congelado en Bs.
  late final _i1.ColumnDouble unitPrice;

  /// Parámetros auxiliares congelados en formato JSON.
  late final _i1.ColumnString metadata;

  /// Eliminación lógica y auditoría temporal.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    opportunityId,
    catalogItemId,
    catalogVersion,
    category,
    concept,
    calculationType,
    unitType,
    quantity,
    unitPrice,
    metadata,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmQuoteItemInclude extends _i1.IncludeObject {
  CrmQuoteItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmQuoteItem.t;
}

class CrmQuoteItemIncludeList extends _i1.IncludeList {
  CrmQuoteItemIncludeList._({
    _i1.WhereExpressionBuilder<CrmQuoteItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmQuoteItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmQuoteItem.t;
}

class CrmQuoteItemRepository {
  const CrmQuoteItemRepository._();

  /// Returns a list of [CrmQuoteItem]s matching the given query parameters.
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
  Future<List<CrmQuoteItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmQuoteItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmQuoteItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmQuoteItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmQuoteItem>(
      where: where?.call(CrmQuoteItem.t),
      orderBy: orderBy?.call(CrmQuoteItem.t),
      orderByList: orderByList?.call(CrmQuoteItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmQuoteItem] matching the given query parameters.
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
  Future<CrmQuoteItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmQuoteItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmQuoteItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmQuoteItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmQuoteItem>(
      where: where?.call(CrmQuoteItem.t),
      orderBy: orderBy?.call(CrmQuoteItem.t),
      orderByList: orderByList?.call(CrmQuoteItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmQuoteItem] by its [id] or null if no such row exists.
  Future<CrmQuoteItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmQuoteItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmQuoteItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmQuoteItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmQuoteItem>> insert(
    _i1.DatabaseSession session,
    List<CrmQuoteItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmQuoteItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmQuoteItem] and returns the inserted row.
  ///
  /// The returned [CrmQuoteItem] will have its `id` field set.
  Future<CrmQuoteItem> insertRow(
    _i1.DatabaseSession session,
    CrmQuoteItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmQuoteItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmQuoteItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmQuoteItem>> update(
    _i1.DatabaseSession session,
    List<CrmQuoteItem> rows, {
    _i1.ColumnSelections<CrmQuoteItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmQuoteItem>(
      rows,
      columns: columns?.call(CrmQuoteItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmQuoteItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmQuoteItem> updateRow(
    _i1.DatabaseSession session,
    CrmQuoteItem row, {
    _i1.ColumnSelections<CrmQuoteItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmQuoteItem>(
      row,
      columns: columns?.call(CrmQuoteItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmQuoteItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmQuoteItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmQuoteItemUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmQuoteItem>(
      id,
      columnValues: columnValues(CrmQuoteItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmQuoteItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmQuoteItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmQuoteItemUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmQuoteItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmQuoteItemTable>? orderBy,
    _i1.OrderByListBuilder<CrmQuoteItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmQuoteItem>(
      columnValues: columnValues(CrmQuoteItem.t.updateTable),
      where: where(CrmQuoteItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmQuoteItem.t),
      orderByList: orderByList?.call(CrmQuoteItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmQuoteItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmQuoteItem>> delete(
    _i1.DatabaseSession session,
    List<CrmQuoteItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmQuoteItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmQuoteItem].
  Future<CrmQuoteItem> deleteRow(
    _i1.DatabaseSession session,
    CrmQuoteItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmQuoteItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmQuoteItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmQuoteItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmQuoteItem>(
      where: where(CrmQuoteItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmQuoteItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmQuoteItem>(
      where: where?.call(CrmQuoteItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmQuoteItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmQuoteItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmQuoteItem>(
      where: where(CrmQuoteItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
