---
name: git-workflow
description: Protocolo estricto de ramas, desarrollo aislado, prevención de colisiones multi-desarrollador, consulta previa obligatoria y apertura de Pull Requests hacia develop.
---

# Git Workflow & Multi-Developer Synchronization Protocol — Elite Multiservicios

Reglas operativas obligatorias para la IA y cualquier colaborador en el repositorio.

---

## Ciclo de Vida Completo del Flujo de Trabajo (9 Pasos)

### Paso 1: Inicio de Jornada / Tarea
Antes de comenzar cualquier trabajo nuevo, traer el estado más fresco del servidor para evitar arrancar con código desactualizado:
```powershell
git checkout develop
git pull origin develop
```

### Paso 2: Aislar en Rama de Trabajo Dedicada
**Regla de oro:** Prohibido terminantemente modificar archivos, hacer commits o pushear directamente sobre `develop` o `main`.
Crear inmediatamente la rama correspondiente:
```powershell
git checkout -b <tipo>/<nombre-descriptivo>
```
*Nomenclatura obligatoria*:
- `feat/<nombre>`: Nuevas funcionalidades o módulos.
- `fix/<nombre>`: Corrección de bugs o glitches visuales.
- `refactor/<nombre>`: Mejoras de arquitectura o refactorización sin cambio funcional.
- `chore/<nombre>`: Configuración, dependencias o mantenimiento.
- `test/<nombre>`: Nuevas pruebas automatizadas.

### Paso 3: Desarrollo y Pruebas Locales (Local-First)
- Todo cambio se desarrolla y prueba **únicamente** dentro de la rama creada.
- Probar en vivo en local con datos reales de la base de datos (cumpliendo `no-mock-policy`).
- Verificar que existan **0 errores** de análisis y tests pasando:
  ```powershell
  dart format --output=none --set-exit-if-changed .
  cd elite_multiservicios_server; dart analyze; cd ..
  cd elite_multiservicios_flutter; flutter analyze; cd ..
  cd elite_multiservicios_flutter; flutter test; cd ..
  cd elite_multiservicios_server; dart test; cd ..
  ```
- Commits atómicos con formato convencional: `feat(modulo): ...` o `fix(modulo): ...`.

### Paso 4: Protocolo Preventivo Anti-Colisión (Multi-Developer Sync)
Antes de preparar la subida de cambios, verificar si otro colaborador subió commits a `origin/develop` durante tu jornada:
```powershell
# 1. Traer el estado remoto sin tocar tu rama de trabajo
git fetch origin develop

# 2. Comprobar si existen commits nuevos en origin/develop que no tienes
git log HEAD..origin/develop --oneline
```

#### Gestión de Escenarios:
- **Caso A: Salida vacía (Nadie más subió cambios)**:
  - Tu rama está al día. Proceder al Paso 5.
- **Caso B: Otro desarrollador subió cambios a `origin/develop`**:
  - Rebasar tu rama sobre lo último de `origin/develop`:
    ```powershell
    git rebase origin/develop
    ```
  - Si surgen conflictos en los mismos archivos, resolverlos en local respetando la lógica de ambos desarrolladores.
  - Ejecutar nuevamente los tests locales para comprobar que la integración está intacta.
  - Continuar el rebase:
    ```powershell
    git rebase --continue
    ```

### Paso 5: CONSULTA Y APROBACIÓN OBLIGATORIA DEL DESARROLLADOR (PUNTO DE CONTROL)
> [!IMPORTANT]
> **PROHIBIDO PUSHEAR O ABRIR PR SIN AUTORIZACIÓN:**  
> La IA **NO DEBE** pushear al repositorio remoto ni abrir el Pull Request de forma automática sin antes consultar con el usuario o desarrollador a cargo.
>
> **Razón:** Podría existir otro desarrollador en el equipo a punto de integrar sus cambios o coordinando una entrega simultánea.

**Pregunta obligatoria al desarrollador:**
> *"He completado el desarrollo y verificado que no hay colisiones con `develop`. ¿Estás de acuerdo en que suba la rama y abra el Pull Request hacia `develop` ahora?"*

Solo tras la confirmación afirmativa del usuario se procede al Paso 6.

### Paso 6: Subir la Rama Aislada al Repositorio Remoto
Subir **únicamente** la rama de trabajo al repositorio:
```powershell
git push -u origin <tipo>/<nombre-descriptivo>
```

### Paso 7: Creación del Pull Request hacia `develop` (`gh`)
La IA genera el cuerpo del PR y ejecuta la apertura vía GitHub CLI:
```powershell
# 1. Escribir descripción estructurada en archivo temporal para evitar problemas de escape en PowerShell
# Guardar en .agents/scratch/pr_body.md con secciones de Contexto, Cambios y Verificación

# 2. Abrir PR apuntando SIEMPRE a develop
gh pr create --base develop --title "<tipo>(<alcance>): <descripción>" --body-file .agents/scratch/pr_body.md

# 3. Limpiar archivo temporal
Remove-Item .agents/scratch/pr_body.md -Force -ErrorAction SilentlyContinue
```

### Paso 8: Validación de CI y Fusión (Merge) a `develop`
- Monitorear que los 4 checks de CI pasen en verde (`gh pr checks`).
- Cuando el Tech Lead (`@rogelio888`) revise y apruebe o instruya la fusión:
  ```powershell
  gh pr merge <numero-de-pr> --merge --delete-branch
  ```

### Paso 9: Retorno y Sincronización Local
Volver a `develop` local y sincronizar:
```powershell
git checkout develop
git pull origin develop
```

---

## Reglas Inquebrantables
1. **Consulta previa obligatoria:** Jamás hacer push ni crear PR sin el "adelante" del desarrollador.
2. **Destino SIEMPRE `develop`, JAMÁS `main`:** Todo PR apunta exclusivamente a `develop`.
3. **Cero push directo a ramas protegidas:** Nunca hacer push a `develop` ni a `main`.
4. **Siempre fetch antes de push:** Evitar sobrescrituras o pérdidas de trabajo concurrente.
