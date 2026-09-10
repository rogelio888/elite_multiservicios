import 'package:serverpod/serverpod.dart';
import 'audit_event.dart';

/// Servicio de auditoría y bitácora de eventos del sistema.
/// Prepara la arquitectura para registrar eventos sin almacenar datos sensibles.
abstract class AuditService {
  /// Registra un evento en la bitácora del sistema.
  Future<void> logEvent(Session session, AuditEventRecord record);
}

/// Implementación base con logging estructurado en Serverpod.
class ServerpodAuditService implements AuditService {
  const ServerpodAuditService();

  @override
  Future<void> logEvent(Session session, AuditEventRecord record) async {
    // Registro estructurado en log de sesión de Serverpod
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
  }
}
