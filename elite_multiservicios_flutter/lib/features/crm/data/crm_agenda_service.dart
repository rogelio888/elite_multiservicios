import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/widgets.dart';
import '../../../main.dart' show client;

/// Tipos de compromisos y tareas comerciales en el CRM.
class CrmTaskType {
  static const String call = 'Llamada de Seguimiento';
  static const String quotation = 'Enviar Cotización';
  static const String siteVisit = 'Visita Técnica';
  static const String meeting = 'Reunión Presencial / Virtual';
  static const String whatsapp = 'Mensaje WhatsApp';
  static const String payment = 'Cobro / Seguimiento de Anticipo';
  static const String postSale = 'Postventa / Control de Calidad';
  static const String renewal = 'Renovación de Contrato';

  static const List<String> all = [
    call,
    quotation,
    siteVisit,
    meeting,
    whatsapp,
    payment,
    postSale,
    renewal,
  ];
}

/// Modelo de un compromiso o tarea agendada en el CRM.
class CrmTaskItem {
  final String id;
  final String title;
  final String taskType; // Usar constantes de CrmTaskType
  final String clientName;
  final String contactPerson;
  final String phone;
  final DateTime scheduledAt;
  final String scheduledTimeText; // Ej: '16:00', '10:30'
  final String priority; // 'Alta / Urgente', 'Media', 'Normal'
  final String status; // 'Pendiente', 'Completada', 'Pospuesta', 'Vencida'
  final String
  callContext; // Ej: "El encargado llega a las 4, llamar a esa hora"
  final String? notes;
  final DateTime createdAt;
  final String? relatedOpportunityId;
  final String? customerId;
  final String? relatedContractId;
  final int? dbId;

  const CrmTaskItem({
    required this.id,
    this.dbId,
    required this.title,
    required this.taskType,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.scheduledAt,
    required this.scheduledTimeText,
    this.priority = 'Media',
    this.status = 'Pendiente',
    this.callContext = '',
    this.notes,
    required this.createdAt,
    this.relatedOpportunityId,
    this.customerId,
    this.relatedContractId,
  });

  bool get isCompleted => status == 'Completada';

  DateTime get fullScheduledDateTime {
    if (scheduledTimeText.contains(':')) {
      final parts = scheduledTimeText.split(':');
      final h = int.tryParse(parts[0]) ?? scheduledAt.hour;
      final m = int.tryParse(parts[1]) ?? scheduledAt.minute;
      return DateTime(
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
        h,
        m,
      );
    }
    return scheduledAt;
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    return fullScheduledDateTime.isBefore(now);
  }

  bool isSameDay(DateTime date) {
    return scheduledAt.year == date.year &&
        scheduledAt.month == date.month &&
        scheduledAt.day == date.day;
  }

  bool get isToday {
    return isSameDay(DateTime.now());
  }

  CrmTask toCrmTask() {
    final rawId = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), ''));
    return CrmTask(
      id: rawId != null && rawId > 0 ? rawId : null,
      code: id.startsWith('TSK') ? id : '',
      title: title,
      taskType: taskType,
      clientName: clientName,
      contactPerson: contactPerson,
      phone: phone,
      scheduledAt: scheduledAt.toUtc(),
      scheduledTimeText: scheduledTimeText,
      priority: priority,
      status: status,
      callContext: callContext,
      notes: notes,
      isDeleted: false,
      createdAt: createdAt.toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  CrmTaskItem copyWith({
    String? title,
    String? taskType,
    String? clientName,
    String? contactPerson,
    String? phone,
    DateTime? scheduledAt,
    String? scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    String? relatedOpportunityId,
    String? customerId,
    String? relatedContractId,
    int? dbId,
  }) {
    return CrmTaskItem(
      id: id,
      dbId: dbId ?? this.dbId,
      title: title ?? this.title,
      taskType: taskType ?? this.taskType,
      clientName: clientName ?? this.clientName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      scheduledTimeText: scheduledTimeText ?? this.scheduledTimeText,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      callContext: callContext ?? this.callContext,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      relatedOpportunityId: relatedOpportunityId ?? this.relatedOpportunityId,
      customerId: customerId ?? this.customerId,
      relatedContractId: relatedContractId ?? this.relatedContractId,
    );
  }
}

/// Servicio reactivo singleton para la gestión de la Agenda Comercial y Recordatorios
/// conectado directamente a los endpoints RPC de Serverpod y PostgreSQL.
class CrmAgendaService extends ChangeNotifier {
  static final CrmAgendaService _instance = CrmAgendaService._internal();
  factory CrmAgendaService({Client? customClient}) {
    if (customClient != null) {
      _instance._clientOverride = customClient;
    }
    return _instance;
  }

  CrmAgendaService._internal();

  Client? _clientOverride;
  Client get _activeClient => _clientOverride ?? client;

  final List<CrmTaskItem> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<CrmTaskItem> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga la lista de compromisos reales desde PostgreSQL vía Serverpod RPC.
  Future<void> loadTasks({
    DateTime? date,
    String? status,
    String? taskType,
  }) async {
    _isLoading = true;
    _error = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isLoading) {
        notifyListeners();
      }
    });

    try {
      final remoteTasks = await _activeClient.crmAgenda.listTasks(
        limit: 200,
        offset: 0,
        status: status,
        taskType: taskType,
      );

      _tasks.clear();
      for (final t in remoteTasks) {
        _tasks.add(_fromCrmTask(t));
      }
    } catch (e) {
      debugPrint('[CrmAgendaService] Error al cargar tareas: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get totalTasks => _tasks.length;

  int get pendingTasksCount =>
      _tasks.where((t) => t.status != 'Completada').length;

  int get completedTasksCount =>
      _tasks.where((t) => t.status == 'Completada').length;

  int get todayTasksCount {
    final now = DateTime.now();
    return _tasks.where((t) => t.isSameDay(now) && !t.isCompleted).length;
  }

  int get overdueTasksCount => _tasks.where((t) => t.isOverdue).length;

  int get thisWeekTasksCount {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final start = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final end = DateTime(
      endOfWeek.year,
      endOfWeek.month,
      endOfWeek.day,
      23,
      59,
      59,
    );

    return _tasks.where((t) {
      return !t.isCompleted &&
          t.scheduledAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
          t.scheduledAt.isBefore(end);
    }).length;
  }

  List<CrmTaskItem> getTasksForDate(DateTime date) {
    return _tasks.where((t) => t.isSameDay(date)).toList()
      ..sort((a, b) => a.scheduledTimeText.compareTo(b.scheduledTimeText));
  }

  List<CrmTaskItem> getOverdueTasks() {
    return _tasks.where((t) => t.isOverdue).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<CrmTaskItem> getTodayTasks() {
    final now = DateTime.now();
    return getTasksForDate(now);
  }

  Future<void> addTask(CrmTaskItem task) async {
    _tasks.insert(0, task);
    notifyListeners();

    try {
      await _activeClient.crmAgenda.createTask(task.toCrmTask());
      await loadTasks();
    } catch (e) {
      debugPrint('[CrmAgendaService] Error al crear tarea en backend: $e');
    }
  }

  static CrmTaskItem _fromCrmTask(CrmTask t) {
    return CrmTaskItem(
      id: t.code.isNotEmpty ? t.code : (t.id?.toString() ?? ''),
      dbId: t.id,
      title: t.title,
      taskType: t.taskType,
      clientName: t.clientName,
      contactPerson: t.contactPerson,
      phone: t.phone,
      scheduledAt: t.scheduledAt.toLocal(),
      scheduledTimeText: t.scheduledTimeText,
      priority: t.priority,
      status: t.status,
      callContext: t.callContext ?? '',
      notes: t.notes,
      createdAt: t.createdAt.toLocal(),
      relatedOpportunityId: t.opportunityId?.toString(),
      customerId: t.customerId?.toString(),
      relatedContractId: t.contractId?.toString(),
    );
  }

  Future<void> toggleTaskCompleted(String taskId) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final current = _tasks[idx];
      final newStatus = current.isCompleted ? 'Pendiente' : 'Completada';
      final updated = current.copyWith(status: newStatus);
      _tasks[idx] = updated;
      notifyListeners();

      final rawId = int.tryParse(taskId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawId != null && rawId > 0) {
        try {
          if (newStatus == 'Completada') {
            await _activeClient.crmAgenda.completeTask(rawId);
          } else {
            await _activeClient.crmAgenda.updateTask(updated.toCrmTask());
          }
        } catch (e) {
          debugPrint(
            '[CrmAgendaService] Error al persistir estado completado en PostgreSQL: $e',
          );
        }
      }
    }
  }

  List<CrmTaskItem> get urgentOrTodayPendingTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      if (t.isCompleted) return false;
      return t.isOverdue || t.isSameDay(now);
    }).toList()..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  int get activeAlertsCount => urgentOrTodayPendingTasks.length;

  void postponeTask(String taskId, Duration duration, {String? reason}) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final current = _tasks[idx];
      final now = DateTime.now();
      // Si la hora ya pasó, posponer a partir de ahora, sino desde la hora programada
      final base = current.scheduledAt.isBefore(now)
          ? now
          : current.scheduledAt;
      final newDate = base.add(duration);
      rescheduleTask(taskId, newDate, reason: reason);
    }
  }

  void rescheduleTask(String taskId, DateTime newDateTime, {String? reason}) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final current = _tasks[idx];
      final updatedNotes = reason != null && reason.isNotEmpty
          ? '${current.notes ?? ""}\n[Pospuesta]: $reason'.trim()
          : current.notes;

      final timeText =
          '${newDateTime.hour.toString().padLeft(2, '0')}:${newDateTime.minute.toString().padLeft(2, '0')}';

      _tasks[idx] = current.copyWith(
        scheduledAt: newDateTime,
        scheduledTimeText: timeText,
        status: 'Pospuesta',
        notes: updatedNotes,
      );
      notifyListeners();

      // Persistir cambio en PostgreSQL
      final rawId = int.tryParse(taskId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawId != null && rawId > 0) {
        () async {
          try {
            await _activeClient.crmAgenda.updateTask(_tasks[idx].toCrmTask());
          } catch (e) {
            debugPrint(
              '[CrmAgendaService] Error al reprogramar tarea en PostgreSQL: $e',
            );
          }
        }();
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    final item = _tasks.where((t) => t.id == taskId).firstOrNull;
    final rawId =
        item?.dbId ?? int.tryParse(taskId.replaceAll(RegExp(r'[^0-9]'), ''));
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();

    if (rawId != null && rawId > 0) {
      try {
        await _activeClient.crmAgenda.deleteTask(rawId);
      } catch (e) {
        debugPrint(
          '[CrmAgendaService] Error al eliminar tarea en PostgreSQL: $e',
        );
      }
    }
  }

  @visibleForTesting
  void initDefaultTasksForTesting() {
    _tasks.clear();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final inTwoDays = today.add(const Duration(days: 2));

    _tasks.addAll([
      CrmTaskItem(
        id: 'TSK-001',
        title: 'Llamar al Administrador (Confirmar Visita Técnica)',
        taskType: CrmTaskType.call,
        clientName: 'Condominio Las Palmas Real',
        contactPerson: 'Lic. Marcelo Justiniano',
        phone: '77312890',
        scheduledAt: today,
        scheduledTimeText: '16:00',
        priority: 'Alta / Urgente',
        status: 'Pendiente',
        callContext:
            'En llamada previa la secretaria indicó que el Administrador llega al condominio exactamente a las 16:00.',
        notes: 'Coordinar ingreso por garita principal y equipo de medición.',
        createdAt: now.subtract(const Duration(hours: 4)),
        relatedOpportunityId: 'OPP-101',
      ),
      CrmTaskItem(
        id: 'TSK-002',
        title: 'Enviar Cotización Formal de Limpieza de Obra',
        taskType: CrmTaskType.quotation,
        clientName: 'Torre Corporativa Titanium',
        contactPerson: 'Ing. Rodrigo Paz',
        phone: '71092834',
        scheduledAt: tomorrow,
        scheduledTimeText: '09:30',
        priority: 'Alta / Urgente',
        status: 'Pendiente',
        callContext:
            'Cliente solicitó tener el PDF formal con desglose de cuadrillas antes de la reunión de directorio del viernes a las 11:00.',
        notes:
            'Incluir cláusula de garantía de entrega en 7 días hábiles y 50% de anticipo.',
        createdAt: now.subtract(const Duration(hours: 8)),
        relatedOpportunityId: 'OPP-102',
      ),
      CrmTaskItem(
        id: 'TSK-003',
        title: 'Reconfirmar fecha de inspección técnica en planta',
        taskType: CrmTaskType.call,
        clientName: 'Industrias Fidalga S.A.',
        contactPerson: 'Lic. Claudia Montero',
        phone: '78291023',
        scheduledAt: today,
        scheduledTimeText: '11:30',
        priority: 'Media',
        status: 'Pendiente',
        callContext:
            'Pidieron llamar a media mañana para confirmar si el jefe de planta autorizó el acceso de la cuadrilla técnica.',
        notes: 'Verificar si requieren botines dieléctricos y casco.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CrmTaskItem(
        id: 'TSK-004',
        title: 'Revisión y Seguimiento de Pago de Anticipo (50%)',
        taskType: CrmTaskType.payment,
        clientName: 'Colegio Saint Peter Campus Norte',
        contactPerson: 'Lic. Patricia Suarez',
        phone: '76589123',
        scheduledAt: inTwoDays,
        scheduledTimeText: '15:00',
        priority: 'Normal',
        status: 'Pendiente',
        callContext:
            'Contrato firmado. La contadora prometió emitir el comprobante de transferencia bancaria del anticipo el día jueves.',
        notes:
            'Una vez acreditado en cuenta, pasar orden de trabajo a Operaciones.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      CrmTaskItem(
        id: 'TSK-005',
        title: 'Llamada de primer contacto con prospecto web',
        taskType: CrmTaskType.call,
        clientName: 'Constructora Urubó Premium',
        contactPerson: 'Arq. Gabriel Torrico',
        phone: '73948572',
        scheduledAt: yesterday,
        scheduledTimeText: '14:00',
        priority: 'Media',
        status: 'Pendiente',
        callContext:
            'Llenaron formulario en la web solicitando cotización de limpieza de vidrios en altura.',
        notes: 'No contestó en el primer intento. Reintentar hoy.',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ]);
  }
}
