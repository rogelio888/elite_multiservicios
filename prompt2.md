# CONFIGURACIÓN OBLIGATORIA — GOOGLE STITCH + ANTIGRAVITY

## 1. CONTEXTO DEL PROYECTO

Estamos desarrollando un sistema empresarial integral utilizando:

- Frontend: Flutter + Dart
- Diseño/UI inicial: Google Stitch
- Backend: Serverpod + Dart
- Base de datos: PostgreSQL mediante Supabase
- IDE asistido por IA: Antigravity
- Control de versiones: Git + GitHub

Google Stitch será nuestra herramienta oficial para el diseño y generación inicial de interfaces del sistema.

---

# 2. REGLA FUNDAMENTAL DE DISEÑO

A partir de este momento:

> TODO diseño de interfaz que se vaya a implementar en el sistema DEBE partir de Google Stitch.

No diseñes interfaces importantes directamente desde cero en Flutter si primero pueden ser diseñadas/prototipadas mediante Stitch.

Esto incluye:

- Login
- Dashboard
- Menús
- Navegación
- Gestión de usuarios
- Roles
- Permisos
- Bitácoras
- Sesiones
- Formularios
- Tablas
- Modales
- Configuraciones
- Paneles administrativos
- Componentes reutilizables
- Futuras interfaces de RRHH
- Futuras interfaces de Contabilidad
- Cualquier otro módulo futuro

---

# 3. INTEGRACIÓN MCP CON GOOGLE STITCH

Configura Antigravity para utilizar Google Stitch mediante MCP.

La configuración debe quedar preparada de forma reproducible para el equipo.

IMPORTANTE:

NO guardar dentro del repositorio:

- API keys personales
- Access tokens
- Refresh tokens
- Credenciales personales
- Secretos
- Tokens de sesión

La configuración compartida del MCP sí debe formar parte del proyecto cuando sea compatible con la configuración de Antigravity.

Las credenciales deberán resolverse mediante variables de entorno, configuración local o el mecanismo seguro recomendado oficialmente por Stitch/Antigravity.

---

# 4. OBJETIVO DE LA CONFIGURACIÓN

Queremos que el flujo para un nuevo colaborador sea:

````text
git clone
     ↓
abrir proyecto en Antigravity
     ↓
instalar dependencias
     ↓
configurar credenciales locales
     ↓
MCP de Stitch disponible
     ↓
puede trabajar con los diseños del proyecto

NO queremos que cada desarrollador tenga que crear manualmente desde cero una configuración diferente del MCP.

5. CONFIGURACIÓN REPRODUCIBLE

Investiga primero la documentación oficial actual de:

Google Stitch
MCP de Google Stitch
Antigravity
configuración de MCP en Antigravity

Utiliza únicamente la configuración compatible con las versiones actuales.

NO inventes nombres de servidores MCP, comandos, endpoints ni parámetros.

Si existe una configuración oficial recomendada para Antigravity, utilizarla.

6. CONFIGURACIÓN DENTRO DEL REPOSITORIO

Organiza la configuración de forma que pueda versionarse sin exponer secretos.

Por ejemplo, si la arquitectura actual de Antigravity/Stitch lo permite:

.github/
docs/
config/

o el directorio oficial correspondiente.

La configuración debe permitir que todos los colaboradores tengan la misma definición del servidor MCP.

Documentar claramente:

¿Qué es Stitch?
¿Qué MCP se utiliza?
¿Cómo se conecta?
¿Qué debe configurar cada colaborador?
¿Dónde colocar las credenciales?
¿Cómo comprobar que MCP funciona?
7. VARIABLES DE ENTORNO

Si Stitch requiere autenticación mediante credenciales:

Crear documentación y archivos de ejemplo, por ejemplo:

.env.example

NUNCA colocar credenciales reales.

Ejemplo conceptual:

STITCH_API_KEY=

Utilizar los nombres reales requeridos por la integración oficial.

El archivo real:

.env

debe estar incluido en .gitignore cuando corresponda.

8. DOCUMENTACIÓN PARA COLABORADORES

Crear:

docs/development/stitch-mcp.md

Debe explicar paso a paso:

Requisitos

Qué necesita instalar el colaborador.

Configuración

Cómo habilitar el MCP.

Autenticación

Cómo configurar sus credenciales personales de forma segura.

Verificación

Cómo comprobar que Antigravity puede comunicarse correctamente con Stitch.

Uso

Cómo solicitar a la IA que:

Cree un diseño en Stitch.
Consulte un diseño existente.
Modifique un diseño.
Utilice un diseño existente como referencia.
Implemente posteriormente ese diseño en Flutter.
9. FLUJO OFICIAL DE DISEÑO

El flujo del equipo será:

REQUISITO
    ↓
DISEÑO EN GOOGLE STITCH
    ↓
REVISIÓN DEL DISEÑO
    ↓
APROBACIÓN
    ↓
IMPLEMENTACIÓN EN FLUTTER
    ↓
PRUEBAS
    ↓
CODE REVIEW

Flutter NO debe convertirse en el lugar donde se inventa el diseño visual final.

Flutter será responsable de:

Implementar.
Dar funcionalidad.
Conectar APIs.
Manejar estados.
Validar formularios.
Implementar navegación.
Integrar permisos.
Conectar con Serverpod.
10. REGLA PARA LAS IAs

Cualquier IA que trabaje en este repositorio debe respetar esta regla:

Antes de implementar una nueva interfaz visual significativa, debe comprobar si existe un diseño correspondiente en Google Stitch.

Si no existe:

Debe utilizar Stitch para crear/proponer el diseño antes de implementar la interfaz definitiva en Flutter.

NO debe inventar arbitrariamente un diseño diferente al sistema.

11. CONSISTENCIA VISUAL

Todos los diseños deberán mantener un lenguaje visual consistente.

Antes de crear una nueva pantalla, revisar:

Diseños existentes en Stitch.
Componentes existentes.
Tipografía.
Espaciado.
Navegación.
Jerarquía visual.
Formularios.
Tablas.
Botones.
Estados.
Mensajes.
Colores.
Iconografía.

No crear cada pantalla como si perteneciera a un sistema diferente.

12. DESIGN SYSTEM

Preparar el proyecto para que los diseños de Stitch puedan convertirse progresivamente en un Design System de Flutter.

Conceptualmente:

Google Stitch
     ↓
Design System
     ↓
Flutter Theme
     ↓
Componentes reutilizables
     ↓
Pantallas

Evitar valores visuales arbitrarios repetidos directamente dentro de widgets.

Preparar componentes reutilizables cuando exista suficiente evidencia de que son patrones compartidos.

13. NO DUPLICAR DISEÑOS

Si Stitch ya contiene un componente o patrón aprobado:

NO crear una segunda versión visual diferente en Flutter.

Reutilizar el patrón aprobado.

14. VERIFICACIÓN ANTES DE TERMINAR

Antes de declarar configurado el MCP:

[ ] Antigravity detecta la configuración
[ ] Stitch MCP está disponible
[ ] La autenticación funciona
[ ] No existen secretos en Git
[ ] .gitignore está correctamente configurado
[ ] Un colaborador puede reproducir la configuración
[ ] La documentación está completa
[ ] Se puede comprobar la conexión

Si alguna comprobación falla:

NO declarar:

"Configuración terminada."

Informar:

VERIFICADO:
...

NO VERIFICADO:
...

ERROR:
...

SOLUCIÓN:
...
15. REGLA DE SEGURIDAD

Nunca:

Comitear API keys.
Comitear tokens.
Copiar credenciales de otro desarrollador.
Compartir credenciales personales.
Hardcodear secretos.
Subir archivos .env con información sensible.

Cada colaborador debe utilizar sus propias credenciales cuando el servicio lo requiera.

16. RESULTADO FINAL ESPERADO

Al finalizar esta tarea, el repositorio debe tener:

sistema-empresarial/
│
├── .github/
│
├── config/
│
├── docs/
│   └── development/
│       └── stitch-mcp.md
│
├── .env.example
├── .gitignore
├── README.md
│
├── server/
├── client/
└── flutter/

La estructura exacta debe respetar la estructura oficial generada por Serverpod y no debe modificarse arbitrariamente.

17. INFORME FINAL

Cuando termines, informa:

MCP
Configuración utilizada.
Ubicación de la configuración.
Método de autenticación.
Cómo la obtiene un nuevo colaborador.
Stitch
Cómo se utilizará dentro del proyecto.
Flujo de diseño → Flutter.
Seguridad
Qué secretos existen.
Dónde deben configurarse.
Qué archivos fueron agregados al .gitignore.
Validación

Indicar exactamente qué pruebas realizaste para confirmar que la integración funciona.

NO afirmes que la conexión funciona si no fue comprobada realmente.


### Una precisión que te recomiendo mantener

No intentaría hacer que **la credencial de Stitch esté "dentro del código"**. Lo que quieres que esté dentro del repositorio es la **configuración del MCP y las instrucciones**, para que todos tengan el mismo entorno. La autenticación debe ser individual.

Así, el colaborador hace:

```text
CLONA REPO
    ↓
ABRE ANTIGRAVITY
    ↓
MCP YA ESTÁ CONFIGURADO
    ↓
AUTENTICA SU CUENTA
    ↓
STITCH DISPONIBLE
````
