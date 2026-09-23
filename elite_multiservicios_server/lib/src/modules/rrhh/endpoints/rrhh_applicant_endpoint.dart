import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_applicant_repository.dart';

/// Endpoint RPC para la gestión de postulantes y seguimiento del proceso de selección (RRHH).
class RrhhApplicantEndpoint extends Endpoint {
  /// Lista los postulantes aplicando filtros opcionales de estado, tipo de entorno o búsqueda.
  Future<List<RrhhApplicant>> listApplicants(
    Session session, {
    String? status,
    String? targetType,
    int? specialtyId,
    String? search,
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.listApplicants(
      status: status,
      targetType: targetType,
      specialtyId: specialtyId,
      search: search,
      limit: limit,
      offset: offset,
      includeDeleted: includeDeleted,
    );
  }

  /// Obtiene el detalle de un postulante por su identificador primario.
  Future<RrhhApplicant?> getApplicantById(
    Session session,
    int id, {
    bool includeDeleted = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.getApplicantById(id, includeDeleted: includeDeleted);
  }

  /// Registra un nuevo postulante en el sistema.
  Future<RrhhApplicant> createApplicant(
    Session session,
    RrhhApplicant applicant,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.createApplicant(applicant);
  }

  /// Actualiza los datos de un postulante existente.
  Future<RrhhApplicant> updateApplicant(
    Session session,
    RrhhApplicant applicant,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.updateApplicant(applicant);
  }

  /// Modifica el estado del postulante en el pipeline de selección ('NUEVO', 'EN_EVALUACION', 'SELECCIONADO', etc.).
  Future<RrhhApplicant> updateApplicantStatus(
    Session session, {
    required int id,
    required String newStatus,
    String? interviewNotes,
    String? discardReason,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.updateApplicantStatus(
      id,
      newStatus: newStatus,
      interviewNotes: interviewNotes,
      discardReason: discardReason,
    );
  }

  /// Soft delete de un postulante del sistema.
  Future<bool> deleteApplicant(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhRecruitmentRepository(session);
    return await repo.deleteApplicant(id);
  }

  /// Sembrado inicial de postulantes si la base de datos está vacía.
  Future<bool> seedInitialData(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhRecruitmentRepository(session);
    await repo.seedInitialApplicants();
    return true;
  }
}
