# Regla de Gobernanza de Diseño: Flujo Obligatorio con Google Stitch

A partir de este momento, **todo diseño de interfaz de usuario** que se vaya a implementar en el sistema **DEBE partir de Google Stitch**.

---

## 1. Regla Mandatoria para Agentes e Inteligencias Artificiales

1. **Prohibición de Diseño desde Cero en Flutter**:
   - Queda terminantemente prohibido diseñar interfaces visuales importantes directamente en código Flutter si primero no han sido diseñadas o prototipadas en Google Stitch.
   - Aplica a: Login, Dashboards, Menús de navegación, Gestión de usuarios, Roles y permisos, Bitácoras, Formularios, Tablas de datos, Modales y futuros módulos de RRHH, Contabilidad, etc.

2. **Verificación Previa**:
   - Antes de iniciar la implementación de una pantalla o vista en Flutter, el agente **DEBE verificar** si existe el diseño correspondiente en Google Stitch (vía MCP o solicitud al usuario).
   - Si no existe un diseño formal:
     - El agente debe proponer/generar el prototipo en Google Stitch mediante las herramientas del MCP (`@_davideast/stitch-mcp` o Stitch CLI) antes de escribir el código definitivo en Flutter.

3. **Responsabilidad de Flutter**:
   - Flutter **NO** es el lugar para inventar el diseño visual.
   - Flutter es responsable de:
     - Implementar con estricta fidelidad el diseño aprobado.
     - Conectar lógica con Serverpod RPC (`Client client` sin mocks).
     - Manejar el estado reactivo, formularios y validaciones.
     - Aplicar los temas corporativos (`AppTheme`).
     - Garantizar accesibilidad y diseño responsive.

4. **Consistencia Visual y Design System**:
   - Reutilizar tokens de color, tipografía, espaciado e iconografía definidos en Stitch.
   - No duplicar patrones visuales si ya existe un componente aprobado.

---

## 2. Flujo Oficial de Desarrollo Frontend

```text
REQUISITO DE NEGOCIO
         ↓
DISEÑO EN GOOGLE STITCH (Vía MCP / IA)
         ↓
REVISIÓN Y APROBACIÓN POR EL PRODUCT OWNER
         ↓
IMPLEMENTACIÓN EN FLUTTER (Tokens -> Theme -> Widgets -> Vistas)
         ↓
CONEXIÓN CON SERVERPOD RPC (No-Mock)
         ↓
PRUEBAS AUTOMATIZADAS (0 errores en analyze/test/format)
         ↓
CODE REVIEW & MERGE
```

---

## 3. Fidelidad visual

Ver `.agents/rules/stitch_fidelity.md` para las reglas de fidelidad pixel-perfect.
