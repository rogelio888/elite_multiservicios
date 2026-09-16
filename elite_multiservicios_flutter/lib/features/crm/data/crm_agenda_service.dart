import 'package:flutter/foundation.dart';

/// Tipos de compromisos y tareas comerciales en el CRM.
class CrmTaskType {
  static const String call = 'Llamada de Seguimiento';
  static const String quotation = 'Enviar Cotización';
  static const String siteVisit = 'Visita Técnica';
  static const String meeting = 'Reunión Presencial / Virtual';
  static const String whatsapp = 'Mensaje WhatsApp';
  static const String payment = 'Cobro / Seguimiento de Anticipo';

  static const List<String> all = [
    call,
    quotation,
    siteVisit,
    meeting,
    whatsapp,
    payment,
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
  final String callContext; // Ej: "El encargado llega a las 4, llamar a esa hora"
  final String? notes;
  final DateTime createdAt;
  final String? relatedOpportunityId;

  const CrmTaskItem({
    required this.id,
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
  });

  bool get isCompleted => status == 'Completada';

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    return scheduledAt.isBefore(DateTime(now.year, now.month, now.day));
  }

  bool isSameDay(DateTime date) {
    return scheduledAt.year == date.year &&
        scheduledAt.month == date.month &&
        scheduledAt.day == date.day;
  }

  bool get isToday {
    return isSameDay(DateTime.now());
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
  }) {
    return CrmTaskItem(
      id: id,
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
    );
  }
}

/// Servicio reactivo singleton para la gestión de la Agenda Comercial y Recordatorios.
class CrmAgendaService extends ChangeNotifier {
  static final CrmAgendaService _instance = CrmAgendaService._internal();
  factory CrmAgendaService() => _instance;

  CrmAgendaService._internal() {
    _initDefaultTasks();
  }

  final List<CrmTaskItem> _tasks = [];

  List<CrmTaskItem> get tasks => List.unmodifiable(_tasks);

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

  void addTask(CrmTaskItem task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTaskCompleted(String taskId) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final current = _tasks[idx];
      final newStatus = current.isCompleted ? 'Pendiente' : 'Completada';
      _tasks[idx] = current.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void postponeTask(String taskId, Duration duration, {String? reason}) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final current = _tasks[idx];
      final newDate = current.scheduledAt.add(duration);
      final updatedNotes = reason != null && reason.isNotEmpty
          ? '${current.notes ?? ""}\n[Pospuesta]: $reason'.trim()
          : current.notes;

      _tasks[idx] = current.copyWith(
        scheduledAt: newDate,
        status: 'Pospuesta',
        notes: updatedNotes,
      );
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void _initDefaultTasks() {
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
        status: 'Pendiente', // Vencida intencionalmente para mostrar alerta visual
        callContext:
            'Llenaron formulario en la web solicitando cotización de limpieza de vidrios en altura.',
        notes: 'No contestó en el primer intento. Reintentar hoy.',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ]);
  }
}
