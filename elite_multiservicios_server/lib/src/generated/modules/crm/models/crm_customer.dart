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
import 'package:elite_multiservicios_server/src/generated/protocol.dart' as _i2;

/// Entidad principal de Cliente 360° para el CRM de Elite Multiservicios.
abstract class CrmCustomer
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmCustomer._({
    this.id,
    required this.code,
    required this.legalName,
    required this.tradeName,
    required this.taxId,
    required this.segment,
    String? status,
    required this.activeServices,
    required this.contactPerson,
    required this.phone,
    required this.email,
    this.opportunityId,
    this.startDate,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Activo',
       isDeleted = isDeleted ?? false;

  factory CrmCustomer({
    int? id,
    required String code,
    required String legalName,
    required String tradeName,
    required String taxId,
    required String segment,
    String? status,
    required List<String> activeServices,
    required String contactPerson,
    required String phone,
    required String email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerImpl;

  factory CrmCustomer.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomer(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      legalName: jsonSerialization['legalName'] as String,
      tradeName: jsonSerialization['tradeName'] as String,
      taxId: jsonSerialization['taxId'] as String,
      segment: jsonSerialization['segment'] as String,
      status: jsonSerialization['status'] as String?,
      activeServices: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['activeServices'],
      ),
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      email: jsonSerialization['email'] as String,
      opportunityId: jsonSerialization['opportunityId'] as int?,
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
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

  static final t = CrmCustomerTable();

  static const db = CrmCustomerRepository._();

  @override
  int? id;

  /// Código comercial único del cliente (ej. CLI-001).
  String code;

  /// Razón Social legal registrada ante impuestos.
  String legalName;

  /// Nombre Comercial o de fantasía de la empresa o cliente.
  String tradeName;

  /// Número de Identificación Tributaria (NIT / RUC / CI).
  String taxId;

  /// Segmento comercial: Corporativo B2B, Residencial B2C, Sector Educativo, Sector Público.
  String segment;

  /// Estado operativo: Activo, En Pausa, Inactivo.
  String status;

  /// Lista de servicios activos contratados.
  List<String> activeServices;

  /// Persona de contacto principal o decisor institucional.
  String contactPerson;

  /// Teléfono corporativo o WhatsApp principal.
  String phone;

  /// Correo electrónico de facturación o contacto.
  String email;

  /// ID de la oportunidad comercial de origen (si proviene del Pipeline).
  int? opportunityId;

  /// Fecha de inicio formal de relación comercial.
  DateTime? startDate;

  /// Notas y antecedentes generales del cliente.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmCustomer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomer copyWith({
    int? id,
    String? code,
    String? legalName,
    String? tradeName,
    String? taxId,
    String? segment,
    String? status,
    List<String>? activeServices,
    String? contactPerson,
    String? phone,
    String? email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomer',
      if (id != null) 'id': id,
      'code': code,
      'legalName': legalName,
      'tradeName': tradeName,
      'taxId': taxId,
      'segment': segment,
      'status': status,
      'activeServices': activeServices.toJson(),
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmCustomer',
      if (id != null) 'id': id,
      'code': code,
      'legalName': legalName,
      'tradeName': tradeName,
      'taxId': taxId,
      'segment': segment,
      'status': status,
      'activeServices': activeServices.toJson(),
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmCustomerInclude include() {
    return CrmCustomerInclude._();
  }

  static CrmCustomerIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmCustomerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerTable>? orderByList,
    CrmCustomerInclude? include,
  }) {
    return CrmCustomerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomer.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmCustomer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmCustomerImpl extends CrmCustomer {
  _CrmCustomerImpl({
    int? id,
    required String code,
    required String legalName,
    required String tradeName,
    required String taxId,
    required String segment,
    String? status,
    required List<String> activeServices,
    required String contactPerson,
    required String phone,
    required String email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         legalName: legalName,
         tradeName: tradeName,
         taxId: taxId,
         segment: segment,
         status: status,
         activeServices: activeServices,
         contactPerson: contactPerson,
         phone: phone,
         email: email,
         opportunityId: opportunityId,
         startDate: startDate,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomer copyWith({
    Object? id = _Undefined,
    String? code,
    String? legalName,
    String? tradeName,
    String? taxId,
    String? segment,
    String? status,
    List<String>? activeServices,
    String? contactPerson,
    String? phone,
    String? email,
    Object? opportunityId = _Undefined,
    Object? startDate = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomer(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      legalName: legalName ?? this.legalName,
      tradeName: tradeName ?? this.tradeName,
      taxId: taxId ?? this.taxId,
      segment: segment ?? this.segment,
      status: status ?? this.status,
      activeServices:
          activeServices ?? this.activeServices.map((e0) => e0).toList(),
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      opportunityId: opportunityId is int? ? opportunityId : this.opportunityId,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmCustomerUpdateTable extends _i1.UpdateTable<CrmCustomerTable> {
  CrmCustomerUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> legalName(String value) => _i1.ColumnValue(
    table.legalName,
    value,
  );

  _i1.ColumnValue<String, String> tradeName(String value) => _i1.ColumnValue(
    table.tradeName,
    value,
  );

  _i1.ColumnValue<String, String> taxId(String value) => _i1.ColumnValue(
    table.taxId,
    value,
  );

  _i1.ColumnValue<String, String> segment(String value) => _i1.ColumnValue(
    table.segment,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> activeServices(
    List<String> value,
  ) => _i1.ColumnValue(
    table.activeServices,
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

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<int, int> opportunityId(int? value) => _i1.ColumnValue(
    table.opportunityId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime? value) =>
      _i1.ColumnValue(
        table.startDate,
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

class CrmCustomerTable extends _i1.Table<int?> {
  CrmCustomerTable({super.tableRelation}) : super(tableName: 'crm_customer') {
    updateTable = CrmCustomerUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    legalName = _i1.ColumnString(
      'legalName',
      this,
    );
    tradeName = _i1.ColumnString(
      'tradeName',
      this,
    );
    taxId = _i1.ColumnString(
      'taxId',
      this,
    );
    segment = _i1.ColumnString(
      'segment',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    activeServices = _i1.ColumnSerializable<List<String>>(
      'activeServices',
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
    email = _i1.ColumnString(
      'email',
      this,
    );
    opportunityId = _i1.ColumnInt(
      'opportunityId',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
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

  late final CrmCustomerUpdateTable updateTable;

  /// Código comercial único del cliente (ej. CLI-001).
  late final _i1.ColumnString code;

  /// Razón Social legal registrada ante impuestos.
  late final _i1.ColumnString legalName;

  /// Nombre Comercial o de fantasía de la empresa o cliente.
  late final _i1.ColumnString tradeName;

  /// Número de Identificación Tributaria (NIT / RUC / CI).
  late final _i1.ColumnString taxId;

  /// Segmento comercial: Corporativo B2B, Residencial B2C, Sector Educativo, Sector Público.
  late final _i1.ColumnString segment;

  /// Estado operativo: Activo, En Pausa, Inactivo.
  late final _i1.ColumnString status;

  /// Lista de servicios activos contratados.
  late final _i1.ColumnSerializable<List<String>> activeServices;

  /// Persona de contacto principal o decisor institucional.
  late final _i1.ColumnString contactPerson;

  /// Teléfono corporativo o WhatsApp principal.
  late final _i1.ColumnString phone;

  /// Correo electrónico de facturación o contacto.
  late final _i1.ColumnString email;

  /// ID de la oportunidad comercial de origen (si proviene del Pipeline).
  late final _i1.ColumnInt opportunityId;

  /// Fecha de inicio formal de relación comercial.
  late final _i1.ColumnDateTime startDate;

  /// Notas y antecedentes generales del cliente.
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
    legalName,
    tradeName,
    taxId,
    segment,
    status,
    activeServices,
    contactPerson,
    phone,
    email,
    opportunityId,
    startDate,
    notes,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmCustomerInclude extends _i1.IncludeObject {
  CrmCustomerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmCustomer.t;
}

class CrmCustomerIncludeList extends _i1.IncludeList {
  CrmCustomerIncludeList._({
    _i1.WhereExpressionBuilder<CrmCustomerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmCustomer.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmCustomer.t;
}

class CrmCustomerRepository {
  const CrmCustomerRepository._();

  /// Returns a list of [CrmCustomer]s matching the given query parameters.
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
  Future<List<CrmCustomer>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmCustomer>(
      where: where?.call(CrmCustomer.t),
      orderBy: orderBy?.call(CrmCustomer.t),
      orderByList: orderByList?.call(CrmCustomer.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmCustomer] matching the given query parameters.
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
  Future<CrmCustomer?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmCustomer>(
      where: where?.call(CrmCustomer.t),
      orderBy: orderBy?.call(CrmCustomer.t),
      orderByList: orderByList?.call(CrmCustomer.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmCustomer] by its [id] or null if no such row exists.
  Future<CrmCustomer?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmCustomer>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmCustomer]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmCustomer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmCustomer>> insert(
    _i1.DatabaseSession session,
    List<CrmCustomer> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmCustomer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmCustomer] and returns the inserted row.
  ///
  /// The returned [CrmCustomer] will have its `id` field set.
  Future<CrmCustomer> insertRow(
    _i1.DatabaseSession session,
    CrmCustomer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmCustomer>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmCustomer>> update(
    _i1.DatabaseSession session,
    List<CrmCustomer> rows, {
    _i1.ColumnSelections<CrmCustomerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmCustomer>(
      rows,
      columns: columns?.call(CrmCustomer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmCustomer> updateRow(
    _i1.DatabaseSession session,
    CrmCustomer row, {
    _i1.ColumnSelections<CrmCustomerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmCustomer>(
      row,
      columns: columns?.call(CrmCustomer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmCustomer?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmCustomerUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmCustomer>(
      id,
      columnValues: columnValues(CrmCustomer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmCustomer>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmCustomerUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmCustomerTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerTable>? orderBy,
    _i1.OrderByListBuilder<CrmCustomerTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmCustomer>(
      columnValues: columnValues(CrmCustomer.t.updateTable),
      where: where(CrmCustomer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomer.t),
      orderByList: orderByList?.call(CrmCustomer.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmCustomer]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmCustomer>> delete(
    _i1.DatabaseSession session,
    List<CrmCustomer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmCustomer>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmCustomer].
  Future<CrmCustomer> deleteRow(
    _i1.DatabaseSession session,
    CrmCustomer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmCustomer>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmCustomer>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmCustomer>(
      where: where(CrmCustomer.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmCustomer>(
      where: where?.call(CrmCustomer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmCustomer] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmCustomer>(
      where: where(CrmCustomer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
