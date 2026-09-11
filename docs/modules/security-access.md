# Especificación: Módulo de Seguridad y Accesos

El **Módulo de Seguridad y Accesos** es el núcleo transversal del Sistema Empresarial. Todos los módulos subsecuentes (Administración, RRHH, Contabilidad, etc.) dependerán de los servicios provistos por este módulo.

## 1. Alcance Funcional
```
MÓDULO SEGURIDAD Y ACCESOS
│
├── Gestión de Usuarios (CRUD, activación, soft-delete, asignación de roles)
├── Control de Accesos basado en Roles (RBAC granular por permisos)
├── Políticas de Contraseñas (longitud, entropía, expiración)
├── Autenticación y Sesiones (login, logout, control de concurrencia, revocación)
├── Bitácora de Eventos (registro inmutable de acciones en PostgreSQL)
├── Monitoreo de Sesiones Activas (concurrencia, IP, dispositivo y revocación)
├── Métricas de Rendimiento del Servidor (salud, tiempos de respuesta)
└── Mantenimiento y Operaciones (migraciones formales, tareas programadas)
```

## 2. Esquema Relacional de Base de Datos (PostgreSQL)

El módulo cuenta con persistencia real e integridad referencial estricta en PostgreSQL generada mediante Serverpod:

```
[app_user] (1) <---> (N) [user_role] (N) <---> (1) [app_role]
                                                      | (1)
                                                      |
                                                      v (N)
                                              [role_permission]
                                                      | (N)
                                                      |
                                                      v (1)
                                              [app_permission]

[app_user] (1) <---> (N) [audit_log] (Bitácora inmutable)
[app_user] (1) <---> (N) [user_session] (Monitoreo de sesiones)
```

---

## 3. Endpoints RPC Implementados (Serverpod)

Todos los endpoints están fuertemente tipados, expuestos al cliente y blindados mediante `RbacGuard`:

### 1. `UserEndpoint` (`client.user`)
- `listUsers(limit, offset, includeDeleted)`: Requiere `users.view`.
- `getUser(id)`: Requiere `users.view`.
- `createUser(email, fullName, roleIds)`: Requiere `users.create`. Emite evento de bitácora `USER_CREATED`.
- `updateUser(id, fullName)`: Requiere `users.update`. Emite evento de bitácora `USER_UPDATED`.
- `setUserActive(id, isActive)`: Requiere `users.disable`. Emite `USER_DISABLED` o `USER_UPDATED`.
- `deleteUser(id)`: Requiere `users.delete`. Borrado lógico con evento `USER_DISABLED`.

### 2. `RbacEndpoint` (`client.rbac`)
- `listRoles()`: Requiere `roles.view`.
- `listPermissions()`: Requiere `permissions.view`.
- `assignRoleToUser(userId, roleId)`: Requiere `roles.manage`. Emite `ROLE_UPDATED`.
- `removeRoleFromUser(userId, roleId)`: Requiere `roles.manage`. Emite `ROLE_UPDATED`.
- `assignPermissionToRole(roleId, permissionId)`: Requiere `permissions.assign`. Emite `PERMISSION_CHANGED`.
- `getUserEffectivePermissions(userId)`: Requiere `roles.view`. Resuelve la jerarquía relacional completa en PostgreSQL.

### 3. `AuditEndpoint` (`client.audit`)
- `listLogs(limit, offset, userId, action)`: Requiere `audit.view`. Consulta la bitácora inmutable de PostgreSQL.

### 4. `SessionManagementEndpoint` (`client.sessionManagement`)
- `listUserSessions(userId)`: Requiere `sessions.view`.
- `revokeSession(sessionId)`: Requiere `sessions.revoke`. Cierre forzado con emisión de `SESSION_REVOKED`.

---

## 4. Seeds y Datos Reales
- `SecuritySeed.seed(session)`: Inserta en PostgreSQL el catálogo oficial de permisos canónicos (`AppPermissions.all`) y crea el rol `Super Administrador` con asignación completa de permisos sin requerir datos mockeados.

---

## 5. Arquitectura de Interfaz de Usuario (Flutter)

La interfaz de usuario del módulo está construida bajo una estética corporativa premium de alto nivel, soporte para temas claro/oscuro dinámicos y arquitectura responsiva:

### Estructura de Componentes
1. **`SecurityShellScreen`**: Contenedor principal con navegación por Sidebar corporativo colapsable, indicador de estado de conexión RPC y selector de tema dinámico.
2. **`SecurityDashboardView`**: Métricas en tiempo real (`SecurityStatCard`), estadísticas de usuarios activos, sesiones e incidentes, y accesos rápidos a módulos de seguridad.
3. **`UsersManagementView`**: Tabla responsiva de administración de usuarios, creación de cuentas con asignación de roles, activación/desactivación inmediata y borrado lógico con confirmación dialogada.
4. **`RolesRbacView`**: Matriz de inspección de roles y permisos granulares, sincronizada directamente con la jerarquía relacional de Serverpod.
5. **`AuditLogView`**: Bitácora de trazabilidad con badges de resultado (`StatusBadge`), filtros rápidos y diálogo de detalle de payload.
6. **`ActiveSessionsView`**: Monitor de sesiones concurrentes con IP, dispositivo y revocación forzada en un clic.

### Servicio de Consumo Backend
- **`SecurityApiService`**: Capa desacoplada que consume directamente el cliente fuertemente tipado de Serverpod (`Client client`) contra PostgreSQL sin mocks.

---

## 6. Estado de Implementación
- **Fase 1**: Andamiaje base, CI/CD, Git Flow y directivas de seguridad backend-first (**COMPLETADO**).
- **Fase 2**: Modelos `.spy.yaml`, generación de contratos, migraciones PostgreSQL aplicadas y repositorios relacionales (**COMPLETADO**).
- **Fase 3**: Endpoints RPC de seguridad, RBAC Guard, auditoría en tiempo real y tests unitarios (**COMPLETADO**).
- **Fase 4**: Interfaz de usuario corporativa Flutter, Dashboard, Gestión de Usuarios, RBAC Matrix, Bitácora y Sesiones (**COMPLETADO**).
