# Regla de Gobernanza: Pruebas y Cobertura Automatizada

> **Regla de oro**: Todo cambio en el código fuente requiere pruebas automatizadas que garanticen su funcionalidad y prevengan regresiones. Prohibido commitear sin tests.

---

## 1. Cobertura mínima obligatoria por tipo de cambio

| Tipo de cambio | Tests requeridos | Descripción |
|---|---|---|
| **Nueva funcionalidad** | Widget + Unit | Pruebas de renderizado/interacción de UI y prueba de lógica de negocio / endpoint. |
| **Corrección de bug (Bugfix)** | Reproducción + Regresión | Test que reproduzca la falla original (falle inicialmente) y pase tras la solución. |
| **Refactorización** | Tests existentes pasando | Toda la suite previa debe mantenerse en verde sin alterar contratos. |
| **Componente de UI / Pantalla** | Widget Test | Renderizado de elementos clave, interacción, respuesta a estados de error y carga. |
| **Endpoint / Servicio Backend** | Test de integración con PostgreSQL | Verificación de persistencia real en base de datos efímera de pruebas (`localhost:9090`). |
| **Modelo de datos / Serialización** | Unit Test | Pruebas de serialización, deserialización y validaciones de invariantes de dominio. |

---

## 2. Comandos obligatorios antes de cada commit

Los 5 comandos de calidad deben ejecutarse y reportar 0 errores:

```bash
# 1. Formato estricto
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático Server
cd elite_multiservicios_server && dart analyze && cd ..

# 3. Análisis estático Flutter
cd elite_multiservicios_flutter && flutter analyze && cd ..

# 4. Pruebas de Flutter
cd elite_multiservicios_flutter && flutter test && cd ..

# 5. Pruebas de Serverpod
cd elite_multiservicios_server && dart test && cd ..
```

---

## 3. Política estricta sobre mocks (No-Mock Policy)

- **Backend Serverpod**: Prohibido el uso de mocks en pruebas de base de datos o lógica de endpoints. Se debe emplear la base de datos PostgreSQL real de pruebas levantada en Docker (`elite_multiservicios_test`).
- **Frontend Flutter**: Solo se permite interceptar llamadas HTTP en tests de widgets usando `HttpOverrides` controlados cuando no exista un backend activo en el entorno de CI para evitar bloqueos de red (`SocketException`).
- **Fixtures de datos**: Emplear datos sembrados reproducibles, nunca JSONs improvisados con valores inválidos.

---

## 4. Prohibiciones explícitas

- ❌ Commitear código de producción sin sus correspondientes pruebas automatizadas.
- ❌ Comentar tests existentes para ocultar fallos o permitir que el CI pase.
- ❌ Utilizar anotaciones `@Skip()` o `skip: true` sin una justificación documentada y aprobada por el Tech Lead.
- ❌ Utilizar timeouts artificialmente altos para enmascarar bloqueos asíncronos o memory leaks.
