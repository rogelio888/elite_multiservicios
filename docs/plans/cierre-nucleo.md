# Plan de Implementación: Cierre del Núcleo y Preparación para Colaboradores

Ruta crítica para finalizar el **Núcleo de Seguridad y Accesos (Sprint 1)** y habilitar la incorporación reproducible, segura y sin fricciones de nuevos colaboradores al repositorio de **Elite Multiservicios**.

---

## 1. Diagnóstico: ¿Qué tenemos y qué falta?

### Ya Construido y Verificado (80–85% del Núcleo)
- **Infraestructura Base**: Docker Compose con PostgreSQL 16 (`pgvector`) en puerto 8090 y Redis en 8091.
- **Modelos & Persistencia**: 7 entidades relacionales `.spy.yaml` en Serverpod (`app_user`, `app_role`, `app_permission`, `user_role`, `role_permission`, `audit_log`, `user_session`) con migración formal `20260910161611120` aplicada.
- **Servicios & Endpoints RPC**: `UserEndpoint`, `RbacEndpoint`, `AuditEndpoint` y `SessionManagementEndpoint` protegidos por `RbacGuard` con permisos granulares (`AppPermissions`).
- **Frontend Corporativo**: Shell responsivo en Flutter con Sidebar interactivo, `SecurityDashboardView`, tabla de usuarios con scroll horizontal, matriz RBAC, bitácora de auditoría y monitor de sesiones activas (0 mocks, consumo real de Serverpod).
- **Diseño & Gobernanza Stitch**: Integración MCP (`@_davideast/stitch-mcp`) con `.mcp.json`, regla permanente en `.agents/rules/stitch_workflow.md` y DoD actualizado en `scrum.md`.
- **Calidad y Pruebas**: 17 pruebas unitarias y de widgets aprobadas al 100%, 0 errores y 0 warnings en `flutter analyze` y `dart analyze`, y formateo limpio con `dart format`.

---

### Recalibración del Alcance Restante (15–20% del Núcleo)
El trabajo pendiente no es una simple pantalla cosmética: representa el **15–20% restante del núcleo** debido a la profundidad técnica requerida:
1. **Configuración y persistencia formal de `emailIdp` en Serverpod**: Requiere soporte de `serverpod_auth_idp`, migración de tablas de credenciales de Serverpod, mock sender en desarrollo y endpoint público de login.
2. **Ciclo de vida de sesión y tokens JWT**: Coordinación entre `FlutterAuthSessionManager`, almacenamiento seguro en cliente (`flutter_secure_storage` / `SharedPreferences`) e inicialización antes del renderizado de la UI.
3. **Flujo de Logout coherente con auditoría**: Revocación en base de datos (`user_session.revokedAt`), emisión inmutable en `audit_log` y purga local de tokens.
4. **Infraestructura de colaboración en equipo**: Pipelines de CI estrictos en GitHub Actions, asignación formal de `CODEOWNERS` y kit de onboarding paso a paso.

---

## 2. Prerequisitos y Supuestos

### Archivos y Componentes que YA Existen en el Repositorio
- `elite_multiservicios_server/lib/server.dart` (Inicializa `JwtConfigFromPasswords` y `EmailIdpConfigFromPasswords`).
- `elite_multiservicios_server/config/passwords.yaml.example` (Plantilla de secretos para Docker y Serverpod).
- `.mcp.json` y `config/mcp/stitch_mcp.json.example` (Configuración de servidor MCP de Stitch).
- `.agents/rules/stitch_workflow.md` y `.agents/rules/project_rules.md` (Reglas de gobernanza de diseño y código).
- `.github/workflows/ci.yml` (Pipeline base de integración continua).
- `docs/modules/security-access.md` y `docs/process/scrum.md` (Documentación arquitectónica y agilidad).

### Módulos de Serverpod Habilitados Actualmente
- `serverpod: 3.4.13`
- `serverpod_auth_idp_server: 3.4.13`
- `serverpod_auth_core_client: 3.4.13`
- `serverpod_auth_idp_flutter: 3.4.13`

### Configuración Local Requerida en la Máquina del Colaborador
Antes de comenzar el onboarding, cada desarrollador debe tener instalado en su sistema operativo:
- **Git** (v2.40+)
- **Flutter SDK** (v3.24+ / v3.41.x canal stable)
- **Dart SDK** (v3.8.0+ / v3.11.x)
- **Docker Desktop** (con Docker Compose activo)
- **Node.js** (v18.0.0+ LTS) y `npx`
- **Google Cloud CLI (`gcloud`)** (para Application Default Credentials hacia Stitch)

### Fuera de Alcance Explícito de este Plan
- Autenticación multifactor (2FA / MFA vía SMS o TOTP).
- Proveedores de identidad de terceros (OAuth con Google, Apple o Microsoft).
- Servicio real de envío de correos por SMTP/SendGrid para producción (se utiliza `MockEmailSender` en desarrollo).
- Recuperación de contraseña con enlace externo en ambiente productivo (solo flujo mock/consola en local).

---

## 3. Prerequisitos Técnicos de `emailIdp` en Serverpod

Para que la autenticación con correo y contraseña funcione de forma reproducible y desacoplada en desarrollo:
1. **Configuración del Generador**:
   - Verificar en `elite_multiservicios_server/config/generator.yaml` que los módulos de `serverpod_auth` estén declarados para sincronizar protocolos cliente/servidor mediante `serverpod generate`.
2. **Configuración de `EmailIdpConfig` en Desarrollo**:
   - En `lib/server.dart`, asegurar que el proveedor `EmailIdpConfigFromPasswords` utilice un `sendRegistrationVerificationCode` y `sendPasswordResetVerificationCode` que impriman en consola (o utilicen `MockEmailSender`) en entornos de desarrollo local, evitando dependencias de proveedores externos de correo.
3. **Migración de Tablas de Autenticación de Serverpod**:
   - Verificar y aplicar la migración que crea las tablas del módulo auth (`serverpod_email_auth`, `serverpod_user_info`, `serverpod_auth_key`) en PostgreSQL.
4. **Exposición del Endpoint Público**:
   - El endpoint `emailIdp` generado por Serverpod debe ser accesible públicamente sin pasar por `RbacGuard`, permitiendo que usuarios no autenticados ejecuten la llamada RPC de login (`client.emailIdp.login`).

---

## 4. Propuesta de Cambios por Componente

```text
ETAPA A: CIERRE TÉCNICO DEL NÚCLEO (Fase 5 - Autenticación y Login)
├── 1. Seed del Administrador sin secretos hardcodeados
├── 2. Modelo app_user con mustChangePassword y migración
├── 3. Diseño en Stitch (Variante Light canónica + derivación Dark)
├── 4. AuthService con persistencia segura y flujo de Logout auditado
├── 5. LoginScreen en Flutter con validación reactiva
├── 6. Control condicional de sesión en main.dart
└── 7. Pruebas automatizadas de autenticación y widgets

ETAPA B: KIT DE ONBOARDING DEL COLABORADOR Y GITHUB
├── 1. Guía de Onboarding en 5 pasos (docs/development/onboarding.md)
├── 2. Paso de Google Stitch / gcloud ADC y verificación de MCP
├── 3. Plantillas de secretos (.env.example y passwords.yaml.example)
├── 4. Configuración obligatoria de GitHub: CI Pipeline + CODEOWNERS
└── 5. Protección de ramas (main y develop blindadas contra CI)
```

---

### Etapa A: Autenticación y Login (Fase 5)

#### [MODIFY] [app_user.spy.yaml](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_server/lib/src/modules/security/models/app_user.spy.yaml)
- Agregar el campo `mustChangePassword: bool, default=true` para forzar la actualización de contraseñas provisionales.
- Ejecutar `serverpod create-migration` y `serverpod generate` para persistir el cambio en PostgreSQL y actualizar el cliente tipado.

#### [MODIFY] [security_seed.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_server/lib/src/modules/security/seeds/security_seed.dart)
- Leer credenciales exclusivamente desde el entorno del sistema:
  ```dart
  final adminEmail = Platform.environment['SEED_ADMIN_EMAIL'] ?? 'admin@elitemultiservicios.com';
  final adminPassword = Platform.environment['SEED_ADMIN_PASSWORD'];

  if (adminPassword == null || adminPassword.isEmpty) {
    throw StateError(
      'FATAL: La variable de entorno SEED_ADMIN_PASSWORD no está definida. '
      'No se permite sembrar el usuario administrador sin una contraseña explícita.',
    );
  }
  ```
- Insertar en `AppUser` con `mustChangePassword: true` y asociar al rol `Super Administrador`.
- Registrar la credencial en `serverpod_email_auth` utilizando el algoritmo de hashing seguro de Serverpod.

#### [NEW] Prototipado en Google Stitch (`LoginScreen`)
- **Estrategia de Tema (Resuelta)**: El diseño canónico del Login se realiza en Google Stitch en su **variante Light**. La variante **Dark** se deriva automáticamente mediante el Design System de Flutter (`AppTheme.darkTheme`) mapeando los tokens semánticos aprobados (`surface`, `onSurface`, `primaryContainer`), documentando la tabla de mapeo de tokens en `.agents/rules/stitch_workflow.md`.
- Elementos del diseño en Stitch:
  - Layout bifurcado para Desktop/Tablet (Branding corporativo + Panel de autenticación).
  - Campos validados: Correo empresarial con icono de validación y Contraseña con alternancia de visibilidad.
  - Indicador de estado de carga con spinner corporativo.
  - Alerta de credenciales inválidas o cuenta inactiva.

#### [NEW] [auth_service.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/services/auth_service.dart)
- Servicio reactivo (`ChangeNotifier`) que expone:
  - `Future<bool> login({required String email, required String password})`: invoca `client.emailIdp.login(email: email, password: password)` y refresca el estado.
  - `Future<void> logout()`: ejecuta el **flujo de Logout server-side auditado**:
    1. Obtiene la sesión actual e invoca `client.sessionManagement.revokeSession(sessionId)` para marcar `user_session.revokedAt`.
    2. Registra el evento `LOGOUT` en `audit_log` con IP y agente de usuario.
    3. Ejecuta `client.auth.signOut()` para purgar el token local de almacenamiento seguro.
  - `bool get isAuthenticated`: consulta el estado del `client.authSessionManager`.
  - `UserInfo? get currentUser`: provee los datos del usuario conectado.
- **Persistencia de sesión**: Utiliza `FlutterAuthSessionManager` conectado a `flutter_secure_storage` en plataformas móviles y de escritorio, y a `SharedPreferences` en Web.

#### [NEW] [login_screen.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/presentation/login_screen.dart)
- Implementación de alta fidelidad en Flutter basada en el prototipo aprobado de Stitch.
- Manejo de estados: formulario interactivo, validaciones en caliente, botón con loading state y banner de error controlado.

#### [MODIFY] [security_shell_screen.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/presentation/security_shell_screen.dart)
- Header y pie de Sidebar actualizados con el perfil del usuario autenticado (`currentUser.userName`, `currentUser.email`).
- Botón de **Cerrar Sesión** en el Header y en el pie del Sidebar que abre un diálogo modal de confirmación antes de disparar `AuthService.logout()`.

#### [MODIFY] [main.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/main.dart)
- Inclusión obligatoria de:
  ```dart
  await client.auth.initialize();
  ```
  **ANTES** de resolver la pantalla inicial de la aplicación.
- Enrutamiento dinámico reactivo:
  - Si `client.authSessionManager.isSignedIn` es falso -> renderiza `LoginScreen`.
  - Si es verdadero -> renderiza `SecurityShellScreen`.

#### [NEW] [login_screen_test.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/test/presentation/login_screen_test.dart)
- Widget test para validar renderizado de campos, alternador de contraseña, validación de correo vacío/malformado y visualización de banner de error.

#### [NEW] [auth_service_test.dart](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/test/services/auth_service_test.dart)
- Unit test que comprueba:
  - Transición de estado exitosa ante login válido.
  - Captura y reporte de error ante credenciales inválidas.
  - Ejecución ordenada de logout (revocación en backend + auditoría + signOut local).

---

### Etapa B: Kit de Onboarding del Colaborador y GitHub

#### [NEW] [passwords.yaml.example](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_server/config/passwords.yaml.example)
- Confirmar/crear la plantilla oficial de credenciales para Serverpod con placeholders seguros para desarrollo:
  ```yaml
  # elite_multiservicios_server/config/passwords.yaml.example
  development:
    database: 'postgres'
    redis: 'redis_dev_password'
    serviceSecret: 'dev_serverpod_service_secret_replace_in_prod'
    jwtSecret: 'dev_jwt_secret_must_be_at_least_32_chars_long'
  ```
- **Verificación**: Confirmar que `**/config/passwords.yaml` está estrictamente ignorado en [`.gitignore`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.gitignore).

#### [MODIFY] [.env.example](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.env.example)
- Actualizar la plantilla en la raíz para incluir las variables de seed de administración y Stitch:
  ```env
  # Google Stitch MCP Configuration
  GOOGLE_CLOUD_PROJECT=tu-id-de-proyecto-gcp
  STITCH_API_KEY=

  # Administrador Inicial para Seed de Base de Datos (Obligatorio en desarrollo)
  SEED_ADMIN_EMAIL=admin@elitemultiservicios.com
  SEED_ADMIN_PASSWORD=

  # Serverpod & Database Local Development
  SERVERPOD_SERVER_URL=http://localhost:8080/
  DATABASE_HOST=localhost
  DATABASE_PORT=8090
  DATABASE_NAME=elite_multiservicios
  DATABASE_USER=postgres
  DATABASE_PASSWORD=postgres
  ```

#### [NEW] [CODEOWNERS](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.github/CODEOWNERS)
- Definición formal de propietarios de código para revisiones obligatorias:
  ```text
  # Propietarios globales del proyecto
  *       @equipo-core-elite

  # Propietarios de Backend y Modelado Relacional
  /elite_multiservicios_server/   @lead-backend
  /docs/architecture/             @lead-backend

  # Propietarios de Frontend y Diseño
  /elite_multiservicios_flutter/  @lead-frontend
  /docs/development/stitch-mcp.md @lead-frontend

  # Propietarios de Procesos y Agilidad
  /docs/process/                  @scrum-master
  ```

#### [MODIFY] [ci.yml](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/.github/workflows/ci.yml)
- Configurar el pipeline para ejecutarse en cada Pull Request y Push hacia `main` y `develop`:
  1. `dart format --output=none --set-exit-if-changed .`
  2. `flutter analyze` y `dart analyze --fatal-infos`
  3. `flutter test`
  4. Levantamiento de servicios en GitHub Actions con Docker Compose y ejecución de `dart test` en `elite_multiservicios_server`.
- **Justificación**: Proteger ramas en GitHub sin verificación automatizada en CI es una medida estéril; el merge a `develop` o `main` estará técnicamente bloqueado hasta que el pipeline reporte éxito al 100%.

#### [NEW] [onboarding.md](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/docs/development/onboarding.md)
- **Título**: *Guía de Onboarding para Desarrolladores en 5 Pasos*.
- **Tiempo estimado realista**: *45 a 90 minutos en una máquina nueva (incluye instalación de herramientas, SDKs y descarga de imágenes Docker)*.
- **Estructura en 5 pasos exactos**:
  - **Paso 1: Clonar y Ubicarse en Rama**:
    ```bash
    git clone <URL_DEL_REPO>
    cd elite_multiservicios
    git checkout develop
    ```
  - **Paso 2: Configurar Secretos Locales**:
    ```bash
    copy elite_multiservicios_server\config\passwords.yaml.example elite_multiservicios_server\config\passwords.yaml
    copy .env.example .env
    ```
    *Editar `.env` y definir `SEED_ADMIN_PASSWORD=TuPasswordSeguro123!`.*
  - **Paso 2.5: Configuración de Google Stitch y gcloud ADC**:
    ```bash
    gcloud auth application-default login
    ```
    *Configurar `GOOGLE_CLOUD_PROJECT` o `STITCH_API_KEY` en `.env` y verificar el proxy MCP:*
    ```bash
    npx -y @_davideast/stitch-mcp proxy
    ```
  - **Paso 3: Levantar Base de Datos y Redis**:
    ```bash
    cd elite_multiservicios_server
    docker compose up -d
    ```
  - **Paso 4: Aplicar Migraciones y Sembrar Base de Datos**:
    ```bash
    dart bin/main.dart --apply-migrations
    ```
  - **Paso 5: Ejecutar la Aplicación y Validar Acceso**:
    ```bash
    cd ..\elite_multiservicios_flutter
    flutter run -d windows  # o -d chrome
    ```
    *Ingresar con `admin@elitemultiservicios.com` y la contraseña configurada en `SEED_ADMIN_PASSWORD`.*

---

## 5. Plan de Verificación Empírica

| Validación | Comando / Método | Criterio de Aprobación |
| :--- | :--- | :--- |
| **Fail-Fast en Seed sin Password** | Ejecutar seed sin `SEED_ADMIN_PASSWORD` | Lanza `StateError` inmediatamente sin crear usuario con password vacía |
| **Seed con Password Válida** | Ejecutar seed con `SEED_ADMIN_PASSWORD` en `.env` | Crea usuario en `app_user` con `mustChangePassword: true` y credencial en `serverpod_email_auth` |
| **Validación Formulario Login** | `flutter test test/presentation/login_screen_test.dart` | Comprueba validación de correo, alternancia de visibilidad y banner de error |
| **Flujo Unitario AuthService** | `flutter test test/services/auth_service_test.dart` | Comprueba login exitoso, login fallido y secuencia de logout auditada |
| **Flujo Completo de Logout** | Ejecutar logout en UI | Verifica `user_session.revokedAt` en PostgreSQL, evento `LOGOUT` en `audit_log` y redirección a login |
| **Análisis Estático** | `flutter analyze` & `dart analyze` | **0 errores y 0 warnings** |
| **Formateo Estricto** | `dart format --output=none --set-exit-if-changed .` | Código 100% conforme a convenciones Dart |
| **Suite Completa de Pruebas** | `flutter test` & `dart test` | **17 pruebas actuales + N pruebas nuevas aprobadas al 100%** |
| **Integridad de Secretos Git** | `git status` tras setup | Ni `.env` ni `passwords.yaml` aparecen en archivos rastreados |
| **Sintaxis de CI y CODEOWNERS** | Validación sintáctica YAML y rutas | `.github/workflows/ci.yml` y `.github/CODEOWNERS` válidos |

---

## 6. Changelog de esta Revisión

1. **Corrección 1 (Seed sin secretos)**: Se configuró `security_seed.dart` para requerir `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD` desde el entorno, lanzando `StateError` si falta la contraseña, añadiendo `mustChangePassword: true` en `app_user` y documentándolo en `.env.example`.
2. **Corrección 2 (Persistencia de sesión)**: Se definió el uso de `FlutterAuthSessionManager` con almacenamiento seguro (`flutter_secure_storage` en desktop/móvil, `SharedPreferences` en web) y llamada obligatoria a `client.auth.initialize()` en `main.dart`.
3. **Corrección 3 (Prerequisitos emailIdp y recalibración)**: Se añadió la sección de prerequisitos técnicos de `emailIdp` y se recalibró el alcance restante del núcleo a 15–20% justificando su complejidad técnica.
4. **Corrección 4 (Logout server-side auditado)**: Se especificó la secuencia de 3 pasos para logout: revocación en `SessionManagementEndpoint`, registro del evento `LOGOUT` en `audit_log` y purga local con `signOut()`.
5. **Corrección 5 (Paso de Stitch en Onboarding)**: Se incorporó el Paso 2.5 en la guía de onboarding para autenticación con `gcloud auth application-default login`, variables de entorno y verificación del proxy MCP.
6. **Corrección 6 (Plantilla passwords.yaml.example)**: Se formalizó `passwords.yaml.example` en `elite_multiservicios_server/config/` con placeholders de desarrollo y confirmación de exclusión en `.gitignore`.
7. **Corrección 7 (Plantilla .env.example actualizada)**: Se incluyeron las variables obligatorias `GOOGLE_CLOUD_PROJECT`, `STITCH_API_KEY`, `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD`.
8. **Corrección 8 (CI + CODEOWNERS en GitHub)**: Se definieron las rutas de `.github/CODEOWNERS` y la integración continua obligatoria en `.github/workflows/ci.yml` como condición previa para proteger ramas.
9. **Corrección 9 (Tests nuevos explícitos)**: Se incorporaron `login_screen_test.dart` y `auth_service_test.dart` al alcance de cambios y se actualizó la métrica a "17 + N pruebas aprobadas".
10. **Corrección 10 (Consistencia de temas en Stitch)**: Se resolvió la coherencia declarando el diseño canónico en variante Light en Stitch y la derivación del modo Dark mediante tokens semánticos del Design System en Flutter.
11. **Corrección 11 (Onboarding en 5 pasos)**: Se ajustó el título a "Guía de Onboarding en 5 Pasos", estimando un tiempo realista de 45 a 90 minutos y listando los prerrequisitos de SDKs del sistema.
12. **Corrección 12 (Prerequisitos y Supuestos)**: Se insertó la sección formal detallando componentes existentes, módulos activos de Serverpod, setup previo de la máquina y límites de alcance.
