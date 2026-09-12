# Variables Manuales en Render

Después del primer deploy vía Blueprint (o durante el asistente de creación en el Dashboard), configurar:

## Backend (`elite-backend` - Web Service Docker)
| Variable | Valor | Dónde obtenerlo |
|---|---|---|
| `SMTP_HOST` | `smtp.resend.com` | Fijo |
| `SMTP_PASSWORD` | `re_xxxxx` | https://resend.com/api-keys |
| `SEED_ADMIN_PASSWORD` | `(contraseña fuerte)` | Elegida por vos (10+ caracteres, mayúscula, minúscula, número, símbolo) |

## Frontend (`elite-frontend` - Web Service Docker + Nginx)
| Variable | Valor | Dónde obtenerlo |
|---|---|---|
| `SERVER_URL` | `https://elite-backend.onrender.com/` | URL pública del backend en Render (se pasa automáticamente como build-arg) |

## Cómo setearlas

### Opción A: Dashboard
1. https://dashboard.render.com/
2. Click en el servicio respectivo.
3. Environment → Add Environment Variable.

### Opción B: CLI
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
render env set elite-backend SMTP_HOST=smtp.resend.com
render env set elite-backend SMTP_PASSWORD=re_xxxxx
render env set elite-backend SEED_ADMIN_PASSWORD=xxxxx
render env set elite-frontend SERVER_URL=https://elite-backend.onrender.com/
```
