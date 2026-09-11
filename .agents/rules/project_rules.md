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

6. **Flujo de Diseño Obligatorio (Google Stitch)**:
   - Toda interfaz de usuario DEBE partir de un diseño en Google Stitch.
   - Prohibido diseñar interfaces directamente desde cero en Flutter sin prototipado previo en Stitch.
   - Seguir el protocolo detallado en `.agents/rules/stitch_workflow.md`.

---

## Referencias obligatorias

Toda IA o agente que trabaje en este repositorio debe consultar y respetar rigurosamente:

- `.agents/rules/git_workflow.md` — Flujo Git detallado, protección de ramas y resolución de errores.
- `.agents/rules/verification_rules.md` — Reglas de verificación empírica en terminal y servicios.
- `.agents/rules/testing_rules.md` — Estándares y cobertura mínima obligatoria de pruebas.
- `.agents/rules/stitch_workflow.md` — Flujo oficial de diseño UI con Google Stitch.
- `.agents/skills/` — Skills y flujos operativos reutilizables (`verify-environment`, `create-feature`, `submit-pr`, etc.).
- `.agents/checklists/` — Checklists mandatorios antes de commit y antes de merge.


