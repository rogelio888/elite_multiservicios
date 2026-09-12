# Variables de Entorno para Producción

## PostgreSQL (Render)
- `DATABASE_HOST`: Host de PostgreSQL (ej. `dpg-xxx.render.com`)
- `DATABASE_PORT`: `5432`
- `DATABASE_NAME`: `elite_multiservicios`
- `DATABASE_USER`: `elite_user`
- `DATABASE_PASSWORD`: contraseña de Render

## Serverpod
- `SERVERPOD_MODE`: `production`
- `SERVERPOD_PASSWORD_database`: igual a `DATABASE_PASSWORD`
- `SERVERPOD_PASSWORD_redis`: contraseña de Redis
- `SERVERPOD_PASSWORD_emailSecretHashPepper`: pepper para hashing
- `SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey`: clave HMAC para JWT
- `SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper`: pepper para refresh tokens

## Redis (Render)
- `REDIS_HOST`: host de Redis
- `REDIS_PORT`: `6379`
- `REDIS_PASSWORD`: contraseña de Redis

## SMTP (Resend)
- `SMTP_HOST`: `smtp.resend.com`
- `SMTP_PORT`: `465`
- `SMTP_USERNAME`: `resend`
- `SMTP_PASSWORD`: API key de Resend
- `SMTP_FROM_EMAIL`: `noreply@elitemultiservicios.com`
- `SMTP_FROM_NAME`: `Elite Multiservicios`

## Seed
- `SEED_ADMIN_EMAIL`: `admin@elitemultiservicios.com`
- `SEED_ADMIN_PASSWORD`: contraseña inicial (rotar después del primer login)
- `SEED_ON_START`: `true` solo el primer deploy, después `false`
