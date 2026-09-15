---
name: token-optimizer
description: Monitoreo y optimización continua de ventana de contexto y rango de lectura de archivos.
---

# Token Optimizer Skill

## Directivas
- Usar rangos específicos (`StartLine` / `EndLine`) al leer archivos. Prohibido leer archivos masivos completos si no es estrictamente necesario.
- Reutilizar contexto existente y evitar repetir código sin cambios.
- Usar búsquedas focalizadas (`grep_search`) antes de abrir directorios extensos.
