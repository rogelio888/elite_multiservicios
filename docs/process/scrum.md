# Marco de Trabajo Ágil: Scrum y Definición de Terminado (Definition of Done)

## 1. Visión del Marco Scrum
El equipo aplica el marco Scrum para la entrega continua de incrementos funcionales con calidad técnica garantizada.

### Roles y Responsabilidades:
- **Product Owner (PO)**: Responsable de maximizar el valor del producto y priorizar el Product Backlog.
- **Scrum Master**: Facilitador de ceremonias, protector del proceso y eliminador de impedimentos (no actúa como jefe técnico).
- **Development Team**: Equipo multidisciplinario autoorganizado con plena propiedad del código, calidad y arquitectura.

---

## 2. Eventos y Ceremonias
1. **Sprint Planning**: Definición del objetivo del Sprint (Sprint Goal) y selección de elementos del Product Backlog para el Sprint Backlog.
2. **Daily Scrum**: Sincronización diaria de 15 minutos centrada en el progreso hacia el Sprint Goal y detección temprana de bloqueos.
3. **Sprint Review**: Demostración y validación empírica del incremento terminado frente a los interesados.
4. **Sprint Retrospective**: Inspección y adaptación del proceso del equipo para mejora continua.

---

## 3. Definición de Terminado (Definition of Done - DoD)
Una tarea o historia de usuario **SOLO** puede declararse **DONE** cuando se cumplen la totalidad de las siguientes condiciones:

```
[ ] Código fuente implementado respetando la arquitectura modular.
[ ] Formateo estricto verificado (`dart format`).
[ ] Cero errores y cero advertencias en análisis estático (`dart analyze` y `flutter analyze`).
[ ] Pruebas unitarias implementadas y ejecutadas con resultado 100% exitoso.
[ ] Pruebas de integración comprobadas contra base de datos cuando aplique.
[ ] Code Review formal aprobado por al menos un par técnico.
[ ] Pipeline de CI en GitHub Actions ejecutado con éxito.
[ ] Cero secretos o claves expuestas en el repositorio.
[ ] Documentación técnica actualizada en docs/ si se incorporaron decisiones o cambios de arquitectura.
[ ] Integración funcional verificada en el entorno correspondiente.
```

> **REGLA DE ORO**: "Ya escribí el código" o "funciona en mi máquina" **NO** significa DONE.

---

## 4. Estado de Sprints e Incrementos Funcionales

### Sprint 1: Núcleo de Seguridad y Control de Accesos
- **Objetivo**: Desarrollar la columna vertebral de seguridad con RBAC relacional, auditoría y UI completa.
- **Entregables**:
  - [x] **Fase 1**: Andamiaje Serverpod + Flutter + PostgreSQL + Docker Compose + CI/CD + Normas. (**DONE**)
  - [x] **Fase 2**: Modelado relacional `.spy.yaml`, repositorios PostgreSQL y migraciones aplicadas. (**DONE**)
  - [x] **Fase 3**: Endpoints RPC Serverpod, `RbacGuard`, Seeds de permisos y tests unitarios. (**DONE**)
  - [x] **Fase 4**: UI Flutter (Dashboard, Gestión de Usuarios, RBAC Matrix, Bitácora y Sesiones). (**DONE**)

