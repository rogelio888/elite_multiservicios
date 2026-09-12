/// Excepción base para el dominio empresarial.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Excepción para operaciones no autenticadas.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Acceso no autenticado. Inicie sesión.',
    dynamic details,
  ]) : super(code: 'AUTH_REQUIRED', details: details);
}

/// Excepción para operaciones sin permisos suficientes (RBAC).
class ForbiddenException extends AppException {
  final String? requiredPermission;

  const ForbiddenException({
    String message = 'Acceso denegado: permisos insuficientes.',
    this.requiredPermission,
    super.details,
  }) : super(message, code: 'FORBIDDEN');
}

/// Excepción para entidades no encontradas en base de datos.
class EntityNotFoundException extends AppException {
  final String entityName;
  final dynamic entityId;

  const EntityNotFoundException(this.entityName, this.entityId)
    : super(
        '$entityName con identificador $entityId no fue encontrado.',
        code: 'NOT_FOUND',
      );
}

/// Excepción para fallas de validación de reglas de negocio.
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors = const {},
  }) : super(code: 'VALIDATION_FAILED', details: fieldErrors);
}

/// Excepción para cuentas temporalmente bloqueadas por exceso de intentos fallidos.
class AccountLockedException extends AppException {
  final int minutesRemaining;

  AccountLockedException({
    required this.minutesRemaining,
    String? message,
  }) : super(
         message ??
             'Cuenta temporalmente bloqueada. Intente de nuevo en $minutesRemaining minutos.',
         code: 'ACCOUNT_LOCKED',
         details: {'minutesRemaining': minutesRemaining},
       );
}
