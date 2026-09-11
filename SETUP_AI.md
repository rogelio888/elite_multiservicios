# Setup Automático para IA — Elite Multiservicios

> **Instrucciones para el colaborador**: Copia todo el contenido de este archivo y pégalo en tu IA (Antigravity, Cursor, Claude Code, etc.). La IA ejecutará los comandos automáticamente y te pedirá confirmación antes de acciones destructivas.

---

## Cómo usar este archivo

**Opción A — Colaborador con IA en IDE**:
1. Abre Antigravity (o Cursor, Claude Code).
2. Clona el repo: pídele a la IA "clona https://github.com/rogelio888/elite_multiservicios.git".
3. Dile: "Lee el archivo SETUP_AI.md y ejecuta las instrucciones paso a paso".
4. La IA hará todo el setup.

**Opción B — Colaborador manual**:
1. Clona el repo tú mismo:
   ```bash
   git clone https://github.com/rogelio888/elite_multiservicios.git
   cd elite_multiservicios
   ```
2. Abre el archivo `SETUP_AI.md` en tu editor.
3. Ejecuta los comandos manualmente.

**Opción C — Colaborador en IDE con IA sin acceso al filesystem**:
1. Abre el archivo `SETUP_AI.md` en GitHub.
2. Copia todo el contenido.
3. Pega el contenido en el chat de tu IA.
4. La IA hará todo el setup.

---

# PROMPT PARA LA IA

## Tu tarea
Vas a configurar el entorno de desarrollo completo de **Elite Multiservicios** en la máquina del colaborador. Ejecuta los pasos en orden, detente si algo falla, y pide confirmación al humano antes de acciones destructivas (borrar volúmenes, force-push, etc.).

## Reglas inviolables
1. **NUNCA** hagas `git push` directo a `main` ni `develop`. Solo a ramas de tarea (`feat/...`, `fix/...`, etc.).
2. **NUNCA** commitees `.env`, `passwords.yaml`, `*.pem`, `*.key` ni secretos a Git.
3. **NUNCA** uses `git push --force`.
4. **PIDE CONFIRMACIÓN** al humano antes de cualquier comando destructivo (`docker compose down -v`, `git reset --hard`, etc.).
5. Trabaja en **Windows + PowerShell** por defecto. Ajusta comandos a Linux/macOS si el humano indica que usa esos sistemas.
6. Si un comando falla, **DETENTE** inmediatamente y muestra el error completo al humano sin inventar soluciones sin evidencia.

---

## Paso 1: Verificar prerrequisitos

Ejecuta y verifica que cada comando devuelva una versión válida:

**En Windows (PowerShell):**
```powershell
git --version
dart --version
flutter --version
docker --version
docker compose version
node --version
```

*(En Linux / macOS ejecuta los mismos comandos en tu terminal).*

Si alguno falla o no está instalado, detente y dile al humano qué instalar:
- **Git**: [https://git-scm.com/downloads](https://git-scm.com/downloads)
- **Flutter SDK** (incluye Dart SDK): [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
- **Docker Desktop**: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
- **Node.js v18+ LTS**: [https://nodejs.org](https://nodejs.org/)

---

## Paso 2: Clonar el repositorio y acceder a develop

Pregunta al humano:
> *"¿En qué carpeta deseas clonar el repositorio? (ej. C:\Users\tu-usuario\Proyectos o presiona Enter para usar la carpeta actual)"*

Luego clona e ingresa al repositorio:

**En Windows (PowerShell):**
```powershell
cd <carpeta-indicada-por-el-humano>
git clone https://github.com/rogelio888/elite_multiservicios.git
cd elite_multiservicios
git checkout develop
```

*(En Linux / macOS usa `cd <carpeta> && git clone ... && cd elite_multiservicios && git checkout develop`).*

---

## Paso 3: Descargar dependencias del workspace

Dado que el monorepo utiliza Dart Workspaces unificado en la raíz:

```powershell
dart pub get
```

*(Debe resolver y descargar dependencias para cliente, servidor y Flutter simultáneamente sin errores).*

---

## Paso 4: Configurar variables de entorno (.env)

Pregunta al humano:
> *"Voy a crear tu archivo `.env` local. Por favor facilítame los siguientes datos:*
> 1. *Tu API Key de Google Stitch (si no la tienes a mano, avísame y saltamos este paso por ahora; podrás agregarla después).*
> 2. *Una contraseña para la base de datos local (ej. `MiPasswordSeguro123!` o la que prefieras).*
> 3. *Correo y contraseña para el usuario administrador inicial (por defecto sugerido: `admin@elitemultiservicios.com` / `TuPasswordAdmin123!`)."*

Copia la plantilla `.env.example` a `.env`:

**En Windows (PowerShell):**
```powershell
copy .env.example .env
```
*(En Linux / macOS: `cp .env.example .env`).*

Edita `.env` con los valores provistos:
- `STITCH_API_KEY`: clave proporcionada o déjala vacía si no la tiene aún.
- `DATABASE_PASSWORD`: contraseña elegida por el humano.
- `POSTGRES_DEV_PASSWORD`, `REDIS_DEV_PASSWORD`, `POSTGRES_TEST_PASSWORD`, `REDIS_TEST_PASSWORD`: asigna la misma contraseña para simplificar el entorno local.
- `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD`: credenciales del superadministrador.

---

## Paso 5: Configurar contraseñas de Serverpod

Copia la plantilla de contraseñas de Serverpod:

**En Windows (PowerShell):**
```powershell
copy elite_multiservicios_server\config\passwords.yaml.example elite_multiservicios_server\config\passwords.yaml
```
*(En Linux / macOS: `cp elite_multiservicios_server/config/passwords.yaml.example elite_multiservicios_server/config/passwords.yaml`).*

Edita `elite_multiservicios_server/config/passwords.yaml` asegurando que las contraseñas de base de datos y Redis en las secciones `development` y `test` coincidan exactamente con las definidas en el `.env` del paso anterior.

---

## Paso 6: Verificar que Git NO rastrea secretos

Ejecuta el chequeo de seguridad de gitignore:

```powershell
git check-ignore .env elite_multiservicios_server/config/passwords.yaml
```

Ambos archivos **deben aparecer en la salida**. Si alguno no aparece, **DETENTE** e infórmale al humano que `.gitignore` debe corregirse antes de continuar.

---

## Paso 7: Levantar la infraestructura en Docker

Inicia los contenedores de PostgreSQL y Redis:

**En Windows (PowerShell):**
```powershell
cd elite_multiservicios_server
docker compose up -d
docker compose ps
cd ..
```

Verifica que los 4 servicios figuren con estado `Up`:
- `postgres` (puerto local `8090`)
- `redis` (puerto local `8091`)
- `postgres_test` (puerto local `9090`)
- `redis_test` (puerto local `9091`)

---

## Paso 8: Aplicar migraciones y levantar el backend Serverpod

Ejecuta las migraciones estructurales e inicializa Serverpod:

**En Windows (PowerShell):**
```powershell
cd elite_multiservicios_server
dart bin/main.dart --apply-migrations
```

> **Nota**: este proceso bloquea la terminal. Ábrelo en una terminal nueva y déjalo corriendo mientras trabajas en otros pasos.

Espera a que aparezcan los mensajes:
`SERVERPOD initialized` y `WebServer listening on http://localhost:8082`.

---

## Paso 9: Levantar la aplicación Flutter

Abre una terminal adicional:

**En Windows (PowerShell):**
```powershell
# Verificar que el backend responde
curl http://localhost:8082
# Debe devolver HTML o JSON. Si falla, esperar 5-10 segundos y reintentar.

cd elite_multiservicios_flutter
flutter pub get
flutter run -d chrome
```
*(O `flutter run -d windows` si el entorno es de escritorio).*

Las credenciales para el inicio de sesión son las configuradas en `.env`:
- **Usuario**: el valor de `SEED_ADMIN_EMAIL`
- **Contraseña**: el valor de `SEED_ADMIN_PASSWORD`

---

## Paso 10: Verificar el entorno completo

Dile al humano:
> *"Abre en tu navegador [http://localhost:8082](http://localhost:8082). Debe mostrar la página de estado web del servidor Serverpod.*
> *Luego dirígete a la ventana de la aplicación Flutter e inicia sesión con tus credenciales de administrador.*
> *Si ingresas exitosamente al Dashboard de Seguridad, ¡tu entorno está 100% operativo!"*

---

## Paso 11: Configurar el MCP de Google Stitch (Opcional)

Si el humano te proporcionó su `STITCH_API_KEY`:
1. Ejecuta el proxy MCP para verificar conectividad con Google:
   ```powershell
   npx -y @_davideast/stitch-mcp proxy
   ```
2. Comprueba que el servidor MCP `stitch` aparezca con estado **Conectado** en el panel de herramientas del IDE (Antigravity o Cursor).

Si no cuenta con la clave aún, dile:
> *"Puedes generar tu API Key de Stitch en [https://stitch.withgoogle.com](https://stitch.withgoogle.com) → Settings → API Keys. Cuando la tengas, solo agrégala a tu `.env` como `STITCH_API_KEY=tu_clave`."*

---

## Paso 12: Instrucciones finales al humano

Comunícale al humano el siguiente resumen de trabajo:

> *"🎉 **¡Entorno de desarrollo configurado con éxito!** Ya puedes comenzar a programar.*
> 
> *📌 **Reglas obligatorias de flujo Git en el proyecto:***
> 1. *Nunca hagas `git push` directo a `main` ni a `develop` (están protegidas por Rulesets).*
> 2. *Crea siempre una rama de tarea: `git checkout -b feat/nombre-de-tarea` (o `fix/`, `chore/`, etc.).*
> 3. *Nunca agregues `.env`, `passwords.yaml` ni archivos de claves a Git.*
> 4. *Antes de subir cualquier cambio, valida la suite de calidad local:*
>    - `dart format --set-exit-if-changed .`
>    - `flutter analyze`
>    - `flutter test`
>    - `dart analyze`
>    - `dart test`
> 5. *Sube tu rama (`git push -u origin tu-rama`) y abre un Pull Request apuntando a `develop`.*
> 6. *El pipeline de CI (Gitleaks, análisis estático, tests Flutter y tests Serverpod) debe pasar en verde para que `@rogelio888` apruebe el merge.*
> 
> *Si necesitas detalles técnicos profundos, consulta el archivo `README.md` o la documentación en `docs/`."*
