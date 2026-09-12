import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';

/// Endpoint RPC para consulta de métricas de telemetría y salud del servidor.
class SystemMetricsEndpoint extends Endpoint {
  static final DateTime _serverStartTime = DateTime.now().toUtc();

  /// Retorna las métricas del sistema en tiempo real. Requiere permiso `audit.view`.
  Future<ServerMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.auditView);

    // 1. Uptime del proceso
    final uptime = DateTime.now().toUtc().difference(_serverStartTime);

    // 2. Memoria RSS
    final rss = ProcessInfo.currentRss;

    // 3. Latencia de conexión a PostgreSQL
    final dbStart = DateTime.now();
    await session.db.unsafeQuery('SELECT 1');
    final dbLatency = DateTime.now().difference(dbStart).inMilliseconds;

    // 4. Conteo de sesiones activas (no revocadas y con fecha de expiración vigente)
    final nowUtc = DateTime.now().toUtc();
    final activeSessions = await UserSession.db.count(
      session,
      where: (t) => t.isRevoked.equals(false) & (t.expiresAt > nowUtc),
    );

    // 5. Intentos fallidos de login en las últimas 24 horas
    final yesterday = DateTime.now().toUtc().subtract(
      const Duration(hours: 24),
    );
    final failedLogins = await AuditLog.db.count(
      session,
      where: (t) => t.action.equals('LOGIN_FAILED') & (t.timestamp > yesterday),
    );

    return ServerMetricsResponse(
      uptimeSeconds: uptime.inSeconds,
      memoryRssBytes: rss,
      databaseLatencyMs: dbLatency,
      activeSessionsCount: activeSessions,
      failedLoginsLast24h: failedLogins,
      serverTimestamp: nowUtc,
      serverVersion: '3.4.13',
    );
  }
}
