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
import 'modules/crm/models/crm_catalog_item.dart' as _i4;
import 'modules/crm/models/crm_catalog_item_scope.dart' as _i5;
import 'modules/crm/models/crm_contract_budget_item.dart' as _i6;
import 'modules/crm/models/crm_customer.dart' as _i7;
import 'modules/crm/models/crm_customer_branch.dart' as _i8;
import 'modules/crm/models/crm_customer_contract.dart' as _i9;
import 'modules/crm/models/crm_customer_detail_response.dart' as _i10;
import 'modules/crm/models/crm_customer_metrics_response.dart' as _i11;
import 'modules/crm/models/crm_lead.dart' as _i12;
import 'modules/crm/models/crm_lead_metrics_response.dart' as _i13;
import 'modules/crm/models/crm_opportunity.dart' as _i14;
import 'modules/crm/models/crm_pipeline_metrics_response.dart' as _i15;
import 'modules/crm/models/crm_quote_item.dart' as _i16;
import 'modules/crm/models/crm_sector.dart' as _i17;
import 'modules/crm/models/crm_service_line.dart' as _i18;
import 'modules/crm/models/crm_task.dart' as _i19;
import 'modules/rrhh/models/rrhh_applicant.dart' as _i20;
import 'modules/rrhh/models/rrhh_area.dart' as _i21;
import 'modules/rrhh/models/rrhh_assignment.dart' as _i22;
import 'modules/rrhh/models/rrhh_dashboard_metrics_response.dart' as _i23;
import 'modules/rrhh/models/rrhh_employee.dart' as _i24;
import 'modules/rrhh/models/rrhh_employee_bonus.dart' as _i25;
import 'modules/rrhh/models/rrhh_employee_contract_data.dart' as _i26;
import 'modules/rrhh/models/rrhh_employee_deduction.dart' as _i27;
import 'modules/rrhh/models/rrhh_employee_document.dart' as _i28;
import 'modules/rrhh/models/rrhh_incident.dart' as _i29;
import 'modules/rrhh/models/rrhh_leave_request.dart' as _i30;
import 'modules/rrhh/models/rrhh_movement_history.dart' as _i31;
import 'modules/rrhh/models/rrhh_position.dart' as _i32;
import 'modules/rrhh/models/rrhh_recent_movement_dto.dart' as _i33;
import 'modules/rrhh/models/rrhh_schedule.dart' as _i34;
import 'modules/rrhh/models/rrhh_specialty.dart' as _i35;
import 'modules/rrhh/models/rrhh_termination.dart' as _i36;
import 'modules/rrhh/models/rrhh_timeline_event.dart' as _i37;
import 'modules/rrhh/models/rrhh_vacation.dart' as _i38;
import 'modules/security/models/app_permission.dart' as _i39;
import 'modules/security/models/app_role.dart' as _i40;
import 'modules/security/models/app_user.dart' as _i41;
import 'modules/security/models/audit_log.dart' as _i42;
import 'modules/security/models/audit_log_page_response.dart' as _i43;
import 'modules/security/models/mfa_challenge.dart' as _i44;
import 'modules/security/models/mfa_challenge_response.dart' as _i45;
import 'modules/security/models/mfa_verify_response.dart' as _i46;
import 'modules/security/models/role_permission.dart' as _i47;
import 'modules/security/models/trusted_device.dart' as _i48;
import 'modules/security/models/user_role.dart' as _i49;
import 'modules/security/models/user_session.dart' as _i50;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_task.dart'
    as _i51;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_sector.dart'
    as _i52;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_service_line.dart'
    as _i53;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item.dart'
    as _i54;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item_scope.dart'
    as _i55;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer.dart'
    as _i56;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_contract_budget_item.dart'
    as _i57;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i58;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_opportunity.dart'
    as _i59;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_quote_item.dart'
    as _i60;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_applicant.dart'
    as _i61;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_schedule.dart'
    as _i62;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_assignment.dart'
    as _i63;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_recent_movement_dto.dart'
    as _i64;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_leave_request.dart'
    as _i65;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_vacation.dart'
    as _i66;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_incident.dart'
    as _i67;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_movement_history.dart'
    as _i68;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_area.dart'
    as _i69;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_position.dart'
    as _i70;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_specialty.dart'
    as _i71;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee.dart'
    as _i72;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_document.dart'
    as _i73;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_timeline_event.dart'
    as _i74;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i75;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i76;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i77;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i78;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i79;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i80;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i81;
export 'greetings/greeting.dart';
export 'modules/crm/models/crm_agenda_metrics_response.dart';
export 'modules/crm/models/crm_catalog_item.dart';
export 'modules/crm/models/crm_catalog_item_scope.dart';
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
export 'modules/crm/models/crm_sector.dart';
export 'modules/crm/models/crm_service_line.dart';
export 'modules/crm/models/crm_task.dart';
export 'modules/rrhh/models/rrhh_applicant.dart';
export 'modules/rrhh/models/rrhh_area.dart';
export 'modules/rrhh/models/rrhh_assignment.dart';
export 'modules/rrhh/models/rrhh_dashboard_metrics_response.dart';
export 'modules/rrhh/models/rrhh_employee.dart';
export 'modules/rrhh/models/rrhh_employee_bonus.dart';
export 'modules/rrhh/models/rrhh_employee_contract_data.dart';
export 'modules/rrhh/models/rrhh_employee_deduction.dart';
export 'modules/rrhh/models/rrhh_employee_document.dart';
export 'modules/rrhh/models/rrhh_incident.dart';
export 'modules/rrhh/models/rrhh_leave_request.dart';
export 'modules/rrhh/models/rrhh_movement_history.dart';
export 'modules/rrhh/models/rrhh_position.dart';
export 'modules/rrhh/models/rrhh_recent_movement_dto.dart';
export 'modules/rrhh/models/rrhh_schedule.dart';
export 'modules/rrhh/models/rrhh_specialty.dart';
export 'modules/rrhh/models/rrhh_termination.dart';
export 'modules/rrhh/models/rrhh_timeline_event.dart';
export 'modules/rrhh/models/rrhh_vacation.dart';
export 'modules/security/models/app_permission.dart';
export 'modules/security/models/app_role.dart';
export 'modules/security/models/app_user.dart';
export 'modules/security/models/audit_log.dart';
export 'modules/security/models/audit_log_page_response.dart';
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
    if (t == _i3.CrmAgendaMetricsResponse) {
      return _i3.CrmAgendaMetricsResponse.fromJson(data) as T;
    }
    if (t == _i4.CrmCatalogItem) {
      return _i4.CrmCatalogItem.fromJson(data) as T;
    }
    if (t == _i5.CrmCatalogItemScope) {
      return _i5.CrmCatalogItemScope.fromJson(data) as T;
    }
    if (t == _i6.CrmContractBudgetItem) {
      return _i6.CrmContractBudgetItem.fromJson(data) as T;
    }
    if (t == _i7.CrmCustomer) {
      return _i7.CrmCustomer.fromJson(data) as T;
    }
    if (t == _i8.CrmCustomerBranch) {
      return _i8.CrmCustomerBranch.fromJson(data) as T;
    }
    if (t == _i9.CrmCustomerContract) {
      return _i9.CrmCustomerContract.fromJson(data) as T;
    }
    if (t == _i10.CrmCustomerDetailResponse) {
      return _i10.CrmCustomerDetailResponse.fromJson(data) as T;
    }
    if (t == _i11.CrmCustomerMetricsResponse) {
      return _i11.CrmCustomerMetricsResponse.fromJson(data) as T;
    }
    if (t == _i12.CrmLead) {
      return _i12.CrmLead.fromJson(data) as T;
    }
    if (t == _i13.CrmLeadMetricsResponse) {
      return _i13.CrmLeadMetricsResponse.fromJson(data) as T;
    }
    if (t == _i14.CrmOpportunity) {
      return _i14.CrmOpportunity.fromJson(data) as T;
    }
    if (t == _i15.CrmPipelineMetricsResponse) {
      return _i15.CrmPipelineMetricsResponse.fromJson(data) as T;
    }
    if (t == _i16.CrmQuoteItem) {
      return _i16.CrmQuoteItem.fromJson(data) as T;
    }
    if (t == _i17.CrmSector) {
      return _i17.CrmSector.fromJson(data) as T;
    }
    if (t == _i18.CrmServiceLine) {
      return _i18.CrmServiceLine.fromJson(data) as T;
    }
    if (t == _i19.CrmTask) {
      return _i19.CrmTask.fromJson(data) as T;
    }
    if (t == _i20.RrhhApplicant) {
      return _i20.RrhhApplicant.fromJson(data) as T;
    }
    if (t == _i21.RrhhArea) {
      return _i21.RrhhArea.fromJson(data) as T;
    }
    if (t == _i22.RrhhAssignment) {
      return _i22.RrhhAssignment.fromJson(data) as T;
    }
    if (t == _i23.RrhhDashboardMetricsResponse) {
      return _i23.RrhhDashboardMetricsResponse.fromJson(data) as T;
    }
    if (t == _i24.RrhhEmployee) {
      return _i24.RrhhEmployee.fromJson(data) as T;
    }
    if (t == _i25.RrhhEmployeeBonus) {
      return _i25.RrhhEmployeeBonus.fromJson(data) as T;
    }
    if (t == _i26.RrhhEmployeeContractData) {
      return _i26.RrhhEmployeeContractData.fromJson(data) as T;
    }
    if (t == _i27.RrhhEmployeeDeduction) {
      return _i27.RrhhEmployeeDeduction.fromJson(data) as T;
    }
    if (t == _i28.RrhhEmployeeDocument) {
      return _i28.RrhhEmployeeDocument.fromJson(data) as T;
    }
    if (t == _i29.RrhhIncident) {
      return _i29.RrhhIncident.fromJson(data) as T;
    }
    if (t == _i30.RrhhLeaveRequest) {
      return _i30.RrhhLeaveRequest.fromJson(data) as T;
    }
    if (t == _i31.RrhhMovementHistory) {
      return _i31.RrhhMovementHistory.fromJson(data) as T;
    }
    if (t == _i32.RrhhPosition) {
      return _i32.RrhhPosition.fromJson(data) as T;
    }
    if (t == _i33.RrhhRecentMovementDto) {
      return _i33.RrhhRecentMovementDto.fromJson(data) as T;
    }
    if (t == _i34.RrhhSchedule) {
      return _i34.RrhhSchedule.fromJson(data) as T;
    }
    if (t == _i35.RrhhSpecialty) {
      return _i35.RrhhSpecialty.fromJson(data) as T;
    }
    if (t == _i36.RrhhTermination) {
      return _i36.RrhhTermination.fromJson(data) as T;
    }
    if (t == _i37.RrhhTimelineEvent) {
      return _i37.RrhhTimelineEvent.fromJson(data) as T;
    }
    if (t == _i38.RrhhVacation) {
      return _i38.RrhhVacation.fromJson(data) as T;
    }
    if (t == _i39.AppPermission) {
      return _i39.AppPermission.fromJson(data) as T;
    }
    if (t == _i40.AppRole) {
      return _i40.AppRole.fromJson(data) as T;
    }
    if (t == _i41.AppUser) {
      return _i41.AppUser.fromJson(data) as T;
    }
    if (t == _i42.AuditLog) {
      return _i42.AuditLog.fromJson(data) as T;
    }
    if (t == _i43.AuditLogPageResponse) {
      return _i43.AuditLogPageResponse.fromJson(data) as T;
    }
    if (t == _i44.MfaChallenge) {
      return _i44.MfaChallenge.fromJson(data) as T;
    }
    if (t == _i45.MfaChallengeResponse) {
      return _i45.MfaChallengeResponse.fromJson(data) as T;
    }
    if (t == _i46.MfaVerifyResponse) {
      return _i46.MfaVerifyResponse.fromJson(data) as T;
    }
    if (t == _i47.RolePermission) {
      return _i47.RolePermission.fromJson(data) as T;
    }
    if (t == _i48.TrustedDevice) {
      return _i48.TrustedDevice.fromJson(data) as T;
    }
    if (t == _i49.UserRole) {
      return _i49.UserRole.fromJson(data) as T;
    }
    if (t == _i50.UserSession) {
      return _i50.UserSession.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CrmAgendaMetricsResponse?>()) {
      return (data != null ? _i3.CrmAgendaMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CrmCatalogItem?>()) {
      return (data != null ? _i4.CrmCatalogItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CrmCatalogItemScope?>()) {
      return (data != null ? _i5.CrmCatalogItemScope.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.CrmContractBudgetItem?>()) {
      return (data != null ? _i6.CrmContractBudgetItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.CrmCustomer?>()) {
      return (data != null ? _i7.CrmCustomer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CrmCustomerBranch?>()) {
      return (data != null ? _i8.CrmCustomerBranch.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CrmCustomerContract?>()) {
      return (data != null ? _i9.CrmCustomerContract.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.CrmCustomerDetailResponse?>()) {
      return (data != null
              ? _i10.CrmCustomerDetailResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.CrmCustomerMetricsResponse?>()) {
      return (data != null
              ? _i11.CrmCustomerMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.CrmLead?>()) {
      return (data != null ? _i12.CrmLead.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CrmLeadMetricsResponse?>()) {
      return (data != null ? _i13.CrmLeadMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.CrmOpportunity?>()) {
      return (data != null ? _i14.CrmOpportunity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CrmPipelineMetricsResponse?>()) {
      return (data != null
              ? _i15.CrmPipelineMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.CrmQuoteItem?>()) {
      return (data != null ? _i16.CrmQuoteItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CrmSector?>()) {
      return (data != null ? _i17.CrmSector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CrmServiceLine?>()) {
      return (data != null ? _i18.CrmServiceLine.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CrmTask?>()) {
      return (data != null ? _i19.CrmTask.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.RrhhApplicant?>()) {
      return (data != null ? _i20.RrhhApplicant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.RrhhArea?>()) {
      return (data != null ? _i21.RrhhArea.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.RrhhAssignment?>()) {
      return (data != null ? _i22.RrhhAssignment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.RrhhDashboardMetricsResponse?>()) {
      return (data != null
              ? _i23.RrhhDashboardMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i24.RrhhEmployee?>()) {
      return (data != null ? _i24.RrhhEmployee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.RrhhEmployeeBonus?>()) {
      return (data != null ? _i25.RrhhEmployeeBonus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.RrhhEmployeeContractData?>()) {
      return (data != null
              ? _i26.RrhhEmployeeContractData.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i27.RrhhEmployeeDeduction?>()) {
      return (data != null ? _i27.RrhhEmployeeDeduction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.RrhhEmployeeDocument?>()) {
      return (data != null ? _i28.RrhhEmployeeDocument.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.RrhhIncident?>()) {
      return (data != null ? _i29.RrhhIncident.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.RrhhLeaveRequest?>()) {
      return (data != null ? _i30.RrhhLeaveRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.RrhhMovementHistory?>()) {
      return (data != null ? _i31.RrhhMovementHistory.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.RrhhPosition?>()) {
      return (data != null ? _i32.RrhhPosition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.RrhhRecentMovementDto?>()) {
      return (data != null ? _i33.RrhhRecentMovementDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.RrhhSchedule?>()) {
      return (data != null ? _i34.RrhhSchedule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.RrhhSpecialty?>()) {
      return (data != null ? _i35.RrhhSpecialty.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.RrhhTermination?>()) {
      return (data != null ? _i36.RrhhTermination.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.RrhhTimelineEvent?>()) {
      return (data != null ? _i37.RrhhTimelineEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.RrhhVacation?>()) {
      return (data != null ? _i38.RrhhVacation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.AppPermission?>()) {
      return (data != null ? _i39.AppPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.AppRole?>()) {
      return (data != null ? _i40.AppRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.AppUser?>()) {
      return (data != null ? _i41.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.AuditLog?>()) {
      return (data != null ? _i42.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.AuditLogPageResponse?>()) {
      return (data != null ? _i43.AuditLogPageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.MfaChallenge?>()) {
      return (data != null ? _i44.MfaChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.MfaChallengeResponse?>()) {
      return (data != null ? _i45.MfaChallengeResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.MfaVerifyResponse?>()) {
      return (data != null ? _i46.MfaVerifyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.RolePermission?>()) {
      return (data != null ? _i47.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.TrustedDevice?>()) {
      return (data != null ? _i48.TrustedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.UserRole?>()) {
      return (data != null ? _i49.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.UserSession?>()) {
      return (data != null ? _i50.UserSession.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i8.CrmCustomerBranch>) {
      return (data as List)
              .map((e) => deserialize<_i8.CrmCustomerBranch>(e))
              .toList()
          as T;
    }
    if (t == List<_i9.CrmCustomerContract>) {
      return (data as List)
              .map((e) => deserialize<_i9.CrmCustomerContract>(e))
              .toList()
          as T;
    }
    if (t == List<_i6.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i6.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i25.RrhhEmployeeBonus>) {
      return (data as List)
              .map((e) => deserialize<_i25.RrhhEmployeeBonus>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i25.RrhhEmployeeBonus>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i25.RrhhEmployeeBonus>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i27.RrhhEmployeeDeduction>) {
      return (data as List)
              .map((e) => deserialize<_i27.RrhhEmployeeDeduction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i27.RrhhEmployeeDeduction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i27.RrhhEmployeeDeduction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i42.AuditLog>) {
      return (data as List).map((e) => deserialize<_i42.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i51.CrmTask>) {
      return (data as List).map((e) => deserialize<_i51.CrmTask>(e)).toList()
          as T;
    }
    if (t == List<_i52.CrmSector>) {
      return (data as List).map((e) => deserialize<_i52.CrmSector>(e)).toList()
          as T;
    }
    if (t == List<_i53.CrmServiceLine>) {
      return (data as List)
              .map((e) => deserialize<_i53.CrmServiceLine>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.CrmCatalogItem>) {
      return (data as List)
              .map((e) => deserialize<_i54.CrmCatalogItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i55.CrmCatalogItemScope>) {
      return (data as List)
              .map((e) => deserialize<_i55.CrmCatalogItemScope>(e))
              .toList()
          as T;
    }
    if (t == List<_i56.CrmCustomer>) {
      return (data as List)
              .map((e) => deserialize<_i56.CrmCustomer>(e))
              .toList()
          as T;
    }
    if (t == List<_i57.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i57.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i57.CrmContractBudgetItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i57.CrmContractBudgetItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i58.CrmLead>) {
      return (data as List).map((e) => deserialize<_i58.CrmLead>(e)).toList()
          as T;
    }
    if (t == List<_i59.CrmOpportunity>) {
      return (data as List)
              .map((e) => deserialize<_i59.CrmOpportunity>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.CrmQuoteItem>) {
      return (data as List)
              .map((e) => deserialize<_i60.CrmQuoteItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i60.CrmQuoteItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i60.CrmQuoteItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i61.RrhhApplicant>) {
      return (data as List)
              .map((e) => deserialize<_i61.RrhhApplicant>(e))
              .toList()
          as T;
    }
    if (t == List<_i62.RrhhSchedule>) {
      return (data as List)
              .map((e) => deserialize<_i62.RrhhSchedule>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.RrhhAssignment>) {
      return (data as List)
              .map((e) => deserialize<_i63.RrhhAssignment>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.RrhhRecentMovementDto>) {
      return (data as List)
              .map((e) => deserialize<_i64.RrhhRecentMovementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.RrhhLeaveRequest>) {
      return (data as List)
              .map((e) => deserialize<_i65.RrhhLeaveRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.RrhhVacation>) {
      return (data as List)
              .map((e) => deserialize<_i66.RrhhVacation>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.RrhhIncident>) {
      return (data as List)
              .map((e) => deserialize<_i67.RrhhIncident>(e))
              .toList()
          as T;
    }
    if (t == List<_i68.RrhhMovementHistory>) {
      return (data as List)
              .map((e) => deserialize<_i68.RrhhMovementHistory>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.RrhhArea>) {
      return (data as List).map((e) => deserialize<_i69.RrhhArea>(e)).toList()
          as T;
    }
    if (t == List<_i70.RrhhPosition>) {
      return (data as List)
              .map((e) => deserialize<_i70.RrhhPosition>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.RrhhSpecialty>) {
      return (data as List)
              .map((e) => deserialize<_i71.RrhhSpecialty>(e))
              .toList()
          as T;
    }
    if (t == List<_i72.RrhhEmployee>) {
      return (data as List)
              .map((e) => deserialize<_i72.RrhhEmployee>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.RrhhEmployeeDocument>) {
      return (data as List)
              .map((e) => deserialize<_i73.RrhhEmployeeDocument>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.RrhhTimelineEvent>) {
      return (data as List)
              .map((e) => deserialize<_i74.RrhhTimelineEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i75.AuditLog>) {
      return (data as List).map((e) => deserialize<_i75.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i76.AppRole>) {
      return (data as List).map((e) => deserialize<_i76.AppRole>(e)).toList()
          as T;
    }
    if (t == List<_i77.AppPermission>) {
      return (data as List)
              .map((e) => deserialize<_i77.AppPermission>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i78.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i78.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.AppUser>) {
      return (data as List).map((e) => deserialize<_i79.AppUser>(e)).toList()
          as T;
    }
    try {
      return _i80.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i81.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.CrmAgendaMetricsResponse => 'CrmAgendaMetricsResponse',
      _i4.CrmCatalogItem => 'CrmCatalogItem',
      _i5.CrmCatalogItemScope => 'CrmCatalogItemScope',
      _i6.CrmContractBudgetItem => 'CrmContractBudgetItem',
      _i7.CrmCustomer => 'CrmCustomer',
      _i8.CrmCustomerBranch => 'CrmCustomerBranch',
      _i9.CrmCustomerContract => 'CrmCustomerContract',
      _i10.CrmCustomerDetailResponse => 'CrmCustomerDetailResponse',
      _i11.CrmCustomerMetricsResponse => 'CrmCustomerMetricsResponse',
      _i12.CrmLead => 'CrmLead',
      _i13.CrmLeadMetricsResponse => 'CrmLeadMetricsResponse',
      _i14.CrmOpportunity => 'CrmOpportunity',
      _i15.CrmPipelineMetricsResponse => 'CrmPipelineMetricsResponse',
      _i16.CrmQuoteItem => 'CrmQuoteItem',
      _i17.CrmSector => 'CrmSector',
      _i18.CrmServiceLine => 'CrmServiceLine',
      _i19.CrmTask => 'CrmTask',
      _i20.RrhhApplicant => 'RrhhApplicant',
      _i21.RrhhArea => 'RrhhArea',
      _i22.RrhhAssignment => 'RrhhAssignment',
      _i23.RrhhDashboardMetricsResponse => 'RrhhDashboardMetricsResponse',
      _i24.RrhhEmployee => 'RrhhEmployee',
      _i25.RrhhEmployeeBonus => 'RrhhEmployeeBonus',
      _i26.RrhhEmployeeContractData => 'RrhhEmployeeContractData',
      _i27.RrhhEmployeeDeduction => 'RrhhEmployeeDeduction',
      _i28.RrhhEmployeeDocument => 'RrhhEmployeeDocument',
      _i29.RrhhIncident => 'RrhhIncident',
      _i30.RrhhLeaveRequest => 'RrhhLeaveRequest',
      _i31.RrhhMovementHistory => 'RrhhMovementHistory',
      _i32.RrhhPosition => 'RrhhPosition',
      _i33.RrhhRecentMovementDto => 'RrhhRecentMovementDto',
      _i34.RrhhSchedule => 'RrhhSchedule',
      _i35.RrhhSpecialty => 'RrhhSpecialty',
      _i36.RrhhTermination => 'RrhhTermination',
      _i37.RrhhTimelineEvent => 'RrhhTimelineEvent',
      _i38.RrhhVacation => 'RrhhVacation',
      _i39.AppPermission => 'AppPermission',
      _i40.AppRole => 'AppRole',
      _i41.AppUser => 'AppUser',
      _i42.AuditLog => 'AuditLog',
      _i43.AuditLogPageResponse => 'AuditLogPageResponse',
      _i44.MfaChallenge => 'MfaChallenge',
      _i45.MfaChallengeResponse => 'MfaChallengeResponse',
      _i46.MfaVerifyResponse => 'MfaVerifyResponse',
      _i47.RolePermission => 'RolePermission',
      _i48.TrustedDevice => 'TrustedDevice',
      _i49.UserRole => 'UserRole',
      _i50.UserSession => 'UserSession',
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
      case _i4.CrmCatalogItem():
        return 'CrmCatalogItem';
      case _i5.CrmCatalogItemScope():
        return 'CrmCatalogItemScope';
      case _i6.CrmContractBudgetItem():
        return 'CrmContractBudgetItem';
      case _i7.CrmCustomer():
        return 'CrmCustomer';
      case _i8.CrmCustomerBranch():
        return 'CrmCustomerBranch';
      case _i9.CrmCustomerContract():
        return 'CrmCustomerContract';
      case _i10.CrmCustomerDetailResponse():
        return 'CrmCustomerDetailResponse';
      case _i11.CrmCustomerMetricsResponse():
        return 'CrmCustomerMetricsResponse';
      case _i12.CrmLead():
        return 'CrmLead';
      case _i13.CrmLeadMetricsResponse():
        return 'CrmLeadMetricsResponse';
      case _i14.CrmOpportunity():
        return 'CrmOpportunity';
      case _i15.CrmPipelineMetricsResponse():
        return 'CrmPipelineMetricsResponse';
      case _i16.CrmQuoteItem():
        return 'CrmQuoteItem';
      case _i17.CrmSector():
        return 'CrmSector';
      case _i18.CrmServiceLine():
        return 'CrmServiceLine';
      case _i19.CrmTask():
        return 'CrmTask';
      case _i20.RrhhApplicant():
        return 'RrhhApplicant';
      case _i21.RrhhArea():
        return 'RrhhArea';
      case _i22.RrhhAssignment():
        return 'RrhhAssignment';
      case _i23.RrhhDashboardMetricsResponse():
        return 'RrhhDashboardMetricsResponse';
      case _i24.RrhhEmployee():
        return 'RrhhEmployee';
      case _i25.RrhhEmployeeBonus():
        return 'RrhhEmployeeBonus';
      case _i26.RrhhEmployeeContractData():
        return 'RrhhEmployeeContractData';
      case _i27.RrhhEmployeeDeduction():
        return 'RrhhEmployeeDeduction';
      case _i28.RrhhEmployeeDocument():
        return 'RrhhEmployeeDocument';
      case _i29.RrhhIncident():
        return 'RrhhIncident';
      case _i30.RrhhLeaveRequest():
        return 'RrhhLeaveRequest';
      case _i31.RrhhMovementHistory():
        return 'RrhhMovementHistory';
      case _i32.RrhhPosition():
        return 'RrhhPosition';
      case _i33.RrhhRecentMovementDto():
        return 'RrhhRecentMovementDto';
      case _i34.RrhhSchedule():
        return 'RrhhSchedule';
      case _i35.RrhhSpecialty():
        return 'RrhhSpecialty';
      case _i36.RrhhTermination():
        return 'RrhhTermination';
      case _i37.RrhhTimelineEvent():
        return 'RrhhTimelineEvent';
      case _i38.RrhhVacation():
        return 'RrhhVacation';
      case _i39.AppPermission():
        return 'AppPermission';
      case _i40.AppRole():
        return 'AppRole';
      case _i41.AppUser():
        return 'AppUser';
      case _i42.AuditLog():
        return 'AuditLog';
      case _i43.AuditLogPageResponse():
        return 'AuditLogPageResponse';
      case _i44.MfaChallenge():
        return 'MfaChallenge';
      case _i45.MfaChallengeResponse():
        return 'MfaChallengeResponse';
      case _i46.MfaVerifyResponse():
        return 'MfaVerifyResponse';
      case _i47.RolePermission():
        return 'RolePermission';
      case _i48.TrustedDevice():
        return 'TrustedDevice';
      case _i49.UserRole():
        return 'UserRole';
      case _i50.UserSession():
        return 'UserSession';
    }
    className = _i80.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i81.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CrmCatalogItem') {
      return deserialize<_i4.CrmCatalogItem>(data['data']);
    }
    if (dataClassName == 'CrmCatalogItemScope') {
      return deserialize<_i5.CrmCatalogItemScope>(data['data']);
    }
    if (dataClassName == 'CrmContractBudgetItem') {
      return deserialize<_i6.CrmContractBudgetItem>(data['data']);
    }
    if (dataClassName == 'CrmCustomer') {
      return deserialize<_i7.CrmCustomer>(data['data']);
    }
    if (dataClassName == 'CrmCustomerBranch') {
      return deserialize<_i8.CrmCustomerBranch>(data['data']);
    }
    if (dataClassName == 'CrmCustomerContract') {
      return deserialize<_i9.CrmCustomerContract>(data['data']);
    }
    if (dataClassName == 'CrmCustomerDetailResponse') {
      return deserialize<_i10.CrmCustomerDetailResponse>(data['data']);
    }
    if (dataClassName == 'CrmCustomerMetricsResponse') {
      return deserialize<_i11.CrmCustomerMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmLead') {
      return deserialize<_i12.CrmLead>(data['data']);
    }
    if (dataClassName == 'CrmLeadMetricsResponse') {
      return deserialize<_i13.CrmLeadMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmOpportunity') {
      return deserialize<_i14.CrmOpportunity>(data['data']);
    }
    if (dataClassName == 'CrmPipelineMetricsResponse') {
      return deserialize<_i15.CrmPipelineMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmQuoteItem') {
      return deserialize<_i16.CrmQuoteItem>(data['data']);
    }
    if (dataClassName == 'CrmSector') {
      return deserialize<_i17.CrmSector>(data['data']);
    }
    if (dataClassName == 'CrmServiceLine') {
      return deserialize<_i18.CrmServiceLine>(data['data']);
    }
    if (dataClassName == 'CrmTask') {
      return deserialize<_i19.CrmTask>(data['data']);
    }
    if (dataClassName == 'RrhhApplicant') {
      return deserialize<_i20.RrhhApplicant>(data['data']);
    }
    if (dataClassName == 'RrhhArea') {
      return deserialize<_i21.RrhhArea>(data['data']);
    }
    if (dataClassName == 'RrhhAssignment') {
      return deserialize<_i22.RrhhAssignment>(data['data']);
    }
    if (dataClassName == 'RrhhDashboardMetricsResponse') {
      return deserialize<_i23.RrhhDashboardMetricsResponse>(data['data']);
    }
    if (dataClassName == 'RrhhEmployee') {
      return deserialize<_i24.RrhhEmployee>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeBonus') {
      return deserialize<_i25.RrhhEmployeeBonus>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeContractData') {
      return deserialize<_i26.RrhhEmployeeContractData>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeDeduction') {
      return deserialize<_i27.RrhhEmployeeDeduction>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeDocument') {
      return deserialize<_i28.RrhhEmployeeDocument>(data['data']);
    }
    if (dataClassName == 'RrhhIncident') {
      return deserialize<_i29.RrhhIncident>(data['data']);
    }
    if (dataClassName == 'RrhhLeaveRequest') {
      return deserialize<_i30.RrhhLeaveRequest>(data['data']);
    }
    if (dataClassName == 'RrhhMovementHistory') {
      return deserialize<_i31.RrhhMovementHistory>(data['data']);
    }
    if (dataClassName == 'RrhhPosition') {
      return deserialize<_i32.RrhhPosition>(data['data']);
    }
    if (dataClassName == 'RrhhRecentMovementDto') {
      return deserialize<_i33.RrhhRecentMovementDto>(data['data']);
    }
    if (dataClassName == 'RrhhSchedule') {
      return deserialize<_i34.RrhhSchedule>(data['data']);
    }
    if (dataClassName == 'RrhhSpecialty') {
      return deserialize<_i35.RrhhSpecialty>(data['data']);
    }
    if (dataClassName == 'RrhhTermination') {
      return deserialize<_i36.RrhhTermination>(data['data']);
    }
    if (dataClassName == 'RrhhTimelineEvent') {
      return deserialize<_i37.RrhhTimelineEvent>(data['data']);
    }
    if (dataClassName == 'RrhhVacation') {
      return deserialize<_i38.RrhhVacation>(data['data']);
    }
    if (dataClassName == 'AppPermission') {
      return deserialize<_i39.AppPermission>(data['data']);
    }
    if (dataClassName == 'AppRole') {
      return deserialize<_i40.AppRole>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i41.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i42.AuditLog>(data['data']);
    }
    if (dataClassName == 'AuditLogPageResponse') {
      return deserialize<_i43.AuditLogPageResponse>(data['data']);
    }
    if (dataClassName == 'MfaChallenge') {
      return deserialize<_i44.MfaChallenge>(data['data']);
    }
    if (dataClassName == 'MfaChallengeResponse') {
      return deserialize<_i45.MfaChallengeResponse>(data['data']);
    }
    if (dataClassName == 'MfaVerifyResponse') {
      return deserialize<_i46.MfaVerifyResponse>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i47.RolePermission>(data['data']);
    }
    if (dataClassName == 'TrustedDevice') {
      return deserialize<_i48.TrustedDevice>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i49.UserRole>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i50.UserSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i80.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i81.Protocol().deserializeByClassName(data);
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
      return _i80.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i81.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
