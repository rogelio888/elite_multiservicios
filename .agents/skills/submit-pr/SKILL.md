---
name: submit-pr
description: Verifica calidad, sube rama, abre PR y pide aprobación al humano antes de mergear.
---

# Submit PR Skill

## Cuándo usar
Cuando una funcionalidad (`feat/`), corrección de bug (`fix/`) o tarea de mantenimiento (`chore/`) ha sido completada localmente y está lista para enviarse al repositorio remoto.

---

## Pasos del flujo

### 1. Verificar calidad local
Ejecutar los 5 comandos de verificación estricta:
```bash
dart format --output=none --set-exit-if-changed .
cd elite_multiservicios_server && dart analyze && cd ..
cd elite_multiservicios_flutter && flutter analyze && cd ..
cd elite_multiservicios_flutter && flutter test && cd ..
cd elite_multiservicios_server && dart test && cd ..
```
Si alguno de los 5 comandos arroja fallas o warnings, **DETENERSE de inmediato** y corregir los problemas antes de continuar.

### 2. Verificar que no existan secretos preparados
```bash
git status
git diff --cached
git check-ignore .env elite_multiservicios_server/config/passwords.yaml
```
Los archivos `.env` y `passwords.yaml` deben aparecer listados por `check-ignore`. Si no aparecen o están rastreados por Git, **DETENERSE y alertar al humano**.

### 3. Subir la rama
```powershell
git push -u origin <nombre-de-tu-rama>
```

### 4. Crear el Pull Request automáticamente con GitHub CLI (`gh`)
```powershell
gh pr create --base develop --title "<tipo>(<alcance>): <descripción>" --body "## Contexto`n<resumen>`n`n## Cambios`n<lista de cambios>`n`n## Verificación`n- [x] Calidad local verificada (5/5 checks).`n- [ ] CI pendiente."
```

### 5. Monitorear el pipeline de CI
Monitorear la ejecución de los 4 checks de GitHub Actions automáticamente:
```powershell
gh pr checks --watch
```

Los 4 jobs deben pasar en verde:
- `Secret Leak Detection (Gitleaks)`
- `Code Formatting & Static Analysis`
- `Flutter Unit & Widget Tests`
- `Serverpod Tests & Database Integration`

Si alguno falla, revisar los logs del job, corregir en la misma rama local y volver a pushear.

### 6. DETENERSE Y ESPERAR APROBACIÓN DEL TECH LEAD (`@rogelio888`)
**IMPORTANTE (POLÍTICA DE CODEOWNERS):**
- Los colaboradores **NO** son administradores del repositorio.
- Las ramas `develop` y `main` están estrictamente protegidas.
- **PROHIBIDO** intentar mergear con `--admin` o cerrar el PR.
- El PR queda en espera de revisión obligatoria por parte del Tech Lead / Propietario (`@rogelio888`).

Presentar el reporte al colaborador:
```text
## PR Creado y Verificado
- URL: <URL del PR>
- CI: ✅ Verde (4/4 checks aprobados)
- Estado: Esperando revisión y aprobación de @rogelio888 en GitHub.
- Nota: Una vez aprobado por el Tech Lead, el PR será incorporado a develop.
```

---

## Prohibiciones explícitas
- ❌ Intentar mergear sin la aprobación formal de `@rogelio888` en GitHub.
- ❌ Usar flags administrativos (`--admin`, `--bypass`).
- ❌ Usar `--force` en ramas compartidas.
- ❌ Omitir la espera de que los 4 checks de CI estén verdes antes de pedir revisión.
