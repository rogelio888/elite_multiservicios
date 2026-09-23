import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_assignment_repository.dart';

/// Endpoint RPC para la administración de Turnos, Horarios, Asignaciones Operativas
/// y Rotaciones Inmutables de Personal en Elite Multiservicios.
class RrhhAssignmentEndpoint extends Endpoint {
  // ===========================================================================
  // 1. HORARIOS Y TURNOS
  // ===========================================================================

  /// Lista los turnos de trabajo disponibles en el catálogo corporativo.
  Future<List<RrhhSchedule>> listSchedules(
    Session session, {
    String? targetType,
    bool? isActive,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.listSchedules(
      targetType: targetType,
      isActive: isActive,
      search: search,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene un turno por su ID.
  Future<RrhhSchedule?> getScheduleById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.getScheduleById(id);
  }

  /// Registra un nuevo horario/turno corporativo.
  Future<RrhhSchedule> createSchedule(Session session, RrhhSchedule schedule) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.createSchedule(schedule);
  }

  /// Actualiza los parámetros de un horario.
  Future<RrhhSchedule> updateSchedule(Session session, RrhhSchedule schedule) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.updateSchedule(schedule);
  }

  /// Desactiva (soft-delete) un horario.
  Future<bool> deleteSchedule(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.deleteSchedule(id);
  }

  // ===========================================================================
  // 2. ASIGNACIONES OPERATIVAS Y ROTACIONES
  // ===========================================================================

  /// Lista las asignaciones de personal con filtros de estado, entorno y búsqueda.
  Future<List<RrhhAssignment>> listAssignments(
    Session session, {
    String? status,
    String? assignmentType,
    int? employeeId,
    int? customerId,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.listAssignments(
      status: status,
      assignmentType: assignmentType,
      employeeId: employeeId,
      customerId: customerId,
      search: search,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene una asignación por su ID.
  Future<RrhhAssignment?> getAssignmentById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.getAssignmentById(id);
  }

  /// Obtiene la asignación activa de un colaborador específico.
  Future<RrhhAssignment?> getActiveAssignmentByEmployee(Session session, int employeeId) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.getActiveAssignmentByEmployee(employeeId);
  }

  /// Obtiene el histórico completo de rotaciones de un colaborador (inmutable).
  Future<List<RrhhAssignment>> getRotationHistory(Session session, int employeeId) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsView);
    final repo = RrhhOperationsRepository(session);
    return await repo.getRotationHistory(employeeId);
  }

  /// Crea una nueva asignación para un colaborador y actualiza su disponibilidad.
  Future<RrhhAssignment> createAssignment(Session session, RrhhAssignment assignment) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.createAssignment(assignment);
  }

  /// Rota a un colaborador a un nuevo destino preservando la inmutabilidad histórica.
  Future<RrhhAssignment> rotateAssignment(
    Session session, {
    required int currentAssignmentId,
    required String newAssignmentType,
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
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.rotateAssignment(
      currentAssignmentId: currentAssignmentId,
      newAssignmentType: newAssignmentType,
      newOfficeAreaId: newOfficeAreaId,
      newOfficeAreaName: newOfficeAreaName,
      newOfficeRole: newOfficeRole,
      newCustomerId: newCustomerId,
      newCustomerCompanyName: newCustomerCompanyName,
      newWorkplaceBranch: newWorkplaceBranch,
      newContractedServiceName: newContractedServiceName,
      newScheduleId: newScheduleId,
      newSupervisorName: newSupervisorName,
      newSupervisorEmployeeId: newSupervisorEmployeeId,
      rotationReason: rotationReason,
      notes: notes,
    );
  }

  /// Cancela una asignación y libera al colaborador a estado 'DISPONIBLE'.
  Future<bool> cancelAssignment(
    Session session,
    int id, {
    String? reason,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhAssignmentsManage);
    final repo = RrhhOperationsRepository(session);
    return await repo.cancelAssignment(id, reason: reason);
  }
}
