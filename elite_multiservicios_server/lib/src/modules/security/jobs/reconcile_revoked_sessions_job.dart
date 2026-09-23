import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../../generated/protocol.dart';

/// Job periódico de Serverpod que reconcilia sesiones revocadas en `user_session`
/// asegurando que su refresh token persistente en Serverpod sea eliminado.
class ReconcileRevokedSessionsJob extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      // 1. Filtrar sesiones revocadas con authSessionId válido y reintentos pendientes (< 5)
      final pendingSessions = await UserSession.db.find(
        session,
        where: (t) =>
            t.isRevoked.equals(true) &
            t.authSessionId.notEquals(null) &
            (t.reconcileAttempts < 5),
      );

      for (final us in pendingSessions) {
        final authSessionId = us.authSessionId!;
        try {
          await AuthServices.instance.tokenManager.revokeToken(
            session,
            tokenId: authSessionId,
          );
        } catch (e, stackTrace) {
          final newAttempts = us.reconcileAttempts + 1;
          await UserSession.db.updateRow(
            session,
            us.copyWith(
              reconcileAttempts: newAttempts,
            ),
          );

          if (newAttempts >= 5) {
            session.log(
              'ALERTA CRÍTICA: Reintentos de reconciliación agotados (5/5) para UserSession id: ${us.id}, authSessionId: $authSessionId: $e',
              level: LogLevel.error,
              exception: e,
              stackTrace: stackTrace,
            );
          } else {
            session.log(
              'Fallo transitorio al reconciliar authSessionId $authSessionId (intento $newAttempts/5): $e',
              level: LogLevel.warning,
            );
          }
        }
      }
    } catch (e, stackTrace) {
      session.log(
        'Error general en ReconcileRevokedSessionsJob: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      // 2. Re-agendar ejecución para dentro de 30 minutos
      try {
        // ignore: deprecated_member_use
        await server.serverpod.futureCallWithDelay(
          name,
          null,
          const Duration(minutes: 30),
          identifier: 'reconcileRevokedSessions',
        );
      } catch (e, stackTrace) {
        try {
          session.log(
            'Error al reagendar ReconcileRevokedSessionsJob: $e',
            level: LogLevel.error,
            exception: e,
            stackTrace: stackTrace,
          );
        } catch (_) {}
      }
    }
  }
}
