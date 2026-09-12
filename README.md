# Elite Multiservicios

> Plataforma empresarial modular y multiplataforma para la administración corporativa centralizada, con arquitectura backend-first, seguridad estricta RBAC y diseño canónico en Google Stitch.

---

## ⚡ Arranque rápido con IA (Recomendado)

Si estás trabajando con un asistente de IA (Antigravity, Cursor, Claude Code), no necesitas configurar cada servicio manualmente. Solo indícale:

> *"Prepara mi entorno para empezar a trabajar"*

La IA activará la skill `.agents/skills/bootstrap-environment`, levantará Docker, aplicará migraciones, ejecutará el seed del administrador con Serverpod Auth y dejará corriendo el backend y Flutter automáticamente.

Si prefieres realizar el proceso manual paso a paso, sigue la guía detallada a continuación.

---

## Tabla de contenidos

- [1. Requisitos previos](#1-requisitos-previos)
- [2. Clonar el repositorio y preparar el entorno](#2-clonar-el-repositorio-y-preparar-el-entorno)
- [3. Configurar secretos locales (NUNCA se suben a Git)](#3-configurar-secretos-locales-nunca-se-suben-a-git)
  - [3.1 Variables de entorno](#31-variables-de-entorno)
  - [3.2 Contraseñas de Serverpod](#32-contraseñas-de-serverpod)
  - [3.3 Verificar que Git NO rastrea secretos](#33-verificar-que-git-no-rastrea-secretos)
- [4. Conectar tu API de Google Stitch (MCP)](#4-conectar-tu-api-de-google-stitch-mcp)
  - [4.1 Obtener tu STITCH_API_KEY en Stitch](#41-obtener-tu-stitch_api_key-en-stitch)
  - [4.2 Pegar tu STITCH_API_KEY en tu .env local](#42-pegar-tu-stitch_api_key-en-tu-env-local)
  - [4.3 Verificar conectividad del proxy MCP](#43-verificar-conectividad-del-proxy-mcp)
  - [4.4 Regla de oro](#44-regla-de-oro)
- [5. Levantar la infraestructura (PostgreSQL + Redis en Docker)](#5-levantar-la-infraestructura-postgresql--redis-en-docker)
- [6. Levantar el backend Serverpod](#6-levantar-el-backend-serverpod)
- [7. Levantar la app Flutter](#7-levantar-la-app-flutter)
- [8. Flujo Git obligatorio (NO trabajar directo en main ni develop)](#8-flujo-git-obligatorio-no-trabajar-directo-en-main-ni-develop)
  - [8.1 Antes de empezar](#81-antes-de-empezar)
  - [8.2 Crear rama de tarea](#82-crear-rama-de-tarea)
  - [8.3 Trabajar y commitear](#83-trabajar-y-commitear)
  - [8.4 Verificar calidad local antes de subir](#84-verificar-calidad-local-antes-de-subir)
  - [8.5 Subir la rama](#85-subir-la-rama)
  - [8.6 Abrir Pull Request en GitHub](#86-abrir-pull-request-en-github)
  - [8.7 Después del merge](#87-después-del-merge)
  - [8.8 Prohibiciones explícitas](#88-prohibiciones-explícitas)
- [9. Cómo verificar que NO subiste secretos](#9-cómo-verificar-que-no-subiste-secretos)
- [10. Solución de problemas comunes](#10-solución-de-problemas-comunes)
- [11. Recursos adicionales](#11-recursos-adicionales)

---

## 1. Requisitos previos

Asegúrate de contar con las siguientes herramientas instaladas antes de iniciar. Tiempo estimado de puesta en marcha: **10 a 15 minutos** con herramientas instaladas (**45 a 90 minutos** si partes de un sistema operativo limpio descargando SDKs e imágenes Docker).

| Herramienta | Versión mínima | Comando para verificar instalación |
|---|---|---|
| **Git** | `v2.40+` | `git --version` |
| **Dart SDK** | `v3.8.0+` (incluido con Flutter) | `dart --version` |
| **Flutter SDK** | `v3.24+` (canal stable) | `flutter --version` |
| **Docker Desktop** | Con Docker Compose v2+ | `docker compose version` |
| **Node.js** | `v18.0.0+ LTS` | `node -v` y `npx -v` |
| **Serverpod CLI** | `v3.4.13` | `serverpod --version` *(instalar con `dart pub global activate serverpod_cli`)* |
| **Cuenta Google Stitch** | Acceso a plataforma Stitch | Acceso validado en consola de Stitch |

---

## 2. Clonar el repositorio y preparar el entorno

```bash
git clone https://github.com/rogelio888/elite_multiservicios.git
cd elite_multiservicios
git checkout develop
```

> **Monorepo Dart Workspace**: El proyecto está configurado como un Dart Workspace en la raíz. Descarga las dependencias de todos los paquetes (`elite_multiservicios_client`, `elite_multiservicios_server` y `elite_multiservicios_flutter`) con un solo comando en la raíz:
> ```bash
> dart pub get
> ```

> **Atajo con IA**: Si usas Antigravity, Cursor o Claude Code, puedes copiar y pegar el contenido de [SETUP_AI.md](SETUP_AI.md) y la IA configurará todo el entorno automáticamente.

**Cómo saber que funcionó:** Verás el mensaje `Got dependencies in .!` sin errores de resolución.

---

## 3. Configurar secretos locales (NUNCA se suben a Git)

### 3.1 Variables de entorno

Copia la plantilla de variables de entorno en la raíz del proyecto:

**En Linux / macOS:**
```bash
cp .env.example .env
```

**En Windows (PowerShell / CMD):**
```powershell
copy .env.example .env
```

Abre `.env` con tu editor y completa tus valores locales:
```env
# Clave personal de API de Google Stitch (ver sección 4)
STITCH_API_KEY=tu_stitch_api_key_aqui

# Credenciales del Super Administrador sembrado (OBLIGATORIO para login inicial)
SEED_ADMIN_EMAIL=admin@elitemultiservicios.com
SEED_ADMIN_PASSWORD=TuPasswordSeguro123!

# Configuración de base de datos local
DATABASE_PASSWORD=tu_password_dev_aqui

# Credenciales para contenedores Docker locales
POSTGRES_DEV_PASSWORD=tu_password_dev_aqui
REDIS_DEV_PASSWORD=tu_password_redis_aqui
POSTGRES_TEST_PASSWORD=tu_password_test_aqui
REDIS_TEST_PASSWORD=tu_password_test_redis_aqui
```

### 3.2 Contraseñas de Serverpod

Serverpod requiere su propio archivo de claves `passwords.yaml` dentro de su directorio de configuración:

**En Linux / macOS:**
```bash
cp elite_multiservicios_server/config/passwords.yaml.example elite_multiservicios_server/config/passwords.yaml
```

**En Windows (PowerShell / CMD):**
```powershell
copy elite_multiservicios_server\config\passwords.yaml.example elite_multiservicios_server\config\passwords.yaml
```

> **Nota**: Las contraseñas en `elite_multiservicios_server/config/passwords.yaml` en las secciones `development` y `test` deben coincidir con las definidas en tu `.env` (`POSTGRES_DEV_PASSWORD`, `REDIS_DEV_PASSWORD`, etc.).

### 3.3 Verificar que Git NO rastrea secretos

Ejecuta el siguiente comando para comprobar que `.gitignore` protege tus secretos:

```bash
git check-ignore .env elite_multiservicios_server/config/passwords.yaml
git check-ignore config/passwords.yaml .env.local
```

**Cómo saber que funcionó:** Ambos archivos deben aparecer listados en la salida de consola:
```text
.env
elite_multiservicios_server/config/passwords.yaml
```
Si alguno no aparece, **DETENTE inmediatamente** y verifica tu archivo `.gitignore`.

---

## 4. Conectar tu API de Google Stitch (MCP)

Google Stitch es la **única fuente de verdad de UI/UX** del proyecto. Queda prohibido diseñar interfaces desde cero en Flutter sin especificación previa en Stitch.

### 4.1 Obtener tu STITCH_API_KEY en Stitch
1. Entra a [https://stitch.withgoogle.com](https://stitch.withgoogle.com).
2. Inicia sesión con tu cuenta corporativa autorizada.
3. Dirígete a **Settings / Configuración → API Keys**.
4. Crea una nueva clave API y cópiala de inmediato (solo se muestra una vez).

### 4.2 Pegar tu STITCH_API_KEY en tu .env local
Abre tu archivo `.env` en la raíz del proyecto y asigna tu clave:
```env
STITCH_API_KEY=tu_stitch_api_key_aqui
```

### 4.3 Verificar conectividad del proxy MCP
Ejecuta el proxy en una terminal para validar que la clave sea aceptada por los servidores de Google Stitch:
```bash
npx -y @_davideast/stitch-mcp proxy
```
En el panel de MCP de tu IDE (Antigravity o Cursor), el servidor `stitch` debe figurar con estado **Conectado**.

### 4.4 Regla de oro
> **Tu `STITCH_API_KEY` NUNCA se sube a Git.** Vive únicamente en tu `.env` local.

---

## 5. Levantar la infraestructura (PostgreSQL + Redis en Docker)

Inicia los contenedores de base de datos relacional y caché desde el directorio del servidor:

```bash
cd elite_multiservicios_server
docker compose up -d
docker compose ps
cd ..
```

**Puertos mapeados en tu máquina local:**
- **PostgreSQL Dev**: `localhost:8090` (mapeado al `5432` interno)
- **Redis Dev**: `localhost:8091` (mapeado al `6379` interno)
- **PostgreSQL Test**: `localhost:9090` (para tests de integración)
- **Redis Test**: `localhost:9091` (para tests de integración)

**Cómo saber que funcionó:** `docker compose ps` mostrará los 4 servicios con estado `Up`:
```text
NAME                                          STATUS
elite_multiservicios_server-postgres-1        Up
elite_multiservicios_server-redis-1           Up
elite_multiservicios_server-postgres_test-1   Up
elite_multiservicios_server-redis_test-1      Up
```

---

## 6. Levantar el backend Serverpod

Dentro del directorio `elite_multiservicios_server`, aplica las migraciones estructurales de base de datos e inicializa el servidor:

```bash
cd elite_multiservicios_server
dart bin/main.dart --apply-migrations
```

**Puertos del backend Serverpod:**
- **API Server (Endpoints RPC para Flutter)**: `http://localhost:8080/`
- **Insights Server (Telemetría y métricas)**: `http://localhost:8081/`
- **Web Server (Portal estático y assets)**: `http://localhost:8082/`

**Cómo saber que funcionó:** La terminal imprimirá:
```text
SERVERPOD initialized
Applied database migration: ...
WebServer INFO: Webserver listening on http://localhost:8082
```
Abre [http://localhost:8082/](http://localhost:8082/) en tu navegador para ver la pantalla de estado del servidor web.

---

## 7. Levantar la app Flutter

En una nueva terminal, navega a la carpeta de la aplicación cliente:

```bash
cd elite_multiservicios_flutter
flutter pub get
flutter run -d chrome    # Para entorno Web
# o para escritorio Windows:
flutter run -d windows
```

### Credenciales iniciales para pruebas
- **Correo**: El configurado en `SEED_ADMIN_EMAIL` (`admin@elitemultiservicios.com`).
- **Contraseña**: La contraseña configurada en `SEED_ADMIN_PASSWORD` en tu `.env`.

**Cómo saber que funcionó:** La app abrirá la pantalla de Login corporativa. Al iniciar sesión, accederás al Dashboard de Seguridad centralizado con métricas del servidor en tiempo real.

---

## 8. Flujo Git obligatorio (NO trabajar directo en main ni develop)

### Regla de oro
> **Nadie hace push directo a `main` ni a `develop`.** Ambas ramas están protegidas por Rulesets en GitHub. Todo cambio pasa obligatoriamente por una rama de tarea y un Pull Request revisado y aprobado.

### 8.1 Antes de empezar
Asegúrate de estar al día con la rama base:
```bash
git checkout develop
git pull origin develop
```

### 8.2 Crear rama de tarea
```bash
git checkout -b feat/nombre-corto-de-tarea
# o fix/, docs/, chore/, refactor/ según corresponda
```

### 8.3 Trabajar y commitear
Sigue la convención de [Conventional Commits](https://www.conventionalcommits.org/):
```bash
git add .
git commit -m "feat(security): descripcion clara y concisa"
```

### 8.4 Verificar calidad local antes de subir
Los 5 comandos deben pasar sin errores ni advertencias:

```bash
# 1. Formato estricto
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático Server
cd elite_multiservicios_server
dart analyze

# 3. Análisis estático Flutter
cd ../elite_multiservicios_flutter
flutter analyze

# 4. Pruebas Flutter
flutter test

# 5. Pruebas Server (unitarias e integración)
cd ../elite_multiservicios_server
dart test
cd ..
```

### 8.5 Subir la rama
```bash
git push -u origin feat/nombre-corto-de-tarea
```

### 8.6 Abrir Pull Request en GitHub
1. Abre tu PR apuntando a **`base: develop`** (NUNCA a `main`).
2. El revisor obligatorio asignado automáticamente por [.github/CODEOWNERS](.github/CODEOWNERS) es `@rogelio888`.
3. El pipeline de CI ejecutará automáticamente los **4 checks obligatorios**:
   - `Secret Leak Detection (Gitleaks)`: Verifica que no haya secretos hardcodeados.
   - `Code Formatting & Static Analysis`: Valida formato y linting de código.
   - `Flutter Unit & Widget Tests`: Ejecuta los tests de frontend.
   - `Serverpod Tests & Database Integration`: Ejecuta tests de backend con contenedores efímeros.
4. El PR solo se mergea cuando los 4 checks estén verdes ✅ y cuente con aprobación.

### 8.7 Después del merge
```bash
git checkout develop
git pull origin develop
git branch -d feat/nombre-corto-de-tarea
```

### 8.8 Prohibiciones explícitas
- ❌ `git push origin main` o `git push origin develop` directo.
- ❌ `git push --force` sobre ramas públicas o compartidas.
- ❌ Commitear `.env`, `passwords.yaml`, `*.key`, `*.pem`, `*.cert`.
- ❌ Mergear tu propio PR sin revisión de código aprobada.
- ❌ Trabajar directamente sobre `main` o `develop`.

> **Ejemplo de error esperado si intentas push directo:**
> ```text
> remote: error: GH013: Repository rule violations found for refs/heads/develop.
> remote: - Changes must be made through a pull request.
> To https://github.com/rogelio888/elite_multiservicios.git
>  ! [remote rejected] develop -> develop (push declined due to repository rule violations)
> ```
> Esto significa que el sistema de protección está funcionando correctamente. Crea una rama y abre un PR.

---

## 9. Cómo verificar que NO subiste secretos

Antes de cada `git push`, ejecuta:
```bash
git status
git diff --cached
```

Si detectas accidentalmente `.env`, `passwords.yaml` o credenciales preparadas para commit, deséchalas de inmediato:
```bash
git restore --staged .env elite_multiservicios_server/config/passwords.yaml
```

### ¿Qué hacer si se subió un secreto a Git por error?
1. **Avisar inmediatamente al equipo de seguridad y Tech Lead (`@rogelio888`)**.
2. **Rotar la clave comprometida**: Revócala de inmediato en la consola de origen (Stitch, base de datos o proveedor).
3. **Reescribir el historial**: Emplear `git-filter-repo` para purgar el secreto de todos los commits antes de volver a sincronizar.

---

## 10. Solución de problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| `docker compose up` falla | Docker Desktop no está iniciado o sin virtualización | Iniciar Docker Desktop y verificar que el motor esté en verde antes de ejecutar comandos. |
| `dart bin/main.dart` no conecta a PostgreSQL | Contenedores aún iniciando o puerto ocupado | Verificar con `docker compose ps` que el puerto `8090` esté en estado `Up`. Si hubo cambios de contraseña, reiniciar con `docker compose down -v` y levantar de nuevo. |
| MCP de Stitch no aparece en el IDE | Falta `STITCH_API_KEY` en tu `.env` | Completar `.env` con tu clave de Stitch y reiniciar el IDE para recargar el entorno. |
| El login falla con el usuario administrador | Seed no aplicado o credenciales no coinciden | Ejecutar `dart bin/main.dart --apply-migrations` con `SEED_ADMIN_PASSWORD` definido en tu `.env`. |
| `git push` rechazado con error `GH013` o `GH006` | Push directo a rama protegida (`main` o `develop`) | Crear una rama de tarea (`feat/...`) y enviar los cambios mediante Pull Request a `develop`. |

---

## 11. Recursos adicionales

- [SETUP_AI.md](SETUP_AI.md) — Prompt auto-ejecutable para configurar el entorno con IA.
- [docs/development/onboarding.md](docs/development/onboarding.md) — Guía detallada de onboarding en 5 pasos.
- [docs/development/setup.md](docs/development/setup.md) — Manual de instalación y configuración técnica profunda.
- [docs/development/coding-standards.md](docs/development/coding-standards.md) — Estándares oficiales de código Dart y Flutter.
- [docs/development/stitch-mcp.md](docs/development/stitch-mcp.md) — Manual de integración y uso de Google Stitch MCP.
- [.github/CODEOWNERS](.github/CODEOWNERS) — Matriz de revisores y propietarios de código.
- [.agents/rules/project_rules.md](.agents/rules/project_rules.md) — Reglas del sistema y políticas de arquitectura backend-first.
