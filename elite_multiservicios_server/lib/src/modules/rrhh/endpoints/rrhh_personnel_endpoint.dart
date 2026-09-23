import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_personnel_repository.dart';

/// Endpoint RPC para la administración integral del Expediente de Empleados,
/// Contratación transaccional desde postulantes, Documentos Digitales e Historial.
class RrhhPersonnelEndpoint extends Endpoint {
  // ===========================================================================
  // 1. EMPLEADOS / EXPEDIENTES
  // ===========================================================================

  /// Lista los colaboradores con filtros opcionales de estado, tipo Oficina/Campo y búsqueda.
  Future<List<RrhhEmployee>> listEmployees(
    Session session, {
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhPersonnelRepository(session);
    return await repo.listEmployees(
      status: status,
      employeeType: employeeType,
      availabilityStatus: availabilityStatus,
      areaId: areaId,
      search: search,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene un colaborador por su ID.
  Future<RrhhEmployee?> getEmployeeById(
    Session session,
    int id, {
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhPersonnelRepository(session);
    return await repo.getEmployeeById(id, includeDeleted: includeDeleted);
  }

  /// Obtiene un colaborador por su código institucional (EMP-001).
  Future<RrhhEmployee?> getEmployeeByCode(
    Session session,
    String code, {
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhPersonnelRepository(session);
    return await repo.getEmployeeByCode(code, includeDeleted: includeDeleted);
  }

  /// Registra un nuevo colaborador directamente en nómina.
  Future<RrhhEmployee> createEmployee(
    Session session,
    RrhhEmployee employee,
  ) async {
    final userId = await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhPersonnelRepository(session);
    return await repo.createEmployee(employee, registeredBy: userId);
  }

  /// Actualiza los datos laborales de un empleado.
  Future<RrhhEmployee> updateEmployee(
    Session session,
    RrhhEmployee employee,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.updateEmployee(employee);
  }

  /// Contrata formalmente a un postulante seleccionado, promoviéndolo a empleado.
  Future<RrhhEmployee> hireApplicant(
    Session session, {
    required int applicantId,
    required DateTime realStartDate,
    required DateTime fiscalStartDate,
    required double agreedSalary,
    required String contractType,
    DateTime? contractEndDate,
    String? observations,
    String? workplace,
    String? supervisor,
  }) async {
    final userId = await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhPersonnelRepository(session);
    return await repo.hireApplicant(
      applicantId: applicantId,
      realStartDate: realStartDate,
      fiscalStartDate: fiscalStartDate,
      agreedSalary: agreedSalary,
      contractType: contractType,
      contractEndDate: contractEndDate,
      observations: observations,
      workplace: workplace,
      supervisor: supervisor,
      registeredBy: userId,
    );
  }

  /// Modifica el estado de disponibilidad operativa del empleado.
  Future<RrhhEmployee> updateAvailabilityStatus(
    Session session, {
    required int id,
    required String newAvailabilityStatus,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.updateAvailabilityStatus(
      id,
      newAvailabilityStatus: newAvailabilityStatus,
    );
  }

  /// Desvincula a un empleado pasando a INACTIVO y conservando todo su historial.
  Future<RrhhEmployee> terminateEmployee(
    Session session, {
    required int id,
    required DateTime exitDate,
    required String exitReason,
    String? exitObservations,
  }) async {
    final userId = await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhPersonnelRepository(session);
    return await repo.terminateEmployee(
      id,
      exitDate: exitDate,
      exitReason: exitReason,
      exitObservations: exitObservations,
      registeredBy: userId,
    );
  }

  /// Soft delete de un empleado (eliminación lógica).
  Future<bool> deleteEmployee(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.deleteEmployee(id);
  }

  // ===========================================================================
  // 2. DOCUMENTOS ADJUNTOS
  // ===========================================================================

  /// Lista los documentos del expediente digital del empleado.
  Future<List<RrhhEmployeeDocument>> listDocuments(
    Session session,
    int employeeId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhPersonnelRepository(session);
    return await repo.listDocuments(employeeId);
  }

  /// Registra un documento en el expediente.
  Future<RrhhEmployeeDocument> addDocument(
    Session session,
    RrhhEmployeeDocument document,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.addDocument(document);
  }

  /// Elimina un documento del expediente.
  Future<bool> deleteDocument(Session session, int documentId) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.deleteDocument(documentId);
  }

  // ===========================================================================
  // 3. LÍNEA DE TIEMPO
  // ===========================================================================

  /// Consulta la línea de tiempo de un colaborador.
  Future<List<RrhhTimelineEvent>> listTimelineEvents(
    Session session,
    int employeeId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhPersonnelRepository(session);
    return await repo.listTimelineEvents(employeeId);
  }

  /// Agrega un hito a la línea de tiempo del empleado.
  Future<RrhhTimelineEvent> addTimelineEvent(
    Session session,
    RrhhTimelineEvent event,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    return await repo.addTimelineEvent(event);
  }

  // ===========================================================================
  // 4. INICIALIZACIÓN / SEED
  // ===========================================================================

  /// Sembrado inicial de empleados si la base de datos está vacía.
  Future<bool> seedInitialData(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhPersonnelRepository(session);
    await repo.seedInitialEmployees();
    return true;
  }
}
