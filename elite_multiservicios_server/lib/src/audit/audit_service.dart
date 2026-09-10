import 'package:serverpod/serverpod.dart';
import 'audit_event.dart';
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
    // 1. Registro estructurado en log de sesión de Serverpod
    final logMessage =
        '[AUDIT] [${record.action}] '
        'User: ${record.userIdentifier ?? record.userId ?? "ANONYMOUS"} | '
        'Resource: ${record.resource ?? "N/A"} | '
        'Result: ${record.result.name.toUpperCase()} | '
        'IP: ${record.ipAddress ?? "UNKNOWN"}';

    if (record.result == AuditResult.failure ||
        record.result == AuditResult.denied) {
      session.log(logMessage, level: LogLevel.warning);
    } else {
      session.log(logMessage, level: LogLevel.info);
    }

    // 2. Persistencia en la tabla audit_log de PostgreSQL
    try {
      final repository = AuditRepository(session);
      await repository.record(record);
    } catch (e, stackTrace) {
      session.log(
        'Error al persistir evento de auditoría en PostgreSQL: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
    }
  }
}
