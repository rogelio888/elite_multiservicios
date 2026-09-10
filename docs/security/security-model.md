# Modelo de Seguridad y Control de Accesos (RBAC)

## 1. Principio Fundamental
El modelo de seguridad se basa en una arquitectura **RBAC (Role-Based Access Control) granular orientada a permisos**.

```
Usuario (User)
   │
   └── Roles (Rol)
         │
         └── Permisos Granulares (Permissions)
```

### Regla Crítica:
Está estrictamente prohibido validar operaciones mediante comprobaciones genéricas del tipo:
```dart
// PROHIBIDO como mecanismo principal de autorización:
if (user.role == 'admin') { ... }
```
La validación se realiza siempre a nivel de **permisos específicos**:
```dart
// CORRECTO:
RbacGuard.requirePermission(session, AppPermissions.usersCreate, userPermissions: permissions);
```

---

## 2. Catálogo Canónico de Permisos Granulares
Definidos centralizadamente en `AppPermissions`:

| Módulo | Clave de Permiso | Descripción |
| :--- | :--- | :--- |
| **Usuarios** | `users.view` | Consulta del listado y detalles de usuarios |
| | `users.create` | Creación de nuevos colaboradores en el sistema |
| | `users.update` | Modificación de información de usuario |
| | `users.disable` | Desactivación o bloqueo de cuentas |
| | `users.delete` | Eliminación definitiva o soft-delete |
| **Roles & RBAC** | `roles.view` | Lectura de catálogo de roles |
| | `roles.manage` | Creación y edición de roles |
| | `permissions.view` | Consulta del catálogo de permisos |
| | `permissions.assign`| Asignación de permisos a roles |
| **Auditoría** | `audit.view` | Acceso a la bitácora de eventos del sistema |
| | `audit.export` | Exportación de reportes de auditoría |
| **Sesiones** | `sessions.view` | Visualización de sesiones activas en el servidor |
| | `sessions.revoke` | Cierre forzoso de sesiones activas |
| **Monitoreo** | `metrics.view` | Consulta del estado de salud del servidor |
| **Operaciones** | `system.maintenance`| Ejecución de tareas administrativas y operativas |

---

## 3. Manejo de Sesiones y Secretos
- **Cero secretos en el repositorio**: `config/passwords.yaml` y variables de entorno `.env` están rigurosamente excluidos en `.gitignore`.
- **Criptografía**: Se emplean las capacidades nativas de hashing y firma JWT de Serverpod (`emailSecretHashPepper`, `jwtHmacSha512PrivateKey`, `jwtRefreshTokenHashPepper`). Prohibido implementar criptografía manual casera.
- **Auditoría no intrusiva**: La bitácora registra `quién`, `qué`, `cuándo`, `desde dónde`, `recurso` y `resultado`, excluyendo contraseñas, tokens y datos sensibles en texto plano.
