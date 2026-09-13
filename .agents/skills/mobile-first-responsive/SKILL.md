---
name: mobile-first-responsive
description: Directiva estricta de diseño mobile-first, transformación adaptativa de tablas a Card View/tarjetas, eliminación de scroll horizontal y erradicación total de glitches visuales o desbordamientos RenderFlex en viewports móviles (320px - 480px).
---

# Mobile-First Responsive & Adaptive UX/UI

## 1. Filosofía Central
1. **Mobile-First Real**: Diseñar y validar prioritariamente para pantallas de **320px a 480px**. Luego escalar a tablet (768px) y escritorio (1024px+). Nunca diseñar pensando en escritorio y luego intentar "encogerlo" a la fuerza.
2. **Adaptación Estructural, no Reducción Forzada**: Prohibido usar `transform: scale()`, `zoom` o reducir tipografías a tamaños ilegibles (<12px) para que "quepa todo". La estructura del layout debe cambiar radicalmente según el viewport.
3. **Cero Scroll Horizontal**: El usuario en móvil jamás debe deslizar horizontalmente para consumir información o navegar. Un scroll horizontal no deseado es un defecto crítico de diseño.
4. **Cero Glitches Visuales o Franjas de Error**: Erradicación absoluta de franjas de error (`RenderFlex overflowed by X pixels` en Flutter o barras de scroll rotas en CSS/Web).

---

## 2. Estrategias para Tablas de Datos (Obligatorias en Móvil)

Las tablas complejas de más de 3 o 4 columnas NO caben en un ancho de 360-440px sin romperse o forzar un scroll horizontal torpe. En viewports móviles (< 768px), se debe aplicar una de las siguientes estrategias:

### Estrategia A: Card View (Formato Tarjeta - Altamente Recomendado)
En lugar de una fila horizontal rígida con múltiples columnas comprimidas, cada registro se renderiza como una **Tarjeta Móvil Independiente**:
- **Encabezado de la Tarjeta**: Icono representativo + Identificador/Título principal + Badge de Estado / Chip semántico a la derecha.
- **Cuerpo de la Tarjeta**: Pares clave-valor (`Label`: `Valor`) con espaciado vertical armónico y tipografía clara.
- **Pie de la Tarjeta**: Botones de acción primaria/secundaria con área táctil cómoda (mínimo 44x44px).

### Estrategia B: Columnas Esenciales + Ficha Modal
Si se mantiene una vista tabular:
- Mostrar en móvil únicamente las **2 columnas críticas** (ej. *Colaborador* + *Estado*).
- Ocultar las columnas secundarias (IP, Timestamp UTC largo, etc.).
- Toda la información complementaria se visualiza al tocar la fila mediante un **Bottom Sheet** o **Modal de Ficha Técnica**.

---

## 3. Navegación y Shell Móvil
- **Sidebar**: En móvil (< 850px), el menú lateral fijo se desmonta del layout principal y se convierte en un `Drawer` nativo deslizable o menú overlay accesible mediante botón hamburguesa (`Icons.menu`).
- **Topbar**: Extremadamente compacto. Solo muestra botón de menú + título de la sección activa + avatar/tema. Se ocultan barras de búsqueda fijas con atajos anchos de teclado (`⌘K`) o textos extensos.
- **Área Táctil**: Todo botón o elemento interactivo debe respetar el estándar ergonómico táctil de **al menos 44x44px**.

---

## 4. Control de Desbordamientos (Glitches & Overflows)
- En `Row` o `Flex`: Todo hijo con texto dinámico o ancho variable DEBE estar protegido con `Expanded` o `Flexible` y `overflow: TextOverflow.ellipsis`.
- En `Text`: Definir siempre `maxLines` explícito cuando conviva con otros elementos horizontales.
- Si dos elementos no caben horizontalmente en 360px, usar `Wrap` o transformar a `Column` con alineación inicial.

---

## 5. Checklist de Verificación Mobile-First
Antes de declarar lista cualquier vista o pantalla, auditar obligatoriamente en un viewport de **400x850px** (iPhone / Android estándar):
- [ ] ¿Existe alguna franja de advertencia o error de desbordamiento (`RenderFlex overflow`)?
- [ ] ¿Hay scroll horizontal no intencionado en la pantalla?
- [ ] ¿Las tablas se leen con naturalidad en formato tarjeta o columnas prioritarias?
- [ ] ¿Los botones y acciones son fáciles de presionar con el pulgar (≥44px)?
- [ ] ¿Los textos largos se truncan con elegancia sin romper la cuadrícula?
- [ ] ¿`flutter analyze` o linter reporta 0 errores y 0 advertencias?
