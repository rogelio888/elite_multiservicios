---
name: create-feature
description: Flujo end-to-end para agregar una nueva funcionalidad al proyecto.
---

# Create Feature Skill

## Cuándo usar
Cuando el usuario o el equipo solicite agregar una nueva funcionalidad, módulo o flujo de negocio al proyecto.

---

## Pasos del flujo

### 1. Clarificar requerimientos
Preguntar al humano:
- ¿Qué debe hacer exactamente la nueva funcionalidad?
- ¿Afecta al backend (Serverpod), al frontend (Flutter) o a ambos?
- ¿Requiere crear o modificar tablas / modelos de base de datos?
- ¿Requiere nuevas pantallas o elementos visuales? *(Si involucra UI → Stitch obligatorio primero)*.

### 2. Verificar entorno
Ejecutar la verificación del skill `verify-environment` para asegurar que Docker, base de datos y Flutter estén listos.

### 3. Si es UI: Diseñar en Stitch primero
Seguir rigurosamente el protocolo de [.agents/rules/stitch_workflow.md](.agents/rules/stitch_workflow.md).
- Prohibido codificar pantallas en Flutter sin especificación previa en Stitch.

### 4. Crear rama de trabajo
```bash
git checkout develop
git pull origin develop
git checkout -b feat/nombre-descriptivo
```

### 5. Implementación (Backend-First)
1. **Backend Serverpod**:
   - Definir modelos YAML en `elite_multiservicios_server/lib/src/models/`.
   - Ejecutar `serverpod generate`.
   - Crear migraciones: `serverpod create-migration`.
   - Implementar endpoints con `RbacGuard.requirePermission(...)`.
   - Escribir tests unitarios y de integración de backend.
2. **Frontend Flutter**:
   - Reutilizar tokens y estilos corporativos derivados de Stitch.
   - Implementar widgets y pantallas conectando con `client.*`.
   - Escribir widget tests correspondientes.

### 6. Verificación local completa
Ejecutar los 5 comandos de calidad:
- `dart format --set-exit-if-changed .`
- `cd elite_multiservicios_server && dart analyze && cd ..`
- `cd elite_multiservicios_flutter && flutter analyze && cd ..`
- `cd elite_multiservicios_flutter && flutter test && cd ..`
- `cd elite_multiservicios_server && dart test && cd ..`

### 7. Commit y Push
```bash
git add .
git commit -m "feat(modulo): descripcion clara y concisa"
git push -u origin feat/nombre-descriptivo
```

### 8. Abrir PR y solicitar revisión
Invocar el skill `submit-pr`.

---

## Reporte final al humano

```text
## Feature completada
- Módulo: <Nombre del módulo>
- Backend: <X modelos, Y endpoints, migraciones aplicadas>
- Frontend: <Z pantallas/widgets creados>
- Tests: N nuevos añadidos, M totales pasando
- CI: ✅ Verde
- PR: <URL del Pull Request>

## Próximo paso
Esperando tu aprobación explícita para mergear a develop.
```
