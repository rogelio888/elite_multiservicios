---
name: pre-flight-check
description: Verificación obligatoria de cero errores en diagnósticos (@[current_problems]) y compilación antes de indicar al usuario que pruebe cualquier cambio o demo.
---

# Pre-Flight Check Skill (Verificación Obligatoria Cero Errores)

## Regla de Oro
Queda **estrictamente prohibido** pedirle al usuario que pruebe una funcionalidad, pantalla o demo sin haber verificado y garantizado previamente que existen **0 errores** en la lista de problemas del IDE (`@[current_problems]`) y **0 errores de compilación**.

---

## Flujo de Ejecución Obligatorio

1. **Auditoría de Diagnósticos (`@[current_problems]`)**:
   - Antes de dar por concluido un turno o respuesta, revisar la sección `@[current_problems]` inyectada por el IDE.
   - Si se detecta cualquier error de sintaxis, importación, tipos TypeScript/Dart o configuración en archivos del proyecto, se **debe corregir de inmediato**.

2. **Verificación Runtime / Compilación**:
   - Ejecutar la orden de compilación/análisis correspondiente (`flutter analyze`, `dart test`, `tsc`, `npm run build`, etc.) para confirmar empíricamente que la compilación es 100% limpia.

3. **Confirmación Final**:
   - Únicamente tras confirmar que `@[current_problems]` está limpio y la compilación fue exitosa, se informará al usuario que la funcionalidad está lista para ser probada.

---

## Formato de Reporte
- Aplicar concisión tipo **caveman** (sin rodeos ni introducciones vacías).
- Indicar brevemente los problemas solucionados y la confirmación de 0 errores.
