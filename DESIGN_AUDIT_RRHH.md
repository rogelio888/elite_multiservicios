# AUDITORÍA DE DISEÑO FUNCIONAL Y ARQUITECTURA DE INFORMACIÓN
## Módulo de Recursos Humanos (RRHH) — Elite Multiservicios

**Documento Fuente de Verdad:** `Relacion_e_Integracion_de_Modulos_Sistema_Multiservicios.pdf`  
**Referencia Técnica Previa:** `AUDITORIA_Y_PLAN_RRHH.md`  
**Tipo de Auditoría:** Diseño funcional, fronteras de dominio, experiencia de usuario (UX) y alineación con la especificación del negocio.  
**Fecha:** 24 de Septiembre de 2026  
**Auditor:** Technical Senior Auditor & Antigravity IDE  

---

## 1. Introducción y Marco de Referencia

El módulo de Recursos Humanos de **Elite Multiservicios** en el frontend fue concebido e implementado de forma previa a la formalización del backend y con anterioridad a la delimitación definitiva de responsabilidades intermodulares.

El documento corporativo oficial **"Relación e Integración de los Módulos"** establece un principio arquitectónico innegociable (Págs. 2 y 7):
> *"La integración no debe consistir simplemente en que todos los módulos puedan consultar todas las tablas. Cada módulo debe tener una responsabilidad clara, ser propietario de determinados datos y exponer la información que los demás necesitan sin permitir que otros la modifiquen directamente."*

Esta auditoría evalúa **pantalla por pantalla y flujo por flujo** si la interfaz actual de RRHH respeta su rol como **módulo maestro del ciclo de vida del colaborador**, identifica dónde se invaden dominios ajenos (Operaciones, CRM, Contabilidad) y señala los vacíos funcionales críticos donde el PDF exige información que hoy no tiene representación visual en el sistema.

---

## 2. Extracción Exhaustiva de Requisitos del PDF (Fuente de Verdad)

De acuerdo con el documento oficial, las responsabilidades de RRHH se descomponen en cinco dimensiones normativas:

### 2.1 Sección 4.1 — Lo que RRHH debe administrar (Propiedad Exclusiva)
1. **Identificador único del empleado** (código institucional irrepetible).
2. **Datos personales y documentación laboral** (CI, croquis, certificado de antecedentes FELCC, fotos, referencias, ficha médica/SUS).
3. **Cargo y área** (catálogos estructurados de puestos y departamentos).
4. **Tipo de contrato laboral** (Indefinido, plazo fijo, consultoría/servicios, fecha de inicio y fin).
5. **Fecha de ingreso y fecha de baja** (preservación histórica post-salida con motivo y finiquito).
6. **Estado del empleado** (Activo, Suspendido, Baja/Inactivo).
7. **Habilidades y capacidades** (certificaciones, competencias técnicas, aptitudes operativas).
8. **Servicios que puede realizar** (jardinería, limpieza especializada, seguridad física, etc.).
9. **Disponibilidad y horarios** (catálogo de jornadas, turnos base convenidos y estado de disponibilidad en tiempo real).
10. **Permisos y vacaciones** (licencias médicas CNS, permisos particulares, cómputo legal de vacaciones por antigüedad).
11. **Salario base o modalidad de pago** (haber mensual, jornal diario, pago por hora o proyecto).
12. **Información laboral necesaria para nómina** (novedades, bonos autorizados, descuentos administrativos).

### 2.2 Sección 4.2 — Lo que RRHH debe ENTREGAR a Operaciones / APK
* **Empleado:** Identificador y nombre para poder ser seleccionado en turnos y servicios.
* **Estado laboral:** Garantía de que solo personal `ACTIVO` puede ser programado.
* **Área / Cargo:** Filtro para asignar el perfil adecuado al requerimiento del cliente.
* **Habilidades:** Verificación de compatibilidad con el servicio contratado.
* **Disponibilidad:** Indicador en tiempo real (`DISPONIBLE`, `ASIGNADO`, `DE_VACACIONES`, `CON_PERMISO`, `SUSPENDIDO`) para evitar conflictos de programación.
* **Horario Teórico:** Jornada laboral planificada según contrato para contrastar contra la jornada real.
* **Permisos / Vacaciones:** Bloqueo preventivo de asignaciones durante ausencias autorizadas.

### 2.3 Sección 4.3 — Lo que RRHH debe RECIBIR de Operaciones / APK (Realidad de Campo)
RRHH es el receptor de la consolidación de lo que efectivamente ocurrió en campo:
* **Empleado asignado:** Registro del colaborador que cumplió la labor.
* **Cliente y servicio:** Dónde y en qué cuenta prestó el servicio.
* **Ubicación:** Sede o puesto asignado.
* **Fecha de trabajo:** Día de ejecución.
* **Hora de entrada programada y real:** Detección de puntualidad o atrasos.
* **Hora de salida programada y real:** Cumplimiento de jornada.
* **Asistencia o inasistencia:** Presencia confirmada o falta injustificada.
* **Retrasos:** Minutos de retraso acumulados para régimen disciplinario.
* **Horas trabajadas:** Cómputo de horas ordinarias y extras de campo.
* **Incidencias operativas:** Reportes de supervisión de campo vinculados al trabajador (quejas, abandonos de puesto, felicitaciones de clientes).

### 2.4 Sección 6.1 — Lo que RRHH debe ENTREGAR a Contabilidad
RRHH proporciona la base contractual y las novedades laborales para que Contabilidad liquide los pagos:
* **Empleado:** Identificador de la persona acreedora del pago.
* **Estado laboral:** Verificación de vigencia de la relación contractual.
* **Tipo de contrato:** Régimen laboral aplicable.
* **Salario / Tarifa base:** Sueldo pactado en contrato.
* **Modalidad de pago:** Mensual, jornal, por horas o por proyecto.
* **Bonificaciones / Descuentos autorizados:** Ajustes administrativos decididos por RRHH (anticipos autorizados, reposición de credencial, bonos de asistencia).
* **Fecha de ingreso / baja:** Días efectivos trabajados en el periodo para cálculo proporcional o finiquito.

### 2.5 Sección 7 y 8 — Matriz de Propiedad de Datos y Fronteras Innegociables
| Dominio de Información | Módulo Propietario Exclusivo (PDF) | Rol de RRHH |
|---|:---:|---|
| **Empleados y Datos Personales** | **RRHH** | **Dueño absoluto (Escritura y lectura)** |
| **Contrato Laboral, Cargo y Área** | **RRHH** | **Dueño absoluto (Escritura y lectura)** |
| **Permisos, Vacaciones y Bajas** | **RRHH** | **Dueño absoluto (Escritura y lectura)** |
| **Salario Base y Modalidad Laboral** | **RRHH** | **Dueño absoluto (Escritura y lectura)** |
| **Disponibilidad Laboral del Personal** | **RRHH** | **Dueño absoluto (Publica a Operaciones)** |
| **Asignaciones Operativas a Clientes** | **Operaciones / APK** | **Consumidor (Solo lectura informativa)** |
| **Asistencia, Entradas, Salidas y Horas**| **Operaciones / APK** | **Consumidor (Recibe para consolidación)** |
| **Incidencias de Campo** | **Operaciones / APK** | **Consumidor (Recibe para evaluar sanciones)** |
| **Nómina, Liquidación y Dispersión** | **Contabilidad** | **Proveedor (Entrega salario y novedades)** |
| **Clientes, Contratos y Sedes Comerciales**| **CRM** | **Consumidor (Referencia débil sin crear clientes)** |

---

## 3. Inventario de Pantallas Actuales del Frontend RRHH

Actualmente existen **11 archivos de vista** en `elite_multiservicios_flutter/lib/features/rrhh/presentation/views/`, divididos en dos categorías:

### 3.1 Vistas Enlazadas al Menú Principal (Shell)
Estas 6 vistas son accesibles desde el acordeón lateral de navegación en [security_shell_screen.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/security/presentation/security_shell_screen.dart#L676-L694):

1. **Dashboard de RRHH (Índice 9):**  
   *Archivo:* [rrhh_dashboard_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_dashboard_view.dart) (1,558 líneas)  
   *Contenido:* Métricas de dotación (activos/inactivos, oficina/campo), porcentaje de expedientes completos, contratos por vencer y feed de novedades recientes.
2. **Directorio de Personal (Índice 10):**  
   *Archivo:* [rrhh_personal_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_personal_view.dart) (1,638 líneas)  
   *Contenido:* 4 pestañas: *Todos los Colaboradores*, *Activos*, *Inactivos/Bajas* y *Postulantes / Reclutamiento*. Acceso a modales de contratación y ficha de empleado.
3. **Estructura Organizacional (Índice 11):**  
   *Archivo:* [rrhh_organization_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_organization_view.dart) (1,657 líneas)  
   *Contenido:* 3 pestañas: *Áreas Departamentales*, *Cargos / Puestos* y *Especialidades Operativas*.
4. **Asignaciones & Horarios (Índice 12):**  
   *Archivo:* [rrhh_assignments_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_assignments_view.dart) (3,704 líneas)  
   *Contenido:* 3 pestañas: *Asignaciones de Personal a Clientes*, *Puestos por Empresa/Cliente* y *Catálogo de Turnos y Horarios*. Incluye diálogos para asignar empleados a sedes y rotarlos.
5. **Gestión Laboral & Novedades (Índice 13):**  
   *Archivo:* [rrhh_labor_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_labor_view.dart) (1,501 líneas)  
   *Contenido:* 5 pestañas: *Permisos y Licencias*, *Vacaciones*, *Incidencias / Memorándums*, *Movimientos Salariales* y *Bajas Laborales*.
6. **Reportes & Planillas OVT (Índice 14):**  
   *Archivo:* [rrhh_reports_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_reports_view.dart) (2,108 líneas)  
   *Contenido:* Pestaña de Planilla por Empresa (cálculo de bonos, AFP, descuentos y líquido pagable), exportador XML/Excel a 19 columnas, e historial de incidencias/bajas.

### 3.2 Vistas Huérfanas (Código Muerto sin Acceso en Menú)
Estas 5 vistas existen en el repositorio pero **no están enlazadas a ninguna ruta ni menú**:

7. **Directorio de Empleados Obsoleto:**  
   *Archivo:* [rrhh_employees_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_employees_view.dart) (2,423 líneas) — *Duplicado viejo de `rrhh_personal_view.dart`.*
8. **Gestor de Contratos Desvinculado:**  
   *Archivo:* [rrhh_contracts_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_contracts_view.dart) (971 líneas) — *Vista abandonada previa a la unificación de fichas.*
9. **Bitácora de Auditoría Desconectada:**  
   *Archivo:* [rrhh_audit_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_audit_view.dart) (1,029 líneas) — *Historial local no conectado al sistema RBAC.*
10. **Gestión de Ausencias Aislada:**  
    *Archivo:* [rrhh_absences_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_absences_view.dart) (881 líneas) — *Reemplazada por `rrhh_labor_view.dart`.*
11. **Historial Laboral Aislado:**  
    *Archivo:* [rrhh_history_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_history_view.dart) (788 líneas) — *Reemplazada por las pestañas de movimientos en `rrhh_labor_view.dart`.*

---

## 4. Tabla Comparativa de Cobertura Funcional y Fronteras

Evaluación de cada requisito estipulado en las Secciones 4.1, 4.2, 4.3, 6.1 y 7 del PDF frente a la implementación visual actual:

| Requisito del PDF | Sección PDF | Pantalla Actual que lo Cubre | Estado | Acción Requerida |
|---|:---:|---|:---:|---|
| **Identificador único de empleado** | 4.1 | `rrhh_personal_view` (Ficha) | ✅ Cubre bien | Mantener código `EMP-xxx`. |
| **Datos personales y expediente físico** | 4.1 | `rrhh_personal_view` + `rrhh_employee_modal` | ✅ Cubre bien | Checklist de 6 documentos físicos bolivianos bien diseñado. |
| **Cargo y área departamental** | 4.1 | `rrhh_organization_view` | ✅ Cubre bien | Catálogo jerárquico bien estructurado. |
| **Tipo de contrato y fechas vigencia** | 4.1 | `rrhh_personal_view` (Tab 1 y 2) | ✅ Cubre bien | Indefinido, plazo fijo, servicios. |
| **Fecha de ingreso y fecha de baja** | 4.1 | `rrhh_personal_view` + `rrhh_labor_view` (Tab 5) | ✅ Cubre bien | Preservación de bajas sin borrado físico. |
| **Estado laboral (Activo, Baja, etc.)** | 4.1 | `rrhh_personal_view` | ✅ Cubre bien | Pestañas claras de Activos vs Inactivos. |
| **Habilidades y capacidades** | 4.1 | `rrhh_hire_dialog` | 🟡 Cubre parcial | Son etiquetas de texto libre; falta matriz formal de competencias. |
| **Servicios que puede realizar** | 4.1 | `rrhh_organization_view` (Especialidades) | 🟡 Cubre parcial | El catálogo existe pero no está vinculado de forma normalizada al empleado. |
| **Catálogo de horarios corporativos** | 4.1 | `rrhh_assignments_view` (Tab 3) | 🟡 Cubre parcial | Bien diseñado, pero metido dentro de una vista que viola fronteras. Mover a vista propia. |
| **Disponibilidad operativa en tiempo real** | 4.1 & 4.2 | `rrhh_personal_view` (Chips) | 🟡 Cubre parcial | Visualmente existe (`DISPONIBLE`, `ASIGNADO`), pero no se actualiza según asistencia real. |
| **Permisos y licencias (médicas, etc.)** | 4.1 | `rrhh_labor_view` (Tab 1) | ✅ Cubre bien | Flujo con soporte de certificado CNS y justificación. |
| **Vacaciones (cómputo por antigüedad)** | 4.1 | `rrhh_labor_view` (Tab 2) | ✅ Cubre bien | Escala de 15, 20 y 30 días hábiles de la Ley boliviana. |
| **Régimen disciplinario y memorándums** | 4.1 | `rrhh_labor_view` (Tab 3) | ✅ Cubre bien | Novedades, llamados de atención y felicitaciones. |
| **Salario base y modalidad de pago** | 4.1 & 6.1 | `rrhh_personal_view` + `rrhh_hire_dialog` | ✅ Cubre bien | Sueldo pactado, jornal, mensual. |
| **Ajustes y bonos para Contabilidad** | 6.1 | `rrhh_labor_view` (Tab 4: Movimientos) | 🟡 Cubre parcial | Muestra movimientos generales, pero falta módulo claro de "Novedades para Nómina". |
| **Creación de Asignaciones Operativas** | 7 & 9 | `rrhh_assignments_view` (Tab 1 y 2) | 🚫 **Sobra (Viola frontera)** | **VIOLACIÓN CRÍTICA:** Operaciones es el dueño de crear asignaciones a clientes. |
| **Rotación de Personal a Sedes Clientes**| 7 & 9 | `rrhh_assignments_view` (Diálogo Rotación) | 🚫 **Sobra (Viola frontera)** | **VIOLACIÓN CRÍTICA:** RRHH rota al personal en cuentas de clientes, usurpando la función de Operaciones. |
| **Catálogo de Clientes y Sedes en RRHH** | 7 | `rrhh_assignments_view` (Tab 2) | 🚫 **Sobra (Viola frontera)** | **VIOLACIÓN:** RRHH muestra sedes y servicios de clientes del CRM. |
| **Liquidación y Cálculo de Planilla OVT**| 7 | `rrhh_reports_view` (Tab 1: Planilla) | 🚫 **Sobra (Viola frontera)** | **VIOLACIÓN:** Contabilidad es dueña de Nómina y Pagos. RRHH solo debe entregar salario base y novedades. |
| **Consolidación de Asistencia de Campo** | 4.3 | *Ninguna pantalla* | ❌ **No cubre** | **VACÍO CRÍTICO:** RRHH no tiene vista para ver entradas, salidas y atrasos reportados por la APK. |
| **Horas Efectivas y Retrasos de Campo** | 4.3 | *Ninguna pantalla* | ❌ **No cubre** | **VACÍO CRÍTICO:** RRHH no puede ver las horas reales laboradas para aplicar sanciones o pasar a Contabilidad. |
| **Incidencias Operativas de Campo** | 4.3 | *Ninguna pantalla* | ❌ **No cubre** | **VACÍO CRÍTICO:** Si el supervisor de campo reporta abandono de puesto en la APK, RRHH no tiene dónde recibirlo. |

---

## 5. Diagnóstico Detallado de Violaciones de Fronteras y Vacíos Funcionales

### 5.1 Pantallas que Violan Fronteras del PDF

#### 🚫 Violación 1: RRHH Asignando y Rotando Personal en Clientes (`rrhh_assignments_view.dart`)
* **Evidencia en el PDF:**
  * **Página 7 (Propiedad de Datos):** `Asignaciones operativas — Módulo propietario: Operaciones / APK`.
  * **Página 8 (Paso 3 del Flujo Real):** *"Paso 3 — Asignación: Operaciones crea la asignación: empleado + cliente + contrato + servicio + ubicación + fecha + horario. La asignación llega a la APK del trabajador."*
  * **Página 10 (Modelo Conceptual):** *"RRHH responde: ¿Quiénes son nuestros empleados y quién está disponible? Operaciones responde: ¿Quién fue asignado, dónde debía trabajar y qué ocurrió realmente?"*
* **Qué hace el frontend actual:**  
  La vista [rrhh_assignments_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_assignments_view.dart) (un monstruo de 3,704 líneas) implementa un sistema completo de asignación de trabajadores a cuentas comerciales (Ventura Mall, Kolping, etc.), selección de sucursales, selección de servicios contratados y diálogo de rotación operativa de campo.
* **Problema de Arquitectura:**  
  RRHH asume la función del **Jefe de Operaciones / Despacho**. Si el encargado de RRHH decide reasignar a un guardia de seguridad a otro edificio desde RRHH, rompe la planificación operativa, genera desajustes en la APK de campo y altera el contrato comercial sin conocimiento de Operaciones.
* **Veredicto:**  
  **RRHH NO DEBE CREAR ASIGNACIONES OPERATIVAS.**  
  RRHH solo debe:
  1. Definir la disponibilidad laboral del trabajador (`DISPONIBLE`, `DE_VACACIONES`, etc.).
  2. Publicar sus turnos y horarios base contractuales.
  3. Visualizar (en modo solo lectura y como consulta de historial) en qué servicio se encuentra trabajando el colaborador según lo que Operaciones le haya reportado.

---

#### 🚫 Violación 2: RRHH Liquidando Nómina y Sueldos Netos (`rrhh_reports_view.dart`)
* **Evidencia en el PDF:**
  * **Página 7 (Propiedad de Datos):** `Nómina y pagos — Módulo propietario: Contabilidad`.
  * **Página 6 (Sección 6.1):** *"RRHH proporciona: Empleado, estado laboral, tipo de contrato, salario base, modalidad de pago, bonificaciones/descuentos autorizados y fecha de ingreso/baja. Contabilidad realiza el cálculo financiero."*
* **Qué hace el frontend actual:**  
  En [rrhh_reports_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_reports_view.dart), RRHH calcula planillas completas de sueldos con 19 columnas ministeriales, computa descuentos de ley (AFP 12.71%, IVA tributario RC-IVA), aportes patronales, provisiones de aguinaldo y emite la orden de pago.
* **Problema de Arquitectura:**  
  RRHH está duplicando y canibalizando el **Módulo de Contabilidad y Finanzas**. Si RRHH calcula el líquido pagable por su cuenta, se generan discrepancias con el libro diario contable, conciliaciones bancarias y pagos impositivos del SIN.
* **Veredicto:**  
  RRHH no liquida pagos bancarios. En RRHH debe existir un **"Consolidado de Novedades Laborales para Nómina"** (días trabajados validados, faltas reportadas, horas extras, anticipos autorizados y salario base contractual) para ser transferido formalmente al módulo de Contabilidad.

---

#### 🚫 Violación 3: Visualización y Manipulación de Clientes del CRM en RRHH
* **Evidencia en el PDF:**
  * **Página 7:** `Clientes, contratos comerciales y servicios contratados — Módulo propietario: CRM`.
  * **Página 10:** `No duplicar entidades completas; guardar solo identificadores estables`.
* **Qué hace el frontend actual:**  
  La pestaña 2 de `rrhh_assignments_view.dart` renderiza una lista de clientes comerciales con sus servicios y sedes, emulando una vista de CRM.
* **Veredicto:**  
  Esa pestaña sobra por completo en RRHH. RRHH solo necesita saber el nombre de la sede o cliente asignado en la ficha del empleado como un dato informativo consumido desde Operaciones.

---

### 5.2 Requisitos del PDF sin Ninguna Pantalla Asignada (Vacíos Críticos)

#### ❌ Vacío 1: Monitoreo de Asistencia y Telemetría de Campo (Sección 4.3)
* **Requisito del PDF:**  
  RRHH debe recibir de Operaciones: entradas y salidas programadas vs reales, inasistencias, minutos de retraso y horas efectivamente trabajadas.
* **Estado Actual:**  
  **INEXISTENTE.** En ninguna de las 11 pantallas actuales la encargada de RRHH puede ver si Juan Pérez marcó a las 08:06 (6 min de retraso) o si tuvo una falta injustificada hoy.
* **Impacto Operativo:**  
  RRHH no puede justificar sanciones disciplinarias (memorándums) ni puede validar si descuenta días en la planilla porque no tiene la pantalla para consultar la asistencia consolidada que envía la APK.

#### ❌ Vacío 2: Matriz de Habilidades y Competencias Laborales (Sección 4.1 y 4.2)
* **Requisito del PDF:**  
  RRHH es responsable de administrar *"Habilidades y capacidades"* y *"Servicios que puede realizar"* para que Operaciones verifique la compatibilidad del trabajador antes de enviarlo a un servicio (Pág. 4.2).
* **Estado Actual:**  
  **INSUFICIENTE.** Las habilidades son una lista plana de textos (`['Puntual', 'Proactivo']`). No existe una vista o panel donde RRHH certifique que un empleado está homologado para *Limpieza Hospitalaria*, *Manejo de Maquinaria Industrial* o *Portación de Credencial de Seguridad privada*.

#### ❌ Vacío 3: Consolidado de Novedades Administrativas para Contabilidad (Sección 6.1)
* **Requisito del PDF:**  
  RRHH debe generar el reporte estructurado de novedades: salario base oficial, tipo de contrato, días trabajados en el mes, bonos aprobados y descuentos autorizados para que Contabilidad proceda con la dispersión económica.
* **Estado Actual:**  
  En lugar de una pantalla de entrega de novedades, se intentó hacer una pantalla completa de liquidación contable. Falta el panel formal de corte administrativo mensual.

---

## 6. Plan de Reestructuración de Pantallas (Las 3 Listas)

Con base en la auditoría de diseño frente al PDF, se dictaminan las siguientes acciones concretas sobre las vistas del frontend:

### A) Pantallas a ELIMINAR (6 Vistas — 9,796 Líneas de Deuda Técnica)

| # | Archivo | Líneas | Motivo de Eliminación |
|:---:|---|:---:|---|
| 1 | [rrhh_employees_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_employees_view.dart) | 2,423 | **Huérfana.** Vista vieja y monolítica. Ya fue reemplazada por `rrhh_personal_view.dart`. |
| 2 | [rrhh_contracts_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_contracts_view.dart) | 971 | **Huérfana.** Vista aislada de contratos; sus funciones ya están en la ficha del empleado. |
| 3 | [rrhh_audit_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_audit_view.dart) | 1,029 | **Huérfana.** Código muerto desconectado del backend y del sistema central de auditoría. |
| 4 | [rrhh_absences_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_absences_view.dart) | 881 | **Huérfana.** Absorbida por las pestañas de permisos y vacaciones de `rrhh_labor_view.dart`. |
| 5 | [rrhh_history_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_history_view.dart) | 788 | **Huérfana.** Absorbida por la bitácora de movimientos laborales de `rrhh_labor_view.dart`. |
| 6 | [rrhh_assignments_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_assignments_view.dart) | 3,704 | **Viola Frontera.** RRHH no asigna ni rota personal en clientes (es de Operaciones). Debe eliminarse y reemplazarse por una vista limpia y acotada solo a *Turnos y Horarios Base*. |

> **Impacto del saneamiento:** Al eliminar estas 6 vistas se depuran **9,796 líneas de código confuso y desalineado**, reduciendo el módulo a la mitad de su peso sin perder ninguna funcionalidad legítima de RRHH.

---

### B) Pantallas a REDISEÑAR (Alinear con el PDF)

#### 1. `rrhh_personal_view.dart` (Directorio de Personal & Postulantes)
* **Diagnóstico actual:** Funciona muy bien en estética y separación de pestañas (Todos, Activos, Inactivos, Postulantes).
* **Ajustes de alineación con el PDF:**
  * Retirar la selección de asignación operativa en el diálogo de contratación ([rrhh_hire_dialog.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/widgets/rrhh_hire_dialog.dart)). Contratar a un empleado en RRHH debe asignarle su **área interna, cargo y horario contractual base**, dejándolo en disponibilidad `DISPONIBLE`. No debe enviarlo directamente a un cliente de campo desde RRHH; eso lo hace el despachador en Operaciones.
  * Incorporar en la ficha del empleado el selector estructurado de **Habilidades y Certificaciones Homologadas** (PDF Pág. 4.1).

#### 2. `rrhh_labor_view.dart` (Gestión Laboral, Permisos y Disciplina)
* **Diagnóstico actual:** Muy completa en vacaciones por ley, permisos y régimen disciplinario.
* **Ajustes de alineación con el PDF:**
  * En la pestaña de Incidencias, permitir filtrar entre **Incidencias Administrativas** (memorándums internos de RRHH) e **Incidencias Operativas reportadas desde la APK** (quejas de clientes, faltas en servicio reportadas por supervisores de campo).

#### 3. `rrhh_dashboard_view.dart` (Dashboard Ejecutivo)
* **Diagnóstico actual:** Excelente presentación ejecutiva y KPIs visuales.
* **Ajustes de alineación con el PDF:**
  * Eliminar métricas que dependen de la creación de asignaciones en RRHH.
  * Enfocar el dashboard en las 3 preguntas clave que el PDF exige a RRHH (Pág. 10):
    1. ¿Quiénes son nuestros empleados activos? (Dotación real oficina vs campo).
    2. ¿Cuál es su situación laboral y contractual? (Contratos por vencer, expedientes completos vs pendientes).
    3. ¿Quién está disponible hoy para ser programado por Operaciones? (Tasa de disponibilidad, personal con permiso/baja médica).

#### 4. `rrhh_reports_view.dart` → Transformar en: *Consolidado para Nómina & Analítica Laboral*
* **Diagnóstico actual:** Pretende ser el liquidador final de nómina de la empresa (función de Contabilidad).
* **Ajustes de alineación con el PDF:**
  * Renombrar y enfocar la vista como **"Novedades y Base para Nómina (Entrega a Contabilidad)"**.
  * Mostrar el salario base contractual, días trabajados, horas computadas, bonos y descuentos administrativos autorizados.
  * Mantener la exportación a Excel / XML como herramienta de auditoría interna de RRHH (Planilla de Control OVT), pero dejando explícito que el pago bancario y contable se procesa en el módulo de Contabilidad.

---

### C) Pantallas a CREAR DESDE CERO (Vacíos del PDF)

#### 1. `rrhh_attendance_view.dart` — *Consolidación de Asistencia & Horas Trabajadas (Sección 4.3)*
* **Por qué es obligatoria:**  
  Es la pantalla que materializa el flujo `Operaciones / APK → RRHH`. Sin ella, RRHH está ciego respecto a lo que ocurre en campo.
* **Alcance de la vista:**
  * Consulta diaria y mensual de marcaciones recibidas de la APK.
  * Tabla con: *Empleado | Sede/Cliente donde trabajó | Entrada programada vs real | Salida programada vs real | Retraso (minutos) | Horas efectivas | Estado (Puntual, Retraso, Falta)*.
  * Filtros por fecha, empleado y área.
  * Botón para emitir automáticamente un memorándum de llamada de atención si un empleado acumula más de 3 retrasos en el mes.

#### 2. `rrhh_schedules_view.dart` — *Catálogo Corporativo de Horarios y Jornadas (Sección 4.1)*
* **Por qué es obligatoria:**  
  Actualmente los turnos están atrapados como una sub-pestaña de la vista monolítica de asignaciones ([rrhh_assignments_view.dart](file:///c:/Users/Hinojosa/Desktop/Proyectos/elite_multiservicios/elite_multiservicios_flutter/lib/features/rrhh/presentation/views/rrhh_assignments_view.dart#L179)).
* **Alcance de la vista:**
  * Catálogo independiente de turnos oficiales de la empresa:
    * *Administrativo Central:* 08:30 – 17:30 (Tolerancia 15 min).
    * *Operativo Mañana (Campo):* 07:00 – 15:00.
    * *Operativo Tarde:* 14:00 – 22:00.
    * *Vigilancia 24/48:* Turno rotativo continuo.
  * Configuración de días laborables, horas semanales de ley (48h varones / 40h mujeres) y banderas de horario nocturno.

---

## 7. Arquitectura de Información y Menú Propuesto para RRHH

Tras eliminar la invasión a Operaciones y cubrir los vacíos del PDF, la navegación de RRHH en el acordeón lateral queda estructurada en **6 vistas especializadas, limpias y 100% alineadas con el PDF**:

```
📂 RECURSOS HUMANOS (RRHH)
│
├── 1. Dashboard Ejecutivo (`rrhh_dashboard_view.dart`)
│      └── KPIs de dotación, contratos, disponibilidad y alertas de expedientes.
│
├── 2. Directorio de Personal & Selección (`rrhh_personal_view.dart`)
│      ├── Pestaña 1: Colaboradores Activos (Ficha, Documentos, Habilidades).
│      ├── Pestaña 2: Inactivos & Bajas (Finiquitos y preservación histórica).
│      └── Pestaña 3: Postulantes & Reclutamiento (Pipeline y contratación formal).
│
├── 3. Estructura Organizacional (`rrhh_organization_view.dart`)
│      ├── Pestaña 1: Áreas Departamentales.
│      ├── Pestaña 2: Cargos y Requisitos de Puesto.
│      └── Pestaña 3: Especialidades Operativas Homologadas.
│
├── 4. Turnos & Horarios Base (`rrhh_schedules_view.dart`) [NUEVA]
│      └── Catálogo de jornadas teóricas que RRHH publica a Operaciones.
│
├── 5. Asistencia & Campo Consolidada (`rrhh_attendance_view.dart`) [NUEVA]
│      └── Vista de solo lectura de entradas, salidas, horas y retrasos recibidos de la APK.
│
├── 6. Gestión Laboral & Novedades (`rrhh_labor_view.dart`)
│      ├── Pestaña 1: Permisos y Licencias Médicas (CNS).
│      ├── Pestaña 2: Vacaciones (Antigüedad según Ley boliviana).
│      ├── Pestaña 3: Régimen Disciplinario (Memorándums y felicitaciones).
│      └── Pestaña 4: Novedades Administrativas para Contabilidad (Corte mensual).
```

### Síntesis del Nuevo Enfoque:
* **RRHH ya no es un "despachador de guardias y personal a clientes"**: Eso le pertenece a **Operaciones**.
* **RRHH ya no es un "liquidador financiero de nómina con pagos bancarios"**: Eso le pertenece a **Contabilidad**.
* **RRHH se consolida como lo que exige el PDF**: El **guardián del talento, del expediente legal, de las normas laborales, de la disponibilidad del personal y del control disciplinario** de Elite Multiservicios.
