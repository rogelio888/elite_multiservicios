// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

/// Servicio para orquestar y despachar correos electrónicos transaccionales.
/// - Entorno local / desarrollo: Mailtrap vía SMTP.
/// - Entorno producción: Resend vía API HTTP.
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

  /// Despacha el correo según el entorno:
  /// Despacha el correo según el entorno:
  /// - En producción (Render / Cloud): Brevo HTTP API (o Resend como alternativa).
  /// - En local / desarrollo: Mailtrap SMTP Sandbox (los correos quedan en el buzón de prueba).
  /// - Opcional: Si se desea probar Brevo en local explícitamente, definir MAIL_DRIVER=brevo en .env.
  static Future<void> _send({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final runMode = session.serverpod.runMode;
    final isProduction =
        runMode == 'production' ||
        Platform.environment['SERVERPOD_ENV'] == 'production';

    final forceBrevoInLocal =
        Platform.environment['MAIL_DRIVER'] == 'brevo' ||
        Platform.environment['FORCE_REAL_MAIL'] == 'true';

    final brevoApiKey =
        Platform.environment['BREVO_API_KEY'] ??
        session.passwords['brevoApiKey'];

    if (isProduction || forceBrevoInLocal) {
      if (brevoApiKey != null && brevoApiKey.isNotEmpty) {
        await _sendViaBrevo(
          session: session,
          apiKey: brevoApiKey,
          to: to,
          subject: subject,
          htmlContent: htmlContent,
          textFallback: textFallback,
        );
      } else {
        await _sendViaResend(
          session: session,
          to: to,
          subject: subject,
          htmlContent: htmlContent,
          textFallback: textFallback,
        );
      }
    } else {
      // Desarrollo local: Siempre Mailtrap SMTP Sandbox
      await _sendViaMailtrap(
        session: session,
        to: to,
        subject: subject,
        htmlContent: htmlContent,
        textFallback: textFallback,
      );
    }
  }

  /// Despacho vía Brevo HTTP API (ideal para producción sin requerir dominio propio).
  static Future<void> _sendViaBrevo({
    required Session session,
    required String apiKey,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final fromEmail =
        Platform.environment['SMTP_FROM_EMAIL'] ??
        session.passwords['smtpFromEmail'] ??
        'soporte@elitemultiservicios.com';
    final fromName =
        Platform.environment['SMTP_FROM_NAME'] ??
        session.passwords['smtpFromName'] ??
        'Elite Multiservicios';

    print(
      '[MailService] [Brevo API] Enviando a $to vía Brevo HTTP API. From: $fromEmail',
    );

    final payload = {
      'sender': {'name': fromName, 'email': fromEmail},
      'to': [
        {'email': to},
      ],
      'subject': subject,
      'htmlContent': htmlContent,
      'textContent': textFallback,
    };

    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri.parse('https://api.brevo.com/v3/smtp/email'),
      );
      request.headers.set('api-key', apiKey);
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');
      final bodyBytes = utf8.encode(jsonEncode(payload));
      request.add(bodyBytes);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(
          '[MailService] [Brevo API] ✅ Email enviado exitosamente a $to. Status: ${response.statusCode}',
        );
        session.log(
          '[MailService] Correo enviado a $to ($subject) vía Brevo.',
          level: LogLevel.info,
        );
      } else {
        print(
          '[MailService] [Brevo API] ❌ Brevo error ${response.statusCode}: $responseBody',
        );
        session.log(
          '[MailService] Error enviando a $to vía Brevo: ${response.statusCode} - $responseBody',
          level: LogLevel.error,
        );
        throw Exception(
          'Brevo API error: ${response.statusCode} - $responseBody',
        );
      }
    } catch (e, stackTrace) {
      print('[MailService] [Brevo API] ❌ Excepción a $to: $e');
      session.log(
        '[MailService] Excepción a $to vía Brevo: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Despacho en desarrollo local vía Mailtrap SMTP.
  static Future<void> _sendViaMailtrap({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final host =
        session.passwords['smtpHost'] ??
        Platform.environment['MAILTRAP_HOST'] ??
        Platform.environment['SMTP_HOST'] ??
        'sandbox.smtp.mailtrap.io';
    final portStr =
        session.passwords['smtpPort'] ??
        Platform.environment['MAILTRAP_PORT'] ??
        Platform.environment['SMTP_PORT'] ??
        '2525';
    final port = int.tryParse(portStr) ?? 2525;
    final username =
        session.passwords['smtpUsername'] ??
        Platform.environment['MAILTRAP_USER'] ??
        Platform.environment['SMTP_USER'] ??
        '0139e7cf5c0c9a';
    final password =
        session.passwords['smtpPassword'] ??
        Platform.environment['MAILTRAP_PASS'] ??
        Platform.environment['SMTP_PASSWORD'] ??
        '67513db99d0e49';
    final fromEmail =
        session.passwords['smtpFromEmail'] ??
        Platform.environment['SMTP_FROM_EMAIL'] ??
        'soporte@elitemultiservicios.com';
    final fromName =
        session.passwords['smtpFromName'] ??
        Platform.environment['SMTP_FROM_NAME'] ??
        'Elite Multiservicios';

    print(
      '[MailService] [Local/Mailtrap] Despachando a $to vía $host:$port ($fromEmail)...',
    );

    if (password.isEmpty) {
      final msg =
          '⚠️ [MailService] Mailtrap password no configurada. Correo no enviado a $to. Contenido: $textFallback';
      print(msg);
      session.log(msg, level: LogLevel.warning);
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
      print(
        '[MailService] [Local/Mailtrap] ✅ Correo enviado exitosamente a $to ($subject). Reporte: $sendReport',
      );
      session.log(
        '[MailService] Correo enviado exitosamente a $to ($subject) vía Mailtrap.',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      print('[MailService] [Local/Mailtrap] ❌ Error despachando a $to: $e');
      session.log(
        '[MailService] Error despachando correo a $to vía Mailtrap: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Despacho en producción vía Resend HTTP API.
  static Future<void> _sendViaResend({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final apiKey =
        Platform.environment['RESEND_API_KEY'] ??
        session.passwords['resendApiKey'] ??
        Platform.environment['SMTP_PASSWORD'];
    final fromEmail =
        Platform.environment['SMTP_FROM_EMAIL'] ?? 'onboarding@resend.dev';
    final fromName =
        Platform.environment['SMTP_FROM_NAME'] ?? 'Elite Multiservicios';

    print(
      '[MailService] [Producción/Resend] Enviando a $to vía Resend HTTP API. From: $fromEmail',
    );

    if (apiKey == null || apiKey.isEmpty) {
      final msg =
          '⚠️ [MailService] RESEND_API_KEY no configurada en producción. Email NO enviado a $to.';
      print(msg);
      session.log(msg, level: LogLevel.warning);
      return;
    }

    final payload = {
      'from': '$fromName <$fromEmail>',
      'to': [to],
      'subject': subject,
      'html': htmlContent,
      'text': textFallback,
    };

    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri.parse('https://api.resend.com/emails'),
      );
      request.headers.set('Authorization', 'Bearer $apiKey');
      request.headers.set('Content-Type', 'application/json');
      final bodyBytes = utf8.encode(jsonEncode(payload));
      request.add(bodyBytes);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(
          '[MailService] [Producción/Resend] ✅ Email enviado a $to. Status: ${response.statusCode}',
        );
        session.log(
          '[MailService] Correo enviado a $to ($subject) vía Resend.',
          level: LogLevel.info,
        );
      } else {
        print(
          '[MailService] [Producción/Resend] ❌ Resend error ${response.statusCode}: $responseBody',
        );
        session.log(
          '[MailService] Error enviando a $to: ${response.statusCode} - $responseBody',
          level: LogLevel.error,
        );
        throw Exception('Resend API error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(
        '[MailService] [Producción/Resend] ❌ Excepción a $to: $e',
      );
      session.log(
        '[MailService] Excepción a $to: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      client.close();
    }
  }
}
