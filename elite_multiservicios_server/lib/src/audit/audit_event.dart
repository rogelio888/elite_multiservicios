/// Tipos estándar de eventos de auditoría en el sistema.
abstract class AuditEventType {
  static const String loginSuccess = 'LOGIN_SUCCESS';
  static const String loginFailed = 'LOGIN_FAILED';
  static const String logout = 'LOGOUT';
  static const String userCreated = 'USER_CREATED';
  static const String userUpdated = 'USER_UPDATED';
  static const String userDisabled = 'USER_DISABLED';
  static const String roleCreated = 'ROLE_CREATED';
  static const String roleUpdated = 'ROLE_UPDATED';
  static const String permissionChanged = 'PERMISSION_CHANGED';
  static const String passwordChanged = 'PASSWORD_CHANGED';
  static const String sessionRevoked = 'SESSION_REVOKED';
}

/// Estado o resultado del evento de auditoría.
enum AuditResult {
  success,
  failure,
  denied,
}

/// Modelo en memoria para transferencia o registro de eventos de bitácora.
class AuditEventRecord {
  final String action;
  final int? userId;
  final String? userIdentifier;
  final String? resource;
  final String? ipAddress;
  final AuditResult result;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AuditEventRecord({
    required this.action,
    this.userId,
    this.userIdentifier,
    this.resource,
    this.ipAddress,
    required this.result,
    DateTime? timestamp,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now().toUtc();

  Map<String, dynamic> toJson() => {
    'action': action,
    'userId': userId,
    'userIdentifier': userIdentifier,
    'resource': resource,
    'ipAddress': ipAddress,
    'result': result.name,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}
