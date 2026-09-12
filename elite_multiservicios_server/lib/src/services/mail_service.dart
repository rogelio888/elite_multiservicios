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

  /// Despacha un correo electrónico vía SMTP configurado en session.passwords.
  static Future<void> _send({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final host = session.passwords['smtpHost'] ?? 'sandbox.smtp.mailtrap.io';
    final portStr = session.passwords['smtpPort'] ?? '2525';
    final port = int.tryParse(portStr) ?? 2525;
    final username = session.passwords['smtpUsername'] ?? '0139e7cf5c0c9a';
    final password = session.passwords['smtpPassword'];
    final fromEmail =
        session.passwords['smtpFromEmail'] ?? 'soporte@elitemultiservicios.com';
    final fromName =
        session.passwords['smtpFromName'] ?? 'Elite Multiservicios';

    if (password == null || password.isEmpty) {
      session.log(
        '⚠️ smtpPassword no configurado en passwords.yaml. Correo no enviado a $to. Contenido: $textFallback',
        level: LogLevel.warning,
      );
      return;
    }

    final smtpServer = SmtpServer(
      host,
      port: port,
      username: username,
      password: password,
      ssl: false,
      allowInsecure: true,
    );

    final message = mailer.Message()
      ..from = mailer.Address(fromEmail, fromName)
      ..recipients.add(to)
      ..subject = subject
      ..text = textFallback
      ..html = htmlContent;

    try {
      final sendReport = await mailer.send(message, smtpServer);
      session.log(
        '[MailService] Correo enviado exitosamente a $to ($subject). Reporte: $sendReport',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
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
