---
name: emil-kowalski
description: Microinteracciones táctiles, motion design refinado, feedback físico y sensación de producto premium.
---

# Emil Kowalski — Microinteracciones & Tactilidad

## Propósito
Transformar pantallas estáticas en experiencias que se sienten vivas, reactivas y táctiles, con microinteracciones de clase mundial.

## Reglas de Implementación
1. **Hover & Cursor**:
   - Todo elemento interactivo debe responder al puntero en 150-200ms (`Curves.easeOutCubic`).
   - Sutil elevación o cambio de tinte de borde (`#1E293B` a `#2563EB` o `#CBD5E1`).

2. **Feedback Físico**:
   - Compresión elástica ligera al hacer clic (`scale(0.98)`).
   - Sombras dinámicas que se expanden sutilmente al pasar el ratón.

3. **Transición sin Rupturas**:
   - Evitar cambios de estado abruptos; usar `AnimatedContainer`, `AnimatedOpacity`, `AnimatedCrossFade`.
