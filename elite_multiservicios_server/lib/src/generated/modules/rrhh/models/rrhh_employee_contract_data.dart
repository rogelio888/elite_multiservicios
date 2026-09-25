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
import '../../../modules/rrhh/models/rrhh_employee_bonus.dart' as _i2;
import '../../../modules/rrhh/models/rrhh_employee_deduction.dart' as _i3;
import 'package:elite_multiservicios_server/src/generated/protocol.dart' as _i4;

/// Resumen contractual y remunerativo del empleado expuesto para Contabilidad.
abstract class RrhhEmployeeContractData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RrhhEmployeeContractData._({
    required this.employeeId,
    required this.code,
    required this.fullName,
    required this.status,
    required this.contractType,
    required this.baseSalary,
    required this.paymentModality,
    this.bonuses,
    this.deductions,
    this.contractStartDate,
    this.terminationDate,
  });

  factory RrhhEmployeeContractData({
    required int employeeId,
    required String code,
    required String fullName,
    required String status,
    required String contractType,
    required double baseSalary,
    required String paymentModality,
    List<_i2.RrhhEmployeeBonus>? bonuses,
    List<_i3.RrhhEmployeeDeduction>? deductions,
    DateTime? contractStartDate,
    DateTime? terminationDate,
  }) = _RrhhEmployeeContractDataImpl;

  factory RrhhEmployeeContractData.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhEmployeeContractData(
      employeeId: jsonSerialization['employeeId'] as int,
      code: jsonSerialization['code'] as String,
      fullName: jsonSerialization['fullName'] as String,
      status: jsonSerialization['status'] as String,
      contractType: jsonSerialization['contractType'] as String,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      paymentModality: jsonSerialization['paymentModality'] as String,
      bonuses: jsonSerialization['bonuses'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i2.RrhhEmployeeBonus>>(
              jsonSerialization['bonuses'],
            ),
      deductions: jsonSerialization['deductions'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.RrhhEmployeeDeduction>>(
              jsonSerialization['deductions'],
            ),
      contractStartDate: jsonSerialization['contractStartDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractStartDate'],
            ),
      terminationDate: jsonSerialization['terminationDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['terminationDate'],
            ),
    );
  }

  int employeeId;

  String code;

  String fullName;

  String status;

  String contractType;

  double baseSalary;

  String paymentModality;

  List<_i2.RrhhEmployeeBonus>? bonuses;

  List<_i3.RrhhEmployeeDeduction>? deductions;

  DateTime? contractStartDate;

  DateTime? terminationDate;

  /// Returns a shallow copy of this [RrhhEmployeeContractData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployeeContractData copyWith({
    int? employeeId,
    String? code,
    String? fullName,
    String? status,
    String? contractType,
    double? baseSalary,
    String? paymentModality,
    List<_i2.RrhhEmployeeBonus>? bonuses,
    List<_i3.RrhhEmployeeDeduction>? deductions,
    DateTime? contractStartDate,
    DateTime? terminationDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployeeContractData',
      'employeeId': employeeId,
      'code': code,
      'fullName': fullName,
      'status': status,
      'contractType': contractType,
      'baseSalary': baseSalary,
      'paymentModality': paymentModality,
      if (bonuses != null)
        'bonuses': bonuses?.toJson(valueToJson: (v) => v.toJson()),
      if (deductions != null)
        'deductions': deductions?.toJson(valueToJson: (v) => v.toJson()),
      if (contractStartDate != null)
        'contractStartDate': contractStartDate?.toJson(),
      if (terminationDate != null) 'terminationDate': terminationDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RrhhEmployeeContractData',
      'employeeId': employeeId,
      'code': code,
      'fullName': fullName,
      'status': status,
      'contractType': contractType,
      'baseSalary': baseSalary,
      'paymentModality': paymentModality,
      if (bonuses != null)
        'bonuses': bonuses?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (deductions != null)
        'deductions': deductions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (contractStartDate != null)
        'contractStartDate': contractStartDate?.toJson(),
      if (terminationDate != null) 'terminationDate': terminationDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeContractDataImpl extends RrhhEmployeeContractData {
  _RrhhEmployeeContractDataImpl({
    required int employeeId,
    required String code,
    required String fullName,
    required String status,
    required String contractType,
    required double baseSalary,
    required String paymentModality,
    List<_i2.RrhhEmployeeBonus>? bonuses,
    List<_i3.RrhhEmployeeDeduction>? deductions,
    DateTime? contractStartDate,
    DateTime? terminationDate,
  }) : super._(
         employeeId: employeeId,
         code: code,
         fullName: fullName,
         status: status,
         contractType: contractType,
         baseSalary: baseSalary,
         paymentModality: paymentModality,
         bonuses: bonuses,
         deductions: deductions,
         contractStartDate: contractStartDate,
         terminationDate: terminationDate,
       );

  /// Returns a shallow copy of this [RrhhEmployeeContractData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployeeContractData copyWith({
    int? employeeId,
    String? code,
    String? fullName,
    String? status,
    String? contractType,
    double? baseSalary,
    String? paymentModality,
    Object? bonuses = _Undefined,
    Object? deductions = _Undefined,
    Object? contractStartDate = _Undefined,
    Object? terminationDate = _Undefined,
  }) {
    return RrhhEmployeeContractData(
      employeeId: employeeId ?? this.employeeId,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      contractType: contractType ?? this.contractType,
      baseSalary: baseSalary ?? this.baseSalary,
      paymentModality: paymentModality ?? this.paymentModality,
      bonuses: bonuses is List<_i2.RrhhEmployeeBonus>?
          ? bonuses
          : this.bonuses?.map((e0) => e0.copyWith()).toList(),
      deductions: deductions is List<_i3.RrhhEmployeeDeduction>?
          ? deductions
          : this.deductions?.map((e0) => e0.copyWith()).toList(),
      contractStartDate: contractStartDate is DateTime?
          ? contractStartDate
          : this.contractStartDate,
      terminationDate: terminationDate is DateTime?
          ? terminationDate
          : this.terminationDate,
    );
  }
}
