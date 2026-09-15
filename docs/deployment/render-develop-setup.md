# Configuración de Blueprint en Render para Rama `develop` (Staging)

Este documento detalla el procedimiento para desplegar automáticamente el entorno de pruebas/staging de la rama `develop` en Render, permitiendo verificar los cambios integrados antes de promoverlos a `main` (producción).

---

## 1. Servicios del Entorno `develop`

Definidos en [`render-develop.yaml`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/render-develop.yaml):

| Servicio | Tipo | Rama | URL por defecto |
|---|---|---|---|
| `elite-backend-dev` | Web Service (Docker / Serverpod) | `develop` | `https://elite-backend-dev.onrender.com` |
| `elite-frontend-dev` | Web Service (Docker / Flutter Web + Nginx) | `develop` | `https://elite-frontend-dev.onrender.com` |
| `elite-redis-dev` | Key-Value (Redis) | — | Interno en Render |

---

## 2. Pasos para Crear la Instancia de Blueprint en Render

1. Entrar a [Render Dashboard > Blueprints](https://dashboard.render.com/blueprints).
2. Hacer clic en **New Blueprint Instance**.
3. Seleccionar el repositorio: `rogelio888/elite_multiservicios`.
4. En la configuración de la instancia:
   - **Branch:** Seleccionar `develop`.
   - **Blueprint Path:** Ingresar `render-develop.yaml`.
5. Hacer clic en **Apply**. Render creará los 3 recursos aislados para desarrollo.

---

## 3. Variables Manuales de Entorno para `develop`

### Backend (`elite-backend-dev`)
Configurar en Render Dashboard (`elite-backend-dev > Environment`):

| Variable | Valor Recomendado | Origen |
|---|---|---|
| `DATABASE_HOST` | Host de base de datos PostgreSQL de desarrollo (Supabase / Postgres) | Supabase Dashboard |
| `DATABASE_PORT` | `6543` o `5432` | Supabase Dashboard |
| `DATABASE_NAME` | `postgres` | Supabase Dashboard |
| `DATABASE_USER` | Usuario de base de datos | Supabase Dashboard |
| `DATABASE_PASSWORD` | Contraseña de base de datos | Supabase Dashboard |
| `SERVERPOD_PASSWORD_database` | Misma contraseña que `DATABASE_PASSWORD` | Supabase Dashboard |
| `SMTP_HOST` | `smtp.resend.com` | Resend |
| `SMTP_PASSWORD` | API Key de Resend (`re_...`) | Resend |
| `SEED_ADMIN_PASSWORD` | Contraseña administrativa segura para staging | Generada por vos |

### Frontend (`elite-frontend-dev`)
Configurar en Render Dashboard (`elite-frontend-dev > Environment`):

| Variable | Valor |
|---|---|
| `SERVER_URL` | `https://elite-backend-dev.onrender.com/` |

---

## 4. Validación Local

Para verificar que ambos blueprints (`render.yaml` y `render-develop.yaml`) se mantengan válidos según la CLI de Render:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-blueprint.ps1 -All
```
