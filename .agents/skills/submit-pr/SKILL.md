---
name: submit-pr
description: Protocolo riguroso de sincronización anti-choques, verificación de calidad, push de rama, apertura automática de Pull Request hacia develop con GitHub CLI y posterior fusión sincronizada.
---

# Submit PR Skill — Elite Multiservicios

## Cuándo usar
Cuando una funcionalidad (`feat/`), corrección de bug (`fix/`) o tarea de mantenimiento (`chore/`) ha sido desarrollada en su rama dedicada y está lista para enviarse e integrarse en `develop`.

---

## Pasos Obligatorios del Flujo

### 1. Verificar Calidad Local (5/5 Checks)
Ejecutar los 5 comandos de verificación estricta:
```powershell
dart format --output=none --set-exit-if-changed .
cd elite_multiservicios_server; dart analyze; cd ..
cd elite_multiservicios_flutter; flutter analyze; cd ..
cd elite_multiservicios_flutter; flutter test; cd ..
cd elite_multiservicios_server; dart test; cd ..
```
Si alguno de los 5 comandos arroja fallas o warnings, **DETENERSE de inmediato** y corregir los problemas antes de continuar.

### 2. Verificar que no Existan Secretos Preparados
```powershell
git status
git diff --cached
git check-ignore .env elite_multiservicios_server/config/passwords.yaml
```
Los archivos `.env` y `passwords.yaml` deben aparecer listados por `check-ignore`. Si no aparecen o están rastreados por Git, **DETENERSE y alertar al humano**.

### 3. Protocolo Preventivo Anti-Colisión (Multi-Developer Sync)
Antes de subir la rama, verificar si otro colaborador subió cambios a `origin/develop` durante tu trabajo:
```powershell
# 1. Consultar estado reciente del remoto sin tocar la rama local
git fetch origin develop

# 2. Comprobar si hay commits nuevos en origin/develop que no tienes
git log HEAD..origin/develop --oneline
```

- **Si la salida está vacía**: La rama está al día con el remoto. Continuar al Paso 4.
- **Si hay commits nuevos de otros desarrolladores**:
  1. Rebasar tu rama sobre lo último de `origin/develop`:
     ```powershell
     git rebase origin/develop
     ```
  2. Si surgen conflictos en los mismos archivos, resolverlos en local respetando la lógica de ambos desarrolladores.
  3. Re-ejecutar los tests locales para garantizar estabilidad.
  4. Continuar el rebase:
     ```powershell
     git rebase --continue
     ```
  *Nota: De esta manera nadie borra ni pisa el código del otro compañero.*

### 4. Subir la Rama Aislada al Repositorio Remoto
```powershell
git push -u origin <nombre-de-tu-rama>
```

### 5. Crear el Pull Request Automáticamente con GitHub CLI (`gh`)
La IA debe generar y ejecutar la creación del PR de forma 100% autónoma:
```powershell
# 1. Escribir descripción estructurada en archivo temporal para evitar problemas de escape en PowerShell
# Guardar en .agents/scratch/pr_body.md con secciones de Contexto, Cambios y Verificación

# 2. Ejecutar gh pr create apuntando SIEMPRE a develop
gh pr create --base develop --title "<tipo>(<alcance>): <descripción>" --body-file .agents/scratch/pr_body.md

# 3. Limpiar archivo temporal
Remove-Item .agents/scratch/pr_body.md -Force -ErrorAction SilentlyContinue
```

### 6. Monitorear el Pipeline de CI
Monitorear la ejecución de los 4 checks de GitHub Actions automáticamente:
```powershell
gh pr checks <numero-del-pr>
```

Los 4 jobs deben pasar en verde:
- `Secret Leak Detection (Gitleaks)`
- `Code Formatting & Static Analysis`
- `Flutter Unit & Widget Tests`
- `Serverpod Tests & Database Integration`

Si alguno falla, revisar los logs del job, corregir en la misma rama local y volver a pushear.

### 7. Fusión (Merge) a `develop` y Cierre de Rama
Una vez el CI esté en verde y el Tech Lead (`@rogelio888`) apruebe o instruya la fusión:
```powershell
gh pr merge <numero-del-pr> --merge --delete-branch
```

### 8. Retorno y Sincronización Local
Sincronizar el entorno local para continuar con la siguiente tarea:
```powershell
git checkout develop
git pull origin develop
git branch -d <nombre-de-tu-rama>
```

---

## Prohibiciones Explícitas
- ❌ Trabajar directamente sobre `develop` o `main` sin rama propia.
- ❌ Pushear sin antes haber hecho `git fetch origin develop` y comprobado si hubo cambios concurrentes.
- ❌ Abrir PR o pushear hacia `main` (solo `develop`).
- ❌ Usar flags destructivos o forzados (`--force`) en ramas compartidas.
