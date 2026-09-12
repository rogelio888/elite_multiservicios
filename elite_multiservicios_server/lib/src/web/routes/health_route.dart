import 'package:serverpod/serverpod.dart';

/// Ruta pública de monitoreo y health check HTTP (/health).
class HealthRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    final dbStart = DateTime.now();
    try {
      await session.db.unsafeQuery('SELECT 1');
      final dbLatency = DateTime.now().difference(dbStart).inMilliseconds;
      return JsonWidget(
        object: {
          'status': 'ok',
          'dbLatencyMs': dbLatency,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (e) {
      return JsonWidget(
        object: {
          'status': 'error',
          'error': e.toString(),
        },
      );
    }
  }
}
