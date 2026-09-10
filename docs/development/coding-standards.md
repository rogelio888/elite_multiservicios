# Estándares de Código y Buenas Prácticas

## 1. Principios Generales
- **Separación Estricta de Responsabilidades**:
  - Los endpoints solo deserializan, validan sesión/permisos y delegan a servicios.
  - Los servicios contienen la lógica de negocio y validaciones de dominio.
  - Los repositorios ejecutan consultas contra la base de datos (PostgreSQL).
  - Los widgets de Flutter solo presentan estado y capturan interacciones del usuario; **cero lógica de negocio ni consultas directas en widgets**.
- **Null Safety y Tipado Estricto**: Prohibido el uso de `dynamic` salvo cuando la serialización de bibliotecas externas lo exija explícitamente.
- **Funciones y Clases Concisas**: Funciones no mayores a 50 líneas y clases orientadas a una única responsabilidad (SRP).

## 2. Reglas Específicas del Backend (Serverpod)
- **Autorización Obligatoria**: Todo endpoint sensible debe verificar permisos mediante `RbacGuard.requirePermission(session, AppPermissions.<permiso>)`.
- **Manejo de Excepciones**: No silenciar excepciones con bloques `catch` vacíos. Mapear errores de dominio a la jerarquía de `AppException`.
- **Código Generado**: Tratar `lib/src/generated/` y `elite_multiservicios_client/` como zonas de solo lectura. Modificar siempre el archivo fuente `.spy.yaml` o endpoint correspondiente y ejecutar `serverpod generate`.

## 3. Reglas Específicas del Frontend (Flutter)
- **UI & UX Premium**: Seguir las directrices de diseño corporativo moderno definidas en `AppTheme`.
- **Microinteracciones Fluidas**: Usar transiciones suaves, retroalimentación visual inmediata en estados de carga y manejo accesible de errores.
- **Autorización Visual**: Ocultar botones mediante `PermissionChecker` para mejorar la ergonomía del usuario, documentando que la seguridad real reside en el servidor.

## 4. Política de Dependencias
- No añadir paquetes externos sin justificación documentada.
- Preferir siempre soluciones nativas del SDK de Dart, Flutter o Serverpod antes de agregar dependencias de terceros.
