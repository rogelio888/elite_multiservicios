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

/// Contrato u orden de trabajo de un Cliente 360°.
abstract class CrmCustomerContract
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CrmCustomerContract._({
    this.id,
    required this.code,
    required this.customerId,
    this.branchId,
    required this.title,
    required this.contractType,
    required this.serviceCategory,
    String? serviceFrequency,
    this.scheduleHours,
    int? billingCycleDay,
    this.specificRequirements,
    required this.totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required this.paymentTerms,
    required this.executionTime,
    int? advancePercentage,
    String? status,
    required this.startDate,
    this.endDate,
    this.actualEndDate,
    String? originType,
    this.serviceScope,
    this.completionNotes,
    this.satisfactionRating,
    this.completedBy,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : serviceFrequency = serviceFrequency ?? 'Lunes a Viernes',
       billingCycleDay = billingCycleDay ?? 5,
       recurringMonthlyAmount = recurringMonthlyAmount ?? 0.0,
       oneTimeAmount = oneTimeAmount ?? 0.0,
       advancePercentage = advancePercentage ?? 0,
       status = status ?? 'Vigente',
       originType = originType ?? 'Venta Nueva',
       isDeleted = isDeleted ?? false;

  factory CrmCustomerContract({
    int? id,
    required String code,
    required int customerId,
    int? branchId,
    required String title,
    required String contractType,
    required String serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    required double totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required String paymentTerms,
    required String executionTime,
    int? advancePercentage,
    String? status,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerContractImpl;

  factory CrmCustomerContract.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomerContract(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      customerId: jsonSerialization['customerId'] as int,
      branchId: jsonSerialization['branchId'] as int?,
      title: jsonSerialization['title'] as String,
      contractType: jsonSerialization['contractType'] as String,
      serviceCategory: jsonSerialization['serviceCategory'] as String,
      serviceFrequency: jsonSerialization['serviceFrequency'] as String?,
      scheduleHours: jsonSerialization['scheduleHours'] as String?,
      billingCycleDay: jsonSerialization['billingCycleDay'] as int?,
      specificRequirements:
          jsonSerialization['specificRequirements'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      recurringMonthlyAmount:
          (jsonSerialization['recurringMonthlyAmount'] as num?)?.toDouble(),
      oneTimeAmount: (jsonSerialization['oneTimeAmount'] as num?)?.toDouble(),
      paymentTerms: jsonSerialization['paymentTerms'] as String,
      executionTime: jsonSerialization['executionTime'] as String,
      advancePercentage: jsonSerialization['advancePercentage'] as int?,
      status: jsonSerialization['status'] as String?,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      actualEndDate: jsonSerialization['actualEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['actualEndDate'],
            ),
      originType: jsonSerialization['originType'] as String?,
      serviceScope: jsonSerialization['serviceScope'] as String?,
      completionNotes: jsonSerialization['completionNotes'] as String?,
      satisfactionRating: jsonSerialization['satisfactionRating'] as int?,
      completedBy: jsonSerialization['completedBy'] as String?,
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

  static final t = CrmCustomerContractTable();

  static const db = CrmCustomerContractRepository._();

  @override
  int? id;

  /// Código de contrato (ej. CTR-001).
  String code;

  /// ID del cliente asociado.
  int customerId;

  /// ID de la sede operativa vinculada (opcional).
  int? branchId;

  /// Título u objeto del contrato o servicio.
  String title;

  /// Modalidad: Recurrente Mensual, Proyecto Único, Servicio por Evento, Híbrido.
  String contractType;

  /// Categoría: Seguridad Física, Limpieza Integral, Mantenimiento, Software / Tecnología, Jardinería.
  String serviceCategory;

  /// Frecuencia del servicio acordada (ej. Lunes a Viernes, 24/7, Interdiario).
  String serviceFrequency;

  /// Horario programado de prestación (ej. 08:00 - 17:00, Turno 12h).
  String? scheduleHours;

  /// Día de corte / facturación de cuotas para Contabilidad (1 al 31).
  int? billingCycleDay;

  /// Requerimientos específicos del cliente (normativas, uniformes, pólizas).
  String? specificRequirements;

  /// Monto total global o valor referencial en Bs.
  double totalAmount;

  /// Monto recurrente mensual si aplica en Bs.
  double recurringMonthlyAmount;

  /// Monto puntual por obra/evento/instalación si aplica en Bs.
  double oneTimeAmount;

  /// Términos y condiciones de pago acordadas.
  String paymentTerms;

  /// Plazo o tiempo de ejecución estipulado.
  String executionTime;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  int advancePercentage;

  /// Estado: Vigente, En Ejecución, Completado, En Pausa.
  String status;

  /// Fechas de vigencia.
  DateTime startDate;

  DateTime? endDate;

  DateTime? actualEndDate;

  /// Origen: Venta Nueva, Recontratación, Renovación, Adicional, Pipeline Ganada.
  String originType;

  /// Especificación técnica del alcance del servicio.
  String? serviceScope;

  /// Datos de conclusión formal de obra o servicio.
  String? completionNotes;

  int? satisfactionRating;

  String? completedBy;

  /// Observaciones adicionales.
  String? notes;

  /// Eliminación lógica.
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CrmCustomerContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerContract copyWith({
    int? id,
    String? code,
    int? customerId,
    int? branchId,
    String? title,
    String? contractType,
    String? serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    double? totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    String? paymentTerms,
    String? executionTime,
    int? advancePercentage,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerContract',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      'title': title,
      'contractType': contractType,
      'serviceCategory': serviceCategory,
      'serviceFrequency': serviceFrequency,
      if (scheduleHours != null) 'scheduleHours': scheduleHours,
      if (billingCycleDay != null) 'billingCycleDay': billingCycleDay,
      if (specificRequirements != null)
        'specificRequirements': specificRequirements,
      'totalAmount': totalAmount,
      'recurringMonthlyAmount': recurringMonthlyAmount,
      'oneTimeAmount': oneTimeAmount,
      'paymentTerms': paymentTerms,
      'executionTime': executionTime,
      'advancePercentage': advancePercentage,
      'status': status,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (actualEndDate != null) 'actualEndDate': actualEndDate?.toJson(),
      'originType': originType,
      if (serviceScope != null) 'serviceScope': serviceScope,
      if (completionNotes != null) 'completionNotes': completionNotes,
      if (satisfactionRating != null) 'satisfactionRating': satisfactionRating,
      if (completedBy != null) 'completedBy': completedBy,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CrmCustomerContract',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      'title': title,
      'contractType': contractType,
      'serviceCategory': serviceCategory,
      'serviceFrequency': serviceFrequency,
      if (scheduleHours != null) 'scheduleHours': scheduleHours,
      if (billingCycleDay != null) 'billingCycleDay': billingCycleDay,
      if (specificRequirements != null)
        'specificRequirements': specificRequirements,
      'totalAmount': totalAmount,
      'recurringMonthlyAmount': recurringMonthlyAmount,
      'oneTimeAmount': oneTimeAmount,
      'paymentTerms': paymentTerms,
      'executionTime': executionTime,
      'advancePercentage': advancePercentage,
      'status': status,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (actualEndDate != null) 'actualEndDate': actualEndDate?.toJson(),
      'originType': originType,
      if (serviceScope != null) 'serviceScope': serviceScope,
      if (completionNotes != null) 'completionNotes': completionNotes,
      if (satisfactionRating != null) 'satisfactionRating': satisfactionRating,
      if (completedBy != null) 'completedBy': completedBy,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CrmCustomerContractInclude include() {
    return CrmCustomerContractInclude._();
  }

  static CrmCustomerContractIncludeList includeList({
    _i1.WhereExpressionBuilder<CrmCustomerContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerContractTable>? orderByList,
    CrmCustomerContractInclude? include,
  }) {
    return CrmCustomerContractIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomerContract.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CrmCustomerContract.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CrmCustomerContractImpl extends CrmCustomerContract {
  _CrmCustomerContractImpl({
    int? id,
    required String code,
    required int customerId,
    int? branchId,
    required String title,
    required String contractType,
    required String serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    required double totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required String paymentTerms,
    required String executionTime,
    int? advancePercentage,
    String? status,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         customerId: customerId,
         branchId: branchId,
         title: title,
         contractType: contractType,
         serviceCategory: serviceCategory,
         serviceFrequency: serviceFrequency,
         scheduleHours: scheduleHours,
         billingCycleDay: billingCycleDay,
         specificRequirements: specificRequirements,
         totalAmount: totalAmount,
         recurringMonthlyAmount: recurringMonthlyAmount,
         oneTimeAmount: oneTimeAmount,
         paymentTerms: paymentTerms,
         executionTime: executionTime,
         advancePercentage: advancePercentage,
         status: status,
         startDate: startDate,
         endDate: endDate,
         actualEndDate: actualEndDate,
         originType: originType,
         serviceScope: serviceScope,
         completionNotes: completionNotes,
         satisfactionRating: satisfactionRating,
         completedBy: completedBy,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomerContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerContract copyWith({
    Object? id = _Undefined,
    String? code,
    int? customerId,
    Object? branchId = _Undefined,
    String? title,
    String? contractType,
    String? serviceCategory,
    String? serviceFrequency,
    Object? scheduleHours = _Undefined,
    Object? billingCycleDay = _Undefined,
    Object? specificRequirements = _Undefined,
    double? totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    String? paymentTerms,
    String? executionTime,
    int? advancePercentage,
    String? status,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? actualEndDate = _Undefined,
    String? originType,
    Object? serviceScope = _Undefined,
    Object? completionNotes = _Undefined,
    Object? satisfactionRating = _Undefined,
    Object? completedBy = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomerContract(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      customerId: customerId ?? this.customerId,
      branchId: branchId is int? ? branchId : this.branchId,
      title: title ?? this.title,
      contractType: contractType ?? this.contractType,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceFrequency: serviceFrequency ?? this.serviceFrequency,
      scheduleHours: scheduleHours is String?
          ? scheduleHours
          : this.scheduleHours,
      billingCycleDay: billingCycleDay is int?
          ? billingCycleDay
          : this.billingCycleDay,
      specificRequirements: specificRequirements is String?
          ? specificRequirements
          : this.specificRequirements,
      totalAmount: totalAmount ?? this.totalAmount,
      recurringMonthlyAmount:
          recurringMonthlyAmount ?? this.recurringMonthlyAmount,
      oneTimeAmount: oneTimeAmount ?? this.oneTimeAmount,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      executionTime: executionTime ?? this.executionTime,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      actualEndDate: actualEndDate is DateTime?
          ? actualEndDate
          : this.actualEndDate,
      originType: originType ?? this.originType,
      serviceScope: serviceScope is String? ? serviceScope : this.serviceScope,
      completionNotes: completionNotes is String?
          ? completionNotes
          : this.completionNotes,
      satisfactionRating: satisfactionRating is int?
          ? satisfactionRating
          : this.satisfactionRating,
      completedBy: completedBy is String? ? completedBy : this.completedBy,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CrmCustomerContractUpdateTable
    extends _i1.UpdateTable<CrmCustomerContractTable> {
  CrmCustomerContractUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> customerId(int value) => _i1.ColumnValue(
    table.customerId,
    value,
  );

  _i1.ColumnValue<int, int> branchId(int? value) => _i1.ColumnValue(
    table.branchId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> contractType(String value) => _i1.ColumnValue(
    table.contractType,
    value,
  );

  _i1.ColumnValue<String, String> serviceCategory(String value) =>
      _i1.ColumnValue(
        table.serviceCategory,
        value,
      );

  _i1.ColumnValue<String, String> serviceFrequency(String value) =>
      _i1.ColumnValue(
        table.serviceFrequency,
        value,
      );

  _i1.ColumnValue<String, String> scheduleHours(String? value) =>
      _i1.ColumnValue(
        table.scheduleHours,
        value,
      );

  _i1.ColumnValue<int, int> billingCycleDay(int? value) => _i1.ColumnValue(
    table.billingCycleDay,
    value,
  );

  _i1.ColumnValue<String, String> specificRequirements(String? value) =>
      _i1.ColumnValue(
        table.specificRequirements,
        value,
      );

  _i1.ColumnValue<double, double> totalAmount(double value) => _i1.ColumnValue(
    table.totalAmount,
    value,
  );

  _i1.ColumnValue<double, double> recurringMonthlyAmount(double value) =>
      _i1.ColumnValue(
        table.recurringMonthlyAmount,
        value,
      );

  _i1.ColumnValue<double, double> oneTimeAmount(double value) =>
      _i1.ColumnValue(
        table.oneTimeAmount,
        value,
      );

  _i1.ColumnValue<String, String> paymentTerms(String value) => _i1.ColumnValue(
    table.paymentTerms,
    value,
  );

  _i1.ColumnValue<String, String> executionTime(String value) =>
      _i1.ColumnValue(
        table.executionTime,
        value,
      );

  _i1.ColumnValue<int, int> advancePercentage(int value) => _i1.ColumnValue(
    table.advancePercentage,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> actualEndDate(DateTime? value) =>
      _i1.ColumnValue(
        table.actualEndDate,
        value,
      );

  _i1.ColumnValue<String, String> originType(String value) => _i1.ColumnValue(
    table.originType,
    value,
  );

  _i1.ColumnValue<String, String> serviceScope(String? value) =>
      _i1.ColumnValue(
        table.serviceScope,
        value,
      );

  _i1.ColumnValue<String, String> completionNotes(String? value) =>
      _i1.ColumnValue(
        table.completionNotes,
        value,
      );

  _i1.ColumnValue<int, int> satisfactionRating(int? value) => _i1.ColumnValue(
    table.satisfactionRating,
    value,
  );

  _i1.ColumnValue<String, String> completedBy(String? value) => _i1.ColumnValue(
    table.completedBy,
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

class CrmCustomerContractTable extends _i1.Table<int?> {
  CrmCustomerContractTable({super.tableRelation})
    : super(tableName: 'crm_customer_contract') {
    updateTable = CrmCustomerContractUpdateTable(this);
    code = _i1.ColumnString(
      'code',
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
    title = _i1.ColumnString(
      'title',
      this,
    );
    contractType = _i1.ColumnString(
      'contractType',
      this,
    );
    serviceCategory = _i1.ColumnString(
      'serviceCategory',
      this,
    );
    serviceFrequency = _i1.ColumnString(
      'serviceFrequency',
      this,
      hasDefault: true,
    );
    scheduleHours = _i1.ColumnString(
      'scheduleHours',
      this,
    );
    billingCycleDay = _i1.ColumnInt(
      'billingCycleDay',
      this,
      hasDefault: true,
    );
    specificRequirements = _i1.ColumnString(
      'specificRequirements',
      this,
    );
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
      this,
    );
    recurringMonthlyAmount = _i1.ColumnDouble(
      'recurringMonthlyAmount',
      this,
      hasDefault: true,
    );
    oneTimeAmount = _i1.ColumnDouble(
      'oneTimeAmount',
      this,
      hasDefault: true,
    );
    paymentTerms = _i1.ColumnString(
      'paymentTerms',
      this,
    );
    executionTime = _i1.ColumnString(
      'executionTime',
      this,
    );
    advancePercentage = _i1.ColumnInt(
      'advancePercentage',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    actualEndDate = _i1.ColumnDateTime(
      'actualEndDate',
      this,
    );
    originType = _i1.ColumnString(
      'originType',
      this,
      hasDefault: true,
    );
    serviceScope = _i1.ColumnString(
      'serviceScope',
      this,
    );
    completionNotes = _i1.ColumnString(
      'completionNotes',
      this,
    );
    satisfactionRating = _i1.ColumnInt(
      'satisfactionRating',
      this,
    );
    completedBy = _i1.ColumnString(
      'completedBy',
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

  late final CrmCustomerContractUpdateTable updateTable;

  /// Código de contrato (ej. CTR-001).
  late final _i1.ColumnString code;

  /// ID del cliente asociado.
  late final _i1.ColumnInt customerId;

  /// ID de la sede operativa vinculada (opcional).
  late final _i1.ColumnInt branchId;

  /// Título u objeto del contrato o servicio.
  late final _i1.ColumnString title;

  /// Modalidad: Recurrente Mensual, Proyecto Único, Servicio por Evento, Híbrido.
  late final _i1.ColumnString contractType;

  /// Categoría: Seguridad Física, Limpieza Integral, Mantenimiento, Software / Tecnología, Jardinería.
  late final _i1.ColumnString serviceCategory;

  /// Frecuencia del servicio acordada (ej. Lunes a Viernes, 24/7, Interdiario).
  late final _i1.ColumnString serviceFrequency;

  /// Horario programado de prestación (ej. 08:00 - 17:00, Turno 12h).
  late final _i1.ColumnString scheduleHours;

  /// Día de corte / facturación de cuotas para Contabilidad (1 al 31).
  late final _i1.ColumnInt billingCycleDay;

  /// Requerimientos específicos del cliente (normativas, uniformes, pólizas).
  late final _i1.ColumnString specificRequirements;

  /// Monto total global o valor referencial en Bs.
  late final _i1.ColumnDouble totalAmount;

  /// Monto recurrente mensual si aplica en Bs.
  late final _i1.ColumnDouble recurringMonthlyAmount;

  /// Monto puntual por obra/evento/instalación si aplica en Bs.
  late final _i1.ColumnDouble oneTimeAmount;

  /// Términos y condiciones de pago acordadas.
  late final _i1.ColumnString paymentTerms;

  /// Plazo o tiempo de ejecución estipulado.
  late final _i1.ColumnString executionTime;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  late final _i1.ColumnInt advancePercentage;

  /// Estado: Vigente, En Ejecución, Completado, En Pausa.
  late final _i1.ColumnString status;

  /// Fechas de vigencia.
  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnDateTime actualEndDate;

  /// Origen: Venta Nueva, Recontratación, Renovación, Adicional, Pipeline Ganada.
  late final _i1.ColumnString originType;

  /// Especificación técnica del alcance del servicio.
  late final _i1.ColumnString serviceScope;

  /// Datos de conclusión formal de obra o servicio.
  late final _i1.ColumnString completionNotes;

  late final _i1.ColumnInt satisfactionRating;

  late final _i1.ColumnString completedBy;

  /// Observaciones adicionales.
  late final _i1.ColumnString notes;

  /// Eliminación lógica.
  late final _i1.ColumnBool isDeleted;

  /// Fechas de auditoría temporal.
  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    customerId,
    branchId,
    title,
    contractType,
    serviceCategory,
    serviceFrequency,
    scheduleHours,
    billingCycleDay,
    specificRequirements,
    totalAmount,
    recurringMonthlyAmount,
    oneTimeAmount,
    paymentTerms,
    executionTime,
    advancePercentage,
    status,
    startDate,
    endDate,
    actualEndDate,
    originType,
    serviceScope,
    completionNotes,
    satisfactionRating,
    completedBy,
    notes,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

class CrmCustomerContractInclude extends _i1.IncludeObject {
  CrmCustomerContractInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CrmCustomerContract.t;
}

class CrmCustomerContractIncludeList extends _i1.IncludeList {
  CrmCustomerContractIncludeList._({
    _i1.WhereExpressionBuilder<CrmCustomerContractTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CrmCustomerContract.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CrmCustomerContract.t;
}

class CrmCustomerContractRepository {
  const CrmCustomerContractRepository._();

  /// Returns a list of [CrmCustomerContract]s matching the given query parameters.
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
  Future<List<CrmCustomerContract>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerContractTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CrmCustomerContract>(
      where: where?.call(CrmCustomerContract.t),
      orderBy: orderBy?.call(CrmCustomerContract.t),
      orderByList: orderByList?.call(CrmCustomerContract.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CrmCustomerContract] matching the given query parameters.
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
  Future<CrmCustomerContract?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerContractTable>? where,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CrmCustomerContractTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CrmCustomerContract>(
      where: where?.call(CrmCustomerContract.t),
      orderBy: orderBy?.call(CrmCustomerContract.t),
      orderByList: orderByList?.call(CrmCustomerContract.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CrmCustomerContract] by its [id] or null if no such row exists.
  Future<CrmCustomerContract?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CrmCustomerContract>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CrmCustomerContract]s in the list and returns the inserted rows.
  ///
  /// The returned [CrmCustomerContract]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CrmCustomerContract>> insert(
    _i1.DatabaseSession session,
    List<CrmCustomerContract> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CrmCustomerContract>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CrmCustomerContract] and returns the inserted row.
  ///
  /// The returned [CrmCustomerContract] will have its `id` field set.
  Future<CrmCustomerContract> insertRow(
    _i1.DatabaseSession session,
    CrmCustomerContract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CrmCustomerContract>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomerContract]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CrmCustomerContract>> update(
    _i1.DatabaseSession session,
    List<CrmCustomerContract> rows, {
    _i1.ColumnSelections<CrmCustomerContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CrmCustomerContract>(
      rows,
      columns: columns?.call(CrmCustomerContract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomerContract]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CrmCustomerContract> updateRow(
    _i1.DatabaseSession session,
    CrmCustomerContract row, {
    _i1.ColumnSelections<CrmCustomerContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CrmCustomerContract>(
      row,
      columns: columns?.call(CrmCustomerContract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CrmCustomerContract] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CrmCustomerContract?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CrmCustomerContractUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CrmCustomerContract>(
      id,
      columnValues: columnValues(CrmCustomerContract.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CrmCustomerContract]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CrmCustomerContract>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CrmCustomerContractUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CrmCustomerContractTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CrmCustomerContractTable>? orderBy,
    _i1.OrderByListBuilder<CrmCustomerContractTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CrmCustomerContract>(
      columnValues: columnValues(CrmCustomerContract.t.updateTable),
      where: where(CrmCustomerContract.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CrmCustomerContract.t),
      orderByList: orderByList?.call(CrmCustomerContract.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CrmCustomerContract]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CrmCustomerContract>> delete(
    _i1.DatabaseSession session,
    List<CrmCustomerContract> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CrmCustomerContract>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CrmCustomerContract].
  Future<CrmCustomerContract> deleteRow(
    _i1.DatabaseSession session,
    CrmCustomerContract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CrmCustomerContract>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CrmCustomerContract>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerContractTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CrmCustomerContract>(
      where: where(CrmCustomerContract.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CrmCustomerContractTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CrmCustomerContract>(
      where: where?.call(CrmCustomerContract.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CrmCustomerContract] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CrmCustomerContractTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CrmCustomerContract>(
      where: where(CrmCustomerContract.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
