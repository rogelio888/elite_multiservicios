# Checklist: Antes de cada commit

Verificación previa obligatoria antes de ejecutar `git commit`:

- [ ] `dart format --set-exit-if-changed .` ejecutado sin cambios pendientes.
- [ ] `dart analyze` en `elite_multiservicios_server` → 0 problemas reportados.
- [ ] `flutter analyze` en `elite_multiservicios_flutter` → 0 problemas reportados.
- [ ] `flutter test` en `elite_multiservicios_flutter` → 100% pruebas aprobadas.
- [ ] `dart test` en `elite_multiservicios_server` → 100% pruebas aprobadas.
- [ ] `git check-ignore .env elite_multiservicios_server/config/passwords.yaml` → ambos archivos aparecen listados.
- [ ] `git status` no muestra `.env`, `passwords.yaml` ni llaves privadas sin ignorar.
- [ ] El mensaje de commit sigue estrictamente el estándar de Conventional Commits (`feat:`, `fix:`, etc.).

> 🛑 **Si alguno de los puntos falla, NO realices el commit.** Corrige la causa raíz primero.
