# Guía de Onboarding para Desarrolladores en 5 Pasos

Bienvenido al equipo de ingeniería de **Elite Multiservicios**. Esta guía detalla el procedimiento oficial y reproducible para poner en marcha el entorno completo de desarrollo local (Backend Serverpod, Base de Datos PostgreSQL, Frontend Flutter y Google Stitch MCP).

> **Tiempo estimado**: Entre **45 y 90 minutos** en una máquina de desarrollo limpia (incluyendo instalación de SDKs, dependencias y descarga de imágenes de Docker). Si ya cuentas con las herramientas instaladas, el proceso toma aproximadamente **10 a 15 minutos**.

---

## Prerrequisitos del Sistema

Antes de iniciar con el Paso 1, asegúrate de tener instaladas las siguientes herramientas en tu máquina local:

1. **Git** (v2.40 o superior)
2. **Flutter SDK** (v3.24+ / v3.41.x canal stable) & **Dart SDK** (v3.8.0+ / v3.11.x)
3. **Docker Desktop** (con Docker Compose y virtualización activa)
4. **Node.js** (v18.0.0+ LTS) y **npx**
5. **Serverpod CLI** (v3.4.13):
   ```bash
   dart pub global activate serverpod_cli
   ```
6. **Cuenta Google** con acceso a Google Stitch (para generar tu API Key)

---

## Los 5 Pasos de Puesta en Marcha

### Paso 1: Clonar el Repositorio y Ubicarse en Rama `develop`
```bash
git clone https://github.com/rogelio888/elite_multiservicios.git
cd elite_multiservicios
git checkout develop
```

---

### Paso 2: Configurar Secretos y Variables de Entorno Locales
Copia las plantillas de configuración segura (nunca se comitean secretos reales a Git):

**En Windows (PowerShell / CMD):**
```powershell
copy elite_multiservicios_server\config\passwords.yaml.example elite_multiservicios_server\config\passwords.yaml
copy .env.example .env
```

**En macOS / Linux:**
```bash
cp elite_multiservicios_server/config/passwords.yaml.example elite_multiservicios_server/config/passwords.yaml
cp .env.example .env
```

Abre el archivo `.env` recién creado y define obligatoriamente tu clave de Stitch y tu contraseña de administrador:
```env
STITCH_API_KEY=tu_clave_de_stitch_aqui
SEED_ADMIN_EMAIL=admin@elitemultiservicios.com
SEED_ADMIN_PASSWORD=TuPasswordSeguro123!
```

---

### Paso 2.5: Configuración de Google Stitch MCP (Solo con STITCH_API_KEY)
Google Stitch es la única fuente de verdad de UI/UX para el proyecto:

1. Obtén tu clave de API personal en la consola de Google Stitch (**Settings → API Keys**).
2. Asegúrate de haberla pegado en tu `.env` local (`STITCH_API_KEY=...`).
3. Verifica la disponibilidad del proxy MCP de Stitch ejecutando:
   ```bash
   npx -y @_davideast/stitch-mcp proxy
   ```
   *(El comando debe inicializar el proxy sin errores)*.

---

### Paso 3: Levantar Base de Datos PostgreSQL y Redis
Dentro del subdirectorio del servidor, inicia los contenedores Docker en segundo plano:

```bash
cd elite_multiservicios_server
docker compose up -d
```
Verifica que los contenedores estén corriendo:
```bash
docker compose ps
```
*(Debes ver `elite_multiservicios_server-postgres-1` en puerto 8090 y `redis-1` en puerto 8091)*.

---

### Paso 4: Aplicar Migraciones y Sembrar la Base de Datos
Ejecuta el servidor con el flag `--apply-migrations` para inicializar el catálogo de permisos canónicos, los roles y la cuenta de administrador:

```bash
dart bin/main.dart --apply-migrations
```
Verás en consola:
- `Migration created / applied.`
- `Seed de seguridad completado exitosamente con usuario admin: admin@elitemultiservicios.com.`

---

### Paso 5: Ejecutar la Aplicación y Validar Acceso
En una nueva terminal, desplázate a la carpeta de Flutter y ejecuta la aplicación:

```bash
cd ..\elite_multiservicios_flutter
flutter pub get
flutter run -d windows   # o: flutter run -d chrome
```

1. La aplicación cargará directamente la **Pantalla de Inicio de Sesión** (`LoginScreen`).
2. Ingresa con las credenciales sembradas en tu `.env`:
   - **Correo**: `admin@elitemultiservicios.com`
   - **Contraseña**: La que configuraste en `SEED_ADMIN_PASSWORD`.
3. Al iniciar sesión, accederás al **Dashboard General de Seguridad**.
4. Haz clic en **Cerrar Sesión** en la barra superior para confirmar que la sesión se revoca en base de datos y retornas al login.

---

## Verificación de Calidad del Entorno
Antes de realizar cualquier cambio o commit, ejecuta la suite de validación local:

```powershell
# Formato estricto (0 cambios)
dart format --output=none --set-exit-if-changed .

# Análisis estático (0 errores / 0 warnings)
cd elite_multiservicios_server; dart analyze
cd ..\elite_multiservicios_flutter; flutter analyze

# Pruebas automatizadas (100% aprobadas)
cd ..\elite_multiservicios_server; dart test
cd ..\elite_multiservicios_flutter; flutter test
```

Si todas las pruebas están en verde, ¡tu entorno está 100% listo para desarrollar!
