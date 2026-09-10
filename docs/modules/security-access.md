# Especificación: Módulo de Seguridad y Accesos

El **Módulo de Seguridad y Accesos** es el núcleo transversal del Sistema Empresarial. Todos los módulos subsecuentes (Administración, RRHH, Contabilidad, etc.) dependerán de los servicios provistos por este módulo.

## 1. Alcance Funcional
```
MÓDULO SEGURIDAD Y ACCESOS
│
├── Gestión de Usuarios (CRUD, activación, asignación de roles)
├── Control de Accesos basado en Roles (RBAC granular)
├── Políticas de Contraseñas (longitud, entropía, expiración)
├── Autenticación y Sesiones (login, logout, revocación)
├── Bitácora de Eventos (registro inmutable de acciones clave)
├── Monitoreo de Sesiones Activas (concurrencia y cierre remoto)
├── Métricas de Rendimiento del Servidor (salud, tiempos de respuesta)
└── Mantenimiento y Operaciones (migraciones, tareas programadas)
```

## 2. Eventos Clave de la Bitácora (Audit Logging)
Los siguientes eventos canónicos deben ser emitidos y registrados formalmente:
- `LOGIN_SUCCESS` / `LOGIN_FAILED`
- `LOGOUT`
- `USER_CREATED` / `USER_UPDATED` / `USER_DISABLED`
- `ROLE_CREATED` / `ROLE_UPDATED`
- `PERMISSION_CHANGED`
- `PASSWORD_CHANGED`
- `SESSION_REVOKED`

## 3. Estado de Implementación
- **Fase 1 (Actual)**: Andamiaje arquitectónico base establecido, contratos de excepciones, guardias de autorización (`RbacGuard`), catálogo de permisos (`AppPermissions`), contratos de auditoría (`AuditService`) y enrutamiento visual en Flutter.
- **Fase 2 (Siguiente)**: Modelado de tablas en Serverpod (`User`, `Role`, `Permission`, `UserRole`, `RolePermission`, `AuditLog`), endpoints RPC y vistas operativas en Flutter.
