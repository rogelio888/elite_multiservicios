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

/// Oportunidad comercial en el embudo del Pipeline (Kanban).
abstract class CrmOpportunity
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmOpportunity._({
    this.id,
    required this.code,
    required this.title,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.serviceType,
    required this.amount,
    required this.stage,
    int? probability,
    required this.owner,
    required this.closingDate,
    this.notes,
    String? contractType,
    String? executionTime,
    required this.paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    this.siteName,
    this.siteAddress,
    String? siteCity,
    this.siteContactName,
    this.siteContactPhone,
    this.siteAccessRequirements,
    bool? isSiteHeadquarters,
    this.legalBusinessName,
    this.taxId,
    this.legalRepresentative,
    this.billingEmail,
    this.serviceStartDate,
    double? advancePaid,
    this.wonNotes,
    this.leadId,
    this.customerId,
    this.branchId,
    this.branchName,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : probability = probability ?? 20,
       contractType = contractType ?? 'Recurrente Mensual',
       executionTime = executionTime ?? '12 meses',
       advancePercentage = advancePercentage ?? 0,
       contactRole = contactRole ?? 'Administrador',
       businessSegment = businessSegment ?? 'Corporativo B2B',
       siteCity = siteCity ?? 'Santa Cruz',
       isSiteHeadquarters = isSiteHeadquarters ?? true,
       advancePaid = advancePaid ?? 0.0,
       isDeleted = isDeleted ?? false;

  factory CrmOpportunity({
    int? id,
    required String code,
    required String title,
    required String clientName,
    required String contactPerson,
    required String phone,
    required String serviceType,
    required double amount,
    required String stage,
    int? probability,
    required String owner,
    required String closingDate,
    String? notes,
    String? contractType,
    String? executionTime,
    required String paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmOpportunityImpl;

  factory CrmOpportunity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmOpportunity(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      clientName: jsonSerialization['clientName'] as String,
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      serviceType: jsonSerialization['serviceType'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      stage: jsonSerialization['stage'] as String,
      probability: jsonSerialization['probability'] as int?,
      owner: jsonSerialization['owner'] as String,
      closingDate: jsonSerialization['closingDate'] as String,
      notes: jsonSerialization['notes'] as String?,
      contractType: jsonSerialization['contractType'] as String?,
      executionTime: jsonSerialization['executionTime'] as String?,
      paymentTerms: jsonSerialization['paymentTerms'] as String,
      advancePercentage: jsonSerialization['advancePercentage'] as int?,
      contactRole: jsonSerialization['contactRole'] as String?,
      businessSegment: jsonSerialization['businessSegment'] as String?,
      siteName: jsonSerialization['siteName'] as String?,
      siteAddress: jsonSerialization['siteAddress'] as String?,
      siteCity: jsonSerialization['siteCity'] as String?,
      siteContactName: jsonSerialization['siteContactName'] as String?,
      siteContactPhone: jsonSerialization['siteContactPhone'] as String?,
      siteAccessRequirements:
          jsonSerialization['siteAccessRequirements'] as String?,
      isSiteHeadquarters: jsonSerialization['isSiteHeadquarters'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isSiteHeadquarters'],
            ),
      legalBusinessName: jsonSerialization['legalBusinessName'] as String?,
      taxId: jsonSerialization['taxId'] as String?,
      legalRepresentative: jsonSerialization['legalRepresentative'] as String?,
      billingEmail: jsonSerialization['billingEmail'] as String?,
      serviceStartDate: jsonSerialization['serviceStartDate'] as String?,
      advancePaid: (jsonSerialization['advancePaid'] as num?)?.toDouble(),
      wonNotes: jsonSerialization['wonNotes'] as String?,
      leadId: jsonSerialization['leadId'] as int?,
      customerId: jsonSerialization['customerId'] as int?,
      branchId: jsonSerialization['branchId'] as int?,
      branchName: jsonSerialization['branchName'] as String?,
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

  static final t = CrmOpportunityTable();

  static const db = CrmOpportunityRepository._();

  @override
  int? id;

  /// Código de seguimiento de la oportunidad (ej. OPP-001).
  String code;

  /// Título u objeto comercial de la oportunidad.
  String title;

  /// Nombre de la empresa, institución o cliente.
  String clientName;

  /// Persona de contacto o decisor.
  String contactPerson;

  /// Teléfono corporativo o de contacto.
  String phone;

  /// Tipo de servicio principal solicitado.
  String serviceType;

  /// Monto total o estimado de la oportunidad en Bs.
  double amount;

  /// Etapa o compuerta comercial en el embudo.
  String stage;

  /// Probabilidad de cierre comercial porcentual (0 - 100).
  int probability;

  /// Asesor o responsable de la oportunidad.
  String owner;

  /// Fecha tentativa de cierre (DD/MM/AAAA).
  String closingDate;

  /// Notas y observaciones comerciales.
  String? notes;

  /// Modalidad de contrato propuesta.
  String contractType;

  /// Tiempo o plazo de ejecución estimado.
  String executionTime;

  /// Términos y condiciones de pago.
  String paymentTerms;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  int advancePercentage;

  /// Compuerta 1: Perfil del Decisor & Segmento
  String contactRole;

  String businessSegment;

  /// Compuerta 2: Sede Operativa de Inspección (Visita Técnica)
  String? siteName;

  String? siteAddress;

  String siteCity;

  String? siteContactName;

  String? siteContactPhone;

  String? siteAccessRequirements;

  bool isSiteHeadquarters;

  /// Compuerta 3: Datos Fiscales & Minuta Legal (Negociación)
  String? legalBusinessName;

  String? taxId;

  String? legalRepresentative;

  String? billingEmail;

  /// Compuerta 4: Cierre Formal & Traspaso (Ganada)
  String? serviceStartDate;

  double advancePaid;

  String? wonNotes;

  /// Enlaces relacionales con otros submódulos
  int? leadId;

  int? customerId;

  int? branchId;

  String? branchName;

  /// Eliminación lógica y auditoría temporal
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmOpportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmOpportunity copyWith({
    int? id,
    String? code,
    String? title,
    String? clientName,
    String? contactPerson,
    String? phone,
    String? serviceType,
    double? amount,
    String? stage,
    int? probability,
    String? owner,
    String? closingDate,
    String? notes,
    String? contractType,
    String? executionTime,
    String? paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmOpportunity',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'serviceType': serviceType,
      'amount': amount,
      'stage': stage,
      'probability': probability,
      'owner': owner,
      'closingDate': closingDate,
      if (notes != null) 'notes': notes,
      'contractType': contractType,
      'executionTime': executionTime,
      'paymentTerms': paymentTerms,
      'advancePercentage': advancePercentage,
      'contactRole': contactRole,
      'businessSegment': businessSegment,
      if (siteName != null) 'siteName': siteName,
      if (siteAddress != null) 'siteAddress': siteAddress,
      'siteCity': siteCity,
      if (siteContactName != null) 'siteContactName': siteContactName,
      if (siteContactPhone != null) 'siteContactPhone': siteContactPhone,
      if (siteAccessRequirements != null)
        'siteAccessRequirements': siteAccessRequirements,
      'isSiteHeadquarters': isSiteHeadquarters,
      if (legalBusinessName != null) 'legalBusinessName': legalBusinessName,
      if (taxId != null) 'taxId': taxId,
      if (legalRepresentative != null)
        'legalRepresentative': legalRepresentative,
      if (billingEmail != null) 'billingEmail': billingEmail,
      if (serviceStartDate != null) 'serviceStartDate': serviceStartDate,
      'advancePaid': advancePaid,
      if (wonNotes != null) 'wonNotes': wonNotes,
      if (leadId != null) 'leadId': leadId,
      if (customerId != null) 'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      if (branchName != null) 'branchName': branchName,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmOpportunity',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'serviceType': serviceType,
      'amount': amount,
      'stage': stage,
      'probability': probability,
      'owner': owner,
      'closingDate': closingDate,
      if (notes != null) 'notes': notes,
      'contractType': contractType,
      'executionTime': executionTime,
      'paymentTerms': paymentTerms,
      'advancePercentage': advancePercentage,
      'contactRole': contactRole,
      'businessSegment': businessSegment,
      if (siteName != null) 'siteName': siteName,
      if (siteAddress != null) 'siteAddress': siteAddress,
      'siteCity': siteCity,
      if (siteContactName != null) 'siteContactName': siteContactName,
      if (siteContactPhone != null) 'siteContactPhone': siteContactPhone,
      if (siteAccessRequirements != null)
        'siteAccessRequirements': siteAccessRequirements,
      'isSiteHeadquarters': isSiteHeadquarters,
      if (legalBusinessName != null) 'legalBusinessName': legalBusinessName,
      if (taxId != null) 'taxId': taxId,
      if (legalRepresentative != null)
        'legalRepresentative': legalRepresentative,
      if (billingEmail != null) 'billingEmail': billingEmail,
      if (serviceStartDate != null) 'serviceStartDate': serviceStartDate,
      'advancePaid': advancePaid,
      if (wonNotes != null) 'wonNotes': wonNotes,
      if (leadId != null) 'leadId': leadId,
      if (customerId != null) 'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      if (branchName != null) 'branchName': branchName,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmOpportunityInclude include() {
    return CrmOpportunityInclude._();
  }

  static CrmOpportunityIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmOpportunityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmOpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmOpportunityTable>? orderByList,
    CrmOpportunityInclude? include,
  }) {
    return CrmOpportunityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmOpportunity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmOpportunity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmOpportunityImpl extends CrmOpportunity {
  _CrmOpportunityImpl({
    int? id,
    required String code,
    required String title,
    required String clientName,
    required String contactPerson,
    required String phone,
    required String serviceType,
    required double amount,
    required String stage,
    int? probability,
    required String owner,
    required String closingDate,
    String? notes,
    String? contractType,
    String? executionTime,
    required String paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         title: title,
         clientName: clientName,
         contactPerson: contactPerson,
         phone: phone,
         serviceType: serviceType,
         amount: amount,
         stage: stage,
         probability: probability,
         owner: owner,
         closingDate: closingDate,
         notes: notes,
         contractType: contractType,
         executionTime: executionTime,
         paymentTerms: paymentTerms,
         advancePercentage: advancePercentage,
         contactRole: contactRole,
         businessSegment: businessSegment,
         siteName: siteName,
         siteAddress: siteAddress,
         siteCity: siteCity,
         siteContactName: siteContactName,
         siteContactPhone: siteContactPhone,
         siteAccessRequirements: siteAccessRequirements,
         isSiteHeadquarters: isSiteHeadquarters,
         legalBusinessName: legalBusinessName,
         taxId: taxId,
         legalRepresentative: legalRepresentative,
         billingEmail: billingEmail,
         serviceStartDate: serviceStartDate,
         advancePaid: advancePaid,
         wonNotes: wonNotes,
         leadId: leadId,
         customerId: customerId,
         branchId: branchId,
         branchName: branchName,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmOpportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmOpportunity copyWith({
    Object? id = _Undefined,
    String? code,
    String? title,
    String? clientName,
    String? contactPerson,
    String? phone,
    String? serviceType,
    double? amount,
    String? stage,
    int? probability,
    String? owner,
    String? closingDate,
    Object? notes = _Undefined,
    String? contractType,
    String? executionTime,
    String? paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    Object? siteName = _Undefined,
    Object? siteAddress = _Undefined,
    String? siteCity,
    Object? siteContactName = _Undefined,
    Object? siteContactPhone = _Undefined,
    Object? siteAccessRequirements = _Undefined,
    bool? isSiteHeadquarters,
    Object? legalBusinessName = _Undefined,
    Object? taxId = _Undefined,
    Object? legalRepresentative = _Undefined,
    Object? billingEmail = _Undefined,
    Object? serviceStartDate = _Undefined,
    double? advancePaid,
    Object? wonNotes = _Undefined,
    Object? leadId = _Undefined,
    Object? customerId = _Undefined,
    Object? branchId = _Undefined,
    Object? branchName = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmOpportunity(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      serviceType: serviceType ?? this.serviceType,
      amount: amount ?? this.amount,
      stage: stage ?? this.stage,
      probability: probability ?? this.probability,
      owner: owner ?? this.owner,
      closingDate: closingDate ?? this.closingDate,
      notes: notes is String? ? notes : this.notes,
      contractType: contractType ?? this.contractType,
      executionTime: executionTime ?? this.executionTime,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      contactRole: contactRole ?? this.contactRole,
      businessSegment: businessSegment ?? this.businessSegment,
      siteName: siteName is String? ? siteName : this.siteName,
      siteAddress: siteAddress is String? ? siteAddress : this.siteAddress,
      siteCity: siteCity ?? this.siteCity,
      siteContactName: siteContactName is String?
          ? siteContactName
          : this.siteContactName,
      siteContactPhone: siteContactPhone is String?
          ? siteContactPhone
          : this.siteContactPhone,
      siteAccessRequirements: siteAccessRequirements is String?
          ? siteAccessRequirements
          : this.siteAccessRequirements,
      isSiteHeadquarters: isSiteHeadquarters ?? this.isSiteHeadquarters,
      legalBusinessName: legalBusinessName is String?
          ? legalBusinessName
          : this.legalBusinessName,
      taxId: taxId is String? ? taxId : this.taxId,
      legalRepresentative: legalRepresentative is String?
          ? legalRepresentative
          : this.legalRepresentative,
      billingEmail: billingEmail is String? ? billingEmail : this.billingEmail,
      serviceStartDate: serviceStartDate is String?
          ? serviceStartDate
          : this.serviceStartDate,
      advancePaid: advancePaid ?? this.advancePaid,
      wonNotes: wonNotes is String? ? wonNotes : this.wonNotes,
      leadId: leadId is int? ? leadId : this.leadId,
      customerId: customerId is int? ? customerId : this.customerId,
      branchId: branchId is int? ? branchId : this.branchId,
      branchName: branchName is String? ? branchName : this.branchName,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmOpportunityUpdateTable extends _i1.UpdateTable<CrmOpportunityTable> {
  CrmOpportunityUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> clientName(String value) => _i1.ColumnValue(
    table.clientName,
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

  _i1.ColumnValue<String, String> serviceType(String value) => _i1.ColumnValue(
    table.serviceType,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> stage(String value) => _i1.ColumnValue(
    table.stage,
    value,
  );

  _i1.ColumnValue<int, int> probability(int value) => _i1.ColumnValue(
    table.probability,
    value,
  );

  _i1.ColumnValue<String, String> owner(String value) => _i1.ColumnValue(
    table.owner,
    value,
  );

  _i1.ColumnValue<String, String> closingDate(String value) => _i1.ColumnValue(
    table.closingDate,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<String, String> contractType(String value) => _i1.ColumnValue(
    table.contractType,
    value,
  );

  _i1.ColumnValue<String, String> executionTime(String value) =>
      _i1.ColumnValue(
        table.executionTime,
        value,
      );

  _i1.ColumnValue<String, String> paymentTerms(String value) => _i1.ColumnValue(
    table.paymentTerms,
    value,
  );

  _i1.ColumnValue<int, int> advancePercentage(int value) => _i1.ColumnValue(
    table.advancePercentage,
    value,
  );

  _i1.ColumnValue<String, String> contactRole(String value) => _i1.ColumnValue(
    table.contactRole,
    value,
  );

  _i1.ColumnValue<String, String> businessSegment(String value) =>
      _i1.ColumnValue(
        table.businessSegment,
        value,
      );

  _i1.ColumnValue<String, String> siteName(String? value) => _i1.ColumnValue(
    table.siteName,
    value,
  );

  _i1.ColumnValue<String, String> siteAddress(String? value) => _i1.ColumnValue(
    table.siteAddress,
    value,
  );

  _i1.ColumnValue<String, String> siteCity(String value) => _i1.ColumnValue(
    table.siteCity,
    value,
  );

  _i1.ColumnValue<String, String> siteContactName(String? value) =>
      _i1.ColumnValue(
        table.siteContactName,
        value,
      );

  _i1.ColumnValue<String, String> siteContactPhone(String? value) =>
      _i1.ColumnValue(
        table.siteContactPhone,
        value,
      );

  _i1.ColumnValue<String, String> siteAccessRequirements(String? value) =>
      _i1.ColumnValue(
        table.siteAccessRequirements,
        value,
      );

  _i1.ColumnValue<bool, bool> isSiteHeadquarters(bool value) => _i1.ColumnValue(
    table.isSiteHeadquarters,
    value,
  );

  _i1.ColumnValue<String, String> legalBusinessName(String? value) =>
      _i1.ColumnValue(
        table.legalBusinessName,
        value,
      );

  _i1.ColumnValue<String, String> taxId(String? value) => _i1.ColumnValue(
    table.taxId,
    value,
  );

  _i1.ColumnValue<String, String> legalRepresentative(String? value) =>
      _i1.ColumnValue(
        table.legalRepresentative,
        value,
      );

  _i1.ColumnValue<String, String> billingEmail(String? value) =>
      _i1.ColumnValue(
        table.billingEmail,
        value,
      );

  _i1.ColumnValue<String, String> serviceStartDate(String? value) =>
      _i1.ColumnValue(
        table.serviceStartDate,
        value,
      );

  _i1.ColumnValue<double, double> advancePaid(double value) => _i1.ColumnValue(
    table.advancePaid,
    value,
  );

  _i1.ColumnValue<String, String> wonNotes(String? value) => _i1.ColumnValue(
    table.wonNotes,
    value,
  );

  _i1.ColumnValue<int, int> leadId(int? value) => _i1.ColumnValue(
    table.leadId,
    value,
  );

  _i1.ColumnValue<int, int> customerId(int? value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<int, int> branchId(int? value) => _i1.ColumnValue(
    table.branchId,
    value,
  );

  _i1.ColumnValue<String, String> branchName(String? value) => _i1.ColumnValue(
    table.branchName,
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

class CrmOpportunityTable extends _i1.Table<int?> {
  CrmOpportunityTable({super.tableRelation})
    : super(tableName: 'crm_opportunity') {
    updateTable = CrmOpportunityUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    clientName = _i1.ColumnString(
      'clientName',
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
    serviceType = _i1.ColumnString(
      'serviceType',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    stage = _i1.ColumnString(
      'stage',
      this,
    );
    probability = _i1.ColumnInt(
      'probability',
      this,
      hasDefault: true,
    );
    owner = _i1.ColumnString(
      'owner',
      this,
    );
    closingDate = _i1.ColumnString(
      'closingDate',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    contractType = _i1.ColumnString(
      'contractType',
      this,
      hasDefault: true,
    );
    executionTime = _i1.ColumnString(
      'executionTime',
      this,
      hasDefault: true,
    );
    paymentTerms = _i1.ColumnString(
      'paymentTerms',
      this,
    );
    advancePercentage = _i1.ColumnInt(
      'advancePercentage',
      this,
      hasDefault: true,
    );
    contactRole = _i1.ColumnString(
      'contactRole',
      this,
      hasDefault: true,
    );
    businessSegment = _i1.ColumnString(
      'businessSegment',
      this,
      hasDefault: true,
    );
    siteName = _i1.ColumnString(
      'siteName',
      this,
    );
    siteAddress = _i1.ColumnString(
      'siteAddress',
      this,
    );
    siteCity = _i1.ColumnString(
      'siteCity',
      this,
      hasDefault: true,
    );
    siteContactName = _i1.ColumnString(
      'siteContactName',
      this,
    );
    siteContactPhone = _i1.ColumnString(
      'siteContactPhone',
      this,
    );
    siteAccessRequirements = _i1.ColumnString(
      'siteAccessRequirements',
      this,
    );
    isSiteHeadquarters = _i1.ColumnBool(
      'isSiteHeadquarters',
      this,
      hasDefault: true,
    );
    legalBusinessName = _i1.ColumnString(
      'legalBusinessName',
      this,
    );
    taxId = _i1.ColumnString(
      'taxId',
      this,
    );
    legalRepresentative = _i1.ColumnString(
      'legalRepresentative',
      this,
    );
    billingEmail = _i1.ColumnString(
      'billingEmail',
      this,
    );
    serviceStartDate = _i1.ColumnString(
      'serviceStartDate',
      this,
    );
    advancePaid = _i1.ColumnDouble(
      'advancePaid',
      this,
      hasDefault: true,
    );
    wonNotes = _i1.ColumnString(
      'wonNotes',
      this,
    );
    leadId = _i1.ColumnInt(
      'leadId',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
    branchId = _i1.ColumnInt(
      'branchId',
      this,
    );
    branchName = _i1.ColumnString(
      'branchName',
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

  late final CrmOpportunityUpdateTable updateTable;

  /// Código de seguimiento de la oportunidad (ej. OPP-001).
  late final _i1.ColumnString code;

  /// Título u objeto comercial de la oportunidad.
  late final _i1.ColumnString title;

  /// Nombre de la empresa, institución o cliente.
  late final _i1.ColumnString clientName;

  /// Persona de contacto o decisor.
  late final _i1.ColumnString contactPerson;

  /// Teléfono corporativo o de contacto.
  late final _i1.ColumnString phone;

  /// Tipo de servicio principal solicitado.
  late final _i1.ColumnString serviceType;

  /// Monto total o estimado de la oportunidad en Bs.
  late final _i1.ColumnDouble amount;

  /// Etapa o compuerta comercial en el embudo.
  late final _i1.ColumnString stage;

  /// Probabilidad de cierre comercial porcentual (0 - 100).
  late final _i1.ColumnInt probability;

  /// Asesor o responsable de la oportunidad.
  late final _i1.ColumnString owner;

  /// Fecha tentativa de cierre (DD/MM/AAAA).
  late final _i1.ColumnString closingDate;

  /// Notas y observaciones comerciales.
  late final _i1.ColumnString notes;

  /// Modalidad de contrato propuesta.
  late final _i1.ColumnString contractType;

  /// Tiempo o plazo de ejecución estimado.
  late final _i1.ColumnString executionTime;

  /// Términos y condiciones de pago.
  late final _i1.ColumnString paymentTerms;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  late final _i1.ColumnInt advancePercentage;

  /// Compuerta 1: Perfil del Decisor & Segmento
  late final _i1.ColumnString contactRole;

  late final _i1.ColumnString businessSegment;

  /// Compuerta 2: Sede Operativa de Inspección (Visita Técnica)
  late final _i1.ColumnString siteName;

  late final _i1.ColumnString siteAddress;

  late final _i1.ColumnString siteCity;

  late final _i1.ColumnString siteContactName;

  late final _i1.ColumnString siteContactPhone;

  late final _i1.ColumnString siteAccessRequirements;

  late final _i1.ColumnBool isSiteHeadquarters;

  /// Compuerta 3: Datos Fiscales & Minuta Legal (Negociación)
  late final _i1.ColumnString legalBusinessName;

  late final _i1.ColumnString taxId;

  late final _i1.ColumnString legalRepresentative;

  late final _i1.ColumnString billingEmail;

  /// Compuerta 4: Cierre Formal & Traspaso (Ganada)
  late final _i1.ColumnString serviceStartDate;

  late final _i1.ColumnDouble advancePaid;

  late final _i1.ColumnString wonNotes;

  /// Enlaces relacionales con otros submódulos
  late final _i1.ColumnInt leadId;

  late final _i1.ColumnInt customerId;

  late final _i1.ColumnInt branchId;

  late final _i1.ColumnString branchName;

  /// Eliminación lógica y auditoría temporal
  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    title,
    clientName,
    contactPerson,
    phone,
    serviceType,
    amount,
    stage,
    probability,
    owner,
    closingDate,
    notes,
    contractType,
    executionTime,
    paymentTerms,
    advancePercentage,
    contactRole,
    businessSegment,
    siteName,
    siteAddress,
    siteCity,
    siteContactName,
    siteContactPhone,
    siteAccessRequirements,
    isSiteHeadquarters,
    legalBusinessName,
    taxId,
    legalRepresentative,
    billingEmail,
    serviceStartDate,
    advancePaid,
    wonNotes,
    leadId,
    customerId,
    branchId,
    branchName,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmOpportunityInclude extends _i1.IncludeObject {
  CrmOpportunityInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmOpportunity.t;
}

class CrmOpportunityIncludeList extends _i1.IncludeList {
  CrmOpportunityIncludeList._({
    _i1.WhereExpressionBuilder<CrmOpportunityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmOpportunity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmOpportunity.t;
}

class CrmOpportunityRepository {
  const CrmOpportunityRepository._();

  /// Returns a list of [CrmOpportunity]s matching the given query parameters.
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
  Future<List<CrmOpportunity>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmOpportunityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmOpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmOpportunityTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmOpportunity>(
      where: where?.call(CrmOpportunity.t),
      orderBy: orderBy?.call(CrmOpportunity.t),
      orderByList: orderByList?.call(CrmOpportunity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmOpportunity] matching the given query parameters.
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
  Future<CrmOpportunity?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmOpportunityTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmOpportunityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmOpportunityTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmOpportunity>(
      where: where?.call(CrmOpportunity.t),
      orderBy: orderBy?.call(CrmOpportunity.t),
      orderByList: orderByList?.call(CrmOpportunity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmOpportunity] by its [id] or null if no such row exists.
  Future<CrmOpportunity?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmOpportunity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmOpportunity]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmOpportunity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmOpportunity>> insert(
    _i1.DatabaseSession session,
    List<CrmOpportunity> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmOpportunity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmOpportunity] and returns the inserted row.
  ///
  /// The returned [CrmOpportunity] will have its `id` field set.
  Future<CrmOpportunity> insertRow(
    _i1.DatabaseSession session,
    CrmOpportunity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmOpportunity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmOpportunity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmOpportunity>> update(
    _i1.DatabaseSession session,
    List<CrmOpportunity> rows, {
    _i1.ColumnSelections<CrmOpportunityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmOpportunity>(
      rows,
      columns: columns?.call(CrmOpportunity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmOpportunity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmOpportunity> updateRow(
    _i1.DatabaseSession session,
    CrmOpportunity row, {
    _i1.ColumnSelections<CrmOpportunityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmOpportunity>(
      row,
      columns: columns?.call(CrmOpportunity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmOpportunity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmOpportunity?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmOpportunityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmOpportunity>(
      id,
      columnValues: columnValues(CrmOpportunity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmOpportunity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmOpportunity>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmOpportunityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CrmOpportunityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmOpportunityTable>? orderBy,
    _i1.OrderByListBuilder<CrmOpportunityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmOpportunity>(
      columnValues: columnValues(CrmOpportunity.t.updateTable),
      where: where(CrmOpportunity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmOpportunity.t),
      orderByList: orderByList?.call(CrmOpportunity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmOpportunity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmOpportunity>> delete(
    _i1.DatabaseSession session,
    List<CrmOpportunity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmOpportunity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmOpportunity].
  Future<CrmOpportunity> deleteRow(
    _i1.DatabaseSession session,
    CrmOpportunity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmOpportunity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmOpportunity>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmOpportunityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmOpportunity>(
      where: where(CrmOpportunity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmOpportunityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmOpportunity>(
      where: where?.call(CrmOpportunity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmOpportunity] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmOpportunityTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmOpportunity>(
      where: where(CrmOpportunity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
