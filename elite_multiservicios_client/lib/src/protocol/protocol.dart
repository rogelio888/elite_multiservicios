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
import 'modules/crm/models/crm_agenda_metrics_response.dart' as _i3;
import 'modules/crm/models/crm_contract_budget_item.dart' as _i4;
import 'modules/crm/models/crm_customer.dart' as _i5;
import 'modules/crm/models/crm_customer_branch.dart' as _i6;
import 'modules/crm/models/crm_customer_contract.dart' as _i7;
import 'modules/crm/models/crm_customer_detail_response.dart' as _i8;
import 'modules/crm/models/crm_customer_metrics_response.dart' as _i9;
import 'modules/crm/models/crm_lead.dart' as _i10;
import 'modules/crm/models/crm_lead_metrics_response.dart' as _i11;
import 'modules/crm/models/crm_opportunity.dart' as _i12;
import 'modules/crm/models/crm_pipeline_metrics_response.dart' as _i13;
import 'modules/crm/models/crm_quote_item.dart' as _i14;
import 'modules/crm/models/crm_task.dart' as _i15;
import 'modules/security/models/app_permission.dart' as _i16;
import 'modules/security/models/app_role.dart' as _i17;
import 'modules/security/models/app_user.dart' as _i18;
import 'modules/security/models/audit_log.dart' as _i19;
import 'modules/security/models/audit_log_page_response.dart' as _i20;
import 'modules/security/models/mfa_challenge.dart' as _i21;
import 'modules/security/models/mfa_challenge_response.dart' as _i22;
import 'modules/security/models/mfa_verify_response.dart' as _i23;
import 'modules/security/models/role_permission.dart' as _i24;
import 'modules/security/models/server_metrics_response.dart' as _i25;
import 'modules/security/models/trusted_device.dart' as _i26;
import 'modules/security/models/user_role.dart' as _i27;
import 'modules/security/models/user_session.dart' as _i28;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_task.dart'
    as _i29;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer.dart'
    as _i30;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_contract_budget_item.dart'
    as _i31;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i32;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_opportunity.dart'
    as _i33;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_quote_item.dart'
    as _i34;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i35;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i36;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i37;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i38;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i39;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i40;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i41;
export 'greetings/greeting.dart';
export 'modules/crm/models/crm_agenda_metrics_response.dart';
export 'modules/crm/models/crm_contract_budget_item.dart';
export 'modules/crm/models/crm_customer.dart';
export 'modules/crm/models/crm_customer_branch.dart';
export 'modules/crm/models/crm_customer_contract.dart';
export 'modules/crm/models/crm_customer_detail_response.dart';
export 'modules/crm/models/crm_customer_metrics_response.dart';
export 'modules/crm/models/crm_lead.dart';
export 'modules/crm/models/crm_lead_metrics_response.dart';
export 'modules/crm/models/crm_opportunity.dart';
export 'modules/crm/models/crm_pipeline_metrics_response.dart';
export 'modules/crm/models/crm_quote_item.dart';
export 'modules/crm/models/crm_task.dart';
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
    if (t == _i3.CrmAgendaMetricsResponse) {
      return _i3.CrmAgendaMetricsResponse.fromJson(data) as T;
    }
    if (t == _i4.CrmContractBudgetItem) {
      return _i4.CrmContractBudgetItem.fromJson(data) as T;
    }
    if (t == _i5.CrmCustomer) {
      return _i5.CrmCustomer.fromJson(data) as T;
    }
    if (t == _i6.CrmCustomerBranch) {
      return _i6.CrmCustomerBranch.fromJson(data) as T;
    }
    if (t == _i7.CrmCustomerContract) {
      return _i7.CrmCustomerContract.fromJson(data) as T;
    }
    if (t == _i8.CrmCustomerDetailResponse) {
      return _i8.CrmCustomerDetailResponse.fromJson(data) as T;
    }
    if (t == _i9.CrmCustomerMetricsResponse) {
      return _i9.CrmCustomerMetricsResponse.fromJson(data) as T;
    }
    if (t == _i10.CrmLead) {
      return _i10.CrmLead.fromJson(data) as T;
    }
    if (t == _i11.CrmLeadMetricsResponse) {
      return _i11.CrmLeadMetricsResponse.fromJson(data) as T;
    }
    if (t == _i12.CrmOpportunity) {
      return _i12.CrmOpportunity.fromJson(data) as T;
    }
    if (t == _i13.CrmPipelineMetricsResponse) {
      return _i13.CrmPipelineMetricsResponse.fromJson(data) as T;
    }
    if (t == _i14.CrmQuoteItem) {
      return _i14.CrmQuoteItem.fromJson(data) as T;
    }
    if (t == _i15.CrmTask) {
      return _i15.CrmTask.fromJson(data) as T;
    }
    if (t == _i16.AppPermission) {
      return _i16.AppPermission.fromJson(data) as T;
    }
    if (t == _i17.AppRole) {
      return _i17.AppRole.fromJson(data) as T;
    }
    if (t == _i18.AppUser) {
      return _i18.AppUser.fromJson(data) as T;
    }
    if (t == _i19.AuditLog) {
      return _i19.AuditLog.fromJson(data) as T;
    }
    if (t == _i20.AuditLogPageResponse) {
      return _i20.AuditLogPageResponse.fromJson(data) as T;
    }
    if (t == _i21.MfaChallenge) {
      return _i21.MfaChallenge.fromJson(data) as T;
    }
    if (t == _i22.MfaChallengeResponse) {
      return _i22.MfaChallengeResponse.fromJson(data) as T;
    }
    if (t == _i23.MfaVerifyResponse) {
      return _i23.MfaVerifyResponse.fromJson(data) as T;
    }
    if (t == _i24.RolePermission) {
      return _i24.RolePermission.fromJson(data) as T;
    }
    if (t == _i25.ServerMetricsResponse) {
      return _i25.ServerMetricsResponse.fromJson(data) as T;
    }
    if (t == _i26.TrustedDevice) {
      return _i26.TrustedDevice.fromJson(data) as T;
    }
    if (t == _i27.UserRole) {
      return _i27.UserRole.fromJson(data) as T;
    }
    if (t == _i28.UserSession) {
      return _i28.UserSession.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CrmAgendaMetricsResponse?>()) {
      return (data != null ? _i3.CrmAgendaMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CrmContractBudgetItem?>()) {
      return (data != null ? _i4.CrmContractBudgetItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.CrmCustomer?>()) {
      return (data != null ? _i5.CrmCustomer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CrmCustomerBranch?>()) {
      return (data != null ? _i6.CrmCustomerBranch.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CrmCustomerContract?>()) {
      return (data != null ? _i7.CrmCustomerContract.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.CrmCustomerDetailResponse?>()) {
      return (data != null
              ? _i8.CrmCustomerDetailResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.CrmCustomerMetricsResponse?>()) {
      return (data != null
              ? _i9.CrmCustomerMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.CrmLead?>()) {
      return (data != null ? _i10.CrmLead.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CrmLeadMetricsResponse?>()) {
      return (data != null ? _i11.CrmLeadMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.CrmOpportunity?>()) {
      return (data != null ? _i12.CrmOpportunity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CrmPipelineMetricsResponse?>()) {
      return (data != null
              ? _i13.CrmPipelineMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.CrmQuoteItem?>()) {
      return (data != null ? _i14.CrmQuoteItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CrmTask?>()) {
      return (data != null ? _i15.CrmTask.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.AppPermission?>()) {
      return (data != null ? _i16.AppPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.AppRole?>()) {
      return (data != null ? _i17.AppRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.AppUser?>()) {
      return (data != null ? _i18.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.AuditLog?>()) {
      return (data != null ? _i19.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.AuditLogPageResponse?>()) {
      return (data != null ? _i20.AuditLogPageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.MfaChallenge?>()) {
      return (data != null ? _i21.MfaChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.MfaChallengeResponse?>()) {
      return (data != null ? _i22.MfaChallengeResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.MfaVerifyResponse?>()) {
      return (data != null ? _i23.MfaVerifyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.RolePermission?>()) {
      return (data != null ? _i24.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ServerMetricsResponse?>()) {
      return (data != null ? _i25.ServerMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.TrustedDevice?>()) {
      return (data != null ? _i26.TrustedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.UserRole?>()) {
      return (data != null ? _i27.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.UserSession?>()) {
      return (data != null ? _i28.UserSession.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i6.CrmCustomerBranch>) {
      return (data as List)
              .map((e) => deserialize<_i6.CrmCustomerBranch>(e))
              .toList()
          as T;
    }
    if (t == List<_i7.CrmCustomerContract>) {
      return (data as List)
              .map((e) => deserialize<_i7.CrmCustomerContract>(e))
              .toList()
          as T;
    }
    if (t == List<_i4.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i4.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.AuditLog>) {
      return (data as List).map((e) => deserialize<_i19.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i29.CrmTask>) {
      return (data as List).map((e) => deserialize<_i29.CrmTask>(e)).toList()
          as T;
    }
    if (t == List<_i30.CrmCustomer>) {
      return (data as List)
              .map((e) => deserialize<_i30.CrmCustomer>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i31.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i31.CrmContractBudgetItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i31.CrmContractBudgetItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i32.CrmLead>) {
      return (data as List).map((e) => deserialize<_i32.CrmLead>(e)).toList()
          as T;
    }
    if (t == List<_i33.CrmOpportunity>) {
      return (data as List)
              .map((e) => deserialize<_i33.CrmOpportunity>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CrmQuoteItem>) {
      return (data as List)
              .map((e) => deserialize<_i34.CrmQuoteItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i34.CrmQuoteItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i34.CrmQuoteItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i35.AuditLog>) {
      return (data as List).map((e) => deserialize<_i35.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i36.AppRole>) {
      return (data as List).map((e) => deserialize<_i36.AppRole>(e)).toList()
          as T;
    }
    if (t == List<_i37.AppPermission>) {
      return (data as List)
              .map((e) => deserialize<_i37.AppPermission>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i38.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i38.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.AppUser>) {
      return (data as List).map((e) => deserialize<_i39.AppUser>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _i40.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i41.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.CrmAgendaMetricsResponse => 'CrmAgendaMetricsResponse',
      _i4.CrmContractBudgetItem => 'CrmContractBudgetItem',
      _i5.CrmCustomer => 'CrmCustomer',
      _i6.CrmCustomerBranch => 'CrmCustomerBranch',
      _i7.CrmCustomerContract => 'CrmCustomerContract',
      _i8.CrmCustomerDetailResponse => 'CrmCustomerDetailResponse',
      _i9.CrmCustomerMetricsResponse => 'CrmCustomerMetricsResponse',
      _i10.CrmLead => 'CrmLead',
      _i11.CrmLeadMetricsResponse => 'CrmLeadMetricsResponse',
      _i12.CrmOpportunity => 'CrmOpportunity',
      _i13.CrmPipelineMetricsResponse => 'CrmPipelineMetricsResponse',
      _i14.CrmQuoteItem => 'CrmQuoteItem',
      _i15.CrmTask => 'CrmTask',
      _i16.AppPermission => 'AppPermission',
      _i17.AppRole => 'AppRole',
      _i18.AppUser => 'AppUser',
      _i19.AuditLog => 'AuditLog',
      _i20.AuditLogPageResponse => 'AuditLogPageResponse',
      _i21.MfaChallenge => 'MfaChallenge',
      _i22.MfaChallengeResponse => 'MfaChallengeResponse',
      _i23.MfaVerifyResponse => 'MfaVerifyResponse',
      _i24.RolePermission => 'RolePermission',
      _i25.ServerMetricsResponse => 'ServerMetricsResponse',
      _i26.TrustedDevice => 'TrustedDevice',
      _i27.UserRole => 'UserRole',
      _i28.UserSession => 'UserSession',
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
      case _i3.CrmAgendaMetricsResponse():
        return 'CrmAgendaMetricsResponse';
      case _i4.CrmContractBudgetItem():
        return 'CrmContractBudgetItem';
      case _i5.CrmCustomer():
        return 'CrmCustomer';
      case _i6.CrmCustomerBranch():
        return 'CrmCustomerBranch';
      case _i7.CrmCustomerContract():
        return 'CrmCustomerContract';
      case _i8.CrmCustomerDetailResponse():
        return 'CrmCustomerDetailResponse';
      case _i9.CrmCustomerMetricsResponse():
        return 'CrmCustomerMetricsResponse';
      case _i10.CrmLead():
        return 'CrmLead';
      case _i11.CrmLeadMetricsResponse():
        return 'CrmLeadMetricsResponse';
      case _i12.CrmOpportunity():
        return 'CrmOpportunity';
      case _i13.CrmPipelineMetricsResponse():
        return 'CrmPipelineMetricsResponse';
      case _i14.CrmQuoteItem():
        return 'CrmQuoteItem';
      case _i15.CrmTask():
        return 'CrmTask';
      case _i16.AppPermission():
        return 'AppPermission';
      case _i17.AppRole():
        return 'AppRole';
      case _i18.AppUser():
        return 'AppUser';
      case _i19.AuditLog():
        return 'AuditLog';
      case _i20.AuditLogPageResponse():
        return 'AuditLogPageResponse';
      case _i21.MfaChallenge():
        return 'MfaChallenge';
      case _i22.MfaChallengeResponse():
        return 'MfaChallengeResponse';
      case _i23.MfaVerifyResponse():
        return 'MfaVerifyResponse';
      case _i24.RolePermission():
        return 'RolePermission';
      case _i25.ServerMetricsResponse():
        return 'ServerMetricsResponse';
      case _i26.TrustedDevice():
        return 'TrustedDevice';
      case _i27.UserRole():
        return 'UserRole';
      case _i28.UserSession():
        return 'UserSession';
    }
    className = _i40.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i41.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CrmAgendaMetricsResponse') {
      return deserialize<_i3.CrmAgendaMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmContractBudgetItem') {
      return deserialize<_i4.CrmContractBudgetItem>(data['data']);
    }
    if (dataClassName == 'CrmCustomer') {
      return deserialize<_i5.CrmCustomer>(data['data']);
    }
    if (dataClassName == 'CrmCustomerBranch') {
      return deserialize<_i6.CrmCustomerBranch>(data['data']);
    }
    if (dataClassName == 'CrmCustomerContract') {
      return deserialize<_i7.CrmCustomerContract>(data['data']);
    }
    if (dataClassName == 'CrmCustomerDetailResponse') {
      return deserialize<_i8.CrmCustomerDetailResponse>(data['data']);
    }
    if (dataClassName == 'CrmCustomerMetricsResponse') {
      return deserialize<_i9.CrmCustomerMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmLead') {
      return deserialize<_i10.CrmLead>(data['data']);
    }
    if (dataClassName == 'CrmLeadMetricsResponse') {
      return deserialize<_i11.CrmLeadMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmOpportunity') {
      return deserialize<_i12.CrmOpportunity>(data['data']);
    }
    if (dataClassName == 'CrmPipelineMetricsResponse') {
      return deserialize<_i13.CrmPipelineMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmQuoteItem') {
      return deserialize<_i14.CrmQuoteItem>(data['data']);
    }
    if (dataClassName == 'CrmTask') {
      return deserialize<_i15.CrmTask>(data['data']);
    }
    if (dataClassName == 'AppPermission') {
      return deserialize<_i16.AppPermission>(data['data']);
    }
    if (dataClassName == 'AppRole') {
      return deserialize<_i17.AppRole>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i18.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i19.AuditLog>(data['data']);
    }
    if (dataClassName == 'AuditLogPageResponse') {
      return deserialize<_i20.AuditLogPageResponse>(data['data']);
    }
    if (dataClassName == 'MfaChallenge') {
      return deserialize<_i21.MfaChallenge>(data['data']);
    }
    if (dataClassName == 'MfaChallengeResponse') {
      return deserialize<_i22.MfaChallengeResponse>(data['data']);
    }
    if (dataClassName == 'MfaVerifyResponse') {
      return deserialize<_i23.MfaVerifyResponse>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i24.RolePermission>(data['data']);
    }
    if (dataClassName == 'ServerMetricsResponse') {
      return deserialize<_i25.ServerMetricsResponse>(data['data']);
    }
    if (dataClassName == 'TrustedDevice') {
      return deserialize<_i26.TrustedDevice>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i27.UserRole>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i28.UserSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i40.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i41.Protocol().deserializeByClassName(data);
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
      return _i40.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i41.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
