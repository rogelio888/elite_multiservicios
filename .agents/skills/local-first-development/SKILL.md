---
name: local-first-development
description: Protocolo obligatorio de desarrollo local-first para colaboradores. Todo cambio debe desarrollarse, probarse y aprobarse personalmente en local antes de abrir PR a develop y promover a main.
---

# Local-First Development Protocol — Elite Multiservicios

## Propósito y Regla de Oro
Todo colaborador del proyecto **Elite Multiservicios** debe garantizar que cualquier funcionalidad, ajuste visual o corrección sea ejecutado, probado y **aprobado personalmente en su entorno local** antes de iniciar el proceso de subida remota.

> **REGLA FUNDAMENTAL:**  
> Está estrictamente **PROHIBIDO** hacer `git push`, abrir Pull Requests o intentar fusionar ramas sin haber probado empírica y visualmente los cambios en local.

---

## Fases del Flujo de Trabajo

### Fase 1: Inicio de Jornada y Creación de Rama
1. **Sincronizar base antes de programar**:
   ```bash
   git checkout develop
   git pull origin develop
   ```
2. **Aislar en rama de trabajo**:
   ```bash
   git checkout -b feat/<nombre-descriptivo>
   # o fix/<nombre-descriptivo>, chore/<nombre-descriptivo>
   ```
   *Nunca programar directamente sobre `develop` ni sobre `main`.*

### Fase 2: Desarrollo y Pruebas en Entorno Local
1. **Verificar Servicios Locales Activos**:
   - Base de datos PostgreSQL local corriendo (Docker o instancia local).
   - Servidor Serverpod iniciado en modo desarrollo (`dart run bin/main.dart` o script `run-server.ps1`).
   - Aplicación Flutter ejecutándose localmente (`flutter run -d chrome` o desktop).
2. **Implementación de Cambios**:
   - Todo dato debe provenir de PostgreSQL / API local (cumplimiento estricto de `no-mock-policy`).
   - Mantener fidelidad visual y estética corporativa.
3. **Prueba Empírica Personal (Aprobación del Colaborador)**:
   - El colaborador debe abrir el navegador o ventana de la app, navegar por la pantalla modificada, probar clics, formularios, validaciones y respuestas en tiempo real.
   - El colaborador debe dar su visto bueno personal explícito: *"Probado y aprobado por mí en local"*.

### Fase 3: Control de Calidad y Cero Errores (Pre-Flight)
Antes de preparar la subida a Git, ejecutar la batería de verificación obligatoria:
```bash
# 1. Formateo de código
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático (debe reportar 0 issues)
cd elite_multiservicios_server && dart analyze && cd ..
cd elite_multiservicios_flutter && flutter analyze && cd ..

# 3. Tests automatizados
cd elite_multiservicios_flutter && flutter test && cd ..
cd elite_multiservicios_server && dart test && cd ..
```
*Si existe un solo warning o test fallido, corregirlo de inmediato en local.*

### Fase 4: Verificación Anti-Colisión y Push Remoto
1. **Detección Preventiva de Cambios Concurrentes**:
   ```bash
   git fetch origin develop
   git log HEAD..origin/develop --oneline
   ```
2. **Integración limpia si otro desarrollador subió código**:
   ```bash
   git rebase origin/develop
   # Resolver choques en local si existen -> git rebase --continue
   ```
3. **Subir rama aislada**:
   ```bash
   git push -u origin feat/<nombre-descriptivo>
   ```

### Fase 5: PR Automático por la IA, CI y Fusión a `develop`
1. **Apertura de PR por la IA**:
   - La IA crea automáticamente el PR apuntando **exclusivamente a `develop`** (`--base develop`) mediante `gh pr create --body-file ...`.
2. **Verificación de CI en GitHub**:
   - Los 4 checks automáticos deben pasar en verde (`Secret Leak Detection`, `Code Formatting & Static Analysis`, `Flutter Tests`, `Serverpod Tests`).
3. **Fusión y Sincronización**:
   - Una vez aprobado, se fusiona el PR a `develop` (`gh pr merge --merge --delete-branch`).
   - El colaborador o la IA vuelve a `develop` local y ejecuta `git pull origin develop`.
4. **Promoción a `main`**:
   - `main` solo se actualiza mediante releases oficiales aprobadas por el Tech Lead (`@rogelio888`).

---

## Lista de Verificación Rápida (Checklist)
- [ ] ¿Iniciaste el día con `git checkout develop && git pull origin develop`?
- [ ] ¿Creaste una rama aislada antes de tocar código?
- [ ] ¿El cambio fue ejecutado y probado en vivo en `localhost` con datos reales (`no-mock-policy`)?
- [ ] ¿`flutter analyze` y `dart analyze` reportan 0 problemas?
- [ ] ¿Hiciste `git fetch origin develop` para verificar que ningún compañero subió cambios antes de pushear?
- [ ] ¿El PR apunta a `develop` y JAMÁS a `main`?
