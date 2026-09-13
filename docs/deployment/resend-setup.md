# Resend: Configuración SMTP para producción

## Variables en Render (elite-backend → Environment)
- `SMTP_HOST` = `smtp.resend.com`
- `SMTP_PORT` = `465` (SSL directo) o `587` (STARTTLS)
- `SMTP_USERNAME` = `resend`
- `SMTP_PASSWORD` = API key de Resend (`re_...`)
- `SMTP_FROM_EMAIL` = `onboarding@resend.dev` (plan free) o dominio verificado
- `SMTP_FROM_NAME` = `Elite Multiservicios`

## Plan free de Resend
- **NO permite** enviar desde dominios personalizados no verificados (como `@elitemultiservicios.com`).
- **Solución temporal obligatoria**: Usar `onboarding@resend.dev` como `SMTP_FROM_EMAIL`.
- **Restricción de destinatario en plan free**: Sin dominio verificado, Resend solo despacha correos a la dirección de email con la que te registraste en Resend.
- **Solución definitiva**: Verificar tu dominio institucional en https://resend.com/domains configurando los registros DNS correspondientes (DKIM, SPF y MX).

## Debugging
Si los correos no llegan:
1. Verificar los logs en Render (`[MailService]` ahora emite trazas detalladas a `stdout`).
2. Verificar la sección de eventos y entrega en https://resend.com/emails.
3. Confirmar que el campo `FROM` sea exactamente `onboarding@resend.dev` o un dominio verificado.
4. Confirmar que la API key tenga permiso "Sending access" o "Full access".
