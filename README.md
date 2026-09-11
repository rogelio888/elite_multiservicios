# Sistema Empresarial Modular — Elite Multiservicios

Plataforma empresarial integral y modular para la administración centralizada de áreas corporativas, construida con arquitectura **backend-first** de alta seguridad, escalabilidad y rendimiento.

---

## 1. Descripción
Elite Multiservicios es un sistema empresarial integral multiplataforma concebido para articular las operaciones comerciales, administrativas y de gestión de la empresa. Su diseño modular garantiza que cada nuevo dominio de negocio (Administración, Recursos Humanos, Contabilidad) se integre armónicamente sobre un núcleo robusto de seguridad, auditoría y control de accesos.

---

## 2. Objetivos
- Centralizar la operación corporativa bajo una plataforma segura y auditable.
- Implementar control de accesos granular basado en roles y permisos (RBAC).
- Mantener una estricta autoridad en el servidor (backend-first), garantizando que ninguna regla de negocio o autorización dependa únicamente del cliente.
- Asegurar calidad continua mediante pipelines automatizados de CI/CD y políticas estrictas de Definition of Done.

---

## 3. Arquitectura
El sistema se compone de tres capas desacopladas mediante contratos fuertemente tipados:

```text
                         SISTEMA EMPRESARIAL
                                 |
                 +---------------+---------------+
                 |                               |
                 v                               v
       FLUTTER CLIENT APP               SERVERPOD BACKEND
           (Frontend)                       (Dart Server)
                 |                               |
                 |                         Lógica de Negocio
                 |                         Autenticación JWT
                 |                         Autorización RBAC
                 |                         Auditoría Transversal
                 |                         Validaciones de Dominio
                 |                         Endpoints RPC
                 |                               |
                 +---------------+---------------+
                                 |
                                 v
                            POSTGRESQL
```

Para más detalles, consulta [docs/architecture/overview.md](docs/architecture/overview.md).

---

## 4. Stack Tecnológico
- **Diseño & Prototipado UI/UX**: Google Stitch (origen obligatorio de interfaces vía MCP).
- **Frontend**: Flutter (v3.41+ stable) & Dart.
- **Backend**: Serverpod (v3.4.13) & Dart (v3.11+).
- **Base de Datos**: PostgreSQL 16 (con soporte pgvector).
- **Caché / Mensajería**: Redis 6.2+.
- **Infraestructura Local**: Docker Desktop & Docker Compose.
- **Control de Versiones**: Git & GitHub.
- **IDE Asistido por IA**: Antigravity (integrado con Stitch MCP).
- **Metodología**: Scrum & GitHub Projects.

---

## 5. Requisitos
Antes de ejecutar el proyecto, asegúrate de tener instalado:
- **Git** (v2.40+)
- **Flutter SDK** (v3.24+ / v3.41.x canal stable)
- **Dart SDK** (v3.8.0+ / v3.11.x)
- **Docker Desktop** (con Linux containers habilitado)
- **Serverpod CLI** (v3.4.13):
  ```bash
  dart pub global activate serverpod_cli
  ```

---

## 6. Instalación
Sigue estos pasos secuenciales:

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd elite_multiservicios

# 2. Descargar dependencias del workspace
flutter pub get
```

---

## 7. Configuración y Secretos
**PROHIBIDO subir archivos con contraseñas o secretos reales al repositorio.**

Copia el archivo de ejemplo a tu configuración local de desarrollo:
```bash
cp elite_multiservicios_server/config/passwords.yaml.example elite_multiservicios_server/config/passwords.yaml
```
El archivo `passwords.yaml` ya se encuentra estrictamente ignorado por `.gitignore`.

---

## 8. Base de Datos y Docker
Inicia los servicios locales de PostgreSQL y Redis:
```bash
cd elite_multiservicios_server
docker compose up -d
```
Aplica las migraciones iniciales a PostgreSQL:
```bash
dart run bin/main.dart --apply-migrations
```

---

## 9. Ejecución Local

### Iniciar Backend (Serverpod):
```bash
cd elite_multiservicios_server
dart run bin/main.dart --mode development
```
- API RPC: `http://localhost:8080/`
- Servidor Web/Insights: `http://localhost:8082/`

### Iniciar Frontend (Flutter):
En otra terminal:
```bash
cd elite_multiservicios_flutter
flutter run -d chrome # o -d windows
```

---

## 10. Estructura del Proyecto
```text
elite_multiservicios/
├── .github/
│   ├── workflows/ci.yml         # Pipeline automatizado de CI/CD
│   └── PULL_REQUEST_TEMPLATE.md # Plantilla obligatoria de PRs
├── docs/                        # Documentación técnica de arquitectura y procesos
├── elite_multiservicios_server/ # Backend Serverpod & PostgreSQL
│   ├── config/                  # Configuraciones por entorno y passwords.yaml.example
│   ├── lib/src/
│   │   ├── audit/               # Auditoría y bitácora de eventos
│   │   ├── authorization/       # RBAC granular y guards de permisos
│   │   ├── exceptions/          # Catálogo de excepciones de dominio
│   │   ├── modules/security/    # Lógica modular de seguridad
│   │   ├── repositories/        # Capa de persistencia
│   │   └── services/            # Servicios de negocio
│   └── migrations/              # Migraciones versionadas de PostgreSQL
├── elite_multiservicios_client/ # Cliente RPC autogenerado (SOLO LECTURA)
├── elite_multiservicios_flutter/# Aplicación cliente multiplataforma
│   └── lib/
│       ├── core/                # Routing, temas, constantes y utilidades
│       ├── features/security/   # Vistas y estado del módulo de seguridad
│       └── shared/              # Widgets y componentes transversales
├── .gitignore                   # Exclusión estricta de secretos y temporales
├── pubspec.yaml                 # Configuración del Dart Workspace unificado
└── README.md
```

---

## 11. Módulo de Seguridad y Accesos
Es el núcleo transversal del sistema. Provee:
- Gestión y ciclo de vida de usuarios.
- Control de accesos basado en roles (RBAC) con permisos granulares (`AppPermissions`).
- Autenticación segura y emisión de tokens JWT.
- Bitácora inmutable de eventos de auditoría (`AuditService`).
- Monitoreo de sesiones y métricas de servidor.

---

## 12. Git Workflow y Branching Strategy
- **Ramas Principales**:
  - `main`: Código en producción, 100% estable.
  - `develop`: Rama base de integración continua.
- **Ramas de Trabajo**:
  - `feature/<nombre>`: Nuevas funcionalidades.
  - `fix/<nombre>`: Correcciones de bugs.
  - `refactor/<nombre>`: Mejoras de código.
  - `docs/<nombre>`: Documentación.
- **Regla Innegociable**: Prohibido el commit o push directo a `main` o `develop`. Todo cambio requiere Pull Request y revisión por pares.

---

## 13. Testing y Calidad
Comandos obligatorios antes de realizar cualquier commit o PR:
```bash
# 1. Formateo de código
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático (0 errores / 0 warnings)
cd elite_multiservicios_server && dart analyze
cd ../elite_multiservicios_flutter && flutter analyze

# 3. Pruebas unitarias
flutter test
cd ../elite_multiservicios_server && dart test test/unit/domain_security_test.dart
```

---

## 14. CI/CD Pipeline
El flujo configurado en `.github/workflows/ci.yml` ejecuta automáticamente en cada Push o PR hacia `main` y `develop`:
1. Verificación de formato (`dart format`).
2. Análisis estático con fallas fatales ante cualquier advertencia (`dart analyze --fatal-infos`).
3. Ejecución de pruebas unitarias y de widgets en Flutter (`flutter test`).
4. Levantamiento de contenedores de base de datos y ejecución de tests en Serverpod.

---

## 15. Reglas de Oro
1. **Autoridad del Backend**: La seguridad NUNCA depende exclusivamente de Flutter. Toda operación sensible se valida en Serverpod.
2. **Cero Datos Falsos (No-Mock Policy)**: Prohibido el uso de mocks o datos simulados para aparentar funcionalidad terminada.
3. **No Mentir en Validaciones**: Nunca declarar que los tests o la compilación pasan sin haberlos ejecutado empíricamente.
4. **Respeto al Código Generado**: Prohibido editar manualmente el subpaquete `elite_multiservicios_client` o `lib/src/generated/`.
5. **Origen de Diseño Mandatorio (Google Stitch)**: Toda pantalla de usuario debe partir de un prototipo oficial en Google Stitch vía MCP. Para instrucciones completas, consulta [docs/development/stitch-mcp.md](docs/development/stitch-mcp.md).


---

## 16. Troubleshooting
- **Error conectando a Docker en Windows**:
  - Asegúrate de que Docker Desktop esté abierto y con el icono en verde.
  - Si aparece `El equipo remoto rechazó la conexión de red (port 9090 o 8090)`, ejecuta `docker compose up -d` dentro de `elite_multiservicios_server`.
- **Comando `serverpod` no reconocido**:
  - Verifica que `C:\Users\<TuUsuario>\AppData\Local\Pub\Cache\bin` esté agregado a tu variable de entorno `PATH`.
- **Desincronización de Protocolos**:
  - Ejecuta `serverpod generate` dentro de `elite_multiservicios_server`.
