# CONTRATO DE DATOS OFICIAL DEL MÓDULO DE RECURSOS HUMANOS (RRHH)
## Sistema Interno de Gestión — Elite Multiservicios

**Documento Fuente de Verdad:** `Relacion_e_Integracion_de_Modulos_Sistema_Multiservicios.pdf` (Págs. 4–10)  
**Especificación Técnica de Referencia:** Modelos Serverpod `.spy.yaml` en `elite_multiservicios_server/lib/src/modules/rrhh/models/`  
**Objetivo:** Establecer la definición formal de entidades, tipados, visibilidad, sensibilidad de datos y fronteras intermodulares que regirán la integración entre el backend Serverpod y el frontend Flutter.  
**Fecha:** 24 de Septiembre de 2026  

---

## 1. Convenciones y Simbología del Contrato

* **Orígenes de Datos:**
  * `RRHH`: Creado, administrado y validado exclusivamente por Recursos Humanos (Dueño de la Verdad).
  * `CRM`: Referencia externa de clientes, sedes y contratos comerciales (Solo Lectura).
  * `Operaciones / APK`: Registros operativos de campo, asistencia y marcaciones (Solo Lectura).
  * `Contabilidad`: Novedades salariales autorizadas e información contractual para nómina.
* **Sensibilidad (`Sensible`):**
  * 🔒 **SÍ**: Dato confidencial / PII (Salario, Cédula de Identidad, Domicilio, Teléfono personal, Contraseña temporal). **PROHIBIDO** incluir en listados masivos; accesible solo en vista de detalle con permisos explícitos `rrhh.personal.manage`.
  * 🌐 **NO**: Dato operativo/laboral visible en tablas y vistas generales.
* **Destino de Datos Derivados:**
  * `→ Operaciones`: Atributos publicados por RRHH para programación y despacho de servicios.
  * `→ Contabilidad`: Atributos publicados por RRHH para liquidación de nómina y finiquitos.

---

## 2. Definición de Entidades y Diccionario de Campos

### 2.1 Entidad: `RrhhEmployee` (Expediente Maestro del Colaborador)
**Tabla:** `rrhh_employee` | **Propósito:** Registro maestro de la vida laboral del trabajador (Sección 4.1).

| Campo | Tipo Dart | Nullable | Origen | Obligatorio | Visible Listado | Visible Detalle | Sensible | Notas y Reglas |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| `id` | `int` | No (PK) | RRHH | Auto | ✅ Sí | ✅ Sí | 🌐 No | Clave primaria relacional PostgreSQL. |
| `code` | `String` | No (UK) | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Código institucional correlativo (`EMP-001`). |
| `fullName` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre oficial completo. |
| `birthDate` | `DateTime?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Fecha de nacimiento para cálculo de edad. |
| `birthPlace` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | Lugar de nacimiento (ej: Santa Cruz de la Sierra). |
| `identityCard` | `String` | No (IDX)| RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Cédula de identidad (CI). No exponer en listas. |
| `phone` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Teléfono personal de contacto. |
| `address` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Domicilio particular del trabajador. |
| `occupation` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Profesión u oficio declarado. |
| `personalReference` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Nombre de referencia familiar o personal. |
| `referencePhone` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Teléfono de la referencia. |
| `employeeType` | `String` | No (IDX)| RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'OFICINA'` o `'CAMPO'`. |
| `area` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre desnormalizado del departamento. |
| `areaId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhArea`. |
| `position` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Cargo contractual oficial. |
| `positionId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhPosition`. |
| `specialty` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Especialidad técnica (`→ Operaciones`). |
| `specialtyId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhSpecialty`. |
| `workplace` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Sede contractual base (`Oficina Central` o Cliente). |
| `supervisor` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | Jefe directo asignado. |
| `supervisorId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Auto-referencia a `RrhhEmployee`. |
| `realStartDate` | `DateTime` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Fecha de ingreso real para cómputo de beneficios. |
| `fiscalStartDate` | `DateTime` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | Fecha de alta ministerial OVT / CNS. |
| `agreedSalary` | `double` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | **Salario pactado (`→ Contabilidad`). Estrictamente confidencial.** |
| `contractType` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'Indefinido'`, `'Plazo Fijo'`, `'Servicios'`. |
| `contractEndDate` | `DateTime?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Vencimiento para alertas de renovación. |
| `status` | `String` | No (IDX)| RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'ACTIVO'` o `'INACTIVO'` (`→ Operaciones`). |
| `skills` | `List<String>?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Habilidades homologadas (`→ Operaciones`). |
| `availabilityStatus`| `String` | No (IDX)| RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'DISPONIBLE'`, `'ASIGNADO'`, `'DE_VACACIONES'`, etc. |
| `paymentModality` | `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | `'MENSUAL'`, `'JORNAL'`, `'POR_HORAS'` (`→ Contab`). |
| `workScheduleType`| `String` | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | Jornada base (`TIEMPO_COMPLETO_48H`, etc.). |
| `hasCiCopy` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Checklist legal de documento físico. |
| `hasUtilityBill` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Aviso de luz / agua verificado. |
| `hasHomeSketch` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Croquis de domicilio verificado. |
| `hasFelccRecord` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | **Antecedentes policiales (Obligatorio en Seguridad).** |
| `hasPhoto3x4` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Fotografía fondo rojo 3x4. |
| `hasSusInsurance` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Constancia de afiliación al seguro de salud. |
| `photoUrl` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Avatar / fotografía digital del colaborador. |
| `corporateEmail` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Correo institucional para acceso a la APK. |
| `temporaryPassword`| `String?` | Sí | RRHH | ❌ No | ❌ No | ❌ No | 🔒 SÍ | Credencial de un solo uso. Nunca exponer en API pública. |
| `applicantId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Trazabilidad con el postulante de origen. |
| `exitDate` | `DateTime?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Fecha efectiva de baja laboral. |
| `exitReason` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Causal legal de desvinculación. |
| `exitObservations` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Detalle o entrega de puesto. |
| `exitRegisteredBy` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Responsable administrativo de registrar la baja. |
| `isDeleted` | `bool` | No | RRHH | Default | ❌ No | ❌ No | 🌐 No | Eliminación lógica (Soft-delete). |
| `deletedAt` | `DateTime?` | Sí | RRHH | ❌ No | ❌ No | ❌ No | 🌐 No | Auditoría de borrado lógico. |
| `createdAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Sello de tiempo de creación en BD. |
| `updatedAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Sello de tiempo de última actualización. |

---

### 2.2 Entidad: `RrhhApplicant` (Candidatos y Reclutamiento)
**Tabla:** `rrhh_applicant` | **Propósito:** Pipeline de selección previo a la contratación formal.

| Campo | Tipo Dart | Nullable | Origen | Obligatorio | Visible Listado | Visible Detalle | Sensible | Notas |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| `id` | `int` | No (PK) | RRHH | Auto | ✅ Sí | ✅ Sí | 🌐 No | Clave primaria. |
| `code` | `String` | No (UK) | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Código identificador (`POST-001`). |
| `fullName` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre completo del candidato. |
| `identityCard` | `String` | No (IDX)| RRHH | ✅ Sí | ❌ No | ✅ Sí | 🔒 SÍ | Cédula de identidad. |
| `phone` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🔒 SÍ | Celular para citas de entrevista. |
| `email` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Correo personal de contacto. |
| `address` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Dirección de residencia. |
| `birthDate` | `DateTime?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Fecha de nacimiento. |
| `emergencyContact` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Contacto de emergencia. |
| `emergencyPhone` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Teléfono de emergencia. |
| `targetArea` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Área a la que aspira. |
| `areaId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhArea`. |
| `targetPosition` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Cargo pretendido. |
| `positionId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhPosition`. |
| `targetType` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'OFICINA'` o `'CAMPO'`. |
| `specialty` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Especialidad técnica (Limpieza, etc.). |
| `specialtyId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Relación con `RrhhSpecialty`. |
| `education` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Grado de instrucción académica. |
| `experienceSummary`| `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Síntesis curricular. |
| `skills` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Competencias declaradas. |
| `referencePerson` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Referencia laboral o personal. |
| `referencePhone` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Teléfono de la referencia. |
| `applicationDate` | `DateTime` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Fecha de recepción de postulación. |
| `status` | `String` | No (IDX)| RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | `'NUEVO'`, `'EN_EVALUACION'`, `'SELECCIONADO'`, `'RECHAZADO'`, `'CONTRATADO'`. |
| `interviewNotes` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Evaluación cualitativa de RRHH. |
| `expectedSalary` | `double?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🔒 SÍ | Pretensión salarial en Bs. |
| `hasCvAttached` | `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Verificación de hoja de vida adjunta. |
| `hasIdentityCardCopy`| `bool` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Verificación de fotocopia de CI. |
| `cvUrl` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Enlace a PDF del CV en almacenamiento. |
| `discardReason` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Causal de descarte si fue rechazado. |
| `isDeleted` | `bool` | No | RRHH | Default | ❌ No | ❌ No | 🌐 No | Soft delete. |
| `deletedAt` | `DateTime?` | Sí | RRHH | ❌ No | ❌ No | ❌ No | 🌐 No | Fecha de soft delete. |
| `createdAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Auditoría temporal. |
| `updatedAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Auditoría temporal. |

---

### 2.3 Entidades Estructurales: Organización y Puestos
* **`RrhhArea` (Departamentos Corporativos):**
  * `id` (`int`, PK), `code` (`String`, UK), `name` (`String`, UK), `description` (`String?`), `colorTag` (`String?`), `isActive` (`bool`), auditoría.
  * *Sensibilidad:* 🌐 No. Pública para filtros de empleados y cargos.
* **`RrhhPosition` (Cargos y Puestos):**
  * `id` (`int`, PK), `code` (`String`, UK), `areaId` (`int`, FK), `name` (`String`), `workplaceType` (`String`: `'Oficina'`/`'Campo'`), `suggestedSalary` (`double?`), `description` (`String?`), `requirements` (`String?`), `isActive` (`bool`), auditoría.
  * *Sensibilidad:* `suggestedSalary` es 🔒 SÍ (orientativo interno).
* **`RrhhSpecialty` (Especialidades Operativas de Campo):**
  * `id` (`int`, PK), `code` (`String`, UK), `name` (`String`, UK), `description` (`String?`), `colorTag` (`String?`), `isActive` (`bool`), auditoría.
  * *Sensibilidad:* 🌐 No. Insumo fundamental exportado a Operaciones (`→ Operaciones`).

---

### 2.4 Entidad: `RrhhSchedule` (Catálogo de Turnos y Jornadas Base)
**Tabla:** `rrhh_schedule` | **Propósito:** Catálogo de jornadas teóricas que RRHH publica a Operaciones (Sección 4.1 y 4.2).

| Campo | Tipo Dart | Nullable | Origen | Obligatorio | Visible Listado | Visible Detalle | Sensible | Notas |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| `id` | `int` | No (PK) | RRHH | Auto | ✅ Sí | ✅ Sí | 🌐 No | Clave primaria. |
| `code` | `String` | No (UK) | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Código identificador (`SCH-001`). |
| `name` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre (`Administrativo Central`). |
| `targetType` | `String` | No (IDX)| RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | `'OFICINA'`, `'CAMPO'`, `'AMBOS'`. |
| `startTime` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Formato `HH:mm` (ej: `"08:30"`). |
| `endTime` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Formato `HH:mm` (ej: `"17:30"`). |
| `workDays` | `List<int>`| No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Días laborables `[1, 2, 3, 4, 5]`. |
| `toleranceMinutes`| `int` | No | RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | Tolerancia de atraso (ej: 10 o 15 min). |
| `isNightShift` | `bool` | No | RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | Bandera para recargos nocturnos legales. |
| `description` | `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Observaciones de alcance. |
| `isActive` | `bool` | No (IDX)| RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | Vigencia en catálogo corporativo. |
| `isDeleted` | `bool` | No | RRHH | Default | ❌ No | ❌ No | 🌐 No | Soft delete. |
| `createdAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Auditoría temporal. |
| `updatedAt` | `DateTime` | No | RRHH | Auto | ❌ No | ✅ Sí | 🌐 No | Auditoría temporal. |

---

### 2.5 Entidad: `RrhhAssignment` (Asignación Contractual / Puesto Base)
**Tabla:** `rrhh_assignment` | **Propósito:** Registro del puesto convenido del trabajador.  
> ⚠️ **REGLA DE FRONTERA:** Esta entidad registra el puesto base contractual. **No debe usarse para el despacho operativo diario de cuadrillas** (eso pertenece a Operaciones/APK).

| Campo | Tipo Dart | Nullable | Origen | Obligatorio | Visible Listado | Visible Detalle | Sensible | Notas de Frontera |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|---|
| `id` | `int` | No (PK) | RRHH | Auto | ✅ Sí | ✅ Sí | 🌐 No | Identificador interno. |
| `code` | `String` | No (UK) | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Código correlativo (`ASG-001`). |
| `employeeId` | `int` (FK) | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Relación estricta con `RrhhEmployee`. |
| `employeeCode` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Código desnormalizado para reportes. |
| `employeeName` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre desnormalizado para auditoría. |
| `assignmentType`| `String` | No (IDX)| RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | `'OFICINA'` o `'CAMPO'`. |
| `officeAreaId` | `int?` (FK) | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Si es oficina: departamento interno. |
| `officeAreaName`| `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Nombre del área interna. |
| `officeRole` | `String?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Rol en oficina. |
| `customerId` | `int?` | Sí | **CRM** | ❌ No | ❌ No | ✅ Sí | 🌐 No | **Referencia externa débil a cliente CRM.** |
| `customerCompanyName`| `String?`| Sí | **CRM** | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | **Nombre de cliente (Solo Lectura).** |
| `workplaceBranch`| `String?` | Sí | **CRM** | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | **Sucursal o sede física (Solo Lectura).** |
| `contractedServiceName`|`String?`| Sí | **CRM** | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | **Servicio del contrato (Solo Lectura).** |
| `supervisorName`| `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre del supervisor responsable. |
| `supervisorEmployeeId`|`int?`(FK)| Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Supervisor si es empleado interno. |
| `scheduleId` | `int` (FK) | No | RRHH | ✅ Sí | ❌ No | ✅ Sí | 🌐 No | Horario base asignado (`RrhhSchedule`). |
| `scheduleName` | `String` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Nombre de turno desnormalizado. |
| `startDate` | `DateTime` | No | RRHH | ✅ Sí | ✅ Sí | ✅ Sí | 🌐 No | Fecha de inicio en el puesto. |
| `endDate` | `DateTime?` | Sí | RRHH | ❌ No | ✅ Sí | ✅ Sí | 🌐 No | Fecha de conclusión si concluyó. |
| `status` | `String` | No (IDX)| RRHH | Default | ✅ Sí | ✅ Sí | 🌐 No | `'ACTIVA'`, `'FINALIZADA'`, `'CANCELADA'`. |
| `rotationNumber`| `int` | No | RRHH | Default | ❌ No | ✅ Sí | 🌐 No | Correlativo de rotación (0=Base). |
| `originDescription`|`String?`| Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Destino anterior para trazabilidad. |
| `rotationReason`| `String?` | Sí | RRHH | ❌ No | ❌ No | ✅ Sí | 🌐 No | Justificación del cambio de sede. |
| `isDeleted` | `bool` | No | RRHH | Default | ❌ No | ❌ No | 🌐 No | Soft delete. |

---

### 2.6 Entidades Laborales: Permisos, Vacaciones, Incidencias y Desvinculación

#### A) `RrhhLeaveRequest` (Permisos y Licencias)
* **Tabla:** `rrhh_leave_request` | **Propósito:** Administración de ausencias justificadas (Sección 4.1).
* **Campos:**
  * `id` (`int`, PK), `code` (`String`, UK).
  * `employeeId` (`int`, FK), `employeeCode` (`String`), `employeeName` (`String`).
  * `leaveType` (`String`: `'MEDICA'`, `'PERSONAL'`, `'DUELO'`, `'MATERNIDAD_PATERNIDAD'`, `'ESTUDIO'`).
  * `startDate` (`DateTime`), `endDate` (`DateTime`), `daysCount` (`int`), `hoursCount` (`double?`).
  * `reason` (`String`).
  * `medicalCertificateNumber` (`String?`: N° de baja médica CNS — 🔒 SÍ).
  * `attachmentUrl` (`String?`: Comprobante adjunto).
  * `status` (`String`: `'PENDIENTE'`, `'APROBADO'`, `'RECHAZADO'`, `'CANCELADO'`).
  * `resolutionNotes` (`String?`), `resolvedByUserId` (`int?`), `resolvedAt` (`DateTime?`).
  * Auditoría temporal y soft delete.

#### B) `RrhhVacation` (Vacaciones por Antigüedad Legal)
* **Tabla:** `rrhh_vacation` | **Propósito:** Cómputo según escala de la Ley General del Trabajo de Bolivia (Sección 4.1).
* **Campos:**
  * `id` (`int`, PK), `code` (`String`, UK).
  * `employeeId` (`int`, FK), `employeeCode` (`String`), `employeeName` (`String`).
  * `periodYear` (`int`: Gestión anual correspondiente, ej: `2026`).
  * `startDate` (`DateTime`), `endDate` (`DateTime`), `daysRequested` (`int`).
  * `totalAccruedDays` (`int`: Días devengados de ley — 15, 20 o 30).
  * `remainingBalanceDays` (`int`: Saldo restante post-solicitud).
  * `status` (`String`: `'SOLICITADA'`, `'APROBADA'`, `'EN_CURSO'`, `'COMPLETADA'`, `'RECHAZADA'`).
  * `approvedByUserId` (`int?`), `approvedAt` (`DateTime?`), `notes` (`String?`).
  * Auditoría temporal y soft delete.

#### C) `RrhhIncident` (Régimen Disciplinario e Incidencias)
* **Tabla:** `rrhh_incident` | **Propósito:** Registro formal de memorándums, sanciones y felicitaciones (Sección 4.1).
* **Campos:**
  * `id` (`int`, PK), `code` (`String`, UK).
  * `employeeId` (`int`, FK), `employeeCode` (`String`), `employeeName` (`String`).
  * `incidentType` (`String`: `'FALTA_INJUSTIFICADA'`, `'ATRASO_REITERADO'`, `'LLAMADO_ATENCION_LEVE'`, `'MEMORANDUM_GRAVE'`, `'SUSPENSION_TEMPORAL'`, `'FELICITACION'`, `'RECONOCIMIENTO'`).
  * `severity` (`String`: `'POSITIVA'`, `'LEVE'`, `'MODERADA'`, `'GRAVE'`).
  * `incidentDate` (`DateTime`), `title` (`String`), `description` (`String`).
  * `actionTaken` (`String`: Medida correctiva aplicada), `isJustified` (`bool`).
  * `recordedByUserId` (`int?`), `documentReferenceUrl` (`String?`: PDF del memorándum firmado).
  * Auditoría temporal y soft delete.

#### D) `RrhhTermination` (Desvinculación Formal Inmutable)
* **Tabla:** `rrhh_termination` | **Propósito:** Egreso laboral sin borrado físico (Regla de Oro, Sección 4.1 y 7).
* **Campos:**
  * `id` (`int`, PK), `code` (`String`, UK).
  * `employeeId` (`int`, FK), `employeeCode` (`String`), `employeeName` (`String`), `employeeCi` (`String` — 🔒 SÍ).
  * `contractType` (`String`), `entryDate` (`DateTime`), `terminationDate` (`DateTime`), `lastWorkingDay` (`DateTime`).
  * `reason` (`String`: `'RENUNCIA_VOLUNTARIA'`, `'FIN_DE_CONTRATO'`, `'DESPIDO_JUSTIFICADO'`, `'DESPIDO_INJUSTIFICADO'`, `'MUTUO_ACUERDO'`, `'JUBILACION'`).
  * `detailedReason` (`String`).
  * `yearsOfService` (`double`: Antigüedad computada para finiquito).
  * `severanceAmount` (`double?`: Monto pactado de liquidación en Bs. — 🔒 SÍ).
  * `clearanceCompleted` (`bool`: Paz y salvo / entrega de activos completada).
  * `isEligibleForRehire` (`bool`: Bandera de recontratación futura).
  * `processedByUserId` (`int?`), `handoverNotes` (`String?`), `createdAt` (`DateTime`).

---

### 2.7 Entidades de Soporte y Auditoría: Timeline, Documentos y Movimientos
* **`RrhhTimelineEvent` (Línea de Tiempo del Empleado):**
  * `id` (`int`, PK), `employeeId` (`int`, FK en cascada), `date` (`DateTime`), `title` (`String`), `description` (`String`), `category` (`String`: `'CONTRATACION'`, `'ASIGNACION'`, `'HORARIO'`, `'PERMISO'`, `'INCIDENCIA'`, `'DESVINCULACION'`), `registeredBy` (`String`), `createdAt` (`DateTime`).
* **`RrhhEmployeeDocument` (Expediente Digital):**
  * `id` (`int`, PK), `employeeId` (`int`, FK en cascada), `documentType` (`String`: `'CI'`, `'AVISO_LUZ_AGUA'`, `'CROQUIS'`, `'FELCC'`, `'FOTO'`, `'SEGURO_SUS'`, `'CONTRATO_FIRMADO'`, `'FINIQUITO'`), `title` (`String`), `fileUrl` (`String`), `fileName` (`String`), `fileSizeBytes` (`int?`), `mimeType` (`String?`), `isVerified` (`bool`), `verifiedBy` (`String?`), `verifiedAt` (`DateTime?`), auditoría.
* **`RrhhMovementHistory` (Bitácora Inmutable de Movimientos):**
  * `id` (`int`, PK), `employeeId` (`int`, FK), `employeeCode` (`String`), `employeeName` (`String`), `movementType` (`String`: `'INGRESO'`, `'ASCENSO'`, `'TRASLADO_AREA'`, `'ROTACION_SEDE'`, `'AJUSTE_SALARIAL'`, `'CAMBIO_TURNO'`, `'SUSPENSION'`, `'DESVINCULACION'`, `'REINCORPORACION'`), `previousValue` (`String?`), `newValue` (`String`), `effectiveDate` (`DateTime`), `reason` (`String`), `authorizedBy` (`String`), `createdAt` (`DateTime`).

---

## 3. Análisis de Brechas del Esquema Actual (.spy.yaml)

### 3.1 Lista A: Campos que FALTAN según el PDF (Requisitos Omitidos)

1. **Atributos de Asistencia y Telemetría de Campo (Sección 4.3):**
   * *Diagnóstico:* Falta una entidad relacional o modelo DTO para consolidar los datos que envía la APK de Operaciones a RRHH:
     * `checkInScheduled` (`DateTime`) vs `checkInReal` (`DateTime`).
     * `checkOutScheduled` (`DateTime`) vs `checkOutReal` (`DateTime`).
     * `delayMinutes` (`int`): Minutos de retraso acumulados.
     * `attendanceStatus` (`String`: `'PUNTUAL'`, `'ATRASO'`, `'FALTA_INJUSTIFICADA'`, `'JUSTIFICADA'`).
     * `effectiveHoursWorked` (`double`): Horas netas de campo.
2. **Entidad Formal de Ajustes Salariales para Nómina (Sección 6.1):**
   * *Diagnóstico:* RRHH debe entregar a Contabilidad: *"Bonificaciones / descuentos autorizados"*. Actualmente en el backend no existe una tabla `rrhh_salary_adjustment` (solo existe un mock suelto en la RAM del frontend). Se requiere formalizar este contrato:
     * `adjustmentType`: `'BONO_PUNTUALIDAD'`, `'ANTICIPO'`, `'DESCUENTO_AUTORIZADO'`, `'REPOSICION_CREDENCIAL'`.
     * `amount`: `double`.
     * `authorizationProofUrl`: `String?`.
3. **Expedición del Documento de Identidad (CI):**
   * *Diagnóstico:* En Bolivia, el CI exige el departamento de emisión (`ciExtension`: `'SC'`, `'LP'`, `'CB'`, `'OR'`, `'PT'`, `'TJ'`, `'CH'`, `'BE'`, `'PA'`). Falta este campo en `RrhhEmployee` y `RrhhApplicant`.
4. **Género / Sexo del Trabajador:**
   * *Diagnóstico:* La Ley General del Trabajo de Bolivia establece una jornada laboral de 48 horas semanales para varones y 40 horas semanales para mujeres (D.S. 21060). Falta el campo `gender` (`String`: `'MASCULINO'`, `'FEMENINO'`) para validar el cumplimiento legal de horas de los turnos.

---

### 3.2 Lista B: Campos que SOBRAN en los .spy.yaml (Violación de Fronteras)

1. **En `RrhhAssignment`:**
   * `officeRole` y `contractedServiceName`: Duplican información comercial que proviene del CRM y del perfil del puesto.
   * `workplaceBranch`: Almacena texto libre en vez de basarse únicamente en el identificador `customerId` y `branchId` del CRM.
2. **En `RrhhEmployee`:**
   * `workplace` (`String`) y `supervisor` (`String`): Guardados como campos de texto rígidos en el maestro del empleado. En una empresa de multiservicios, el lugar de trabajo y el supervisor cambian constantemente según la asignación de Operaciones. Estos campos deben ser **virtuales o derivados** de la última asignación activa reportada, no estar quemados en el expediente fijo.

---

### 3.3 Lista C: Campos Mal Tipados o Mal Nombrados

1. **`RrhhApplicant.skills` (`String?`) vs `RrhhEmployee.skills` (`List<String>?`):**
   * En el postulante se guardó como un texto plano (`String?`), mientras que en el empleado es una lista tipada (`List<String>?`). Al contratar al postulante en `hireApplicant`, se genera una inconsistencia de conversión de tipos. Ambos deben ser `List<String>?`.
2. **`RrhhApplicant.expectedSalary` (`default=0.0`):**
   * Usar `0.0` como valor por defecto enmascara si el candidato no especificó su pretensión o si realmente pretende 0 Bs. Debe ser `double?` con valor nulo por defecto.
3. **`RrhhSchedule.startTime` y `RrhhSchedule.endTime` (`String`):**
   * Se almacenan como texto plano `"08:30"`. Aunque facilita la lectura rápida, no valida rangos de minutos ni formato válido de 24 horas. Deben validarse con expresión regular `^([01]\d|2[0-3]):([0-5]\d)$`.
4. **`RrhhTermination.yearsOfService` (`double`):**
   * Es un dato redundante que puede provocar inconsistencias si difiere del cálculo matemático entre `entryDate` y `terminationDate`. Debe ser un getter calculado o garantizarse en el repositorio.

---

## 4. Modelos Propuestos para el Frontend Flutter

Para resolver la duplicidad actual y proteger los datos sensibles, el frontend consumirá **tres categorías de modelos**:

```
                       ARQUITECTURA DE MODELOS EN FRONTEND
                                       │
        ┌──────────────────────────────┼──────────────────────────────┐
        ▼                              ▼                              ▼
  1. MODELOS COMPLETOS           2. DTOs REDUCIDOS             3. MODELOS REF
   (Ficha Detalle / Edit)       (Listados & Tablas)         (Lectura Intermodular)
   • RrhhEmployeeDetail          • RrhhEmployeeSummaryDto    • CrmClientRefDto
   • RrhhApplicantDetail         • RrhhApplicantSummaryDto   • OpsFieldAttendanceDto
   • RrhhLaborFullRecord         • RrhhScheduleSummaryDto    • ContabPayrollInputDto
```

### 4.1 Categoría 1: Modelos Completos (Ficha de Detalle y Formularios)
Utilizan directamente las clases cliente generadas por Serverpod (`package:elite_multiservicios_client`):
* **`RrhhEmployee`:** Contiene todos los campos del expediente, checklist de documentos y credenciales institucionales. Se descarga **únicamente** cuando el usuario abre el modal o pantalla de detalle de un trabajador específico.
* **`RrhhApplicant`:** Contiene evaluación, teléfono de emergencia, notas de entrevista y pretensión salarial.
* **`RrhhTermination`:** Ficha de finiquito y liquidación legal.

### 4.2 Categoría 2: DTOs Reducidos (Listados Generales y Tablas)
Diseñados para optimizar el ancho de banda y **bloquear la fuga de datos sensibles**:
* **`RrhhEmployeeSummaryDto`:**
  ```dart
  class RrhhEmployeeSummaryDto {
    final int id;
    final String code;             // EMP-001
    final String fullName;         // Juan Carlos Pérez
    final String? photoUrl;
    final String employeeType;     // OFICINA / CAMPO
    final String area;             // Operaciones
    final String position;         // Guardia de Seguridad
    final String specialty;        // Seguridad Física
    final String workplace;        // Ventura Mall
    final String status;           // ACTIVO
    final String availabilityStatus; // DISPONIBLE / ASIGNADO
    final DateTime realStartDate;  // Antigüedad
    final int attachedDocsCount;   // 6/6
    // 🔒 EXCLUIDOS: agreedSalary, identityCard, address, phone, temporaryPassword
  }
  ```
* **`RrhhApplicantSummaryDto`:**
  ```dart
  class RrhhApplicantSummaryDto {
    final int id;
    final String code;             // POST-001
    final String fullName;
    final String targetType;       // CAMPO
    final String targetPosition;   // Jardinero
    final String specialty;        // Jardinería
    final String status;           // SELECCIONADO
    final DateTime applicationDate;
    final bool hasCv;
    // 🔒 EXCLUIDOS: expectedSalary, identityCard, emergencyContact
  }
  ```

### 4.3 Categoría 3: Modelos de Solo Lectura (Integración Intermodular)
Modelos ligeros para renderizar referencias externas sin acoplar las bases de datos:
* **`CrmClientRefDto` (Consumo desde CRM):**
  * `customerId` (`int`), `companyName` (`String`), `workplaceBranch` (`String`), `contractId` (`int`).
* **`OpsAttendanceSummaryDto` (Consumo desde Operaciones/APK — Sección 4.3):**
  * `employeeId` (`int`), `workDate` (`DateTime`), `scheduledCheckIn` (`String`), `realCheckIn` (`String`), `delayMinutes` (`int`), `status` (`String`), `hoursWorked` (`double`).
* **`RrhhPayrollExportDto` (Entrega a Contabilidad — Sección 6.1):**
  * `employeeId` (`int`), `employeeCode` (`String`), `fullName` (`String`), `identityCard` (`String`), `contractType` (`String`), `baseSalary` (`double`), `daysWorked` (`int`), `authorizedBonuses` (`double`), `authorizedDeductions` (`double`).

---

## 5. Matriz de Autorización y Gobernanza de Datos (RBAC)

| Entidad / Flujo | Permiso Requerido (Lectura) | Permiso Requerido (Mutación) | Regla de Gobernanza |
|---|---|---|---|
| **Directorio de Personal** | `rrhh.personal.view` | `rrhh.personal.manage` | Lectura solo expone `RrhhEmployeeSummaryDto`. Mutación audita usuario y fecha. |
| **Salario y Compensación** | `rrhh.compensation.view` | `rrhh.compensation.manage` | Solo accesible por Gerencia y Jefatura de RRHH. Prohibido a supervisores. |
| **Postulantes y Reclutamiento** | `rrhh.personal.view` | `rrhh.personal.manage` | Contratar promueve automáticamente a `RrhhEmployee`. |
| **Catálogo de Horarios** | `rrhh.assignments.view` | `rrhh.assignments.manage` | Turnos publicados quedan inmediatamente visibles para Operaciones. |
| **Permisos y Vacaciones** | `rrhh.labor.view` | `rrhh.labor.manage` | Aprobación actualiza disponibilidad a `'CON_PERMISO'` o `'DE_VACACIONES'`. |
| **Desvinculación Laboral** | `rrhh.labor.manage` | `rrhh.labor.manage` | **Prohibido borrado físico.** Pasa a `'INACTIVO'` y cierra asignaciones activas. |
| **Consolidado para Nómina** | `rrhh.reports.view` | `rrhh.reports.manage` | Congelamiento de corte mensual para entrega formal a Contabilidad. |
