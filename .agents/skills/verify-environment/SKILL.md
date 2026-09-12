---
name: verify-environment
description: Verifica que el entorno local del colaborador está listo antes de empezar a trabajar.
---

# Verify Environment Skill

## Cuándo usar
Antes de empezar a trabajar en una tarea nueva, o cuando el colaborador sospeche que algún servicio, contenedor o dependencia no está funcionando adecuadamente.

---

## Pasos de verificación

### 1. Verificar Git
```bash
git status
git branch --show-current
git log --oneline -3
```
- El working tree debe estar limpio (`nothing to commit, working tree clean`).
- Debe estar en una rama distinta a `main` o `develop` si ya está trabajando en una tarea.

### 2. Verificar Docker
```bash
cd elite_multiservicios_server
docker compose ps
cd ..
```
- Los 4 servicios deben estar en estado `Up`:
  - `postgres` (8090)
  - `redis` (8091)
  - `postgres_test` (9090)
  - `redis_test` (9091)

### 3. Verificar Backend Serverpod
```bash
curl http://localhost:8082
```
- Debe devolver respuesta HTML o JSON válida. Si falla, el backend no está iniciado.

### 4. Verificar Flutter
```bash
cd elite_multiservicios_flutter
flutter doctor
flutter pub get
cd ..
```
- Las dependencias deben resolver sin errores ni conflictos.

### 5. Verificar Tests
```bash
cd elite_multiservicios_flutter
flutter test
cd ../elite_multiservicios_server
dart test
cd ..
```
- Ambas suites deben pasar al 100% sin excepciones.

---

## Reporte obligatorio

```text
## Estado del entorno
- [x] Git: rama <nombre>, working tree limpio
- [x] Docker: 4/4 Up (postgres, redis, postgres_test, redis_test)
- [x] Backend: responde en :8082
- [x] Flutter: doctor sin issues críticos, pub get OK
- [x] Tests: N/M pasando (100%)

## Conclusión
Entorno listo / Entorno con problemas (detallar exactamente el fallo y solución requerida)
```
