# Regla: Uso de Render CLI

## Qué es
Render CLI permite gestionar servicios de Render desde la terminal.

## Configuración
- **Instalación**: `winget install render.cli`
- **Autenticación**: `render login` (el humano, una sola vez)
- **Archivo de config**: `C:\Users\rogel\.render\config.yaml` (fuera del repo)

## Seguridad
- ✅ La IA puede invocar `render <comando>` sin ver la API key.
- ❌ La IA NO debe leer `RENDER_API_KEY` del `.env`.
- ❌ La IA NO debe ejecutar comandos con `rnd_` visible.
- ❌ La IA NO debe diagnosticar el CLI con curl/fetch/spawn.
- ❌ La IA NO debe usar el MCP de Render (fue desinstalado).

## Comandos útiles

### Servicios
- `render services list` — Listar todos los servicios
- `render services list --type web_service` — Filtrar por tipo
- `render services get <id>` — Detalles de un servicio

### Deploys
- `render deploys list <service-id>` — Listar deploys
- `render deploys get <deploy-id>` — Estado de un deploy
- `render deploys create <service-id>` — Trigger deploy
- `render logs <service-id> --tail` — Logs en tiempo real

### Bases de datos
- `render databases list` — Listar PostgreSQL + Redis
- `render databases get <db-id>` — Detalles

### Env vars
- `render env list <service-id>` — Listar env vars
- `render env set <service-id> KEY=value` — Setear env var
- `render env unset <service-id> KEY` — Remover env var

## Cómo usarlo

✅ **Correcto**:
- La IA invoca: `render services list`
- La IA ve: [lista de servicios]
- La IA reporta: "Hay 9 servicios."

❌ **Incorrecto**:
- La IA invoca: `curl -H "Authorization: Bearer rnd_xxx" ...`
- La IA ve: la key en el comando
- La IA reporta: comando con la key visible

## Documentación oficial
- CLI docs: https://render.com/docs/cli
- API docs: https://api-docs.render.com/
