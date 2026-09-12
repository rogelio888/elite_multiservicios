---
name: implement-from-stitch
description: Implementa una pantalla de Flutter a partir de un diseño aprobado en Google Stitch, asegurando fidelidad pixel-perfect.
---

# Implement From Stitch Skill

## Cuándo usar
Cuando el humano pide implementar en Flutter una pantalla que ya fue diseñada y aprobada en Google Stitch.

## Prerequisitos
- El diseño existe en Stitch y fue aprobado por el humano.
- El ID de la pantalla en Stitch es conocido.
- El MCP de Stitch está conectado.

## Pasos

### 1. Obtener el diseño desde Stitch

Llamar a `get_screen` con el ID de la pantalla:
```text
Tool: get_screen
Args: { projectId: "...", screenId: "..." }
```

Obtener:
- El HTML exportado.
- La captura (screenshot).
- Los tokens (colores, tipografías, espaciados).

### 2. Guardar el HTML de referencia

Guardar el HTML en:
`elite_multiservicios_flutter/.stitch_reference/<nombre_pantalla>.html`

Este archivo se convierte en el **contrato visual** de la implementación.

### 3. Analizar el HTML y extraer tokens

Leer el HTML y extraer:
- Colores exactos (hex) → mapear a `AppTheme` o constantes locales.
- Tipografías (familia, tamaño, peso) → mapear a `GoogleFonts` o `TextStyle`.
- Espaciados (padding, margin, gap) → mapear a `SizedBox` y `EdgeInsets`.
- Radios de borde → mapear a `BorderRadius.circular(...)`.
- Sombras → mapear a `BoxShadow(...)`.
- Jerarquía de elementos → mapear a `Column`, `Row`, `Stack`.

Si algún token NO está en `AppTheme`, agregarlo primero.

### 4. Implementar en Flutter

**Regla**: replicar 1:1. NO interpretar.

- Usar los colores exactos del HTML.
- Usar las tipografías exactas.
- Usar los espaciados exactos.
- Replicar la estructura (qué va arriba, qué va abajo).

### 5. Comparar 1:1 con el diseño

Al terminar:
1. Correr la app: `flutter run -d chrome`.
2. Tomar captura de pantalla.
3. Comparar lado a lado con la captura de Stitch.
4. Anotar diferencias.

### 6. Iterar hasta fidelidad

Si hay diferencias:
1. Identificar cada diferencia (color, tamaño, espaciado, posición).
2. Ajustar el código.
3. Volver al paso 5.
4. Repetir hasta que las capturas sean **idénticas**.

### 7. Reportar al humano

Formato obligatorio:
```text
Implementación de <NombrePantalla>

Fidelidad
☑ Colores coinciden
☑ Tipografías coinciden
☑ Espaciados coinciden
☑ Posiciones coinciden
☑ Iconos presentes
☑ Comparación 1:1 realizada

Diferencias documentadas (si las hay)
<diferencia>: <razón técnica>

Capturas
Stitch: <URL>
Flutter: <URL o descripción>

Tests
flutter analyze: 0 problemas
flutter test: N/N pasando

Próximo paso
Esperando aprobación visual del humano antes de commitear.
```

## Reglas

- ❌ NO implementar sin leer el HTML de referencia.
- ❌ NO declarar "listo" sin comparar lado a lado.
- ❌ NO saltar la comparación 1:1.
- ✅ Documentar cualquier excepción técnica.
- ✅ Pedir aprobación del humano antes del commit.

## Ejemplo real

**Problema detectado en LoginScreen (2026-09-11)**:
- Stitch: fondo casi negro + logo 160px + tagline bold 30px + badges con icono.
- Flutter: fondo azul saturado + logo 200px + tagline regular 15px + badges solo texto.
- **Causa**: la IA implementó sin leer el HTML completo, "interpretó" el diseño.
- **Lección**: siempre leer el HTML primero. Comparar 1:1 antes de aprobar.
