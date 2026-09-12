# ==============================================================================
# Elite Multiservicios - Frontend Flutter Web
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder (Flutter Web)
# ------------------------------------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Argumento para la URL del backend (Render traduce envVars a build args automáticamente)
ARG SERVER_URL=http://localhost:8080/

# Copiar archivos del monorepo necesarios para compilar el frontend
COPY pubspec.lock ./
COPY elite_multiservicios_client/ ./elite_multiservicios_client/
COPY elite_multiservicios_flutter/ ./elite_multiservicios_flutter/

# Configurar un workspace mínimo para compilar el frontend de forma aislada
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.8.0' \
  'workspace:' \
  '  - elite_multiservicios_client' \
  '  - elite_multiservicios_flutter' \
  > pubspec.yaml

# Instalar dependencias
RUN flutter pub get

# Compilar Flutter Web
WORKDIR /app/elite_multiservicios_flutter
RUN flutter build web --release --dart-define=SERVER_URL=$SERVER_URL

# ------------------------------------------------------------------------------
# Stage 2: Runtime (Nginx)
# ------------------------------------------------------------------------------
FROM nginx:alpine

# Copiar el bundle web compilado
COPY --from=builder /app/elite_multiservicios_flutter/build/web /usr/share/nginx/html

# Configuración de Nginx para Single Page Application (SPA)
RUN printf '%s\n' \
  'server {' \
  '    listen 80;' \
  '    server_name _;' \
  '    root /usr/share/nginx/html;' \
  '    index index.html;' \
  '    location / {' \
  '        try_files $uri $uri/ /index.html;' \
  '    }' \
  '    gzip on;' \
  '    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;' \
  '}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
