# Perfecto. Ahora sí entiendo.

El PR #93 es tu punto de partida. No sabés qué hay ahí. Necesitás auditar antes de decidir. Y querés que la IA del repo te lo diga, no yo.

Entonces te doy **prompts cortos, uno por cosa**, para que la IA te reporte qué hay en el PR #93. Sin auditorías de 72 archivos. Sin informes de 20 secciones. Preguntas concretas, respuestas verificables.

---

## Antes de arrancar: dos reglas para todos los prompts

1. **La IA debe reportar evidencia, no opiniones.** Si dice "existe", que diga dónde. Si dice "funciona", que diga cómo lo verificó.

2. **Si la IA no puede verificar algo, que lo diga.** No que invente. No que infiera. "No pude verificar" es una respuesta válida.

---

## Prompt 1 — Inventario del PR #93 (el primero que tenés que correr)

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93). Necesito saber qué existe
en el módulo RRHH en este estado exacto.

TAREA:
Lista TODOS los archivos relacionados con RRHH en este commit.

Para cada archivo:

  Ruta: [completa]
  Tipo: [vista/widget/dialog/servicio/state/modelo/mock/endpoint/repo/test/otro]
  Tamaño: [líneas o KB]
  Propósito aparente: [1 línea]

Al final:

  - Total de archivos frontend RRHH
  - Total de archivos backend RRHH
  - Total de tests RRHH
  - Total de archivos que usan mocks
  - Total de archivos que llaman a Serverpod

REGLAS:
  - No infieras el propósito por el nombre. Abrí el archivo.
  - Si no podés abrirlo, decilo.
  - No incluyas archivos que no sean de RRHH.
  - No incluyas archivos generados (*.g.dart, *.freezed.dart).

FORMATO:
  Tabla + resumen numérico.

DETENTE. No propongas cambios. No opines.
```

---

## Prompt 2 — Estructura de vistas

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Lista todas las vistas (pantallas) del módulo RRHH.

Para cada vista:

  Nombre de la vista: [título visible]
  Archivo: [ruta]
  ¿Está enlazada al menú principal? [SÍ/NO/NO SÉ]
  ¿Cómo se accede? [ruta de navegación]
  ¿Qué muestra? [1-2 líneas]
  ¿Qué acciones permite? [lista]

Al final:

  - Lista de vistas enlazadas al menú
  - Lista de vistas huérfanas (existen pero no se accede)

REGLAS:
  - No infieras. Buscá la referencia en el menú/shell.
  - Si una vista no está referenciada, decilo.
  - Si no podés determinar si está enlazada, decilo.

FORMATO:
  Tabla + dos listas.

DETENTE.
```

---

## Prompt 3 — Backend existente

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Lista todos los endpoints de Serverpod relacionados con RRHH.

Para cada endpoint:

  Nombre: [nombre de la clase]
  Archivo: [ruta]
  Métodos: [lista de métodos públicos]
  ¿Registrado en el servidor? [SÍ/NO]
  ¿Tiene tests? [SÍ/NO]
  ¿Los tests pasan? [SÍ/NO/NO PROBADO]

Al final:

  - Total de endpoints
  - Total de métodos
  - Total de tests
  - Discrepancias entre endpoints declarados y registrados

REGLAS:
  - No infieras. Abrí el archivo.
  - Si un endpoint existe pero no está registrado, DENUNCIALO.
  - Si no podés correr los tests, decilo.

FORMATO:
  Tabla + resumen.

DETENTE.
```

---

## Prompt 4 — Modelos de datos

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Lista todos los modelos de datos de RRHH.

Para cada modelo:

  Nombre: [nombre de la clase]
  Archivo: [ruta]
  Campos: [lista de campos]
  Relaciones: [FK, listas, etc.]
  ¿Está en uso? [SÍ/NO/NO SÉ]

Al final:

  - Total de modelos
  - Modelos duplicados (mismo concepto con dos nombres)
  - Modelos huérfanos (no se usan)

REGLAS:
  - No infieras. Abrí el archivo.
  - Si ves un modelo que parece duplicado, DENUNCIALO.
  - Si un modelo no se importa en ningún lado, decilo.

FORMATO:
  Tabla + listas.

DETENTE.
```

---

## Prompt 5 — Estado del frontend (runtime)

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Ejecuta la app y recorre las pantallas de RRHH.

Para CADA pantalla:

  Pantalla: [nombre]
  ¿Abre? [SÍ/NO/PANTALLA ROJA]
  ¿Qué muestra? [1-2 líneas]
  ¿Errores en consola? [texto exacto o "ninguno"]
  ¿Stack trace? [pegar si hay]
  ¿Carga datos? [SÍ/NO]
  ¿Los datos parecen reales o ficticios? [REALES/MOCK/NO SÉ]
  ¿Acciones funcionan? [SÍ/NO/PARCIAL]

REGLAS:
  - No me des un informe de código. Quiero runtime.
  - Si no podés ejecutar la app, DECILO.
  - No infieras comportamiento.
  - No digas "debería funcionar".

FORMATO:
  Una sección por pantalla.

DETENTE. No propongas fixes.
```

---

## Prompt 6 — Estado del backend (runtime)

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Verifica el backend de RRHH en runtime.

  ¿Serverpod corre? [SÍ/NO]
  ¿PostgreSQL corre? [SÍ/NO]
  ¿La base de datos tiene datos? [SÍ/NO]
  ¿Qué tablas existen? [lista]
  ¿Qué endpoints responden? [lista]
  ¿Qué endpoints dan error? [lista + error]

MÉTODO:
  - Ejecutá el servidor.
  - Consultá la base.
  - Probá cada endpoint.

REGLAS:
  - No infieras. Ejecutá.
  - Si no podés ejecutar, DECILO.
  - Si un endpoint no responde, DENUNCIALO.

FORMATO:
  Tabla + evidencia.

DETENTE.
```

---

## Prompt 7 — Mocks y seeds

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Determina si hay mocks, seeds o datos hardcodeados en el módulo RRHH.

BUSCA:
  - RrhhMockData
  - _initFromSeed
  - fallback
  - mock
  - fixture
  - hardcoded
  - List<...> = [ ... ] (listas literales)
  - Datos de ejemplo en el código

Para cada ocurrencia:

  Archivo:
  Línea:
  Contexto: [código]
  ¿Se usa en runtime productivo? [SÍ/NO/NO SÉ]
  ¿Se usa solo en tests? [SÍ/NO]
  Evidencia:

CONCLUSIÓN:
  ¿Hay mocks productivos? [SÍ/NO]
  ¿Hay fallback a mock en error? [SÍ/NO]
  ¿Hay datos hardcodeados visibles en la app? [SÍ/NO]

REGLAS:
  - No infieras. Buscá en el código.
  - Si encontrás un mock productivo, DENUNCIALO.
  - Si encontrás un fallback, DENUNCIALO.

FORMATO:
  Lista + conclusión.

DETENTE.
```

---

## Prompt 8 — Credenciales y seguridad

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).
Hay una decisión arquitectónica: RRHH NO genera ni almacena contraseñas.

TAREA:
Verifica si esa decisión se respeta en este commit.

BUSCA:
  - temporaryPassword
  - effectiveTemporaryPassword
  - password
  - credential
  - "Elite" (en contexto de credenciales)
  - Generación de contraseñas

Para cada ocurrencia:

  Archivo:
  Línea:
  Contexto: [código]
  ¿Es productivo? [SÍ/NO]
  ¿Se usa en runtime? [SÍ/NO/NO SÉ]
  Acción: [ELIMINAR/REVISAR/OK]

CONCLUSIÓN:
  ¿RRHH genera contraseñas en este commit? [SÍ/NO/NO DETERMINADO]
  Evidencia:

REGLAS:
  - No elimines nada. Solo reportá.
  - Si encontrás lógica productiva, DENUNCIALA.

FORMATO:
  Lista + conclusión.

DETENTE.
```

---

## Prompt 9 — Tests existentes

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Lista todos los tests relacionados con RRHH.

Para cada test:

  Archivo:
  Tipo: [unit/widget/integration/e2e]
  ¿Qué prueba? [1 línea]
  ¿Pasa? [SÍ/NO/NO PROBADO]
  Evidencia: [comando + resultado]

Al final:

  - Total de tests RRHH
  - Total que pasan
  - Total que fallan
  - Total que no se pueden correr

REGLAS:
  - No infieras. Ejecutá.
  - Si un test no se puede correr, decilo.
  - No cuentes tests que no sean de RRHH.

FORMATO:
  Tabla + resumen.

DETENTE.
```

---

## Prompt 10 — Capacidades del módulo

```
CONTEXTO:
Estamos en el commit 35635fe (PR #93).

TAREA:
Lista las capacidades funcionales que el módulo RRHH soporta HOY.

Para cada capacidad:

  Capacidad: [nombre]
  ¿Existe? [SÍ/NO/PARCIAL]
  ¿Dónde? [archivo/pantalla]
  ¿Funciona? [SÍ/NO/PARCIAL]
  Evidencia: [cómo lo verificaste]

CAPACIDADES A VERIFICAR:
  - Gestión de empleados
  - Expediente
  - Reclutamiento
  - Contratación
  - Contratos
  - Organización (áreas, cargos, especialidades)
  - Horarios
  - Permisos
  - Vacaciones
  - Incidencias
  - Ajustes salariales
  - Historial
  - Reportes
  - Auditoría
  - Asignaciones
  - Rotaciones
  - Desvinculación
  - Reingreso
  - Documentos
  - Exportaciones

REGLAS:
  - No infieras. Verificá.
  - Si una capacidad no existe, decilo.
  - Si existe pero no funciona, decilo.

FORMATO:
  Tabla.

DETENTE.
```

---

## Orden recomendado de uso

```
DÍA 1: Saber qué hay
  1. Prompt 1 — Inventario
  2. Prompt 2 — Vistas
  3. Prompt 3 — Backend
  4. Prompt 4 — Modelos

DÍA 2: Saber qué funciona
  5. Prompt 5 — Runtime frontend
  6. Prompt 6 — Runtime backend
  7. Prompt 9 — Tests

DÍA 3: Saber qué problemas hay
  8. Prompt 7 — Mocks y seeds
  9. Prompt 8 — Credenciales
  10. Prompt 10 — Capacidades

DÍA 4: Decidir
  Con los 10 informes, armamos la matriz de rescate.
```

---

## Reglas para cuando la IA responda

1. **Si dice "existe" sin evidencia → pedile evidencia.**
2. **Si dice "funciona" sin runtime → pedile runtime.**
3. **Si dice "no pude verificar" → está bien, aceptalo.**
4. **Si dice "debería funcionar" → rechazalo.**
5. **Si inventa algo que no le pediste → descartalo.**

---

## Lo que NO vas a hacer

- ❌ No corras los 10 prompts de una.
- ❌ No pidas "un informe completo de todo".
- ❌ No aceptes conclusiones generales.
- ❌ No dejes que la IA opine sobre qué hacer.

## Lo que SÍ vas a hacer

- ✅ Un prompt a la vez.
- ✅ Esperás la respuesta.
- ✅ La revisás.
- ✅ Si está bien, pasás al siguiente.
- ✅ Si está mal, la devolvés con observaciones.

---

## Empezá por el Prompt 1

Es el más importante. Te va a decir qué hay en el PR #93. Sin eso, no podés decidir nada.

Corré el Prompt 1 y pegame el resultado. Con eso, te digo si vamos al Prompt 2 o si primero hay que aclarar algo.

**Un prompt a la vez. Un paso a la vez. Sin humo.**