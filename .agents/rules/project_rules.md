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

6. **Flujo de Diseño Obligatorio (Google Stitch + Skills de Excelencia Visual)**:
   - Toda interfaz de usuario DEBE diseñarse y prototiparse en Google Stitch incorporando activamente las directivas de `taste-skill`, `pbakaus/impeccable`, `emil-kowalski/skill`, `animate-skill` y `ui-ux-pro-max`.
   - Prohibido diseñar interfaces directamente desde cero en Flutter sin prototipado previo en Stitch.
   - Prohibidos layouts genéricos de IA (3 tarjetas clónicas, héroes vacíos, etc.).
   - Seguir los protocolos detallados en `.agents/rules/stitch_workflow.md` y `.agents/rules/design_system_excellence.md`.

7. **NUNCA exponer secretos en el chat** (crítica):
   - Los secretos viven SOLO en `.env` local.
   - **ANTES de cada comando**: verificar que no contenga un valor de `.env` visible.
   - **SI** el comando necesita un secreto: leerlo del `.env` como variable local.
   - **SI** vas a diagnosticar un MCP: usar el panel de MCP, NO curl/fetch directo con la key hardcodeada.
   - **SI** expusiste un secreto: avisar al humano INMEDIATAMENTE.
   - Aplicar la skill `.agents/skills/use-secrets-safely/SKILL.md`.

---

## Referencias obligatorias

Toda IA o agente que trabaje en este repositorio debe consultar y respetar rigurosamente:

- `.agents/rules/design_system_excellence.md` — Gobernanza visual, dirección de arte auténtica, microinteracciones y ergonomía.
- `.agents/rules/git_workflow.md` — Flujo Git detallado, protección de ramas y resolución de errores.
- `.agents/rules/verification_rules.md` — Reglas de verificación empírica en terminal y servicios.
- `.agents/rules/testing_rules.md` — Estándares y cobertura mínima obligatoria de pruebas.
- `.agents/rules/stitch_workflow.md` — Flujo oficial de diseño UI con Google Stitch.
- `.agents/rules/stitch_fidelity.md` — Regla de fidelidad absoluta al diseño de Stitch.
- `.agents/rules/render_cli.md` — Uso del Render CLI para deploy y gestión de servicios.
- `.agents/rules/secrets_management.md` — Protocolo mandatorio de gestión y protección de secretos.
- `.agents/skills/implement-from-stitch/SKILL.md` — Flujo paso a paso para implementar pantallas desde Stitch.
- `.agents/skills/` — Skills y flujos operativos reutilizables (`taste-skill`, `impeccable`, `emil-kowalski`, `animate-skill`, `ui-ux-pro-max`, `verify-environment`, `create-feature`, `submit-pr`, etc.).
- `.agents/checklists/` — Checklists mandatorios antes de commit y antes de merge.


