# Guía de Resolución de Problemas de Inicio de Sesión y Seguridad

## Orden correcto del flujo post-login

El flujo de navegación posterior al ingreso de credenciales debe respetar rigurosamente la jerarquía de seguridad del backend:

1. **Login de credenciales** (`emailIdp.login`): Verifica correo y contraseña en Auth IDP.
2. **Autenticación Multifactor (MFA)**: Si el usuario tiene MFA activado (`mfaEnabled=true`), se debe presentar primero `MfaVerificationScreen`.
3. **Cambio obligatorio de contraseña (`mustChangePassword`)**: Si el usuario requiere actualizar su credencial (`user.mustChangePassword=true`), se muestra `ForcePasswordChangeScreen`.
4. **Dashboard principal (`SecurityShellScreen`)**: Una vez satisfechos todos los pasos previos.

### ¿Por qué es crítico el orden MFA antes de cambio de contraseña?
El endpoint `UserEndpoint.changePassword` está protegido por la regla RBAC `RbacGuard.requireMfaVerified(session)`. Si un usuario con MFA habilitado intenta cambiar su contraseña antes de validar el código de 6 dígitos, el backend rechazará la operación con:
```
ERROR: AppException: Esta operación requiere verificación previa de autenticación multifactor (MFA). (code: MFA_REQUIRED)
```
Al resolver el desafío MFA en primer lugar, la sesión activa se eleva a `mfaVerified=true`, permitiendo que el endpoint de cambio de contraseña valide exitosamente los permisos de la sesión.
