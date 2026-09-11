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
```bash
git push -u origin <nombre-de-tu-rama>
```

### 4. Proveer la URL del PR al humano
```text
https://github.com/rogelio888/elite_multiservicios/compare/develop...<nombre-de-tu-rama>
```

### 5. Monitorear el pipeline de CI
Verificar que los 4 jobs de GitHub Actions pasen exitosamente:
- `Secret Leak Detection (Gitleaks)`
- `Code Formatting & Static Analysis`
- `Flutter Unit & Widget Tests`
- `Serverpod Tests & Database Integration`

Si alguno falla, revisar los logs del job, corregir en la misma rama local y volver a pushear.

### 6. DETENERSE Y PEDIR APROBACIÓN AL HUMANO
**NUNCA** intentar mergear por iniciativa propia ni cerrar el PR sin visto bueno.
Presentar el reporte al humano:

```text
## PR listo
- URL: <URL>
- CI: ✅ Verde (4/4 checks aprobados)
- Cambios: N archivos modificados (+X/-Y líneas)
- Pendiente: Tu aprobación para mergear a develop

¿Deseas que proceda con el merge?
```

### 7. Ejecución del merge (Solo tras confirmación explícita)
```text
Humano: "Sí, procede con el merge."
IA: Ejecuta el merge o confirma la finalización en GitHub.
```

---

## Prohibiciones explícitas
- ❌ Mergear sin que los 4 checks de CI estén completamente en verde.
- ❌ Mergear sin la aprobación explícita del Tech Lead humano.
- ❌ Usar `--force` si el push de la rama es rechazado.
