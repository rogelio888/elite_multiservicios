# Estrategia de Ramas y Flujo Git (Git Workflow)

## 1. Reglas Absolutas e Innegociables
- **PROHIBIDO hacer commit o push directo a `main` o `develop`**.
- Todo cambio debe integrarse mediante un **Pull Request** formal con revisión de código y CI aprobado.
- **NUNCA subir cambios directamente a producción**.
  - Flujo obligatorio: `feature/*` $\rightarrow$ PR $\rightarrow$ CI & Review $\rightarrow$ `develop` $\rightarrow$ Staging $\rightarrow$ Aprobación Formal $\rightarrow$ `main` (Producción).

---

## 2. Convención de Ramas

```
main (Producción estable)
│
└── develop (Integración de desarrollo)
    │
    ├── feature/authentication-flow
    ├── feature/user-management
    ├── feature/rbac-permissions
    ├── fix/session-timeout
    ├── refactor/audit-logger
    └── docs/api-specification
```

### Prefijos Permitidos:
- `feature/<nombre>`: Nuevas capacidades o funcionalidades.
- `fix/<nombre>`: Correcciones de defectos.
- `refactor/<nombre>`: Mejoras de código sin cambio de comportamiento.
- `chore/<nombre>`: Actualizaciones de herramientas, dependencias o tareas menores.
- `docs/<nombre>`: Modificaciones exclusivas de documentación.
- `test/<nombre>`: Incorporación o actualización de pruebas.

---

## 3. Ciclo de Vida de una Tarea

1. **Sincronizar y crear rama desde `develop`**:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/nombre-de-la-tarea
   ```
2. **Desarrollo y validación local estricta**:
   Antes de hacer commit, ejecutar el ciclo de calidad:
   ```bash
   # 1. Formatear
   dart format .
   # 2. Analizar servidor y cliente
   cd elite_multiservicios_server && dart analyze
   cd ../elite_multiservicios_flutter && flutter analyze
   # 3. Ejecutar pruebas
   flutter test
   cd ../elite_multiservicios_server && dart test test/unit/domain_security_test.dart
   ```
3. **Commit semántico**:
   ```bash
   git add .
   git commit -m "feat: implementar validación RBAC de usuarios"
   ```
4. **Push y creación de Pull Request**:
   ```bash
   git push -u origin feature/nombre-de-la-tarea
   ```
5. **Completar la plantilla del PR (`.github/PULL_REQUEST_TEMPLATE.md`)**.
6. **Aprobación de Code Review y paso de CI requerido para el merge**.
