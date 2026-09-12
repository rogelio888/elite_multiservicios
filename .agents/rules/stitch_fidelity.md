# Regla de Gobernanza: Fidelidad Absoluta al Diseño de Google Stitch

> **Regla de oro absoluta**: Toda pantalla implementada en Flutter DEBE ser visualmente idéntica al diseño aprobado en Google Stitch. No se permiten "interpretaciones" ni "aproximaciones". Si el diseñador puso el logo a 160px, va a 160px. Si el color es `#0B0F19`, es `#0B0F19`.

---

## 1. Principios

### 1.1. Stitch es la fuente de verdad
- El diseño en Google Stitch es **el contrato visual**.
- Flutter implementa, no diseña.
- Cualquier desviación del diseño es un bug, no una decisión creativa.

### 1.2. Fidelidad pixel-perfect
- Los colores exactos del diseño (hex).
- Las tipografías exactas (familia, tamaño, peso, tracking).
- Los espaciados exactos (padding, margin, gap).
- Los radios de borde exactos.
- Las sombras exactas.
- Los iconos exactos (o equivalentes más cercanos).
- Las posiciones exactas (logo arriba, texto centrado, botón full-width, etc.).

### 1.3. Prohibido "interpretar"
- ❌ "El diseñador puso un gradiente, yo puse un color plano."
- ❌ "El badge tenía icono, yo lo puse solo con texto."
- ❌ "El tagline era bold 30px, yo lo puse regular 15px."
- ❌ "El fondo era casi negro, yo lo puse azul saturado."
- ✅ "Copio exactamente lo que dice el diseño."

## 2. Flujo obligatorio antes de implementar

### 2.1. Exportar el HTML/CSS de Stitch
Antes de escribir una línea de Flutter:
1. Usar la herramienta `get_screen` del MCP de Stitch para obtener el HTML.
2. Descargar el HTML de la pantalla objetivo.
3. Leer el HTML y extraer:
   - Colores exactos (hex).
   - Tipografías (familia, tamaño, peso).
   - Espaciados (padding, margin).
   - Radios, sombras.
   - Jerarquía de elementos (qué va arriba, qué va abajo).

### 2.2. Guardar el HTML de referencia
Guardar el HTML en `elite_multiservicios_flutter/.stitch_reference/<nombre_pantalla>.html`.
Este archivo se consulta durante la implementación y sirve como contrato.

### 2.3. Comparar 1:1 antes de aprobar
Al terminar la implementación:
1. Correr la app.
2. Tomar captura.
3. Comparar lado a lado con la captura del diseño de Stitch.
4. Si hay diferencias → iterar hasta que sean idénticas.

## 3. Checklist de fidelidad

Antes de declarar una implementación "lista":

- [ ] Los colores coinciden exactamente con los tokens de Stitch.
- [ ] Las tipografías coinciden (familia, tamaño, peso, tracking).
- [ ] Los espaciados coinciden (padding, margin, gap).
- [ ] Los radios de borde coinciden.
- [ ] Las sombras coinciden.
- [ ] Los iconos están presentes (o equivalentes más cercanos documentados).
- [ ] La jerarquía visual coincide (qué es título, qué es subtítulo, qué es cuerpo).
- [ ] La posición de los elementos coincide (arriba, centro, abajo).
- [ ] Comparación lado a lado realizada con captura.

## 4. Prohibiciones

- ❌ Implementar sin exportar el HTML de Stitch primero.
- ❌ Declarar "listo" sin comparar lado a lado con el diseño.
- ❌ Aproximar colores, tipografías o espaciados "porque se ven parecidos".
- ❌ Omitir elementos del diseño (iconos, badges, decoraciones).
- ❌ Inventar elementos que no están en el diseño.

## 5. Excepciones justificadas

Si por alguna razón técnica NO se puede replicar algo exacto:
1. Documentar la diferencia.
2. Pedir aprobación al humano antes de desviarse.
3. Registrar la excepción en el PR con justificación técnica.

Ejemplos de excepciones válidas:
- Una fuente específica no está disponible en `google_fonts` → usar la más parecida y documentar.
- Un efecto CSS no tiene equivalente directo en Flutter → usar el más cercano y documentar.
- Una herramienta del diseño no está disponible → aproximar y avisar.

## 6. Referencias

- Flujo de diseño: `.agents/rules/stitch_workflow.md`.
- Skill de implementación: `.agents/skills/implement-from-stitch/SKILL.md`.
