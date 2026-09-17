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

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'greetings/greeting.dart' as _i2;
import 'modules/crm/models/crm_lead.dart' as _i3;
import 'modules/crm/models/crm_lead_metrics_response.dart' as _i4;
import 'modules/security/models/app_permission.dart' as _i5;
import 'modules/security/models/app_role.dart' as _i6;
import 'modules/security/models/app_user.dart' as _i7;
import 'modules/security/models/audit_log.dart' as _i8;
import 'modules/security/models/audit_log_page_response.dart' as _i9;
import 'modules/security/models/mfa_challenge.dart' as _i10;
import 'modules/security/models/mfa_challenge_response.dart' as _i11;
import 'modules/security/models/mfa_verify_response.dart' as _i12;
import 'modules/security/models/role_permission.dart' as _i13;
import 'modules/security/models/server_metrics_response.dart' as _i14;
import 'modules/security/models/trusted_device.dart' as _i15;
import 'modules/security/models/user_role.dart' as _i16;
import 'modules/security/models/user_session.dart' as _i17;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i18;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i19;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i20;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i21;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i22;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i23;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i24;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i25;
export 'greetings/greeting.dart';
export 'modules/crm/models/crm_lead.dart';
export 'modules/crm/models/crm_lead_metrics_response.dart';
export 'modules/security/models/app_permission.dart';
export 'modules/security/models/app_role.dart';
export 'modules/security/models/app_user.dart';
export 'modules/security/models/audit_log.dart';
export 'modules/security/models/audit_log_page_response.dart';
export 'modules/security/models/mfa_challenge.dart';
export 'modules/security/models/mfa_challenge_response.dart';
export 'modules/security/models/mfa_verify_response.dart';
export 'modules/security/models/role_permission.dart';
export 'modules/security/models/server_metrics_response.dart';
export 'modules/security/models/trusted_device.dart';
export 'modules/security/models/user_role.dart';
export 'modules/security/models/user_session.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.CrmLead) {
      return _i3.CrmLead.fromJson(data) as T;
    }
    if (t == _i4.CrmLeadMetricsResponse) {
      return _i4.CrmLeadMetricsResponse.fromJson(data) as T;
    }
    if (t == _i5.AppPermission) {
      return _i5.AppPermission.fromJson(data) as T;
    }
    if (t == _i6.AppRole) {
      return _i6.AppRole.fromJson(data) as T;
    }
    if (t == _i7.AppUser) {
      return _i7.AppUser.fromJson(data) as T;
    }
    if (t == _i8.AuditLog) {
      return _i8.AuditLog.fromJson(data) as T;
    }
    if (t == _i9.AuditLogPageResponse) {
      return _i9.AuditLogPageResponse.fromJson(data) as T;
    }
    if (t == _i10.MfaChallenge) {
      return _i10.MfaChallenge.fromJson(data) as T;
    }
    if (t == _i11.MfaChallengeResponse) {
      return _i11.MfaChallengeResponse.fromJson(data) as T;
    }
    if (t == _i12.MfaVerifyResponse) {
      return _i12.MfaVerifyResponse.fromJson(data) as T;
    }
    if (t == _i13.RolePermission) {
      return _i13.RolePermission.fromJson(data) as T;
    }
    if (t == _i14.ServerMetricsResponse) {
      return _i14.ServerMetricsResponse.fromJson(data) as T;
    }
    if (t == _i15.TrustedDevice) {
      return _i15.TrustedDevice.fromJson(data) as T;
    }
    if (t == _i16.UserRole) {
      return _i16.UserRole.fromJson(data) as T;
    }
    if (t == _i17.UserSession) {
      return _i17.UserSession.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CrmLead?>()) {
      return (data != null ? _i3.CrmLead.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CrmLeadMetricsResponse?>()) {
      return (data != null ? _i4.CrmLeadMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AppPermission?>()) {
      return (data != null ? _i5.AppPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AppRole?>()) {
      return (data != null ? _i6.AppRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AppUser?>()) {
      return (data != null ? _i7.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AuditLog?>()) {
      return (data != null ? _i8.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AuditLogPageResponse?>()) {
      return (data != null ? _i9.AuditLogPageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.MfaChallenge?>()) {
      return (data != null ? _i10.MfaChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.MfaChallengeResponse?>()) {
      return (data != null ? _i11.MfaChallengeResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.MfaVerifyResponse?>()) {
      return (data != null ? _i12.MfaVerifyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.RolePermission?>()) {
      return (data != null ? _i13.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ServerMetricsResponse?>()) {
      return (data != null ? _i14.ServerMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.TrustedDevice?>()) {
      return (data != null ? _i15.TrustedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserRole?>()) {
      return (data != null ? _i16.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserSession?>()) {
      return (data != null ? _i17.UserSession.fromJson(data) : null) as T;
    }
    if (t == List<_i8.AuditLog>) {
      return (data as List).map((e) => deserialize<_i8.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i18.CrmLead>) {
      return (data as List).map((e) => deserialize<_i18.CrmLead>(e)).toList()
          as T;
    }
    if (t == List<_i19.AuditLog>) {
      return (data as List).map((e) => deserialize<_i19.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i20.AppRole>) {
      return (data as List).map((e) => deserialize<_i20.AppRole>(e)).toList()
          as T;
    }
    if (t == List<_i21.AppPermission>) {
      return (data as List)
              .map((e) => deserialize<_i21.AppPermission>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i22.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i22.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.AppUser>) {
      return (data as List).map((e) => deserialize<_i23.AppUser>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _i24.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.CrmLead => 'CrmLead',
      _i4.CrmLeadMetricsResponse => 'CrmLeadMetricsResponse',
      _i5.AppPermission => 'AppPermission',
      _i6.AppRole => 'AppRole',
      _i7.AppUser => 'AppUser',
      _i8.AuditLog => 'AuditLog',
      _i9.AuditLogPageResponse => 'AuditLogPageResponse',
      _i10.MfaChallenge => 'MfaChallenge',
      _i11.MfaChallengeResponse => 'MfaChallengeResponse',
      _i12.MfaVerifyResponse => 'MfaVerifyResponse',
      _i13.RolePermission => 'RolePermission',
      _i14.ServerMetricsResponse => 'ServerMetricsResponse',
      _i15.TrustedDevice => 'TrustedDevice',
      _i16.UserRole => 'UserRole',
      _i17.UserSession => 'UserSession',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'elite_multiservicios.',
        '',
      );
    }

    switch (data) {
      case _i2.Greeting():
        return 'Greeting';
      case _i3.CrmLead():
        return 'CrmLead';
      case _i4.CrmLeadMetricsResponse():
        return 'CrmLeadMetricsResponse';
      case _i5.AppPermission():
        return 'AppPermission';
      case _i6.AppRole():
        return 'AppRole';
      case _i7.AppUser():
        return 'AppUser';
      case _i8.AuditLog():
        return 'AuditLog';
      case _i9.AuditLogPageResponse():
        return 'AuditLogPageResponse';
      case _i10.MfaChallenge():
        return 'MfaChallenge';
      case _i11.MfaChallengeResponse():
        return 'MfaChallengeResponse';
      case _i12.MfaVerifyResponse():
        return 'MfaVerifyResponse';
      case _i13.RolePermission():
        return 'RolePermission';
      case _i14.ServerMetricsResponse():
        return 'ServerMetricsResponse';
      case _i15.TrustedDevice():
        return 'TrustedDevice';
      case _i16.UserRole():
        return 'UserRole';
      case _i17.UserSession():
        return 'UserSession';
    }
    className = _i24.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'CrmLead') {
      return deserialize<_i3.CrmLead>(data['data']);
    }
    if (dataClassName == 'CrmLeadMetricsResponse') {
      return deserialize<_i4.CrmLeadMetricsResponse>(data['data']);
    }
    if (dataClassName == 'AppPermission') {
      return deserialize<_i5.AppPermission>(data['data']);
    }
    if (dataClassName == 'AppRole') {
      return deserialize<_i6.AppRole>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i7.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i8.AuditLog>(data['data']);
    }
    if (dataClassName == 'AuditLogPageResponse') {
      return deserialize<_i9.AuditLogPageResponse>(data['data']);
    }
    if (dataClassName == 'MfaChallenge') {
      return deserialize<_i10.MfaChallenge>(data['data']);
    }
    if (dataClassName == 'MfaChallengeResponse') {
      return deserialize<_i11.MfaChallengeResponse>(data['data']);
    }
    if (dataClassName == 'MfaVerifyResponse') {
      return deserialize<_i12.MfaVerifyResponse>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i13.RolePermission>(data['data']);
    }
    if (dataClassName == 'ServerMetricsResponse') {
      return deserialize<_i14.ServerMetricsResponse>(data['data']);
    }
    if (dataClassName == 'TrustedDevice') {
      return deserialize<_i15.TrustedDevice>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i16.UserRole>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i17.UserSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i24.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i25.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i24.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
