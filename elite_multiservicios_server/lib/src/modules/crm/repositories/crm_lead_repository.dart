import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Servicio de datos y persistencia para la gestión de prospectos comerciales (CRM Leads) en PostgreSQL.
class CrmLeadDataService {
  final Session session;

  const CrmLeadDataService(this.session);

  /// Lista prospectos con filtros avanzados, búsqueda y paginación.
  Future<List<CrmLead>> listLeads({
    int limit = 100,
    int offset = 0,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
    String? origin,
    String? requestedService,
  }) async {
    return await CrmLead.db.find(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);

        if (sector != null && sector != 'Todos') {
          filter = filter & t.sector.ilike('%$sector%');
        }

        if (status != null && status != 'Todos') {
          filter = filter & t.status.equals(status);
        }

        if (temperature != null && temperature != 'Todos') {
          filter = filter & t.temperature.equals(temperature);
        }

        if (advisor != null && advisor != 'Todos') {
          filter = filter & t.advisor.equals(advisor);
        }

        if (origin != null && origin != 'Todos') {
          filter = filter & t.origin.equals(origin);
        }

        if (requestedService != null && requestedService != 'Todos') {
          filter = filter & t.requestedService.ilike('%$requestedService%');
        }

        if (search != null && search.trim().isNotEmpty) {
          final q = '%${search.trim()}%';
          final searchExpr =
              t.company.ilike(q) |
              t.address.ilike(q) |
              t.phone.ilike(q) |
              t.contactPerson.ilike(q) |
              t.origin.ilike(q) |
              (t.requestedService.notEquals(null) &
                  t.requestedService.ilike(q)) |
              t.code.ilike(q);
          filter = filter & searchExpr;
        }

        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Obtiene un prospecto específico por su ID primario.
  Future<CrmLead?> getLeadById(int id) async {
    return await CrmLead.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Registra un nuevo prospecto con código autonumérico secuencial PROSP-XXX.
  Future<CrmLead> createLead(CrmLead lead) async {
    final count = await CrmLead.db.count(session);
    final nextCode = lead.code.isNotEmpty
        ? lead.code
        : 'PROSP-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now();
    final toInsert = lead.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmLead.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos generales de un prospecto existente.
  Future<CrmLead> updateLead(CrmLead lead) async {
    final toUpdate = lead.copyWith(updatedAt: DateTime.now());
    return await CrmLead.db.updateRow(session, toUpdate);
  }

  /// Actualiza el estado comercial de un prospecto.
  Future<CrmLead?> updateStatus(int id, String newStatus) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  Future<CrmLead?> updateTemperature(int id, String newTemp) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      temperature: newTemp,
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Marca un prospecto como promovido a Oportunidad en el Pipeline comercial.
  Future<CrmLead?> markPromoted(int id, int? opportunityId) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      isPromoted: true,
      promotedOpportunityId: opportunityId,
      status: 'Interesado (Calificado)',
      temperature: 'Caliente',
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Realiza la eliminación lógica (Soft Delete) de un prospecto.
  Future<bool> deleteLead(int id) async {
    final existing = await getLeadById(id);
    if (existing == null) return false;

    final updated = existing.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
    await CrmLead.db.updateRow(session, updated);
    return true;
  }

  /// Calcula las métricas agregadas de prospectos en tiempo real.
  Future<CrmLeadMetricsResponse> getMetrics() async {
    final activeLeads = await CrmLead.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalCount = activeLeads.length;
    final contactedCount = activeLeads
        .where((l) => l.status == 'Contactado')
        .length;
    final waitingCount = activeLeads
        .where((l) => l.status == 'En Espera de Respuesta')
        .length;
    final qualifiedCount = activeLeads
        .where((l) => l.status == 'Interesado (Calificado)')
        .length;
    final hotCount = activeLeads
        .where((l) => l.temperature == 'Caliente')
        .length;

    final conversionRate = totalCount > 0
        ? (qualifiedCount / totalCount) * 100
        : 0.0;
    final totalPotential = activeLeads
        .where((l) => l.status != 'Descartado')
        .fold<double>(0.0, (acc, l) => acc + l.estimatedValue);

    return CrmLeadMetricsResponse(
      totalCount: totalCount,
      contactedCount: contactedCount,
      waitingCount: waitingCount,
      qualifiedCount: qualifiedCount,
      hotCount: hotCount,
      conversionRate: conversionRate,
      totalPipelinePotential: totalPotential,
    );
  }
}
