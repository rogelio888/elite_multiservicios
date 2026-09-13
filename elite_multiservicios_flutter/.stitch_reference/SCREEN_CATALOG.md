# Catálogo Oficial de Pantallas Google Stitch — Elite Multiservicios

**Proyecto Stitch ID**: `17779301282544970984`  
**Última actualización**: 2026-09-13  
**Estado**: 100% Implementado y Verificado (42/42 Tests pasando, 0 errores en `flutter analyze`)

---

## Módulos y Pantallas Oficiales Activas

### 1. Panel de Control de Seguridad (Dashboard)
- **Desktop (Oficial con Sidebar)**:
  - **Screen ID**: `5cb0ceba1c604ac391a1759bf1cb1eb9`
  - **Título**: `Elite Multiservicios - Panel de Control de Seguridad (Dark Mode con Sidebar)`
  - **Contrato HTML**: `elite_multiservicios_flutter/.stitch_reference/security_dashboard.html`
  - **Implementación Flutter**: [`lib/features/security/presentation/views/security_dashboard_view.dart`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/presentation/views/security_dashboard_view.dart) & [`lib/features/security/presentation/security_shell_screen.dart`](file:///c:/Users/rogel/OneDrive/Escritorio/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/presentation/security_shell_screen.dart)

### 2. Autenticación & Acceso (Login)
- **Desktop**:
  - **Screen ID**: `a2d22c1a844c4ce6a2216563099ecbfa`
  - **Título**: `Elite Multiservicios - Login (Dark Theme)`
- **Móvil (390px)**:
  - **Screen ID**: `336b214acec949198873715524accfc3`
  - **Título**: `Elite Multiservicios - Login (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/login_screen.dart`

### 3. Verificación MFA en Dos Pasos (2FA)
- **Desktop**:
  - **Screen ID**: `da968cefcce34850bf7853b1069ed50f`
  - **Título**: `Elite Multiservicios - Verificación MFA (Dark Theme)`
- **Móvil (390px)**:
  - **Screen ID**: `e626a6f1d88143c5b0da4570e45762d2`
  - **Título**: `Elite Multiservicios - Verificación MFA Móvil (2FA)`
- **Implementación Flutter**: `lib/features/security/presentation/recovery/mfa_verification_screen.dart`

### 4. Cambio Obligatorio de Contraseña (Primer Inicio / Expirada)
- **Desktop**:
  - **Screen ID**: `36ff8f42f88b43b2b1f07ddd47a1eabf`
  - **Título**: `Elite Multiservicios - ForcePasswordChangeScreen`
- **Móvil (390px)**:
  - **Screen ID**: `95173eab97e24860abe16be803e46cae`
  - **Título**: `Elite Multiservicios - ForcePasswordChange (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/recovery/force_password_change_screen.dart`

### 5. Recuperación de Contraseña (Solicitud de Enlace / Código)
- **Desktop**:
  - **Screen ID**: `1a2bc77b9267492aba88b9c0ce93aaa7`
  - **Título**: `Elite Multiservicios - Recuperar Contraseña (Dark Theme v2)`
- **Móvil (390px)**:
  - **Screen ID**: `95cfc78b496d4823a07b2e0c52adc6f1`
  - **Título**: `Elite Multiservicios - Recuperar Contraseña (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/recovery/forgot_password_screen.dart`

### 6. Verificación de Código de Recuperación
- **Desktop**:
  - **Screen ID**: `f6e8d6d45cec45319359a128ae62514f`
  - **Título**: `Elite Multiservicios - Verificar Código (Clon Login Exacto)`
- **Móvil (390px)**:
  - **Screen ID**: `f6bc716057b04c55a60112f84546d770`
  - **Título**: `Elite Multiservicios - Verificar Código (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/recovery/verify_code_screen.dart`

### 7. Restablecer Nueva Contraseña
- **Desktop**:
  - **Screen ID**: `ad867730a9764ab58931cc4263172af5`
  - **Título**: `Elite Multiservicios - Restablecer Contraseña (Dark Theme v2)`
- **Móvil (390px)**:
  - **Screen ID**: `77a128322a8b440dbc214a5794c129a9`
  - **Título**: `Elite Multiservicios - ResetPasswordScreen (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/recovery/reset_password_screen.dart`

### 8. Bitácora de Auditoría del Sistema
- **Desktop**:
  - **Screen ID**: `3fdbe54ee19a4596a4a1b97bba3544ec`
  - **Título**: `AuditLogViewImproved - Dark Mode`
- **Móvil (390px)**:
  - **Screen ID**: `f87bfd84bd834908a486a9d888fa4386`
  - **Título**: `Elite Multiservicios - Bitácora de Auditoría (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/views/audit_log_view.dart`

### 9. Telemetría y Métricas del Servidor
- **Desktop**:
  - **Screen ID**: `b441056c7667405390eebfdd58195740`
  - **Título**: `ServerMetricsView - Dark Mode (Telemetría y Estado del Servidor)`
- **Móvil (390px)**:
  - **Screen ID**: `ee17bd18e9f847e587a39a6cabc7337b`
  - **Título**: `ServerMetricsView - Telemetría Móvil (390px)`
- **Implementación Flutter**: `lib/features/security/presentation/views/server_metrics_view.dart`

### 10. Validador de Reglas de Contraseña (Widget)
- **Desktop / Dark**:
  - **Screen ID**: `23811c3994134c6499bc47bd386715f7`
  - **Título**: `PasswordRequirementsWidget (Dark Theme)`
- **Móvil**:
  - **Screen ID**: `697b7b29393b4fee9647e596b5f7e099`
  - **Título**: `PasswordRequirementsWidget (Móvil)`
- **Implementación Flutter**: `lib/features/security/presentation/widgets/password_requirements_widget.dart`

---

## Pantallas Descartadas / Obsoletas (No Usar)
- `52962aee9f4c46a2b1490ed68a8c7a3a`: Primera versión del dashboard sin sidebar (descartada).
- `fedba6616cbd4ee9b0f1ab8e9047807e`: AuditLogView previa en modo claro.
- `cbfe20d921724e2d809b484747be9b07`: ServerMetricsView previa en modo claro.
- `202662eca56749d3b5e623cebfb2854f`: Recuperar contraseña v1 (descartada por v2).
- `eef4a9c4fcc24e57a0a8c8823ad57950`: Recuperar contraseña v1 dark (descartada por v2).
- `3e92bdc168944966834465f837e186c0`: Restablecer contraseña v1 (descartada por v2).
- `e9b584acd3a144619c6fb34207ab08c8`: Restablecer contraseña v1 dark (descartada por v2).
- `e718bf2728ec49119459cac95eccfefe`: Verificar código v1 (descartada por clon login).
- `ca43e71358d743b08f66407a199158f7`: Verificar código v2 (descartada por clon login).
- `8d226f4a7cc3482b94f112ea3416a64b`: Login transitorio de validación.
- `4f6ad4eb53d24cbc82cfde85b8141076`: Login en modo claro.
- `a1a0499172aa417fb499c4c44172cc1e`: ForcePasswordChange v1.
- `3490b13624ee4b5da478e5a88a1ea402`: ForcePasswordChange estado error.
- `249a15163d4643d2be7d87a6560ec5dd`: MFA v1.
- `796a32dc7dc64c35b812f92bd95742ed`: Recuperar contraseña móvil redundante.
- `8b9aeac37f354e17b97be60a3648d5fc`: Restablecer contraseña móvil redundante.
- `a80ddcf9fc6044ada2682f704b0964e3`: Verificar código móvil redundante.
