# Auditoría Exhaustiva y Plan de Transformación Backend: Módulo de Recursos Humanos (RRHH)
**Sistema Interno de Gestión — Elite Multiservicios**  
**Documento de Referencia:** *Relación e Integración de los Módulos (Arquitectura Funcional e Integración, Págs. 1–10) & Protocolo de Reconstrucción de RRHH*  
**Fecha:** 23 de Septiembre de 2026  
**Responsable del Módulo:** Encargada de RRHH & Antigravity AI  

---

## 1. Resumen Ejecutivo del Dictamen de Auditoría

Tras cotejar minuciosamente los requerimientos del documento de arquitectura funcional (*Relación e Integración de los Módulos*, Págs. 1–10) y las especificaciones operativas de la empresa con el estado actual del código:

1. **Estado Actual:** El módulo de RRHH cuenta con una interfaz de usuario avanzada en Flutter (`features/rrhh/`), pero la persistencia en el backend Serverpod es casi inexistente (únicamente cuenta con `RrhhDashboardEndpoint` y métricas simuladas en `RrhhDashboardRepository`). El resto del módulo opera sobre datos en memoria (`RrhhStateService` y `rrhh_mock_data.dart`).
2. **Mandato de la Auditoría:** Reemplazar progresivamente todos los mocks en memoria por un esquema backend real en PostgreSQL + Serverpod, robusto, fuertemente tipado, con auditoría transaccional, control de permisos RBAC y estricto cumplimiento de fronteras entre módulos.

---

## 2. Matriz de Fronteras y Propiedad de los Datos (PDF Págs. 2–8)

Para evitar duplicidad, inconsistencias y colisiones intermodulares, se delimitan estrictamente las responsabilidades de RRHH:

| Ámbito Funcional | ¿Es Propiedad de RRHH? | Módulo Propietario / Frontera | Regla de Arquitectura |
| :--- | :---: | :--- | :--- |
| **Expediente del Personal** (Datos, CI, Hoja de Vida, Contratos) | **SÍ (Fuente de Verdad)** | **RRHH** | RRHH centraliza todo el ciclo de vida del trabajador (Postulante → Contratado → Activo → Inactivo). |
| **Estructura Organizacional** (Áreas, Cargos, Especialidades) | **SÍ (Fuente de Verdad)** | **RRHH** | Catálogos administrados por RRHH que definen los perfiles de puesto. |
| **Disponibilidad Laboral del Personal** | **SÍ (Fuente de Verdad)** | **RRHH** | RRHH publica a Operaciones qué empleados están disponibles (no de baja, sin sanción, activos). |
| **Asignación Contractual / Puesto Base** | **SÍ (Fuente de Verdad)** | **RRHH** | RRHH asigna al trabajador a una cuenta/cliente o área interna y define su turno/horario convenido. |
| **Gestión Laboral Administrativa** (Permisos, Vacaciones, Bajas) | **SÍ (Fuente de Verdad)** | **RRHH** | RRHH autoriza y registra incidencias administrativas, memorándums y desvinculaciones. |
| **Nómina y Planillas (Vista RRHH por Empresa)** | **SÍ (Administrativo)** | **RRHH** (Agrupado por Cliente/Empresa) | Reporte consolidado de personal asignado por empresa para control operativo y ministerial (OVT). |
| **Marcaciones Biométricas y Asistencia Diaria** | **NO** | **Operaciones / APK de Campo** | RRHH define el horario teórico (ej. 08:00–17:00). La APK registra entradas/salidas reales con GPS. RRHH solo consume faltas/atrasos reportados. |
| **Clientes, Sedes y Servicios Contratados** | **NO** | **CRM y Ventas** | RRHH **NO crea clientes ni contratos de clientes**; guarda solo referencias (`customerId`, `branchId`, `contractId`). |
| **Dispersión Bancaria y Declaración Impositiva** | **NO** | **Contabilidad y Finanzas** | Contabilidad consume la planilla aprobada de RRHH para generar pagos bancarios y libros contables. |

---

## 3. Hoja de Ruta Dividida por Fases de Ejecución

El plan de construcción e integración backend se ejecuta en **7 Fases Secuenciales**, con parada obligatoria y punto de control al término de cada una:

```
[FASE 1] Catálogos Organizacionales y Estructura Base (Áreas, Cargos, Especialidades)
    ↓ (Punto de Control & Verificación)
[FASE 2] Postulantes y Pipeline de Selección (Reclutamiento)
    ↓ (Punto de Control & Verificación)
[FASE 3] Expediente del Empleado y Contratación (Empleado, Ficha, Documentos)
    ↓ (Punto de Control & Verificación)
[FASE 4] Asignaciones Operativas y Horarios (Oficina vs Campo & Referencias CRM)
    ↓ (Punto de Control & Verificación)
[FASE 5] Gestión Laboral (Permisos, Vacaciones, Incidencias, Desvinculación e Historial)
    ↓ (Punto de Control & Verificación)
[FASE 6] Telemetría y Reportes Backend (Dashboard Ejecutivo & Planilla por Empresa)
    ↓ (Punto de Control & Verificación)
[FASE 7] Conexión Frontend & Erradicación de Mocks de RRHH
```

---

## 4. Detalle y Alcance de las Fases

### **FASE 1: Catálogos Organizacionales y Estructura Base (COMPLETADA CON ÉXITO ✅)**
*Objetivo:* Establecer la base jerárquica de la empresa (Áreas, Cargos y Especialidades operativas).
- [x] **Modelos Serverpod:**
  - `rrhh_area.spy.yaml`: `code`, `name`, `description`, `colorTag`, `isActive`, `isDeleted`, `deletedAt`, `createdAt`, `updatedAt`.
  - `rrhh_position.spy.yaml`: `code`, `areaId` (FK), `name`, `workplaceType` ('Oficina' | 'Campo'), `suggestedSalary`, `requirements`, `isActive`.
  - `rrhh_specialty.spy.yaml`: `code`, `name`, `description`, `colorTag`, `isActive`.
- [x] **Lógica & Repositorios:**
  - `RrhhOrganizationRepository`: CRUD completo para áreas, cargos y especialidades con validación de no duplicidad, filtros por entorno y soft delete con cascada lógica.
  - `RrhhOrganizationEndpoint`: Endpoints protegidos mediante `RbacGuard` con permisos `AppPermissions.rrhhPersonalView` y `AppPermissions.rrhhPersonalManage`.
- [x] **Migración & Seed Data:**
  - Ejecutado `serverpod generate` y migración SQL `20260923131047544` aplicada en PostgreSQL de desarrollo y testing.
  - Seeder corporativo `RrhhOrganizationSeed` integrado en arranque del servidor: 4 Áreas (Operaciones, RRHH, Administración, Comercial), 7 Cargos (Oficina y Campo) y 5 Especialidades Técnicas persistidas en PostgreSQL.
  - Test de integración `rrhh_organization_test.dart` ejecutado y pasando al 100%.
- ⏸️ **PUNTO DE CONTROL 1 ALCANZADO: FASE 1 completada y validada en PostgreSQL con cero errores de análisis estático.**

---

### **FASE 2: Postulantes y Pipeline de Selección (Reclutamiento) (COMPLETADA CON ÉXITO ✅)**
*Objetivo:* Gestionar el ciclo de vida del candidato antes de convertirse en empleado formal.
- [x] **Modelos Serverpod:**
  - `rrhh_applicant.spy.yaml`:
    - Identificación: `code` (ej: POST-001 con auto-generación), `fullName`, `identityCard` (CI), `phone`, `email`, `address`, `birthDate`.
    - Contacto de emergencia: `emergencyContact`, `emergencyPhone`.
    - Perfil: `targetArea`, `areaId` (FK), `targetPosition`, `positionId` (FK), `targetType` ('OFICINA' | 'CAMPO'), `specialty`, `specialtyId` (FK), `education`, `experienceSummary`, `skills`, referencias.
    - Embudo y compuertas: `status` ('NUEVO', 'EN_EVALUACION', 'ENTREVISTADO', 'SELECCIONADO', 'RECHAZADO', 'CONTRATADO'), `interviewNotes`, `expectedSalary`, `hasCvAttached`, `hasIdentityCardCopy`, `cvUrl`, `discardReason`.
    - Índices y auditoría: `code_unique_idx`, `ci_idx`, `status_idx`, soft delete con `isDeleted` y `deletedAt`.
- [x] **Lógica & Repositorios:**
  - `RrhhRecruitmentRepository`: Búsqueda, paginación, filtros por estado/entorno/especialidad, auto-generación de código secuencial, compuertas de entrevista/evaluación y soft delete.
  - `RrhhApplicantEndpoint`: Endpoints protegidos mediante `RbacGuard` con permisos `AppPermissions.rrhhPersonalView` y `AppPermissions.rrhhPersonalManage`.
- [x] **Migración & Seed Data:**
  - Migración SQL `20260923132810894` aplicada en desarrollo y test.
  - Seeder de 4 postulantes representativos en diferentes etapas del pipeline (POST-001 SELECCIONADO, POST-002 EN_EVALUACION, POST-003 NUEVO, POST-004 RECHAZADO) persistidos en PostgreSQL.
  - Test de integración `rrhh_recruitment_test.dart` ejecutado y pasando al 100%.
- ⏸️ **PUNTO DE CONTROL 2 ALCANZADO: FASE 2 completada y validada en PostgreSQL con cero errores de análisis estático.**

---

### **FASE 3: Expediente del Empleado y Contratación (COMPLETADA CON ÉXITO ✅)**
*Objetivo:* Núcleo principal de información laboral, legal y contractual del trabajador.
- [x] **Modelos Serverpod:**
  - `rrhh_employee.spy.yaml`:
    - Identificación: `code` (ej. EMP-001 con auto-generación), `fullName`, `birthDate`, `birthPlace`, `identityCard` (CI), `phone`, `address`, `occupation`, referencias.
    - Clasificación: `employeeType` ('OFICINA' | 'CAMPO'), `area`, `areaId` (FK), `position`, `positionId` (FK), `specialty`, `specialtyId` (FK), `workplace`, `supervisor`, `supervisorId` (FK).
    - Contrato y Salarios: `realStartDate`, `fiscalStartDate`, `agreedSalary`, `contractType` ('Indefinido', 'Plazo Fijo', 'Servicios'), `contractEndDate`, `paymentModality` ('MENSUAL', 'JORNAL', 'POR_HORAS'), `workScheduleType`.
    - Disponibilidad Operativa: `availabilityStatus` ('DISPONIBLE', 'ASIGNADO', 'DE_VACACIONES', 'CON_PERMISO', 'SUSPENDIDO') publicado a Operaciones.
    - Expediente físico e institucional: flags de CI, luz/agua, croquis, FELCC, foto, seguro SUS, `corporateEmail`, `applicantId` (FK).
    - Desvinculación laboral: `exitDate`, `exitReason`, `exitObservations`, `exitRegisteredBy` (preservando registro inactivo).
  - `rrhh_employee_document.spy.yaml`: Adjuntos digitales del expediente (CI, croquis, finiquito, certificados) con verificación.
  - `rrhh_timeline_event.spy.yaml`: Hitos históricos inmutables de la trayectoria laboral ('CONTRATACION', 'DESVINCULACION', 'ASIGNACION', etc.).
- [x] **Lógica de Conversión & Repositorio:**
  - `RrhhPersonnelRepository`: Creación directa con código correlativo (`EMP-001`, `EMP-002`), método transaccional `hireApplicant` que contrata al postulante seleccionado creando su expediente y marcando al candidato como 'CONTRATADO', actualización de disponibilidad, desvinculación `terminateEmployee` sin borrado físico y gestión de documentos/timeline.
  - `RrhhPersonnelEndpoint`: Endpoints protegidos mediante `RbacGuard` con permisos `AppPermissions.rrhhPersonalView` y `AppPermissions.rrhhPersonalManage`.
- [x] **Migración & Seed Data:**
  - Migración SQL `20260923135115883` aplicada en PostgreSQL de desarrollo y testing.
  - Seeder de 5 empleados iniciales (4 activos de campo/oficina y 1 inactivo desvinculado con finiquito) persistidos en PostgreSQL.
  - Test de integración `rrhh_personnel_test.dart` ejecutado y pasando al 100%.
- ⏸️ **PUNTO DE CONTROL 3 ALCANZADO: FASE 3 completada y validada en PostgreSQL con cero errores de análisis estático.**

---

### **FASE 4: Asignaciones Operativas y Horarios (COMPLETADA CON ÉXITO ✅)**
*Objetivo:* Definición de turnos, jornadas y asignación de personal a sedes de clientes (CRM) o áreas internas con inmutabilidad de rotaciones.
- [x] **Modelos Serverpod:**
  - `rrhh_schedule.spy.yaml`: `code`, `name`, `targetType` ('OFICINA' | 'CAMPO' | 'AMBOS'), `startTime`, `endTime`, `workDays` (`List<int>`), `toleranceMinutes`, `isNightShift`, `isActive`, soft delete y auditoría.
  - `rrhh_assignment.spy.yaml`:
    - Personal: `code` ('ASG-001'), `employeeId` (FK), `employeeCode`, `employeeName`, `assignmentType` ('OFICINA' | 'CAMPO').
    - Modalidad Oficina: `officeAreaId` (FK), `officeAreaName`, `officeRole`.
    - Modalidad Campo: `customerId` (ref CRM), `customerCompanyName`, `workplaceBranch`, `contractedServiceName`.
    - Supervisor & Horario: `supervisorName`, `supervisorEmployeeId` (FK), `scheduleId` (FK), `scheduleName`.
    - Vigencia & Rotación: `startDate`, `endDate`, `status` ('ACTIVA', 'FINALIZADA', 'CANCELADA'), `rotationNumber` (0=Puesto Inicial, 1, 2...), `originDescription`, `rotationReason`.
- [x] **Reglas de Integración Cumplidas:**
  - Inmutabilidad estricta: al rotar, la asignación previa pasa a `FINALIZADA` con su fecha de egreso y se crea una nueva asignación incrementando `rotationNumber` e indicando el destino de origen.
  - Actualización automática de `availabilityStatus = 'ASIGNADO'` y trazabilidad en la línea de tiempo del colaborador (`RrhhTimelineEvent`).
  - Al cancelar, se libera al colaborador a `availabilityStatus = 'DISPONIBLE'`.
- [x] **Repositorio & Endpoint:**
  - `RrhhOperationsRepository` y `RrhhAssignmentEndpoint` con protección RBAC (`AppPermissions.rrhhAssignmentsView` y `AppPermissions.rrhhAssignmentsManage`).
- [x] **Migración & Seed Data:**
  - Migración SQL `20260923150108714` generada y aplicada en PostgreSQL.
  - Seeder de 4 turnos oficiales y 4 asignaciones activas (con rotaciones históricas) integrado en arranque de servidor.
  - Suite de integración `rrhh_assignment_test.dart` ejecutada y pasando al 100% (4 suites de RRHH validadas en verde).
- ⏸️ **PUNTO DE CONTROL 4 ALCANZADO: FASE 4 completada y validada en PostgreSQL con cero errores de análisis estático.**

---

### **FASE 5: Gestión Laboral (Permisos, Vacaciones, Incidencias, Desvinculación)**
*Objetivo:* Registro de novedades administrativas, trazabilidad disciplinaria y preservación histórica post-salida.
- [ ] **Modelos Serverpod:**
  - `rrhh_leave_request.spy.yaml`: Permisos médicos, personales, duelo, con fechas, horas, justificación y estado ('Pendiente' | 'Aprobado' | 'Rechazado').
  - `rrhh_vacation.spy.yaml`: Registro de días solicitados, saldo restante, período legal.
  - `rrhh_incident.spy.yaml`: Memorándums, atrasos justificados, faltas, llamados de atención o felicitaciones.
  - `rrhh_termination.spy.yaml`: Fecha de egreso, motivo ('Renuncia Voluntaria', 'Fin de Contrato', 'Despido Justificado'), observaciones, responsable.
  - `rrhh_movement_history.spy.yaml`: Bitácora inmutable de cambios (ascensos, cambio de área, ajustes salariales, traslados).
- [ ] **Regla de Oro en Desvinculación:**
  - **PROHIBIDO ELIMINAR FÍSICAMENTE.** El empleado pasa a `employmentStatus = 'Inactivo'`. El expediente y su historial permanecen intactos para auditorías laborales y emisión de certificados de trabajo.
- [ ] **Repositorio & Endpoint:**
  - `RrhhLaborRepository` y `RrhhLaborEndpoint`.
- ⏸️ **PUNTO DE CONTROL 5: Verificación de gestión disciplinaria, permisos y retención de inactivos.**

---

### **FASE 6: Telemetría y Reportes Backend (Dashboard y Planilla por Empresa)**
*Objetivo:* Generación de métricas analíticas y agregaciones para la toma de decisiones y reportes OVT.
- [ ] **Modelos DTO:**
  - `rrhh_payroll_report_dto.spy.yaml`:
    - Agrupación por Cliente/Empresa (`companyName`, `customerNit`).
    - Detalle de trabajadores asignados, cargo, fecha de ingreso, días laborados, haber básico, bonos, descuentos y líquido pagable.
    - Soporte de modo 'RESUMEN' (8 columnas operativas) y modo 'OFICIAL OVT' (19 columnas ministeriales).
- [ ] **Lógica & Repositorio:**
  - `RrhhReportsRepository`: Generación de planillas filtradas por empresa, mes y año directamente desde PostgreSQL.
  - Actualización de `RrhhDashboardRepository` para calcular KPIs reales desde las tablas de la base de datos (eliminando mocks residuales).
- [ ] **Endpoint:**
  - `RrhhReportsEndpoint` protegido con `rrhh.reports.view`.
- ⏸️ **PUNTO DE CONTROL 6: Verificación de reportes agregados y telemetría real.**

---

### **FASE 7: Conexión Frontend & Erradicación de Mocks de RRHH**
*Objetivo:* Conectar la UI de Flutter (`features/rrhh/`) a los endpoints de Serverpod y eliminar los datos mockeados.
- [ ] Reemplazar `RrhhStateService` en memoria por llamadas a `RrhhApiService` y Serverpod Client.
- [ ] Conectar selector de empleados, asignaciones y diálogos de edición a PostgreSQL.
- [ ] Validar que las pruebas unitarias y de integración pasen con éxito.
- [ ] Ejecución de `pre-completion-check` y apertura de Pull Request hacia `develop`.
- 🏆 **AUDITORÍA Y TRANSFORMACIÓN BACKEND DE RRHH COMPLETADA AL 100%.**

---

## 5. Próximo Paso Inmediato
Comenzar con la ejecución de la **FASE 1: Catálogos Organizacionales y Estructura Base (Áreas, Cargos y Especialidades)** en Serverpod.
