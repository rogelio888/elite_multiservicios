---
name: use-secrets-safely
description: Protocolo obligatorio para el uso de secretos (.env) en comandos, scripts y diagnósticos.
---

# Use Secrets Safely Skill

## Cuándo usar
Antes de ejecutar cualquier comando que pueda necesitar un secreto:
- Llamadas a APIs externas (Render, Stitch, Resend).
- Diagnóstico de MCP servers.
- Pruebas de conectividad.
- Debugging de autenticación.

## Pasos

### 1. Detectar el secreto
**Antes** de escribir el comando, preguntarse:
- ¿Va a contener un valor de `.env`?
- ¿Va a imprimirse el valor en el output?

Si la respuesta a alguna es SÍ → aplicar el protocolo.

### 2. Leer sin exponer
```powershell
# Correcto: leer y guardar en variable
$key = (Get-Content .env | Select-String '^RENDER_API_KEY=').ToString().Split('=')[1]

# Incorrecto: imprimir el valor
Get-Content .env | Select-String 'RENDER_API_KEY'
```

### 3. Usar en comandos sin mostrar
```powershell
# Correcto: usar la variable sin imprimir el comando
Invoke-RestMethod -Uri 'https://api.render.com/v1/services' -Headers @{ Authorization = "Bearer $key" } | ConvertTo-Json
```

### 4. Reportar solo el resultado
- ✅ "Lista de 9 servicios obtenida."
- ❌ "Comando ejecutado: curl -H 'Bearer rnd_xxx'..."

## Prohibiciones
- ❌ Nunca escribir el valor del secreto en el chat.
- ❌ Nunca pasar el secreto como argumento CLI visible.
- ❌ Nunca incluir el secreto en logs de comandos.
- ❌ Nunca imprimir el comando completo si contiene un secreto.

## Alternativa preferida: usar el MCP
SIEMPRE preferir el MCP (render/*) sobre HTTP directo. El MCP inyecta el secreto desde el .env sin exponerlo.
