---
name: security-review
description: Protocolo de revisión de seguridad y autorización backend-first para Serverpod y Flutter.
---

# Security Review Skill

Cada vez que se introduzcan cambios relacionados con autenticación, endpoints o control de accesos:

1. **Backend First**: Comprobar que el endpoint en Serverpod cuente con validación `RbacGuard.requirePermission(...)`. Ocultar un botón en Flutter NO es seguridad.
2. **Granularidad RBAC**: Verificar que no se use `user.role == 'admin'`. Todo acceso debe ampararse en un permiso de `AppPermissions`.
3. **Auditoría**: Registrar eventos críticos en `AuditService` (`AuditEventRecord`).
4. **Higiene de Logs**: Asegurarse de no loguear contraseñas, hashes, tokens JWT ni datos personales sensibles en texto plano.
5. **Cero Secretos**: Verificar que `passwords.yaml` y `.env` sigan ignorados por Git.
