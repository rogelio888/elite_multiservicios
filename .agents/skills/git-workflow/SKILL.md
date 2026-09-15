---
name: git-workflow
description: Protocolo estricto de ramas, desarrollo aislado, prevención de colisiones multi-desarrollador y apertura automática de Pull Requests en Elite Multiservicios.
---

# Git Workflow & Multi-Developer Synchronization Protocol

Reglas operativas obligatorias para la IA y cualquier colaborador en el repositorio:

---

## 1. Regla Inquebrantable: Ramas Protegidas y Trabajo Aislado
- **Prohibido terminantemente** modificar archivos, hacer commits o pushear directamente sobre `develop` o `main`.
- **Antes de tocar cualquier línea de código**, la IA DEBE verificar la rama actual y crear una rama de trabajo dedicada a partir de lo último de `develop`:
  ```powershell
  git checkout develop
  git pull origin develop
  git checkout -b <tipo>/<nombre-descriptivo>
  ```
- **Nomenclatura permitida**:
  - `feat/<nombre>`: Nuevas funcionalidades o módulos.
  - `fix/<nombre>`: Correcciones de bugs o glitches.
  - `refactor/<nombre>`: Refactorizaciones de arquitectura o UI.
  - `chore/<nombre>`: Mantenimiento, dependencias o configuración.
  - `test/<nombre>`: Cobertura de pruebas unitarias o de integración.

---

## 2. Desarrollo Exclusivo en la Rama
- Todo cambio, refactor o nueva característica se desarrolla y prueba **únicamente** dentro de la rama creada.
- Commits atómicos con formato convencional:
  - `feat(modulo): descripción clara`
  - `fix(modulo): descripción de la causa resuelta`

---

## 3. Protocolo Preventivo Anti-Colisión (Multi-Developer Sync)
En entornos donde múltiples desarrolladores trabajan en paralelo, otro colaborador puede haber mergeado cambios a `origin/develop` mientras se trabajaba en la rama.

**Antes de cualquier commit final o push**, la IA DEBE ejecutar este chequeo:
```powershell
# 1. Traer el estado más reciente del remoto sin alterar la rama de trabajo
git fetch origin develop

# 2. Verificar si existen commits nuevos en origin/develop que no están en la rama local
git log HEAD..origin/develop --oneline
```

### Gestión de Escenarios:
- **Caso A: Sin cambios remotos (salida vacía)**:
  - Proceder con el push normalmente.
- **Caso B: Otro desarrollador subió cambios a `origin/develop`**:
  1. Rebasar la rama local sobre lo último de `origin/develop`:
     ```powershell
     git rebase origin/develop
     ```
  2. Si surgen conflictos, resolverlos inmediatamente en local respetando la lógica de ambos desarrolladores.
  3. Ejecutar los tests para comprobar que la integración no rompió nada.
  4. Continuar el rebase:
     ```powershell
     git rebase --continue
     ```

---

## 4. Verificación de Calidad Pre-Push (5/5 Checks)
Antes de subir al remoto:
1. Formato de código: `dart format --set-exit-if-changed .`
2. Análisis estático backend: `cd elite_multiservicios_server && dart analyze && cd ..`
3. Análisis estático frontend: `cd elite_multiservicios_flutter && flutter analyze && cd ..`
4. Pruebas frontend: `cd elite_multiservicios_flutter && flutter test && cd ..`
5. Pruebas backend: `cd elite_multiservicios_server && dart test && cd ..`
6. Verificación de secretos: `git check-ignore .env elite_multiservicios_server/config/passwords.yaml`

---

## 5. Creación Automática de Pull Request con GitHub CLI (`gh`)
La IA DEBE automatizar la creación del PR sin requerir pasos manuales del usuario:

```powershell
# 1. Subir la rama al repositorio remoto
git push -u origin <nombre-de-tu-rama>

# 2. Generar archivo temporal de descripción para evitar problemas de escape en PowerShell
# Guardar en .agents/scratch/pr_body.md con resumen de Contexto, Cambios y Verificación

# 3. Crear el PR apuntando SIEMPRE a develop como rama base
gh pr create --base develop --title "<tipo>(<alcance>): <descripción>" --body-file .agents/scratch/pr_body.md

# 4. Eliminar el archivo temporal
Remove-Item .agents/scratch/pr_body.md -Force -ErrorAction SilentlyContinue

# 5. Monitorear los checks de CI
gh pr checks <numero-de-pr>
```

---

## 6. Regla de Destino: SIEMPRE `develop`, JAMÁS `main`
- El Pull Request debe apuntar **exclusivamente a `develop`** (`--base develop`).
- **PROHIBIDO** abrir PRs o hacer merge hacia `main`. `main` queda reservado únicamente para releases de producción controladas y aprobadas expresamente por el Tech Lead (`@rogelio888`).
