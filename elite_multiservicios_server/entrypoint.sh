#!/bin/sh
# ==============================================================================
# Entrypoint de Elite Multiservicios - Backend Serverpod
# ==============================================================================
# Mapea las env vars genéricas (DATABASE_*, REDIS_*) a las env vars nativas
# que Serverpod 3.x espera (SERVERPOD_DATABASE_*, SERVERPOD_REDIS_*).
#
# Esto permite usar nombres genéricos en Render y mantener compatibilidad
# con Serverpod.
# ==============================================================================

# Mapear DATABASE_* -> SERVERPOD_DATABASE_*
export SERVERPOD_DATABASE_HOST="${SERVERPOD_DATABASE_HOST:-$DATABASE_HOST}"
export SERVERPOD_DATABASE_PORT="${SERVERPOD_DATABASE_PORT:-$DATABASE_PORT}"
export SERVERPOD_DATABASE_NAME="${SERVERPOD_DATABASE_NAME:-$DATABASE_NAME}"
export SERVERPOD_DATABASE_USER="${SERVERPOD_DATABASE_USER:-$DATABASE_USER}"
export SERVERPOD_DATABASE_REQUIRE_SSL="${SERVERPOD_DATABASE_REQUIRE_SSL:-true}"

# Mapear SERVERPOD_PASSWORD_database si viene como DATABASE_PASSWORD
export SERVERPOD_PASSWORD_database="${SERVERPOD_PASSWORD_database:-$DATABASE_PASSWORD}"

# Mapear REDIS_* -> SERVERPOD_REDIS_*
export SERVERPOD_REDIS_HOST="${SERVERPOD_REDIS_HOST:-$REDIS_HOST}"
export SERVERPOD_REDIS_PORT="${SERVERPOD_REDIS_PORT:-$REDIS_PORT}"
export SERVERPOD_REDIS_ENABLED="${SERVERPOD_REDIS_ENABLED:-true}"

# Render Key Value (Redis) no usa contraseña.
# Si no hay REDIS_PASSWORD explícito, des-exportamos SERVERPOD_PASSWORD_redis
# para prevenir el error "AUTH called without any password configured".
if [ -z "$REDIS_PASSWORD" ]; then
    unset SERVERPOD_PASSWORD_redis
else
    export SERVERPOD_PASSWORD_redis="$REDIS_PASSWORD"
fi

# Ejecutar el binario con los argumentos originales
exec /app/bin/server "$@"
