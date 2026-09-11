# Elite Multiservicios

> Plataforma empresarial modular y multiplataforma para la administración corporativa centralizada, con arquitectura backend-first, seguridad estricta RBAC y diseño canónico en Google Stitch.

---

## Tabla de contenidos

- [1. Requisitos previos](#1-requisitos-previos)
- [2. Clonar el repositorio y preparar el entorno](#2-clonar-el-repositorio-y-preparar-el-entorno)
- [3. Configurar secretos locales (NUNCA se suben a Git)](#3-configurar-secretos-locales-nunca-se-suben-a-git)
  - [3.1 Variables de entorno](#31-variables-de-entorno)
  - [3.2 Contraseñas de Serverpod](#32-contraseñas-de-serverpod)
  - [3.3 Verificar que Git NO rastrea secretos](#33-verificar-que-git-no-rastrea-secretos)
- [4. Levantar la infraestructura (PostgreSQL + Redis)](#4-levantar-la-infraestructura-postgresql--redis)
- [5. Levantar el backend Serverpod](#5-levantar-el-backend-serverpod)
- [6. Conectar tu API de Google Stitch (MCP)](#6-conectar-tu-api-de-google-stitch-mcp)
  - [6.1 Crear tu API Key en Stitch](#61-crear-tu-api-key-en-stitch)
  - [6.2 Autenticar Google Cloud localmente](#62-autenticar-google-cloud-localmente)
  - [6.3 Pegar la configuración en tu .env local](#63-pegar-la-configuración-en-tu-env-local)
  - [6.4 Verificar que Antigravity detecta el MCP](#64-verificar-que-antigravity-detecta-el-mcp)
  - [6.5 Regla de oro](#65-regla-de-oro)
- [7. Levantar la app Flutter](#7-levantar-la-app-flutter)
- [8. Flujo Git obligatorio (NO trabajar directo en main)](#8-flujo-git-obligatorio-no-trabajar-directo-en-main)
  - [Regla de oro](#regla-de-oro)
  - [Paso a paso](#paso-a-paso)
  - [Prohibiciones explícitas](#prohibiciones-explícitas)
- [9. Cómo verificar que NO subiste secretos](#9-cómo-verificar-que-no-subiste-secretos)
- [10. Protección de ramas en GitHub (configuración del owner)](#10-protección-de-ramas-en-github-configuración-del-owner)
- [11. Solución de problemas comunes](#11-solución-de-problemas-comunes)
- [12. Recursos adicionales](#12-recursos-adicionales)

---

## 1. Requisitos previos

Asegúrate de contar con las siguientes herramientas instaladas antes de iniciar. El tiempo estimado de configuración completa en un equipo limpio es de **45 a 90 minutos**; si ya cuentas con el entorno instalado, tomará aproximadamente **10 a 15 minutos**.

| Herramienta | Versión mínima | Comando para verificar instalación |
|---|---|---|
| **Git** | `v2.40+` | `git --version` |
| **Dart SDK** | `v3.8.0+` (detectado: 3.11.x) | `dart --version` |
| **Flutter SDK** | `v3.32.0+` (detectado: 3.41.x canal stable) | `flutter --version` |
| **Docker Desktop** | Con Docker Compose v2+ | `docker compose version` |
| **Node.js** | `v18.0.0+ LTS` (detectado: v22.x) | `node -v` y `npx -v` |
| **Google Cloud CLI (`gcloud`)** | Última versión disponible | `gcloud --version` |
| **Serverpod CLI** | `v3.4.13` | `serverpod --version` *(instalar con `dart pub global activate serverpod_cli`)* |
| **Cuenta Google** | Corporativa con acceso a Google Stitch | Acceso validado en consola de Stitch |

---

## 2. Clonar el repositorio y preparar el entorno

```bash
git clone https://github.com/rogelio888/elite_multiservicios.git
cd elite_multiservicios
git checkout develop
```

> **Nota de Monorepo**: El proyecto está configurado como un Dart Workspace en la raíz. Descarga las dependencias de todos los paquetes ejecutando en la raíz:
> ```bash
> dart pub get
> ```

---

## 3. Configurar secretos locales (NUNCA se suben a Git)

### 3.1 Variables de entorno

Copia la plantilla de variables de entorno en la raíz:

**En Linux / macOS:**
```bash
cp .env.example .env
```

**En Windows (PowerShell / CMD):**
```powershell
copy .env.example .env
```

Edita `.env` y completa los valores requeridos:
```env
# Identificador de proyecto GCP para cuotas y servicios
GOOGLE_CLOUD_PROJECT=tu-proyecto-gcp

# Clave API directa de Google Stitch (ver sección 6)
STITCH_API_KEY=tu_api_key_aqui

# Credenciales maestras del Super Administrador sembrado (OBLIGATORIO)
SEED_ADMIN_EMAIL=admin@elitemultiservicios.com
SEED_ADMIN_PASSWORD=TuPasswordSeguro123!
```

### 3.2 Contraseñas de Serverpod

Serverpod requiere un archivo `passwords.yaml` local con las claves de acceso para base de datos y JWT.

**En Linux / macOS:**
```bash
cp elite_multiservicios_server/config/passwords.yaml.example elite_multiservicios_server/config/passwords.yaml
```

**En Windows (PowerShell / CMD):**
```powershell
copy elite_multiservicios_server\config\passwords.yaml.example elite_multiservicios_server\config\passwords.yaml
```

*(Las credenciales predeterminadas del archivo `.example` coinciden con los valores del `docker-compose.yaml` local para desarrollo rápido).*

### 3.3 Verificar que Git NO rastrea secretos

Ejecuta el siguiente comando para comprobar que `.gitignore` protege tus secretos:

```bash
git check-ignore .env elite_multiservicios_server/config/passwords.yaml
```

**Validación**: Ambos archivos deben aparecer listados en la salida de consola. Si alguno no aparece, **DETENTE inmediatamente y avisa al equipo de seguridad**.

---

## 4. Levantar la infraestructura (PostgreSQL + Redis)

Los servicios de base de datos relacional y caché residen en la carpeta del servidor:

```bash
cd elite_multiservicios_server
docker compose up -d
docker compose ps
```

**Validación**: Confirma que los contenedores `postgres` (puerto `8090`) y `redis` (puerto `8091`) muestren estado `healthy` o `Up`.

---

## 5. Levantar el backend Serverpod

Dentro del directorio `elite_multiservicios_server/`, aplica las migraciones estructurales de PostgreSQL y levanta el servidor RPC:

```bash
dart bin/main.dart --apply-migrations
```

**Validación**: 
1. La consola mostrará:
   - `Migration created / applied.`
   - `Seed de seguridad completado exitosamente con usuario admin: admin@elitemultiservicios.com.`
   - `SERVERPOD: Listening on port 8080`
2. Abre [http://localhost:8080/](http://localhost:8080/) en tu navegador para ver la pantalla de estado de Serverpod.

---

## 6. Conectar tu API de Google Stitch (MCP)

Google Stitch es la **única fuente de verdad de UI/UX** del proyecto. Queda prohibido diseñar interfaces desde cero en Flutter sin especificación previa en Stitch.

### 6.1 Crear tu API Key en Stitch
1. Entra a <!-- TODO: URL real de Stitch --> [https://stitch.withgoogle.com](https://stitch.withgoogle.com).
2. Inicia sesión con tu cuenta corporativa autorizada.
3. Dirígete a **Settings / Configuración → API Keys**.
4. Crea una nueva clave API y cópiala inmediatamente (solo se muestra una vez).

### 6.2 Autenticar Google Cloud localmente
Configura tus credenciales Application Default Credentials (ADC):

```bash
gcloud auth application-default login
```
*(Esto abrirá el navegador para autenticar tu cuenta corporativa en tu máquina local).*

### 6.3 Pegar la configuración en tu .env local
Abre tu `.env` en la raíz del proyecto y confirma:
```env
GOOGLE_CLOUD_PROJECT=tu-proyecto-gcp
STITCH_API_KEY=tu_api_key_aqui
```

### 6.4 Verificar que Antigravity detecta el MCP
1. Abre el IDE Antigravity en la carpeta raíz del proyecto.
2. Comprueba que el archivo `.mcp.json` esté activo.
3. Ejecuta manualmente el proxy para verificar conectividad si lo deseas:
   ```bash
   npx -y @_davideast/stitch-mcp proxy
   ```
4. En el panel de MCP de Antigravity, valida que `stitch` figure con estado **Conectado** y exponga herramientas como `list_projects` y `get_screen`.

### 6.5 Regla de oro
> **Tu `STITCH_API_KEY` NUNCA se sube a Git.** Vive únicamente en tu `.env` local, el cual está estrictamente ignorado.

---

## 7. Levantar la app Flutter

En una nueva terminal, navega a la carpeta frontend:

```bash
cd elite_multiservicios_flutter
flutter pub get
flutter run -d chrome    # Para entorno Web
# o:
flutter run -d windows   # Para aplicación de escritorio Windows
```

### Credenciales iniciales para pruebas
- **Correo**: El configurado en `SEED_ADMIN_EMAIL` (`admin@elitemultiservicios.com`).
- **Contraseña**: El valor definido en `SEED_ADMIN_PASSWORD` en tu `.env`.

**Validación**: Al autenticarte, accederás al Dashboard General de Seguridad y podrás alternar el tema claro/oscuro o cerrar sesión de forma segura y auditada.

---

## 8. Flujo Git obligatorio (NO trabajar directo en main)

### Regla de oro
> **Nadie hace push directo a `main` ni a `develop`.** Todo cambio pasa obligatoriamente por una rama de tarea y un Pull Request revisado y aprobado.

### Paso a paso

#### 8.1 Antes de empezar cualquier tarea
```bash
git checkout develop
git pull origin develop
```

#### 8.2 Crear una rama para tu tarea
```bash
git checkout -b feat/nombre-corto-de-la-tarea
# o fix/, docs/, chore/, refactor/ según corresponda
```

#### 8.3 Trabajar y commitear
Usa [Conventional Commits](https://www.conventionalcommits.org/):
```bash
git add .
git commit -m "feat(modulo): descripcion clara y concisa del cambio"
```

#### 8.4 Antes de subir, verificar calidad local
Los 5 comandos deben pasar sin errores ni advertencias:

```bash
# 1. Formateo estricto
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático Flutter
cd elite_multiservicios_flutter
flutter analyze

# 3. Análisis estático Server
cd ../elite_multiservicios_server
dart analyze

# 4. Pruebas Flutter
cd ../elite_multiservicios_flutter
flutter test

# 5. Pruebas Server (unitarias)
cd ../elite_multiservicios_server
dart test test/unit
```

#### 8.5 Subir la rama
```bash
git push -u origin feat/nombre-corto-de-la-tarea
```

#### 8.6 Abrir Pull Request en GitHub
- **Base**: `develop` (NUNCA a `main`).
- **Título**: Mismo estándar que Conventional Commits.
- **Descripción**: Completar la plantilla generada por [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md).
- **Asignar revisores**: Consulta [.github/CODEOWNERS](.github/CODEOWNERS).
- **Requisitos de Merge**:
  1. Pipeline de CI en verde ([.github/workflows/ci.yml](.github/workflows/ci.yml)).
  2. Aprobación de al menos 1 reviewer del área correspondiente.
  3. Cero conflictos con `develop`.

#### 8.7 Después del merge
```bash
git checkout develop
git pull origin develop
git branch -d feat/nombre-corto-de-la-tarea
```

### Prohibiciones explícitas
- ❌ `git push origin main`
- ❌ `git push --force` sobre ramas públicas o compartidas
- ❌ Commitear `.env`, `passwords.yaml`, `*.key`, `*.pem`, `*.cert`
- ❌ Mergear tu propio Pull Request sin aprobación externa
- ❌ Trabajar directamente sobre `main` o `develop`

---

## 9. Cómo verificar que NO subiste secretos

Antes de cada `git push`, ejecuta:

```bash
git status
git diff --cached
```

Si detectas accidentalmente `.env`, `passwords.yaml` o credenciales, ejecuta de inmediato:

```bash
git restore --staged .env elite_multiservicios_server/config/passwords.yaml
```

### ¿Qué hacer si ya subiste un secreto a Git por error?
1. **Avisar INMEDIATAMENTE al equipo de seguridad y Tech Lead**.
2. **Rotar la clave comprometida**: Revócala en Stitch / Google Cloud y genera una nueva.
3. **Purgar el historial**: El owner del repositorio deberá emplear herramientas especializadas (`git-filter-repo` o `bfg`) para reescribir el historial antes de volver a sincronizar.

---

## 10. Protección de ramas en GitHub (configuración del owner)

<!-- TODO: verificar configuraciones en la consola web de GitHub -->
El owner del repositorio debe configurar las siguientes políticas en **GitHub → Settings → Branches**:

### Para rama `main`
- [x] Require a pull request before merging
- [x] Require approvals: al menos `1`
- [x] Dismiss stale pull request approvals when new commits are pushed
- [x] Require status checks to pass before merging (`build-and-test` de CI)
- [x] Require conversation resolution before merging
- [x] Do not allow bypassing the above settings

### Para rama `develop`
- [x] Require a pull request before merging
- [x] Require status checks to pass before merging (`build-and-test` de CI)
- [x] Require conversation resolution before merging

### Asignaciones en CODEOWNERS
Definidas formalmente en [.github/CODEOWNERS](.github/CODEOWNERS):
- `*` → `@rogelio888` (Propietario y revisor general del repositorio)
- `/elite_multiservicios_server/` → `@rogelio888`
- `/elite_multiservicios_flutter/` → `@rogelio888`
- `/elite_multiservicios_client/` → `@rogelio888`
- `/docs/` → `@rogelio888`
- `/.github/` → `@rogelio888`

---

## 11. Solución de problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| `docker compose up` falla | Docker Desktop no está iniciado o sin virtualización | Iniciar Docker Desktop y verificar que el motor esté en verde. |
| `dart bin/main.dart` no conecta a PostgreSQL | Contenedores aún iniciando o puerto ocupado | Verificar con `docker compose ps` que el puerto `8090` esté disponible y saludable. |
| MCP de Stitch no aparece en Antigravity | `.env` sin `GOOGLE_CLOUD_PROJECT` o `STITCH_API_KEY` | Completar `.env` y reiniciar Antigravity para recargar variables. |
| El login falla con el usuario administrador | Seed no aplicado o credenciales no coinciden | Ejecutar `dart bin/main.dart --apply-migrations` con `SEED_ADMIN_PASSWORD` definido en `.env`. |
| `git push` rechazado por GitHub | Push directo a rama protegida (`main`/`develop`) | Crear una rama de tarea (`feat/...`) y enviar los cambios mediante Pull Request. |
| `gcloud` no se reconoce como comando | Google Cloud SDK no instalado o fuera del PATH | Instalar Google Cloud CLI y agregarlo a las variables de entorno del sistema. |

---

## 12. Recursos adicionales

- [docs/development/onboarding.md](docs/development/onboarding.md) — Guía detallada de onboarding en 5 pasos.
- [docs/development/stitch-mcp.md](docs/development/stitch-mcp.md) — Manual de integración y uso de Google Stitch MCP.
- [docs/development/coding-standards.md](docs/development/coding-standards.md) — Estándares oficiales de código Dart y Flutter.
- [docs/process/scrum.md](docs/process/scrum.md) — Protocolo de trabajo, sprints y Definition of Done.
- [.agents/rules/project_rules.md](.agents/rules/project_rules.md) — Reglas del sistema y políticas para agentes de IA.
- [.agents/rules/stitch_workflow.md](.agents/rules/stitch_workflow.md) — Gobernanza de diseño y origen Stitch.
