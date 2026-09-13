# ==============================================================================
# Elite Multiservicios - Backend Serverpod
# ==============================================================================
# Multi-stage build para minimizar el tamaño de la imagen final.
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder
# ------------------------------------------------------------------------------
FROM dart:stable AS builder

WORKDIR /app

# Copiar archivos del servidor al workspace de compilación
COPY . ./elite_multiservicios_server/

# Configurar un workspace mínimo para compilar el backend de forma aislada
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.8.0' \
  'workspace:' \
  '  - elite_multiservicios_server' \
  > pubspec.yaml

# Resolver dependencias del workspace
RUN dart pub get

# Compilar a ejecutable nativo
WORKDIR /app/elite_multiservicios_server
RUN mkdir -p /app/bin && dart compile exe bin/main.dart -o /app/bin/server

# ------------------------------------------------------------------------------
# Stage 2: Runtime
# ------------------------------------------------------------------------------
FROM debian:bookworm-slim

# Instalar dependencias runtime y herramientas necesarias (curl para healthcheck)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar ejecutable binario nativo
COPY --from=builder /app/bin/server /app/bin/server

# Copiar archivos de configuración, recursos web, migraciones y protocolo
COPY --from=builder /app/elite_multiservicios_server/config/ /app/config/
COPY --from=builder /app/elite_multiservicios_server/migrations/ /app/migrations/
COPY --from=builder /app/elite_multiservicios_server/web/ /app/web/
COPY --from=builder /app/elite_multiservicios_server/lib/src/generated/protocol.yaml /app/lib/src/generated/protocol.yaml

# Copiar script de entrypoint y otorgar permisos de ejecución
COPY --from=builder /app/elite_multiservicios_server/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Puertos expuestos: 8080 (API), 8081 (Insights), 8082 (Web)
ENV PORT=8080
EXPOSE 8080 8081 8082

# Healthcheck contra el API Server en puerto 8080 (/livez)
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/livez || exit 1

# Entrypoint y comando de arranque
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["--apply-migrations", "--mode", "production"]
