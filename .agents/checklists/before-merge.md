# Checklist: Antes de mergear un Pull Request

Verificación previa obligatoria antes de ejecutar o autorizar el merge de un PR a `develop` o `main`:

- [ ] Los 4 checks automáticos del CI en GitHub Actions están en verde ✅ (`secrets-scan`, `code-quality`, `flutter-tests`, `server-tests`).
- [ ] El PR cuenta con un título y descripción claros conforme al cambio realizado.
- [ ] No existen conflictos de integración con la rama base (`develop`).
- [ ] La rama de tarea se encuentra actualizada con los últimos cambios de `develop`.
- [ ] El revisor humano y Tech Lead (`@rogelio888`) ha otorgado su aprobación explícita.
- [ ] Todas las pruebas locales continúan pasando exitosamente sobre la rama.

> 🛑 **Si alguno de los puntos falla o falta aprobación, NO procedas con el merge.**
