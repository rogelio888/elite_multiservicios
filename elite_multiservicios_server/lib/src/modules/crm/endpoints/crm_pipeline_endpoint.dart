import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/crm_pipeline_repository.dart';

/// Endpoint RPC para el embudo de ventas, compuertas y Pipeline comercial.
class CrmPipelineEndpoint extends Endpoint {
  /// Lista las oportunidades con filtros opcionales.
  Future<List<CrmOpportunity>> listOpportunities(
    Session session, {
    int limit = 100,
    int offset = 0,
    String? search,
    String? stage,
    String? owner,
    String? serviceType,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmPipelineView);
    final repo = CrmPipelineDataService(session);
    return await repo.listOpportunities(
      limit: limit,
      offset: offset,
      search: search,
      stage: stage,
      owner: owner,
      serviceType: serviceType,
    );
  }

  /// Obtiene el detalle de una oportunidad por ID.
  Future<CrmOpportunity?> getOpportunity(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmPipelineView);
    final repo = CrmPipelineDataService(session);
    return await repo.getOpportunityById(id);
  }

  /// Obtiene las partidas de cotización asociadas a una oportunidad.
  Future<List<CrmQuoteItem>> getQuoteItems(
    Session session,
    int opportunityId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmPipelineView);
    final repo = CrmPipelineDataService(session);
    return await repo.getQuoteItems(opportunityId);
  }

  /// Crea una nueva oportunidad comercial.
  Future<CrmOpportunity> createOpportunity(
    Session session,
    CrmOpportunity opp, {
    List<CrmQuoteItem>? quoteItems,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmPipelineCreate,
    );
    final repo = CrmPipelineDataService(session);
    return await repo.createOpportunity(opp, quoteItems: quoteItems);
  }

  /// Actualiza una oportunidad comercial.
  Future<CrmOpportunity> updateOpportunity(
    Session session,
    CrmOpportunity opp, {
    List<CrmQuoteItem>? quoteItems,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmPipelineUpdate,
    );
    final repo = CrmPipelineDataService(session);
    return await repo.updateOpportunity(opp, quoteItems: quoteItems);
  }

  /// Actualiza la etapa o compuerta comercial de una oportunidad.
  Future<CrmOpportunity?> updateStage(
    Session session,
    int id,
    String newStage,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmPipelineUpdate,
    );
    final repo = CrmPipelineDataService(session);
    return await repo.updateStage(id, newStage);
  }

  /// Traspaso formal de oportunidad Ganada a Cliente 360°.
  Future<CrmCustomerDetailResponse?> promoteToCustomer(
    Session session,
    int opportunityId,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmPipelinePromoteToCustomer,
    );
    final repo = CrmPipelineDataService(session);
    return await repo.promoteToCustomer(opportunityId);
  }

  /// Elimina lógicamente una oportunidad.
  Future<bool> deleteOpportunity(Session session, int id) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmPipelineDelete,
    );
    final repo = CrmPipelineDataService(session);
    return await repo.deleteOpportunity(id);
  }

  /// Obtiene las métricas agregadas del pipeline.
  Future<CrmPipelineMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmPipelineView);
    final repo = CrmPipelineDataService(session);
    return await repo.getPipelineMetrics();
  }
}
