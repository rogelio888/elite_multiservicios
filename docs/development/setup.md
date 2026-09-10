# Guía de Instalación y Configuración Local (Setup)

Esta guía describe el procedimiento exacto para poner en marcha el entorno de desarrollo desde cero.

## 1. Requisitos Previos

Asegúrate de contar con las siguientes herramientas instaladas en tu sistema:
- **Git** (v2.40+ recomendado)
- **Dart SDK** (v3.8.0+ / v3.11.x)
- **Flutter SDK** (v3.24+ / v3.41.x canal stable)
- **Docker Desktop** (con soporte para Linux Containers activo)
- **Serverpod CLI** (v3.4.13)

### Instalación del CLI de Serverpod
Si aún no tienes el CLI instalado en Dart Pub Cache, ejecútalo mediante:
```bash
dart pub global activate serverpod_cli
```
Asegúrate de que `C:\Users\<TuUsuario>\AppData\Local\Pub\Cache\bin` esté incluido en la variable de entorno `PATH`.

---

## 2. Pasos de Instalación

### Paso 1: Clonar el Repositorio
```bash
git clone <url-del-repositorio>
cd elite_multiservicios
```

### Paso 2: Instalar Dependencias del Workspace
Dado que el proyecto utiliza un Dart Workspace unificado:
```bash
flutter pub get
```

### Paso 3: Configurar Secretos Locales
1. Navega a `elite_multiservicios_server/config/`.
2. Si no existe `passwords.yaml`, copia el archivo de ejemplo:
   ```bash
   cp config/passwords.yaml.example config/passwords.yaml
   ```
3. Verifica las credenciales locales de desarrollo y pruebas.

### Paso 4: Iniciar Base de Datos y Servicios (Docker)
Inicia PostgreSQL y Redis mediante Docker Compose:
```bash
cd elite_multiservicios_server
docker compose up -d
```
Esto levantará:
- **PostgreSQL Dev**: `localhost:8090`
- **Redis Dev**: `localhost:8091`
- **PostgreSQL Test**: `localhost:9090`
- **Redis Test**: `localhost:9091`

### Paso 5: Aplicar Migraciones de Base de Datos
Aplica las migraciones iniciales sobre PostgreSQL:
```bash
cd elite_multiservicios_server
dart run bin/main.dart --apply-migrations
```

### Paso 6: Iniciar el Servidor Backend
Inicia el servidor en modo desarrollo:
```bash
cd elite_multiservicios_server
dart run bin/main.dart --mode development
```
El servidor quedará escuchando en:
- **API Serverpod**: `http://localhost:8080/`
- **Insights & Web**: `http://localhost:8082/`

### Paso 7: Iniciar la Aplicación Flutter
En una terminal separada:
```bash
cd elite_multiservicios_flutter
flutter run -d chrome # o -d windows
```

---

## 3. Regeneración de Protocolos
Siempre que modifiques modelos `.spy.yaml` o endpoints en `elite_multiservicios_server`:
```bash
cd elite_multiservicios_server
serverpod generate
```
Nunca edites manualmente los archivos dentro de `elite_multiservicios_client` ni `lib/src/generated/`.
