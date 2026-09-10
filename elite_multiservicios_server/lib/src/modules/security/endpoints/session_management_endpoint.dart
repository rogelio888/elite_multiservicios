import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';

/// Endpoint RPC para el monitoreo y control de sesiones activas.
class SessionManagementEndpoint extends Endpoint {
  final AuditService _auditService;

  SessionManagementEndpoint({
    AuditService auditService = const ServerpodAuditService(),
  }) : _auditService = auditService;

  /// Lista las sesiones activas asociadas a un usuario. Requiere sessions.view.
  Future<List<UserSession>> listUserSessions(
    Session session,
    int userId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.sessionsView);

    return await UserSession.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isRevoked.equals(false),
      orderBy: (t) => t.lastActivityAt,
      orderDescending: true,
    );
  }

  /// Revoca de forma inmediata una sesión activa por su ID. Requiere sessions.revoke.
  Future<bool> revokeSession(Session session, int sessionId) async {
    final caller = await RbacGuard.requirePermission(
      session,
      AppPermissions.sessionsRevoke,
    );

    final userSession = await UserSession.db.findById(session, sessionId);
    if (userSession == null) return false;

    await UserSession.db.updateRow(
      session,
      userSession.copyWith(isRevoked: true),
    );

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.sessionRevoked,
        userIdentifier: caller,
        resource: 'session:#$sessionId/user:#${userSession.userId}',
        result: AuditResult.success,
      ),
    );

    return true;
  }
}
