# Render bloquea SMTP saliente

## Problema
Render bloquea los puertos SMTP salientes 25, 465 y 587 (política anti-spam vigente).

**Error típico**:
```text
SocketException: Connection timed out, host: smtp.resend.com, port: 465
```

## Solución
Usar la **API HTTP** del proveedor en lugar de SMTP:
- **Resend**: `POST https://api.resend.com/emails`
- **SendGrid**: `POST https://api.sendgrid.com/v3/mail/send`
- **Mailgun**: `POST https://api.mailgun.net/v3/<domain>/messages`

## Configuración en el código
`MailService._send()` usa `HttpClient` (nativo de Dart) contra el endpoint HTTP de Resend en lugar de SMTP.

## Variables de entorno
- `SMTP_PASSWORD` o `RESEND_API_KEY`: API key de Resend (`re_...`).
- `SMTP_FROM_EMAIL`: `onboarding@resend.dev` (plan free) o dominio corporativo verificado.
- `SMTP_FROM_NAME`: `Elite Multiservicios`.

> **Nota:** Ya **NO se necesitan** `SMTP_HOST`, `SMTP_PORT` ni `SMTP_USERNAME`.

## Referencias
- Render docs: https://render.com/docs/outbound-smtp
- Resend API: https://resend.com/docs/api-reference/emails/send-email
