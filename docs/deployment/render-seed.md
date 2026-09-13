# Seed del Admin en Render

## Cómo funciona
- El script `entrypoint.sh` evalúa la variable de entorno `SEED_ON_START`.
- Si `SEED_ON_START=true`, añade el flag `--seed` a los argumentos de ejecución del servidor.
- El seed es **idempotente**: si el usuario administrador y los roles/permisos canónicos ya existen en la base de datos, no los recrea ni duplica (únicamente sincroniza la contraseña si se actualizó `SEED_ADMIN_PASSWORD`).

## Flujo de Despliegue
1. **Primer deploy**: Configurar en Render `SEED_ON_START=true` junto con `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD` → El administrador y los roles se crean automáticamente.
2. **Después del primer login verificado**: Cambiar en Render `SEED_ON_START=false` para optimizar los tiempos de inicio de los próximos deploys.
3. **Próximos deploys**: El servidor arrancará directamente sin ejecutar el proceso de sembrado.

## Cómo verificar que el seed corrió
En **Render Dashboard** → **elite-backend** → pestaña **Logs**:
```
==> [entrypoint] Seed habilitado (SEED_ON_START=true)
Ejecutando seed de seguridad en PostgreSQL...
Seed de seguridad completado exitosamente con usuario admin: admin@elitemultiservicios.com.
```

En **Supabase Dashboard** → **Table Editor** → tabla `app_user`:
- Debe figurar 1 registro con el correo del administrador configurado.

## Variables de Entorno Requeridas
- `SEED_ADMIN_EMAIL`: Correo electrónico del administrador inicial.
- `SEED_ADMIN_PASSWORD`: Contraseña segura para el administrador (mínimo 10 caracteres, incluyendo mayúsculas, minúsculas, números y caracteres especiales).
- `SEED_ON_START`: `true` para activar el sembrado en el arranque; `false` para omitirlo.
