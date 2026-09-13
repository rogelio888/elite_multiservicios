# Regla de Gobernanza Visual: Excelencia en Diseño de Interfaz & Dirección de Arte

> **Mandato Supremo**: Las interfaces de Elite Multiservicios deben evocar una experiencia **única, formal, minimalista, ejecutiva y con personalidad auténtica**. Queda estrictamente prohibido generar interfaces genéricas de IA (como estructuras repetitivas de 3 tarjetas idénticas, héroes vacíos sin propósito, o paletas deslavadas).

Esta regla codifica e integra las skills globales de diseño del sistema en el flujo de trabajo del proyecto:
1. **`taste-skill`** (Dirección de arte auténtica, estética minimalista formal, asimetría intencional, personalidad de marca).
2. **`pbakaus/impeccable`** (Precisión tipográfica, jerarquía visual matemática, ritmo modular 4/8pt, componentes de alta gama).
3. **`emil-kowalski/skill`** (Microinteracciones táctiles, animaciones elásticas físicas, estados hover y focus refinados).
4. **`animate-skill`** (Coreografía de movimiento, entradas escalonadas/stagger, easing no-lineal y transiciones fluidas).
5. **`web-design-guidelines` & `ui-ux-pro-max-cli`** (Accesibilidad WCAG AA/AAA, ergonomía táctil, 100% responsividad sin desbordamiento horizontal).

---

## 1. Dirección de Arte & Estética (`taste-skill`)

### 1.1. Anti-Patrones de IA Prohibidos (Cero Diseños Genéricos)
- ❌ **Prohibido**: El layout de "3 tarjetas idénticas flotando" con iconos centrados sin contexto.
- ❌ **Prohibido**: Héroes gigantescos vacíos que empujan el contenido útil fuera de la pantalla.
- ❌ **Prohibido**: Gradientes de baja fidelidad (como violeta/fucsia estándar de plantilla).
- ❌ **Prohibido**: Tablas rígidas sin adaptación responsiva que fuercen un scroll horizontal tosco.
- ❌ **Prohibido**: UUIDs, direcciones IP crudas o tecnicismos expuestos al personal de operaciones.

### 1.2. Principios de Identidad Visual Elite
- **Minimalismo Formal con Carácter**: Espacios de respiración generosos, líneas estructurales limpias y contraste deliberado.
- **Asimetría Funcional**: Destacar la información crítica mediante proporción (ej: paneles 60/40, tarjetas ejecutivas con micro-métricas y gráficas sparkline).
- **Materialidad Tecnológica**: Fondos en obsidiana profunda (`#0B0F19`), pizarras medianoche (`#0F172A`, `#1E293B`) y lienzos claros clínicos (`#F8FAFC`, `#FFFFFF`), delineados por bordes milimétricos hairline (`#334155` / `#E2E8F0`).

---

## 2. Precisión Visual & Sistema de Componentes (`pbakaus/impeccable`)

### 2.1. Paleta Cromática Institucional
- **Obsidian Dark Surface**: `#0B0F19` (canvas principal) y `#0F172A` (tarjetas elevadas).
- **Executive Navy & Sapphire**: `#1E3A8A` (ancla de marca) y `#2563EB` (interactividad de alta prioridad).
- **Emerald Integrity**: `#059669` (seguridad activa, estado en línea, verificación 2FA).
- **Amber Warning**: `#D97706` (alertas de política, configuraciones pendientes).
- **Crimson Security Alert**: `#DC2626` (revocaciones, incidentes, bloqueos).
- **Subtle Slate Borders**: `#1E293B` / `#334155` (modo oscuro) y `#E2E8F0` / `#CBD5E1` (modo claro).

### 2.2. Tipografía con Jerarquía Estricta
- **Títulos Ejecutivos**: Letras con tracking negativo ligero (`-0.02em` a `-0.01em`) para peso institucional.
- **Micro-Labels y Badges**: Tipografía seminegrita/negrita en caja alta o title case con espaciado ligeramente positivo (`0.04em`).
- **Datos Criptográficos y Hashes**: Siempre en tipografía monoespaciada (`monospace`), truncados con formato forense y botón de copiado.

### 2.3. Ritmo Modular y Espaciado
- Cuadrícula de 8pt con sub-módulo de 4pt para micro-alineación.
- Radios de borde estandarizados:
  - `8px`: Controles de formulario, botones compactos, inputs.
  - `12px` - `16px`: Tarjetas ejecutivas, paneles de contenido.
  - `20px` - `24px`: Hero banners, modales y hojas inferiores (*bottom sheets*).
  - `9999px` (Pill): Badges de estado e indicadores de pulso.

---

## 3. Microinteracciones & Tactilidad (`emil-kowalski/skill`)

- **Hover States Suaves**: Todo botón, tarjeta interactiva o elemento clickable debe responder suavemente al puntero en un rango de `150ms` a `200ms`.
- **Efecto de Presencia en Vivo**: Indicadores de pulso circulares con halos translúcidos para estados concurrentes (*En Línea*, *Sistema Online*).
- **Retroalimentación Física**: Reducción sutil de escala (`0.98`) o elevación de sombra en estados activos/hover.
- **Acciones Críticas**: Botones destructivos (como Revocar Sesión o Suspender) destacados en tonos carmesí con diálogo de confirmación que explique las implicaciones de seguridad.

---

## 4. Coreografía de Movimiento (`animate-skill`)

- **Entradas Escalonadas (Staggered)**: Las tarjetas y filas de listas deben entrar con un retraso progresivo sutil para crear una sensación de orquestación fluida.
- **Curvas de Aceleración**: Usar curvas no-lineales naturales (`Curves.easeInOutCubic`, `Curves.easeOutQuart`).
- **Transición de Pestañas**: Desvanecimiento suave (*fade cross-dissolve*) sin saltos bruscos de diseño.

---

## 5. Accesibilidad & Auditoría de Ergonomía (`web-design-guidelines` & `ui-ux-pro-max-cli`)

- **Contraste de Texto**: Ratio mínimo de 4.5:1 para texto regular y 3:1 para encabezados grandes (WCAG AA).
- **Zonas Táctiles**: Tamaño mínimo de clic de 44x44 píxeles para todos los elementos accionables.
- **Cero Desbordamiento Horizontal**: Todas las tablas y vistas deben ser auto-responsivas mediante flex y grid; prohibido obligar al usuario a desplazarse horizontalmente para leer información básica.
- **Protección de Datos Confidenciales**: Prohibido mostrar contraseñas, hashes completos sin truncar, o detalles internos de la base de datos a operadores no calificados.

---

## 6. Integración con Google Stitch

1. **Stitch es el Diseñador Formal**: Toda nueva pantalla o flujo debe prototiparse en Stitch antes de implementarse.
2. **Prompts Guiados por Arte**: Al solicitar pantallas a Stitch (vía MCP), se debe inyectar esta guía de estilo formal y minimalista.
3. **Fidelidad y Elevación**: Flutter implementa el diseño de Stitch con precisión milimétrica (`stitch_fidelity.md`) e inyecta las microinteracciones (`emil-kowalski`) y la conexión de datos reales (`no-mock-policy`).
