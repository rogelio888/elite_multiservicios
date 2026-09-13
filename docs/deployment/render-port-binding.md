# Render: Port Binding y Healthcheck

## Cómo funciona Render
- Render asigna un puerto dinámico (`$PORT`) a cada Web Service.
- En plan free, `$PORT` es **10000** por defecto (a menos que se declare otra variable `PORT` en el Dashboard o Dockerfile).
- El healthcheck de Render va a `<hostname>:<PORT>/<healthPath>`.
- **La aplicación DEBE escuchar en `$PORT`** para que Render pueda rutear el tráfico externo y validar la salud.

## Serverpod y Render
- Serverpod escucha en puertos fijos (`8080` para API Server y `8082` para Web Server) por defecto según `production.yaml`.
- Serverpod 3.x soporta variables de entorno nativas para sobreescribir los puertos de escucha:
  - `SERVERPOD_API_SERVER_PORT`: puerto del servidor API principal (RPC y probes).
  - `SERVERPOD_WEB_SERVER_PORT`: puerto del servidor Web (assets estáticos y rutas web custom).
- **Solución implementada**: en `entrypoint.sh` se mapea automáticamente `$PORT` a `SERVERPOD_API_SERVER_PORT`.

## Problema del Healthcheck
- Render manda `GET <healthPath>` al puerto donde está bindeado el servicio (`:PORT`).
- En el API Server (`SERVERPOD_API_SERVER_PORT`), los endpoints de salud nativos de Serverpod son:
  - `/livez` (Liveness probe → HTTP 200)
  - `/readyz` (Readiness probe → HTTP 200)
  - `/` (Ping básico → HTTP 200)
- La ruta `/health` customizada del proyecto se encuentra registrada en el Web Server (`8082`), por lo que si Render consulta `/health` contra el API Server, recibirá un HTTP 404.
- **Configuración recomendada en Render**:
  - **Health Check Path**: `/livez` (o dejarlo vacío para evitar demoras).
