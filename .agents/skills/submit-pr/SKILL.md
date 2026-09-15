---
name: submit-pr
description: Protocolo riguroso de sincronización anti-choques, verificación de calidad, consulta previa al desarrollador, push de rama y apertura de Pull Request hacia develop con GitHub CLI.
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

### 4. CONSULTA Y APROBACIÓN OBLIGATORIA DEL DESARROLLADOR (PUNTO DE CONTROL)
> [!IMPORTANT]
> **REGLA DE ORO ANTI-CHOQUES:**  
> La IA tiene **ESTRICTAMENTE PROHIBIDO** hacer `git push` o abrir un Pull Request de forma autónoma sin consultar previamente y recibir el consentimiento explícito del usuario o desarrollador activo.
>
> **Motivo:** En equipos concurrentes, otro colaborador puede estar a punto de subir sus cambios o coordinando una integración. Abrir el PR sin aviso previo puede causar condiciones de carrera y colisiones de despliegue.

**Acción obligatoria de la IA:**
Presentar un resumen claro de los cambios locales y preguntar:
> *"He completado las verificaciones locales (calidad 5/5, sin secretos y anti-colisión con `develop` al día). ¿Estás listo para que suba la rama y abra el Pull Request hacia `develop`?"*

**Condición de avance:**  
Esperar la respuesta afirmativa del usuario ("sí", "adelante", "sube el PR", etc.) antes de ejecutar los pasos siguientes.

### 5. Subir la Rama Aislada al Repositorio Remoto
Una vez aprobada por el usuario:
```powershell
git push -u origin <nombre-de-tu-rama>
```

### 6. Crear el Pull Request con GitHub CLI (`gh`)
La IA genera la descripción y abre el PR apuntando a `develop`:
```powershell
# 1. Escribir descripción estructurada en archivo temporal para evitar problemas de escape en PowerShell
# Guardar en .agents/scratch/pr_body.md con secciones de Contexto, Cambios y Verificación

# 2. Ejecutar gh pr create apuntando SIEMPRE a develop
gh pr create --base develop --title "<tipo>(<alcance>): <descripción>" --body-file .agents/scratch/pr_body.md

# 3. Limpiar archivo temporal
Remove-Item .agents/scratch/pr_body.md -Force -ErrorAction SilentlyContinue
```

### 7. Monitorear el Pipeline de CI
Monitorear la ejecución de los 4 checks de GitHub Actions automáticamente:
```powershell
gh pr checks <numero-del-pr>
```

Los 4 jobs deben pasar en verde:
- `Secret Leak Detection (Gitleaks)`
- `Code Formatting & Static Analysis`
- `Flutter Unit & Widget Tests`
- `Serverpod Tests & Database Integration`

### 8. Fusión (Merge) a `develop` y Retorno Local
Cuando el Tech Lead (`@rogelio888`) apruebe o instruya la fusión:
```powershell
gh pr merge <numero-del-pr> --merge --delete-branch
git checkout develop
git pull origin develop
```

---

## Prohibiciones Explícitas
- ❌ **Pushear o abrir PR automáticamente sin consulta previa y confirmación del usuario.**
- ❌ Trabajar directamente sobre `develop` o `main` sin rama propia.
- ❌ Pushear sin antes haber hecho `git fetch origin develop` y comprobado si hubo cambios concurrentes.
- ❌ Abrir PR o pushear hacia `main` (solo `develop`).
- ❌ Usar flags destructivos o forzados (`--force`) en ramas compartidas.
