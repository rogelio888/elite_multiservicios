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
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../greetings/greeting_endpoint.dart' as _i4;
import '../modules/crm/endpoints/crm_agenda_endpoint.dart' as _i5;
import '../modules/crm/endpoints/crm_catalog_endpoint.dart' as _i6;
import '../modules/crm/endpoints/crm_customers_endpoint.dart' as _i7;
import '../modules/crm/endpoints/crm_leads_endpoint.dart' as _i8;
import '../modules/crm/endpoints/crm_pipeline_endpoint.dart' as _i9;
import '../modules/rrhh/endpoints/rrhh_applicant_endpoint.dart' as _i10;
import '../modules/rrhh/endpoints/rrhh_dashboard_endpoint.dart' as _i11;
import '../modules/rrhh/endpoints/rrhh_organization_endpoint.dart' as _i12;
import '../modules/rrhh/endpoints/rrhh_personnel_endpoint.dart' as _i13;
import '../modules/security/endpoints/audit_endpoint.dart' as _i14;
import '../modules/security/endpoints/mfa_endpoint.dart' as _i15;
import '../modules/security/endpoints/rbac_endpoint.dart' as _i16;
import '../modules/security/endpoints/session_management_endpoint.dart' as _i17;
import '../modules/security/endpoints/user_endpoint.dart' as _i18;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_task.dart'
    as _i19;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_sector.dart'
    as _i20;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_service_line.dart'
    as _i21;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_catalog_item.dart'
    as _i22;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_catalog_item_scope.dart'
    as _i23;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_customer.dart'
    as _i24;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_customer_branch.dart'
    as _i25;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_customer_contract.dart'
    as _i26;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_contract_budget_item.dart'
    as _i27;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_lead.dart'
    as _i28;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_opportunity.dart'
    as _i29;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_quote_item.dart'
    as _i30;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_applicant.dart'
    as _i31;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_area.dart'
    as _i32;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_position.dart'
    as _i33;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_specialty.dart'
    as _i34;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_employee.dart'
    as _i35;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_employee_document.dart'
    as _i36;
import 'package:elite_multiservicios_server/src/generated/modules/rrhh/models/rrhh_timeline_event.dart'
    as _i37;
import 'package:elite_multiservicios_server/src/generated/modules/security/models/app_role.dart'
    as _i38;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i39;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i40;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'crmAgenda': _i5.CrmAgendaEndpoint()
        ..initialize(
          server,
          'crmAgenda',
          null,
        ),
      'crmCatalog': _i6.CrmCatalogEndpoint()
        ..initialize(
          server,
          'crmCatalog',
          null,
        ),
      'crmCustomers': _i7.CrmCustomersEndpoint()
        ..initialize(
          server,
          'crmCustomers',
          null,
        ),
      'crmLeads': _i8.CrmLeadsEndpoint()
        ..initialize(
          server,
          'crmLeads',
          null,
        ),
      'crmPipeline': _i9.CrmPipelineEndpoint()
        ..initialize(
          server,
          'crmPipeline',
          null,
        ),
      'rrhhApplicant': _i10.RrhhApplicantEndpoint()
        ..initialize(
          server,
          'rrhhApplicant',
          null,
        ),
      'rrhhDashboard': _i11.RrhhDashboardEndpoint()
        ..initialize(
          server,
          'rrhhDashboard',
          null,
        ),
      'rrhhOrganization': _i12.RrhhOrganizationEndpoint()
        ..initialize(
          server,
          'rrhhOrganization',
          null,
        ),
      'rrhhPersonnel': _i13.RrhhPersonnelEndpoint()
        ..initialize(
          server,
          'rrhhPersonnel',
          null,
        ),
      'audit': _i14.AuditEndpoint()
        ..initialize(
          server,
          'audit',
          null,
        ),
      'mfa': _i15.MfaEndpoint()
        ..initialize(
          server,
          'mfa',
          null,
        ),
      'rbac': _i16.RbacEndpoint()
        ..initialize(
          server,
          'rbac',
          null,
        ),
      'sessionManagement': _i17.SessionManagementEndpoint()
        ..initialize(
          server,
          'sessionManagement',
          null,
        ),
      'user': _i18.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i4.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['crmAgenda'] = _i1.EndpointConnector(
      name: 'crmAgenda',
      endpoint: endpoints['crmAgenda']!,
      methodConnectors: {
        'listTasks': _i1.MethodConnector(
          name: 'listTasks',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'taskType': _i1.ParameterDescription(
              name: 'taskType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'customerId': _i1.ParameterDescription(
              name: 'customerId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'leadId': _i1.ParameterDescription(
              name: 'leadId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint).listTasks(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    search: params['search'],
                    status: params['status'],
                    taskType: params['taskType'],
                    priority: params['priority'],
                    customerId: params['customerId'],
                    opportunityId: params['opportunityId'],
                    leadId: params['leadId'],
                  ),
        ),
        'getTask': _i1.MethodConnector(
          name: 'getTask',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint).getTask(
                    session,
                    params['id'],
                  ),
        ),
        'getTasksForDate': _i1.MethodConnector(
          name: 'getTasksForDate',
          params: {
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .getTasksForDate(
                    session,
                    params['date'],
                  ),
        ),
        'getTodayTasks': _i1.MethodConnector(
          name: 'getTodayTasks',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .getTodayTasks(session),
        ),
        'getOverdueTasks': _i1.MethodConnector(
          name: 'getOverdueTasks',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .getOverdueTasks(session),
        ),
        'createTask': _i1.MethodConnector(
          name: 'createTask',
          params: {
            'task': _i1.ParameterDescription(
              name: 'task',
              type: _i1.getType<_i19.CrmTask>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint).createTask(
                    session,
                    params['task'],
                  ),
        ),
        'updateTask': _i1.MethodConnector(
          name: 'updateTask',
          params: {
            'task': _i1.ParameterDescription(
              name: 'task',
              type: _i1.getType<_i19.CrmTask>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint).updateTask(
                    session,
                    params['task'],
                  ),
        ),
        'completeTask': _i1.MethodConnector(
          name: 'completeTask',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .completeTask(
                    session,
                    params['id'],
                    notes: params['notes'],
                  ),
        ),
        'postponeTask': _i1.MethodConnector(
          name: 'postponeTask',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newDate': _i1.ParameterDescription(
              name: 'newDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'newTimeText': _i1.ParameterDescription(
              name: 'newTimeText',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .postponeTask(
                    session,
                    params['id'],
                    newDate: params['newDate'],
                    newTimeText: params['newTimeText'],
                    reason: params['reason'],
                  ),
        ),
        'deleteTask': _i1.MethodConnector(
          name: 'deleteTask',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint).deleteTask(
                    session,
                    params['id'],
                  ),
        ),
        'scheduleQualityCheck': _i1.MethodConnector(
          name: 'scheduleQualityCheck',
          params: {
            'clientName': _i1.ParameterDescription(
              name: 'clientName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contactPerson': _i1.ParameterDescription(
              name: 'contactPerson',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contractTitle': _i1.ParameterDescription(
              name: 'contractTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'customerId': _i1.ParameterDescription(
              name: 'customerId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'contractId': _i1.ParameterDescription(
              name: 'contractId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .scheduleQualityCheck(
                    session,
                    clientName: params['clientName'],
                    contactPerson: params['contactPerson'],
                    phone: params['phone'],
                    contractTitle: params['contractTitle'],
                    customerId: params['customerId'],
                    contractId: params['contractId'],
                  ),
        ),
        'scheduleRenewal': _i1.MethodConnector(
          name: 'scheduleRenewal',
          params: {
            'clientName': _i1.ParameterDescription(
              name: 'clientName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contactPerson': _i1.ParameterDescription(
              name: 'contactPerson',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contractTitle': _i1.ParameterDescription(
              name: 'contractTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'expiryDate': _i1.ParameterDescription(
              name: 'expiryDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'customerId': _i1.ParameterDescription(
              name: 'customerId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'contractId': _i1.ParameterDescription(
              name: 'contractId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .scheduleRenewal(
                    session,
                    clientName: params['clientName'],
                    contactPerson: params['contactPerson'],
                    phone: params['phone'],
                    contractTitle: params['contractTitle'],
                    expiryDate: params['expiryDate'],
                    customerId: params['customerId'],
                    contractId: params['contractId'],
                  ),
        ),
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmAgenda'] as _i5.CrmAgendaEndpoint)
                  .getMetrics(session),
        ),
      },
    );
    connectors['crmCatalog'] = _i1.EndpointConnector(
      name: 'crmCatalog',
      endpoint: endpoints['crmCatalog']!,
      methodConnectors: {
        'listSectors': _i1.MethodConnector(
          name: 'listSectors',
          params: {
            'includeInactive': _i1.ParameterDescription(
              name: 'includeInactive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .listSectors(
                    session,
                    includeInactive: params['includeInactive'],
                  ),
        ),
        'createSector': _i1.MethodConnector(
          name: 'createSector',
          params: {
            'sector': _i1.ParameterDescription(
              name: 'sector',
              type: _i1.getType<_i20.CrmSector>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .createSector(
                    session,
                    params['sector'],
                  ),
        ),
        'updateSector': _i1.MethodConnector(
          name: 'updateSector',
          params: {
            'sector': _i1.ParameterDescription(
              name: 'sector',
              type: _i1.getType<_i20.CrmSector>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .updateSector(
                    session,
                    params['sector'],
                  ),
        ),
        'deleteSector': _i1.MethodConnector(
          name: 'deleteSector',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .deleteSector(
                    session,
                    params['id'],
                  ),
        ),
        'listServiceLines': _i1.MethodConnector(
          name: 'listServiceLines',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'includeInactive': _i1.ParameterDescription(
              name: 'includeInactive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .listServiceLines(
                    session,
                    category: params['category'],
                    includeInactive: params['includeInactive'],
                  ),
        ),
        'createServiceLine': _i1.MethodConnector(
          name: 'createServiceLine',
          params: {
            'line': _i1.ParameterDescription(
              name: 'line',
              type: _i1.getType<_i21.CrmServiceLine>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .createServiceLine(
                    session,
                    params['line'],
                  ),
        ),
        'updateServiceLine': _i1.MethodConnector(
          name: 'updateServiceLine',
          params: {
            'line': _i1.ParameterDescription(
              name: 'line',
              type: _i1.getType<_i21.CrmServiceLine>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .updateServiceLine(
                    session,
                    params['line'],
                  ),
        ),
        'deleteServiceLine': _i1.MethodConnector(
          name: 'deleteServiceLine',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .deleteServiceLine(
                    session,
                    params['id'],
                  ),
        ),
        'listCatalogItems': _i1.MethodConnector(
          name: 'listCatalogItems',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sectorId': _i1.ParameterDescription(
              name: 'sectorId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'serviceLineId': _i1.ParameterDescription(
              name: 'serviceLineId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'activeOnly': _i1.ParameterDescription(
              name: 'activeOnly',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .listCatalogItems(
                    session,
                    category: params['category'],
                    sectorId: params['sectorId'],
                    serviceLineId: params['serviceLineId'],
                    activeOnly: params['activeOnly'],
                  ),
        ),
        'getCatalogItem': _i1.MethodConnector(
          name: 'getCatalogItem',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .getCatalogItem(
                    session,
                    params['id'],
                  ),
        ),
        'createCatalogItem': _i1.MethodConnector(
          name: 'createCatalogItem',
          params: {
            'item': _i1.ParameterDescription(
              name: 'item',
              type: _i1.getType<_i22.CrmCatalogItem>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .createCatalogItem(
                    session,
                    params['item'],
                  ),
        ),
        'updateCatalogItem': _i1.MethodConnector(
          name: 'updateCatalogItem',
          params: {
            'item': _i1.ParameterDescription(
              name: 'item',
              type: _i1.getType<_i22.CrmCatalogItem>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .updateCatalogItem(
                    session,
                    params['item'],
                  ),
        ),
        'deleteCatalogItem': _i1.MethodConnector(
          name: 'deleteCatalogItem',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .deleteCatalogItem(
                    session,
                    params['id'],
                  ),
        ),
        'listScopesForItem': _i1.MethodConnector(
          name: 'listScopesForItem',
          params: {
            'catalogItemId': _i1.ParameterDescription(
              name: 'catalogItemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .listScopesForItem(
                    session,
                    params['catalogItemId'],
                  ),
        ),
        'setCatalogItemScope': _i1.MethodConnector(
          name: 'setCatalogItemScope',
          params: {
            'scope': _i1.ParameterDescription(
              name: 'scope',
              type: _i1.getType<_i23.CrmCatalogItemScope>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCatalog'] as _i6.CrmCatalogEndpoint)
                  .setCatalogItemScope(
                    session,
                    params['scope'],
                  ),
        ),
      },
    );
    connectors['crmCustomers'] = _i1.EndpointConnector(
      name: 'crmCustomers',
      endpoint: endpoints['crmCustomers']!,
      methodConnectors: {
        'listCustomers': _i1.MethodConnector(
          name: 'listCustomers',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'segment': _i1.ParameterDescription(
              name: 'segment',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .listCustomers(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    search: params['search'],
                    segment: params['segment'],
                    status: params['status'],
                  ),
        ),
        'getCustomerDetail': _i1.MethodConnector(
          name: 'getCustomerDetail',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .getCustomerDetail(
                    session,
                    params['id'],
                  ),
        ),
        'getCustomer': _i1.MethodConnector(
          name: 'getCustomer',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .getCustomer(
                    session,
                    params['id'],
                  ),
        ),
        'createCustomer': _i1.MethodConnector(
          name: 'createCustomer',
          params: {
            'customer': _i1.ParameterDescription(
              name: 'customer',
              type: _i1.getType<_i24.CrmCustomer>(),
              nullable: false,
            ),
            'initialBranch': _i1.ParameterDescription(
              name: 'initialBranch',
              type: _i1.getType<_i25.CrmCustomerBranch?>(),
              nullable: true,
            ),
            'initialContract': _i1.ParameterDescription(
              name: 'initialContract',
              type: _i1.getType<_i26.CrmCustomerContract?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .createCustomer(
                    session,
                    params['customer'],
                    initialBranch: params['initialBranch'],
                    initialContract: params['initialContract'],
                  ),
        ),
        'updateCustomer': _i1.MethodConnector(
          name: 'updateCustomer',
          params: {
            'customer': _i1.ParameterDescription(
              name: 'customer',
              type: _i1.getType<_i24.CrmCustomer>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .updateCustomer(
                    session,
                    params['customer'],
                  ),
        ),
        'deleteCustomer': _i1.MethodConnector(
          name: 'deleteCustomer',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .deleteCustomer(
                    session,
                    params['id'],
                  ),
        ),
        'addBranch': _i1.MethodConnector(
          name: 'addBranch',
          params: {
            'branch': _i1.ParameterDescription(
              name: 'branch',
              type: _i1.getType<_i25.CrmCustomerBranch>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .addBranch(
                    session,
                    params['branch'],
                  ),
        ),
        'updateBranch': _i1.MethodConnector(
          name: 'updateBranch',
          params: {
            'branch': _i1.ParameterDescription(
              name: 'branch',
              type: _i1.getType<_i25.CrmCustomerBranch>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .updateBranch(
                    session,
                    params['branch'],
                  ),
        ),
        'deleteBranch': _i1.MethodConnector(
          name: 'deleteBranch',
          params: {
            'branchId': _i1.ParameterDescription(
              name: 'branchId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .deleteBranch(
                    session,
                    params['branchId'],
                  ),
        ),
        'addContract': _i1.MethodConnector(
          name: 'addContract',
          params: {
            'contract': _i1.ParameterDescription(
              name: 'contract',
              type: _i1.getType<_i26.CrmCustomerContract>(),
              nullable: false,
            ),
            'budgetItems': _i1.ParameterDescription(
              name: 'budgetItems',
              type: _i1.getType<List<_i27.CrmContractBudgetItem>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .addContract(
                    session,
                    params['contract'],
                    budgetItems: params['budgetItems'],
                  ),
        ),
        'updateContract': _i1.MethodConnector(
          name: 'updateContract',
          params: {
            'contract': _i1.ParameterDescription(
              name: 'contract',
              type: _i1.getType<_i26.CrmCustomerContract>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .updateContract(
                    session,
                    params['contract'],
                  ),
        ),
        'completeContract': _i1.MethodConnector(
          name: 'completeContract',
          params: {
            'contractId': _i1.ParameterDescription(
              name: 'contractId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'actualEndDate': _i1.ParameterDescription(
              name: 'actualEndDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'completionNotes': _i1.ParameterDescription(
              name: 'completionNotes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'satisfactionRating': _i1.ParameterDescription(
              name: 'satisfactionRating',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'completedBy': _i1.ParameterDescription(
              name: 'completedBy',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .completeContract(
                    session,
                    params['contractId'],
                    actualEndDate: params['actualEndDate'],
                    completionNotes: params['completionNotes'],
                    satisfactionRating: params['satisfactionRating'],
                    completedBy: params['completedBy'],
                  ),
        ),
        'renewContract': _i1.MethodConnector(
          name: 'renewContract',
          params: {
            'contractId': _i1.ParameterDescription(
              name: 'contractId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'additionalMonths': _i1.ParameterDescription(
              name: 'additionalMonths',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'adjustedMonthlyAmount': _i1.ParameterDescription(
              name: 'adjustedMonthlyAmount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .renewContract(
                    session,
                    params['contractId'],
                    additionalMonths: params['additionalMonths'],
                    adjustedMonthlyAmount: params['adjustedMonthlyAmount'],
                    notes: params['notes'],
                  ),
        ),
        'updateContractStatus': _i1.MethodConnector(
          name: 'updateContractStatus',
          params: {
            'contractId': _i1.ParameterDescription(
              name: 'contractId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newStatus': _i1.ParameterDescription(
              name: 'newStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .updateContractStatus(
                    session,
                    params['contractId'],
                    params['newStatus'],
                  ),
        ),
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmCustomers'] as _i7.CrmCustomersEndpoint)
                  .getMetrics(session),
        ),
      },
    );
    connectors['crmLeads'] = _i1.EndpointConnector(
      name: 'crmLeads',
      endpoint: endpoints['crmLeads']!,
      methodConnectors: {
        'listLeads': _i1.MethodConnector(
          name: 'listLeads',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sector': _i1.ParameterDescription(
              name: 'sector',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'temperature': _i1.ParameterDescription(
              name: 'temperature',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'advisor': _i1.ParameterDescription(
              name: 'advisor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'origin': _i1.ParameterDescription(
              name: 'origin',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'requestedService': _i1.ParameterDescription(
              name: 'requestedService',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).listLeads(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    search: params['search'],
                    sector: params['sector'],
                    status: params['status'],
                    temperature: params['temperature'],
                    advisor: params['advisor'],
                    origin: params['origin'],
                    requestedService: params['requestedService'],
                  ),
        ),
        'getLead': _i1.MethodConnector(
          name: 'getLead',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).getLead(
                    session,
                    params['id'],
                  ),
        ),
        'createLead': _i1.MethodConnector(
          name: 'createLead',
          params: {
            'lead': _i1.ParameterDescription(
              name: 'lead',
              type: _i1.getType<_i28.CrmLead>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).createLead(
                    session,
                    params['lead'],
                  ),
        ),
        'updateLead': _i1.MethodConnector(
          name: 'updateLead',
          params: {
            'lead': _i1.ParameterDescription(
              name: 'lead',
              type: _i1.getType<_i28.CrmLead>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).updateLead(
                    session,
                    params['lead'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).updateStatus(
                    session,
                    params['id'],
                    params['status'],
                  ),
        ),
        'updateTemperature': _i1.MethodConnector(
          name: 'updateTemperature',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'temperature': _i1.ParameterDescription(
              name: 'temperature',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint)
                  .updateTemperature(
                    session,
                    params['id'],
                    params['temperature'],
                  ),
        ),
        'markPromoted': _i1.MethodConnector(
          name: 'markPromoted',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).markPromoted(
                    session,
                    params['id'],
                    params['opportunityId'],
                  ),
        ),
        'deleteLead': _i1.MethodConnector(
          name: 'deleteLead',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint).deleteLead(
                    session,
                    params['id'],
                  ),
        ),
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmLeads'] as _i8.CrmLeadsEndpoint)
                  .getMetrics(session),
        ),
      },
    );
    connectors['crmPipeline'] = _i1.EndpointConnector(
      name: 'crmPipeline',
      endpoint: endpoints['crmPipeline']!,
      methodConnectors: {
        'listOpportunities': _i1.MethodConnector(
          name: 'listOpportunities',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'stage': _i1.ParameterDescription(
              name: 'stage',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'owner': _i1.ParameterDescription(
              name: 'owner',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'serviceType': _i1.ParameterDescription(
              name: 'serviceType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .listOpportunities(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    search: params['search'],
                    stage: params['stage'],
                    owner: params['owner'],
                    serviceType: params['serviceType'],
                  ),
        ),
        'getOpportunity': _i1.MethodConnector(
          name: 'getOpportunity',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .getOpportunity(
                    session,
                    params['id'],
                  ),
        ),
        'getQuoteItems': _i1.MethodConnector(
          name: 'getQuoteItems',
          params: {
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .getQuoteItems(
                    session,
                    params['opportunityId'],
                  ),
        ),
        'createOpportunity': _i1.MethodConnector(
          name: 'createOpportunity',
          params: {
            'opp': _i1.ParameterDescription(
              name: 'opp',
              type: _i1.getType<_i29.CrmOpportunity>(),
              nullable: false,
            ),
            'quoteItems': _i1.ParameterDescription(
              name: 'quoteItems',
              type: _i1.getType<List<_i30.CrmQuoteItem>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .createOpportunity(
                    session,
                    params['opp'],
                    quoteItems: params['quoteItems'],
                  ),
        ),
        'updateOpportunity': _i1.MethodConnector(
          name: 'updateOpportunity',
          params: {
            'opp': _i1.ParameterDescription(
              name: 'opp',
              type: _i1.getType<_i29.CrmOpportunity>(),
              nullable: false,
            ),
            'quoteItems': _i1.ParameterDescription(
              name: 'quoteItems',
              type: _i1.getType<List<_i30.CrmQuoteItem>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .updateOpportunity(
                    session,
                    params['opp'],
                    quoteItems: params['quoteItems'],
                  ),
        ),
        'updateStage': _i1.MethodConnector(
          name: 'updateStage',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newStage': _i1.ParameterDescription(
              name: 'newStage',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .updateStage(
                    session,
                    params['id'],
                    params['newStage'],
                  ),
        ),
        'promoteToCustomer': _i1.MethodConnector(
          name: 'promoteToCustomer',
          params: {
            'opportunityId': _i1.ParameterDescription(
              name: 'opportunityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .promoteToCustomer(
                    session,
                    params['opportunityId'],
                  ),
        ),
        'deleteOpportunity': _i1.MethodConnector(
          name: 'deleteOpportunity',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .deleteOpportunity(
                    session,
                    params['id'],
                  ),
        ),
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['crmPipeline'] as _i9.CrmPipelineEndpoint)
                  .getMetrics(session),
        ),
      },
    );
    connectors['rrhhApplicant'] = _i1.EndpointConnector(
      name: 'rrhhApplicant',
      endpoint: endpoints['rrhhApplicant']!,
      methodConnectors: {
        'listApplicants': _i1.MethodConnector(
          name: 'listApplicants',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'targetType': _i1.ParameterDescription(
              name: 'targetType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'specialtyId': _i1.ParameterDescription(
              name: 'specialtyId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .listApplicants(
                        session,
                        status: params['status'],
                        targetType: params['targetType'],
                        specialtyId: params['specialtyId'],
                        search: params['search'],
                        limit: params['limit'],
                        offset: params['offset'],
                        includeDeleted: params['includeDeleted'],
                      ),
        ),
        'getApplicantById': _i1.MethodConnector(
          name: 'getApplicantById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .getApplicantById(
                        session,
                        params['id'],
                        includeDeleted: params['includeDeleted'],
                      ),
        ),
        'createApplicant': _i1.MethodConnector(
          name: 'createApplicant',
          params: {
            'applicant': _i1.ParameterDescription(
              name: 'applicant',
              type: _i1.getType<_i31.RrhhApplicant>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .createApplicant(
                        session,
                        params['applicant'],
                      ),
        ),
        'updateApplicant': _i1.MethodConnector(
          name: 'updateApplicant',
          params: {
            'applicant': _i1.ParameterDescription(
              name: 'applicant',
              type: _i1.getType<_i31.RrhhApplicant>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .updateApplicant(
                        session,
                        params['applicant'],
                      ),
        ),
        'updateApplicantStatus': _i1.MethodConnector(
          name: 'updateApplicantStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newStatus': _i1.ParameterDescription(
              name: 'newStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'interviewNotes': _i1.ParameterDescription(
              name: 'interviewNotes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'discardReason': _i1.ParameterDescription(
              name: 'discardReason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .updateApplicantStatus(
                        session,
                        id: params['id'],
                        newStatus: params['newStatus'],
                        interviewNotes: params['interviewNotes'],
                        discardReason: params['discardReason'],
                      ),
        ),
        'deleteApplicant': _i1.MethodConnector(
          name: 'deleteApplicant',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .deleteApplicant(
                        session,
                        params['id'],
                      ),
        ),
        'seedInitialData': _i1.MethodConnector(
          name: 'seedInitialData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhApplicant'] as _i10.RrhhApplicantEndpoint)
                      .seedInitialData(session),
        ),
      },
    );
    connectors['rrhhDashboard'] = _i1.EndpointConnector(
      name: 'rrhhDashboard',
      endpoint: endpoints['rrhhDashboard']!,
      methodConnectors: {
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhDashboard'] as _i11.RrhhDashboardEndpoint)
                      .getMetrics(session),
        ),
        'getRecentMovements': _i1.MethodConnector(
          name: 'getRecentMovements',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhDashboard'] as _i11.RrhhDashboardEndpoint)
                      .getRecentMovements(
                        session,
                        limit: params['limit'],
                      ),
        ),
      },
    );
    connectors['rrhhOrganization'] = _i1.EndpointConnector(
      name: 'rrhhOrganization',
      endpoint: endpoints['rrhhOrganization']!,
      methodConnectors: {
        'listAreas': _i1.MethodConnector(
          name: 'listAreas',
          params: {
            'includeInactive': _i1.ParameterDescription(
              name: 'includeInactive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .listAreas(
                        session,
                        includeInactive: params['includeInactive'],
                        search: params['search'],
                      ),
        ),
        'getAreaById': _i1.MethodConnector(
          name: 'getAreaById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .getAreaById(
                        session,
                        params['id'],
                      ),
        ),
        'createArea': _i1.MethodConnector(
          name: 'createArea',
          params: {
            'area': _i1.ParameterDescription(
              name: 'area',
              type: _i1.getType<_i32.RrhhArea>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .createArea(
                        session,
                        params['area'],
                      ),
        ),
        'updateArea': _i1.MethodConnector(
          name: 'updateArea',
          params: {
            'area': _i1.ParameterDescription(
              name: 'area',
              type: _i1.getType<_i32.RrhhArea>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .updateArea(
                        session,
                        params['area'],
                      ),
        ),
        'deleteArea': _i1.MethodConnector(
          name: 'deleteArea',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .deleteArea(
                        session,
                        params['id'],
                      ),
        ),
        'listPositions': _i1.MethodConnector(
          name: 'listPositions',
          params: {
            'areaId': _i1.ParameterDescription(
              name: 'areaId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'workplaceType': _i1.ParameterDescription(
              name: 'workplaceType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'includeInactive': _i1.ParameterDescription(
              name: 'includeInactive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .listPositions(
                        session,
                        areaId: params['areaId'],
                        workplaceType: params['workplaceType'],
                        includeInactive: params['includeInactive'],
                        search: params['search'],
                      ),
        ),
        'getPositionById': _i1.MethodConnector(
          name: 'getPositionById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .getPositionById(
                        session,
                        params['id'],
                      ),
        ),
        'createPosition': _i1.MethodConnector(
          name: 'createPosition',
          params: {
            'position': _i1.ParameterDescription(
              name: 'position',
              type: _i1.getType<_i33.RrhhPosition>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .createPosition(
                        session,
                        params['position'],
                      ),
        ),
        'updatePosition': _i1.MethodConnector(
          name: 'updatePosition',
          params: {
            'position': _i1.ParameterDescription(
              name: 'position',
              type: _i1.getType<_i33.RrhhPosition>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .updatePosition(
                        session,
                        params['position'],
                      ),
        ),
        'deletePosition': _i1.MethodConnector(
          name: 'deletePosition',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .deletePosition(
                        session,
                        params['id'],
                      ),
        ),
        'listSpecialties': _i1.MethodConnector(
          name: 'listSpecialties',
          params: {
            'includeInactive': _i1.ParameterDescription(
              name: 'includeInactive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .listSpecialties(
                        session,
                        includeInactive: params['includeInactive'],
                        search: params['search'],
                      ),
        ),
        'getSpecialtyById': _i1.MethodConnector(
          name: 'getSpecialtyById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .getSpecialtyById(
                        session,
                        params['id'],
                      ),
        ),
        'createSpecialty': _i1.MethodConnector(
          name: 'createSpecialty',
          params: {
            'specialty': _i1.ParameterDescription(
              name: 'specialty',
              type: _i1.getType<_i34.RrhhSpecialty>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .createSpecialty(
                        session,
                        params['specialty'],
                      ),
        ),
        'updateSpecialty': _i1.MethodConnector(
          name: 'updateSpecialty',
          params: {
            'specialty': _i1.ParameterDescription(
              name: 'specialty',
              type: _i1.getType<_i34.RrhhSpecialty>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .updateSpecialty(
                        session,
                        params['specialty'],
                      ),
        ),
        'deleteSpecialty': _i1.MethodConnector(
          name: 'deleteSpecialty',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .deleteSpecialty(
                        session,
                        params['id'],
                      ),
        ),
        'seedInitialData': _i1.MethodConnector(
          name: 'seedInitialData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhOrganization']
                          as _i12.RrhhOrganizationEndpoint)
                      .seedInitialData(session),
        ),
      },
    );
    connectors['rrhhPersonnel'] = _i1.EndpointConnector(
      name: 'rrhhPersonnel',
      endpoint: endpoints['rrhhPersonnel']!,
      methodConnectors: {
        'listEmployees': _i1.MethodConnector(
          name: 'listEmployees',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'employeeType': _i1.ParameterDescription(
              name: 'employeeType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'availabilityStatus': _i1.ParameterDescription(
              name: 'availabilityStatus',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'areaId': _i1.ParameterDescription(
              name: 'areaId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .listEmployees(
                        session,
                        status: params['status'],
                        employeeType: params['employeeType'],
                        availabilityStatus: params['availabilityStatus'],
                        areaId: params['areaId'],
                        search: params['search'],
                        limit: params['limit'],
                        offset: params['offset'],
                        includeDeleted: params['includeDeleted'],
                      ),
        ),
        'getEmployeeById': _i1.MethodConnector(
          name: 'getEmployeeById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .getEmployeeById(
                        session,
                        params['id'],
                        includeDeleted: params['includeDeleted'],
                      ),
        ),
        'getEmployeeByCode': _i1.MethodConnector(
          name: 'getEmployeeByCode',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .getEmployeeByCode(
                        session,
                        params['code'],
                        includeDeleted: params['includeDeleted'],
                      ),
        ),
        'createEmployee': _i1.MethodConnector(
          name: 'createEmployee',
          params: {
            'employee': _i1.ParameterDescription(
              name: 'employee',
              type: _i1.getType<_i35.RrhhEmployee>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .createEmployee(
                        session,
                        params['employee'],
                      ),
        ),
        'updateEmployee': _i1.MethodConnector(
          name: 'updateEmployee',
          params: {
            'employee': _i1.ParameterDescription(
              name: 'employee',
              type: _i1.getType<_i35.RrhhEmployee>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .updateEmployee(
                        session,
                        params['employee'],
                      ),
        ),
        'hireApplicant': _i1.MethodConnector(
          name: 'hireApplicant',
          params: {
            'applicantId': _i1.ParameterDescription(
              name: 'applicantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'realStartDate': _i1.ParameterDescription(
              name: 'realStartDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'fiscalStartDate': _i1.ParameterDescription(
              name: 'fiscalStartDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'agreedSalary': _i1.ParameterDescription(
              name: 'agreedSalary',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'contractType': _i1.ParameterDescription(
              name: 'contractType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contractEndDate': _i1.ParameterDescription(
              name: 'contractEndDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'observations': _i1.ParameterDescription(
              name: 'observations',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'workplace': _i1.ParameterDescription(
              name: 'workplace',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'supervisor': _i1.ParameterDescription(
              name: 'supervisor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .hireApplicant(
                        session,
                        applicantId: params['applicantId'],
                        realStartDate: params['realStartDate'],
                        fiscalStartDate: params['fiscalStartDate'],
                        agreedSalary: params['agreedSalary'],
                        contractType: params['contractType'],
                        contractEndDate: params['contractEndDate'],
                        observations: params['observations'],
                        workplace: params['workplace'],
                        supervisor: params['supervisor'],
                      ),
        ),
        'updateAvailabilityStatus': _i1.MethodConnector(
          name: 'updateAvailabilityStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newAvailabilityStatus': _i1.ParameterDescription(
              name: 'newAvailabilityStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .updateAvailabilityStatus(
                        session,
                        id: params['id'],
                        newAvailabilityStatus: params['newAvailabilityStatus'],
                      ),
        ),
        'terminateEmployee': _i1.MethodConnector(
          name: 'terminateEmployee',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'exitDate': _i1.ParameterDescription(
              name: 'exitDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'exitReason': _i1.ParameterDescription(
              name: 'exitReason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'exitObservations': _i1.ParameterDescription(
              name: 'exitObservations',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .terminateEmployee(
                        session,
                        id: params['id'],
                        exitDate: params['exitDate'],
                        exitReason: params['exitReason'],
                        exitObservations: params['exitObservations'],
                      ),
        ),
        'deleteEmployee': _i1.MethodConnector(
          name: 'deleteEmployee',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .deleteEmployee(
                        session,
                        params['id'],
                      ),
        ),
        'listDocuments': _i1.MethodConnector(
          name: 'listDocuments',
          params: {
            'employeeId': _i1.ParameterDescription(
              name: 'employeeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .listDocuments(
                        session,
                        params['employeeId'],
                      ),
        ),
        'addDocument': _i1.MethodConnector(
          name: 'addDocument',
          params: {
            'document': _i1.ParameterDescription(
              name: 'document',
              type: _i1.getType<_i36.RrhhEmployeeDocument>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .addDocument(
                        session,
                        params['document'],
                      ),
        ),
        'deleteDocument': _i1.MethodConnector(
          name: 'deleteDocument',
          params: {
            'documentId': _i1.ParameterDescription(
              name: 'documentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .deleteDocument(
                        session,
                        params['documentId'],
                      ),
        ),
        'listTimelineEvents': _i1.MethodConnector(
          name: 'listTimelineEvents',
          params: {
            'employeeId': _i1.ParameterDescription(
              name: 'employeeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .listTimelineEvents(
                        session,
                        params['employeeId'],
                      ),
        ),
        'addTimelineEvent': _i1.MethodConnector(
          name: 'addTimelineEvent',
          params: {
            'event': _i1.ParameterDescription(
              name: 'event',
              type: _i1.getType<_i37.RrhhTimelineEvent>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .addTimelineEvent(
                        session,
                        params['event'],
                      ),
        ),
        'seedInitialData': _i1.MethodConnector(
          name: 'seedInitialData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rrhhPersonnel'] as _i13.RrhhPersonnelEndpoint)
                      .seedInitialData(session),
        ),
      },
    );
    connectors['audit'] = _i1.EndpointConnector(
      name: 'audit',
      endpoint: endpoints['audit']!,
      methodConnectors: {
        'listLogs': _i1.MethodConnector(
          name: 'listLogs',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['audit'] as _i14.AuditEndpoint).listLogs(
                session,
                limit: params['limit'],
                offset: params['offset'],
                userId: params['userId'],
                action: params['action'],
              ),
        ),
        'listLogsPaged': _i1.MethodConnector(
          name: 'listLogsPaged',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageSize': _i1.ParameterDescription(
              name: 'pageSize',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'result': _i1.ParameterDescription(
              name: 'result',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'fromDate': _i1.ParameterDescription(
              name: 'fromDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'toDate': _i1.ParameterDescription(
              name: 'toDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['audit'] as _i14.AuditEndpoint).listLogsPaged(
                    session,
                    page: params['page'],
                    pageSize: params['pageSize'],
                    action: params['action'],
                    result: params['result'],
                    userId: params['userId'],
                    fromDate: params['fromDate'],
                    toDate: params['toDate'],
                    search: params['search'],
                  ),
        ),
      },
    );
    connectors['mfa'] = _i1.EndpointConnector(
      name: 'mfa',
      endpoint: endpoints['mfa']!,
      methodConnectors: {
        'checkRequired': _i1.MethodConnector(
          name: 'checkRequired',
          params: {
            'rememberMe': _i1.ParameterDescription(
              name: 'rememberMe',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'trustedDeviceToken': _i1.ParameterDescription(
              name: 'trustedDeviceToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mfa'] as _i15.MfaEndpoint).checkRequired(
                session,
                rememberMe: params['rememberMe'],
                trustedDeviceToken: params['trustedDeviceToken'],
              ),
        ),
        'verifyMfa': _i1.MethodConnector(
          name: 'verifyMfa',
          params: {
            'challengeId': _i1.ParameterDescription(
              name: 'challengeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'rememberMe': _i1.ParameterDescription(
              name: 'rememberMe',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mfa'] as _i15.MfaEndpoint).verifyMfa(
                session,
                challengeId: params['challengeId'],
                code: params['code'],
                rememberMe: params['rememberMe'],
              ),
        ),
        'resendMfaCode': _i1.MethodConnector(
          name: 'resendMfaCode',
          params: {
            'challengeId': _i1.ParameterDescription(
              name: 'challengeId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mfa'] as _i15.MfaEndpoint).resendMfaCode(
                session,
                challengeId: params['challengeId'],
              ),
        ),
        'isSessionVerified': _i1.MethodConnector(
          name: 'isSessionVerified',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mfa'] as _i15.MfaEndpoint)
                  .isSessionVerified(session),
        ),
      },
    );
    connectors['rbac'] = _i1.EndpointConnector(
      name: 'rbac',
      endpoint: endpoints['rbac']!,
      methodConnectors: {
        'listRoles': _i1.MethodConnector(
          name: 'listRoles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i16.RbacEndpoint).listRoles(session),
        ),
        'listPermissions': _i1.MethodConnector(
          name: 'listPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint)
                  .listPermissions(session),
        ),
        'assignRoleToUser': _i1.MethodConnector(
          name: 'assignRoleToUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i16.RbacEndpoint).assignRoleToUser(
                    session,
                    userId: params['userId'],
                    roleId: params['roleId'],
                  ),
        ),
        'removeRoleFromUser': _i1.MethodConnector(
          name: 'removeRoleFromUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i16.RbacEndpoint).removeRoleFromUser(
                    session,
                    userId: params['userId'],
                    roleId: params['roleId'],
                  ),
        ),
        'assignPermissionToRole': _i1.MethodConnector(
          name: 'assignPermissionToRole',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionId': _i1.ParameterDescription(
              name: 'permissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint)
                  .assignPermissionToRole(
                    session,
                    roleId: params['roleId'],
                    permissionId: params['permissionId'],
                  ),
        ),
        'getUserEffectivePermissions': _i1.MethodConnector(
          name: 'getUserEffectivePermissions',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint)
                  .getUserEffectivePermissions(
                    session,
                    params['userId'],
                  ),
        ),
        'createRole': _i1.MethodConnector(
          name: 'createRole',
          params: {
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i38.AppRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint).createRole(
                session,
                params['role'],
              ),
        ),
        'updateRole': _i1.MethodConnector(
          name: 'updateRole',
          params: {
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i38.AppRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint).updateRole(
                session,
                params['role'],
              ),
        ),
        'deleteRole': _i1.MethodConnector(
          name: 'deleteRole',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i16.RbacEndpoint).deleteRole(
                session,
                params['roleId'],
              ),
        ),
        'getRolePermissions': _i1.MethodConnector(
          name: 'getRolePermissions',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i16.RbacEndpoint).getRolePermissions(
                    session,
                    params['roleId'],
                  ),
        ),
        'syncRolePermissions': _i1.MethodConnector(
          name: 'syncRolePermissions',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionIds': _i1.ParameterDescription(
              name: 'permissionIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rbac'] as _i16.RbacEndpoint).syncRolePermissions(
                    session,
                    roleId: params['roleId'],
                    permissionIds: params['permissionIds'],
                  ),
        ),
      },
    );
    connectors['sessionManagement'] = _i1.EndpointConnector(
      name: 'sessionManagement',
      endpoint: endpoints['sessionManagement']!,
      methodConnectors: {
        'registerSession': _i1.MethodConnector(
          name: 'registerSession',
          params: {
            'sessionTokenHash': _i1.ParameterDescription(
              name: 'sessionTokenHash',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'expiresAt': _i1.ParameterDescription(
              name: 'expiresAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'mfaVerified': _i1.ParameterDescription(
              name: 'mfaVerified',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i17.SessionManagementEndpoint)
                      .registerSession(
                        session,
                        sessionTokenHash: params['sessionTokenHash'],
                        expiresAt: params['expiresAt'],
                        mfaVerified: params['mfaVerified'],
                      ),
        ),
        'listUserSessions': _i1.MethodConnector(
          name: 'listUserSessions',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i17.SessionManagementEndpoint)
                      .listUserSessions(
                        session,
                        params['userId'],
                      ),
        ),
        'revokeSession': _i1.MethodConnector(
          name: 'revokeSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i17.SessionManagementEndpoint)
                      .revokeSession(
                        session,
                        params['sessionId'],
                      ),
        ),
        'logout': _i1.MethodConnector(
          name: 'logout',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i17.SessionManagementEndpoint)
                      .logout(session),
        ),
        'markMfaVerified': _i1.MethodConnector(
          name: 'markMfaVerified',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sessionManagement']
                          as _i17.SessionManagementEndpoint)
                      .markMfaVerified(session),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'includeDeleted': _i1.ParameterDescription(
              name: 'includeDeleted',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).listUsers(
                session,
                limit: params['limit'],
                offset: params['offset'],
                includeDeleted: params['includeDeleted'],
              ),
        ),
        'getUser': _i1.MethodConnector(
          name: 'getUser',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).getUser(
                session,
                params['id'],
              ),
        ),
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'roleIds': _i1.ParameterDescription(
              name: 'roleIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).createUser(
                session,
                email: params['email'],
                fullName: params['fullName'],
                roleIds: params['roleIds'],
              ),
        ),
        'updateUser': _i1.MethodConnector(
          name: 'updateUser',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).updateUser(
                session,
                id: params['id'],
                fullName: params['fullName'],
              ),
        ),
        'setUserActive': _i1.MethodConnector(
          name: 'setUserActive',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).setUserActive(
                session,
                id: params['id'],
                isActive: params['isActive'],
              ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).deleteUser(
                session,
                params['id'],
              ),
        ),
        'getCurrentUser': _i1.MethodConnector(
          name: 'getCurrentUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint)
                  .getCurrentUser(session),
        ),
        'changePassword': _i1.MethodConnector(
          name: 'changePassword',
          params: {
            'currentPassword': _i1.ParameterDescription(
              name: 'currentPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i18.UserEndpoint).changePassword(
                    session,
                    currentPassword: params['currentPassword'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i39.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i40.Endpoints()
      ..initializeEndpoints(server);
  }
}
