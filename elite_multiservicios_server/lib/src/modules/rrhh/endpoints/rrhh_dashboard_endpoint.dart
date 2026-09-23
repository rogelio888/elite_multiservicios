import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_dashboard_repository.dart';

/// Endpoint RPC para el Dashboard de Recursos Humanos y Telemetría Laboral.
class RrhhDashboardEndpoint extends Endpoint {
  /// Obtiene los KPIs consolidados y métricas operativas del Dashboard de RRHH.
  Future<RrhhDashboardMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhDashboardView,
    );

    final repo = RrhhDashboardDataService(session);
    return await repo.getDashboardMetrics();
  }

  /// Obtiene la lista de novedades y movimientos recientes de personal.
  Future<List<RrhhRecentMovementDto>> getRecentMovements(
    Session session, {
    int limit = 10,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhDashboardView,
    );

    final repo = RrhhDashboardDataService(session);
    return await repo.getRecentMovements(limit: limit);
  }
}
