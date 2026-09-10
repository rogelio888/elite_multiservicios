---
name: pre-completion-check
description: Checklist obligatorio de verificación empírica antes de declarar cualquier tarea terminada en Elite Multiservicios.
---

# Pre-Completion Check Skill

Antes de responder "Listo" o dar por finalizada una tarea en este proyecto:

1. Ejecutar formato: `dart format --output=none --set-exit-if-changed .`
2. Ejecutar análisis estático:
   - `cd elite_multiservicios_server && dart analyze`
   - `cd elite_multiservicios_flutter && flutter analyze`
   - **Criterio**: 0 errores y 0 advertencias.
3. Ejecutar pruebas unitarias:
   - `flutter test`
   - `cd elite_multiservicios_server && dart test test/unit/domain_security_test.dart`
4. Revisar que no se hayan introducido secretos (`passwords.yaml`, `.env`, tokens).
5. Revisar `git status` y `git diff`.
6. En caso de que alguna verificación no pueda ejecutarse (ej. Docker no iniciado), reportar con precisión:
   - `VERIFICADO`: Lista de puntos comprobados.
   - `NO VERIFICADO`: Puntos pendientes.
   - `MOTIVO`: Causa técnica real.
