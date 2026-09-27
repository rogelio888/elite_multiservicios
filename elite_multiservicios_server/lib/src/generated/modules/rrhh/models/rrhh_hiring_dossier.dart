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
import '../../../modules/rrhh/models/rrhh_dossier_document.dart' as _i2;
import '../../../modules/rrhh/models/rrhh_employee_bonus.dart' as _i3;
import '../../../modules/rrhh/models/rrhh_employee_deduction.dart' as _i4;
import 'package:elite_multiservicios_server/src/generated/protocol.dart' as _i5;

/// Expediente de Contratación (FASE C). Conecta la etapa SELECCIONADO con el alta en Nómina.
abstract class RrhhHiringDossier
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RrhhHiringDossier._({
    this.id,
    required this.code,
    this.applicantId,
    required this.applicantCode,
    required this.applicantName,
    this.employeeId,
    this.convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    this.documentChecklist,
    this.afpName,
    this.afpNumber,
    this.healthInsurance,
    this.section2Notes,
    this.fullAddress,
    this.maritalStatus,
    this.childrenCount,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.contractType,
    this.workdayType,
    this.paymentModality,
    this.baseSalary,
    this.contractStartDate,
    this.contractEndDate,
    this.bonuses,
    this.deductions,
    this.section4Notes,
    this.areaId,
    this.positionId,
    this.shiftId,
    this.scheduleId,
    this.baseLocation,
    this.supervisorEmployeeId,
    this.effectiveStartDate,
    this.section5Notes,
    this.closingNotes,
    this.approvedBy,
    this.approvedAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    bool? isDeleted,
    this.deletedAt,
  }) : status = status ?? 'abierto',
       section1Status = section1Status ?? 'pendiente',
       section2Status = section2Status ?? 'pendiente',
       section3Status = section3Status ?? 'pendiente',
       section4Status = section4Status ?? 'pendiente',
       section5Status = section5Status ?? 'pendiente',
       section6Status = section6Status ?? 'pendiente',
       isDeleted = isDeleted ?? false;

  factory RrhhHiringDossier({
    int? id,
    required String code,
    int? applicantId,
    required String applicantCode,
    required String applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) = _RrhhHiringDossierImpl;

  factory RrhhHiringDossier.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhHiringDossier(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      applicantId: jsonSerialization['applicantId'] as int?,
      applicantCode: jsonSerialization['applicantCode'] as String,
      applicantName: jsonSerialization['applicantName'] as String,
      employeeId: jsonSerialization['employeeId'] as int?,
      convertedEmployeeCode:
          jsonSerialization['convertedEmployeeCode'] as String?,
      status: jsonSerialization['status'] as String?,
      section1Status: jsonSerialization['section1Status'] as String?,
      section2Status: jsonSerialization['section2Status'] as String?,
      section3Status: jsonSerialization['section3Status'] as String?,
      section4Status: jsonSerialization['section4Status'] as String?,
      section5Status: jsonSerialization['section5Status'] as String?,
      section6Status: jsonSerialization['section6Status'] as String?,
      documentChecklist: jsonSerialization['documentChecklist'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i2.RrhhDossierDocument>>(
              jsonSerialization['documentChecklist'],
            ),
      afpName: jsonSerialization['afpName'] as String?,
      afpNumber: jsonSerialization['afpNumber'] as String?,
      healthInsurance: jsonSerialization['healthInsurance'] as String?,
      section2Notes: jsonSerialization['section2Notes'] as String?,
      fullAddress: jsonSerialization['fullAddress'] as String?,
      maritalStatus: jsonSerialization['maritalStatus'] as String?,
      childrenCount: jsonSerialization['childrenCount'] as int?,
      emergencyContactName:
          jsonSerialization['emergencyContactName'] as String?,
      emergencyContactPhone:
          jsonSerialization['emergencyContactPhone'] as String?,
      emergencyContactRelation:
          jsonSerialization['emergencyContactRelation'] as String?,
      contractType: jsonSerialization['contractType'] as String?,
      workdayType: jsonSerialization['workdayType'] as String?,
      paymentModality: jsonSerialization['paymentModality'] as String?,
      baseSalary: (jsonSerialization['baseSalary'] as num?)?.toDouble(),
      contractStartDate: jsonSerialization['contractStartDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractStartDate'],
            ),
      contractEndDate: jsonSerialization['contractEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractEndDate'],
            ),
      bonuses: jsonSerialization['bonuses'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i3.RrhhEmployeeBonus>>(
              jsonSerialization['bonuses'],
            ),
      deductions: jsonSerialization['deductions'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.RrhhEmployeeDeduction>>(
              jsonSerialization['deductions'],
            ),
      section4Notes: jsonSerialization['section4Notes'] as String?,
      areaId: jsonSerialization['areaId'] as int?,
      positionId: jsonSerialization['positionId'] as int?,
      shiftId: jsonSerialization['shiftId'] as String?,
      scheduleId: jsonSerialization['scheduleId'] as String?,
      baseLocation: jsonSerialization['baseLocation'] as String?,
      supervisorEmployeeId:
          jsonSerialization['supervisorEmployeeId'] as String?,
      effectiveStartDate: jsonSerialization['effectiveStartDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['effectiveStartDate'],
            ),
      section5Notes: jsonSerialization['section5Notes'] as String?,
      closingNotes: jsonSerialization['closingNotes'] as String?,
      approvedBy: jsonSerialization['approvedBy'] as String?,
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = RrhhHiringDossierTable();

  static const db = RrhhHiringDossierRepository._();

  @override
  int? id;

  /// Identificación
  String code;

  /// Referencias
  int? applicantId;

  String applicantCode;

  String applicantName;

  int? employeeId;

  String? convertedEmployeeCode;

  /// Estado general del expediente
  /// 'abierto' | 'en_proceso' | 'listo_para_convertir' | 'convertido' | 'pausado' | 'cancelado'
  String status;

  /// Estados por sección ('pendiente' | 'en_proceso' | 'completa')
  String section1Status;

  String section2Status;

  String section3Status;

  String section4Status;

  String section5Status;

  String section6Status;

  /// Sección 1: Documentos (checklist estructurado)
  List<_i2.RrhhDossierDocument>? documentChecklist;

  /// Sección 2: Afiliación seguridad social
  String? afpName;

  String? afpNumber;

  String? healthInsurance;

  String? section2Notes;

  /// Sección 3: Datos personales complementarios
  String? fullAddress;

  String? maritalStatus;

  int? childrenCount;

  String? emergencyContactName;

  String? emergencyContactPhone;

  String? emergencyContactRelation;

  /// Sección 4: Condiciones contractuales
  String? contractType;

  String? workdayType;

  String? paymentModality;

  double? baseSalary;

  DateTime? contractStartDate;

  DateTime? contractEndDate;

  List<_i3.RrhhEmployeeBonus>? bonuses;

  List<_i4.RrhhEmployeeDeduction>? deductions;

  String? section4Notes;

  /// Sección 5: Asignación organizacional
  int? areaId;

  int? positionId;

  String? shiftId;

  String? scheduleId;

  String? baseLocation;

  String? supervisorEmployeeId;

  DateTime? effectiveStartDate;

  String? section5Notes;

  /// Sección 6: Cierre
  String? closingNotes;

  String? approvedBy;

  DateTime? approvedAt;

  /// Auditoría
  String? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? closedAt;

  bool isDeleted;

  DateTime? deletedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RrhhHiringDossier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhHiringDossier copyWith({
    int? id,
    String? code,
    int? applicantId,
    String? applicantCode,
    String? applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhHiringDossier',
      if (id != null) 'id': id,
      'code': code,
      if (applicantId != null) 'applicantId': applicantId,
      'applicantCode': applicantCode,
      'applicantName': applicantName,
      if (employeeId != null) 'employeeId': employeeId,
      if (convertedEmployeeCode != null)
        'convertedEmployeeCode': convertedEmployeeCode,
      'status': status,
      'section1Status': section1Status,
      'section2Status': section2Status,
      'section3Status': section3Status,
      'section4Status': section4Status,
      'section5Status': section5Status,
      'section6Status': section6Status,
      if (documentChecklist != null)
        'documentChecklist': documentChecklist?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (afpName != null) 'afpName': afpName,
      if (afpNumber != null) 'afpNumber': afpNumber,
      if (healthInsurance != null) 'healthInsurance': healthInsurance,
      if (section2Notes != null) 'section2Notes': section2Notes,
      if (fullAddress != null) 'fullAddress': fullAddress,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (childrenCount != null) 'childrenCount': childrenCount,
      if (emergencyContactName != null)
        'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergencyContactPhone': emergencyContactPhone,
      if (emergencyContactRelation != null)
        'emergencyContactRelation': emergencyContactRelation,
      if (contractType != null) 'contractType': contractType,
      if (workdayType != null) 'workdayType': workdayType,
      if (paymentModality != null) 'paymentModality': paymentModality,
      if (baseSalary != null) 'baseSalary': baseSalary,
      if (contractStartDate != null)
        'contractStartDate': contractStartDate?.toJson(),
      if (contractEndDate != null) 'contractEndDate': contractEndDate?.toJson(),
      if (bonuses != null)
        'bonuses': bonuses?.toJson(valueToJson: (v) => v.toJson()),
      if (deductions != null)
        'deductions': deductions?.toJson(valueToJson: (v) => v.toJson()),
      if (section4Notes != null) 'section4Notes': section4Notes,
      if (areaId != null) 'areaId': areaId,
      if (positionId != null) 'positionId': positionId,
      if (shiftId != null) 'shiftId': shiftId,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (baseLocation != null) 'baseLocation': baseLocation,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      if (effectiveStartDate != null)
        'effectiveStartDate': effectiveStartDate?.toJson(),
      if (section5Notes != null) 'section5Notes': section5Notes,
      if (closingNotes != null) 'closingNotes': closingNotes,
      if (approvedBy != null) 'approvedBy': approvedBy,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhHiringDossier',
      if (id != null) 'id': id,
      'code': code,
      if (applicantId != null) 'applicantId': applicantId,
      'applicantCode': applicantCode,
      'applicantName': applicantName,
      if (employeeId != null) 'employeeId': employeeId,
      if (convertedEmployeeCode != null)
        'convertedEmployeeCode': convertedEmployeeCode,
      'status': status,
      'section1Status': section1Status,
      'section2Status': section2Status,
      'section3Status': section3Status,
      'section4Status': section4Status,
      'section5Status': section5Status,
      'section6Status': section6Status,
      if (documentChecklist != null)
        'documentChecklist': documentChecklist?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (afpName != null) 'afpName': afpName,
      if (afpNumber != null) 'afpNumber': afpNumber,
      if (healthInsurance != null) 'healthInsurance': healthInsurance,
      if (section2Notes != null) 'section2Notes': section2Notes,
      if (fullAddress != null) 'fullAddress': fullAddress,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (childrenCount != null) 'childrenCount': childrenCount,
      if (emergencyContactName != null)
        'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergencyContactPhone': emergencyContactPhone,
      if (emergencyContactRelation != null)
        'emergencyContactRelation': emergencyContactRelation,
      if (contractType != null) 'contractType': contractType,
      if (workdayType != null) 'workdayType': workdayType,
      if (paymentModality != null) 'paymentModality': paymentModality,
      if (baseSalary != null) 'baseSalary': baseSalary,
      if (contractStartDate != null)
        'contractStartDate': contractStartDate?.toJson(),
      if (contractEndDate != null) 'contractEndDate': contractEndDate?.toJson(),
      if (bonuses != null)
        'bonuses': bonuses?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (deductions != null)
        'deductions': deductions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (section4Notes != null) 'section4Notes': section4Notes,
      if (areaId != null) 'areaId': areaId,
      if (positionId != null) 'positionId': positionId,
      if (shiftId != null) 'shiftId': shiftId,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (baseLocation != null) 'baseLocation': baseLocation,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      if (effectiveStartDate != null)
        'effectiveStartDate': effectiveStartDate?.toJson(),
      if (section5Notes != null) 'section5Notes': section5Notes,
      if (closingNotes != null) 'closingNotes': closingNotes,
      if (approvedBy != null) 'approvedBy': approvedBy,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static RrhhHiringDossierInclude include() {
    return RrhhHiringDossierInclude._();
  }

  static RrhhHiringDossierIncludeList includeList({
    _i1.WhereExpressionBuilder<RrhhHiringDossierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhHiringDossierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhHiringDossierTable>? orderByList,
    RrhhHiringDossierInclude? include,
  }) {
    return RrhhHiringDossierIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhHiringDossier.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RrhhHiringDossier.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhHiringDossierImpl extends RrhhHiringDossier {
  _RrhhHiringDossierImpl({
    int? id,
    required String code,
    int? applicantId,
    required String applicantCode,
    required String applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         code: code,
         applicantId: applicantId,
         applicantCode: applicantCode,
         applicantName: applicantName,
         employeeId: employeeId,
         convertedEmployeeCode: convertedEmployeeCode,
         status: status,
         section1Status: section1Status,
         section2Status: section2Status,
         section3Status: section3Status,
         section4Status: section4Status,
         section5Status: section5Status,
         section6Status: section6Status,
         documentChecklist: documentChecklist,
         afpName: afpName,
         afpNumber: afpNumber,
         healthInsurance: healthInsurance,
         section2Notes: section2Notes,
         fullAddress: fullAddress,
         maritalStatus: maritalStatus,
         childrenCount: childrenCount,
         emergencyContactName: emergencyContactName,
         emergencyContactPhone: emergencyContactPhone,
         emergencyContactRelation: emergencyContactRelation,
         contractType: contractType,
         workdayType: workdayType,
         paymentModality: paymentModality,
         baseSalary: baseSalary,
         contractStartDate: contractStartDate,
         contractEndDate: contractEndDate,
         bonuses: bonuses,
         deductions: deductions,
         section4Notes: section4Notes,
         areaId: areaId,
         positionId: positionId,
         shiftId: shiftId,
         scheduleId: scheduleId,
         baseLocation: baseLocation,
         supervisorEmployeeId: supervisorEmployeeId,
         effectiveStartDate: effectiveStartDate,
         section5Notes: section5Notes,
         closingNotes: closingNotes,
         approvedBy: approvedBy,
         approvedAt: approvedAt,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         closedAt: closedAt,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [RrhhHiringDossier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhHiringDossier copyWith({
    Object? id = _Undefined,
    String? code,
    Object? applicantId = _Undefined,
    String? applicantCode,
    String? applicantName,
    Object? employeeId = _Undefined,
    Object? convertedEmployeeCode = _Undefined,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    Object? documentChecklist = _Undefined,
    Object? afpName = _Undefined,
    Object? afpNumber = _Undefined,
    Object? healthInsurance = _Undefined,
    Object? section2Notes = _Undefined,
    Object? fullAddress = _Undefined,
    Object? maritalStatus = _Undefined,
    Object? childrenCount = _Undefined,
    Object? emergencyContactName = _Undefined,
    Object? emergencyContactPhone = _Undefined,
    Object? emergencyContactRelation = _Undefined,
    Object? contractType = _Undefined,
    Object? workdayType = _Undefined,
    Object? paymentModality = _Undefined,
    Object? baseSalary = _Undefined,
    Object? contractStartDate = _Undefined,
    Object? contractEndDate = _Undefined,
    Object? bonuses = _Undefined,
    Object? deductions = _Undefined,
    Object? section4Notes = _Undefined,
    Object? areaId = _Undefined,
    Object? positionId = _Undefined,
    Object? shiftId = _Undefined,
    Object? scheduleId = _Undefined,
    Object? baseLocation = _Undefined,
    Object? supervisorEmployeeId = _Undefined,
    Object? effectiveStartDate = _Undefined,
    Object? section5Notes = _Undefined,
    Object? closingNotes = _Undefined,
    Object? approvedBy = _Undefined,
    Object? approvedAt = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? closedAt = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
  }) {
    return RrhhHiringDossier(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      applicantId: applicantId is int? ? applicantId : this.applicantId,
      applicantCode: applicantCode ?? this.applicantCode,
      applicantName: applicantName ?? this.applicantName,
      employeeId: employeeId is int? ? employeeId : this.employeeId,
      convertedEmployeeCode: convertedEmployeeCode is String?
          ? convertedEmployeeCode
          : this.convertedEmployeeCode,
      status: status ?? this.status,
      section1Status: section1Status ?? this.section1Status,
      section2Status: section2Status ?? this.section2Status,
      section3Status: section3Status ?? this.section3Status,
      section4Status: section4Status ?? this.section4Status,
      section5Status: section5Status ?? this.section5Status,
      section6Status: section6Status ?? this.section6Status,
      documentChecklist: documentChecklist is List<_i2.RrhhDossierDocument>?
          ? documentChecklist
          : this.documentChecklist?.map((e0) => e0.copyWith()).toList(),
      afpName: afpName is String? ? afpName : this.afpName,
      afpNumber: afpNumber is String? ? afpNumber : this.afpNumber,
      healthInsurance: healthInsurance is String?
          ? healthInsurance
          : this.healthInsurance,
      section2Notes: section2Notes is String?
          ? section2Notes
          : this.section2Notes,
      fullAddress: fullAddress is String? ? fullAddress : this.fullAddress,
      maritalStatus: maritalStatus is String?
          ? maritalStatus
          : this.maritalStatus,
      childrenCount: childrenCount is int? ? childrenCount : this.childrenCount,
      emergencyContactName: emergencyContactName is String?
          ? emergencyContactName
          : this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone is String?
          ? emergencyContactPhone
          : this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation is String?
          ? emergencyContactRelation
          : this.emergencyContactRelation,
      contractType: contractType is String? ? contractType : this.contractType,
      workdayType: workdayType is String? ? workdayType : this.workdayType,
      paymentModality: paymentModality is String?
          ? paymentModality
          : this.paymentModality,
      baseSalary: baseSalary is double? ? baseSalary : this.baseSalary,
      contractStartDate: contractStartDate is DateTime?
          ? contractStartDate
          : this.contractStartDate,
      contractEndDate: contractEndDate is DateTime?
          ? contractEndDate
          : this.contractEndDate,
      bonuses: bonuses is List<_i3.RrhhEmployeeBonus>?
          ? bonuses
          : this.bonuses?.map((e0) => e0.copyWith()).toList(),
      deductions: deductions is List<_i4.RrhhEmployeeDeduction>?
          ? deductions
          : this.deductions?.map((e0) => e0.copyWith()).toList(),
      section4Notes: section4Notes is String?
          ? section4Notes
          : this.section4Notes,
      areaId: areaId is int? ? areaId : this.areaId,
      positionId: positionId is int? ? positionId : this.positionId,
      shiftId: shiftId is String? ? shiftId : this.shiftId,
      scheduleId: scheduleId is String? ? scheduleId : this.scheduleId,
      baseLocation: baseLocation is String? ? baseLocation : this.baseLocation,
      supervisorEmployeeId: supervisorEmployeeId is String?
          ? supervisorEmployeeId
          : this.supervisorEmployeeId,
      effectiveStartDate: effectiveStartDate is DateTime?
          ? effectiveStartDate
          : this.effectiveStartDate,
      section5Notes: section5Notes is String?
          ? section5Notes
          : this.section5Notes,
      closingNotes: closingNotes is String? ? closingNotes : this.closingNotes,
      approvedBy: approvedBy is String? ? approvedBy : this.approvedBy,
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt is DateTime? ? closedAt : this.closedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class RrhhHiringDossierUpdateTable
    extends _i1.UpdateTable<RrhhHiringDossierTable> {
  RrhhHiringDossierUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<int, int> applicantId(int? value) => _i1.ColumnValue(
    table.applicantId,
    value,
  );

  _i1.ColumnValue<String, String> applicantCode(String value) =>
      _i1.ColumnValue(
        table.applicantCode,
        value,
      );

  _i1.ColumnValue<String, String> applicantName(String value) =>
      _i1.ColumnValue(
        table.applicantName,
        value,
      );

  _i1.ColumnValue<int, int> employeeId(int? value) => _i1.ColumnValue(
    table.employeeId,
    value,
  );

  _i1.ColumnValue<String, String> convertedEmployeeCode(String? value) =>
      _i1.ColumnValue(
        table.convertedEmployeeCode,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> section1Status(String value) =>
      _i1.ColumnValue(
        table.section1Status,
        value,
      );

  _i1.ColumnValue<String, String> section2Status(String value) =>
      _i1.ColumnValue(
        table.section2Status,
        value,
      );

  _i1.ColumnValue<String, String> section3Status(String value) =>
      _i1.ColumnValue(
        table.section3Status,
        value,
      );

  _i1.ColumnValue<String, String> section4Status(String value) =>
      _i1.ColumnValue(
        table.section4Status,
        value,
      );

  _i1.ColumnValue<String, String> section5Status(String value) =>
      _i1.ColumnValue(
        table.section5Status,
        value,
      );

  _i1.ColumnValue<String, String> section6Status(String value) =>
      _i1.ColumnValue(
        table.section6Status,
        value,
      );

  _i1.ColumnValue<List<_i2.RrhhDossierDocument>, List<_i2.RrhhDossierDocument>>
  documentChecklist(List<_i2.RrhhDossierDocument>? value) => _i1.ColumnValue(
    table.documentChecklist,
    value,
  );

  _i1.ColumnValue<String, String> afpName(String? value) => _i1.ColumnValue(
    table.afpName,
    value,
  );

  _i1.ColumnValue<String, String> afpNumber(String? value) => _i1.ColumnValue(
    table.afpNumber,
    value,
  );

  _i1.ColumnValue<String, String> healthInsurance(String? value) =>
      _i1.ColumnValue(
        table.healthInsurance,
        value,
      );

  _i1.ColumnValue<String, String> section2Notes(String? value) =>
      _i1.ColumnValue(
        table.section2Notes,
        value,
      );

  _i1.ColumnValue<String, String> fullAddress(String? value) => _i1.ColumnValue(
    table.fullAddress,
    value,
  );

  _i1.ColumnValue<String, String> maritalStatus(String? value) =>
      _i1.ColumnValue(
        table.maritalStatus,
        value,
      );

  _i1.ColumnValue<int, int> childrenCount(int? value) => _i1.ColumnValue(
    table.childrenCount,
    value,
  );

  _i1.ColumnValue<String, String> emergencyContactName(String? value) =>
      _i1.ColumnValue(
        table.emergencyContactName,
        value,
      );

  _i1.ColumnValue<String, String> emergencyContactPhone(String? value) =>
      _i1.ColumnValue(
        table.emergencyContactPhone,
        value,
      );

  _i1.ColumnValue<String, String> emergencyContactRelation(String? value) =>
      _i1.ColumnValue(
        table.emergencyContactRelation,
        value,
      );

  _i1.ColumnValue<String, String> contractType(String? value) =>
      _i1.ColumnValue(
        table.contractType,
        value,
      );

  _i1.ColumnValue<String, String> workdayType(String? value) => _i1.ColumnValue(
    table.workdayType,
    value,
  );

  _i1.ColumnValue<String, String> paymentModality(String? value) =>
      _i1.ColumnValue(
        table.paymentModality,
        value,
      );

  _i1.ColumnValue<double, double> baseSalary(double? value) => _i1.ColumnValue(
    table.baseSalary,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> contractStartDate(DateTime? value) =>
      _i1.ColumnValue(
        table.contractStartDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> contractEndDate(DateTime? value) =>
      _i1.ColumnValue(
        table.contractEndDate,
        value,
      );

  _i1.ColumnValue<List<_i3.RrhhEmployeeBonus>, List<_i3.RrhhEmployeeBonus>>
  bonuses(List<_i3.RrhhEmployeeBonus>? value) => _i1.ColumnValue(
    table.bonuses,
    value,
  );

  _i1.ColumnValue<
    List<_i4.RrhhEmployeeDeduction>,
    List<_i4.RrhhEmployeeDeduction>
  >
  deductions(List<_i4.RrhhEmployeeDeduction>? value) => _i1.ColumnValue(
    table.deductions,
    value,
  );

  _i1.ColumnValue<String, String> section4Notes(String? value) =>
      _i1.ColumnValue(
        table.section4Notes,
        value,
      );

  _i1.ColumnValue<int, int> areaId(int? value) => _i1.ColumnValue(
    table.areaId,
    value,
  );

  _i1.ColumnValue<int, int> positionId(int? value) => _i1.ColumnValue(
    table.positionId,
    value,
  );

  _i1.ColumnValue<String, String> shiftId(String? value) => _i1.ColumnValue(
    table.shiftId,
    value,
  );

  _i1.ColumnValue<String, String> scheduleId(String? value) => _i1.ColumnValue(
    table.scheduleId,
    value,
  );

  _i1.ColumnValue<String, String> baseLocation(String? value) =>
      _i1.ColumnValue(
        table.baseLocation,
        value,
      );

  _i1.ColumnValue<String, String> supervisorEmployeeId(String? value) =>
      _i1.ColumnValue(
        table.supervisorEmployeeId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> effectiveStartDate(DateTime? value) =>
      _i1.ColumnValue(
        table.effectiveStartDate,
        value,
      );

  _i1.ColumnValue<String, String> section5Notes(String? value) =>
      _i1.ColumnValue(
        table.section5Notes,
        value,
      );

  _i1.ColumnValue<String, String> closingNotes(String? value) =>
      _i1.ColumnValue(
        table.closingNotes,
        value,
      );

  _i1.ColumnValue<String, String> approvedBy(String? value) => _i1.ColumnValue(
    table.approvedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> approvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.approvedAt,
        value,
      );

  _i1.ColumnValue<String, String> createdBy(String? value) => _i1.ColumnValue(
    table.createdBy,
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

  _i1.ColumnValue<DateTime, DateTime> closedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.closedAt,
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
}

class RrhhHiringDossierTable extends _i1.Table<int?> {
  RrhhHiringDossierTable({super.tableRelation})
    : super(tableName: 'rrhh_hiring_dossier') {
    updateTable = RrhhHiringDossierUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    applicantId = _i1.ColumnInt(
      'applicantId',
      this,
    );
    applicantCode = _i1.ColumnString(
      'applicantCode',
      this,
    );
    applicantName = _i1.ColumnString(
      'applicantName',
      this,
    );
    employeeId = _i1.ColumnInt(
      'employeeId',
      this,
    );
    convertedEmployeeCode = _i1.ColumnString(
      'convertedEmployeeCode',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    section1Status = _i1.ColumnString(
      'section1Status',
      this,
      hasDefault: true,
    );
    section2Status = _i1.ColumnString(
      'section2Status',
      this,
      hasDefault: true,
    );
    section3Status = _i1.ColumnString(
      'section3Status',
      this,
      hasDefault: true,
    );
    section4Status = _i1.ColumnString(
      'section4Status',
      this,
      hasDefault: true,
    );
    section5Status = _i1.ColumnString(
      'section5Status',
      this,
      hasDefault: true,
    );
    section6Status = _i1.ColumnString(
      'section6Status',
      this,
      hasDefault: true,
    );
    documentChecklist = _i1.ColumnSerializable<List<_i2.RrhhDossierDocument>>(
      'documentChecklist',
      this,
    );
    afpName = _i1.ColumnString(
      'afpName',
      this,
    );
    afpNumber = _i1.ColumnString(
      'afpNumber',
      this,
    );
    healthInsurance = _i1.ColumnString(
      'healthInsurance',
      this,
    );
    section2Notes = _i1.ColumnString(
      'section2Notes',
      this,
    );
    fullAddress = _i1.ColumnString(
      'fullAddress',
      this,
    );
    maritalStatus = _i1.ColumnString(
      'maritalStatus',
      this,
    );
    childrenCount = _i1.ColumnInt(
      'childrenCount',
      this,
    );
    emergencyContactName = _i1.ColumnString(
      'emergencyContactName',
      this,
    );
    emergencyContactPhone = _i1.ColumnString(
      'emergencyContactPhone',
      this,
    );
    emergencyContactRelation = _i1.ColumnString(
      'emergencyContactRelation',
      this,
    );
    contractType = _i1.ColumnString(
      'contractType',
      this,
    );
    workdayType = _i1.ColumnString(
      'workdayType',
      this,
    );
    paymentModality = _i1.ColumnString(
      'paymentModality',
      this,
    );
    baseSalary = _i1.ColumnDouble(
      'baseSalary',
      this,
    );
    contractStartDate = _i1.ColumnDateTime(
      'contractStartDate',
      this,
    );
    contractEndDate = _i1.ColumnDateTime(
      'contractEndDate',
      this,
    );
    bonuses = _i1.ColumnSerializable<List<_i3.RrhhEmployeeBonus>>(
      'bonuses',
      this,
    );
    deductions = _i1.ColumnSerializable<List<_i4.RrhhEmployeeDeduction>>(
      'deductions',
      this,
    );
    section4Notes = _i1.ColumnString(
      'section4Notes',
      this,
    );
    areaId = _i1.ColumnInt(
      'areaId',
      this,
    );
    positionId = _i1.ColumnInt(
      'positionId',
      this,
    );
    shiftId = _i1.ColumnString(
      'shiftId',
      this,
    );
    scheduleId = _i1.ColumnString(
      'scheduleId',
      this,
    );
    baseLocation = _i1.ColumnString(
      'baseLocation',
      this,
    );
    supervisorEmployeeId = _i1.ColumnString(
      'supervisorEmployeeId',
      this,
    );
    effectiveStartDate = _i1.ColumnDateTime(
      'effectiveStartDate',
      this,
    );
    section5Notes = _i1.ColumnString(
      'section5Notes',
      this,
    );
    closingNotes = _i1.ColumnString(
      'closingNotes',
      this,
    );
    approvedBy = _i1.ColumnString(
      'approvedBy',
      this,
    );
    approvedAt = _i1.ColumnDateTime(
      'approvedAt',
      this,
    );
    createdBy = _i1.ColumnString(
      'createdBy',
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
    closedAt = _i1.ColumnDateTime(
      'closedAt',
      this,
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
  }

  late final RrhhHiringDossierUpdateTable updateTable;

  /// Identificación
  late final _i1.ColumnString code;

  /// Referencias
  late final _i1.ColumnInt applicantId;

  late final _i1.ColumnString applicantCode;

  late final _i1.ColumnString applicantName;

  late final _i1.ColumnInt employeeId;

  late final _i1.ColumnString convertedEmployeeCode;

  /// Estado general del expediente
  /// 'abierto' | 'en_proceso' | 'listo_para_convertir' | 'convertido' | 'pausado' | 'cancelado'
  late final _i1.ColumnString status;

  /// Estados por sección ('pendiente' | 'en_proceso' | 'completa')
  late final _i1.ColumnString section1Status;

  late final _i1.ColumnString section2Status;

  late final _i1.ColumnString section3Status;

  late final _i1.ColumnString section4Status;

  late final _i1.ColumnString section5Status;

  late final _i1.ColumnString section6Status;

  /// Sección 1: Documentos (checklist estructurado)
  late final _i1.ColumnSerializable<List<_i2.RrhhDossierDocument>>
  documentChecklist;

  /// Sección 2: Afiliación seguridad social
  late final _i1.ColumnString afpName;

  late final _i1.ColumnString afpNumber;

  late final _i1.ColumnString healthInsurance;

  late final _i1.ColumnString section2Notes;

  /// Sección 3: Datos personales complementarios
  late final _i1.ColumnString fullAddress;

  late final _i1.ColumnString maritalStatus;

  late final _i1.ColumnInt childrenCount;

  late final _i1.ColumnString emergencyContactName;

  late final _i1.ColumnString emergencyContactPhone;

  late final _i1.ColumnString emergencyContactRelation;

  /// Sección 4: Condiciones contractuales
  late final _i1.ColumnString contractType;

  late final _i1.ColumnString workdayType;

  late final _i1.ColumnString paymentModality;

  late final _i1.ColumnDouble baseSalary;

  late final _i1.ColumnDateTime contractStartDate;

  late final _i1.ColumnDateTime contractEndDate;

  late final _i1.ColumnSerializable<List<_i3.RrhhEmployeeBonus>> bonuses;

  late final _i1.ColumnSerializable<List<_i4.RrhhEmployeeDeduction>> deductions;

  late final _i1.ColumnString section4Notes;

  /// Sección 5: Asignación organizacional
  late final _i1.ColumnInt areaId;

  late final _i1.ColumnInt positionId;

  late final _i1.ColumnString shiftId;

  late final _i1.ColumnString scheduleId;

  late final _i1.ColumnString baseLocation;

  late final _i1.ColumnString supervisorEmployeeId;

  late final _i1.ColumnDateTime effectiveStartDate;

  late final _i1.ColumnString section5Notes;

  /// Sección 6: Cierre
  late final _i1.ColumnString closingNotes;

  late final _i1.ColumnString approvedBy;

  late final _i1.ColumnDateTime approvedAt;

  /// Auditoría
  late final _i1.ColumnString createdBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime closedAt;

  late final _i1.ColumnBool isDeleted;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    applicantId,
    applicantCode,
    applicantName,
    employeeId,
    convertedEmployeeCode,
    status,
    section1Status,
    section2Status,
    section3Status,
    section4Status,
    section5Status,
    section6Status,
    documentChecklist,
    afpName,
    afpNumber,
    healthInsurance,
    section2Notes,
    fullAddress,
    maritalStatus,
    childrenCount,
    emergencyContactName,
    emergencyContactPhone,
    emergencyContactRelation,
    contractType,
    workdayType,
    paymentModality,
    baseSalary,
    contractStartDate,
    contractEndDate,
    bonuses,
    deductions,
    section4Notes,
    areaId,
    positionId,
    shiftId,
    scheduleId,
    baseLocation,
    supervisorEmployeeId,
    effectiveStartDate,
    section5Notes,
    closingNotes,
    approvedBy,
    approvedAt,
    createdBy,
    createdAt,
    updatedAt,
    closedAt,
    isDeleted,
    deletedAt,
  ];
}

class RrhhHiringDossierInclude extends _i1.IncludeObject {
  RrhhHiringDossierInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RrhhHiringDossier.t;
}

class RrhhHiringDossierIncludeList extends _i1.IncludeList {
  RrhhHiringDossierIncludeList._({
    _i1.WhereExpressionBuilder<RrhhHiringDossierTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RrhhHiringDossier.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RrhhHiringDossier.t;
}

class RrhhHiringDossierRepository {
  const RrhhHiringDossierRepository._();

  /// Returns a list of [RrhhHiringDossier]s matching the given query parameters.
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
  Future<List<RrhhHiringDossier>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhHiringDossierTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhHiringDossierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhHiringDossierTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RrhhHiringDossier>(
      where: where?.call(RrhhHiringDossier.t),
      orderBy: orderBy?.call(RrhhHiringDossier.t),
      orderByList: orderByList?.call(RrhhHiringDossier.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RrhhHiringDossier] matching the given query parameters.
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
  Future<RrhhHiringDossier?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhHiringDossierTable>? where,
    int? offset,
    _i1.OrderByBuilder<RrhhHiringDossierTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RrhhHiringDossierTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RrhhHiringDossier>(
      where: where?.call(RrhhHiringDossier.t),
      orderBy: orderBy?.call(RrhhHiringDossier.t),
      orderByList: orderByList?.call(RrhhHiringDossier.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RrhhHiringDossier] by its [id] or null if no such row exists.
  Future<RrhhHiringDossier?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RrhhHiringDossier>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RrhhHiringDossier]s in the list and returns the inserted rows.
  ///
  /// The returned [RrhhHiringDossier]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RrhhHiringDossier>> insert(
    _i1.DatabaseSession session,
    List<RrhhHiringDossier> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RrhhHiringDossier>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RrhhHiringDossier] and returns the inserted row.
  ///
  /// The returned [RrhhHiringDossier] will have its `id` field set.
  Future<RrhhHiringDossier> insertRow(
    _i1.DatabaseSession session,
    RrhhHiringDossier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RrhhHiringDossier>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RrhhHiringDossier]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RrhhHiringDossier>> update(
    _i1.DatabaseSession session,
    List<RrhhHiringDossier> rows, {
    _i1.ColumnSelections<RrhhHiringDossierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RrhhHiringDossier>(
      rows,
      columns: columns?.call(RrhhHiringDossier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhHiringDossier]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RrhhHiringDossier> updateRow(
    _i1.DatabaseSession session,
    RrhhHiringDossier row, {
    _i1.ColumnSelections<RrhhHiringDossierTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RrhhHiringDossier>(
      row,
      columns: columns?.call(RrhhHiringDossier.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RrhhHiringDossier] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RrhhHiringDossier?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RrhhHiringDossierUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RrhhHiringDossier>(
      id,
      columnValues: columnValues(RrhhHiringDossier.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RrhhHiringDossier]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RrhhHiringDossier>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RrhhHiringDossierUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RrhhHiringDossierTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RrhhHiringDossierTable>? orderBy,
    _i1.OrderByListBuilder<RrhhHiringDossierTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RrhhHiringDossier>(
      columnValues: columnValues(RrhhHiringDossier.t.updateTable),
      where: where(RrhhHiringDossier.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RrhhHiringDossier.t),
      orderByList: orderByList?.call(RrhhHiringDossier.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RrhhHiringDossier]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RrhhHiringDossier>> delete(
    _i1.DatabaseSession session,
    List<RrhhHiringDossier> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RrhhHiringDossier>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RrhhHiringDossier].
  Future<RrhhHiringDossier> deleteRow(
    _i1.DatabaseSession session,
    RrhhHiringDossier row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RrhhHiringDossier>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RrhhHiringDossier>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhHiringDossierTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RrhhHiringDossier>(
      where: where(RrhhHiringDossier.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RrhhHiringDossierTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RrhhHiringDossier>(
      where: where?.call(RrhhHiringDossier.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RrhhHiringDossier] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RrhhHiringDossierTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RrhhHiringDossier>(
      where: where(RrhhHiringDossier.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
