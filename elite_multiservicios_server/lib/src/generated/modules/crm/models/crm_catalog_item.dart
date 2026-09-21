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

/// Partida maestra del catálogo y tarifario de servicios.
abstract class CrmCatalogItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmCatalogItem._({
    this.id,
    required this.code,
    required this.category,
    required this.serviceLineId,
    required this.concept,
    required this.calculationType,
    required this.unitType,
    required this.basePrice,
    double? minQuantity,
    int? version,
    this.metadata,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : minQuantity = minQuantity ?? 1.0,
       version = version ?? 1,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmCatalogItem({
    int? id,
    required String code,
    required String category,
    required int serviceLineId,
    required String concept,
    required String calculationType,
    required String unitType,
    required double basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCatalogItemImpl;

  factory CrmCatalogItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCatalogItem(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      category: jsonSerialization['category'] as String,
      serviceLineId: jsonSerialization['serviceLineId'] as int,
      concept: jsonSerialization['concept'] as String,
      calculationType: jsonSerialization['calculationType'] as String,
      unitType: jsonSerialization['unitType'] as String,
      basePrice: (jsonSerialization['basePrice'] as num).toDouble(),
      minQuantity: (jsonSerialization['minQuantity'] as num?)?.toDouble(),
      version: jsonSerialization['version'] as int?,
      metadata: jsonSerialization['metadata'] as String?,
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

  static final t = CrmCatalogItemTable();

  static const db = CrmCatalogItemRepository._();

  @override
  int? id;

  /// Código identificador de la partida (ej: CAT-LIMP-M2, CAT-VIG-247).
  String code;

  /// Categoría principal: Personal, Limpieza, Mantenimiento, Equipamiento, Tecnología.
  String category;

  /// Línea de servicio a la que pertenece la partida.
  int serviceLineId;

  /// Concepto descriptivo del servicio o partida.
  String concept;

  /// Tipo de cálculo: FIXED, PER_UNIT, PER_HOUR, PER_AREA, PER_POSITION, GLOBAL.
  String calculationType;

  /// Unidad de medida: m², Hora, Puesto 24/7, Puesto 12h, Operario, Tanque, Global, Unid., Kit.
  String unitType;

  /// Precio base de referencia vigente en Bolivianos (Bs.).
  double basePrice;

  /// Cantidad mínima requerida por orden o contrato.
  double minQuantity;

  /// Versión de la partida (incrementa ante cualquier cambio que altere el cálculo).
  int version;

  /// Parámetros auxiliares serializados en formato JSON (ej. turnos, horas, rendimiento).
  String? metadata;

  /// Especificación o alcance detallado.
  String? description;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmCatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCatalogItem copyWith({
    int? id,
    String? code,
    String? category,
    int? serviceLineId,
    String? concept,
    String? calculationType,
    String? unitType,
    double? basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
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
      '__className__': 'CrmCatalogItem',
      if (id != null) 'id': id,
      'code': code,
      'category': category,
      'serviceLineId': serviceLineId,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'basePrice': basePrice,
      'minQuantity': minQuantity,
      'version': version,
      if (metadata != null) 'metadata': metadata,
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
      '__className__': 'CrmCatalogItem',
      if (id != null) 'id': id,
      'code': code,
      'category': category,
      'serviceLineId': serviceLineId,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'basePrice': basePrice,
      'minQuantity': minQuantity,
      'version': version,
      if (metadata != null) 'metadata': metadata,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmCatalogItemInclude include() {
    return CrmCatalogItemInclude._();
  }

  static CrmCatalogItemIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmCatalogItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemTable>? orderByList,
    CrmCatalogItemInclude? include,
  }) {
    return CrmCatalogItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCatalogItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmCatalogItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmCatalogItemImpl extends CrmCatalogItem {
  _CrmCatalogItemImpl({
    int? id,
    required String code,
    required String category,
    required int serviceLineId,
    required String concept,
    required String calculationType,
    required String unitType,
    required double basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         category: category,
         serviceLineId: serviceLineId,
         concept: concept,
         calculationType: calculationType,
         unitType: unitType,
         basePrice: basePrice,
         minQuantity: minQuantity,
         version: version,
         metadata: metadata,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCatalogItem copyWith({
    Object? id = _Undefined,
    String? code,
    String? category,
    int? serviceLineId,
    String? concept,
    String? calculationType,
    String? unitType,
    double? basePrice,
    double? minQuantity,
    int? version,
    Object? metadata = _Undefined,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCatalogItem(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      category: category ?? this.category,
      serviceLineId: serviceLineId ?? this.serviceLineId,
      concept: concept ?? this.concept,
      calculationType: calculationType ?? this.calculationType,
      unitType: unitType ?? this.unitType,
      basePrice: basePrice ?? this.basePrice,
      minQuantity: minQuantity ?? this.minQuantity,
      version: version ?? this.version,
      metadata: metadata is String? ? metadata : this.metadata,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmCatalogItemUpdateTable extends _i1.UpdateTable<CrmCatalogItemTable> {
  CrmCatalogItemUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<int, int> serviceLineId(int value) => _i1.ColumnValue(
    table.serviceLineId,
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

  _i1.ColumnValue<double, double> basePrice(double value) => _i1.ColumnValue(
    table.basePrice,
    value,
  );

  _i1.ColumnValue<double, double> minQuantity(double value) => _i1.ColumnValue(
    table.minQuantity,
    value,
  );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
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

class CrmCatalogItemTable extends _i1.Table<int?> {
  CrmCatalogItemTable({super.tableRelation})
    : super(tableName: 'crm_catalog_item') {
    updateTable = CrmCatalogItemUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    serviceLineId = _i1.ColumnInt(
      'serviceLineId',
      this,
    );
    concept = _i1.ColumnString(
      'concept',
      this,
    );
    calculationType = _i1.ColumnString(
      'calculationType',
      this,
    );
    unitType = _i1.ColumnString(
      'unitType',
      this,
    );
    basePrice = _i1.ColumnDouble(
      'basePrice',
      this,
    );
    minQuantity = _i1.ColumnDouble(
      'minQuantity',
      this,
      hasDefault: true,
    );
    version = _i1.ColumnInt(
      'version',
      this,
      hasDefault: true,
    );
    metadata = _i1.ColumnString(
      'metadata',
      this,
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

  late final CrmCatalogItemUpdateTable updateTable;

  /// Código identificador de la partida (ej: CAT-LIMP-M2, CAT-VIG-247).
  late final _i1.ColumnString code;

  /// Categoría principal: Personal, Limpieza, Mantenimiento, Equipamiento, Tecnología.
  late final _i1.ColumnString category;

  /// Línea de servicio a la que pertenece la partida.
  late final _i1.ColumnInt serviceLineId;

  /// Concepto descriptivo del servicio o partida.
  late final _i1.ColumnString concept;

  /// Tipo de cálculo: FIXED, PER_UNIT, PER_HOUR, PER_AREA, PER_POSITION, GLOBAL.
  late final _i1.ColumnString calculationType;

  /// Unidad de medida: m², Hora, Puesto 24/7, Puesto 12h, Operario, Tanque, Global, Unid., Kit.
  late final _i1.ColumnString unitType;

  /// Precio base de referencia vigente en Bolivianos (Bs.).
  late final _i1.ColumnDouble basePrice;

  /// Cantidad mínima requerida por orden o contrato.
  late final _i1.ColumnDouble minQuantity;

  /// Versión de la partida (incrementa ante cualquier cambio que altere el cálculo).
  late final _i1.ColumnInt version;

  /// Parámetros auxiliares serializados en formato JSON (ej. turnos, horas, rendimiento).
  late final _i1.ColumnString metadata;

  /// Especificación o alcance detallado.
  late final _i1.ColumnString description;

  /// Estado operativo.
  late final _i1.ColumnBool isActive;

  /// Eliminación lógica y auditoría temporal.
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    category,
    serviceLineId,
    concept,
    calculationType,
    unitType,
    basePrice,
    minQuantity,
    version,
    metadata,
    description,
    isActive,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}

class CrmCatalogItemInclude extends _i1.IncludeObject {
  CrmCatalogItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmCatalogItem.t;
}

class CrmCatalogItemIncludeList extends _i1.IncludeList {
  CrmCatalogItemIncludeList._({
    _i1.WhereExpressionBuilder<CrmCatalogItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmCatalogItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmCatalogItem.t;
}

class CrmCatalogItemRepository {
  const CrmCatalogItemRepository._();

  /// Returns a list of [CrmCatalogItem]s matching the given query parameters.
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
  Future<List<CrmCatalogItem>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmCatalogItem>(
      where: where?.call(CrmCatalogItem.t),
      orderBy: orderBy?.call(CrmCatalogItem.t),
      orderByList: orderByList?.call(CrmCatalogItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmCatalogItem] matching the given query parameters.
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
  Future<CrmCatalogItem?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCatalogItemTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmCatalogItem>(
      where: where?.call(CrmCatalogItem.t),
      orderBy: orderBy?.call(CrmCatalogItem.t),
      orderByList: orderByList?.call(CrmCatalogItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmCatalogItem] by its [id] or null if no such row exists.
  Future<CrmCatalogItem?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmCatalogItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmCatalogItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmCatalogItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmCatalogItem>> insert(
    _i1.DatabaseSession session,
    List<CrmCatalogItem> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmCatalogItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmCatalogItem] and returns the inserted row.
  ///
  /// The returned [CrmCatalogItem] will have its `id` field set.
  Future<CrmCatalogItem> insertRow(
    _i1.DatabaseSession session,
    CrmCatalogItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmCatalogItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmCatalogItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmCatalogItem>> update(
    _i1.DatabaseSession session,
    List<CrmCatalogItem> rows, {
    _i1.ColumnSelections<CrmCatalogItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmCatalogItem>(
      rows,
      columns: columns?.call(CrmCatalogItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCatalogItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmCatalogItem> updateRow(
    _i1.DatabaseSession session,
    CrmCatalogItem row, {
    _i1.ColumnSelections<CrmCatalogItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmCatalogItem>(
      row,
      columns: columns?.call(CrmCatalogItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCatalogItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmCatalogItem?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmCatalogItemUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmCatalogItem>(
      id,
      columnValues: columnValues(CrmCatalogItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmCatalogItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmCatalogItem>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmCatalogItemUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmCatalogItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCatalogItemTable>? orderBy,
    _i1.OrderByListBuilder<CrmCatalogItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmCatalogItem>(
      columnValues: columnValues(CrmCatalogItem.t.updateTable),
      where: where(CrmCatalogItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCatalogItem.t),
      orderByList: orderByList?.call(CrmCatalogItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmCatalogItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmCatalogItem>> delete(
    _i1.DatabaseSession session,
    List<CrmCatalogItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmCatalogItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmCatalogItem].
  Future<CrmCatalogItem> deleteRow(
    _i1.DatabaseSession session,
    CrmCatalogItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmCatalogItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmCatalogItem>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCatalogItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmCatalogItem>(
      where: where(CrmCatalogItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCatalogItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmCatalogItem>(
      where: where?.call(CrmCatalogItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmCatalogItem] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCatalogItemTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmCatalogItem>(
      where: where(CrmCatalogItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
