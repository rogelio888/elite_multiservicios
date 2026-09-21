import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/crm_catalog_repository.dart';

/// Endpoint RPC para la administración y consulta del Catálogo de Servicios,
/// Rubros Industriales, Líneas de Servicio y Tarifas Diferenciadas (Scopes).
class CrmCatalogEndpoint extends Endpoint {
  // ===========================================================================
  // 1. SECTORES / RUBROS INDUSTRIALES
  // ===========================================================================

  /// Lista los sectores o rubros industriales no eliminados.
  Future<List<CrmSector>> listSectors(
    Session session, {
    bool includeInactive = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogView);
    final repo = CrmCatalogRepository(session);
    return await repo.listSectors(includeInactive: includeInactive);
  }

  /// Crea un nuevo sector con validación de código y nombre únicos.
  Future<CrmSector> createSector(Session session, CrmSector sector) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.createSector(sector);
  }

  /// Actualiza un sector existente.
  Future<CrmSector> updateSector(Session session, CrmSector sector) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.updateSector(sector);
  }

  /// Soft delete de un sector con cascada lógica sobre sus scopes asociados.
  Future<bool> deleteSector(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.deleteSector(id);
  }

  // ===========================================================================
  // 2. LÍNEAS DE SERVICIO
  // ===========================================================================

  /// Lista las líneas de servicio disponibles.
  Future<List<CrmServiceLine>> listServiceLines(
    Session session, {
    String? category,
    bool includeInactive = false,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogView);
    final repo = CrmCatalogRepository(session);
    return await repo.listServiceLines(
      category: category,
      includeInactive: includeInactive,
    );
  }

  /// Crea una nueva línea de servicio.
  Future<CrmServiceLine> createServiceLine(
    Session session,
    CrmServiceLine line,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.createServiceLine(line);
  }

  /// Actualiza una línea de servicio existente.
  Future<CrmServiceLine> updateServiceLine(
    Session session,
    CrmServiceLine line,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.updateServiceLine(line);
  }

  /// Soft delete de una línea de servicio.
  Future<bool> deleteServiceLine(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.deleteServiceLine(id);
  }

  // ===========================================================================
  // 3. CATÁLOGO DE PARTIDAS Y TARIFARIO MAESTRO
  // ===========================================================================

  /// Lista las partidas del catálogo, resolviendo opcionalmente precios diferenciados por sector.
  Future<List<CrmCatalogItem>> listCatalogItems(
    Session session, {
    String? category,
    int? sectorId,
    int? serviceLineId,
    bool activeOnly = true,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogView);
    final repo = CrmCatalogRepository(session);
    return await repo.listCatalogItems(
      category: category,
      sectorId: sectorId,
      serviceLineId: serviceLineId,
      activeOnly: activeOnly,
    );
  }

  /// Obtiene una partida de catálogo por su ID.
  Future<CrmCatalogItem?> getCatalogItem(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogView);
    final repo = CrmCatalogRepository(session);
    return await repo.getCatalogItemById(id);
  }

  /// Crea una nueva partida con validación de unicidad y metadata de cálculo.
  Future<CrmCatalogItem> createCatalogItem(
    Session session,
    CrmCatalogItem item,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.createCatalogItem(item);
  }

  /// Actualiza una partida existente con versionado automático si cambia el precio o fórmula.
  Future<CrmCatalogItem> updateCatalogItem(
    Session session,
    CrmCatalogItem item,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.updateCatalogItem(item);
  }

  /// Soft delete de partida de catálogo.
  Future<bool> deleteCatalogItem(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.deleteCatalogItem(id);
  }

  // ===========================================================================
  // 4. TARIFAS DIFERENCIADAS POR RUBRO (SCOPES)
  // ===========================================================================

  /// Lista los precios diferenciados (scopes) definidos para una partida.
  Future<List<CrmCatalogItemScope>> listScopesForItem(
    Session session,
    int catalogItemId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogView);
    final repo = CrmCatalogRepository(session);
    return await repo.listScopesForItem(catalogItemId);
  }

  /// Registra o actualiza la tarifa diferenciada de una partida para un sector específico.
  Future<CrmCatalogItemScope> setCatalogItemScope(
    Session session,
    CrmCatalogItemScope scope,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCatalogManage);
    final repo = CrmCatalogRepository(session);
    return await repo.setCatalogItemScope(scope);
  }
}
