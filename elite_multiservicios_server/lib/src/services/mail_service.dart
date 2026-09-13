// ignore_for_file: avoid_print
import 'dart:io';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

/// Servicio para orquestar y despachar correos electrónicos transaccionales
/// a través de SMTP (Mailtrap en desarrollo/sandbox).
class MailService {
  /// Envía el código de verificación para el registro de una nueva cuenta.
  static Future<void> sendRegistrationCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) async {
    const subject = 'Código de verificación de registro - Elite Multiservicios';
    final html =
        '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 24px; color: #1e293b; }
    .card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
    .header { font-size: 20px; font-weight: 700; color: #0f172a; margin-bottom: 16px; text-align: center; }
    .desc { font-size: 14px; line-height: 1.6; color: #475569; margin-bottom: 24px; }
    .code-box { background: #f1f5f9; border-radius: 8px; padding: 16px; text-align: center; font-size: 32px; font-weight: 800; letter-spacing: 6px; color: #0284c7; margin-bottom: 24px; }
    .footer { font-size: 12px; color: #94a3b8; text-align: center; margin-top: 24px; border-top: 1px solid #e2e8f0; padding-top: 16px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="header">Elite Multiservicios</div>
    <p class="desc">Has solicitado registrar una cuenta empresarial. Utiliza el siguiente código de verificación para completar tu alta:</p>
    <div class="code-box">$verificationCode</div>
    <p class="desc">Este código expira en 15 minutos. Si tú no realizaste esta solicitud, puedes ignorar este mensaje con total seguridad.</p>
    <div class="footer">Elite Multiservicios • Sistema de Seguridad y Gestión Centralizada</div>
  </div>
</body>
</html>
''';

    await _send(
      session: session,
      to: email,
      subject: subject,
      htmlContent: html,
      textFallback: 'Tu código de verificación es: $verificationCode',
    );
  }

  /// Envía el código de verificación para restablecer la contraseña.
  static Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) async {
    const subject = 'Restablecimiento de contraseña - Elite Multiservicios';
    final html =
        '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 24px; color: #1e293b; }
    .card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
    .header { font-size: 20px; font-weight: 700; color: #0f172a; margin-bottom: 16px; text-align: center; }
    .desc { font-size: 14px; line-height: 1.6; color: #475569; margin-bottom: 24px; }
    .code-box { background: #fef2f2; border-radius: 8px; padding: 16px; text-align: center; font-size: 32px; font-weight: 800; letter-spacing: 6px; color: #dc2626; margin-bottom: 24px; }
    .footer { font-size: 12px; color: #94a3b8; text-align: center; margin-top: 24px; border-top: 1px solid #e2e8f0; padding-top: 16px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="header">Elite Multiservicios</div>
    <p class="desc">Recibimos una solicitud para restablecer la contraseña de tu cuenta empresarial. Utiliza el siguiente código para autorizar el cambio:</p>
    <div class="code-box">$verificationCode</div>
    <p class="desc">Este código expira en 15 minutos. Si no solicitaste este cambio, notifica de inmediato al equipo de seguridad.</p>
    <div class="footer">Elite Multiservicios • Sistema de Seguridad y Gestión Centralizada</div>
  </div>
</body>
</html>
''';

    await _send(
      session: session,
      to: email,
      subject: subject,
      htmlContent: html,
      textFallback:
          'Tu código para restablecer tu contraseña es: $verificationCode',
    );
  }

  /// Envía el código de verificación para autenticación multifactor (MFA).
  static Future<void> sendMfaCode(
    Session session, {
    required String email,
    required String code,
  }) async {
    const subject =
        'Código de verificación de seguridad (MFA) - Elite Multiservicios';
    final html =
        '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 24px; color: #1e293b; }
    .card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 32px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
    .header { font-size: 20px; font-weight: 700; color: #0f172a; margin-bottom: 16px; text-align: center; }
    .desc { font-size: 14px; line-height: 1.6; color: #475569; margin-bottom: 24px; }
    .code-box { background: #eff6ff; border-radius: 8px; padding: 16px; text-align: center; font-size: 32px; font-weight: 800; letter-spacing: 8px; color: #1e3a8a; margin-bottom: 24px; }
    .footer { font-size: 12px; color: #94a3b8; text-align: center; margin-top: 24px; border-top: 1px solid #e2e8f0; padding-top: 16px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="header">Elite Multiservicios</div>
    <p class="desc">Se ha solicitado el inicio de sesión en tu cuenta empresarial. Utiliza el siguiente código de verificación de 6 dígitos para completar el acceso:</p>
    <div class="code-box">$code</div>
    <p class="desc">Este código expira en 5 minutos. Si no solicitaste este código, ignorá este mensaje.</p>
    <div class="footer">Elite Multiservicios • Sistema de Seguridad y Gestión Centralizada</div>
  </div>
</body>
</html>
''';

    await _send(
      session: session,
      to: email,
      subject: subject,
      htmlContent: html,
      textFallback:
          'Tu código de verificación de seguridad (MFA) es: $code. Expira en 5 minutos. Si no solicitaste este código, ignorá este mensaje.',
    );
  }

  /// Despacha un correo electrónico vía SMTP configurado en session.passwords o env vars.
  static Future<void> _send({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    // 1. Leer de Platform.environment PRIMERO, con fallback a session.passwords.
    final host = Platform.environment['SMTP_HOST'] ??
        session.passwords['smtpHost'] ??
        'sandbox.smtp.mailtrap.io';
    final portStr = Platform.environment['SMTP_PORT'] ??
        session.passwords['smtpPort'] ??
        '2525';
    final port = int.tryParse(portStr) ?? 2525;
    final username = Platform.environment['SMTP_USERNAME'] ??
        session.passwords['smtpUsername'] ??
        '0139e7cf5c0c9a';
    final password = Platform.environment['SMTP_PASSWORD'] ??
        session.passwords['smtpPassword'];
    final fromEmail = Platform.environment['SMTP_FROM_EMAIL'] ??
        session.passwords['smtpFromEmail'] ??
        'soporte@elitemultiservicios.com';
    final fromName = Platform.environment['SMTP_FROM_NAME'] ??
        session.passwords['smtpFromName'] ??
        'Elite Multiservicios';

    // 2. Logs con print() para que aparezcan en Render stdout.
    print(
      '[MailService] Intentando enviar email a $to. Host: $host:$port, From: $fromEmail',
    );

    if (password == null || password.isEmpty) {
      print(
        '[MailService] ⚠️ SMTP_PASSWORD no configurado. Email NO enviado a $to.',
      );
      session.log(
        '⚠️ smtpPassword no configurado. Correo no enviado a $to.',
        level: LogLevel.warning,
      );
      return;
    }

    // 3. SSL según puerto (465 = SSL directo, 587 = STARTTLS, 25/2525 = sin SSL).
    final useSsl = port == 465;

    final smtpServer = SmtpServer(
      host,
      port: port,
      username: username,
      password: password,
      ssl: useSsl,
      allowInsecure: !useSsl && port != 587,
    );

    final message = mailer.Message()
      ..from = mailer.Address(fromEmail, fromName)
      ..recipients.add(to)
      ..subject = subject
      ..text = textFallback
      ..html = htmlContent;

    try {
      final sendReport = await mailer.send(message, smtpServer);
      print('[MailService] ✅ Correo enviado a $to. Reporte: $sendReport');
      session.log(
        '[MailService] Correo enviado exitosamente a $to ($subject).',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      print('[MailService] ❌ Error enviando a $to: $e');
      session.log(
        '[MailService] Error despachando correo a $to: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
