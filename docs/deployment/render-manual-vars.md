# Variables Manuales en Render

Después del primer deploy vía Blueprint (o durante el asistente de creación en el Dashboard), configurar:

## Backend (`elite-backend` - Web Service Docker)

| Variable | Valor | Dónde |
|---|---|---|
| `DATABASE_HOST` | `aws-0-us-east-2.pooler.supabase.com` | Supabase Dashboard |
| `DATABASE_PORT` | `6543` | Fijo |
| `DATABASE_NAME` | `postgres` | Fijo |
| `DATABASE_USER` | `postgres.cbhupysmnkkusegdfdwo` | Supabase Dashboard |
| `DATABASE_PASSWORD` | `(password de Supabase)` | Elegida por vos |
| `SERVERPOD_PASSWORD_database` | `(mismo)` | Elegida por vos |
| `SMTP_HOST` | `smtp.resend.com` | Fijo |
| `SMTP_PASSWORD` | `(API key de Resend)` | https://resend.com/api-keys |
| `SEED_ADMIN_PASSWORD` | `(contraseña fuerte)` | Elegida por vos |

---

## Frontend (`elite-frontend` - Web Service Docker + Nginx)

| Variable | Valor | Dónde |
|---|---|---|
| `SERVER_URL` | `https://elite-backend.onrender.com/` | Render Dashboard |

---

## Cómo setearlas

### Opción A: Dashboard
1. https://dashboard.render.com/
2. Click en el servicio respectivo.
3. Environment → Add Environment Variable.

### Opción B: CLI
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
render env set elite-backend DATABASE_HOST=aws-0-us-east-2.pooler.supabase.com
render env set elite-backend DATABASE_PORT=6543
render env set elite-backend DATABASE_NAME=postgres
render env set elite-backend DATABASE_USER=postgres.cbhupysmnkkusegdfdwo
render env set elite-backend DATABASE_PASSWORD=<password>
render env set elite-backend SERVERPOD_PASSWORD_database=<password>
render env set elite-backend SMTP_HOST=smtp.resend.com
render env set elite-backend SMTP_PASSWORD=re_xxxxx
render env set elite-backend SEED_ADMIN_PASSWORD=xxxxx
render env set elite-frontend SERVER_URL=https://elite-backend.onrender.com/
```
