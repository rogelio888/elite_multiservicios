import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import '../generated/protocol.dart';
import '../audit/audit_event.dart';
import '../audit/audit_service.dart';
import '../exceptions/app_exception.dart';

/// Endpoint de autenticación mediante correo y contraseña.
/// Extiende [EmailIdpBaseEndpoint] para incorporar auditoría de login fallido
/// y bloqueo de cuentas por intentos excesivos (soft lock 15 min, hard lock 24 h).
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  final AuditService _auditService;

  EmailIdpEndpoint({
    AuditService auditService = const ServerpodAuditService(),
  }) : _auditService = auditService;

  @override
  Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    // 1. Buscar el AppUser por email
    final appUser = await AppUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    // 2. Verificar si la cuenta está actualmente bloqueada
    if (appUser != null && appUser.lockedUntil != null) {
      final now = DateTime.now().toUtc();
      if (appUser.lockedUntil!.isAfter(now)) {
        throw EmailAccountLoginException(
          reason: EmailAccountLoginExceptionReason.tooManyAttempts,
        );
      }
    }

    try {
      // 3. Intentar login nativo
      final result = await super.login(
        session,
        email: email,
        password: password,
      );

      // 4. Login exitoso -> resetear contadores y bloqueos
      if (appUser != null &&
          (appUser.failedLoginAttempts > 0 || appUser.lockedUntil != null)) {
        await AppUser.db.updateRow(
          session,
          appUser.copyWith(
            failedLoginAttempts: 0,
            lastFailedLoginAt: null,
            lockedUntil: null,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      return result;
    } catch (e) {
      // 5. Login fallido -> incrementar contador y evaluar umbrales de bloqueo
      if (appUser != null && e is! AccountLockedException) {
        final newAttempts = appUser.failedLoginAttempts + 1;
        final now = DateTime.now().toUtc();

        DateTime? lockedUntil;
        if (newAttempts >= 5) {
          lockedUntil = now.add(
            const Duration(hours: 24),
          ); // Hard lock (24 horas)
          await _auditService.logEvent(
            session,
            AuditEventRecord(
              action: AuditEventType.accountLocked,
              userId: appUser.id,
              userIdentifier: appUser.email,
              resource: 'user:#${appUser.id}',
              ipAddress: session.request?.remoteInfo,
              result: AuditResult.denied,
              metadata: {
                'attempts': newAttempts,
                'lockedUntil': lockedUntil.toIso8601String(),
                'type': 'hard',
              },
            ),
          );
        } else if (newAttempts >= 3) {
          lockedUntil = now.add(
            const Duration(minutes: 15),
          ); // Soft lock (15 minutos)
          await _auditService.logEvent(
            session,
            AuditEventRecord(
              action: AuditEventType.accountLocked,
              userId: appUser.id,
              userIdentifier: appUser.email,
              resource: 'user:#${appUser.id}',
              ipAddress: session.request?.remoteInfo,
              result: AuditResult.denied,
              metadata: {
                'attempts': newAttempts,
                'lockedUntil': lockedUntil.toIso8601String(),
                'type': 'soft',
              },
            ),
          );
        }

        await AppUser.db.updateRow(
          session,
          appUser.copyWith(
            failedLoginAttempts: newAttempts,
            lastFailedLoginAt: now,
            lockedUntil: lockedUntil,
            updatedAt: now,
          ),
        );

        await _auditService.logEvent(
          session,
          AuditEventRecord(
            action: AuditEventType.loginFailed,
            userId: appUser.id,
            userIdentifier: appUser.email,
            resource: 'user:#${appUser.id}',
            ipAddress: session.request?.remoteInfo,
            result: AuditResult.failure,
            metadata: {
              'attempts': newAttempts,
              'lockedUntil': lockedUntil?.toIso8601String(),
            },
          ),
        );
      }

      rethrow;
    }
  }
}
