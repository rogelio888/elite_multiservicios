# Conexión a Supabase desde Serverpod

## Importante
- **NO usar el Connection Pooler** (puerto 6543). Rompe `PREPARE` statements (`42P05: prepared statement already exists`) que el driver de PostgreSQL en Serverpod utiliza.
- **USAR la conexión directa** (puerto 5432).

## Configuración correcta
- `DATABASE_HOST`: `db.<project-ref>.supabase.co` (ej. `db.cbhupysmnkkusegdfdwo.supabase.co`)
- `DATABASE_PORT`: `5432`
- `DATABASE_NAME`: `postgres`
- `DATABASE_USER`: `postgres` o `postgres.<project-ref>` (según la cadena de conexión directa indicada en Supabase)
- `DATABASE_PASSWORD`: (contraseña definida en Supabase)

## Límites del pooler
El connection pooler de Supabase (PgBouncer en modo transaction) **NO soporta**:
- `PREPARE` statements / prepared queries.
- Advisory locks.
- `LISTEN` / `NOTIFY`.

Serverpod requiere `PREPARE` statements para la ejecución tipada de sus consultas y migraciones, por lo cual es obligatorio conectarse directamente al puerto `5432`.

## Configuración de Redis en Render
- Render Key Value interno **no tiene contraseña**.
- `entrypoint.sh` se encarga de des-exportar `SERVERPOD_PASSWORD_redis` si `REDIS_PASSWORD` no está definido, previniendo el fallo `AUTH called without any password configured`.
