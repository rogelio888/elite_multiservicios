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
import 'modules/security/models/app_permission.dart' as _i3;
import 'modules/security/models/app_role.dart' as _i4;
import 'modules/security/models/app_user.dart' as _i5;
import 'modules/security/models/audit_log.dart' as _i6;
import 'modules/security/models/mfa_challenge.dart' as _i7;
import 'modules/security/models/mfa_challenge_response.dart' as _i8;
import 'modules/security/models/mfa_verify_response.dart' as _i9;
import 'modules/security/models/role_permission.dart' as _i10;
import 'modules/security/models/trusted_device.dart' as _i11;
import 'modules/security/models/user_role.dart' as _i12;
import 'modules/security/models/user_session.dart' as _i13;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i14;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i15;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i16;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i17;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i18;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i19;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i20;
export 'greetings/greeting.dart';
export 'modules/security/models/app_permission.dart';
export 'modules/security/models/app_role.dart';
export 'modules/security/models/app_user.dart';
export 'modules/security/models/audit_log.dart';
export 'modules/security/models/mfa_challenge.dart';
export 'modules/security/models/mfa_challenge_response.dart';
export 'modules/security/models/mfa_verify_response.dart';
export 'modules/security/models/role_permission.dart';
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
    if (t == _i3.AppPermission) {
      return _i3.AppPermission.fromJson(data) as T;
    }
    if (t == _i4.AppRole) {
      return _i4.AppRole.fromJson(data) as T;
    }
    if (t == _i5.AppUser) {
      return _i5.AppUser.fromJson(data) as T;
    }
    if (t == _i6.AuditLog) {
      return _i6.AuditLog.fromJson(data) as T;
    }
    if (t == _i7.MfaChallenge) {
      return _i7.MfaChallenge.fromJson(data) as T;
    }
    if (t == _i8.MfaChallengeResponse) {
      return _i8.MfaChallengeResponse.fromJson(data) as T;
    }
    if (t == _i9.MfaVerifyResponse) {
      return _i9.MfaVerifyResponse.fromJson(data) as T;
    }
    if (t == _i10.RolePermission) {
      return _i10.RolePermission.fromJson(data) as T;
    }
    if (t == _i11.TrustedDevice) {
      return _i11.TrustedDevice.fromJson(data) as T;
    }
    if (t == _i12.UserRole) {
      return _i12.UserRole.fromJson(data) as T;
    }
    if (t == _i13.UserSession) {
      return _i13.UserSession.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppPermission?>()) {
      return (data != null ? _i3.AppPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AppRole?>()) {
      return (data != null ? _i4.AppRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AppUser?>()) {
      return (data != null ? _i5.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AuditLog?>()) {
      return (data != null ? _i6.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.MfaChallenge?>()) {
      return (data != null ? _i7.MfaChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.MfaChallengeResponse?>()) {
      return (data != null ? _i8.MfaChallengeResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.MfaVerifyResponse?>()) {
      return (data != null ? _i9.MfaVerifyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.RolePermission?>()) {
      return (data != null ? _i10.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.TrustedDevice?>()) {
      return (data != null ? _i11.TrustedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.UserRole?>()) {
      return (data != null ? _i12.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.UserSession?>()) {
      return (data != null ? _i13.UserSession.fromJson(data) : null) as T;
    }
    if (t == List<_i14.AuditLog>) {
      return (data as List).map((e) => deserialize<_i14.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i15.AppRole>) {
      return (data as List).map((e) => deserialize<_i15.AppRole>(e)).toList()
          as T;
    }
    if (t == List<_i16.AppPermission>) {
      return (data as List)
              .map((e) => deserialize<_i16.AppPermission>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i17.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i17.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.AppUser>) {
      return (data as List).map((e) => deserialize<_i18.AppUser>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.AppPermission => 'AppPermission',
      _i4.AppRole => 'AppRole',
      _i5.AppUser => 'AppUser',
      _i6.AuditLog => 'AuditLog',
      _i7.MfaChallenge => 'MfaChallenge',
      _i8.MfaChallengeResponse => 'MfaChallengeResponse',
      _i9.MfaVerifyResponse => 'MfaVerifyResponse',
      _i10.RolePermission => 'RolePermission',
      _i11.TrustedDevice => 'TrustedDevice',
      _i12.UserRole => 'UserRole',
      _i13.UserSession => 'UserSession',
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
      case _i3.AppPermission():
        return 'AppPermission';
      case _i4.AppRole():
        return 'AppRole';
      case _i5.AppUser():
        return 'AppUser';
      case _i6.AuditLog():
        return 'AuditLog';
      case _i7.MfaChallenge():
        return 'MfaChallenge';
      case _i8.MfaChallengeResponse():
        return 'MfaChallengeResponse';
      case _i9.MfaVerifyResponse():
        return 'MfaVerifyResponse';
      case _i10.RolePermission():
        return 'RolePermission';
      case _i11.TrustedDevice():
        return 'TrustedDevice';
      case _i12.UserRole():
        return 'UserRole';
      case _i13.UserSession():
        return 'UserSession';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AppPermission') {
      return deserialize<_i3.AppPermission>(data['data']);
    }
    if (dataClassName == 'AppRole') {
      return deserialize<_i4.AppRole>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i5.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i6.AuditLog>(data['data']);
    }
    if (dataClassName == 'MfaChallenge') {
      return deserialize<_i7.MfaChallenge>(data['data']);
    }
    if (dataClassName == 'MfaChallengeResponse') {
      return deserialize<_i8.MfaChallengeResponse>(data['data']);
    }
    if (dataClassName == 'MfaVerifyResponse') {
      return deserialize<_i9.MfaVerifyResponse>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i10.RolePermission>(data['data']);
    }
    if (dataClassName == 'TrustedDevice') {
      return deserialize<_i11.TrustedDevice>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i12.UserRole>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i13.UserSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i20.Protocol().deserializeByClassName(data);
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
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i20.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
