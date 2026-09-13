---
name: animate-skill
description: Coreografía de animación avanzada, entradas escalonadas (stagger) y transiciones fluidas.
---

# Animate Skill — Coreografía de Movimiento

## Propósito
Guiar la atención del usuario mediante animación intencional y fluida, evitando movimientos innecesarios o distractores.

## Pautas
1. **Entradas Escalonadas (Staggered)**:
   - Al cargar listas o grids, animar cada elemento con un retraso secuencial de 30-50ms.
   - Efecto combinado de `FadeTransition` + `SlideTransition` leve (8-16px de offset hacia arriba).

2. **Easing Natural**:
   - Prohibidas las transiciones lineales (`linear`) para UI.
   - Usar `Curves.fastOutSlowIn`, `Curves.easeOutQuart` o `Curves.easeInOutCubic`.

3. **Duración Calibrada**:
   - Microinteracciones: 150-200ms.
   - Entradas de modales/hojas: 250-350ms.
   - Cambios de página: 200-300ms.
