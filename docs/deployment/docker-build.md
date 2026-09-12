# Build y Test Local del Backend

## Build
```bash
cd elite_multiservicios_server
docker build -t elite-backend:test .
```

## Test local (con Docker Desktop corriendo)
```bash
# 1. Levantar PostgreSQL + Redis local
docker compose up -d

# 2. Arrancar el backend en Docker
docker run --rm \
  --network host \
  -e DATABASE_HOST=host.docker.internal \
  -e DATABASE_PORT=8090 \
  -e DATABASE_NAME=elite_multiservicios \
  -e DATABASE_USER=postgres \
  -e DATABASE_PASSWORD=xxx \
  -e SERVERPOD_PASSWORD_database=xxx \
  -e SERVERPOD_PASSWORD_redis=xxx \
  -p 8080:8080 -p 8082:8082 \
  elite-backend:test

# 3. Verificar
curl http://localhost:8082/health
```
