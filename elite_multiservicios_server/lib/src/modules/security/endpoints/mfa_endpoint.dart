import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../audit/audit_event.dart';
import '../../../audit/audit_service.dart';
import '../../../exceptions/app_exception.dart';
import '../../../services/mail_service.dart';

/// Endpoint RPC para la gestión de autenticación multifactor (MFA) y dispositivos de confianza.
class MfaEndpoint extends Endpoint {
  final AuditService _auditService;

  MfaEndpoint({AuditService auditService = const ServerpodAuditService()})
    : _auditService = auditService;

  /// Verifica si el usuario autenticado requiere MFA.
  /// Si sí, genera un challenge, envía el email y devuelve el challengeId.
  /// Si no, devuelve null.
  Future<MfaChallengeResponse?> checkRequired(
    Session session, {
    required bool rememberMe,
    String? trustedDeviceToken,
  }) async {
    // 1. Obtener el usuario autenticado
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado.');
    }

    final appUser = await RbacGuard.resolveAppUser(session, authUserIdStr);

    // 2. Si MFA no está habilitado → no requiere
    if (!appUser.mfaEnabled) {
      return null;
    }

    // 3. Si la sesión activa ya tiene mfaVerified == true → no requiere
    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    if (activeSession != null && activeSession.mfaVerified) {
      return null;
    }

    // 4. Si rememberMe && trustedDeviceToken válido → no requiere
    if (rememberMe && trustedDeviceToken != null) {
      final trusted = await TrustedDevice.db.findFirstRow(
        session,
        where: (t) =>
            t.deviceToken.equals(trustedDeviceToken) &
            t.userId.equals(appUser.id!),
      );

      if (trusted != null &&
          trusted.expiresAt.isAfter(DateTime.now().toUtc())) {
        // Registrar uso en bitácora de auditoría
        await _auditService.logEvent(
          session,
          AuditEventRecord(
            action: AuditEventType.trustedDeviceUsed,
            userId: appUser.id,
            userIdentifier: appUser.email,
            resource: 'trusted_device',
            ipAddress: session.request?.remoteInfo,
            result: AuditResult.success,
            metadata: {
              'trustedDeviceId': trusted.id,
              'deviceInfo': trusted.deviceInfo,
            },
          ),
        );

        if (activeSession != null) {
          await UserSession.db.updateRow(
            session,
            activeSession.copyWith(
              mfaVerified: true,
              lastActivityAt: DateTime.now().toUtc(),
            ),
            columns: (t) => [t.mfaVerified, t.lastActivityAt],
          );
        }

        return null; // No requiere MFA
      }
    }

    // 5. Si ya existe un challenge vigente (< 90s), reutilizarlo para evitar saturación de emails
    final existingChallenge = await MfaChallenge.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(appUser.id!) &
          t.isUsed.equals(false) &
          (t.expiresAt > DateTime.now().toUtc()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    if (existingChallenge != null && existingChallenge.attempts < 3) {
      final age = DateTime.now().toUtc().difference(
        existingChallenge.createdAt,
      );
      if (age.inSeconds < 90) {
        return MfaChallengeResponse(
          challengeId: existingChallenge.challengeId,
          emailHint: _maskEmail(appUser.email),
          expiresAt: existingChallenge.expiresAt,
        );
      }
    }

    // 6. Generar código y challenge
    final code = _generateSixDigitCode();
    final challengeId = const Uuid().v4();
    final codeHash = sha256.convert(utf8.encode(code)).toString();
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(const Duration(minutes: 5));

    await MfaChallenge.db.insertRow(
      session,
      MfaChallenge(
        userId: appUser.id!,
        challengeId: challengeId,
        codeHash: codeHash,
        attempts: 0,
        isUsed: false,
        expiresAt: expiresAt,
        createdAt: now,
      ),
    );

    // 5. Enviar email con el código de 6 dígitos (con tolerancia a fallas del proveedor)
    try {
      await MailService.sendMfaCode(session, email: appUser.email, code: code);
    } catch (e, stackTrace) {
      session.log(
        '⚠️ [MfaEndpoint] No se pudo enviar email MFA a ${appUser.email}: $e. Código temporal de respaldo: $code',
        level: LogLevel.warning,
        exception: e,
        stackTrace: stackTrace,
      );
    }

    // 6. Registrar en auditoría
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.mfaChallengeIssued,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource: 'mfa_challenge',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {
          'challengeId': challengeId,
          'expiresAt': expiresAt.toIso8601String(),
        },
      ),
    );

    // 7. Devolver respuesta
    return MfaChallengeResponse(
      challengeId: challengeId,
      emailHint: _maskEmail(appUser.email),
      expiresAt: expiresAt,
    );
  }

  /// Verifica el código MFA. Si es correcto:
  /// - Marca el challenge como usado.
  /// - Si rememberMe, crea un TrustedDevice y devuelve el token.
  /// - Devuelve true si OK.
  /// Si es incorrecto, incrementa attempts y devuelve error.
  Future<MfaVerifyResponse> verifyMfa(
    Session session, {
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) async {
    // 1. Obtener el usuario autenticado
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado.');
    }

    final appUser = await RbacGuard.resolveAppUser(session, authUserIdStr);

    // 2. Buscar challenge
    final challenge = await MfaChallenge.db.findFirstRow(
      session,
      where: (t) =>
          t.challengeId.equals(challengeId) & t.userId.equals(appUser.id!),
    );

    if (challenge == null) {
      throw MfaChallengeNotFoundException();
    }

    final now = DateTime.now().toUtc();

    // 3. Validar estado del challenge
    if (challenge.isUsed) {
      throw MfaCodeAlreadyUsedException();
    }

    if (challenge.expiresAt.isBefore(now)) {
      throw MfaCodeExpiredException();
    }

    if (challenge.attempts >= 3) {
      throw MfaTooManyAttemptsException();
    }

    // 4. Comparar hash del código
    final inputHash = sha256.convert(utf8.encode(code.trim())).toString();
    if (inputHash != challenge.codeHash) {
      final newAttempts = challenge.attempts + 1;
      await MfaChallenge.db.updateRow(
        session,
        challenge.copyWith(attempts: newAttempts),
      );

      await _auditService.logEvent(
        session,
        AuditEventRecord(
          action: AuditEventType.mfaFailed,
          userId: appUser.id,
          userIdentifier: appUser.email,
          resource: 'mfa_challenge',
          ipAddress: session.request?.remoteInfo,
          result: AuditResult.failure,
          metadata: {
            'challengeId': challengeId,
            'attempts': newAttempts,
          },
        ),
      );

      final remaining = 3 - newAttempts;
      if (remaining > 0) {
        throw MfaCodeInvalidException(attemptsRemaining: remaining);
      } else {
        throw MfaTooManyAttemptsException();
      }
    }

    // 5. Código correcto: marcar isUsed y auditar
    await MfaChallenge.db.updateRow(
      session,
      challenge.copyWith(isUsed: true),
    );

    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.mfaVerified,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource: 'mfa_challenge',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {
          'challengeId': challengeId,
        },
      ),
    );

    // 6. Marcar la sesión activa del usuario como verificada con MFA
    final activeSession = await UserSession.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (activeSession != null) {
      await UserSession.db.updateRow(
        session,
        activeSession.copyWith(
          mfaVerified: true,
          lastActivityAt: now,
        ),
        columns: (t) => [t.mfaVerified, t.lastActivityAt],
      );
    } else {
      final ipAddress = session.request?.remoteInfo;
      final deviceInfo = session.request?.headers['user-agent']?.firstOrNull;
      await UserSession.db.insertRow(
        session,
        UserSession(
          userId: appUser.id!,
          sessionTokenHash: 'mfa-${now.millisecondsSinceEpoch}-${appUser.id}',
          ipAddress: ipAddress,
          deviceInfo: deviceInfo,
          isRevoked: false,
          mfaVerified: true,
          createdAt: now,
          lastActivityAt: now,
          expiresAt: now.add(const Duration(days: 30)),
        ),
      );
    }

    // 7. Si rememberMe → registrar TrustedDevice
    String? trustedDeviceToken;
    if (rememberMe) {
      trustedDeviceToken = const Uuid().v4();
      final deviceExpires = now.add(const Duration(days: 30));
      final ipAddress = session.request?.remoteInfo;
      final deviceInfo = session.request?.headers['user-agent']?.firstOrNull;

      await TrustedDevice.db.insertRow(
        session,
        TrustedDevice(
          userId: appUser.id!,
          deviceToken: trustedDeviceToken,
          deviceInfo: deviceInfo,
          ipAddress: ipAddress,
          expiresAt: deviceExpires,
          createdAt: now,
        ),
      );

      await _auditService.logEvent(
        session,
        AuditEventRecord(
          action: AuditEventType.trustedDeviceCreated,
          userId: appUser.id,
          userIdentifier: appUser.email,
          resource: 'trusted_device',
          ipAddress: ipAddress,
          result: AuditResult.success,
          metadata: {
            'deviceToken': trustedDeviceToken,
            'expiresAt': deviceExpires.toIso8601String(),
          },
        ),
      );
    }

    return MfaVerifyResponse(
      success: true,
      trustedDeviceToken: trustedDeviceToken,
    );
  }

  /// Reenvía un nuevo código para el mismo challenge.
  /// Rate limited: solo si pasó 1 minuto desde el último envío.
  Future<void> resendMfaCode(
    Session session, {
    required String challengeId,
  }) async {
    // 1. Obtener usuario autenticado
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) {
      throw const UnauthorizedException('Usuario no autenticado.');
    }

    final appUser = await RbacGuard.resolveAppUser(session, authUserIdStr);

    // 2. Buscar challenge
    final challenge = await MfaChallenge.db.findFirstRow(
      session,
      where: (t) =>
          t.challengeId.equals(challengeId) & t.userId.equals(appUser.id!),
    );

    if (challenge == null) {
      throw MfaChallengeNotFoundException();
    }

    if (challenge.isUsed) {
      throw MfaCodeAlreadyUsedException();
    }

    // 3. Validar rate limit (mínimo 60s entre solicitudes)
    final now = DateTime.now().toUtc();
    final lastSentAt = challenge.expiresAt.subtract(const Duration(minutes: 5));
    final elapsedSeconds = now.difference(lastSentAt).inSeconds;

    if (elapsedSeconds < 60) {
      final waitSec = 60 - elapsedSeconds;
      throw ValidationException(
        'Debes esperar $waitSec segundo(s) antes de solicitar un nuevo código.',
      );
    }

    // 4. Generar nuevo código
    final newCode = _generateSixDigitCode();
    final newCodeHash = sha256.convert(utf8.encode(newCode)).toString();
    final newExpiresAt = now.add(const Duration(minutes: 5));

    // 5. Actualizar challenge (nuevo hash, reset de intentos, nueva expiración)
    await MfaChallenge.db.updateRow(
      session,
      challenge.copyWith(
        codeHash: newCodeHash,
        attempts: 0,
        expiresAt: newExpiresAt,
      ),
    );

    // 6. Reenviar email (con tolerancia a fallas del proveedor)
    try {
      await MailService.sendMfaCode(
        session,
        email: appUser.email,
        code: newCode,
      );
    } catch (e, stackTrace) {
      session.log(
        '⚠️ [MfaEndpoint] No se pudo reenviar email MFA a ${appUser.email}: $e. Código temporal de respaldo: $newCode',
        level: LogLevel.warning,
        exception: e,
        stackTrace: stackTrace,
      );
    }

    // 7. Registrar en auditoría
    await _auditService.logEvent(
      session,
      AuditEventRecord(
        action: AuditEventType.mfaChallengeIssued,
        userId: appUser.id,
        userIdentifier: appUser.email,
        resource: 'mfa_challenge',
        ipAddress: session.request?.remoteInfo,
        result: AuditResult.success,
        metadata: {
          'challengeId': challengeId,
          'resend': true,
          'expiresAt': newExpiresAt.toIso8601String(),
        },
      ),
    );
  }

  /// Genera un código criptográficamente seguro de 6 dígitos numéricos.
  String _generateSixDigitCode() {
    final random = Random.secure();
    final number = random.nextInt(900000) + 100000;
    return number.toString();
  }

  /// Enmascara una dirección de correo para protección de datos personales.
  /// Ej: `admin@elitemultiservicios.com` -> `a***n@elitemultiservicios.com`
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return '${name[0]}*@$domain';
    }
    final first = name[0];
    final last = name[name.length - 1];
    final masked = '*' * (name.length - 2);
    return '$first$masked$last@$domain';
  }

  /// Comprueba si la sesión activa del usuario actual ya está verificada con MFA en PostgreSQL.
  Future<bool> isSessionVerified(Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) return false;

    try {
      final appUser = await RbacGuard.resolveAppUser(
        session,
        authUserIdStr,
      );
      if (!appUser.mfaEnabled) return true;

      final activeSession = await UserSession.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(appUser.id!) & t.isRevoked.equals(false),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      return activeSession?.mfaVerified ?? false;
    } catch (_) {
      return false;
    }
  }
}
