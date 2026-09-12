# Regla de Gobernanza: Verificación Empírica Obligatoria

> **Regla de oro absoluta**: NUNCA declarar una tarea o paso como "Listo" sin haber verificado empíricamente la salida de la terminal y los diagnósticos del sistema. Prohibido asumir éxito sin evidencia.

---

## 1. Verificación obligatoria tras cada comando de terminal

Tras ejecutar cualquier comando en PowerShell o Bash, el agente o IA **debe verificar de inmediato**:

1. **Exit Code**: Debe ser estrictamente `0`.
2. **stdout**: Ausencia total de cadenas como `Error`, `Exception`, `FAILED`, `Unhandled`, `Connection refused`, `SyntaxError`.
3. **stderr**: Vacío o libre de advertencias críticas que comprometan la ejecución.

Si un comando arroja salida inesperada o código de error, **DETENERSE de inmediato** y mostrar el error completo al humano sin afirmar que la acción fue exitosa.

---

## 2. Verificación de servicios e infraestructura

Antes de reportar el entorno operativo:
- **Backend Serverpod**:
  ```bash
  curl http://localhost:8082
  ```
  *(Debe retornar código 200 con HTML o JSON válido. Si falla, esperar 5-10 segundos o verificar logs).*
- **Contenedores Docker**:
  ```bash
  cd elite_multiservicios_server
  docker compose ps
  cd ..
  ```
  *(Los 4 servicios `postgres`, `redis`, `postgres_test` y `redis_test` deben estar en estado `Up`).*

---

## 3. Verificación de suite de pruebas

Toda suite de tests ejecutada debe terminar con 100% de éxito:
- **Flutter**: `flutter test` → todos los tests pasando (0 failed).
- **Serverpod**: `dart test` → todos los tests pasando (0 failed).

---

## 4. Verificación de análisis estático y formato

Antes de cualquier commit o cierre de tarea:
- `dart format --output=none --set-exit-if-changed .` → 0 archivos con cambios pendientes de formato.
- `cd elite_multiservicios_server && dart analyze` → `No issues found!`.
- `cd elite_multiservicios_flutter && flutter analyze` → `No issues found!`.

---

## 5. Prohibiciones explícitas

- ❌ Declarar "listo" con warnings o errores presentes en la consola o diagnósticos.
- ❌ Asumir que un contenedor o servidor levantó sin consultar su estado (`docker compose ps` / `curl`).
- ❌ Omitir la ejecución de tests bajo el supuesto de que "el cambio fue muy pequeño".
- ❌ Ocultar fallos o justificar errores reales como "comportamiento esperado" sin confirmación del humano.

---

## 6. Formato obligatorio de reporte final

Toda entrega o reporte de finalización debe estructurarse con el siguiente bloque de evidencia:

```text
## Verificación
☑ Comando 1: OK (exit 0, sin errores)
☑ Comando 2: OK (exit 0, sin errores)
☑ Tests: N/N pasando (100%)
☑ Análisis: 0 problemas (dart/flutter analyze)
☑ Servicios: backend respondiendo en :8082, docker 4/4 Up
```
