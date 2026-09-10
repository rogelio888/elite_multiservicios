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

### Tablas e Índices Clave:
1. **`app_user`**:
   - `id`: PK bigserial.
   - `email`: Text NOT NULL (Índice único: `app_user_email_idx`).
   - `fullName`: Text NOT NULL.
   - `userInfoId`: Bigint nullable (vínculo con `serverpod_user_info`).
   - `isActive`: Boolean NOT NULL.
   - `isDeleted`: Boolean NOT NULL (Soft Delete).
   - `createdAt`, `updatedAt`: Timestamps UTC.
2. **`app_role`**:
   - `name`: Text NOT NULL (Índice único: `app_role_name_idx`).
   - `description`: Text NOT NULL.
   - `isSystemRole`: Boolean NOT NULL.
3. **`app_permission`**:
   - `code`: Text NOT NULL (Índice único: `app_permission_code_idx`).
   - `module`: Text NOT NULL.
   - `description`: Text NOT NULL.
4. **`user_role`**:
   - `userId`: FK $\rightarrow$ `app_user(id)` ON DELETE CASCADE.
   - `roleId`: FK $\rightarrow$ `app_role(id)` ON DELETE CASCADE.
   - Índice compuesto único: `user_role_composite_idx (userId, roleId)`.
5. **`role_permission`**:
   - `roleId`: FK $\rightarrow$ `app_role(id)` ON DELETE CASCADE.
   - `permissionId`: FK $\rightarrow$ `app_permission(id)` ON DELETE CASCADE.
   - Índice compuesto único: `role_permission_composite_idx (roleId, permissionId)`.
6. **`audit_log`**:
   - `action`, `resource`, `ipAddress`, `result`, `metadata`, `timestamp`.
   - `userId`: FK $\rightarrow$ `app_user(id)` ON DELETE SET NULL.
   - Índices: `timestamp`, `action`, `userId`.
7. **`user_session`**:
   - `userId`: FK $\rightarrow$ `app_user(id)` ON DELETE CASCADE.
   - `sessionTokenHash`: Text NOT NULL (Índice único).
   - `isRevoked`, `createdAt`, `lastActivityAt`, `expiresAt`.

---

## 3. Repositorios de Persistencia Implementados
- `UserRepository`: Búsqueda por email/ID, listado paginado, activación y soft delete.
- `RbacRepository`: Asignación y revocación de roles/permisos, resolución de permisos efectivos por usuario mediante joins relacionales.
- `AuditRepository`: Inserción de eventos de bitácora y consulta filtrada por usuario/acción.
- `ServerpodAuditService`: Servicio transversal con logging de sesión y guardado automático en PostgreSQL.

---

## 4. Estado de Implementación
- **Fase 1**: Andamiaje base, CI/CD, Git Flow y directivas de seguridad backend-first (**COMPLETADO**).
- **Fase 2**: Modelos `.spy.yaml`, generación de contratos, migraciones PostgreSQL aplicadas y repositorios relacionales (**COMPLETADO**).
- **Fase 3 (Siguiente)**: Endpoints RPC de Serverpod (CRUD de usuarios, gestión de roles/permisos y consulta de bitácora) y protección estricta con `RbacGuard`.
