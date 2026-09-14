import 'package:serverpod/serverpod.dart';
import 'audit_event.dart';
import '../authorization/rbac_guard.dart';
import '../modules/security/repositories/audit_repository.dart';

/// Servicio de auditoría y bitácora de eventos del sistema.
/// Prepara la arquitectura para registrar eventos sin almacenar datos sensibles.
abstract class AuditService {
  /// Registra un evento en la bitácora del sistema y persiste en PostgreSQL.
  Future<void> logEvent(Session session, AuditEventRecord record);
}

/// Implementación oficial con persistencia en base de datos PostgreSQL y logging de sesión.
class ServerpodAuditService implements AuditService {
  const ServerpodAuditService();

  @override
  Future<void> logEvent(Session session, AuditEventRecord record) async {
    AuditEventRecord effectiveRecord = record;

    // Si userIdentifier no es un correo electrónico (por ejemplo, es un UUID de sesión),
    // resolver la entidad AppUser relacional para persistir el email legible y el userId.
    if (record.userIdentifier != null &&
        !record.userIdentifier!.contains('@')) {
      try {
        final appUser = await RbacGuard.resolveAppUser(
          session,
          record.userIdentifier!,
        );
        effectiveRecord = record.copyWith(
          userIdentifier: appUser.email,
          userId: record.userId ?? appUser.id,
        );
      } catch (_) {
        // Mantiene el identificador original si no fue resoluble
      }
    }

    // 1. Registro estructurado en log de sesión de Serverpod
    final logMessage =
        '[AUDIT] [${effectiveRecord.action}] '
        'User: ${effectiveRecord.userIdentifier ?? effectiveRecord.userId ?? "ANONYMOUS"} | '
        'Resource: ${effectiveRecord.resource ?? "N/A"} | '
        'Result: ${effectiveRecord.result.name.toUpperCase()} | '
        'IP: ${effectiveRecord.ipAddress ?? "UNKNOWN"}';

    if (effectiveRecord.result == AuditResult.failure ||
        effectiveRecord.result == AuditResult.denied) {
      session.log(logMessage, level: LogLevel.warning);
    } else {
      session.log(logMessage, level: LogLevel.info);
    }

    // 2. Persistencia en la tabla audit_log de PostgreSQL
    try {
      final repository = AuditRepository(session);
      await repository.record(effectiveRecord);
    } catch (e, stackTrace) {
      session.log(
        'Error al persistir evento de auditoría en PostgreSQL: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
    }
  }
}
