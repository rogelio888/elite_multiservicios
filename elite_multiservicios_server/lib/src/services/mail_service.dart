// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
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

  /// Despacha un correo electrónico vía la API HTTP de Resend (evita bloqueo de puertos SMTP en Render).
  static Future<void> _send({
    required Session session,
    required String to,
    required String subject,
    required String htmlContent,
    required String textFallback,
  }) async {
    final apiKey =
        Platform.environment['RESEND_API_KEY'] ??
        Platform.environment['SMTP_PASSWORD'] ??
        session.passwords['resendApiKey'];
    final fromEmail =
        Platform.environment['SMTP_FROM_EMAIL'] ?? 'onboarding@resend.dev';
    final fromName =
        Platform.environment['SMTP_FROM_NAME'] ?? 'Elite Multiservicios';

    print('[MailService] Enviando a $to vía Resend HTTP API. From: $fromEmail');

    if (apiKey == null || apiKey.isEmpty) {
      print(
        '[MailService] ⚠️ RESEND_API_KEY no configurada. Email NO enviado a $to.',
      );
      session.log(
        '⚠️ RESEND_API_KEY no configurada. Correo no enviado a $to.',
        level: LogLevel.warning,
      );
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
          '[MailService] ✅ Email enviado a $to. Status: ${response.statusCode}',
        );
        session.log(
          '[MailService] Correo enviado a $to ($subject).',
          level: LogLevel.info,
        );
      } else {
        print(
          '[MailService] ❌ Resend error ${response.statusCode}: $responseBody',
        );
        session.log(
          '[MailService] Error enviando a $to: ${response.statusCode} - $responseBody',
          level: LogLevel.error,
        );
        throw Exception('Resend API error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[MailService] ❌ Excepción a $to: $e');
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
