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

/// Código MFA incorrecto.
class MfaCodeInvalidException extends AppException {
  MfaCodeInvalidException({String? message, int? attemptsRemaining})
    : super(
        message ?? 'Código incorrecto. Verificalo e intentá de nuevo.',
        code: 'MFA_CODE_INVALID',
        details: attemptsRemaining != null
            ? {'attemptsRemaining': attemptsRemaining}
            : null,
      );
}

/// Código MFA expirado.
class MfaCodeExpiredException extends AppException {
  MfaCodeExpiredException({String? message})
    : super(
        message ?? 'El código expiró. Solicitá uno nuevo.',
        code: 'MFA_CODE_EXPIRED',
      );
}

/// Demasiados intentos MFA.
class MfaTooManyAttemptsException extends AppException {
  MfaTooManyAttemptsException({String? message})
    : super(
        message ?? 'Demasiados intentos. Solicitá un nuevo código.',
        code: 'MFA_TOO_MANY_ATTEMPTS',
      );
}

/// Challenge MFA no encontrado o inválido.
class MfaChallengeNotFoundException extends AppException {
  MfaChallengeNotFoundException({String? message})
    : super(
        message ?? 'Challenge no encontrado o inválido.',
        code: 'MFA_CHALLENGE_NOT_FOUND',
      );
}

/// El código MFA ya fue usado.
class MfaCodeAlreadyUsedException extends AppException {
  MfaCodeAlreadyUsedException({String? message})
    : super(
        message ?? 'Este código ya fue utilizado.',
        code: 'MFA_CODE_ALREADY_USED',
      );
}

/// Operación crítica bloqueada porque la sesión requiere verificación MFA previa.
class MfaRequiredException extends AppException {
  const MfaRequiredException([
    super.message =
        'Esta operación requiere verificación previa de autenticación multifactor (MFA).',
  ]) : super(code: 'MFA_REQUIRED');
}

/// La contraseña no cumple con las políticas corporativas de seguridad.
class PasswordPolicyException extends AppException {
  final List<String> errors;

  PasswordPolicyException({required this.errors})
    : super(
        'La contraseña no cumple con las políticas de seguridad.',
        code: 'PASSWORD_POLICY_VIOLATION',
        details: {'errors': errors},
      );
}
