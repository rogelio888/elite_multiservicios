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

### Fase 1: Desarrollo y Pruebas en Entorno Local
1. **Verificar Servicios Locales Activos**:
   - Base de datos PostgreSQL local corriendo (Docker o instancia local configurada).
   - Servidor Serverpod iniciado en modo desarrollo (`dart run bin/main.dart`).
   - Aplicación Flutter ejecutándose localmente (`flutter run -d chrome` o desktop).
2. **Implementación de Cambios**:
   - Todo dato debe provenir de PostgreSQL / API local (cumplimiento estricto de `no-mock-policy`).
   - Mantener fidelidad visual y estética corporativa.
3. **Prueba Empírica Personal (Aprobación del Colaborador)**:
   - El colaborador debe abrir el navegador o ventana de la app, navegar por la pantalla modificada, probar clics, formularios, validaciones y respuestas en tiempo real.
   - El colaborador debe dar su visto bueno personal explícito: *"Probado y aprobado por mí en local"*.

### Fase 2: Control de Calidad y Cero Errores
Antes de tocar Git, ejecutar la batería de verificación obligatoria:
```bash
# 1. Formateo de código
dart format --output=none --set-exit-if-changed .

# 2. Análisis estático (debe reportar 0 issues)
cd elite_multiservicios_server && dart analyze && cd ..
cd elite_multiservicios_flutter && flutter analyze && cd ..

# 3. Tests automatizados
cd elite_multiservicios_flutter && flutter test && cd ..
```
*Si existe un solo warning o test fallido, corregirlo de inmediato en local.*

### Fase 3: Apertura de Pull Request hacia `develop`
1. **Crear Rama Específica**:
   ```bash
   git checkout -b feat/<nombre-descriptivo>
   # o fix/<nombre-descriptivo>
   ```
2. **Commit Convencional**:
   ```bash
   git commit -m "feat(usuarios): directorio corporativo estilo clerk con drawer de detalle"
   ```
3. **Publicar Rama y Abrir PR**:
   ```powershell
   git push -u origin feat/<nombre-descriptivo>
   gh pr create --base develop --title "feat(modulo): descripción clara" --body "## Pruebas en Local`n- [x] Probado y aprobado personalmente en local con datos reales.`n- [x] flutter analyze: 0 problemas.`n- [x] flutter test: todos pasando."
   ```

### Fase 4: Integración Continua (CI) y Aprobación
1. **Verificación de CI en GitHub**:
   Los 4 checks automáticos deben pasar en verde:
   - `Secret Leak Detection (Gitleaks)`
   - `Code Formatting & Static Analysis`
   - `Flutter Unit & Widget Tests`
   - `Serverpod Tests & Database Integration`
2. **Aprobación de Code Review**:
   - El colaborador **NO** mergea directamente a `develop`.
   - El Tech Lead (`@rogelio888`) revisa y aprueba el PR en GitHub.
3. **Promoción a `main`**:
   - Una vez incorporado en `develop` y validado el entorno integrado, se sincroniza y promueve hacia `main` para despliegue productivo.

---

## Lista de Verificación Rápida (Checklist)
- [ ] ¿El cambio fue ejecutado y probado en vivo en `localhost`?
- [ ] ¿Fue aprobado personalmente por el colaborador tras interactuar con la interfaz?
- [ ] ¿Hay 0 datos mock o números falsos (`no-mock-policy`)?
- [ ] ¿`flutter analyze` y `dart analyze` reportan 0 problemas?
- [ ] ¿Todos los tests de Flutter pasan al 100%?
- [ ] ¿El PR apunta a `develop` y no a `main`?
