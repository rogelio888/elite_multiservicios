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
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i6;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead_metrics_response.dart'
    as _i7;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i8;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log_page_response.dart'
    as _i9;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_challenge_response.dart'
    as _i10;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_verify_response.dart'
    as _i11;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i12;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i13;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_role.dart'
    as _i14;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/role_permission.dart'
    as _i15;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i16;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/server_metrics_response.dart'
    as _i17;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i18;
import 'protocol.dart' as _i19;

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

/// Endpoint RPC para la gestión integral de Prospectos (CRM Leads) en frío y Maps.
/// {@category Endpoint}
class EndpointCrmLeads extends _i2.EndpointRef {
  EndpointCrmLeads(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmLeads';

  /// Lista los prospectos con filtros opcionales de búsqueda, rubro, estado y temperatura.
  _i3.Future<List<_i6.CrmLead>> listLeads({
    required int limit,
    required int offset,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
  }) => caller.callServerEndpoint<List<_i6.CrmLead>>(
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
  _i3.Future<_i6.CrmLead?> getLead(int id) =>
      caller.callServerEndpoint<_i6.CrmLead?>(
        'crmLeads',
        'getLead',
        {'id': id},
      );

  /// Registra un nuevo prospecto comercial en el sistema.
  _i3.Future<_i6.CrmLead> createLead(_i6.CrmLead lead) =>
      caller.callServerEndpoint<_i6.CrmLead>(
        'crmLeads',
        'createLead',
        {'lead': lead},
      );

  /// Actualiza los datos generales de un prospecto.
  _i3.Future<_i6.CrmLead> updateLead(_i6.CrmLead lead) =>
      caller.callServerEndpoint<_i6.CrmLead>(
        'crmLeads',
        'updateLead',
        {'lead': lead},
      );

  /// Actualiza el estado comercial de un prospecto en el embudo inicial.
  _i3.Future<_i6.CrmLead?> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i6.CrmLead?>(
    'crmLeads',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  _i3.Future<_i6.CrmLead?> updateTemperature(
    int id,
    String temperature,
  ) => caller.callServerEndpoint<_i6.CrmLead?>(
    'crmLeads',
    'updateTemperature',
    {
      'id': id,
      'temperature': temperature,
    },
  );

  /// Marca el prospecto como promovido formalmente a una Oportunidad en el Pipeline.
  _i3.Future<_i6.CrmLead?> markPromoted(
    int id,
    int? opportunityId,
  ) => caller.callServerEndpoint<_i6.CrmLead?>(
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
  _i3.Future<_i7.CrmLeadMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i7.CrmLeadMetricsResponse>(
        'crmLeads',
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
  _i3.Future<List<_i8.AuditLog>> listLogs({
    required int limit,
    required int offset,
    int? userId,
    String? action,
  }) => caller.callServerEndpoint<List<_i8.AuditLog>>(
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
  _i3.Future<_i9.AuditLogPageResponse> listLogsPaged({
    required int page,
    required int pageSize,
    String? action,
    String? result,
    int? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) => caller.callServerEndpoint<_i9.AuditLogPageResponse>(
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
  _i3.Future<_i10.MfaChallengeResponse?> checkRequired({
    required bool rememberMe,
    String? trustedDeviceToken,
  }) => caller.callServerEndpoint<_i10.MfaChallengeResponse?>(
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
  _i3.Future<_i11.MfaVerifyResponse> verifyMfa({
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) => caller.callServerEndpoint<_i11.MfaVerifyResponse>(
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
}

/// Endpoint RPC para administración de Roles y Permisos Granulares (RBAC).
/// {@category Endpoint}
class EndpointRbac extends _i2.EndpointRef {
  EndpointRbac(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rbac';

  /// Lista los roles registrados en el sistema. Requiere roles.view.
  _i3.Future<List<_i12.AppRole>> listRoles() =>
      caller.callServerEndpoint<List<_i12.AppRole>>(
        'rbac',
        'listRoles',
        {},
      );

  /// Lista el catálogo de permisos granulares. Requiere permissions.view.
  _i3.Future<List<_i13.AppPermission>> listPermissions() =>
      caller.callServerEndpoint<List<_i13.AppPermission>>(
        'rbac',
        'listPermissions',
        {},
      );

  /// Asigna un rol a un usuario. Requiere roles.manage.
  _i3.Future<_i14.UserRole> assignRoleToUser({
    required int userId,
    required int roleId,
  }) => caller.callServerEndpoint<_i14.UserRole>(
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
  _i3.Future<_i15.RolePermission> assignPermissionToRole({
    required int roleId,
    required int permissionId,
  }) => caller.callServerEndpoint<_i15.RolePermission>(
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
  _i3.Future<List<_i16.UserSession>> listUserSessions(int userId) =>
      caller.callServerEndpoint<List<_i16.UserSession>>(
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
  _i3.Future<_i17.ServerMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i17.ServerMetricsResponse>(
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
  _i3.Future<List<_i18.AppUser>> listUsers({
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i18.AppUser>>(
    'user',
    'listUsers',
    {
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene el detalle de un usuario por ID. Requiere permiso users.view.
  _i3.Future<_i18.AppUser?> getUser(int id) =>
      caller.callServerEndpoint<_i18.AppUser?>(
        'user',
        'getUser',
        {'id': id},
      );

  /// Crea un nuevo usuario empresarial y le asocia sus roles iniciales. Requiere users.create.
  _i3.Future<_i18.AppUser> createUser({
    required String email,
    required String fullName,
    required List<int> roleIds,
  }) => caller.callServerEndpoint<_i18.AppUser>(
    'user',
    'createUser',
    {
      'email': email,
      'fullName': fullName,
      'roleIds': roleIds,
    },
  );

  /// Actualiza información de un usuario. Requiere users.update.
  _i3.Future<_i18.AppUser?> updateUser({
    required int id,
    required String fullName,
  }) => caller.callServerEndpoint<_i18.AppUser?>(
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
  _i3.Future<_i18.AppUser> getCurrentUser() =>
      caller.callServerEndpoint<_i18.AppUser>(
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
         _i19.Protocol(),
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
    crmLeads = EndpointCrmLeads(this);
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

  late final EndpointCrmLeads crmLeads;

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
    'crmLeads': crmLeads,
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
