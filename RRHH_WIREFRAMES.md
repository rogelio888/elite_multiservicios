# ESPECIFICACIÓN DE WIREFRAMES TEXTUALES Y ARQUITECTURA DE PANTALLAS
## Módulo de Recursos Humanos (RRHH) — Elite Multiservicios

**Documentos de Referencia:**  
* `Relacion_e_Integracion_de_Modulos_Sistema_Multiservicios.pdf` (Fronteras y Reglas de Negocio)  
* `DESIGN_AUDIT_RRHH.md` (Auditoría de Diseño y Saneamiento)  
* `RRHH_DATA_CONTRACT.md` (Contrato de Datos, Tipados y DTOs)  
* `DESIGN.md` (Sistema de Diseño Ejecutivo: Canvas `#0B0F19`, Contenedores `#0F172A`/`#1E293B`, Primario `#2563EB`, Esmeralda `#059669`, Tipografía `Inter` / `JetBrains Mono`)  

---

## 1. Mapa General de Pantallas y Navegación

> **Nota aclaratoria:** Las 14 pantallas siguen existiendo; se reagrupan en 6 entradas de menú para reducir saturación y optimizar la navegación mediante pestañas (tabs) internas.

Estructura reorganizada del menú lateral (`security_shell_screen`):

```text
📁 RECURSOS HUMANOS (Shell Lateral - 6 Entradas)
├── [Índice 9]  01. Dashboard
├── [Índice 10] 02. Personal
│               ├── Tab 1: Directorio de Personal (Pantalla 02)
│               │          └── [Modal/Sub-vista] 03. Expediente del Empleado (Detalle 360°)
│               ├── Tab 2: Reclutamiento & Postulantes (Pantalla 04)
│               └── [Acción / Modal] + Contratar Colaborador (Wizard, Pantalla 05)
├── [Índice 11] 03. Organización y Turnos
│               ├── Tab 1: Áreas (Pantalla 06)
│               ├── Tab 2: Cargos y Especialidades
│               └── Tab 3: Turnos y Horarios Base (Pantalla 07)
├── [Índice 12] 04. Novedades Laborales
│               ├── Tab 1: Permisos y Licencias (Pantalla 08)
│               ├── Tab 2: Control de Vacaciones (Pantalla 09)
│               ├── Tab 3: Incidencias y Disciplina (Pantalla 10)
│               └── Tab 4: Desvinculaciones y Bajas (Pantalla 11)
├── [Índice 13] 05. Asistencia de Campo (Pantalla 13 - Solo Lectura Recepción APK)
└── [Índice 14] 06. Reportes y Auditoría
                ├── Tab 1: Novedades para Nómina (Pantalla 12 - Entrega a Contabilidad)
                └── Tab 2: Bitácora de Movimientos (Pantalla 14 - Trazabilidad Inmutable)
```

---

## 2. Especificación Detallada de Pantallas (Wireframes Textuales)

---

### PANTALLA 01: Dashboard Ejecutivo de RRHH
1. **Propósito:** Telemetría centralizada, KPIs de dotación en tiempo real, alertas de vencimiento contractual y control de disponibilidad para Operaciones.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Dashboard (Índice 9).
3. **Modo de Operación:** `[Solo lectura]` con refresco manual y telemetría reactiva.
4. **Modelos:** `RrhhDashboardMetricsResponse`, `List<RrhhRecentMovementDto>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| DASHBOARD DE RECURSOS HUMANOS                                              [Refrescar] [Descargar] |
| Telemetría consolidada de dotación, disponibilidad operativa y alertas contractuales               |
+----------------------------------------------------------------------------------------------------+
| [KPIS SUPERIORES - TARJETAS EJECUTIVAS 4 COLUMNAS]                                                 |
| +-------------------+  +-------------------+  +-------------------+  +-------------------+         |
| | PERSONAL ACTIVO   |  | DISPONIBILIDAD    |  | EXPEDIENTES COMPL |  | CONTRATOS X VENCER|         |
| | 25 Colaboradores  |  | 92.0% Disponibles |  | 88.9% Al Día      |  | 2 Próximos 30d    |         |
| | (19 Campo / 6 Ofic)| | 2 Permiso, 0 Bajas|  | 24 de 27 Físicos  |  | Alerta Preventiva |         |
| +-------------------+  +-------------------+  +-------------------+  +-------------------+         |
+----------------------------------------------------------------------------------------------------+
| [DISTRIBUCIÓN OPERATIVA (60%)]                     | [FEED DE NOVEDADES RECIENTES (40%)]           |
| Dotación por Especialidad / Área:                  | Novedades de Personal (Últimas 24h):          |
| • Limpieza Integral: ████████████ 11 operarios     | --------------------------------------------- |
| • Seguridad Física:  ████████ 7 guardias           | [10:30] Contratación: EMP-015 Carlos Choque   |
| • Administrativo:    ████ 4 personal               |         Operaciones • Asignado a Jardinería   |
| • Comercial:         ██ 2 ejecutivos               | [08:15] Permiso Aprobado: EMP-007 Paola Vaca  |
|                                                    |         Licencia médica CNS (2 días)          |
| Estado de Disponibilidad publicado a Operaciones:  | [Ayer]  Ajuste Salarial: EMP-001 Juan Pérez   |
| [23 Disponibles] [2 Con Permiso] [0 Suspendidos]   |         Bono puntualidad aprobado (Bs 350)    |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:**
   * **Vacío:** Card informativa *"No existen métricas registradas en la base de datos."*
   * **Cargando:** Skeleton shimmer sobre las 4 tarjetas KPI y el gráfico de barras.
   * **Error:** Banner carmesí con detalle del error + botón `[Reintentar Conexión]`.
   * **Sin permisos:** Pantalla de acceso denegado con código `403 - Requiere rrhh.dashboard.view`.
7. **Validaciones en Cliente:** N/A (Solo lectura).
8. **Roles / Permisos:** `rrhh.dashboard.view` (Gerencia, Jefatura RRHH, Auditoría).
9. **Endpoints:** `rrhhDashboard.getMetrics()`, `rrhhDashboard.getRecentMovements()`.

---

### PANTALLA 02: Directorio / Nómina de Personal
1. **Propósito:** Maestro general de colaboradores activos e inactivos, filtrado por entorno y punto de acceso al expediente.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Personal (Índice 10).
3. **Modo de Operación:** `[Lectura + Acciones específicas: Ver Expediente, Editar Datos, Desvincular]`.
4. **Modelos:** Consume DTO reducido `RrhhEmployeeSummaryDto` para la tabla; modelo completo `RrhhEmployee` solo al abrir detalle.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| DIRECTORIO DE PERSONAL                                                   [+ Contratar Colaborador] |
| Nómina oficial de trabajadores, clasificación laboral y estado de disponibilidad                   |
+----------------------------------------------------------------------------------------------------+
| [PESTAÑAS]:  [Todos (27)]  |  [Activos (25)]  |  [Inactivos / Bajas (2)]                           |
+----------------------------------------------------------------------------------------------------+
| [FILTROS]:                                                                                         |
| [Buscar por nombre, CI, cargo...]  [Tipo: TODOS/OFICINA/CAMPO]  [Área: TODAS v]  [Disponibilidad v]|
+----------------------------------------------------------------------------------------------------+
| TABLA DE COLABORADORES (DTO Reducido - Sin salarios ni direcciones expuestas)                      |
| CÓDIGO  | FOTO | NOMBRE COMPLETO     | TIPO    | ÁREA / CARGO        | ESPECIALIDAD | DISPONIBILIDAD | EXPED. | ACCIONES   |
|---------+------+---------------------+---------+---------------------+--------------+----------------+--------+------------|
| EMP-001 | [IMG]| Juan Carlos Pérez   | CAMPO   | Operaciones/Líder   | Limpieza     | [ASIGNADO]     |  6/6   | [Ver] [...]|
| EMP-002 | [IMG]| María Elena Gómez   | OFICINA | Administración/Cont | Administrat. | [DISPONIBLE]   |  6/6   | [Ver] [...]|
| EMP-003 | [IMG]| Carlos E. Mamani    | CAMPO   | Operaciones/Guardia | Seguridad    | [CON PERMISO]  |  5/6 ⚠️| [Ver] [...]|
| EMP-004 | [IMG]| Laura Mendoza C.    | OFICINA | RRHH/Encargada      | Psicol. Lab. | [DISPONIBLE]   |  6/6   | [Ver] [...]|
+----------------------------------------------------------------------------------------------------+
| Mostrando 1-10 de 25 empleados activos                                    [< Anterior] [1] [2] [Siguiente >] |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:**
   * **Vacío:** Ilustración de directorio vacío + mensaje *"No se encontraron colaboradores con los filtros seleccionados."* + botón `[Limpiar Filtros]`.
   * **Cargando:** Skeleton animado de 8 filas y 8 columnas con hairline borders.
   * **Error:** Card con mensaje de error de conexión a Serverpod + botón `[Reintentar]`.
   * **Sin permisos:** *"Acceso restringido. Requiere permiso rrhh.personal.view"*.
7. **Validaciones en Cliente:** Búsqueda textual sanitizada (mínimo 2 caracteres para disparar query; debounce de 300ms).
8. **Roles / Permisos:** Lectura: `rrhh.personal.view`; Acciones/Mutación: `rrhh.personal.manage`.
9. **Endpoints:** `rrhhPersonnel.listEmployees(status, employeeType, areaId, search, limit, offset)`.

---

### PANTALLA 03: Expediente del Empleado (Detalle 360°)
1. **Propósito:** Vista integral de 360° del trabajador con datos personales, contractuales, checklist físico, historial y asignación actual reportada por Operaciones.
2. **Ubicación:** Modal expandido o Sub-ruta desde Pantalla 02 (`/rrhh/personal/:id`).
3. **Modo de Operación:** `[Lectura + Acciones específicas: Editar Ficha, Subir Documento, Modificar Disponibilidad, Registrar Desvinculación]`.
4. **Modelos:** `RrhhEmployee` (Completo), `List<RrhhEmployeeDocument>`, `List<RrhhTimelineEvent>`, `RrhhAssignment?` (Solo lectura de Operaciones).
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| EXPEDIENTE DEL COLABORADOR: EMP-001                                             [Editar] [Cerrar X]|
+----------------------------------------------------------------------------------------------------+
| [CABECERA DEL PERFIL]                                                                              |
| [FOTO GRANDE]  JUAN CARLOS PÉREZ MENDOZA                  Estado: [ACTIVO]  Disponib: [ASIGNADO]  |
|                Líder de Cuadrilla • Operaciones & Campo   Antigüedad: 3 años, 4 meses (12/05/2023)  |
|                Email Corporativo: juan.perez@elitemultiservicios.com                               |
+----------------------------------------------------------------------------------------------------+
| [PESTAÑAS DE DETALLE]:                                                                             |
| [1. Datos Personales] | [2. Contrato & Salario] | [3. Documentos Físicos] | [4. Asignación Vigente (Ops)] | [5. Historial] |
+----------------------------------------------------------------------------------------------------+
| CONTENIDO SEGÚN PESTAÑA:                                                                           |
|                                                                                                    |
| • SI PESTAÑA 1 (DATOS): CI: 4455882 SC | Nacimiento: 14/08/1990 (36 años) | Tel: 70012345 (🔒)     |
|   Dirección: Barrio Las Palmas, C/ 4 #12 (🔒) | Ref: María Mendoza (Madre - 78899001 🔒)           |
|                                                                                                    |
| • SI PESTAÑA 2 (CONTRATO): Modalidad: Indefinido | Jornada: 48h Semanales | Pago: Mensual         |
|   Salario Base Pactado: Bs. 4.200,00 (🔒 Visible solo con rrhh.compensation.view)                 |
|                                                                                                    |
| • SI PESTAÑA 3 (DOCUMENTOS FÍSICOS): Checklist de 6 Documentos de Ley (Ficha Verde/Roja)           |
|   [✓] Fotocopia Cédula de Identidad      [✓] Certificado FELCC (Antecedentes Policiales)           |
|   [✓] Aviso Luz / Agua (Domicilio)       [✓] Croquis de Ubicación Domiciliaria                     |
|   [✓] Fotografía 3x4 Fondo Rojo          [✓] Afiliación Seguro Médico SUS                          |
|                                                                                                    |
| • SI PESTAÑA 4 (ASIGNACIÓN VIGENTE - SOLO LECTURA DESDE OPERACIONES):                              |
|   Cuenta Asignada: "Kolping Bolivia" • Sede: "Central Equipetrol" • Servicio: "Limpieza Hospitalaria"|
|   Supervisor en Campo: Ricardo Montaño • Horario: Operativo Mañana (07:00 - 15:00)                 |
|   *Nota: Las asignaciones de campo son administradas por el módulo de Operaciones.*                |
|                                                                                                    |
| • SI PESTAÑA 5 (HISTORIAL): Línea de tiempo cronológica con hitos inmutables.                       |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:**
   * **Cargando:** Skeleton detallado imitando la estructura de la ficha.
   * **Error:** Mensaje *"No se pudo cargar el expediente del colaborador"* + botón de reintento.
   * **Sensible Oculto:** Máscara `••••••` en campos de salario si el usuario no tiene rol salarial.
7. **Validaciones en Cliente:** Edición de teléfono y dirección con formato válido; no permitir guardar nombres vacíos.
8. **Roles / Permisos:** General: `rrhh.personal.view`; Campos Salariales: `rrhh.compensation.view`; Edición: `rrhh.personal.manage`.
9. **Endpoints:** `rrhhPersonnel.getEmployeeById(id)`, `rrhhPersonnel.listDocuments(id)`, `rrhhPersonnel.listTimelineEvents(id)`.

---

### PANTALLA 04: Reclutamiento & Pipeline de Postulantes
1. **Propósito:** Gestión del embudo de candidatos, evaluación curricular, entrevistas y filtro previo a contratación.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Postulantes (Índice 11).
3. **Modo de Operación:** `[Lectura y Escritura: Registrar Postulante, Cambiar Estado, Descartar, Promover a Contratación]`.
4. **Modelos:** DTO reducido `RrhhApplicantSummaryDto` para el embudo/tabla; `RrhhApplicant` para ficha de evaluación.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| RECLUTAMIENTO & SELECCIÓN DE PERSONAL                                       [+ Registrar Postulante]|
| Pipeline de candidatos para cobertura de vacantes en Oficina y Operaciones en Campo                |
+----------------------------------------------------------------------------------------------------+
| [COLUMNAS DEL EMBUDO KANBAN / TABS]:                                                               |
| [1. Nuevos (4)]  |  [2. En Evaluación (3)]  |  [3. Seleccionados (2)]  |  [4. Descartados (8)]       |
+----------------------------------------------------------------------------------------------------+
| [TABLA DE CANDIDATOS EN LA ETAPA SELECCIONADA]:                                                    |
| CÓDIGO   | CANDIDATO              | ÁREA ASPIRADA | CARGO / ESPECIALIDAD | FECHA POST. | CV | ACCIONES |
|----------+------------------------+---------------+----------------------+-------------+----+----------|
| POST-012 | Andrés Morales Cuéllar | Operaciones   | Limpieza Hospital.   | 20/09/2026  | [✓]| [Evaluar]|
| POST-014 | Marcos Aguilera Soto   | Operaciones   | Seguridad Física     | 21/09/2026  | [✓]| [Evaluar]|
+----------------------------------------------------------------------------------------------------+
| [DRAWER / MODAL DE EVALUACIÓN LATERAL]:                                                            |
| Candidato: Marcos Aguilera Soto (POST-014) • Tel: 78912345 (🔒) • Pretensión: Bs. 3.200 (🔒)       |
| Documentación: [✓] Fotocopia CI adjunta   [✓] Currículum Vitae PDF [Ver Archivo]                  |
| Notas de Entrevista: "Cumple con estatura y libreta militar. Experiencia previa en banca."         |
| Acciones de Etapa: [Pasar a Seleccionado] [Rechazar / Descartar]                                   |
| Acción Principal:  [>>> INICIAR CONTRATACIÓN FORMAL >>>] (Activo solo si status=SELECCIONADO)      |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:**
   * **Vacío:** *"No hay postulantes en esta etapa del proceso de selección."*
   * **Cargando:** Indicador de carga modular por columna.
   * **Error:** Mensaje de error con reintento.
7. **Validaciones en Cliente:** Nombre, CI y celular obligatorios en registro de postulante; motivo obligatorio si se marca como `RECHAZADO`.
8. **Roles / Permisos:** `rrhh.personal.view`, `rrhh.personal.manage`.
9. **Endpoints:** `rrhhApplicant.listApplicants()`, `rrhhApplicant.updateApplicantStatus()`, `rrhhApplicant.createApplicant()`.

---

### PANTALLA 05: Contratación Formal (Wizard / Stepper)
1. **Propósito:** Promoción guiada de postulante seleccionado a empleado o alta directa, validando checklist legal de documentos.
2. **Ubicación:** Wizard modal invocado desde Pantalla 04 o botón superior de Pantalla 02.
3. **Modo de Operación:** `[Escritura / Transaccional]`.
4. **Modelos:** Input: `RrhhApplicant?`; Output: `RrhhEmployee`.
5. **Layout Visual (Stepper de 3 Pasos):**

```
+----------------------------------------------------------------------------------------------------+
| CONTRATACIÓN FORMAL E INCORPORACIÓN EN NÓMINA                                             [Cancelar]|
+----------------------------------------------------------------------------------------------------+
| [PASO 1: DATOS LABORALES] ---- (PASO 2: CONTRATO & SUELDO) ---- (PASO 3: CHECKLIST LEGAL)          |
+----------------------------------------------------------------------------------------------------+
| PASO 1 ACTUAL: Clasificación Laboral                                                               |
| • Tipo de Trabajador:  (o) CAMPO (Operativo en Clientes)    ( ) OFICINA (Administrativo)           |
| • Departamento / Área: [ Operaciones & Servicios v ]                                               |
| • Cargo Contractual:   [ Guardia de Seguridad v ]                                                  |
| • Especialidad Base:   [ Seguridad Física & Vigilancia v ]                                         |
| • Turno Base Convenido:[ Operativo Mañana (07:00 - 15:00) v ]                                      |
| • Fecha de Ingreso:    [ 01/10/2026 ] (Fecha efectiva de inicio)                                   |
|                                                                                                    |
| [Siguiente: Contrato y Sueldo >]                                                                   |
+----------------------------------------------------------------------------------------------------+
| PASO 2: Contrato y Remuneración                                                                    |
| • Tipo Contrato:       [ A Plazo Fijo (1 año) v ]   • Fin de Contrato: [ 30/09/2027 ]               |
| • Sueldo Base Acordado:Bs. [ 3.500,00 ] (🔒)        • Modalidad Pago:  [ Mensual v ]               |
|                                                                                                    |
| [ < Anterior ]  [ Siguiente: Documentos > ]                                                        |
+----------------------------------------------------------------------------------------------------+
| PASO 3: Validación Legal de Documentos Físicos                                                     |
| [✓] Fotocopia de C.I. (Obligatorio)             [✓] Certificado FELCC (Obligatorio para Seguridad) |
| [✓] Aviso Luz/Agua                              [✓] Croquis Domiciliario                           |
| [✓] Foto 3x4 Fondo Rojo                         [✓] Afiliación Seguro SUS                          |
| *Regla de Bloqueo: Si es personal de Seguridad y falta FELCC, el botón se deshabilita.*           |
|                                                                                                    |
| [ < Anterior ]  [ CONFIRMAR Y CREAR EXPEDIENTE EN NÓMINA ]                                         |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:**
   * **Procesando Contratación:** Overlay con spinner *"Creando expediente institucional y generando credenciales..."*.
   * **Éxito:** Modal de bienvenida mostrando credenciales APK generadas (`usuario` y `contraseña temporal`) con botón `[Copiar Credenciales]` e imprimir ficha.
7. **Validaciones en Cliente:**
   * Bloqueo estricto: Si el cargo contiene "seguridad" o "guardia", la casilla `hasFelccRecord` es **obligatoria**.
   * Sueldo base mayor a cero.
   * Fechas válidas (`contractEndDate` posterior a `realStartDate`).
8. **Roles / Permisos:** `rrhh.personal.manage`.
9. **Endpoints:** `rrhhPersonnel.hireApplicant()`.

---

### PANTALLA 06: Estructura Organizacional
1. **Propósito:** Administración de catálogos estructurales: Áreas corporativas, Puestos/Cargos de trabajo y Especialidades técnicas operativas.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Organización (Índice 12).
3. **Modo de Operación:** `[Lectura y Escritura: Crear, Editar, Desactivar Áreas/Cargos/Especialidades]`.
4. **Modelos:** `List<RrhhArea>`, `List<RrhhPosition>`, `List<RrhhSpecialty>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| ESTRUCTURA ORGANIZACIONAL                                                 [+ Nuevo Registro en Tab]|
| Catálogos jerárquicos corporativos: Departamentos, Puestos y Especialidades técnicas               |
+----------------------------------------------------------------------------------------------------+
| [PESTAÑAS]:  [1. Áreas Departamentales (4)]  |  [2. Cargos de Trabajo (7)]  |  [3. Especialidades (5)] |
+----------------------------------------------------------------------------------------------------+
| TABLA SEGÚN PESTAÑA SELECCIONADA (Ej: Pestaña 2 - Cargos de Trabajo):                              |
| CÓDIGO        | TÍTULO DEL CARGO          | ÁREA PERTENECIENTE | ENTORNO | SUELDO SUGERIDO | ACCIONES |
|---------------+---------------------------+--------------------+---------+-----------------+----------|
| CARGO-JARD    | Jardinero de Área Verde   | Operaciones        | CAMPO   | Bs. 2.800,00 🔒 | [Editar] |
| CARGO-LIMP    | Operario de Limpieza      | Operaciones        | CAMPO   | Bs. 2.750,00 🔒 | [Editar] |
| CARGO-SEG     | Guardia de Seguridad      | Operaciones        | CAMPO   | Bs. 3.200,00 🔒 | [Editar] |
| CARGO-ADM     | Auxiliar Administrativo   | Administración     | OFICINA | Bs. 3.000,00 🔒 | [Editar] |
| CARGO-RRHH    | Encargada de RRHH         | Recursos Humanos   | OFICINA | Bs. 4.500,00 🔒 | [Editar] |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando (Skeleton), Error con reintento.
7. **Validaciones en Cliente:** Código único en mayúsculas (`CARGO-xxx`), nombre no vacío, área padre obligatoria en creación de cargos.
8. **Roles / Permisos:** Lectura: `rrhh.personal.view`; Modificación: `rrhh.personal.manage`.
9. **Endpoints:** `rrhhOrganization.listAreas()`, `rrhhOrganization.listPositions()`, `rrhhOrganization.listSpecialties()`.

---

### PANTALLA 07: Catálogo de Horarios y Turnos Base [NUEVA]
1. **Propósito:** Gestión del catálogo oficial de jornadas y turnos de trabajo que RRHH publica para consulta de Operaciones (Sección 4.1 y 4.2).
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Turnos & Horarios (Índice 13).
3. **Modo de Operación:** `[Lectura y Escritura: Crear Turno, Modificar Tolerancias, Desactivar]`.
4. **Modelos:** `List<RrhhSchedule>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| CATÁLOGO CORPORATIVO DE TURNOS Y HORARIOS                                            [+ Nuevo Turno]|
| Jornadas contractuales y reglas de tolerancia publicadas para la APK y programación de Operaciones |
+----------------------------------------------------------------------------------------------------+
| [GRID DE TARJETAS DE TURNOS CORPORATIVOS]:                                                         |
|                                                                                                    |
| +--------------------------------------+  +--------------------------------------+                 |
| | ADMINISTRATIVO CENTRAL     [OFICINA] |  | OPERATIVO MAÑANA (CAMPO)     [CAMPO] |                 |
| | 08:30 — 17:30 (Lunes a Viernes)      |  | 07:00 — 15:00 (Lunes a Sábado)       |                 |
| | Tolerancia de Marcación: 15 minutos  |  | Tolerancia de Marcación: 10 minutos  |                 |
| | Total Horas Semanales: 40 hrs        |  | Total Horas Semanales: 48 hrs        |                 |
| | Jornada Diurna • Activo              |  | Jornada Diurna • Activo              |                 |
| | [Editar Parámetros]    [Desactivar]  |  | [Editar Parámetros]    [Desactivar]  |                 |
| +--------------------------------------+  +--------------------------------------+                 |
|                                                                                                    |
| +--------------------------------------+  +--------------------------------------+                 |
| | OPERATIVO TARDE            [CAMPO]   |  | VIGILANCIA NOCTURNA 24/48    [CAMPO] |                 |
| | 14:00 — 22:00 (Lunes a Sábado)       |  | 20:00 — 08:00 (Turno Rotativo 24h)   |                 |
| | Tolerancia de Marcación: 10 minutos  |  | Tolerancia de Marcación: 5 minutos   |                 |
| | [Editar Parámetros]    [Desactivar]  |  | [🌙 Recargo Nocturno] [Editar]       |                 |
| +--------------------------------------+  +--------------------------------------+                 |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error con reintento.
7. **Validaciones en Cliente:** Validación regex de horas `HH:mm`; días laborables no vacíos; tolerancia entre 0 y 60 minutos.
8. **Roles / Permisos:** `rrhh.assignments.view`, `rrhh.assignments.manage`.
9. **Endpoints:** `rrhhAssignment.listSchedules()`, `rrhhAssignment.createSchedule()`.

---

### PANTALLA 08: Permisos y Licencias Médicas
1. **Propósito:** Recepción, validación de certificados médicos (CNS) y resolución (Aprobación/Rechazo) de licencias laborales.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Permisos & Licencias (Índice 14).
3. **Modo de Operación:** `[Lectura + Acciones específicas: Registrar Permiso, Aprobar, Rechazar]`.
4. **Modelos:** `List<RrhhLeaveRequest>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| GESTIÓN DE PERMISOS & LICENCIAS MÉDICAS                                         [+ Registrar Permiso]|
| Control de ausencias autorizadas. La aprobación actualiza automáticamente disponibilidad a CON_PERMISO|
+----------------------------------------------------------------------------------------------------+
| [FILTROS]: [Estado: TODOS/PENDIENTES/APROBADOS]  [Tipo: TODOS/MÉDICO/PERSONAL]  [Mes: Septiembre 2026] |
+----------------------------------------------------------------------------------------------------+
| CÓDIGO   | COLABORADOR         | TIPO       | FECHAS (DESDE - HASTA) | DÍAS/HRS | COMPROBANTE | ESTADO    | ACCIONES       |
|----------+---------------------+------------+------------------------+----------+-------------+-----------+----------------|
| LIC-001  | Paola Andrea Torrico| MÉDICA CNS | 22/09/2026 - 24/09/2026| 2 días   | CNS #88912  | [APROBADO]| [Ver Detalle]  |
| LIC-002  | Carlos Mamani C.    | PARTICULAR | 25/09/2026 (08:00-12:00| 4 horas  | Nota escrita| [PENDIENTE| [Aprobar][Rech]|
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** `endDate >= startDate`; `daysCount > 0`; si tipo es `MEDICA`, exigencia del número de certificado médico CNS.
8. **Roles / Permisos:** Lectura: `rrhh.labor.view`; Resolución: `rrhh.labor.manage`.
9. **Endpoints:** `rrhhLabor.listLeaveRequests()`, `rrhhLabor.resolveLeaveRequest()`.

---

### PANTALLA 09: Control de Vacaciones (Ley Laboral Bolivia)
1. **Propósito:** Cómputo legal de días de vacación según antigüedad en Bolivia, registro de solicitudes y control de saldo de días.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Vacaciones (Índice 15).
3. **Modo de Operación:** `[Lectura + Acciones específicas: Solicitar Vacación, Aprobar Cómputo]`.
4. **Modelos:** `List<RrhhVacation>`, cálculo legal derivado de `RrhhEmployee.realStartDate`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| CONTROL LEGAL DE VACACIONES ANUALES                                             [+ Programar Salida]|
| Cómputo estricto conforme a la Ley General del Trabajo de Bolivia (1 a 5a: 15d | 5 a 10a: 20d | +10a: 30d)|
+----------------------------------------------------------------------------------------------------+
| RESUMEN EJECUTIVO: [18 Colaboradores con Saldo Disponible] • [2 De Vacaciones Hoy]                 |
+----------------------------------------------------------------------------------------------------+
| CÓDIGO   | COLABORADOR       | INGRESO    | ANTIGÜEDAD | GESTIÓN | DÍAS LEY | TOMADOS | SALDO | ESTADO    | ACCIONES |
|----------+-------------------+------------+------------+---------+----------+---------+-------+-----------+----------|
| VAC-001  | Juan Carlos Pérez | 12/05/2023 | 3 años     | 2026    | 15 días  | 5 días  | 10 d  | [EN CURSO]| [Detalle]|
| VAC-002  | Roberto Justiniano| 10/01/2019 | 7 años     | 2026    | 20 días  | 0 días  | 20 d  | [PENDIENTE| [Aprobar]|
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** Días solicitados no pueden superar el saldo restante devengado; empleado debe tener al menos 1 año de antigüedad real para consolidar duodécimas.
8. **Roles / Permisos:** `rrhh.labor.view`, `rrhh.labor.manage`.
9. **Endpoints:** `rrhhLabor.listVacations()`, `rrhhLabor.requestVacation()`, `rrhhLabor.approveVacation()`.

---

### PANTALLA 10: Régimen Disciplinario e Incidencias
1. **Propósito:** Emisión y registro de sanciones, memorándums de llamada de atención y felicitaciones por desempeño.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Disciplina & Novedades (Índice 16).
3. **Modo de Operación:** `[Lectura y Escritura: Registrar Novedad, Adjuntar Memorándum Firmado]`.
4. **Modelos:** `List<RrhhIncident>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| RÉGIMEN DISCIPLINARIO & RECONOCIMIENTOS                                          [+ Emitir Novedad] |
| Registro de memorándums, sanciones, faltas graves y felicitaciones al expediente del trabajador    |
+----------------------------------------------------------------------------------------------------+
| [FILTROS]: [Severidad: TODAS/LEVE/MODERADA/GRAVE/POSITIVA]  [Buscar por colaborador...]             |
+----------------------------------------------------------------------------------------------------+
| FECHA      | COLABORADOR       | TIPO DE INCIDENCIA       | SEVERIDAD | TÍTULO / MOTIVO         | ADJUNTO | ACCIONES |
|------------+-------------------+--------------------------+-----------+-------------------------+---------+----------|
| 18/09/2026 | Carlos E. Mamani  | ATRASO_REITERADO         | [LEVE]    | Memorándum 3 atrasos    | [PDF]   | [Ver Ficha]
| 15/09/2026 | Juan Carlos Pérez | FELICITACION_CLIENTE     | [POSITIVA]| Carta felicitación Kolp.| [PDF]   | [Ver Ficha]
| 10/09/2026 | Marcos Aguilera   | ABANDONO_PUESTO_CAMPO    | [GRAVE]   | Falta de guardia 4 hrs  | [PDF]   | [Ver Ficha]
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** Título, descripción y acción correctiva obligatorios; si es grave, recomendación de adjuntar escaneado firmado.
8. **Roles / Permisos:** `rrhh.labor.view`, `rrhh.labor.manage`.
9. **Endpoints:** `rrhhLabor.listIncidents()`, `rrhhLabor.recordIncident()`.

---

### PANTALLA 11: Desvinculación & Bajas Laborales (Regla de Oro Inactivo)
1. **Propósito:** Proceso de egreso laboral definitivo, cálculo de antigüedad para finiquito y congelamiento del expediente sin borrado físico.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Bajas & Finiquitos (Índice 17).
3. **Modo de Operación:** `[Escritura / Regla de Oro Inmutable]`.
4. **Modelos:** `List<RrhhTermination>`, `RrhhEmployee`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| DESVINCULACIONES & REGISTRO DE FINIQUITOS                                        [+ Registrar Egreso]|
| Aplicación estricta de la Regla de Oro: Prohibido borrado físico; preservación histórica para OVT |
+----------------------------------------------------------------------------------------------------+
| CÓDIGO   | EX-COLABORADOR        | FECHA INGRESO | FECHA EGRESO | MOTIVO LEGAL      | FINIQUITO   | ACTIVO? | DETALLE  |
|----------+-----------------------+---------------+--------------+-------------------+-------------+---------+----------|
| DESV-001 | Pedro Pablo Gutiérrez | 01/02/2024    | 31/08/2026   | FIN_DE_CONTRATO   | Bs. 4.500 🔒| [NO]    | [Finiquito]
| DESV-002 | Mariana Siles Roca    | 15/06/2023    | 15/07/2026   | RENUNCIA_VOLUNT.  | Bs. 3.200 🔒| [NO]    | [Finiquito]
+----------------------------------------------------------------------------------------------------+
| [MODAL DE REGISTRO DE BAJA]:                                                                       |
| 1. Colaborador a desvincular: [ EMP-003 Carlos Mamani Choque v ]                                   |
| 2. Fecha de Egreso: [ 24/09/2026 ]  •  Último Día Trabajado: [ 23/09/2026 ]                         |
| 3. Causal Legal: [ Conclusión de contrato a plazo fijo v ]                                         |
| 4. Detalle y Entrega de Puesto: "Devolución de uniforme completo y credencial física."             |
| 5. Importe Estimado Finiquito: Bs. [ 3.800,00 ] (🔒)  •  Paz y Salvo: [✓] Inventario Entregado      |
| [ ADVERTENCIA ]: El colaborador pasará a INACTIVO y se finalizarán sus asignaciones en Operaciones |
| [ CONFIRMAR DESVINCULACIÓN INMUTABLE ]                                                             |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** Confirmación con diálogo modal irreversible; motivo detallado obligatorio; fecha de egreso obligatoria.
8. **Roles / Permisos:** `rrhh.labor.manage`.
9. **Endpoints:** `rrhhPersonnel.terminateEmployee()`, `rrhhLabor.terminateEmployee()`.

---

### PANTALLA 12: Novedades para Nómina (Entrega a Contabilidad)
1. **Propósito:** Consolidado administrativo mensual de días trabajados, salarios base pactados, bonos y descuentos para entrega formal a Contabilidad (Sección 6.1).  
> ⚠️ **REGLA DE FRONTERA:** Esta pantalla **NO liquida pagos bancarios ni genera asientos contables**. Su función es exportar el corte laboral mensual verificado para Contabilidad.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Novedades para Nómina (Índice 18).
3. **Modo de Operación:** `[Lectura + Exportación de Novedades a Contabilidad / Excel]`.
4. **Modelos:** DTO `RrhhPayrollExportDto`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| CONSOLIDADO DE NOVEDADES LABORALES PARA NÓMINA (CORTE MENSUAL)               [Exportar para Contab]|
| Datos base y novedades autorizadas por RRHH para liquidación en Contabilidad (PDF Sección 6.1)     |
+----------------------------------------------------------------------------------------------------+
| [SELECTOR DE PERIODO]:  Mes: [ Septiembre v ]   Año: [ 2026 v ]   Estado: [ CERRADO Y CONCILIADO ]  |
+----------------------------------------------------------------------------------------------------+
| CÓDIGO  | COLABORADOR         | TIPO CONTRATO | SUELDO BASE 🔒| DÍAS TRAB | BONOS AUTORIZ. | DESCUENTOS AUT.| NOVEDADES |
|---------+---------------------+---------------+---------------+-----------+----------------+----------------+-----------|
| EMP-001 | Juan Carlos Pérez   | Indefinido    | Bs. 4.200 🔒  | 30 días   | +Bs. 350 (Punt)| -Bs. 0         | Normal    |
| EMP-002 | María Elena Gómez   | Indefinido    | Bs. 3.800 🔒  | 30 días   | +Bs. 0         | -Bs. 500 (Ant) | Anticipo  |
| EMP-003 | Carlos E. Mamani    | Plazo Fijo    | Bs. 3.000 🔒  | 28 días   | +Bs. 0         | -Bs. 120 (Cred)| 2d Permiso|
+----------------------------------------------------------------------------------------------------+
| TOTALES DEL CORTE: 25 Colaboradores • Total Novedades: +Bs. 350 / -Bs. 620 • [Transferir a Contab]  |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** Periodo cerrado no editable.
8. **Roles / Permisos:** `rrhh.reports.view`, `rrhh.compensation.view`.
9. **Endpoints:** `rrhhReports.getPayrollInputs(month, year)`.

---

### PANTALLA 13: Asistencia de Campo Consolidada (Recepción APK) [NUEVA]
1. **Propósito:** Visualización de solo lectura de la realidad operativa de campo recibida de la APK: entradas, salidas, horas y retrasos (Sección 4.3).  
> ⚠️ **REGLA DE FRONTERA:** 100% Solo Lectura. RRHH **NUNCA modifica marcaciones reales ni altera entradas/salidas de campo**.
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Asistencia de Campo (Índice 19).
3. **Modo de Operación:** `[100% Solo lectura]`.
4. **Modelos:** DTO `OpsAttendanceSummaryDto`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| ASISTENCIA DE CAMPO CONSOLIDADA (TELEMETRÍA APK OPERACIONES)               [Actualizar Marcaciones]|
| Registros de campo recibidos de la APK: marcaciones, horas efectivas y retrasos (PDF Sección 4.3)  |
+----------------------------------------------------------------------------------------------------+
| [FILTRO POR FECHA]: [ Hoy: 24/09/2026 v ]   [Estado: TODOS/PUNTUAL/ATRASO/FALTA]   [Área: Campo v] |
+----------------------------------------------------------------------------------------------------+
| CÓDIGO  | COLABORADOR         | CUENTA / SEDE CLIENTE     | ENTRADA PROG | ENTRADA REAL | RETRASO | SALIDA REAL | ESTADO    |
|---------+---------------------+---------------------------+--------------+--------------+---------+-------------+-----------|
| EMP-001 | Juan Carlos Pérez   | Kolping • Central         | 07:00        | 06:58        | 0 min   | 15:02       | [PUNTUAL] |
| EMP-003 | Carlos E. Mamani    | Ventura Mall • Equipetrol | 07:00        | 07:18        | 18 min  | --:--       | [ATRASO]⚠️|
| EMP-014 | Marcos Aguilera     | Manzana 40 • Piso 12      | 08:00        | 07:55        | 0 min   | --:--       | [PUNTUAL] |
| EMP-018 | Fernando Roca       | Fancesa • Planta          | 07:00        | --:--        | -- min  | --:--       | [FALTA] ❌|
+----------------------------------------------------------------------------------------------------+
| *Nota de Auditoría: Estos datos provienen directamente del GPS y marcaciones de la APK de Campo.*   |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** N/A (Solo lectura).
8. **Roles / Permisos:** `rrhh.labor.view`.
9. **Endpoints:** `rrhhLabor.listAttendanceRecords(date)`.

---

### PANTALLA 14: Bitácora / Auditoría de Movimientos [NUEVA]
1. **Propósito:** Trazabilidad inmutable de todas las novedades laborales del sistema (ascensos, transferencias de área, ajustes salariales, cambios de turno y bajas).
2. **Ubicación:** Acordeón Lateral > Recursos Humanos > Bitácora de Movimientos (Índice 20).
3. **Modo de Operación:** `[100% Solo lectura inmutable — Prohibido editar o borrar registros]`.
4. **Modelos:** `List<RrhhMovementHistory>`.
5. **Layout Visual:**

```
+----------------------------------------------------------------------------------------------------+
| BITÁCORA INMUTABLE DE MOVIMIENTOS LABORALES                                  [Exportar Auditoría]  |
| Registro histórico inmutable de eventos, ascensos, rotaciones y cambios contractuales             |
+----------------------------------------------------------------------------------------------------+
| [FILTROS]: [Tipo Movimiento: TODOS v]   [Colaborador: Todos v]   [Rango Fechas: Últimos 30 días]   |
+----------------------------------------------------------------------------------------------------+
| TIMESTAMPS | CÓDIGO  | COLABORADOR       | TIPO EVENTO      | VALOR ANTERIOR    | NUEVO VALOR       | AUTORIZADO POR     |
|------------+---------+-------------------+------------------+-------------------+-------------------+--------------------|
| 23/09 11:30| EMP-001 | Juan Carlos Pérez | AJUSTE_SALARIAL  | Bs. 3.850,00 🔒   | Bs. 4.200,00 🔒   | Gerencia General   |
| 20/09 09:15| EMP-015 | Carlos Choque M.  | INGRESO_NOMINA   | Postulante        | Empleado Activo   | Lic. Laura Mendoza |
| 15/09 16:40| EMP-007 | Paola A. Torrico  | TRASLADO_AREA    | Marketing         | Recursos Humanos  | Gerencia General   |
| 31/08 18:00| EMP-011 | Mariana Siles R.  | DESVINCULACION   | Activo            | Inactivo (Fin Cto)| Lic. Laura Mendoza |
+----------------------------------------------------------------------------------------------------+
| Total 142 movimientos auditados sin alteraciones registradas                                       |
+----------------------------------------------------------------------------------------------------+
```

6. **Estados Obligatorios:** Vacío, Cargando, Error.
7. **Validaciones en Cliente:** N/A (Solo lectura).
8. **Roles / Permisos:** `rrhh.labor.view`, `audit.view`.
9. **Endpoints:** `rrhhLabor.listMovements(limit, offset)`.

---

## 3. Matriz de Síntesis de Modelos por Pantalla

| # | Nombre de Pantalla | Modelo Reducido (Tabla) | Modelo Completo (Detalle) | Modelo Externo (Ref) |
|---|---|---|---|---|
| **01** | Dashboard RRHH | `RrhhDashboardMetricsResponse` | `RrhhRecentMovementDto` | N/A |
| **02** | Directorio de Personal | `RrhhEmployeeSummaryDto` | `RrhhEmployee` | N/A |
| **03** | Expediente del Empleado | N/A | `RrhhEmployee`, `RrhhEmployeeDocument` | `RrhhAssignment?` (Ops/CRM) |
| **04** | Reclutamiento & Postulantes| `RrhhApplicantSummaryDto` | `RrhhApplicant` | N/A |
| **05** | Contratación (Wizard) | N/A | `RrhhApplicant`, `RrhhEmployee` | N/A |
| **06** | Estructura Organizacional | `RrhhArea`, `RrhhPosition`, `RrhhSpecialty` | Idem | N/A |
| **07** | Turnos & Horarios Base | `RrhhSchedule` | `RrhhSchedule` | N/A |
| **08** | Permisos y Licencias | `RrhhLeaveRequest` | `RrhhLeaveRequest` | N/A |
| **09** | Control de Vacaciones | `RrhhVacation` | `RrhhVacation` | N/A |
| **10** | Régimen Disciplinario | `RrhhIncident` | `RrhhIncident` | N/A |
| **11** | Desvinculaciones & Bajas | `RrhhTermination` | `RrhhTermination` | N/A |
| **12** | Novedades para Nómina | `RrhhPayrollExportDto` | `RrhhPayrollExportDto` | `ContabPayrollInputDto` |
| **13** | Asistencia de Campo | `OpsAttendanceSummaryDto` | `OpsAttendanceSummaryDto` | Solo Lectura de Operaciones |
| **14** | Bitácora de Movimientos | `RrhhMovementHistory` | `RrhhMovementHistory` | Inmutable |
