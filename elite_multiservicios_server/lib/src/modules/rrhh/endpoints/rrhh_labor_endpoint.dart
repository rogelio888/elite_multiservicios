import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_labor_repository.dart';

/// Endpoint RPC para la Gestión Laboral en RRHH:
/// Licencias, Vacaciones Legales, Régimen Disciplinario y Desvinculaciones Inmutables.
class RrhhLaborEndpoint extends Endpoint {
  // ===========================================================================
  // 1. PERMISOS Y LICENCIAS
  // ===========================================================================

  /// Lista solicitudes de permiso/licencia.
  Future<List<RrhhLeaveRequest>> listLeaveRequests(
    Session session, {
    int? employeeId,
    String? status,
    String? leaveType,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return await repo.listLeaveRequests(
      employeeId: employeeId,
      status: status,
      leaveType: leaveType,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene una solicitud de permiso por ID.
  Future<RrhhLeaveRequest?> getLeaveRequestById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return await repo.getLeaveRequestById(id);
  }

  /// Registra una nueva solicitud de permiso o licencia.
  Future<RrhhLeaveRequest> createLeaveRequest(
    Session session, {
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
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.createLeaveRequest(
      employeeId: employeeId,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      hoursCount: hoursCount,
      reason: reason,
      medicalCertificateNumber: medicalCertificateNumber,
      attachmentUrl: attachmentUrl,
    );
  }

  /// Resuelve (Aprueba o Rechaza) una solicitud de permiso.
  Future<RrhhLeaveRequest> resolveLeaveRequest(
    Session session,
    int id, {
    required String status,
    String? resolutionNotes,
    int? resolvedByUserId,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.resolveLeaveRequest(
      id,
      status: status,
      resolutionNotes: resolutionNotes,
      resolvedByUserId: resolvedByUserId,
    );
  }

  // ===========================================================================
  // 2. VACACIONES Y DÍAS HÁBILES SEGÚN LEY
  // ===========================================================================

  /// Retorna los días de vacación según antigüedad en Bolivia.
  Future<int> calculateVacationEntitlement(
    Session session,
    DateTime entryDate, [
    DateTime? asOfDate,
  ]) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return repo.calculateVacationEntitlement(entryDate, asOfDate);
  }

  /// Lista vacaciones programadas o históricas.
  Future<List<RrhhVacation>> listVacations(
    Session session, {
    int? employeeId,
    int? periodYear,
    String? status,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return await repo.listVacations(
      employeeId: employeeId,
      periodYear: periodYear,
      status: status,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Solicita un período de vacaciones.
  Future<RrhhVacation> requestVacation(
    Session session, {
    required int employeeId,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    String? notes,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.requestVacation(
      employeeId: employeeId,
      periodYear: periodYear,
      startDate: startDate,
      endDate: endDate,
      daysRequested: daysRequested,
      notes: notes,
    );
  }

  /// Aprueba una solicitud de vacación.
  Future<RrhhVacation> approveVacation(
    Session session,
    int id, {
    int? approvedByUserId,
    String? notes,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.approveVacation(
      id,
      approvedByUserId: approvedByUserId,
      notes: notes,
    );
  }

  // ===========================================================================
  // 3. RÉGIMEN DISCIPLINARIO E INCIDENCIAS
  // ===========================================================================

  /// Lista novedades, memorándums o reconocimientos.
  Future<List<RrhhIncident>> listIncidents(
    Session session, {
    int? employeeId,
    String? incidentType,
    String? severity,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return await repo.listIncidents(
      employeeId: employeeId,
      incidentType: incidentType,
      severity: severity,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Registra una incidencia disciplinaria o felicitación.
  Future<RrhhIncident> recordIncident(
    Session session, {
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
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.recordIncident(
      employeeId: employeeId,
      incidentType: incidentType,
      severity: severity,
      incidentDate: incidentDate,
      title: title,
      description: description,
      actionTaken: actionTaken,
      isJustified: isJustified,
      recordedByUserId: recordedByUserId,
      documentReferenceUrl: documentReferenceUrl,
    );
  }

  // ===========================================================================
  // 4. DESVINCULACIÓN FORMAL Y PRESERVACIÓN HISTÓRICA (REGLA DE ORO)
  // ===========================================================================

  /// Registra el egreso de un colaborador, marcándolo INACTIVO y cerrando asignaciones
  /// sin eliminar su expediente histórico de la base de datos.
  Future<RrhhTermination> terminateEmployee(
    Session session, {
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
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.terminateEmployee(
      employeeId: employeeId,
      terminationDate: terminationDate,
      lastWorkingDay: lastWorkingDay,
      reason: reason,
      detailedReason: detailedReason,
      severanceAmount: severanceAmount,
      clearanceCompleted: clearanceCompleted,
      isEligibleForRehire: isEligibleForRehire,
      processedByUserId: processedByUserId,
      handoverNotes: handoverNotes,
    );
  }

  // ===========================================================================
  // 5. BITÁCORA INMUTABLE DE MOVIMIENTOS
  // ===========================================================================

  /// Lista movimientos registrados de un colaborador o generales.
  Future<List<RrhhMovementHistory>> listMovements(
    Session session, {
    int? employeeId,
    String? movementType,
    int limit = 100,
    int offset = 0,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborView);
    final repo = RrhhLaborRepository(session);
    return await repo.listMovements(
      employeeId: employeeId,
      movementType: movementType,
      limit: limit,
      offset: offset,
    );
  }

  /// Registra un movimiento laboral institucional.
  Future<RrhhMovementHistory> recordMovement(
    Session session, {
    required int employeeId,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhLaborManage);
    final repo = RrhhLaborRepository(session);
    return await repo.recordMovement(
      employeeId: employeeId,
      movementType: movementType,
      previousValue: previousValue,
      newValue: newValue,
      effectiveDate: effectiveDate,
      reason: reason,
      authorizedBy: authorizedBy,
    );
  }
}
