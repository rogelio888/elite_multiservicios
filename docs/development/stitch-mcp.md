# Guía de Integración: Google Stitch MCP en Antigravity

Esta guía describe el protocolo oficial para configurar, autenticar y operar **Google Stitch** a través del **Model Context Protocol (MCP)** en el IDE Antigravity para el equipo de desarrollo de **Elite Multiservicios**.

---

## 1. ¿Qué es Google Stitch y por qué es el origen del diseño?

**Google Stitch** es una plataforma de diseño y prototipado UI/UX asistida por IA que genera especificaciones visuales de alta fidelidad, tokens de diseño (`colors`, `spacing`, `typography`) y estructuras de interfaz.

En este proyecto:
- **Google Stitch es la única fuente de verdad para el diseño UI/UX.**
- **Flutter es el motor de implementación funcional**, responsable de renderizar los diseños aprobados, gestionar el estado y comunicarse con Serverpod RPC bajo la política No-Mock.
- Queda prohibido diseñar o inventar pantallas importantes directamente en Flutter sin que exista su diseño previo en Stitch.

---

## 2. Requisitos de Instalación

Cada desarrollador o colaborador debe contar con las siguientes herramientas en su máquina local:

1. **Node.js y npm / npx**:
   - Versión de Node.js: **v18.0.0 o superior** (Recomendado v20 LTS).
   - Verificar instalación en terminal:
     ```bash
     node -v
     npx -v
     ```
2. **Cuenta de Google Stitch & API Key**:
   - Generar tu propia clave de API personal en la consola de Google Stitch.
3. **IDE Antigravity**:
   - Versión actualizada con soporte nativo para Model Context Protocol (MCP).

---

## 3. Arquitectura del MCP y Configuración en el Repositorio

El proyecto utiliza el paquete oficial de proxy stdio **`@_davideast/stitch-mcp`**. Esto permite que Antigravity ejecute el servidor MCP en segundo plano vía standard I/O inyectando directamente tu API Key personal.

### Archivos de Configuración en el Repositorio

El repositorio provee la configuración lista para usar sin secretos en:
- [`.mcp.json`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.mcp.json) (Raíz del proyecto):
  ```json
  {
    "mcpServers": {
      "stitch": {
        "command": "npx",
        "args": [
          "-y",
          "@_davideast/stitch-mcp",
          "proxy"
        ],
        "env": {
          "STITCH_API_KEY": "${STITCH_API_KEY}"
        }
      }
    }
  }
  ```
- [`config/mcp/stitch_mcp.json.example`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/config/mcp/stitch_mcp.json.example): Plantilla de referencia protegida en Git.

---

## 4. Paso a Paso: Configuración de la Clave de API

La autenticación es **estrictamente individual y local**. Jamás compartas tu clave de API ni la subas a Git.

### Paso 1: Obtener tu STITCH_API_KEY
1. Ingresa a la plataforma de Google Stitch con tu cuenta autorizada.
2. Accede a **Settings / Configuración → API Keys**.
3. Genera una nueva clave y cópiala de inmediato.

### Paso 2: Crear o Editar tu `.env` Local
En la raíz del proyecto, copia la plantilla `.env.example` a `.env` (el cual está protegido en `.gitignore`):

```bash
cp .env.example .env      # Linux/macOS
copy .env.example .env    # Windows
```

Pega tu clave en `.env`:
```env
STITCH_API_KEY=tu_stitch_api_key_aqui
```

### Paso 3: Verificar Conectividad del Proxy
Ejecuta en tu terminal para validar que la clave es reconocida por el proxy MCP:
```bash
npx -y @_davideast/stitch-mcp proxy
```

---

## 5. Verificación de Conexión en Antigravity

1. Abre el workspace en Antigravity.
2. Antigravity leerá automáticamente [.mcp.json](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.mcp.json) e inyectará la variable `STITCH_API_KEY` desde tu `.env`.
3. Ve a la barra de servidores MCP y confirma que `stitch` figure en estado verde (**Connected**).
4. El agente Antigravity tendrá acceso a las herramientas del MCP de Stitch (`list_projects`, `get_screen`, etc.) para inspeccionar diseños canónicos.
