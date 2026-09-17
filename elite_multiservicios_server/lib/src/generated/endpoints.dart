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
import '../modules/crm/endpoints/crm_leads_endpoint.dart' as _i5;
import '../modules/security/endpoints/audit_endpoint.dart' as _i6;
import '../modules/security/endpoints/mfa_endpoint.dart' as _i7;
import '../modules/security/endpoints/rbac_endpoint.dart' as _i8;
import '../modules/security/endpoints/session_management_endpoint.dart' as _i9;
import '../modules/security/endpoints/system_metrics_endpoint.dart' as _i10;
import '../modules/security/endpoints/user_endpoint.dart' as _i11;
import 'package:elite_multiservicios_server/src/generated/modules/crm/models/crm_lead.dart'
    as _i12;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i13;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i14;

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
      'crmLeads': _i5.CrmLeadsEndpoint()
        ..initialize(
          server,
          'crmLeads',
          null,
        ),
      'audit': _i6.AuditEndpoint()
        ..initialize(
          server,
          'audit',
          null,
        ),
      'mfa': _i7.MfaEndpoint()
        ..initialize(
          server,
          'mfa',
          null,
        ),
      'rbac': _i8.RbacEndpoint()
        ..initialize(
          server,
          'rbac',
          null,
        ),
      'sessionManagement': _i9.SessionManagementEndpoint()
        ..initialize(
          server,
          'sessionManagement',
          null,
        ),
      'systemMetrics': _i10.SystemMetricsEndpoint()
        ..initialize(
          server,
          'systemMetrics',
          null,
        ),
      'user': _i11.UserEndpoint()
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).listLeads(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    search: params['search'],
                    sector: params['sector'],
                    status: params['status'],
                    temperature: params['temperature'],
                    advisor: params['advisor'],
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
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).getLead(
                    session,
                    params['id'],
                  ),
        ),
        'createLead': _i1.MethodConnector(
          name: 'createLead',
          params: {
            'lead': _i1.ParameterDescription(
              name: 'lead',
              type: _i1.getType<_i12.CrmLead>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).createLead(
                    session,
                    params['lead'],
                  ),
        ),
        'updateLead': _i1.MethodConnector(
          name: 'updateLead',
          params: {
            'lead': _i1.ParameterDescription(
              name: 'lead',
              type: _i1.getType<_i12.CrmLead>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).updateLead(
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
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).updateStatus(
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
              ) async => (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint)
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
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).markPromoted(
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
                  (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint).deleteLead(
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
              ) async => (endpoints['crmLeads'] as _i5.CrmLeadsEndpoint)
                  .getMetrics(session),
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
              ) async => (endpoints['audit'] as _i6.AuditEndpoint).listLogs(
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
                  (endpoints['audit'] as _i6.AuditEndpoint).listLogsPaged(
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
              ) async => (endpoints['mfa'] as _i7.MfaEndpoint).checkRequired(
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
              ) async => (endpoints['mfa'] as _i7.MfaEndpoint).verifyMfa(
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
              ) async => (endpoints['mfa'] as _i7.MfaEndpoint).resendMfaCode(
                session,
                challengeId: params['challengeId'],
              ),
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
                  (endpoints['rbac'] as _i8.RbacEndpoint).listRoles(session),
        ),
        'listPermissions': _i1.MethodConnector(
          name: 'listPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rbac'] as _i8.RbacEndpoint)
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
                  (endpoints['rbac'] as _i8.RbacEndpoint).assignRoleToUser(
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
                  (endpoints['rbac'] as _i8.RbacEndpoint).removeRoleFromUser(
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
              ) async => (endpoints['rbac'] as _i8.RbacEndpoint)
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
              ) async => (endpoints['rbac'] as _i8.RbacEndpoint)
                  .getUserEffectivePermissions(
                    session,
                    params['userId'],
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
                          as _i9.SessionManagementEndpoint)
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
                          as _i9.SessionManagementEndpoint)
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
                          as _i9.SessionManagementEndpoint)
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
                          as _i9.SessionManagementEndpoint)
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
                          as _i9.SessionManagementEndpoint)
                      .markMfaVerified(session),
        ),
      },
    );
    connectors['systemMetrics'] = _i1.EndpointConnector(
      name: 'systemMetrics',
      endpoint: endpoints['systemMetrics']!,
      methodConnectors: {
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['systemMetrics'] as _i10.SystemMetricsEndpoint)
                      .getMetrics(session),
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).listUsers(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).getUser(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).createUser(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).updateUser(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).setUserActive(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint).deleteUser(
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
              ) async => (endpoints['user'] as _i11.UserEndpoint)
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
                  (endpoints['user'] as _i11.UserEndpoint).changePassword(
                    session,
                    currentPassword: params['currentPassword'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i13.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i14.Endpoints()
      ..initializeEndpoints(server);
  }
}
