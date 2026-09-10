import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/audit_repository.dart';

/// Endpoint RPC para consulta de la bitácora de eventos y auditoría del sistema.
class AuditEndpoint extends Endpoint {
  /// Lista los registros de bitácora paginados con filtros opcionales. Requiere audit.view.
  Future<List<AuditLog>> listLogs(
    Session session, {
    int limit = 50,
    int offset = 0,
    int? userId,
    String? action,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.auditView);

    final repo = AuditRepository(session);
    return await repo.listLogs(
      limit: limit,
      offset: offset,
      userId: userId,
      action: action,
    );
  }
}
