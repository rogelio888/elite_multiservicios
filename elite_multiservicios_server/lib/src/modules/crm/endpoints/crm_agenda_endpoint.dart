import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/crm_agenda_repository.dart';

/// Endpoint RPC para la Agenda Comercial, compromisos y tareas de seguimiento.
class CrmAgendaEndpoint extends Endpoint {
  /// Lista las tareas con filtros opcionales.
  Future<List<CrmTask>> listTasks(
    Session session, {
    int limit = 100,
    int offset = 0,
    String? search,
    String? status,
    String? taskType,
    String? priority,
    int? customerId,
    int? opportunityId,
    int? leadId,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.listTasks(
      limit: limit,
      offset: offset,
      search: search,
      status: status,
      taskType: taskType,
      priority: priority,
      customerId: customerId,
      opportunityId: opportunityId,
      leadId: leadId,
    );
  }

  /// Obtiene una tarea por su ID.
  Future<CrmTask?> getTask(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.getTaskById(id);
  }

  /// Obtiene las tareas programadas para una fecha específica.
  Future<List<CrmTask>> getTasksForDate(Session session, DateTime date) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.getTasksForDate(date);
  }

  /// Obtiene las tareas correspondientes al día de hoy.
  Future<List<CrmTask>> getTodayTasks(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.getTodayTasks();
  }

  /// Obtiene las tareas vencidas.
  Future<List<CrmTask>> getOverdueTasks(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.getOverdueTasks();
  }

  /// Crea una nueva tarea en la agenda.
  Future<CrmTask> createTask(Session session, CrmTask task) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaCreate);
    final repo = CrmAgendaDataService(session);
    return await repo.createTask(task);
  }

  /// Actualiza una tarea existente.
  Future<CrmTask> updateTask(Session session, CrmTask task) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaUpdate);
    final repo = CrmAgendaDataService(session);
    return await repo.updateTask(task);
  }

  /// Marca una tarea como completada.
  Future<CrmTask?> completeTask(
    Session session,
    int id, {
    String? notes,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmAgendaComplete,
    );
    final repo = CrmAgendaDataService(session);
    return await repo.completeTask(id, notes: notes);
  }

  /// Pospone una tarea.
  Future<CrmTask?> postponeTask(
    Session session,
    int id, {
    required DateTime newDate,
    required String newTimeText,
    String? reason,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaUpdate);
    final repo = CrmAgendaDataService(session);
    return await repo.postponeTask(
      id,
      newDate: newDate,
      newTimeText: newTimeText,
      reason: reason,
    );
  }

  /// Elimina lógicamente una tarea.
  Future<bool> deleteTask(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaDelete);
    final repo = CrmAgendaDataService(session);
    return await repo.deleteTask(id);
  }

  /// Programa una tarea de control de calidad tras finalizar obra.
  Future<CrmTask> scheduleQualityCheck(
    Session session, {
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    int? customerId,
    int? contractId,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaCreate);
    final repo = CrmAgendaDataService(session);
    return await repo.scheduleQualityCheck(
      clientName: clientName,
      contactPerson: contactPerson,
      phone: phone,
      contractTitle: contractTitle,
      customerId: customerId,
      contractId: contractId,
    );
  }

  /// Programa una alerta comercial de renovación de contrato.
  Future<CrmTask> scheduleRenewal(
    Session session, {
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    required DateTime expiryDate,
    int? customerId,
    int? contractId,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaCreate);
    final repo = CrmAgendaDataService(session);
    return await repo.scheduleRenewal(
      clientName: clientName,
      contactPerson: contactPerson,
      phone: phone,
      contractTitle: contractTitle,
      expiryDate: expiryDate,
      customerId: customerId,
      contractId: contractId,
    );
  }

  /// Obtiene las métricas agregadas de la agenda.
  Future<CrmAgendaMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmAgendaView);
    final repo = CrmAgendaDataService(session);
    return await repo.getAgendaMetrics();
  }
}
