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

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:elite_multiservicios_client/src/protocol/greetings/greeting.dart'
    as _i5;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_task.dart'
    as _i6;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_agenda_metrics_response.dart'
    as _i7;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer.dart'
    as _i8;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_detail_response.dart'
    as _i9;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_branch.dart'
    as _i10;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_contract.dart'
    as _i11;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_contract_budget_item.dart'
    as _i12;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_metrics_response.dart'
    as _i13;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i14;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead_metrics_response.dart'
    as _i15;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_opportunity.dart'
    as _i16;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_quote_item.dart'
    as _i17;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_pipeline_metrics_response.dart'
    as _i18;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i19;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log_page_response.dart'
    as _i20;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_challenge_response.dart'
    as _i21;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_verify_response.dart'
    as _i22;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i23;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i24;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_role.dart'
    as _i25;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/role_permission.dart'
    as _i26;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i27;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/server_metrics_response.dart'
    as _i28;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i29;
import 'protocol.dart' as _i30;

/// Endpoint de autenticación mediante correo y contraseña.
/// Extiende [EmailIdpBaseEndpoint] para incorporar auditoría de login fallido
/// y bloqueo de cuentas por intentos excesivos (soft lock 15 min, hard lock 24 h).
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Endpoint RPC para la Agenda Comercial, compromisos y tareas de seguimiento.
/// {@category Endpoint}
class EndpointCrmAgenda extends _i2.EndpointRef {
  EndpointCrmAgenda(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmAgenda';

  /// Lista las tareas con filtros opcionales.
  _i3.Future<List<_i6.CrmTask>> listTasks({
    required int limit,
    required int offset,
    String? search,
    String? status,
    String? taskType,
    String? priority,
    int? customerId,
    int? opportunityId,
    int? leadId,
  }) => caller.callServerEndpoint<List<_i6.CrmTask>>(
    'crmAgenda',
    'listTasks',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'status': status,
      'taskType': taskType,
      'priority': priority,
      'customerId': customerId,
      'opportunityId': opportunityId,
      'leadId': leadId,
    },
  );

  /// Obtiene una tarea por su ID.
  _i3.Future<_i6.CrmTask?> getTask(int id) =>
      caller.callServerEndpoint<_i6.CrmTask?>(
        'crmAgenda',
        'getTask',
        {'id': id},
      );

  /// Obtiene las tareas programadas para una fecha específica.
  _i3.Future<List<_i6.CrmTask>> getTasksForDate(DateTime date) =>
      caller.callServerEndpoint<List<_i6.CrmTask>>(
        'crmAgenda',
        'getTasksForDate',
        {'date': date},
      );

  /// Obtiene las tareas correspondientes al día de hoy.
  _i3.Future<List<_i6.CrmTask>> getTodayTasks() =>
      caller.callServerEndpoint<List<_i6.CrmTask>>(
        'crmAgenda',
        'getTodayTasks',
        {},
      );

  /// Obtiene las tareas vencidas.
  _i3.Future<List<_i6.CrmTask>> getOverdueTasks() =>
      caller.callServerEndpoint<List<_i6.CrmTask>>(
        'crmAgenda',
        'getOverdueTasks',
        {},
      );

  /// Crea una nueva tarea en la agenda.
  _i3.Future<_i6.CrmTask> createTask(_i6.CrmTask task) =>
      caller.callServerEndpoint<_i6.CrmTask>(
        'crmAgenda',
        'createTask',
        {'task': task},
      );

  /// Actualiza una tarea existente.
  _i3.Future<_i6.CrmTask> updateTask(_i6.CrmTask task) =>
      caller.callServerEndpoint<_i6.CrmTask>(
        'crmAgenda',
        'updateTask',
        {'task': task},
      );

  /// Marca una tarea como completada.
  _i3.Future<_i6.CrmTask?> completeTask(
    int id, {
    String? notes,
  }) => caller.callServerEndpoint<_i6.CrmTask?>(
    'crmAgenda',
    'completeTask',
    {
      'id': id,
      'notes': notes,
    },
  );

  /// Pospone una tarea.
  _i3.Future<_i6.CrmTask?> postponeTask(
    int id, {
    required DateTime newDate,
    required String newTimeText,
    String? reason,
  }) => caller.callServerEndpoint<_i6.CrmTask?>(
    'crmAgenda',
    'postponeTask',
    {
      'id': id,
      'newDate': newDate,
      'newTimeText': newTimeText,
      'reason': reason,
    },
  );

  /// Elimina lógicamente una tarea.
  _i3.Future<bool> deleteTask(int id) => caller.callServerEndpoint<bool>(
    'crmAgenda',
    'deleteTask',
    {'id': id},
  );

  /// Programa una tarea de control de calidad tras finalizar obra.
  _i3.Future<_i6.CrmTask> scheduleQualityCheck({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    int? customerId,
    int? contractId,
  }) => caller.callServerEndpoint<_i6.CrmTask>(
    'crmAgenda',
    'scheduleQualityCheck',
    {
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'contractTitle': contractTitle,
      'customerId': customerId,
      'contractId': contractId,
    },
  );

  /// Programa una alerta comercial de renovación de contrato.
  _i3.Future<_i6.CrmTask> scheduleRenewal({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    required DateTime expiryDate,
    int? customerId,
    int? contractId,
  }) => caller.callServerEndpoint<_i6.CrmTask>(
    'crmAgenda',
    'scheduleRenewal',
    {
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'contractTitle': contractTitle,
      'expiryDate': expiryDate,
      'customerId': customerId,
      'contractId': contractId,
    },
  );

  /// Obtiene las métricas agregadas de la agenda.
  _i3.Future<_i7.CrmAgendaMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i7.CrmAgendaMetricsResponse>(
        'crmAgenda',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para el catálogo maestro de Clientes 360°, Sedes Operativas y Contratos.
/// {@category Endpoint}
class EndpointCrmCustomers extends _i2.EndpointRef {
  EndpointCrmCustomers(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmCustomers';

  /// Lista los clientes activos con filtros avanzados.
  _i3.Future<List<_i8.CrmCustomer>> listCustomers({
    required int limit,
    required int offset,
    String? search,
    String? segment,
    String? status,
  }) => caller.callServerEndpoint<List<_i8.CrmCustomer>>(
    'crmCustomers',
    'listCustomers',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'segment': segment,
      'status': status,
    },
  );

  /// Obtiene la ficha 360° detallada e hidratada de un cliente.
  _i3.Future<_i9.CrmCustomerDetailResponse?> getCustomerDetail(int id) =>
      caller.callServerEndpoint<_i9.CrmCustomerDetailResponse?>(
        'crmCustomers',
        'getCustomerDetail',
        {'id': id},
      );

  /// Obtiene los datos generales de un cliente por su ID.
  _i3.Future<_i8.CrmCustomer?> getCustomer(int id) =>
      caller.callServerEndpoint<_i8.CrmCustomer?>(
        'crmCustomers',
        'getCustomer',
        {'id': id},
      );

  /// Registra un nuevo Cliente 360°.
  _i3.Future<_i8.CrmCustomer> createCustomer(
    _i8.CrmCustomer customer, {
    _i10.CrmCustomerBranch? initialBranch,
    _i11.CrmCustomerContract? initialContract,
  }) => caller.callServerEndpoint<_i8.CrmCustomer>(
    'crmCustomers',
    'createCustomer',
    {
      'customer': customer,
      'initialBranch': initialBranch,
      'initialContract': initialContract,
    },
  );

  /// Actualiza los datos generales de un cliente.
  _i3.Future<_i8.CrmCustomer> updateCustomer(_i8.CrmCustomer customer) =>
      caller.callServerEndpoint<_i8.CrmCustomer>(
        'crmCustomers',
        'updateCustomer',
        {'customer': customer},
      );

  /// Elimina lógicamente un cliente y sus dependencias.
  _i3.Future<bool> deleteCustomer(int id) => caller.callServerEndpoint<bool>(
    'crmCustomers',
    'deleteCustomer',
    {'id': id},
  );

  /// Agrega una sede operativa a un cliente.
  _i3.Future<_i10.CrmCustomerBranch> addBranch(_i10.CrmCustomerBranch branch) =>
      caller.callServerEndpoint<_i10.CrmCustomerBranch>(
        'crmCustomers',
        'addBranch',
        {'branch': branch},
      );

  /// Actualiza una sede operativa existente.
  _i3.Future<_i10.CrmCustomerBranch> updateBranch(
    _i10.CrmCustomerBranch branch,
  ) => caller.callServerEndpoint<_i10.CrmCustomerBranch>(
    'crmCustomers',
    'updateBranch',
    {'branch': branch},
  );

  /// Elimina lógicamente una sede operativa.
  _i3.Future<bool> deleteBranch(int branchId) =>
      caller.callServerEndpoint<bool>(
        'crmCustomers',
        'deleteBranch',
        {'branchId': branchId},
      );

  /// Registra un contrato con partidas de cotización.
  _i3.Future<_i11.CrmCustomerContract> addContract(
    _i11.CrmCustomerContract contract, {
    List<_i12.CrmContractBudgetItem>? budgetItems,
  }) => caller.callServerEndpoint<_i11.CrmCustomerContract>(
    'crmCustomers',
    'addContract',
    {
      'contract': contract,
      'budgetItems': budgetItems,
    },
  );

  /// Actualiza un contrato existente.
  _i3.Future<_i11.CrmCustomerContract> updateContract(
    _i11.CrmCustomerContract contract,
  ) => caller.callServerEndpoint<_i11.CrmCustomerContract>(
    'crmCustomers',
    'updateContract',
    {'contract': contract},
  );

  /// Conclusión formal de contrato/obra con calificación de satisfacción.
  _i3.Future<_i11.CrmCustomerContract?> completeContract(
    int contractId, {
    required DateTime actualEndDate,
    String? completionNotes,
    required int satisfactionRating,
    String? completedBy,
  }) => caller.callServerEndpoint<_i11.CrmCustomerContract?>(
    'crmCustomers',
    'completeContract',
    {
      'contractId': contractId,
      'actualEndDate': actualEndDate,
      'completionNotes': completionNotes,
      'satisfactionRating': satisfactionRating,
      'completedBy': completedBy,
    },
  );

  /// Renovación directa de un contrato recurrente (+6 / +12 meses).
  _i3.Future<_i11.CrmCustomerContract?> renewContract(
    int contractId, {
    required int additionalMonths,
    double? adjustedMonthlyAmount,
    String? notes,
  }) => caller.callServerEndpoint<_i11.CrmCustomerContract?>(
    'crmCustomers',
    'renewContract',
    {
      'contractId': contractId,
      'additionalMonths': additionalMonths,
      'adjustedMonthlyAmount': adjustedMonthlyAmount,
      'notes': notes,
    },
  );

  /// Actualiza el estado puntual de un contrato (Pausar / Reactivar).
  _i3.Future<_i11.CrmCustomerContract?> updateContractStatus(
    int contractId,
    String newStatus,
  ) => caller.callServerEndpoint<_i11.CrmCustomerContract?>(
    'crmCustomers',
    'updateContractStatus',
    {
      'contractId': contractId,
      'newStatus': newStatus,
    },
  );

  /// Obtiene el consolidado de métricas en tiempo real.
  _i3.Future<_i13.CrmCustomerMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i13.CrmCustomerMetricsResponse>(
        'crmCustomers',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para la gestión integral de Prospectos (CRM Leads) en frío y Maps.
/// {@category Endpoint}
class EndpointCrmLeads extends _i2.EndpointRef {
  EndpointCrmLeads(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmLeads';

  /// Lista los prospectos con filtros opcionales de búsqueda, rubro, estado y temperatura.
  _i3.Future<List<_i14.CrmLead>> listLeads({
    required int limit,
    required int offset,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
  }) => caller.callServerEndpoint<List<_i14.CrmLead>>(
    'crmLeads',
    'listLeads',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'sector': sector,
      'status': status,
      'temperature': temperature,
      'advisor': advisor,
    },
  );

  /// Obtiene el detalle de un prospecto por su ID.
  _i3.Future<_i14.CrmLead?> getLead(int id) =>
      caller.callServerEndpoint<_i14.CrmLead?>(
        'crmLeads',
        'getLead',
        {'id': id},
      );

  /// Registra un nuevo prospecto comercial en el sistema.
  _i3.Future<_i14.CrmLead> createLead(_i14.CrmLead lead) =>
      caller.callServerEndpoint<_i14.CrmLead>(
        'crmLeads',
        'createLead',
        {'lead': lead},
      );

  /// Actualiza los datos generales de un prospecto.
  _i3.Future<_i14.CrmLead> updateLead(_i14.CrmLead lead) =>
      caller.callServerEndpoint<_i14.CrmLead>(
        'crmLeads',
        'updateLead',
        {'lead': lead},
      );

  /// Actualiza el estado comercial de un prospecto en el embudo inicial.
  _i3.Future<_i14.CrmLead?> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i14.CrmLead?>(
    'crmLeads',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  _i3.Future<_i14.CrmLead?> updateTemperature(
    int id,
    String temperature,
  ) => caller.callServerEndpoint<_i14.CrmLead?>(
    'crmLeads',
    'updateTemperature',
    {
      'id': id,
      'temperature': temperature,
    },
  );

  /// Marca el prospecto como promovido formalmente a una Oportunidad en el Pipeline.
  _i3.Future<_i14.CrmLead?> markPromoted(
    int id,
    int? opportunityId,
  ) => caller.callServerEndpoint<_i14.CrmLead?>(
    'crmLeads',
    'markPromoted',
    {
      'id': id,
      'opportunityId': opportunityId,
    },
  );

  /// Elimina lógicamente (Soft Delete) un prospecto.
  _i3.Future<bool> deleteLead(int id) => caller.callServerEndpoint<bool>(
    'crmLeads',
    'deleteLead',
    {'id': id},
  );

  /// Consulta el consolidado de métricas de prospección en tiempo real.
  _i3.Future<_i15.CrmLeadMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i15.CrmLeadMetricsResponse>(
        'crmLeads',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para el embudo de ventas, compuertas y Pipeline comercial.
/// {@category Endpoint}
class EndpointCrmPipeline extends _i2.EndpointRef {
  EndpointCrmPipeline(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmPipeline';

  /// Lista las oportunidades con filtros opcionales.
  _i3.Future<List<_i16.CrmOpportunity>> listOpportunities({
    required int limit,
    required int offset,
    String? search,
    String? stage,
    String? owner,
    String? serviceType,
  }) => caller.callServerEndpoint<List<_i16.CrmOpportunity>>(
    'crmPipeline',
    'listOpportunities',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'stage': stage,
      'owner': owner,
      'serviceType': serviceType,
    },
  );

  /// Obtiene el detalle de una oportunidad por ID.
  _i3.Future<_i16.CrmOpportunity?> getOpportunity(int id) =>
      caller.callServerEndpoint<_i16.CrmOpportunity?>(
        'crmPipeline',
        'getOpportunity',
        {'id': id},
      );

  /// Obtiene las partidas de cotización asociadas a una oportunidad.
  _i3.Future<List<_i17.CrmQuoteItem>> getQuoteItems(int opportunityId) =>
      caller.callServerEndpoint<List<_i17.CrmQuoteItem>>(
        'crmPipeline',
        'getQuoteItems',
        {'opportunityId': opportunityId},
      );

  /// Crea una nueva oportunidad comercial.
  _i3.Future<_i16.CrmOpportunity> createOpportunity(
    _i16.CrmOpportunity opp, {
    List<_i17.CrmQuoteItem>? quoteItems,
  }) => caller.callServerEndpoint<_i16.CrmOpportunity>(
    'crmPipeline',
    'createOpportunity',
    {
      'opp': opp,
      'quoteItems': quoteItems,
    },
  );

  /// Actualiza una oportunidad comercial.
  _i3.Future<_i16.CrmOpportunity> updateOpportunity(
    _i16.CrmOpportunity opp, {
    List<_i17.CrmQuoteItem>? quoteItems,
  }) => caller.callServerEndpoint<_i16.CrmOpportunity>(
    'crmPipeline',
    'updateOpportunity',
    {
      'opp': opp,
      'quoteItems': quoteItems,
    },
  );

  /// Actualiza la etapa o compuerta comercial de una oportunidad.
  _i3.Future<_i16.CrmOpportunity?> updateStage(
    int id,
    String newStage,
  ) => caller.callServerEndpoint<_i16.CrmOpportunity?>(
    'crmPipeline',
    'updateStage',
    {
      'id': id,
      'newStage': newStage,
    },
  );

  /// Traspaso formal de oportunidad Ganada a Cliente 360°.
  _i3.Future<_i9.CrmCustomerDetailResponse?> promoteToCustomer(
    int opportunityId,
  ) => caller.callServerEndpoint<_i9.CrmCustomerDetailResponse?>(
    'crmPipeline',
    'promoteToCustomer',
    {'opportunityId': opportunityId},
  );

  /// Elimina lógicamente una oportunidad.
  _i3.Future<bool> deleteOpportunity(int id) => caller.callServerEndpoint<bool>(
    'crmPipeline',
    'deleteOpportunity',
    {'id': id},
  );

  /// Obtiene las métricas agregadas del pipeline.
  _i3.Future<_i18.CrmPipelineMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i18.CrmPipelineMetricsResponse>(
        'crmPipeline',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para consulta de la bitácora de eventos y auditoría del sistema.
/// {@category Endpoint}
class EndpointAudit extends _i2.EndpointRef {
  EndpointAudit(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'audit';

  /// Lista los registros de bitácora paginados con filtros opcionales. Requiere audit.view.
  _i3.Future<List<_i19.AuditLog>> listLogs({
    required int limit,
    required int offset,
    int? userId,
    String? action,
  }) => caller.callServerEndpoint<List<_i19.AuditLog>>(
    'audit',
    'listLogs',
    {
      'limit': limit,
      'offset': offset,
      'userId': userId,
      'action': action,
    },
  );

  /// Lista los registros de auditoría de forma paginada con filtros avanzados. Requiere audit.view.
  _i3.Future<_i20.AuditLogPageResponse> listLogsPaged({
    required int page,
    required int pageSize,
    String? action,
    String? result,
    int? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) => caller.callServerEndpoint<_i20.AuditLogPageResponse>(
    'audit',
    'listLogsPaged',
    {
      'page': page,
      'pageSize': pageSize,
      'action': action,
      'result': result,
      'userId': userId,
      'fromDate': fromDate,
      'toDate': toDate,
      'search': search,
    },
  );
}

/// Endpoint RPC para la gestión de autenticación multifactor (MFA) y dispositivos de confianza.
/// {@category Endpoint}
class EndpointMfa extends _i2.EndpointRef {
  EndpointMfa(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mfa';

  /// Verifica si el usuario autenticado requiere MFA.
  /// Si sí, genera un challenge, envía el email y devuelve el challengeId.
  /// Si no, devuelve null.
  _i3.Future<_i21.MfaChallengeResponse?> checkRequired({
    required bool rememberMe,
    String? trustedDeviceToken,
  }) => caller.callServerEndpoint<_i21.MfaChallengeResponse?>(
    'mfa',
    'checkRequired',
    {
      'rememberMe': rememberMe,
      'trustedDeviceToken': trustedDeviceToken,
    },
  );

  /// Verifica el código MFA. Si es correcto:
  /// - Marca el challenge como usado.
  /// - Si rememberMe, crea un TrustedDevice y devuelve el token.
  /// - Devuelve true si OK.
  /// Si es incorrecto, incrementa attempts y devuelve error.
  _i3.Future<_i22.MfaVerifyResponse> verifyMfa({
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) => caller.callServerEndpoint<_i22.MfaVerifyResponse>(
    'mfa',
    'verifyMfa',
    {
      'challengeId': challengeId,
      'code': code,
      'rememberMe': rememberMe,
    },
  );

  /// Reenvía un nuevo código para el mismo challenge.
  /// Rate limited: solo si pasó 1 minuto desde el último envío.
  _i3.Future<void> resendMfaCode({required String challengeId}) =>
      caller.callServerEndpoint<void>(
        'mfa',
        'resendMfaCode',
        {'challengeId': challengeId},
      );

  /// Comprueba si la sesión activa del usuario actual ya está verificada con MFA en PostgreSQL.
  _i3.Future<bool> isSessionVerified() => caller.callServerEndpoint<bool>(
    'mfa',
    'isSessionVerified',
    {},
  );
}

/// Endpoint RPC para administración de Roles y Permisos Granulares (RBAC).
/// {@category Endpoint}
class EndpointRbac extends _i2.EndpointRef {
  EndpointRbac(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rbac';

  /// Lista los roles registrados en el sistema. Requiere roles.view.
  _i3.Future<List<_i23.AppRole>> listRoles() =>
      caller.callServerEndpoint<List<_i23.AppRole>>(
        'rbac',
        'listRoles',
        {},
      );

  /// Lista el catálogo de permisos granulares. Requiere permissions.view.
  _i3.Future<List<_i24.AppPermission>> listPermissions() =>
      caller.callServerEndpoint<List<_i24.AppPermission>>(
        'rbac',
        'listPermissions',
        {},
      );

  /// Asigna un rol a un usuario. Requiere roles.manage.
  _i3.Future<_i25.UserRole> assignRoleToUser({
    required int userId,
    required int roleId,
  }) => caller.callServerEndpoint<_i25.UserRole>(
    'rbac',
    'assignRoleToUser',
    {
      'userId': userId,
      'roleId': roleId,
    },
  );

  /// Remueve un rol asignado a un usuario. Requiere roles.manage.
  _i3.Future<bool> removeRoleFromUser({
    required int userId,
    required int roleId,
  }) => caller.callServerEndpoint<bool>(
    'rbac',
    'removeRoleFromUser',
    {
      'userId': userId,
      'roleId': roleId,
    },
  );

  /// Asigna un permiso granular a un rol. Requiere permissions.assign.
  _i3.Future<_i26.RolePermission> assignPermissionToRole({
    required int roleId,
    required int permissionId,
  }) => caller.callServerEndpoint<_i26.RolePermission>(
    'rbac',
    'assignPermissionToRole',
    {
      'roleId': roleId,
      'permissionId': permissionId,
    },
  );

  /// Obtiene la lista de códigos de permisos efectivos de un usuario.
  _i3.Future<List<String>> getUserEffectivePermissions(int userId) =>
      caller.callServerEndpoint<List<String>>(
        'rbac',
        'getUserEffectivePermissions',
        {'userId': userId},
      );
}

/// Endpoint RPC para el monitoreo y control de sesiones activas.
/// {@category Endpoint}
class EndpointSessionManagement extends _i2.EndpointRef {
  EndpointSessionManagement(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionManagement';

  /// Registra la sesión actual del usuario autenticado en la tabla `user_session`.
  /// Se invoca después de un login exitoso.
  /// Retorna el `id` de la sesión creada.
  _i3.Future<int> registerSession({
    required String sessionTokenHash,
    required DateTime expiresAt,
    bool? mfaVerified,
  }) => caller.callServerEndpoint<int>(
    'sessionManagement',
    'registerSession',
    {
      'sessionTokenHash': sessionTokenHash,
      'expiresAt': expiresAt,
      'mfaVerified': mfaVerified,
    },
  );

  /// Lista las sesiones activas asociadas a un usuario. Requiere sessions.view.
  _i3.Future<List<_i27.UserSession>> listUserSessions(int userId) =>
      caller.callServerEndpoint<List<_i27.UserSession>>(
        'sessionManagement',
        'listUserSessions',
        {'userId': userId},
      );

  /// Revoca de forma inmediata una sesión activa por su ID. Requiere sessions.revoke.
  _i3.Future<bool> revokeSession(int sessionId) =>
      caller.callServerEndpoint<bool>(
        'sessionManagement',
        'revokeSession',
        {'sessionId': sessionId},
      );

  /// Cierra la sesión actual del usuario autenticado.
  /// Marca la fila en `user_session` como revocada y registra el evento en `audit_log`.
  /// Retorna `true` si se revocó correctamente, `false` si no se encontró la sesión.
  _i3.Future<bool> logout() => caller.callServerEndpoint<bool>(
    'sessionManagement',
    'logout',
    {},
  );

  /// Marca la sesión activa actual del usuario autenticado como verificada con MFA.
  _i3.Future<void> markMfaVerified() => caller.callServerEndpoint<void>(
    'sessionManagement',
    'markMfaVerified',
    {},
  );
}

/// Endpoint RPC para consulta de métricas de telemetría y salud del servidor.
/// {@category Endpoint}
class EndpointSystemMetrics extends _i2.EndpointRef {
  EndpointSystemMetrics(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'systemMetrics';

  /// Retorna las métricas del sistema en tiempo real. Requiere permiso `audit.view`.
  _i3.Future<_i28.ServerMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i28.ServerMetricsResponse>(
        'systemMetrics',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para administración del ciclo de vida de usuarios.
/// Protegido con autorización backend-first estricta.
/// {@category Endpoint}
class EndpointUser extends _i2.EndpointRef {
  EndpointUser(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Lista usuarios paginados. Requiere permiso users.view.
  _i3.Future<List<_i29.AppUser>> listUsers({
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i29.AppUser>>(
    'user',
    'listUsers',
    {
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene el detalle de un usuario por ID. Requiere permiso users.view.
  _i3.Future<_i29.AppUser?> getUser(int id) =>
      caller.callServerEndpoint<_i29.AppUser?>(
        'user',
        'getUser',
        {'id': id},
      );

  /// Crea un nuevo usuario empresarial y le asocia sus roles iniciales. Requiere users.create.
  _i3.Future<_i29.AppUser> createUser({
    required String email,
    required String fullName,
    required List<int> roleIds,
  }) => caller.callServerEndpoint<_i29.AppUser>(
    'user',
    'createUser',
    {
      'email': email,
      'fullName': fullName,
      'roleIds': roleIds,
    },
  );

  /// Actualiza información de un usuario. Requiere users.update.
  _i3.Future<_i29.AppUser?> updateUser({
    required int id,
    required String fullName,
  }) => caller.callServerEndpoint<_i29.AppUser?>(
    'user',
    'updateUser',
    {
      'id': id,
      'fullName': fullName,
    },
  );

  /// Activa o desactiva la cuenta de un usuario. Requiere users.disable.
  _i3.Future<bool> setUserActive({
    required int id,
    required bool isActive,
  }) => caller.callServerEndpoint<bool>(
    'user',
    'setUserActive',
    {
      'id': id,
      'isActive': isActive,
    },
  );

  /// Borrado lógico (Soft Delete) de un usuario. Requiere users.delete.
  _i3.Future<bool> deleteUser(int id) => caller.callServerEndpoint<bool>(
    'user',
    'deleteUser',
    {'id': id},
  );

  /// Retorna el AppUser asociado a la sesión autenticada actual.
  _i3.Future<_i29.AppUser> getCurrentUser() =>
      caller.callServerEndpoint<_i29.AppUser>(
        'user',
        'getCurrentUser',
        {},
      );

  /// Cambia la contraseña del usuario autenticado.
  _i3.Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'user',
    'changePassword',
    {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i30.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    greeting = EndpointGreeting(this);
    crmAgenda = EndpointCrmAgenda(this);
    crmCustomers = EndpointCrmCustomers(this);
    crmLeads = EndpointCrmLeads(this);
    crmPipeline = EndpointCrmPipeline(this);
    audit = EndpointAudit(this);
    mfa = EndpointMfa(this);
    rbac = EndpointRbac(this);
    sessionManagement = EndpointSessionManagement(this);
    systemMetrics = EndpointSystemMetrics(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointGreeting greeting;

  late final EndpointCrmAgenda crmAgenda;

  late final EndpointCrmCustomers crmCustomers;

  late final EndpointCrmLeads crmLeads;

  late final EndpointCrmPipeline crmPipeline;

  late final EndpointAudit audit;

  late final EndpointMfa mfa;

  late final EndpointRbac rbac;

  late final EndpointSessionManagement sessionManagement;

  late final EndpointSystemMetrics systemMetrics;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'greeting': greeting,
    'crmAgenda': crmAgenda,
    'crmCustomers': crmCustomers,
    'crmLeads': crmLeads,
    'crmPipeline': crmPipeline,
    'audit': audit,
    'mfa': mfa,
    'rbac': rbac,
    'sessionManagement': sessionManagement,
    'systemMetrics': systemMetrics,
    'user': user,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
