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

/// Sede u oficina operativa de un Cliente 360°.
abstract class CrmCustomerBranch
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmCustomerBranch._({
    this.id,
    required this.code,
    required this.customerId,
    required this.name,
    required this.address,
    required this.localContact,
    required this.localPhone,
    bool? isHeadquarters,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isHeadquarters = isHeadquarters ?? false,
       isDeleted = isDeleted ?? false;

  factory CrmCustomerBranch({
    int? id,
    required String code,
    required int customerId,
    required String name,
    required String address,
    required String localContact,
    required String localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerBranchImpl;

  factory CrmCustomerBranch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomerBranch(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      customerId: jsonSerialization['customerId'] as int,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      localContact: jsonSerialization['localContact'] as String,
      localPhone: jsonSerialization['localPhone'] as String,
      isHeadquarters: jsonSerialization['isHeadquarters'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isHeadquarters']),
      notes: jsonSerialization['notes'] as String?,
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

  static final t = CrmCustomerBranchTable();

  static const db = CrmCustomerBranchRepository._();

  @override
  int? id;

  /// Código de seguimiento de la sede (ej. BR-001).
  String code;

  /// ID del cliente propietario de la sede.
  int customerId;

  /// Nombre descriptivo de la sede (ej. Torre Central, Garita Norte).
  String name;

  /// Dirección física detallada de la sede.
  String address;

  /// Contacto operativo local en la sede.
  String localContact;

  /// Teléfono de contacto local.
  String localPhone;

  /// Indicador de si es la Sede Principal / Casa Matriz.
  bool isHeadquarters;

  /// Requisitos de acceso y notas operativas.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmCustomerBranch]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerBranch copyWith({
    int? id,
    String? code,
    int? customerId,
    String? name,
    String? address,
    String? localContact,
    String? localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerBranch',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      'name': name,
      'address': address,
      'localContact': localContact,
      'localPhone': localPhone,
      'isHeadquarters': isHeadquarters,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmCustomerBranch',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      'name': name,
      'address': address,
      'localContact': localContact,
      'localPhone': localPhone,
      'isHeadquarters': isHeadquarters,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmCustomerBranchInclude include() {
    return CrmCustomerBranchInclude._();
  }

  static CrmCustomerBranchIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmCustomerBranchTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerBranchTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerBranchTable>? orderByList,
    CrmCustomerBranchInclude? include,
  }) {
    return CrmCustomerBranchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomerBranch.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmCustomerBranch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmCustomerBranchImpl extends CrmCustomerBranch {
  _CrmCustomerBranchImpl({
    int? id,
    required String code,
    required int customerId,
    required String name,
    required String address,
    required String localContact,
    required String localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         customerId: customerId,
         name: name,
         address: address,
         localContact: localContact,
         localPhone: localPhone,
         isHeadquarters: isHeadquarters,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomerBranch]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerBranch copyWith({
    Object? id = _Undefined,
    String? code,
    int? customerId,
    String? name,
    String? address,
    String? localContact,
    String? localPhone,
    bool? isHeadquarters,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomerBranch(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      address: address ?? this.address,
      localContact: localContact ?? this.localContact,
      localPhone: localPhone ?? this.localPhone,
      isHeadquarters: isHeadquarters ?? this.isHeadquarters,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmCustomerBranchUpdateTable
    extends _i1.UpdateTable<CrmCustomerBranchTable> {
  CrmCustomerBranchUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> customerId(int value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> localContact(String value) => _i1.ColumnValue(
    table.localContact,
    value,
  );

  _i1.ColumnValue<String, String> localPhone(String value) => _i1.ColumnValue(
    table.localPhone,
    value,
  );

  _i1.ColumnValue<bool, bool> isHeadquarters(bool value) => _i1.ColumnValue(
    table.isHeadquarters,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
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

class CrmCustomerBranchTable extends _i1.Table<int?> {
  CrmCustomerBranchTable({super.tableRelation})
    : super(tableName: 'crm_customer_branch') {
    updateTable = CrmCustomerBranchUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    localContact = _i1.ColumnString(
      'localContact',
      this,
    );
    localPhone = _i1.ColumnString(
      'localPhone',
      this,
    );
    isHeadquarters = _i1.ColumnBool(
      'isHeadquarters',
      this,
      hasDefault: true,
    );
    notes = _i1.ColumnString(
      'notes',
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

  late final CrmCustomerBranchUpdateTable updateTable;

  /// Código de seguimiento de la sede (ej. BR-001).
  late final _i1.ColumnString code;

  /// ID del cliente propietario de la sede.
  late final _i1.ColumnInt customerId;

  /// Nombre descriptivo de la sede (ej. Torre Central, Garita Norte).
  late final _i1.ColumnString name;

  /// Dirección física detallada de la sede.
  late final _i1.ColumnString address;

  /// Contacto operativo local en la sede.
  late final _i1.ColumnString localContact;

  /// Teléfono de contacto local.
  late final _i1.ColumnString localPhone;

  /// Indicador de si es la Sede Principal / Casa Matriz.
  late final _i1.ColumnBool isHeadquarters;

  /// Requisitos de acceso y notas operativas.
  late final _i1.ColumnString notes;

  /// Eliminación lógica (Soft Delete).
  late final _i1.ColumnBool isDeleted;

  /// Fechas de auditoría temporal.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    customerId,
    name,
    address,
    localContact,
    localPhone,
    isHeadquarters,
    notes,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmCustomerBranchInclude extends _i1.IncludeObject {
  CrmCustomerBranchInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmCustomerBranch.t;
}

class CrmCustomerBranchIncludeList extends _i1.IncludeList {
  CrmCustomerBranchIncludeList._({
    _i1.WhereExpressionBuilder<CrmCustomerBranchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmCustomerBranch.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmCustomerBranch.t;
}

class CrmCustomerBranchRepository {
  const CrmCustomerBranchRepository._();

  /// Returns a list of [CrmCustomerBranch]s matching the given query parameters.
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
  Future<List<CrmCustomerBranch>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerBranchTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerBranchTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerBranchTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmCustomerBranch>(
      where: where?.call(CrmCustomerBranch.t),
      orderBy: orderBy?.call(CrmCustomerBranch.t),
      orderByList: orderByList?.call(CrmCustomerBranch.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmCustomerBranch] matching the given query parameters.
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
  Future<CrmCustomerBranch?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerBranchTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerBranchTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerBranchTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmCustomerBranch>(
      where: where?.call(CrmCustomerBranch.t),
      orderBy: orderBy?.call(CrmCustomerBranch.t),
      orderByList: orderByList?.call(CrmCustomerBranch.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmCustomerBranch] by its [id] or null if no such row exists.
  Future<CrmCustomerBranch?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmCustomerBranch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmCustomerBranch]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmCustomerBranch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmCustomerBranch>> insert(
    _i1.DatabaseSession session,
    List<CrmCustomerBranch> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmCustomerBranch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmCustomerBranch] and returns the inserted row.
  ///
  /// The returned [CrmCustomerBranch] will have its `id` field set.
  Future<CrmCustomerBranch> insertRow(
    _i1.DatabaseSession session,
    CrmCustomerBranch row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmCustomerBranch>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomerBranch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmCustomerBranch>> update(
    _i1.DatabaseSession session,
    List<CrmCustomerBranch> rows, {
    _i1.ColumnSelections<CrmCustomerBranchTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmCustomerBranch>(
      rows,
      columns: columns?.call(CrmCustomerBranch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomerBranch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmCustomerBranch> updateRow(
    _i1.DatabaseSession session,
    CrmCustomerBranch row, {
    _i1.ColumnSelections<CrmCustomerBranchTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmCustomerBranch>(
      row,
      columns: columns?.call(CrmCustomerBranch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomerBranch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmCustomerBranch?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmCustomerBranchUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmCustomerBranch>(
      id,
      columnValues: columnValues(CrmCustomerBranch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomerBranch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmCustomerBranch>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmCustomerBranchUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CrmCustomerBranchTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerBranchTable>? orderBy,
    _i1.OrderByListBuilder<CrmCustomerBranchTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmCustomerBranch>(
      columnValues: columnValues(CrmCustomerBranch.t.updateTable),
      where: where(CrmCustomerBranch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomerBranch.t),
      orderByList: orderByList?.call(CrmCustomerBranch.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmCustomerBranch]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmCustomerBranch>> delete(
    _i1.DatabaseSession session,
    List<CrmCustomerBranch> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmCustomerBranch>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmCustomerBranch].
  Future<CrmCustomerBranch> deleteRow(
    _i1.DatabaseSession session,
    CrmCustomerBranch row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmCustomerBranch>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmCustomerBranch>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerBranchTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmCustomerBranch>(
      where: where(CrmCustomerBranch.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerBranchTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmCustomerBranch>(
      where: where?.call(CrmCustomerBranch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmCustomerBranch] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerBranchTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmCustomerBranch>(
      where: where(CrmCustomerBranch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
