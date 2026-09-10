import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../audit/audit_event.dart';

/// Repositorio para la persistencia inmutable de la bitácora de auditoría en PostgreSQL.
class AuditRepository {
  final Session session;

  const AuditRepository(this.session);

  /// Inserta un nuevo evento de auditoría en base de datos.
  Future<AuditLog> record(AuditEventRecord record) async {
    final entity = AuditLog(
      action: record.action,
      userId: record.userId,
      userIdentifier: record.userIdentifier,
      resource: record.resource,
      ipAddress: record.ipAddress,
      result: record.result.name.toUpperCase(),
      metadata: record.metadata != null ? jsonEncode(record.metadata) : null,
      timestamp: record.timestamp,
    );

    return await AuditLog.db.insertRow(session, entity);
  }

  /// Lista eventos de auditoría con filtros opcionales.
  Future<List<AuditLog>> listLogs({
    int limit = 50,
    int offset = 0,
    int? userId,
    String? action,
  }) async {
    return await AuditLog.db.find(
      session,
      where: (t) {
        Expression filter = Constant.bool(true);
        if (userId != null) {
          filter = filter & t.userId.equals(userId);
        }
        if (action != null) {
          filter = filter & t.action.equals(action);
        }
        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );
  }
}
