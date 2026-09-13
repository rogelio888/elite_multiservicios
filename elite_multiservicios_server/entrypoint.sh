#!/bin/sh
# ==============================================================================
# Entrypoint de Elite Multiservicios - Backend Serverpod
# ==============================================================================
# Mapea las env vars genéricas (DATABASE_*, REDIS_*) a las env vars nativas
# que Serverpod 3.x espera (SERVERPOD_DATABASE_*, SERVERPOD_REDIS_*).
#
# IMPORTANTE: Nunca exportar variables con string vacío "", porque Serverpod
# intenta parsearlas con int.parse() o bool.parse() y falla fatalmente.
# ==============================================================================

echo "==> [entrypoint] Preparando entorno de Serverpod..."

# Database Host
if [ -n "$SERVERPOD_DATABASE_HOST" ]; then
    export SERVERPOD_DATABASE_HOST
elif [ -n "$DATABASE_HOST" ]; then
    export SERVERPOD_DATABASE_HOST="$DATABASE_HOST"
fi

# Database Port
if [ -n "$SERVERPOD_DATABASE_PORT" ]; then
    export SERVERPOD_DATABASE_PORT
elif [ -n "$DATABASE_PORT" ]; then
    export SERVERPOD_DATABASE_PORT="$DATABASE_PORT"
fi

# Database Name
if [ -n "$SERVERPOD_DATABASE_NAME" ]; then
    export SERVERPOD_DATABASE_NAME
elif [ -n "$DATABASE_NAME" ]; then
    export SERVERPOD_DATABASE_NAME="$DATABASE_NAME"
fi

# Database User
if [ -n "$SERVERPOD_DATABASE_USER" ]; then
    export SERVERPOD_DATABASE_USER
elif [ -n "$DATABASE_USER" ]; then
    export SERVERPOD_DATABASE_USER="$DATABASE_USER"
fi

# Database Require SSL (default true en producción para Supabase)
export SERVERPOD_DATABASE_REQUIRE_SSL="${SERVERPOD_DATABASE_REQUIRE_SSL:-true}"

# Database Max Connection Count (default 3 para plan free de Supabase)
if [ -n "$SERVERPOD_DATABASE_MAX_CONNECTION_COUNT" ]; then
    export SERVERPOD_DATABASE_MAX_CONNECTION_COUNT
elif [ -n "$DATABASE_MAX_CONNECTION_COUNT" ]; then
    export SERVERPOD_DATABASE_MAX_CONNECTION_COUNT="$DATABASE_MAX_CONNECTION_COUNT"
else
    export SERVERPOD_DATABASE_MAX_CONNECTION_COUNT="3"
fi

# Database Password
if [ -n "$SERVERPOD_PASSWORD_database" ]; then
    export SERVERPOD_PASSWORD_database
elif [ -n "$DATABASE_PASSWORD" ]; then
    export SERVERPOD_PASSWORD_database="$DATABASE_PASSWORD"
fi

# Redis Host
if [ -n "$SERVERPOD_REDIS_HOST" ]; then
    export SERVERPOD_REDIS_HOST
elif [ -n "$REDIS_HOST" ]; then
    export SERVERPOD_REDIS_HOST="$REDIS_HOST"
fi

# Redis Port
if [ -n "$SERVERPOD_REDIS_PORT" ]; then
    export SERVERPOD_REDIS_PORT
elif [ -n "$REDIS_PORT" ]; then
    export SERVERPOD_REDIS_PORT="$REDIS_PORT"
fi

# Redis Enabled (solo habilitar si hay host configurado)
if [ -n "$REDIS_HOST" ] || [ -n "$SERVERPOD_REDIS_HOST" ]; then
    export SERVERPOD_REDIS_ENABLED="true"
else
    export SERVERPOD_REDIS_ENABLED="false"
fi

# Redis Password: Render Key Value no tiene contraseña
if [ -n "$REDIS_PASSWORD" ]; then
    export SERVERPOD_PASSWORD_redis="$REDIS_PASSWORD"
else
    unset SERVERPOD_PASSWORD_redis
fi

echo "==> [entrypoint] Configuración procesada:"
echo "    SERVERPOD_DATABASE_HOST=${SERVERPOD_DATABASE_HOST:-[desde yaml]}"
echo "    SERVERPOD_DATABASE_PORT=${SERVERPOD_DATABASE_PORT:-[desde yaml]}"
echo "    SERVERPOD_DATABASE_NAME=${SERVERPOD_DATABASE_NAME:-[desde yaml]}"
echo "    SERVERPOD_DATABASE_USER=${SERVERPOD_DATABASE_USER:-[desde yaml]}"
echo "    SERVERPOD_REDIS_ENABLED=${SERVERPOD_REDIS_ENABLED}"
echo "==> [entrypoint] Ejecutando: /app/bin/server $@"

# Ejecutar el binario con los argumentos originales
exec /app/bin/server "$@"
