import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/rrhh_organization_repository.dart';

/// Endpoint RPC para la administración y consulta de la Estructura Organizacional:
/// Áreas Departamentales, Cargos de Personal y Especialidades Técnicas Operativas.
class RrhhOrganizationEndpoint extends Endpoint {
  // ===========================================================================
  // 1. ÁREAS / DEPARTAMENTOS
  // ===========================================================================

  /// Lista las áreas de la empresa con filtros opcionales.
  Future<List<RrhhArea>> listAreas(
    Session session, {
    bool includeInactive = false,
    String? search,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.listAreas(
      includeInactive: includeInactive,
      search: search,
    );
  }

  /// Obtiene un área por su ID.
  Future<RrhhArea?> getAreaById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.getAreaById(id);
  }

  /// Crea una nueva área validando código y nombre únicos.
  Future<RrhhArea> createArea(Session session, RrhhArea area) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.createArea(area);
  }

  /// Actualiza un área existente.
  Future<RrhhArea> updateArea(Session session, RrhhArea area) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.updateArea(area);
  }

  /// Soft delete de un área y desactivación en cascada de sus cargos.
  Future<bool> deleteArea(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.deleteArea(id);
  }

  // ===========================================================================
  // 2. CARGOS / PUESTOS DE TRABAJO
  // ===========================================================================

  /// Lista los cargos con filtros por área y tipo de entorno laboral ('Oficina'/'Campo').
  Future<List<RrhhPosition>> listPositions(
    Session session, {
    int? areaId,
    String? workplaceType,
    bool includeInactive = false,
    String? search,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.listPositions(
      areaId: areaId,
      workplaceType: workplaceType,
      includeInactive: includeInactive,
      search: search,
    );
  }

  /// Obtiene un cargo por su ID.
  Future<RrhhPosition?> getPositionById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.getPositionById(id);
  }

  /// Crea un nuevo cargo asociado a un departamento.
  Future<RrhhPosition> createPosition(
    Session session,
    RrhhPosition position,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.createPosition(position);
  }

  /// Actualiza un cargo existente.
  Future<RrhhPosition> updatePosition(
    Session session,
    RrhhPosition position,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.updatePosition(position);
  }

  /// Soft delete de un cargo.
  Future<bool> deletePosition(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.deletePosition(id);
  }

  // ===========================================================================
  // 3. ESPECIALIDADES TÉCNICAS
  // ===========================================================================

  /// Lista las especialidades técnicas para personal operativo.
  Future<List<RrhhSpecialty>> listSpecialties(
    Session session, {
    bool includeInactive = false,
    String? search,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.listSpecialties(
      includeInactive: includeInactive,
      search: search,
    );
  }

  /// Obtiene una especialidad por su ID.
  Future<RrhhSpecialty?> getSpecialtyById(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhOrganizationRepository(session);
    return await repo.getSpecialtyById(id);
  }

  /// Crea una nueva especialidad operativa.
  Future<RrhhSpecialty> createSpecialty(
    Session session,
    RrhhSpecialty specialty,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.createSpecialty(specialty);
  }

  /// Actualiza una especialidad existente.
  Future<RrhhSpecialty> updateSpecialty(
    Session session,
    RrhhSpecialty specialty,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.updateSpecialty(specialty);
  }

  /// Soft delete de una especialidad.
  Future<bool> deleteSpecialty(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    return await repo.deleteSpecialty(id);
  }

  // ===========================================================================
  // 4. INICIALIZACIÓN / SEED DATA
  // ===========================================================================

  /// Si las tablas de áreas y especialidades se encuentran vacías, las inicializa con datos estándar.
  Future<bool> seedInitialData(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalManage);
    final repo = RrhhOrganizationRepository(session);
    await repo.seedInitialOrganizationData();
    return true;
  }
}
