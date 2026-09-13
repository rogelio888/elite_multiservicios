# Conexión a Supabase desde Serverpod

## Importante
- **NO usar el Transaction Pooler** (puerto 6543). Rompe `PREPARE` statements (`42P05: prepared statement already exists`) que el driver de PostgreSQL en Serverpod utiliza.
- **USAR el Session Pooler** (puerto 5432) con límite de conexiones controlado.

## Configuración correcta
- `DATABASE_HOST`: `aws-0-us-east-2.pooler.supabase.com` (o el host del pooler asignado por Supabase)
- `DATABASE_PORT`: `5432` (Modo Session Pooler)
- `DATABASE_NAME`: `postgres`
- `DATABASE_USER`: `postgres.<project-ref>` (ej. `postgres.cbhupysmnkkusegdfdwo`)
- `DATABASE_PASSWORD`: (contraseña configurada en Supabase)

## Límites del plan free

- **Session Pooler (puerto 5432)**: máximo 15 conexiones concurrentes (`EMAXCONNSESSION`).
- **Transaction Pooler (puerto 6543)**: soporta hasta 200 conexiones, pero rompe `PREPARE` statements requeridos por Serverpod.
- **Direct connection**: suele operar sobre IPv6 directo (no alcanzable en redes IPv4-only sin add-on).

## Configuración de Serverpod
En `config/production.yaml`:
```yaml
database:
  maxConnectionCount: 3 # Conservador para el plan free
```
Con `maxConnectionCount: 3`, la instancia del backend ocupa ~3 conexiones activas para el pool de la app, dejando margen suficiente para healthchecks, migraciones y sesiones administrativas sin alcanzar el límite de 15 del Session Pooler.

## Si necesitás más conexiones
- **Opción A (Recomendada)**: Migrar al plan Pro de Supabase ($25/mes → 60+ conexiones directas/session).
- **Opción B**: Serverpod 3.4.13 **NO soporta** `usePreparedStatements: false` (el driver `package:postgres` v3 en Serverpod ejecuta sentencias preparadas de forma nativa e incondicional, por lo que el Transaction Pooler en puerto 6543 no es viable actualmente).
- **Opción C**: Migrar a Neon PostgreSQL u otro proveedor con límites más amplios en tier gratuito.

## Configuración de Redis en Render
- Render Key Value interno **no tiene contraseña**.
- `entrypoint.sh` des-exporta `SERVERPOD_PASSWORD_redis` si `REDIS_PASSWORD` no está definido, previniendo el fallo `AUTH called without any password configured`.
