---
name: git-workflow
description: Protocolo de ramas y contribución Git para el equipo de Elite Multiservicios.
---

# Git Workflow Skill

Reglas obligatorias de Git para el repositorio:

1. **Ramas Principales Protegidas**: `main` y `develop`. Prohibido commit o push directo.
2. **Creación de Ramas**: Ramas creadas a partir de `develop` con nomenclatura `feature/*`, `fix/*`, `refactor/*`, `test/*`, `docs/*`.
3. **Flujo de Integración**:
   - `develop` $\rightarrow$ `feature/*` $\rightarrow$ Formato & Tests $\rightarrow$ Push $\rightarrow$ Pull Request $\rightarrow$ Code Review & CI $\rightarrow$ Merge a `develop`.
4. **Despliegues a Producción**: Únicamente desde `main` mediante releases controladas y aprobadas. Jamás desplegar cambios no probados directamente a producción.
