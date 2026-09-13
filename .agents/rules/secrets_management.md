# Regla: Manejo de Secretos en el Proyecto

## Principio fundamental
**Los secretos viven SOLO en `.env` local. NUNCA se exponen en chat, logs, commits o salidas de comandos.**

## Secretos del proyecto
- `RENDER_API_KEY`: API key de Render.
- `STITCH_API_KEY`: API key de Google Stitch.
- `RESEND_API_KEY`: API key de Resend (cuando se configure).
- `SEED_ADMIN_PASSWORD`: contraseña del admin seed.
- `DATABASE_PASSWORD`: contraseña de PostgreSQL local.
- `JWT_SECRET`: (si aplica).

## Cómo verificar sin exponer

✅ Correcto:
```powershell
if (Select-String -Path .env -Pattern '^RENDER_API_KEY=rnd_\S+') {
  Write-Output "✅ RENDER_API_KEY presente"
} else {
  Write-Output "❌ RENDER_API_KEY faltante"
}
```

❌ Incorrecto:
```powershell
Get-Content .env | Select-String "RENDER_API_KEY"
# Muestra el valor completo
```

## Cómo usar en comandos

✅ Correcto:
```powershell
$key = (Get-Content .env | Select-String '^RENDER_API_KEY=').ToString().Split('=')[1]
curl -H "Authorization: Bearer $key" https://api.render.com/v1/services
```

❌ Incorrecto:
```powershell
curl -H "Authorization: Bearer rnd_..." https://api.render.com/v1/services
# La key está visible en el chat
```

## Cómo mostrar archivos con secretos

✅ Correcto (redactado):
```json
{
  "env": {
    "RENDER_API_KEY": "<REDACTED>"
  }
}
```

❌ Incorrecto:
```json
{
  "env": {
    "RENDER_API_KEY": "rnd_..."
  }
}
```

## Uso del MCP de Render
- SIEMPRE usar el MCP `render/*` para operaciones de Render.
- NO usar curl directo salvo que sea estrictamente necesario y siguiendo las reglas de arriba.

## Si la API key se expone por error
1. Rotarla INMEDIATAMENTE en el dashboard.
2. Actualizar `.env` local.
3. Actualizar `mcp_config.json` (con node sin imprimir el valor).
4. Documentar el incidente en `docs/incidents/`.

## Referencias
- `.agents/rules/render_mcp.md`
- `.agents/rules/project_rules.md`

## REGLA BLOQUEANTE (crítica)

**SI** estás por ejecutar un comando que va a incluir un secreto visible (rnd_, Bearer, sk_, AKIA, ghp_, AQ., o cualquier valor del .env):
**ENTONCES** DETENETE INMEDIATAMENTE.

**SI** el comando necesita un secreto:
**ENTONCES**:
1. Leer el secreto del `.env` como variable local:
   ```powershell
   $key = (Get-Content .env | Select-String '^RENDER_API_KEY=').ToString().Split('=')[1]
   ```
2. Usar `$key` en el comando (sin imprimirlo).
3. NO imprimir el comando completo si contiene el valor.
4. NO incluir el valor en ningún output.

**SI** vas a diagnosticar por qué un MCP falla:
**ENTONCES**:
1. NO uses curl/fetch/spawn con la key hardcodeada.
2. Revisá los logs del MCP.
3. Pedile al humano que verifique la conexión en el panel de MCP.
4. Si necesitás probar la API directamente, LEÉ la key del .env (nunca hardcodeada).

**SI** expusiste un secreto:
**ENTONCES**:
1. Avisar al humano INMEDIATAMENTE.
2. El humano debe rotar la key.
3. Detener toda acción hasta que la key esté rotada.

### Patrones de secretos a detectar
Detenerse si el comando contiene:
- `rnd_` (Render API key)
- `AQ.` (Stitch API key)
- `Bearer <algo-largo>` (Authorization headers)
- `sk_` (Stripe / OpenAI API key)
- `AKIA` (AWS access key)
- `ghp_` (GitHub personal token)
- `xoxb-` (Slack token)
- Valores del `.env` en texto plano
- `password=` con valor real
- `secret=` con valor real
