import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Capa de persistencia y lógica de negocio para la Agenda Comercial y Tareas en PostgreSQL.
class CrmAgendaDataService {
  final Session session;

  const CrmAgendaDataService(this.session);

  /// Lista tareas y compromisos con filtros avanzados por estado, tipo, prioridad y búsqueda.
  Future<List<CrmTask>> listTasks({
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
    return await CrmTask.db.find(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);

        if (status != null && status != 'Todos') {
          filter = filter & t.status.equals(status);
        }

        if (taskType != null && taskType != 'Todos') {
          filter = filter & t.taskType.equals(taskType);
        }

        if (priority != null && priority != 'Todos') {
          filter = filter & t.priority.equals(priority);
        }

        if (customerId != null) {
          filter = filter & t.customerId.equals(customerId);
        }

        if (opportunityId != null) {
          filter = filter & t.opportunityId.equals(opportunityId);
        }

        if (leadId != null) {
          filter = filter & t.leadId.equals(leadId);
        }

        if (search != null && search.trim().isNotEmpty) {
          final q = '%${search.trim()}%';
          final searchExpr =
              t.title.ilike(q) |
              t.clientName.ilike(q) |
              t.contactPerson.ilike(q) |
              t.phone.ilike(q) |
              t.code.ilike(q) |
              t.callContext.ilike(q);
          filter = filter & searchExpr;
        }

        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.scheduledAt,
      orderDescending: false,
    );
  }

  /// Obtiene una tarea específica por su ID primario.
  Future<CrmTask?> getTaskById(int id) async {
    return await CrmTask.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Obtiene las tareas programadas para una fecha específica.
  Future<List<CrmTask>> getTasksForDate(DateTime date) async {
    final start = DateTime.utc(date.year, date.month, date.day);
    final end = DateTime.utc(date.year, date.month, date.day, 23, 59, 59);

    return await CrmTask.db.find(
      session,
      where: (t) =>
          t.scheduledAt.between(start, end) & t.isDeleted.equals(false),
      orderBy: (t) => t.scheduledTimeText,
    );
  }

  /// Obtiene las tareas correspondientes al día de hoy.
  Future<List<CrmTask>> getTodayTasks() async {
    return await getTasksForDate(DateTime.now().toUtc());
  }

  /// Obtiene las tareas vencidas que aún no han sido completadas.
  Future<List<CrmTask>> getOverdueTasks() async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);

    return await CrmTask.db.find(
      session,
      where: (t) =>
          (t.scheduledAt < todayStart) &
          t.status.notEquals('Completada') &
          t.isDeleted.equals(false),
      orderBy: (t) => t.scheduledAt,
    );
  }

  /// Registra una nueva tarea en la agenda con código secuencial TSK-XXX.
  Future<CrmTask> createTask(CrmTask task) async {
    final count = await CrmTask.db.count(session);
    final nextCode = task.code.isNotEmpty
        ? task.code
        : 'TSK-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now().toUtc();
    final toInsert = task.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmTask.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos de una tarea existente.
  Future<CrmTask> updateTask(CrmTask task) async {
    final toUpdate = task.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmTask.db.updateRow(session, toUpdate);
  }

  /// Marca una tarea como Completada.
  Future<CrmTask?> completeTask(int id, {String? notes}) async {
    final existing = await getTaskById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: 'Completada',
      notes: notes ?? existing.notes,
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmTask.db.updateRow(session, updated);
  }

  /// Pospone una tarea a una nueva fecha y hora.
  Future<CrmTask?> postponeTask(
    int id, {
    required DateTime newDate,
    required String newTimeText,
    String? reason,
  }) async {
    final existing = await getTaskById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: 'Pospuesta',
      scheduledAt: newDate,
      scheduledTimeText: newTimeText,
      callContext: reason != null
          ? '${existing.callContext ?? ''} (Pospuesta: $reason)'.trim()
          : existing.callContext,
      updatedAt: DateTime.now().toUtc(),
    );

    return await CrmTask.db.updateRow(session, updated);
  }

  /// Eliminación lógica (Soft Delete) de una tarea.
  Future<bool> deleteTask(int id) async {
    final existing = await getTaskById(id);
    if (existing == null) return false;

    await CrmTask.db.updateRow(
      session,
      existing.copyWith(isDeleted: true, updatedAt: DateTime.now().toUtc()),
    );
    return true;
  }

  /// Programa automáticamente una tarea de control de calidad a 72h tras fin de obra.
  Future<CrmTask> scheduleQualityCheck({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    int? customerId,
    int? contractId,
  }) async {
    final targetDate = DateTime.now().toUtc().add(const Duration(days: 3));
    return await createTask(
      CrmTask(
        code: '',
        title: 'Control de calidad: $contractTitle',
        taskType: 'Postventa / Control de Calidad',
        clientName: clientName,
        contactPerson: contactPerson,
        phone: phone,
        scheduledAt: targetDate,
        scheduledTimeText: '10:00',
        priority: 'Alta / Urgente',
        status: 'Pendiente',
        callContext:
            'Servicio concluido. Realizar llamada de verificación de satisfacción, entrega conforme y ofrecer plan de mantenimiento recurrente.',
        customerId: customerId,
        contractId: contractId,
        isDeleted: false,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Programa automáticamente una alerta comercial 30 días antes del vencimiento de un contrato.
  Future<CrmTask> scheduleRenewal({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    required DateTime expiryDate,
    int? customerId,
    int? contractId,
  }) async {
    final now = DateTime.now().toUtc();
    final reminderDate = expiryDate.subtract(const Duration(days: 30));
    final effectiveDate = reminderDate.isBefore(now)
        ? now.add(const Duration(days: 1))
        : reminderDate;

    return await createTask(
      CrmTask(
        code: '',
        title: 'Renovación de Contrato: $contractTitle',
        taskType: 'Renovación de Contrato',
        clientName: clientName,
        contactPerson: contactPerson,
        phone: phone,
        scheduledAt: effectiveDate,
        scheduledTimeText: '11:00',
        priority: 'Alta / Urgente',
        status: 'Pendiente',
        callContext:
            'El contrato vencerá próximamente. Contactar para acordar la renovación del período (+12 meses) y actualizar la tarifa según ajuste acordado.',
        customerId: customerId,
        contractId: contractId,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Calcula las métricas agregadas de la agenda en tiempo real.
  Future<CrmAgendaMetricsResponse> getAgendaMetrics() async {
    final allTasks = await CrmTask.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalTasks = allTasks.length;
    final pendingCount = allTasks.where((t) => t.status != 'Completada').length;
    final completedCount = allTasks
        .where((t) => t.status == 'Completada')
        .length;

    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final todayEnd = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

    final todayTasksCount = allTasks.where((t) {
      return t.scheduledAt.isAfter(
            todayStart.subtract(const Duration(seconds: 1)),
          ) &&
          t.scheduledAt.isBefore(todayEnd.add(const Duration(seconds: 1))) &&
          t.status != 'Completada';
    }).length;

    final overdueTasksCount = allTasks.where((t) {
      return t.scheduledAt.isBefore(todayStart) && t.status != 'Completada';
    }).length;

    final startOfWeek = todayStart.subtract(
      Duration(days: todayStart.weekday - 1),
    );
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    final thisWeekTasksCount = allTasks.where((t) {
      return !t.status.contains('Completada') &&
          t.scheduledAt.isAfter(
            startOfWeek.subtract(const Duration(seconds: 1)),
          ) &&
          t.scheduledAt.isBefore(endOfWeek);
    }).length;

    return CrmAgendaMetricsResponse(
      totalTasks: totalTasks,
      pendingTasksCount: pendingCount,
      completedTasksCount: completedCount,
      todayTasksCount: todayTasksCount,
      overdueTasksCount: overdueTasksCount,
      thisWeekTasksCount: thisWeekTasksCount,
    );
  }
}
