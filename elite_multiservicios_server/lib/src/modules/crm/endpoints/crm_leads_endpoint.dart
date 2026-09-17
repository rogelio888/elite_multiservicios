import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/crm_lead_repository.dart';

/// Endpoint RPC para la gestión integral de Prospectos (CRM Leads) en frío y Maps.
class CrmLeadsEndpoint extends Endpoint {
  /// Lista los prospectos con filtros opcionales de búsqueda, rubro, estado y temperatura.
  Future<List<CrmLead>> listLeads(
    Session session, {
    int limit = 100,
    int offset = 0,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsView);

    final repo = CrmLeadDataService(session);
    return await repo.listLeads(
      limit: limit,
      offset: offset,
      search: search,
      sector: sector,
      status: status,
      temperature: temperature,
      advisor: advisor,
    );
  }

  /// Obtiene el detalle de un prospecto por su ID.
  Future<CrmLead?> getLead(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsView);

    final repo = CrmLeadDataService(session);
    return await repo.getLeadById(id);
  }

  /// Registra un nuevo prospecto comercial en el sistema.
  Future<CrmLead> createLead(Session session, CrmLead lead) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsCreate);

    final repo = CrmLeadDataService(session);
    return await repo.createLead(lead);
  }

  /// Actualiza los datos generales de un prospecto.
  Future<CrmLead> updateLead(Session session, CrmLead lead) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsUpdate);

    final repo = CrmLeadDataService(session);
    return await repo.updateLead(lead);
  }

  /// Actualiza el estado comercial de un prospecto en el embudo inicial.
  Future<CrmLead?> updateStatus(
    Session session,
    int id,
    String status,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsUpdate);

    final repo = CrmLeadDataService(session);
    return await repo.updateStatus(id, status);
  }

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  Future<CrmLead?> updateTemperature(
    Session session,
    int id,
    String temperature,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsUpdate);

    final repo = CrmLeadDataService(session);
    return await repo.updateTemperature(id, temperature);
  }

  /// Marca el prospecto como promovido formalmente a una Oportunidad en el Pipeline.
  Future<CrmLead?> markPromoted(
    Session session,
    int id,
    int? opportunityId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsPromote);

    final repo = CrmLeadDataService(session);
    return await repo.markPromoted(id, opportunityId);
  }

  /// Elimina lógicamente (Soft Delete) un prospecto.
  Future<bool> deleteLead(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsDelete);

    final repo = CrmLeadDataService(session);
    return await repo.deleteLead(id);
  }

  /// Consulta el consolidado de métricas de prospección en tiempo real.
  Future<CrmLeadMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmLeadsView);

    final repo = CrmLeadDataService(session);
    return await repo.getMetrics();
  }
}
