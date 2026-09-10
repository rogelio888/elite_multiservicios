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

## 5. Estado de Implementación
- **Fase 1**: Andamiaje base, CI/CD, Git Flow y directivas de seguridad backend-first (**COMPLETADO**).
- **Fase 2**: Modelos `.spy.yaml`, generación de contratos, migraciones PostgreSQL aplicadas y repositorios relacionales (**COMPLETADO**).
- **Fase 3**: Endpoints RPC de Serverpod con protección `RbacGuard`, logging automático y seeds de inicialización (**COMPLETADO**).
- **Fase 4 (Siguiente)**: Interfaz de usuario en Flutter (Pantalla de Administración de Seguridad, gestión visual de usuarios, roles, permisos y bitácora consumiendo los endpoints RPC reales).
