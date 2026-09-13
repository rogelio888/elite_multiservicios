# Regla: Uso de GitHub CLI (gh) para Automatización de PRs

## Propósito
GitHub CLI (`gh`) permite automatizar de forma end-to-end la creación de Pull Requests, el seguimiento reactivo de GitHub Actions (CI) y el merge seguro a las ramas protegidas (`develop` y `main`).

## Ubicación y Configuración
- **Binario**: `C:\Program Files\GitHub CLI\gh.exe`
- **Comando global**: `gh` (requiere PATH actualizado)
- **Autenticación**: `gh auth status` (vinculado a la cuenta `rogelio888` con rol ADMIN).

## Comandos Principales

### 1. Inspección y Creación de PRs
```powershell
# Listar PRs abiertos
gh pr list

# Ver detalles de un PR
gh pr view <pr-number>

# Crear un PR
gh pr create --base <base-branch> --head <head-branch> --title "<título>" --body "<descripción>"
```

### 2. Monitoreo de CI
```powershell
# Ver estado instantáneo de los checks
gh pr checks <pr-number>

# Esperar activamente a que todos los checks terminen
gh pr checks <pr-number> --watch
```

### 3. Merge de PRs
```powershell
# Merge de feature branch a develop (elimina la rama feature)
gh pr merge <pr-number> --squash --delete-branch --admin

# Promoción de develop a main (NUNCA usar --delete-branch en develop)
gh pr merge <pr-number> --merge --admin
# o con squash si se prefiere:
gh pr merge <pr-number> --squash --admin
```

## Políticas y Reglas Estrictas

1. **PROHIBIDO mergear sin CI verde**:
   - Todo PR debe pasar los 4 checks obligatorios (Formatting, Flutter Tests, Serverpod Tests, Gitleaks) antes de ejecutar el merge.
2. **Uso de `--admin`**:
   - El flag `--admin` se utiliza para hacer bypass de las reglas de protección que exigen un segundo revisor humano (CODEOWNERS), permitiendo la automatización fluida por parte del agente en repositorios personales/unipersonales.
3. **Protección de ramas base**:
   - **NUNCA** ejecutar `--delete-branch` al mergear `develop` hacia `main`. `develop` es la rama troncal de integración continua y debe persistir siempre.
4. **Prohibición de `git push --force`**:
   - Está terminantemente prohibido forzar la historia en ramas remotas compartidas.
5. **No exponer credenciales ni tokens**:
   - En ningún comando o reporte se deben imprimir tokens `gho_*` ni variables sensibles del `.env`.
