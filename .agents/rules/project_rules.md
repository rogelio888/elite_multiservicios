# Reglas del Proyecto: Elite Multiservicios

1. **Autoridad Absoluta del Backend**:
   - Flutter solo adapta la UI/UX. La seguridad y validaciones residen 100% en Serverpod.
   - Prohibido autorizar solo con `if (user.role == 'admin')`. Usar `RbacGuard` con permisos granulares (`AppPermissions`).

2. **Política de Cero Mocks (No-Mock Policy)**:
   - Prohibido hardcodear datos de prueba o simular llamadas a APIs.
   - Datos reales persistidos en PostgreSQL o fixtures formales de desarrollo.

3. **Gobernanza Git Estricta**:
   - Jamás hacer commit directo a `main` o `develop`.
   - Utilizar ramas `feature/*`, `fix/*`, `refactor/*`.
   - PR y Code Review obligatorios. Prohibido subir directo a producción.

4. **Código Generado**:
   - `elite_multiservicios_client` y `lib/src/generated` son de solo lectura. Ejecutar siempre `serverpod generate`.

5. **Pre-Completion Check Obligatorio**:
   - Antes de considerar una tarea terminada:
     - `dart format` verificado.
     - `dart analyze` y `flutter analyze` con 0 errores y 0 warnings.
     - Pruebas unitarias aprobadas.
     - Reportar explícitamente qué fue VERIFICADO y qué NO FUE VERIFICADO con su MOTIVO.
