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
2. **Google Cloud CLI (`gcloud`)**:
   - Necesario para autenticación automática mediante Application Default Credentials (ADC).
   - Instalar desde: [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
   - Verificar instalación:
     ```bash
     gcloud version
     ```
3. **Proyecto en Google Cloud con API de Stitch habilitada**:
   - Contar con un Google Cloud Project ID con los permisos correspondientes.
4. **IDE Antigravity**:
   - Versión actualizada con soporte para Model Context Protocol (MCP).

---

## 3. Arquitectura del MCP y Configuración Reproducible

El proyecto utiliza el paquete oficial de proxy stdio **`@_davideast/stitch-mcp`**. Esto permite que Antigravity ejecute el servidor MCP en segundo plano vía standard I/O sin necesidad de servicios remotos no autenticados.

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
          "GOOGLE_CLOUD_PROJECT": "${GOOGLE_CLOUD_PROJECT}"
        }
      }
    }
  }
  ```
- [`config/mcp/stitch_mcp.json.example`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/config/mcp/stitch_mcp.json.example): Plantilla de referencia para configuración en editores alternativos o configuración global de Antigravity.

---

## 4. Paso a Paso: Autenticación Segura para Colaboradores

La autenticación es **estrictamente individual**. Jamás compartas tus credenciales ni las agregues a Git.

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/tu-organizacion/elite_multiservicios.git
cd elite_multiservicios
```

### Paso 2: Crear el Archivo de Entorno Local `.env`
Copia la plantilla `.env.example` a un archivo local `.env` (el cual está protegido en `.gitignore`):
```bash
cp .env.example .env
```

Edita `.env` y configura el ID de tu proyecto de Google Cloud:
```env
GOOGLE_CLOUD_PROJECT=tu-google-cloud-project-id
```

### Paso 3: Autenticación en Google Cloud (Application Default Credentials)
Ejecuta en tu terminal para autenticar tu cuenta de Google en tu entorno local:
```bash
gcloud auth application-default login
```
Esto abrirá tu navegador para iniciar sesión con tu cuenta corporativa autorizada.

### Paso 4: Habilitar el Servicio MCP de Stitch (Una sola vez por proyecto GCP)
```bash
gcloud beta services mcp enable stitch.googleapis.com
```

---

## 5. Verificación de Conexión en Antigravity

Para verificar que Antigravity ha detectado e inicializado el servidor MCP:

1. **Abrir el proyecto en Antigravity**.
2. Ir a **Additional Options (...) > MCP Servers** en la interfaz de Antigravity.
3. Confirmar que **stitch** figure en la lista con estado activo (`Connected` o `Ready`).
4. En el chat con el agente, puedes comprobar preguntando:
   > "¿Qué herramientas tienes disponibles del servidor MCP de Stitch?"
5. El agente listará herramientas como:
   - `stitch_list_projects`
   - `stitch_get_screen`
   - `stitch_generate_screen`

---

## 6. Flujo de Trabajo Oficial: Diseño en Stitch → Implementación en Flutter

El flujo obligatorio para cualquier requerimiento o pantalla nueva es:

```text
REQUISITO
    ↓
DISEÑO EN GOOGLE STITCH
    ↓
REVISIÓN DEL DISEÑO
    ↓
APROBACIÓN
    ↓
IMPLEMENTACIÓN EN FLUTTER
    ↓
PRUEBAS (0 errores)
    ↓
CODE REVIEW
```

### Cómo interactuar con la IA para utilizar Stitch:

#### 1. Crear un nuevo diseño en Stitch
> "Diseña en Google Stitch una pantalla de inicio de sesión corporativa para Elite Multiservicios con soporte para temas claro y oscuro, campo de correo empresarial, contraseña y branding institucional."

#### 2. Consultar un diseño existente
> "Consulta en Stitch el diseño de la pantalla de Gestión de Usuarios y extrae los tokens de color y la estructura de la tabla de datos."

#### 3. Modificar un diseño existente
> "En el diseño de Bitácora de Auditoría en Stitch, añade una columna para visualizar el identificador del usuario y un badge de resultado."

#### 4. Implementar el diseño en Flutter
> "Una vez aprobado el diseño de Login en Stitch, impleméntalo en Flutter dentro de `lib/features/security/presentation/login_screen.dart` utilizando los tokens del diseño y conectando con Serverpod."

---

## 7. Políticas de Seguridad Innegociables

- **PROHIBIDO** comitear claves de API o tokens a Git.
- **PROHIBIDO** copiar o reutilizar credenciales de otro desarrollador.
- **VERIFICAR** siempre que `.env` no aparezca en `git status` antes de hacer commit.
