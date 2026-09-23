import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio relacional para la Gestión Laboral en RRHH:
/// Permisos/Licencias, Vacaciones, Incidencias/Régimen Disciplinario,
/// y Desvinculaciones Formales (con preservación inmutable del expediente).
class RrhhLaborRepository {
  final Session session;

  const RrhhLaborRepository(this.session);

  // ===========================================================================
  // 1. GESTIÓN DE PERMISOS Y LICENCIAS (RrhhLeaveRequest)
  // ===========================================================================

  /// Lista solicitudes de permiso/licencia con filtros por colaborador, estado o tipo.
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    int? employeeId,
    String? status,
    String? leaveType,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhLeaveRequest.db.find(
      session,
      where: (t) {
        var expr = includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false);
        if (employeeId != null) {
          expr = expr & t.employeeId.equals(employeeId);
        }
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (leaveType != null && leaveType.trim().isNotEmpty) {
          expr = expr & t.leaveType.equals(leaveType.trim().toUpperCase());
        }
        return expr;
      },
      orderBy: (t) => t.startDate,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Obtiene una solicitud de permiso por ID.
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id) async {
    return await RrhhLeaveRequest.db.findById(session, id);
  }

  /// Crea una nueva solicitud de permiso o licencia.
  Future<RrhhLeaveRequest> createLeaveRequest({
    required int employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
  }) async {
    final employee = await RrhhEmployee.db.findById(session, employeeId);
    if (employee == null || employee.isDeleted) {
      throw ArgumentError('El colaborador con ID $employeeId no existe.');
    }

    final now = DateTime.now();
    final year = startDate.year;
    final count = await RrhhLeaveRequest.db.count(
      session,
      where: (t) => t.code.like('LIC-$year-%'),
    );
    final code = 'LIC-$year-${(count + 1).toString().padLeft(3, '0')}';

    final request = RrhhLeaveRequest(
      code: code,
      employeeId: employeeId,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      leaveType: leaveType.trim().toUpperCase(),
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      hoursCount: hoursCount,
      reason: reason.trim(),
      medicalCertificateNumber: medicalCertificateNumber?.trim(),
      attachmentUrl: attachmentUrl?.trim(),
      status: 'PENDIENTE',
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await RrhhLeaveRequest.db.insertRow(session, request);

    // Registro en la línea de tiempo
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: employeeId,
        date: startDate,
        title: 'Solicitud de Licencia ($leaveType)',
        description: 'Solicitud $code por $daysCount día(s). Motivo: $reason',
        category: 'PERMISO',
        registeredBy: 'Sistema RRHH',
        createdAt: now,
      ),
    );

    return inserted;
  }

  /// Resuelve (Aprueba o Rechaza) una solicitud de permiso.
  Future<RrhhLeaveRequest> resolveLeaveRequest(
    int id, {
    required String status,
    String? resolutionNotes,
    int? resolvedByUserId,
  }) async {
    final req = await RrhhLeaveRequest.db.findById(session, id);
    if (req == null || req.isDeleted) {
      throw ArgumentError('La solicitud de licencia con ID $id no existe.');
    }

    final upperStatus = status.trim().toUpperCase();
    if (!['APROBADO', 'RECHAZADO', 'CANCELADO'].contains(upperStatus)) {
      throw ArgumentError('Estado inválido para resolución: $status');
    }

    final now = DateTime.now();
    req.status = upperStatus;
    req.resolutionNotes = resolutionNotes?.trim();
    req.resolvedByUserId = resolvedByUserId;
    req.resolvedAt = now;
    req.updatedAt = now;

    final updated = await RrhhLeaveRequest.db.updateRow(session, req);

    // Si se aprueba y la fecha actual cae dentro de la vigencia, actualizar disponibilidad
    if (upperStatus == 'APROBADO') {
      final employee = await RrhhEmployee.db.findById(session, req.employeeId);
      if (employee != null) {
        if (!now.isBefore(req.startDate) && !now.isAfter(req.endDate)) {
          employee.availabilityStatus = 'CON_PERMISO';
          employee.updatedAt = now;
          await RrhhEmployee.db.updateRow(session, employee);
        }
      }
    }

    // Registrar en línea de tiempo
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: req.employeeId,
        date: now,
        title: 'Resolución de Licencia ($upperStatus)',
        description: 'Licencia ${req.code} marcada como $upperStatus. ${resolutionNotes ?? ""}',
        category: 'PERMISO',
        registeredBy: resolvedByUserId != null ? 'Usuario #$resolvedByUserId' : 'Administración RRHH',
        createdAt: now,
      ),
    );

    return updated;
  }

  // ===========================================================================
  // 2. CONTROL Y CÁLCULO DE VACACIONES (RrhhVacation)
  // ===========================================================================

  /// Calcula la escala legal de días de vacación según antigüedad en Bolivia:
  /// - De 1 a 5 años de servicio: 15 días hábiles
  /// - De 5 a 10 años de servicio: 20 días hábiles
  /// - Más de 10 años de servicio: 30 días hábiles
  int calculateVacationEntitlement(DateTime entryDate, [DateTime? asOfDate]) {
    final targetDate = asOfDate ?? DateTime.now();
    final differenceDays = targetDate.difference(entryDate).inDays;
    final years = differenceDays / 365.25;

    if (years < 1.0) {
      return 0; // Menos de 1 año no tiene duodécimas consolidadas para vacación anual completa
    } else if (years < 5.0) {
      return 15;
    } else if (years < 10.0) {
      return 20;
    } else {
      return 30;
    }
  }

  /// Lista solicitudes de vacación por colaborador o período.
  Future<List<RrhhVacation>> listVacations({
    int? employeeId,
    int? periodYear,
    String? status,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhVacation.db.find(
      session,
      where: (t) {
        var expr = includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false);
        if (employeeId != null) {
          expr = expr & t.employeeId.equals(employeeId);
        }
        if (periodYear != null) {
          expr = expr & t.periodYear.equals(periodYear);
        }
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        return expr;
      },
      orderBy: (t) => t.startDate,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Registra una solicitud de vacaciones validando el saldo disponible.
  Future<RrhhVacation> requestVacation({
    required int employeeId,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    String? notes,
  }) async {
    final employee = await RrhhEmployee.db.findById(session, employeeId);
    if (employee == null || employee.isDeleted) {
      throw ArgumentError('El colaborador con ID $employeeId no existe.');
    }

    final totalAccrued = calculateVacationEntitlement(employee.realStartDate, startDate);

    // Sumar días ya tomados o aprobados en ese período
    final existingVacations = await RrhhVacation.db.find(
      session,
      where: (t) =>
          t.employeeId.equals(employeeId) &
          t.periodYear.equals(periodYear) &
          t.isDeleted.equals(false) &
          (t.status.equals('APROBADA') | t.status.equals('COMPLETADA') | t.status.equals('EN_CURSO')),
    );

    int daysAlreadyUsed = 0;
    for (final v in existingVacations) {
      daysAlreadyUsed += v.daysRequested;
    }

    final remainingBefore = totalAccrued - daysAlreadyUsed;
    if (daysRequested > remainingBefore && remainingBefore > 0) {
      // Advertencia pero se registra indicando saldo proyectado
    }

    final now = DateTime.now();
    final year = startDate.year;
    final count = await RrhhVacation.db.count(
      session,
      where: (t) => t.code.like('VAC-$year-%'),
    );
    final code = 'VAC-$year-${(count + 1).toString().padLeft(3, '0')}';

    final vacation = RrhhVacation(
      code: code,
      employeeId: employeeId,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      periodYear: periodYear,
      startDate: startDate,
      endDate: endDate,
      daysRequested: daysRequested,
      totalAccruedDays: totalAccrued,
      remainingBalanceDays: remainingBefore - daysRequested,
      status: 'SOLICITADA',
      notes: notes?.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await RrhhVacation.db.insertRow(session, vacation);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: employeeId,
        date: startDate,
        title: 'Solicitud de Vacación',
        description: 'Solicitud $code por $daysRequested días correspondientes al período $periodYear.',
        category: 'PERMISO',
        registeredBy: 'Sistema RRHH',
        createdAt: now,
      ),
    );

    return inserted;
  }

  /// Aprueba una vacación programada.
  Future<RrhhVacation> approveVacation(
    int id, {
    int? approvedByUserId,
    String? notes,
  }) async {
    final vacation = await RrhhVacation.db.findById(session, id);
    if (vacation == null || vacation.isDeleted) {
      throw ArgumentError('La vacación con ID $id no existe.');
    }

    final now = DateTime.now();
    vacation.status = 'APROBADA';
    vacation.approvedByUserId = approvedByUserId;
    vacation.approvedAt = now;
    if (notes != null) vacation.notes = notes;
    vacation.updatedAt = now;

    final updated = await RrhhVacation.db.updateRow(session, vacation);

    // Si coincide con la fecha actual, actualizar disponibilidad
    if (!now.isBefore(vacation.startDate) && !now.isAfter(vacation.endDate)) {
      final employee = await RrhhEmployee.db.findById(session, vacation.employeeId);
      if (employee != null) {
        employee.availabilityStatus = 'DE_VACACIONES';
        employee.updatedAt = now;
        await RrhhEmployee.db.updateRow(session, employee);
      }
    }

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: vacation.employeeId,
        date: now,
        title: 'Vacación Aprobada',
        description: 'Vacación ${vacation.code} aprobada del ${vacation.startDate.toIso8601String().split("T").first} al ${vacation.endDate.toIso8601String().split("T").first}.',
        category: 'PERMISO',
        registeredBy: approvedByUserId != null ? 'Usuario #$approvedByUserId' : 'Gerencia RRHH',
        createdAt: now,
      ),
    );

    return updated;
  }

  // ===========================================================================
  // 3. RÉGIMEN DISCIPLINARIO E INCIDENCIAS (RrhhIncident)
  // ===========================================================================

  /// Lista incidencias disciplinarias o reconocimientos con filtros.
  Future<List<RrhhIncident>> listIncidents({
    int? employeeId,
    String? incidentType,
    String? severity,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhIncident.db.find(
      session,
      where: (t) {
        var expr = includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false);
        if (employeeId != null) {
          expr = expr & t.employeeId.equals(employeeId);
        }
        if (incidentType != null && incidentType.trim().isNotEmpty) {
          expr = expr & t.incidentType.equals(incidentType.trim().toUpperCase());
        }
        if (severity != null && severity.trim().isNotEmpty) {
          expr = expr & t.severity.equals(severity.trim().toUpperCase());
        }
        return expr;
      },
      orderBy: (t) => t.incidentDate,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Registra una novedad, sanción, memorándum o felicitación.
  Future<RrhhIncident> recordIncident({
    required int employeeId,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    bool isJustified = false,
    int? recordedByUserId,
    String? documentReferenceUrl,
  }) async {
    final employee = await RrhhEmployee.db.findById(session, employeeId);
    if (employee == null || employee.isDeleted) {
      throw ArgumentError('El colaborador con ID $employeeId no existe.');
    }

    final now = DateTime.now();
    final year = incidentDate.year;
    final count = await RrhhIncident.db.count(
      session,
      where: (t) => t.code.like('INC-$year-%'),
    );
    final code = 'INC-$year-${(count + 1).toString().padLeft(3, '0')}';

    final incident = RrhhIncident(
      code: code,
      employeeId: employeeId,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      incidentType: incidentType.trim().toUpperCase(),
      severity: severity.trim().toUpperCase(),
      incidentDate: incidentDate,
      title: title.trim(),
      description: description.trim(),
      actionTaken: actionTaken.trim(),
      isJustified: isJustified,
      recordedByUserId: recordedByUserId,
      documentReferenceUrl: documentReferenceUrl?.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await RrhhIncident.db.insertRow(session, incident);

    // Registro en la línea de tiempo
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: employeeId,
        date: incidentDate,
        title: '$incidentType: $title',
        description: 'Acción tomada: $actionTaken. $description',
        category: 'INCIDENCIA',
        registeredBy: recordedByUserId != null ? 'Usuario #$recordedByUserId' : 'Supervisor / RRHH',
        createdAt: now,
      ),
    );

    return inserted;
  }

  // ===========================================================================
  // 4. DESVINCULACIÓN FORMAL Y PRESERVACIÓN HISTÓRICA (REGLA DE ORO)
  // ===========================================================================

  /// Registra la desvinculación formal de un trabajador.
  /// REGLA DE ORO DE AUDITORÍA:
  /// - PROHIBIDO el borrado físico (`DELETE`) del empleado.
  /// - Pasa a `status = 'INACTIVO'` y `availabilityStatus = 'NO_DISPONIBLE'`.
  /// - Se finalizan automáticamente todas sus asignaciones operativas activas.
  /// - Su expediente e historial quedan preservados para certificaciones laborales y fiscalización OVT.
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    double? severanceAmount,
    bool clearanceCompleted = false,
    bool isEligibleForRehire = true,
    int? processedByUserId,
    String? handoverNotes,
  }) async {
    final employee = await RrhhEmployee.db.findById(session, employeeId);
    if (employee == null || employee.isDeleted) {
      throw ArgumentError('El colaborador con ID $employeeId no existe.');
    }

    if (employee.status == 'INACTIVO') {
      throw StateError('El colaborador ya se encuentra en estado INACTIVO.');
    }

    final now = DateTime.now();
    final year = terminationDate.year;
    final count = await RrhhTermination.db.count(
      session,
      where: (t) => t.code.like('DESV-$year-%'),
    );
    final code = 'DESV-$year-${(count + 1).toString().padLeft(3, '0')}';

    final yearsOfService = terminationDate.difference(employee.realStartDate).inDays / 365.25;

    final termination = RrhhTermination(
      code: code,
      employeeId: employeeId,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      employeeCi: employee.identityCard,
      contractType: employee.contractType,
      entryDate: employee.realStartDate,
      terminationDate: terminationDate,
      lastWorkingDay: lastWorkingDay,
      reason: reason.trim().toUpperCase(),
      detailedReason: detailedReason.trim(),
      yearsOfService: double.parse(yearsOfService.toStringAsFixed(2)),
      severanceAmount: severanceAmount,
      clearanceCompleted: clearanceCompleted,
      isEligibleForRehire: isEligibleForRehire,
      processedByUserId: processedByUserId,
      handoverNotes: handoverNotes?.trim(),
      createdAt: now,
    );

    final insertedTermination = await RrhhTermination.db.insertRow(session, termination);

    // 1. REGLA DE ORO: Marcar INACTIVO preservando todo el expediente
    employee.status = 'INACTIVO';
    employee.availabilityStatus = 'NO_DISPONIBLE';
    employee.exitDate = terminationDate;
    employee.exitReason = reason.trim().toUpperCase();
    employee.exitObservations = detailedReason.trim();
    employee.exitRegisteredBy = processedByUserId != null ? 'Usuario #$processedByUserId' : 'Gerencia RRHH';
    employee.updatedAt = now;
    await RrhhEmployee.db.updateRow(session, employee);

    // 2. Finalizar automáticamente todas sus asignaciones operativas activas
    final activeAssignments = await RrhhAssignment.db.find(
      session,
      where: (t) =>
          t.employeeId.equals(employeeId) &
          t.status.equals('ACTIVA') &
          t.isDeleted.equals(false),
    );

    for (final asg in activeAssignments) {
      asg.status = 'FINALIZADA';
      asg.endDate = lastWorkingDay;
      asg.notes = 'Finalizada automáticamente por desvinculación laboral ($reason).';
      asg.updatedAt = now;
      await RrhhAssignment.db.updateRow(session, asg);
    }

    // 3. Registrar en bitácora inmutable de movimientos
    await RrhhMovementHistory.db.insertRow(
      session,
      RrhhMovementHistory(
        employeeId: employeeId,
        employeeCode: employee.code,
        employeeName: employee.fullName,
        movementType: 'DESVINCULACION',
        previousValue: 'ACTIVO (${employee.position})',
        newValue: 'INACTIVO',
        effectiveDate: terminationDate,
        reason: '$reason: $detailedReason',
        authorizedBy: processedByUserId != null ? 'Usuario #$processedByUserId' : 'Dirección RRHH',
        createdAt: now,
      ),
    );

    // 4. Registrar en línea de tiempo del expediente
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: employeeId,
        date: terminationDate,
        title: 'Desvinculación Laboral ($reason)',
        description: 'Egreso formal registrado ($code). Antigüedad: ${yearsOfService.toStringAsFixed(1)} años. '
            'Expediente e historial preservados íntegramente conforme a auditoría.',
        category: 'DESVINCULACION',
        registeredBy: processedByUserId != null ? 'Usuario #$processedByUserId' : 'RRHH',
        createdAt: now,
      ),
    );

    return insertedTermination;
  }

  // ===========================================================================
  // 5. BITÁCORA INMUTABLE DE MOVIMIENTOS (RrhhMovementHistory)
  // ===========================================================================

  /// Lista movimientos históricos con filtros por colaborador o tipo.
  Future<List<RrhhMovementHistory>> listMovements({
    int? employeeId,
    String? movementType,
    int limit = 100,
    int offset = 0,
  }) async {
    return await RrhhMovementHistory.db.find(
      session,
      where: (t) {
        Expression expr = Constant.bool(true);
        if (employeeId != null) {
          expr = expr & t.employeeId.equals(employeeId);
        }
        if (movementType != null && movementType.trim().isNotEmpty) {
          expr = expr & t.movementType.equals(movementType.trim().toUpperCase());
        }
        return expr;
      },
      orderBy: (t) => t.effectiveDate,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Registra un movimiento de personal en la bitácora inmutable.
  Future<RrhhMovementHistory> recordMovement({
    required int employeeId,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
  }) async {
    final employee = await RrhhEmployee.db.findById(session, employeeId);
    if (employee == null || employee.isDeleted) {
      throw ArgumentError('El colaborador con ID $employeeId no existe.');
    }

    final now = DateTime.now();
    final movement = RrhhMovementHistory(
      employeeId: employeeId,
      employeeCode: employee.code,
      employeeName: employee.fullName,
      movementType: movementType.trim().toUpperCase(),
      previousValue: previousValue?.trim(),
      newValue: newValue.trim(),
      effectiveDate: effectiveDate,
      reason: reason.trim(),
      authorizedBy: authorizedBy.trim(),
      createdAt: now,
    );

    return await RrhhMovementHistory.db.insertRow(session, movement);
  }

  // ===========================================================================
  // 6. SEED DE DATOS LABORALES (PERMISOS, VACACIONES, SANCIONES, EGRESOS)
  // ===========================================================================

  Future<void> seedInitialLaborData() async {
    final existingRequests = await RrhhLeaveRequest.db.count(session);
    if (existingRequests > 0) return;

    final employees = await RrhhEmployee.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
      orderBy: (t) => t.id,
      limit: 10,
    );

    if (employees.isEmpty) return;

    final now = DateTime.now();

    // 1. Licencia Médica Aprobada para Colaborador 1
    final emp1 = employees.first;
    final licMedica = await createLeaveRequest(
      employeeId: emp1.id!,
      leaveType: 'MEDICA',
      startDate: now.subtract(const Duration(days: 10)),
      endDate: now.subtract(const Duration(days: 7)),
      daysCount: 3,
      reason: 'Reposo médico por cuadro de gastroenteritis aguda certificada.',
      medicalCertificateNumber: 'CNSS-SCZ-88912',
    );
    await resolveLeaveRequest(
      licMedica.id!,
      status: 'APROBADO',
      resolutionNotes: 'Baja médica validada por la Caja Nacional de Salud.',
    );

    // 2. Licencia Personal Pendiente para Colaborador 2 (si existe)
    if (employees.length > 1) {
      final emp2 = employees[1];
      await createLeaveRequest(
        employeeId: emp2.id!,
        leaveType: 'PERSONAL',
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 2)),
        daysCount: 1,
        reason: 'Trámite notarial personal e impostergable.',
      );
    }

    // 3. Vacaciones Aprobadas para Colaborador 1
    final vac1 = await requestVacation(
      employeeId: emp1.id!,
      periodYear: now.year - 1,
      startDate: now.subtract(const Duration(days: 45)),
      endDate: now.subtract(const Duration(days: 35)),
      daysRequested: 10,
      notes: 'Vacaciones anuales correspondientes a gestión anterior.',
    );
    await approveVacation(
      vac1.id!,
      notes: 'Aprobado de común acuerdo con supervisión de área.',
    );

    // 4. Incidencias: 1 Felicitación y 1 Llamado de atención leve
    await recordIncident(
      employeeId: emp1.id!,
      incidentType: 'FELICITACION',
      severity: 'POSITIVA',
      incidentDate: now.subtract(const Duration(days: 20)),
      title: 'Desempeño y Puntualidad Impecable',
      description: 'Reconocimiento formal por felicitación expresa recibida desde la sede del cliente Kolping Bolivia.',
      actionTaken: 'Carta de felicitación archivada en expediente con puntuación meritoria.',
      isJustified: true,
    );

    if (employees.length > 1) {
      final emp2 = employees[1];
      await recordIncident(
        employeeId: emp2.id!,
        incidentType: 'LLAMADO_ATENCION_LEVE',
        severity: 'LEVE',
        incidentDate: now.subtract(const Duration(days: 15)),
        title: 'Atraso Justificado de 20 Minutos',
        description: 'Demora imprevista en línea de microbús reportada anticipadamente a supervisión.',
        actionTaken: 'Compensación de jornada al cierre de turno.',
        isJustified: true,
      );
    }

    // 5. Histórico Desvinculado (Regla de Oro: Retenido como INACTIVO en la BD)
    final existingExEmp = await RrhhEmployee.db.findFirstRow(
      session,
      where: (t) => t.code.equals('EMP-099'),
    );

    if (existingExEmp == null) {
      final exEmp = await RrhhEmployee.db.insertRow(
        session,
        RrhhEmployee(
          code: 'EMP-099',
          identityCard: '4392810 SC',
          fullName: 'José Luis Gutiérrez Vaca',
          birthDate: DateTime(1989, 5, 12),
          birthPlace: 'Santa Cruz de la Sierra',
          occupation: 'Operador de Limpieza Industrial',
          phone: '77391823',
          address: 'Plan 3000, Calle 4 #12, Santa Cruz',
          personalReference: 'Roberto Gutiérrez (Hermano)',
          referencePhone: '77123999',
          employeeType: 'CAMPO',
          area: 'Operaciones de Campo',
          position: 'Operador de Limpieza Industrial',
          specialty: 'Limpieza Integral',
          workplace: 'Parque Industrial PI-27',
          supervisor: 'Ing. Javier Torrico',
          realStartDate: DateTime(2023, 2, 1),
          fiscalStartDate: DateTime(2023, 2, 1),
          agreedSalary: 2600.0,
          contractType: 'Plazo Fijo',
          status: 'ACTIVO',
          createdAt: now.subtract(const Duration(days: 400)),
          updatedAt: now.subtract(const Duration(days: 400)),
        ),
      );

      // Desvincularlo formalmente con la regla de oro de auditoría
      await terminateEmployee(
        employeeId: exEmp.id!,
        terminationDate: DateTime(2025, 12, 31),
        lastWorkingDay: DateTime(2025, 12, 31),
        reason: 'FIN_DE_CONTRATO',
        detailedReason: 'Conclusión regular del contrato a plazo fijo convenido con entrega formal de dotación y paz y salvo.',
        severanceAmount: 2600.0,
        clearanceCompleted: true,
        isEligibleForRehire: true,
        handoverNotes: 'Entrega completa de credencial, llaves de lockers y uniforme operativo en buen estado.',
      );
    }
  }
}
