import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import 'rrhh_personnel_repository.dart';

/// Repositorio relacional para la gestión de Horarios, Turnos, Asignaciones Operativas
/// y Rotaciones Inmutables en PostgreSQL según la delimitación de RRHH.
class RrhhOperationsRepository {
  final Session session;

  const RrhhOperationsRepository(this.session);

  // ===========================================================================
  // 1. HORARIOS Y TURNOS (RRHH_SCHEDULE)
  // ===========================================================================

  /// Lista los turnos y horarios con filtros por tipo de entorno ('OFICINA', 'CAMPO', 'AMBOS'),
  /// estado activo o búsqueda por nombre/código.
  Future<List<RrhhSchedule>> listSchedules({
    String? targetType,
    bool? isActive,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhSchedule.db.find(
      session,
      where: (t) {
        var expr = includeDeleted
            ? Constant.bool(true)
            : t.isDeleted.equals(false);
        if (targetType != null &&
            targetType.trim().isNotEmpty &&
            targetType != 'TODOS') {
          expr =
              expr &
              (t.targetType.equals(targetType.trim().toUpperCase()) |
                  t.targetType.equals('AMBOS'));
        }
        if (isActive != null) {
          expr = expr & t.isActive.equals(isActive);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr = expr & (t.name.ilike(query) | t.code.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.code,
      limit: limit,
      offset: offset,
    );
  }

  /// Obtiene un turno por su ID.
  Future<RrhhSchedule?> getScheduleById(int id) async {
    return await RrhhSchedule.db.findById(session, id);
  }

  /// Obtiene un turno por su código único.
  Future<RrhhSchedule?> getScheduleByCode(String code) async {
    return await RrhhSchedule.db.findFirstRow(
      session,
      where: (t) =>
          t.code.equals(code.trim().toUpperCase()) & t.isDeleted.equals(false),
    );
  }

  /// Crea un nuevo turno en catálogo con validación de código único y auto-generación correlativa.
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule) async {
    final now = DateTime.now().toUtc();
    var code = schedule.code.trim().toUpperCase();

    if (code.isEmpty) {
      final total = await RrhhSchedule.db.count(session);
      code = 'SCH-${(total + 1).toString().padLeft(3, '0')}';
    }

    final existing = await getScheduleByCode(code);
    if (existing != null) {
      throw ArgumentError(
        'Ya existe un horario registrado con el código $code.',
      );
    }

    final sanitized = schedule.copyWith(
      code: code,
      name: schedule.name.trim(),
      targetType: schedule.targetType.trim().toUpperCase(),
      startTime: schedule.startTime.trim(),
      endTime: schedule.endTime.trim(),
      workDays: schedule.workDays.isNotEmpty
          ? schedule.workDays
          : [1, 2, 3, 4, 5],
      toleranceMinutes: schedule.toleranceMinutes > 0
          ? schedule.toleranceMinutes
          : 10,
      isNightShift: schedule.isNightShift,
      description: schedule.description?.trim(),
      isActive: schedule.isActive,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    return await RrhhSchedule.db.insertRow(session, sanitized);
  }

  /// Actualiza los parámetros de un turno.
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule) async {
    final existing = await getScheduleById(schedule.id!);
    if (existing == null) {
      throw ArgumentError('No se encontró el horario con ID ${schedule.id}.');
    }

    final now = DateTime.now().toUtc();
    final updated = existing.copyWith(
      name: schedule.name.trim(),
      targetType: schedule.targetType.trim().toUpperCase(),
      startTime: schedule.startTime.trim(),
      endTime: schedule.endTime.trim(),
      workDays: schedule.workDays,
      toleranceMinutes: schedule.toleranceMinutes,
      isNightShift: schedule.isNightShift,
      description: schedule.description?.trim(),
      isActive: schedule.isActive,
      updatedAt: now,
    );

    return await RrhhSchedule.db.updateRow(session, updated);
  }

  /// Soft delete de un turno.
  Future<bool> deleteSchedule(int id) async {
    final existing = await getScheduleById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhSchedule.db.updateRow(
      session,
      existing.copyWith(
        isActive: false,
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );
    return true;
  }

  // ===========================================================================
  // 2. ASIGNACIONES OPERATIVAS (RRHH_ASSIGNMENT)
  // ===========================================================================

  /// Lista asignaciones con filtros por estado ('TODAS', 'ACTIVA', 'FINALIZADA', 'CANCELADA'),
  /// modalidad ('TODOS', 'OFICINA', 'CAMPO'), colaborador, cliente o búsqueda por texto.
  Future<List<RrhhAssignment>> listAssignments({
    String? status,
    String? assignmentType,
    int? employeeId,
    int? customerId,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhAssignment.db.find(
      session,
      where: (t) {
        var expr = includeDeleted
            ? Constant.bool(true)
            : t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty && status != 'TODAS') {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (assignmentType != null &&
            assignmentType.trim().isNotEmpty &&
            assignmentType != 'TODOS') {
          expr =
              expr &
              t.assignmentType.equals(assignmentType.trim().toUpperCase());
        }
        if (employeeId != null) {
          expr = expr & t.employeeId.equals(employeeId);
        }
        if (customerId != null) {
          expr = expr & t.customerId.equals(customerId);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr =
              expr &
              (t.employeeName.ilike(query) |
                  t.employeeCode.ilike(query) |
                  t.customerCompanyName.ilike(query) |
                  t.officeAreaName.ilike(query) |
                  t.supervisorName.ilike(query) |
                  t.code.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.startDate,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Obtiene una asignación por su ID.
  Future<RrhhAssignment?> getAssignmentById(int id) async {
    return await RrhhAssignment.db.findById(session, id);
  }

  /// Obtiene la asignación ACTIVA de un colaborador (si existe).
  Future<RrhhAssignment?> getActiveAssignmentByEmployee(int employeeId) async {
    return await RrhhAssignment.db.findFirstRow(
      session,
      where: (t) =>
          t.employeeId.equals(employeeId) &
          t.status.equals('ACTIVA') &
          t.isDeleted.equals(false),
    );
  }

  /// Historial de rotaciones y asignaciones pasadas de un colaborador (inmutable).
  Future<List<RrhhAssignment>> getRotationHistory(int employeeId) async {
    return await RrhhAssignment.db.find(
      session,
      where: (t) => t.employeeId.equals(employeeId) & t.isDeleted.equals(false),
      orderBy: (t) => t.rotationNumber,
      orderDescending: true,
    );
  }

  /// Crea una nueva asignación operativa para un colaborador.
  /// Sincroniza la disponibilidad del empleado a 'ASIGNADO' e inscribe el evento en su línea de tiempo.
  Future<RrhhAssignment> createAssignment(RrhhAssignment assignment) async {
    final now = DateTime.now().toUtc();

    // 1. Validar que el empleado exista y esté activo
    final employee = await RrhhEmployee.db.findById(
      session,
      assignment.employeeId,
    );
    if (employee == null || employee.isDeleted) {
      throw ArgumentError(
        'El empleado con ID ${assignment.employeeId} no existe.',
      );
    }
    if (employee.status != 'ACTIVO') {
      throw StateError(
        'No se puede asignar al colaborador ${employee.fullName} porque su estado es ${employee.status}.',
      );
    }

    // 2. Si ya tiene una asignación activa previa, se finaliza ordenadamente
    final prevActive = await getActiveAssignmentByEmployee(
      assignment.employeeId,
    );
    if (prevActive != null) {
      await RrhhAssignment.db.updateRow(
        session,
        prevActive.copyWith(
          status: 'FINALIZADA',
          endDate: now,
          updatedAt: now,
        ),
      );
    }

    // 3. Generar código correlativo de asignación
    var code = assignment.code.trim().toUpperCase();
    if (code.isEmpty) {
      final total = await RrhhAssignment.db.count(session);
      code = 'ASG-${(total + 1).toString().padLeft(3, '0')}';
    }

    // 4. Validar turno/horario
    final schedule = await RrhhSchedule.db.findById(
      session,
      assignment.scheduleId,
    );
    final scheduleName = schedule?.name ?? assignment.scheduleName;

    final sanitized = assignment.copyWith(
      code: code,
      employeeId: employee.id!,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      assignmentType: assignment.assignmentType.trim().toUpperCase(),
      officeAreaId: assignment.officeAreaId,
      officeAreaName: assignment.officeAreaName?.trim(),
      officeRole: assignment.officeRole?.trim(),
      customerId: assignment.customerId,
      customerCompanyName: assignment.customerCompanyName?.trim(),
      workplaceBranch: assignment.workplaceBranch?.trim(),
      contractedServiceName: assignment.contractedServiceName?.trim(),
      supervisorName: assignment.supervisorName.trim(),
      supervisorEmployeeId: assignment.supervisorEmployeeId,
      scheduleId: assignment.scheduleId,
      scheduleName: scheduleName,
      startDate: assignment.startDate,
      endDate: assignment.endDate,
      status: 'ACTIVA',
      rotationNumber: assignment.rotationNumber >= 0
          ? assignment.rotationNumber
          : 0,
      originDescription: assignment.originDescription?.trim(),
      rotationReason: assignment.rotationReason?.trim(),
      notes: assignment.notes?.trim(),
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await RrhhAssignment.db.insertRow(session, sanitized);

    // 5. Actualizar estado y sede en el expediente del empleado
    final newWorkplace = inserted.assignmentType == 'OFICINA'
        ? (inserted.officeAreaName != null
              ? 'Oficina Central - ${inserted.officeAreaName}'
              : 'Oficina Central Elite')
        : '${inserted.customerCompanyName ?? "Cliente"} (${inserted.workplaceBranch ?? "Principal"})';

    await RrhhEmployee.db.updateRow(
      session,
      employee.copyWith(
        availabilityStatus: 'ASIGNADO',
        workplace: newWorkplace,
        supervisor: inserted.supervisorName,
        supervisorId: inserted.supervisorEmployeeId,
        updatedAt: now,
      ),
    );

    // 6. Registrar evento en la línea de tiempo del empleado
    final personnelRepo = RrhhPersonnelRepository(session);
    await personnelRepo.addTimelineEvent(
      RrhhTimelineEvent(
        employeeId: employee.id!,
        title: inserted.rotationNumber > 0
            ? 'Rotación #${inserted.rotationNumber}: $newWorkplace'
            : 'Asignación Inicial: $newWorkplace',
        description: inserted.rotationNumber > 0
            ? 'Rotó desde: ${inserted.originDescription ?? "Destino Anterior"}. Turno: $scheduleName. Motivo: ${inserted.rotationReason ?? "Reorganización de cuadrilla"}'
            : 'Asignado a $newWorkplace bajo supervisión de ${inserted.supervisorName}. Turno: $scheduleName.',
        date: now,
        category: 'ASIGNACION',
        registeredBy: 'RRHH - Asignaciones',
        createdAt: now,
      ),
    );

    return inserted;
  }

  /// Ejecuta una rotación operativa preservando el historial inmutable (Regla de Oro de Auditoría).
  /// Finaliza la asignación previa, crea la nueva con `rotationNumber` incrementado y registra trazabilidad.
  Future<RrhhAssignment> rotateAssignment({
    required int currentAssignmentId,
    required String newAssignmentType, // 'OFICINA' | 'CAMPO'
    int? newOfficeAreaId,
    String? newOfficeAreaName,
    String? newOfficeRole,
    int? newCustomerId,
    String? newCustomerCompanyName,
    String? newWorkplaceBranch,
    String? newContractedServiceName,
    required int newScheduleId,
    required String newSupervisorName,
    int? newSupervisorEmployeeId,
    required String rotationReason,
    String? notes,
  }) async {
    final now = DateTime.now().toUtc();

    // 1. Obtener la asignación actual
    final current = await getAssignmentById(currentAssignmentId);
    if (current == null) {
      throw ArgumentError(
        'No se encontró la asignación con ID $currentAssignmentId.',
      );
    }

    final originDestination = current.assignmentType == 'OFICINA'
        ? 'Oficina Central (${current.officeAreaName ?? "General"})'
        : '${current.customerCompanyName ?? "Cliente"} - ${current.workplaceBranch ?? "Sede"} (${current.contractedServiceName ?? "Servicio"})';

    // 2. Finalizar la asignación previa
    await RrhhAssignment.db.updateRow(
      session,
      current.copyWith(
        status: 'FINALIZADA',
        endDate: now,
        updatedAt: now,
      ),
    );

    // 3. Crear la nueva asignación incrementando el número de rotación
    final nextRotationNumber = current.rotationNumber + 1;
    final total = await RrhhAssignment.db.count(session);
    final nextCode = 'ASG-${(total + 1).toString().padLeft(3, '0')}';

    final schedule = await RrhhSchedule.db.findById(session, newScheduleId);
    final scheduleName = schedule?.name ?? 'Horario Asignado';

    final newAssignment = RrhhAssignment(
      code: nextCode,
      employeeId: current.employeeId,
      employeeCode: current.employeeCode,
      employeeName: current.employeeName,
      assignmentType: newAssignmentType.trim().toUpperCase(),
      officeAreaId: newOfficeAreaId,
      officeAreaName: newOfficeAreaName?.trim(),
      officeRole: newOfficeRole?.trim(),
      customerId: newCustomerId,
      customerCompanyName: newCustomerCompanyName?.trim(),
      workplaceBranch: newWorkplaceBranch?.trim(),
      contractedServiceName: newContractedServiceName?.trim(),
      supervisorName: newSupervisorName.trim(),
      supervisorEmployeeId: newSupervisorEmployeeId,
      scheduleId: newScheduleId,
      scheduleName: scheduleName,
      startDate: now,
      status: 'ACTIVA',
      rotationNumber: nextRotationNumber,
      originDescription: originDestination,
      rotationReason: rotationReason.trim(),
      notes: notes?.trim(),
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await RrhhAssignment.db.insertRow(session, newAssignment);

    // 4. Actualizar sede y supervisor en el empleado
    final newWorkplace = inserted.assignmentType == 'OFICINA'
        ? (inserted.officeAreaName != null
              ? 'Oficina Central - ${inserted.officeAreaName}'
              : 'Oficina Central Elite')
        : '${inserted.customerCompanyName ?? "Cliente"} (${inserted.workplaceBranch ?? "Principal"})';

    final employee = await RrhhEmployee.db.findById(
      session,
      current.employeeId,
    );
    if (employee != null) {
      await RrhhEmployee.db.updateRow(
        session,
        employee.copyWith(
          workplace: newWorkplace,
          supervisor: inserted.supervisorName,
          supervisorId: inserted.supervisorEmployeeId,
          updatedAt: now,
        ),
      );

      // 5. Registrar evento de rotación en la línea de tiempo del empleado
      final personnelRepo = RrhhPersonnelRepository(session);
      await personnelRepo.addTimelineEvent(
        RrhhTimelineEvent(
          employeeId: employee.id!,
          title: 'Rotación #$nextRotationNumber: $newWorkplace',
          description:
              'Rotado desde: $originDestination. Turno: $scheduleName. Motivo: $rotationReason',
          date: now,
          category: 'ASIGNACION',
          registeredBy: 'RRHH - Rotaciones',
          createdAt: now,
        ),
      );
    }

    return inserted;
  }

  /// Cancela o desactiva una asignación, liberando la disponibilidad del colaborador a 'DISPONIBLE'.
  Future<bool> cancelAssignment(int id, {String? reason}) async {
    final assignment = await getAssignmentById(id);
    if (assignment == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhAssignment.db.updateRow(
      session,
      assignment.copyWith(
        status: 'CANCELADA',
        endDate: now,
        notes: reason != null
            ? '${assignment.notes ?? ""}\nCancelada: $reason'.trim()
            : assignment.notes,
        updatedAt: now,
      ),
    );

    // Actualizar empleado a DISPONIBLE si no tiene otra asignación activa
    final otherActive = await getActiveAssignmentByEmployee(
      assignment.employeeId,
    );
    if (otherActive == null) {
      final employee = await RrhhEmployee.db.findById(
        session,
        assignment.employeeId,
      );
      if (employee != null) {
        await RrhhEmployee.db.updateRow(
          session,
          employee.copyWith(
            availabilityStatus: 'DISPONIBLE',
            updatedAt: now,
          ),
        );
      }
    }

    return true;
  }

  // ===========================================================================
  // 3. SEEDING INICIAL DE TURNOS Y ASIGNACIONES CORPORATIVAS
  // ===========================================================================

  /// Siembra los 4 turnos estándar y las asignaciones iniciales si las tablas están vacías.
  Future<void> seedInitialData() async {
    final scheduleCount = await RrhhSchedule.db.count(session);
    final now = DateTime.now().toUtc();

    if (scheduleCount == 0) {
      final defaultSchedules = [
        RrhhSchedule(
          code: 'SCH-ADM',
          name: 'Administrativo Central',
          targetType: 'OFICINA',
          startTime: '08:30',
          endTime: '17:30',
          workDays: [1, 2, 3, 4, 5],
          toleranceMinutes: 15,
          isNightShift: false,
          description:
              'Horario corporativo estándar de lunes a viernes con 15 minutos de tolerancia.',
          isActive: true,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
        RrhhSchedule(
          code: 'SCH-OP-MAN',
          name: 'Operativo Mañana (Campo)',
          targetType: 'CAMPO',
          startTime: '07:00',
          endTime: '15:00',
          workDays: [1, 2, 3, 4, 5, 6],
          toleranceMinutes: 10,
          isNightShift: false,
          description:
              'Turno matutino de servicios generales en sedes de clientes de lunes a sábado.',
          isActive: true,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
        RrhhSchedule(
          code: 'SCH-OP-TAR',
          name: 'Operativo Tarde (Retail)',
          targetType: 'CAMPO',
          startTime: '14:00',
          endTime: '22:00',
          workDays: [1, 2, 3, 4, 5, 6],
          toleranceMinutes: 10,
          isNightShift: false,
          description:
              'Turno vespertino para centros comerciales, retail y limpieza de food courts.',
          isActive: true,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
        RrhhSchedule(
          code: 'SCH-SEG-NOC',
          name: 'Seguridad Nocturna',
          targetType: 'CAMPO',
          startTime: '22:00',
          endTime: '06:00',
          workDays: [1, 2, 3, 4, 5, 6],
          toleranceMinutes: 5,
          isNightShift: true,
          description:
              'Turno nocturno con recargo legal para vigilancia perimetral y plantas industriales.',
          isActive: true,
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      for (final s in defaultSchedules) {
        await RrhhSchedule.db.insertRow(session, s);
      }
    }

    final assignmentCount = await RrhhAssignment.db.count(session);
    if (assignmentCount == 0) {
      // Buscar los turnos sembrados
      final admSchedule = await getScheduleByCode('SCH-ADM');
      final manSchedule = await getScheduleByCode('SCH-OP-MAN');
      final nocSchedule = await getScheduleByCode('SCH-SEG-NOC');

      // Buscar empleados existentes
      final emp1 = await RrhhEmployee.db.findFirstRow(
        session,
        where: (t) => t.code.equals('EMP-001'),
      );
      final emp2 = await RrhhEmployee.db.findFirstRow(
        session,
        where: (t) => t.code.equals('EMP-002'),
      );
      final emp3 = await RrhhEmployee.db.findFirstRow(
        session,
        where: (t) => t.code.equals('EMP-003'),
      );
      final emp4 = await RrhhEmployee.db.findFirstRow(
        session,
        where: (t) => t.code.equals('EMP-004'),
      );

      if (emp1 != null && emp2 != null && emp3 != null && emp4 != null) {
        final initialAssignments = [
          // 1. Carlos Mendoza (Campo - Kolping Bolivia con Rotación #1)
          RrhhAssignment(
            code: 'ASG-001',
            employeeId: emp1.id!,
            employeeCode: emp1.code,
            employeeName: emp1.fullName,
            assignmentType: 'CAMPO',
            customerId: 1,
            customerCompanyName: 'Kolping Bolivia',
            workplaceBranch: 'Sede: Kolping - Central',
            contractedServiceName: 'Mantenimiento Preventivo',
            supervisorName: 'Ricardo Montaño Justiniano',
            scheduleId: manSchedule?.id ?? 1,
            scheduleName: manSchedule?.name ?? 'Operativo Mañana',
            startDate: DateTime.utc(2023, 1, 15),
            status: 'ACTIVA',
            rotationNumber: 1,
            originDescription: 'Ventura Mall - Mantenimiento General',
            rotationReason:
                'Refuerzo de cuadrilla técnica especializada para Kolping.',
            isDeleted: false,
            createdAt: now,
            updatedAt: now,
          ),
          // 2. Jorge Aguilera (Campo - Ventura Mall con Rotación #1)
          RrhhAssignment(
            code: 'ASG-002',
            employeeId: emp2.id!,
            employeeCode: emp2.code,
            employeeName: emp2.fullName,
            assignmentType: 'CAMPO',
            customerId: 2,
            customerCompanyName: 'Ventura Mall',
            workplaceBranch: 'Sede: Ventura Mall - Pasillo Norte',
            contractedServiceName: 'Limpieza de Áreas Comunes & Food Court',
            supervisorName: 'Ricardo Montaño Justiniano',
            scheduleId: manSchedule?.id ?? 1,
            scheduleName: manSchedule?.name ?? 'Operativo Mañana',
            startDate: DateTime.utc(2023, 3, 1),
            status: 'ACTIVA',
            rotationNumber: 1,
            originDescription: 'Plaza Blacutt - Jardinería y Paisajismo',
            rotationReason: 'Ampliación de contrato en el centro comercial.',
            isDeleted: false,
            createdAt: now,
            updatedAt: now,
          ),
          // 3. Miguel Vargas (Campo - Segomeit SRL Puesto Inicial)
          RrhhAssignment(
            code: 'ASG-003',
            employeeId: emp3.id!,
            employeeCode: emp3.code,
            employeeName: emp3.fullName,
            assignmentType: 'CAMPO',
            customerId: 3,
            customerCompanyName: 'Segomeit SRL',
            workplaceBranch: 'Sede: Planta Parque Industrial',
            contractedServiceName: 'Seguridad Perimetral',
            supervisorName: 'Ricardo Montaño Justiniano',
            scheduleId: nocSchedule?.id ?? 4,
            scheduleName: nocSchedule?.name ?? 'Seguridad Nocturna',
            startDate: DateTime.utc(2023, 5, 10),
            status: 'ACTIVA',
            rotationNumber: 0,
            originDescription: 'Puesto Inicial',
            isDeleted: false,
            createdAt: now,
            updatedAt: now,
          ),
          // 4. Paola Torrico (Oficina Central - RRHH Puesto Inicial)
          RrhhAssignment(
            code: 'ASG-004',
            employeeId: emp4.id!,
            employeeCode: emp4.code,
            employeeName: emp4.fullName,
            assignmentType: 'OFICINA',
            officeAreaName: 'Recursos Humanos',
            officeRole: 'Encargada de Recursos Humanos',
            supervisorName: 'Gerencia General',
            scheduleId: admSchedule?.id ?? 1,
            scheduleName: admSchedule?.name ?? 'Administrativo Central',
            startDate: DateTime.utc(2021, 8, 1),
            status: 'ACTIVA',
            rotationNumber: 0,
            originDescription: 'Puesto Inicial',
            isDeleted: false,
            createdAt: now,
            updatedAt: now,
          ),
        ];

        for (final asg in initialAssignments) {
          await RrhhAssignment.db.insertRow(session, asg);
        }
      }
    }
  }
}
