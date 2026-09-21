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

/// Alcance y precio diferenciado de una partida de catálogo para un sector o rubro.
abstract class CrmCatalogItemScope
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmCatalogItemScope._({
    this.id,
    required this.catalogItemId,
    required this.sectorId,
    this.serviceLineId,
    this.priceOverride,
    this.minQuantityOverride,
    this.metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmCatalogItemScope({
    int? id,
    required int catalogItemId,
    required int sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCatalogItemScopeImpl;

  factory CrmCatalogItemScope.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCatalogItemScope(
      id: jsonSerialization['id'] as int?,
      catalogItemId: jsonSerialization['catalogItemId'] as int,
      sectorId: jsonSerialization['sectorId'] as int,
      serviceLineId: jsonSerialization['serviceLineId'] as int?,
      priceOverride: (jsonSerialization['priceOverride'] as num?)?.toDouble(),
      minQuantityOverride: (jsonSerialization['minQuantityOverride'] as num?)
          ?.toDouble(),
      metadataOverride: jsonSerialization['metadataOverride'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
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

  static final t = CrmCatalogItemScopeTable();

  static const db = CrmCatalogItemScopeRepository._();

  @override
  int? id;

  /// Partida de catálogo sobre la que aplica la diferenciación.
  int catalogItemId;

  /// Sector o Rubro industrial al que aplica este override.
  int sectorId;

  /// Línea de servicio opcional.
  int? serviceLineId;

  /// Precio diferenciado o sobreescrito para este rubro en Bs.
  double? priceOverride;

  /// Cantidad mínima diferenciada.
  double? minQuantityOverride;

  /// Parámetros auxiliares JSON sobreescritos para este sector.
  String? metadataOverride;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmCatalogItemScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCatalogItemScope copyWith({
    int? id,
    int? catalogItemId,
    int? sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCatalogItemScope',
      if (id != null) 'id': id,
      'catalogItemId': catalogItemId,
      'sectorId': sectorId,
      if (serviceLineId != null) 'serviceLineId': serviceLineId,
      if (priceOverride != null) 'priceOverride': priceOverride,
      if (minQuantityOverride != null)
        'minQuantityOverride': minQuantityOverride,
      if (metadataOverride != null) 'metadataOverride': metadataOverride,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmCatalogItemScope',
      if (id != null) 'id': id,
      'catalogItemId': catalogItemId,
      'sectorId': sectorId,
      if (serviceLineId != null) 'serviceLineId': serviceLineId,
      if (priceOverride != null) 'priceOverride': priceOverride,
      if (minQuantityOverride != null)
        'minQuantityOverride': minQuantityOverride,
      if (metadataOverride != null) 'metadataOverride': metadataOverride,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmCatalogItemScopeInclude include() {
    return CrmCatalogItemScopeInclude._();
  }

  static CrmCatalogItemScopeIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemScopeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemScopeTable>? orderByList,
    CrmCatalogItemScopeInclude? include,
  }) {
    return CrmCatalogItemScopeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCatalogItemScope.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmCatalogItemScope.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmCatalogItemScopeImpl extends CrmCatalogItemScope {
  _CrmCatalogItemScopeImpl({
    int? id,
    required int catalogItemId,
    required int sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         catalogItemId: catalogItemId,
         sectorId: sectorId,
         serviceLineId: serviceLineId,
         priceOverride: priceOverride,
         minQuantityOverride: minQuantityOverride,
         metadataOverride: metadataOverride,
         isActive: isActive,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCatalogItemScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCatalogItemScope copyWith({
    Object? id = _Undefined,
    int? catalogItemId,
    int? sectorId,
    Object? serviceLineId = _Undefined,
    Object? priceOverride = _Undefined,
    Object? minQuantityOverride = _Undefined,
    Object? metadataOverride = _Undefined,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCatalogItemScope(
      id: id is int? ? id : this.id,
      catalogItemId: catalogItemId ?? this.catalogItemId,
      sectorId: sectorId ?? this.sectorId,
      serviceLineId: serviceLineId is int? ? serviceLineId : this.serviceLineId,
      priceOverride: priceOverride is double?
          ? priceOverride
          : this.priceOverride,
      minQuantityOverride: minQuantityOverride is double?
          ? minQuantityOverride
          : this.minQuantityOverride,
      metadataOverride: metadataOverride is String?
          ? metadataOverride
          : this.metadataOverride,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmCatalogItemScopeUpdateTable
    extends _i1.UpdateTable<CrmCatalogItemScopeTable> {
  CrmCatalogItemScopeUpdateTable(super.table);

  _i1.ColumnValue<int, int> catalogItemId(int value) => _i1.ColumnValue(
    table.catalogItemId,
    value,
  );

  _i1.ColumnValue<int, int> sectorId(int value) => _i1.ColumnValue(
    table.sectorId,
    value,
  );

  _i1.ColumnValue<int, int> serviceLineId(int? value) => _i1.ColumnValue(
    table.serviceLineId,
    value,
  );

  _i1.ColumnValue<double, double> priceOverride(double? value) =>
      _i1.ColumnValue(
        table.priceOverride,
        value,
      );

  _i1.ColumnValue<double, double> minQuantityOverride(double? value) =>
      _i1.ColumnValue(
        table.minQuantityOverride,
        value,
      );

  _i1.ColumnValue<String, String> metadataOverride(String? value) =>
      _i1.ColumnValue(
        table.metadataOverride,
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

class CrmCatalogItemScopeTable extends _i1.Table<int?> {
  CrmCatalogItemScopeTable({super.tableRelation})
    : super(tableName: 'crm_catalog_item_scope') {
    updateTable = CrmCatalogItemScopeUpdateTable(this);
    catalogItemId = _i1.ColumnInt(
      'catalogItemId',
      this,
    );
    sectorId = _i1.ColumnInt(
      'sectorId',
      this,
    );
    serviceLineId = _i1.ColumnInt(
      'serviceLineId',
      this,
    );
    priceOverride = _i1.ColumnDouble(
      'priceOverride',
      this,
    );
    minQuantityOverride = _i1.ColumnDouble(
      'minQuantityOverride',
      this,
    );
    metadataOverride = _i1.ColumnString(
      'metadataOverride',
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
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final CrmCatalogItemScopeUpdateTable updateTable;

  /// Partida de catálogo sobre la que aplica la diferenciación.
  late final _i1.ColumnInt catalogItemId;

  /// Sector o Rubro industrial al que aplica este override.
  late final _i1.ColumnInt sectorId;

  /// Línea de servicio opcional.
  late final _i1.ColumnInt serviceLineId;

  /// Precio diferenciado o sobreescrito para este rubro en Bs.
  late final _i1.ColumnDouble priceOverride;

  /// Cantidad mínima diferenciada.
  late final _i1.ColumnDouble minQuantityOverride;

  /// Parámetros auxiliares JSON sobreescritos para este sector.
  late final _i1.ColumnString metadataOverride;

  /// Estado operativo.
  late final _i1.ColumnBool isActive;

  /// Eliminación lógica y auditoría temporal.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    catalogItemId,
    sectorId,
    serviceLineId,
    priceOverride,
    minQuantityOverride,
    metadataOverride,
    isActive,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmCatalogItemScopeInclude extends _i1.IncludeObject {
  CrmCatalogItemScopeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmCatalogItemScope.t;
}

class CrmCatalogItemScopeIncludeList extends _i1.IncludeList {
  CrmCatalogItemScopeIncludeList._({
    _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmCatalogItemScope.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmCatalogItemScope.t;
}

class CrmCatalogItemScopeRepository {
  const CrmCatalogItemScopeRepository._();

  /// Returns a list of [CrmCatalogItemScope]s matching the given query parameters.
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
  Future<List<CrmCatalogItemScope>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemScopeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemScopeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmCatalogItemScope>(
      where: where?.call(CrmCatalogItemScope.t),
      orderBy: orderBy?.call(CrmCatalogItemScope.t),
      orderByList: orderByList?.call(CrmCatalogItemScope.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmCatalogItemScope] matching the given query parameters.
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
  Future<CrmCatalogItemScope?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemScopeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemScopeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmCatalogItemScope>(
      where: where?.call(CrmCatalogItemScope.t),
      orderBy: orderBy?.call(CrmCatalogItemScope.t),
      orderByList: orderByList?.call(CrmCatalogItemScope.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmCatalogItemScope] by its [id] or null if no such row exists.
  Future<CrmCatalogItemScope?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmCatalogItemScope>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmCatalogItemScope]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmCatalogItemScope]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmCatalogItemScope>> insert(
    _i1.DatabaseSession session,
    List<CrmCatalogItemScope> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmCatalogItemScope>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmCatalogItemScope] and returns the inserted row.
  ///
  /// The returned [CrmCatalogItemScope] will have its `id` field set.
  Future<CrmCatalogItemScope> insertRow(
    _i1.DatabaseSession session,
    CrmCatalogItemScope row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmCatalogItemScope>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmCatalogItemScope]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmCatalogItemScope>> update(
    _i1.DatabaseSession session,
    List<CrmCatalogItemScope> rows, {
    _i1.ColumnSelections<CrmCatalogItemScopeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmCatalogItemScope>(
      rows,
      columns: columns?.call(CrmCatalogItemScope.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCatalogItemScope]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmCatalogItemScope> updateRow(
    _i1.DatabaseSession session,
    CrmCatalogItemScope row, {
    _i1.ColumnSelections<CrmCatalogItemScopeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmCatalogItemScope>(
      row,
      columns: columns?.call(CrmCatalogItemScope.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCatalogItemScope] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmCatalogItemScope?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmCatalogItemScopeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmCatalogItemScope>(
      id,
      columnValues: columnValues(CrmCatalogItemScope.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmCatalogItemScope]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmCatalogItemScope>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmCatalogItemScopeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemScopeTable>? orderBy,
    _i1.OrderByListBuilder<CrmCatalogItemScopeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmCatalogItemScope>(
      columnValues: columnValues(CrmCatalogItemScope.t.updateTable),
      where: where(CrmCatalogItemScope.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCatalogItemScope.t),
      orderByList: orderByList?.call(CrmCatalogItemScope.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmCatalogItemScope]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmCatalogItemScope>> delete(
    _i1.DatabaseSession session,
    List<CrmCatalogItemScope> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmCatalogItemScope>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmCatalogItemScope].
  Future<CrmCatalogItemScope> deleteRow(
    _i1.DatabaseSession session,
    CrmCatalogItemScope row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmCatalogItemScope>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmCatalogItemScope>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmCatalogItemScope>(
      where: where(CrmCatalogItemScope.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmCatalogItemScope>(
      where: where?.call(CrmCatalogItemScope.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmCatalogItemScope] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCatalogItemScopeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmCatalogItemScope>(
      where: where(CrmCatalogItemScope.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
