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

/// Entidad de prospecto comercial (Outbound / Google Maps / Directorios).
abstract class CrmLead
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmLead._({
    this.id,
    required this.code,
    required this.company,
    String? origin,
    this.requestedService,
    this.companyUrl,
    required this.sector,
    required this.advisor,
    this.advisorUserId,
    required this.address,
    required this.phone,
    this.emailOrWeb,
    String? status,
    String? temperature,
    required this.contactPerson,
    this.notes,
    double? estimatedValue,
    bool? isPromoted,
    this.promotedOpportunityId,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : origin = origin ?? 'Google Maps',
       status = status ?? 'Prospectado',
       temperature = temperature ?? 'Templado',
       estimatedValue = estimatedValue ?? 0.0,
       isPromoted = isPromoted ?? false,
       isDeleted = isDeleted ?? false;

  factory CrmLead({
    int? id,
    required String code,
    required String company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    required String sector,
    required String advisor,
    int? advisorUserId,
    required String address,
    required String phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    required String contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmLeadImpl;

  factory CrmLead.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmLead(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      company: jsonSerialization['company'] as String,
      origin: jsonSerialization['origin'] as String?,
      requestedService: jsonSerialization['requestedService'] as String?,
      companyUrl: jsonSerialization['companyUrl'] as String?,
      sector: jsonSerialization['sector'] as String,
      advisor: jsonSerialization['advisor'] as String,
      advisorUserId: jsonSerialization['advisorUserId'] as int?,
      address: jsonSerialization['address'] as String,
      phone: jsonSerialization['phone'] as String,
      emailOrWeb: jsonSerialization['emailOrWeb'] as String?,
      status: jsonSerialization['status'] as String?,
      temperature: jsonSerialization['temperature'] as String?,
      contactPerson: jsonSerialization['contactPerson'] as String,
      notes: jsonSerialization['notes'] as String?,
      estimatedValue: (jsonSerialization['estimatedValue'] as num?)?.toDouble(),
      isPromoted: jsonSerialization['isPromoted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPromoted']),
      promotedOpportunityId: jsonSerialization['promotedOpportunityId'] as int?,
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

  static final t = CrmLeadTable();

  static const db = CrmLeadRepository._();

  @override
  int? id;

  /// Código de seguimiento del prospecto (ej. PROSP-001).
  String code;

  /// Nombre comercial de la empresa o edificio.
  String company;

  /// Canal de captación / origen del prospecto (Google Maps, Sitio Web, Llamada Telefónica, Referido, Redes Sociales, Prospección en Frío).
  String origin;

  /// Servicio solicitado o de interés inicial.
  String? requestedService;

  /// Enlace web o ficha en Google Maps.
  String? companyUrl;

  /// Rubro o industria (Clínicas, Corporativo, Colegios, Banca, etc.).
  String sector;

  /// Asesor comercial asignado.
  String advisor;

  /// ID del usuario asesor en AppUser (opcional).
  int? advisorUserId;

  /// Dirección física o zona geográfica.
  String address;

  /// Teléfono(s) o WhatsApp corporativo.
  String phone;

  /// Correo electrónico o enlace web oficial.
  String? emailOrWeb;

  /// Estado: Prospectado, Contactado, En Espera de Respuesta, Interesado (Calificado), Descartado.
  String status;

  /// Temperatura comercial: Frío, Templado, Caliente.
  String temperature;

  /// Persona o cargo de contacto decisor.
  String contactPerson;

  /// Notas y observaciones del seguimiento comercial.
  String? notes;

  /// Valor potencial estimado mensual o por proyecto.
  double estimatedValue;

  /// Indicador de si fue promovido al Pipeline comercial.
  bool isPromoted;

  /// ID de la oportunidad generada al promoverse.
  int? promotedOpportunityId;

  /// Indicador de eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fecha de creación del registro.
  DateTime createdAt;

  /// Fecha de última actualización.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmLead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmLead copyWith({
    int? id,
    String? code,
    String? company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    String? sector,
    String? advisor,
    int? advisorUserId,
    String? address,
    String? phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    String? contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmLead',
      if (id != null) 'id': id,
      'code': code,
      'company': company,
      'origin': origin,
      if (requestedService != null) 'requestedService': requestedService,
      if (companyUrl != null) 'companyUrl': companyUrl,
      'sector': sector,
      'advisor': advisor,
      if (advisorUserId != null) 'advisorUserId': advisorUserId,
      'address': address,
      'phone': phone,
      if (emailOrWeb != null) 'emailOrWeb': emailOrWeb,
      'status': status,
      'temperature': temperature,
      'contactPerson': contactPerson,
      if (notes != null) 'notes': notes,
      'estimatedValue': estimatedValue,
      'isPromoted': isPromoted,
      if (promotedOpportunityId != null)
        'promotedOpportunityId': promotedOpportunityId,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmLead',
      if (id != null) 'id': id,
      'code': code,
      'company': company,
      'origin': origin,
      if (requestedService != null) 'requestedService': requestedService,
      if (companyUrl != null) 'companyUrl': companyUrl,
      'sector': sector,
      'advisor': advisor,
      if (advisorUserId != null) 'advisorUserId': advisorUserId,
      'address': address,
      'phone': phone,
      if (emailOrWeb != null) 'emailOrWeb': emailOrWeb,
      'status': status,
      'temperature': temperature,
      'contactPerson': contactPerson,
      if (notes != null) 'notes': notes,
      'estimatedValue': estimatedValue,
      'isPromoted': isPromoted,
      if (promotedOpportunityId != null)
        'promotedOpportunityId': promotedOpportunityId,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmLeadInclude include() {
    return CrmLeadInclude._();
  }

  static CrmLeadIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmLeadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmLeadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmLeadTable>? orderByList,
    CrmLeadInclude? include,
  }) {
    return CrmLeadIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmLead.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmLead.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmLeadImpl extends CrmLead {
  _CrmLeadImpl({
    int? id,
    required String code,
    required String company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    required String sector,
    required String advisor,
    int? advisorUserId,
    required String address,
    required String phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    required String contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         company: company,
         origin: origin,
         requestedService: requestedService,
         companyUrl: companyUrl,
         sector: sector,
         advisor: advisor,
         advisorUserId: advisorUserId,
         address: address,
         phone: phone,
         emailOrWeb: emailOrWeb,
         status: status,
         temperature: temperature,
         contactPerson: contactPerson,
         notes: notes,
         estimatedValue: estimatedValue,
         isPromoted: isPromoted,
         promotedOpportunityId: promotedOpportunityId,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmLead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmLead copyWith({
    Object? id = _Undefined,
    String? code,
    String? company,
    String? origin,
    Object? requestedService = _Undefined,
    Object? companyUrl = _Undefined,
    String? sector,
    String? advisor,
    Object? advisorUserId = _Undefined,
    String? address,
    String? phone,
    Object? emailOrWeb = _Undefined,
    String? status,
    String? temperature,
    String? contactPerson,
    Object? notes = _Undefined,
    double? estimatedValue,
    bool? isPromoted,
    Object? promotedOpportunityId = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmLead(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      company: company ?? this.company,
      origin: origin ?? this.origin,
      requestedService: requestedService is String?
          ? requestedService
          : this.requestedService,
      companyUrl: companyUrl is String? ? companyUrl : this.companyUrl,
      sector: sector ?? this.sector,
      advisor: advisor ?? this.advisor,
      advisorUserId: advisorUserId is int? ? advisorUserId : this.advisorUserId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      emailOrWeb: emailOrWeb is String? ? emailOrWeb : this.emailOrWeb,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      contactPerson: contactPerson ?? this.contactPerson,
      notes: notes is String? ? notes : this.notes,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      isPromoted: isPromoted ?? this.isPromoted,
      promotedOpportunityId: promotedOpportunityId is int?
          ? promotedOpportunityId
          : this.promotedOpportunityId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmLeadUpdateTable extends _i1.UpdateTable<CrmLeadTable> {
  CrmLeadUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> company(String value) => _i1.ColumnValue(
    table.company,
    value,
  );

  _i1.ColumnValue<String, String> origin(String value) => _i1.ColumnValue(
    table.origin,
    value,
  );

  _i1.ColumnValue<String, String> requestedService(String? value) =>
      _i1.ColumnValue(
        table.requestedService,
        value,
      );

  _i1.ColumnValue<String, String> companyUrl(String? value) => _i1.ColumnValue(
    table.companyUrl,
    value,
  );

  _i1.ColumnValue<String, String> sector(String value) => _i1.ColumnValue(
    table.sector,
    value,
  );

  _i1.ColumnValue<String, String> advisor(String value) => _i1.ColumnValue(
    table.advisor,
    value,
  );

  _i1.ColumnValue<int, int> advisorUserId(int? value) => _i1.ColumnValue(
    table.advisorUserId,
    value,
  );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> phone(String value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> emailOrWeb(String? value) => _i1.ColumnValue(
    table.emailOrWeb,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> temperature(String value) => _i1.ColumnValue(
    table.temperature,
    value,
  );

  _i1.ColumnValue<String, String> contactPerson(String value) =>
      _i1.ColumnValue(
        table.contactPerson,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<double, double> estimatedValue(double value) =>
      _i1.ColumnValue(
        table.estimatedValue,
        value,
      );

  _i1.ColumnValue<bool, bool> isPromoted(bool value) => _i1.ColumnValue(
    table.isPromoted,
    value,
  );

  _i1.ColumnValue<int, int> promotedOpportunityId(int? value) =>
      _i1.ColumnValue(
        table.promotedOpportunityId,
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

class CrmLeadTable extends _i1.Table<int?> {
  CrmLeadTable({super.tableRelation}) : super(tableName: 'crm_lead') {
    updateTable = CrmLeadUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    company = _i1.ColumnString(
      'company',
      this,
    );
    origin = _i1.ColumnString(
      'origin',
      this,
      hasDefault: true,
    );
    requestedService = _i1.ColumnString(
      'requestedService',
      this,
    );
    companyUrl = _i1.ColumnString(
      'companyUrl',
      this,
    );
    sector = _i1.ColumnString(
      'sector',
      this,
    );
    advisor = _i1.ColumnString(
      'advisor',
      this,
    );
    advisorUserId = _i1.ColumnInt(
      'advisorUserId',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    emailOrWeb = _i1.ColumnString(
      'emailOrWeb',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    temperature = _i1.ColumnString(
      'temperature',
      this,
      hasDefault: true,
    );
    contactPerson = _i1.ColumnString(
      'contactPerson',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    estimatedValue = _i1.ColumnDouble(
      'estimatedValue',
      this,
      hasDefault: true,
    );
    isPromoted = _i1.ColumnBool(
      'isPromoted',
      this,
      hasDefault: true,
    );
    promotedOpportunityId = _i1.ColumnInt(
      'promotedOpportunityId',
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

  late final CrmLeadUpdateTable updateTable;

  /// Código de seguimiento del prospecto (ej. PROSP-001).
  late final _i1.ColumnString code;

  /// Nombre comercial de la empresa o edificio.
  late final _i1.ColumnString company;

  /// Canal de captación / origen del prospecto (Google Maps, Sitio Web, Llamada Telefónica, Referido, Redes Sociales, Prospección en Frío).
  late final _i1.ColumnString origin;

  /// Servicio solicitado o de interés inicial.
  late final _i1.ColumnString requestedService;

  /// Enlace web o ficha en Google Maps.
  late final _i1.ColumnString companyUrl;

  /// Rubro o industria (Clínicas, Corporativo, Colegios, Banca, etc.).
  late final _i1.ColumnString sector;

  /// Asesor comercial asignado.
  late final _i1.ColumnString advisor;

  /// ID del usuario asesor en AppUser (opcional).
  late final _i1.ColumnInt advisorUserId;

  /// Dirección física o zona geográfica.
  late final _i1.ColumnString address;

  /// Teléfono(s) o WhatsApp corporativo.
  late final _i1.ColumnString phone;

  /// Correo electrónico o enlace web oficial.
  late final _i1.ColumnString emailOrWeb;

  /// Estado: Prospectado, Contactado, En Espera de Respuesta, Interesado (Calificado), Descartado.
  late final _i1.ColumnString status;

  /// Temperatura comercial: Frío, Templado, Caliente.
  late final _i1.ColumnString temperature;

  /// Persona o cargo de contacto decisor.
  late final _i1.ColumnString contactPerson;

  /// Notas y observaciones del seguimiento comercial.
  late final _i1.ColumnString notes;

  /// Valor potencial estimado mensual o por proyecto.
  late final _i1.ColumnDouble estimatedValue;

  /// Indicador de si fue promovido al Pipeline comercial.
  late final _i1.ColumnBool isPromoted;

  /// ID de la oportunidad generada al promoverse.
  late final _i1.ColumnInt promotedOpportunityId;

  /// Indicador de eliminación lógica (Soft Delete).
  late final _i1.ColumnBool isDeleted;

  /// Fecha de creación del registro.
  late final _i1.ColumnDateTime createdAt;

  /// Fecha de última actualización.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    company,
    origin,
    requestedService,
    companyUrl,
    sector,
    advisor,
    advisorUserId,
    address,
    phone,
    emailOrWeb,
    status,
    temperature,
    contactPerson,
    notes,
    estimatedValue,
    isPromoted,
    promotedOpportunityId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmLeadInclude extends _i1.IncludeObject {
  CrmLeadInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmLead.t;
}

class CrmLeadIncludeList extends _i1.IncludeList {
  CrmLeadIncludeList._({
    _i1.WhereExpressionBuilder<CrmLeadTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmLead.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmLead.t;
}

class CrmLeadRepository {
  const CrmLeadRepository._();

  /// Returns a list of [CrmLead]s matching the given query parameters.
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
  Future<List<CrmLead>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmLeadTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmLeadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmLeadTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmLead>(
      where: where?.call(CrmLead.t),
      orderBy: orderBy?.call(CrmLead.t),
      orderByList: orderByList?.call(CrmLead.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmLead] matching the given query parameters.
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
  Future<CrmLead?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmLeadTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmLeadTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmLeadTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmLead>(
      where: where?.call(CrmLead.t),
      orderBy: orderBy?.call(CrmLead.t),
      orderByList: orderByList?.call(CrmLead.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmLead] by its [id] or null if no such row exists.
  Future<CrmLead?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmLead>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmLead]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmLead]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmLead>> insert(
    _i1.DatabaseSession session,
    List<CrmLead> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmLead>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmLead] and returns the inserted row.
  ///
  /// The returned [CrmLead] will have its `id` field set.
  Future<CrmLead> insertRow(
    _i1.DatabaseSession session,
    CrmLead row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmLead>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmLead]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmLead>> update(
    _i1.DatabaseSession session,
    List<CrmLead> rows, {
    _i1.ColumnSelections<CrmLeadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmLead>(
      rows,
      columns: columns?.call(CrmLead.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmLead]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmLead> updateRow(
    _i1.DatabaseSession session,
    CrmLead row, {
    _i1.ColumnSelections<CrmLeadTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmLead>(
      row,
      columns: columns?.call(CrmLead.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmLead] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmLead?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmLeadUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmLead>(
      id,
      columnValues: columnValues(CrmLead.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmLead]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmLead>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmLeadUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmLeadTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmLeadTable>? orderBy,
    _i1.OrderByListBuilder<CrmLeadTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmLead>(
      columnValues: columnValues(CrmLead.t.updateTable),
      where: where(CrmLead.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmLead.t),
      orderByList: orderByList?.call(CrmLead.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmLead]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmLead>> delete(
    _i1.DatabaseSession session,
    List<CrmLead> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmLead>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmLead].
  Future<CrmLead> deleteRow(
    _i1.DatabaseSession session,
    CrmLead row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmLead>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmLead>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmLeadTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmLead>(
      where: where(CrmLead.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmLeadTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmLead>(
      where: where?.call(CrmLead.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmLead] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmLeadTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmLead>(
      where: where(CrmLead.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
