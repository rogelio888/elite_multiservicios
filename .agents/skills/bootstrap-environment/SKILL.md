---
name: bootstrap-environment
description: Prepara el entorno completo de desarrollo (Docker + backend + frontend) para que el colaborador pueda empezar a trabajar sin pasos manuales.
---

# Bootstrap Environment Skill

## Cuándo usar
Cuando el colaborador dice frases como:
- "Prepara mi entorno"
- "Empezar con el módulo X"
- "Levanta todo el entorno"
- "Necesito empezar a trabajar"

## Prerequisitos
- Docker Desktop instalado y abierto.
- Flutter SDK instalado.
- Dart SDK instalado.
- Archivo `.env` configurado con `SEED_ADMIN_EMAIL` y `SEED_ADMIN_PASSWORD`.
- Archivo `elite_multiservicios_server/config/passwords.yaml` configurado.

## Pasos

### 1. Verificar prerequisitos

```powershell
docker --version
flutter --version
dart --version
Test-Path .env
Test-Path elite_multiservicios_server/config/passwords.yaml
```

Si algún comando falla, **DETENERSE** y avisar al colaborador.

Si `.env` no existe, avisar:
> *"Ejecutá primero `copy .env.example .env` y completá las variables."*

### 2. Verificar que Docker Desktop esté corriendo

```powershell
docker info
```

Si falla con `"Cannot connect to the Docker daemon"`, **DETENERSE** y avisar:
> *"Por favor, abrí Docker Desktop y esperá a que el ícono esté verde."*

### 3. Levantar contenedores

```powershell
cd elite_multiservicios_server
docker compose up -d
docker compose ps
cd ..
```

Verificar que los 4 servicios estén `Up`: `postgres`, `redis`, `postgres_test`, `redis_test`.

Si alguno no está `Up`, esperar 5 segundos y reintentar `docker compose ps`.

### 4. Cargar variables de entorno del .env

Leer `.env` y extraer:
- `SEED_ADMIN_EMAIL`
- `SEED_ADMIN_PASSWORD`

Guardarlas como variables del shell:
```powershell
$env:SEED_ADMIN_EMAIL = "<valor del .env>"
$env:SEED_ADMIN_PASSWORD = "<valor del .env>"
```

### 5. Levantar backend con migraciones y seed

> **Nota**: El comando `dart bin/main.dart --apply-migrations --seed` bloquea la terminal.
> 
> **Opción recomendada**: usar el script dedicado:
> ```powershell
> cd elite_multiservicios_server
> powershell -ExecutionPolicy Bypass -File scripts/run-server.ps1
> ```
> Este comando también bloquea, así que ejecutarlo en una terminal en background.
> 
> **Opción manual**: usar `$env:SEED_ADMIN_EMAIL = "..."` y `$env:SEED_ADMIN_PASSWORD = "..."` antes de `dart bin/main.dart`.

### 6. Esperar a que el backend arranque

Verificar que http://localhost:8082 responde:

```powershell
curl http://localhost:8082
```

Si falla, esperar 5 segundos y reintentar.

### 7. Levantar Flutter

En otra terminal:

```powershell
cd elite_multiservicios_flutter
flutter pub get
flutter run -d chrome
```

### 8. Reportar al colaborador

```text
## Entorno listo

- ✅ Docker: 4/4 servicios Up
- ✅ Backend: corriendo en http://localhost:8082
- ✅ Seed: admin creado (admin@elitemultiservicios.com)
- ✅ Flutter: corriendo en http://localhost:55002

## Credenciales
- Email: admin@elitemultiservicios.com
- Password: <la del .env>

## Próximos pasos
- Abrí http://localhost:55002 en tu navegador.
- Hacé login con las credenciales de arriba.
- Cuando termines de trabajar, avisame y detengo los servicios.
```

## Reglas
- **NUNCA** hardcodees la contraseña en el reporte. Leela del `.env`.
- Si algo falla, **DETENERSE** y avisar con el error exacto.
- En español.

## Ejemplo de uso
Colaborador: *"Voy a empezar con el módulo de Login. Prepara mi entorno."*

IA:
1. Ejecuta los pasos.
2. Reporta el estado.
3. Deja los servicios corriendo.
4. Pregunta: *"¿Querés que abra el navegador?"*

## Cómo detener el entorno
Cuando el colaborador diga *"detén el entorno"*:

```powershell
# Detener Flutter (Ctrl+C en su terminal)
# Detener backend (Ctrl+C)
cd elite_multiservicios_server
docker compose down
```
