import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/crm_agenda_service.dart';

String _formatDateShort(DateTime d) {
  const months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  return '${d.day.toString().padLeft(2, '0')}/${months[d.month - 1]}/${d.year} (${days[d.weekday - 1]})';
}

String _formatMonthYear(DateTime d) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${months[d.month - 1]} ${d.year}';
}

String _formatDateLong(DateTime d) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${d.day} de ${months[d.month - 1]}, ${d.year}';
}

/// Vista de Agenda Comercial, Calendario Interactivo y Recordatorios Inteligentes.
class CrmActivitiesView extends StatefulWidget {
  const CrmActivitiesView({super.key});

  @override
  State<CrmActivitiesView> createState() => _CrmActivitiesViewState();
}

class _CrmActivitiesViewState extends State<CrmActivitiesView> {
  final CrmAgendaService _agendaService = CrmAgendaService();

  late DateTime _selectedDate;
  late DateTime _currentMonth;
  String _activeFilter =
      'Fecha'; // 'Fecha', 'Hoy', 'Vencidas', 'Semana', 'Completadas', 'Todas'
  String _typeFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
    _agendaService.addListener(_onServiceUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _agendaService.loadTasks();
      }
    });
  }

  @override
  void dispose() {
    _agendaService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  Color _getTaskTypeColor(String type) {
    switch (type) {
      case CrmTaskType.call:
        return const Color(0xFF10B981); // Esmeralda / Verde llamada
      case CrmTaskType.quotation:
        return const Color(0xFF3B82F6); // Azul cotización
      case CrmTaskType.siteVisit:
        return const Color(0xFF8B5CF6); // Púrpura visita
      case CrmTaskType.whatsapp:
        return const Color(0xFF22C55E); // WhatsApp verde
      case CrmTaskType.payment:
        return const Color(0xFFF59E0B); // Ámbar cobros
      case CrmTaskType.meeting:
        return const Color(0xFF06B6D4); // Cian reuniones
      case CrmTaskType.postSale:
        return const Color(0xFF10B981); // Esmeralda postventa
      case CrmTaskType.renewal:
        return const Color(0xFF6366F1); // Índigo renovación
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getTaskTypeIcon(String type) {
    switch (type) {
      case CrmTaskType.call:
        return Icons.phone_in_talk_outlined;
      case CrmTaskType.quotation:
        return Icons.request_quote_outlined;
      case CrmTaskType.siteVisit:
        return Icons.pin_drop_outlined;
      case CrmTaskType.whatsapp:
        return Icons.chat_bubble_outline;
      case CrmTaskType.payment:
        return Icons.payments_outlined;
      case CrmTaskType.meeting:
        return Icons.groups_outlined;
      case CrmTaskType.postSale:
        return Icons.verified_outlined;
      case CrmTaskType.renewal:
        return Icons.autorenew_outlined;
      default:
        return Icons.event_note_outlined;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta / Urgente':
        return const Color(0xFFEF4444);
      case 'Media':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  List<CrmTaskItem> _getFilteredTasks() {
    List<CrmTaskItem> baseTasks = _agendaService.tasks;

    if (_activeFilter == 'Hoy') {
      baseTasks = _agendaService.getTodayTasks();
    } else if (_activeFilter == 'Vencidas') {
      baseTasks = _agendaService.getOverdueTasks();
    } else if (_activeFilter == 'Semana') {
      final now = DateTime.now();
      final start = now.subtract(Duration(days: now.weekday - 1));
      final end = start.add(const Duration(days: 7));
      baseTasks = baseTasks
          .where(
            (t) => t.scheduledAt.isAfter(start) && t.scheduledAt.isBefore(end),
          )
          .toList();
    } else if (_activeFilter == 'Completadas') {
      baseTasks = baseTasks.where((t) => t.isCompleted).toList();
    } else if (_activeFilter == 'Todas') {
      baseTasks = baseTasks.toList();
    } else {
      // Filtrar por _selectedDate
      baseTasks = _agendaService.getTasksForDate(_selectedDate);
    }

    if (_typeFilter != 'Todos') {
      baseTasks = baseTasks.where((t) => t.taskType == _typeFilter).toList();
    }

    return baseTasks;
  }

  void _showNewTaskDialog({DateTime? initialDate}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();

    final clientCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final contextCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    DateTime selectedDay = initialDate ?? _selectedDate;
    String selectedTime = '16:00';
    String selectedType = CrmTaskType.call;
    String selectedPriority = 'Alta / Urgente';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dCtx, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_alert_outlined,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registrar Compromiso Comercial',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Guarda lo que te dijeron en la llamada y fija un recordatorio inteligente.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 540,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Tipo de Tarea (Chips)
                        Text(
                          'TIPO DE COMPROMISO',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: CrmTaskType.all.map((t) {
                            final isSel = selectedType == t;
                            final col = _getTaskTypeColor(t);
                            return ChoiceChip(
                              avatar: Icon(
                                _getTaskTypeIcon(t),
                                size: 14,
                                color: isSel ? Colors.white : col,
                              ),
                              label: Text(t),
                              selected: isSel,
                              selectedColor: col,
                              labelStyle: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSel
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.white70
                                          : const Color(0xFF334155)),
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setModalState(() {
                                    selectedType = t;
                                    if (titleCtrl.text.isEmpty ||
                                        titleCtrl.text.startsWith('Llamar') ||
                                        titleCtrl.text.startsWith('Enviar') ||
                                        titleCtrl.text.startsWith('Visita')) {
                                      if (t == CrmTaskType.call) {
                                        titleCtrl.text =
                                            'Llamada de seguimiento';
                                      } else if (t == CrmTaskType.quotation) {
                                        titleCtrl.text =
                                            'Enviar cotización formal';
                                      } else if (t == CrmTaskType.siteVisit) {
                                        titleCtrl.text =
                                            'Inspección técnica en sitio';
                                      }
                                    }
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 14),

                        // Datos del Cliente y Teléfono
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: clientCtrl,
                                style: GoogleFonts.inter(fontSize: 12.5),
                                decoration: InputDecoration(
                                  labelText: 'Empresa o Cliente *',
                                  hintText: 'Ej: Torre Titanium',
                                  prefixIcon: const Icon(
                                    Icons.business,
                                    size: 18,
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Ingresa el nombre del cliente'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: phoneCtrl,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Teléfono / WhatsApp',
                                  hintText: '77312890',
                                  prefixIcon: const Icon(Icons.phone, size: 18),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: contactCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Persona de Contacto / Cargo',
                            hintText:
                                'Ej: Lic. Marcelo Justiniano (Administrador)',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              size: 18,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Campo Clave: Contexto de la llamada
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF59E0B,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.record_voice_over_outlined,
                                    size: 16,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '¿QUÉ TE DIJERON EN LA LLAMADA? (CONTEXTO CLAVE) *',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: contextCtrl,
                                maxLines: 2,
                                style: GoogleFonts.inter(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText:
                                      'Ej: "La secretaria indicó que el administrador llega a las 4:00 PM, llamar a esa hora puntual para revisar el presupuesto."',
                                  isDense: true,
                                  fillColor: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Anota qué te dijeron para que no se olvide el contexto'
                                    : null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Selección de Fecha & Hora Rápida
                        Row(
                          children: [
                            // Selector de Fecha
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FECHA DEL RECORDATORIO',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: dCtx,
                                        initialDate: selectedDay,
                                        firstDate: DateTime(2025),
                                        lastDate: DateTime(2030),
                                      );
                                      if (picked != null) {
                                        setModalState(
                                          () => selectedDay = picked,
                                        );
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFCBD5E1),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatDateShort(selectedDay),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.calendar_month,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Selector de Hora
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HORA EXACTA',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue:
                                        [
                                          '09:00',
                                          '10:30',
                                          '11:30',
                                          '14:00',
                                          '16:00',
                                          '17:30',
                                          '18:00',
                                        ].contains(selectedTime)
                                        ? selectedTime
                                        : '16:00',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 9,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items:
                                        [
                                              '09:00',
                                              '10:30',
                                              '11:30',
                                              '14:00',
                                              '16:00',
                                              '17:30',
                                              '18:00',
                                            ]
                                            .map(
                                              (h) => DropdownMenuItem(
                                                value: h,
                                                child: Text(h),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setModalState(() => selectedTime = v);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Prioridad
                        Row(
                          children: [
                            Text(
                              'Prioridad: ',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Wrap(
                              spacing: 6,
                              children: ['Alta / Urgente', 'Media', 'Normal']
                                  .map((p) {
                                    final isSel = selectedPriority == p;
                                    final col = _getPriorityColor(p);
                                    return ChoiceChip(
                                      label: Text(p),
                                      selected: isSel,
                                      selectedColor: col,
                                      labelStyle: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        fontWeight: isSel
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSel ? Colors.white : col,
                                      ),
                                      onSelected: (val) {
                                        if (val) {
                                          setModalState(
                                            () => selectedPriority = p,
                                          );
                                        }
                                      },
                                    );
                                  })
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final title = titleCtrl.text.trim().isNotEmpty
                          ? titleCtrl.text.trim()
                          : '$selectedType: ${clientCtrl.text.trim()}';

                      final newTask = CrmTaskItem(
                        id: 'TSK-${DateTime.now().millisecondsSinceEpoch % 100000}',
                        title: title,
                        taskType: selectedType,
                        clientName: clientCtrl.text.trim(),
                        contactPerson: contactCtrl.text.trim().isNotEmpty
                            ? contactCtrl.text.trim()
                            : 'Contacto Principal',
                        phone: phoneCtrl.text.trim(),
                        scheduledAt: DateTime(
                          selectedDay.year,
                          selectedDay.month,
                          selectedDay.day,
                          int.tryParse(selectedTime.split(':')[0]) ?? 16,
                          int.tryParse(selectedTime.split(':')[1]) ?? 0,
                        ),
                        scheduledTimeText: selectedTime,
                        priority: selectedPriority,
                        status: 'Pendiente',
                        callContext: contextCtrl.text.trim(),
                        notes: notesCtrl.text.trim(),
                        createdAt: DateTime.now(),
                      );

                      _agendaService.addTask(newTask);
                      setState(() {
                        _selectedDate = selectedDay;
                        _activeFilter = 'Fecha';
                      });
                      Navigator.pop(dCtx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF0F172A),
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '¡Compromiso agendado para las $selectedTime con "${newTask.clientName}"!',
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.alarm_add, size: 18),
                  label: Text(
                    'Guardar y Notificar',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPostponeMenu(BuildContext context, CrmTaskItem task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Material(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.85,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.update, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Text(
                          'Posponer Compromiso',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selecciona cuánto tiempo posponer "${task.title}":',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.flash_on,
                        color: Color(0xFFEF4444),
                      ),
                      title: const Text(
                        'Posponer +5 Minutos (Llamar enseguida)',
                      ),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(minutes: 5),
                          reason: 'Llamar en 5 minutos',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.timer_outlined,
                        color: Color(0xFFF59E0B),
                      ),
                      title: const Text('Posponer +15 Minutos (En breve)'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(minutes: 15),
                          reason: 'Llamar en 15 minutos',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.schedule,
                        color: Color(0xFF3B82F6),
                      ),
                      title: const Text('Posponer +30 Minutos'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(minutes: 30),
                          reason: 'Llamar en 30 minutos',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.hourglass_top,
                        color: Color(0xFF6366F1),
                      ),
                      title: const Text('Posponer +1 Hora'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(hours: 1),
                          reason: 'Llamar en 1 hora',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.timer_outlined,
                        color: Color(0xFF3B82F6),
                      ),
                      title: const Text('Posponer +2 Horas (Hoy más tarde)'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(hours: 2),
                          reason: 'Cliente ocupado, pidió llamar en 2 horas',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.today_outlined,
                        color: Color(0xFF10B981),
                      ),
                      title: const Text('Posponer para Mañana a la misma hora'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(days: 1),
                          reason: 'No contestó / Pidió llamar mañana',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.date_range_outlined,
                        color: Color(0xFF8B5CF6),
                      ),
                      title: const Text('Posponer +3 Días'),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(days: 3),
                          reason: 'Esperando respuesta de gerencia',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.next_plan_outlined,
                        color: Color(0xFFF59E0B),
                      ),
                      title: const Text(
                        'Posponer para la Próxima Semana (+7 días)',
                      ),
                      onTap: () {
                        _agendaService.postponeTask(
                          task.id,
                          const Duration(days: 7),
                          reason: 'Cliente de viaje o en cierre de mes',
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.edit_calendar_outlined,
                        color: Color(0xFF10B981),
                      ),
                      title: const Text(
                        'Personalizado (Elegir fecha y hora exacta)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: const Text('Elegir día y hora exacta'),
                      onTap: () {
                        Navigator.pop(ctx);
                        _showCustomPostponeDialog(task);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomPostponeDialog(CrmTaskItem task) async {
    DateTime selectedDate = task.scheduledAt.isBefore(DateTime.now())
        ? DateTime.now()
        : task.scheduledAt;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(minutes: 5)),
    );
    final reasonCtrl = TextEditingController(text: 'Llamar a hora específica');

    await showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.edit_calendar_outlined,
                              color: Color(0xFF10B981),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha y Hora Personalizada',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  task.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Botones rápidos de minutos
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Text(
                            'Llamar en:',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          for (final m in [5, 10, 20, 45])
                            ActionChip(
                              label: Text('+$m min'),
                              onPressed: () {
                                final newDt = DateTime.now().add(
                                  Duration(minutes: m),
                                );
                                setModalState(() {
                                  selectedDate = newDt;
                                  selectedTime = TimeOfDay.fromDateTime(newDt);
                                  reasonCtrl.text = 'Llamar en $m minutos';
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Selección de Fecha y Hora
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 1),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (d != null) {
                                  setModalState(() => selectedDate = d);
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Color(0xFF3B82F6),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final t = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (t != null) {
                                  setModalState(() => selectedTime = t);
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: reasonCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Motivo / Nota de reprogramación',
                          hintText: 'Ej: Pedir cotización de nuevo número',
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 11,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final combined = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              _agendaService.rescheduleTask(
                                task.id,
                                combined,
                                reason: reasonCtrl.text.trim().isNotEmpty
                                    ? reasonCtrl.text.trim()
                                    : 'Reprogramada',
                              );
                              Navigator.pop(ctx);
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF065F46),
                                  content: Text(
                                    'Compromiso pospuesto para las ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Guardar Fecha y Hora'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredTasks = _getFilteredTasks();

    return ListenableBuilder(
      listenable: _agendaService,
      builder: (context, _) {
        final overdueCount = _agendaService.overdueTasksCount;
        final todayCount = _agendaService.todayTasksCount;
        final weekCount = _agendaService.thisWeekTasksCount;
        final completedCount = _agendaService.completedTasksCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Principal
              _buildHeader(isDark),

              const SizedBox(height: 18),

              // 2. Banner de Alerta Activa si hay Vencidas o Pendientes de Hoy
              if (overdueCount > 0 || todayCount > 0)
                _buildAlertBanner(overdueCount, todayCount, isDark),

              const SizedBox(height: 16),

              // 3. KPIs de Seguimiento
              _buildKpiCards(
                overdueCount,
                todayCount,
                weekCount,
                completedCount,
                isDark,
              ),

              const SizedBox(height: 20),

              // 4. Filtros Rápidos
              _buildQuickFilters(isDark),

              const SizedBox(height: 20),

              // 5. Layout Principal: Calendario Interactivo a la Izquierda y Lista de Compromisos a la Derecha
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 960;
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Columna Izquierda: Calendario Interactivo
                        SizedBox(
                          width: 360,
                          child: _buildInteractiveCalendar(isDark),
                        ),
                        const SizedBox(width: 20),
                        // Columna Derecha: Lista y Timeline de Tareas
                        Expanded(
                          child: _buildTaskListPanel(filteredTasks, isDark),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildInteractiveCalendar(isDark),
                        const SizedBox(height: 20),
                        _buildTaskListPanel(filteredTasks, isDark),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'AGENDA & PROSPECCIÓN CRM',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Elite Multiservicios',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Agenda Comercial & Recordatorios',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Calendario interactivo de compromisos, llamadas y envíos de cotizaciones programadas.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            elevation: 0,
          ),
          onPressed: () => _showNewTaskDialog(),
          icon: const Icon(Icons.add_alarm, size: 18),
          label: Text(
            'Registrar Compromiso',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBanner(int overdue, int today, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: overdue > 0
            ? const Color(0xFFEF4444).withValues(alpha: 0.1)
            : const Color(0xFFF59E0B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: overdue > 0
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFFF59E0B).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            overdue > 0 ? Icons.error_outline : Icons.alarm_on,
            color: overdue > 0
                ? const Color(0xFFEF4444)
                : const Color(0xFFF59E0B),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overdue > 0
                      ? '¡Tienes $overdue compromiso(s) vencido(s) que requieren atención inmediata!'
                      : '¡Tienes $today llamada(s) y tarea(s) programadas para hoy!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: overdue > 0
                        ? const Color(0xFFEF4444)
                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                ),
                Text(
                  'Revisa el contexto anotado de cada llamada para no perder la oportunidad con el cliente.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (overdue > 0)
            TextButton(
              onPressed: () {
                setState(() => _activeFilter = 'Vencidas');
              },
              child: Text(
                'Ver Vencidas',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKpiCards(
    int overdue,
    int today,
    int week,
    int completed,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            label: 'COMPROMISOS HOY',
            value: '$today',
            color: const Color(0xFF10B981),
            icon: Icons.today,
            isDark: isDark,
            isSelected: _activeFilter == 'Hoy',
            onTap: () => setState(() => _activeFilter = 'Hoy'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            label: 'VENCIDAS / URGENTES',
            value: '$overdue',
            color: const Color(0xFFEF4444),
            icon: Icons.warning_amber_rounded,
            isDark: isDark,
            isSelected: _activeFilter == 'Vencidas',
            onTap: () => setState(() => _activeFilter = 'Vencidas'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            label: 'ESTA SEMANA',
            value: '$week',
            color: const Color(0xFF3B82F6),
            icon: Icons.date_range,
            isDark: isDark,
            isSelected: _activeFilter == 'Semana',
            onTap: () => setState(() => _activeFilter = 'Semana'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            label: 'COMPLETADAS',
            value: '$completed',
            color: const Color(0xFF8B5CF6),
            icon: Icons.check_circle_outline,
            isDark: isDark,
            isSelected: _activeFilter == 'Completadas',
            onTap: () => setState(() => _activeFilter = 'Completadas'),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    required bool isDark,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 6,
          children: [
            _buildFilterChip('Fecha Seleccionada', 'Fecha', isDark),
            _buildFilterChip('Hoy', 'Hoy', isDark),
            _buildFilterChip('Vencidas', 'Vencidas', isDark),
            _buildFilterChip('Esta Semana', 'Semana', isDark),
            _buildFilterChip('Completadas', 'Completadas', isDark),
            _buildFilterChip('Todas', 'Todas', isDark),
          ],
        ),
        DropdownButton<String>(
          value: _typeFilter,
          underline: const SizedBox(),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
          ),
          items: ['Todos', ...CrmTaskType.all].map((t) {
            return DropdownMenuItem(value: t, child: Text(t));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _typeFilter = val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSel = _activeFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSel,
      selectedColor: const Color(0xFF10B981),
      labelStyle: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
        color: isSel
            ? Colors.white
            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      ),
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF1F5F9),
      onSelected: (val) {
        if (val) {
          setState(() => _activeFilter = value);
        }
      },
    );
  }

  // ==========================================
  // CALENDARIO INTERACTIVO MENSUAL
  // ==========================================

  Widget _buildInteractiveCalendar(bool isDark) {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    final firstDayOfWeek = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday; // 1 = Lunes, 7 = Domingo

    final monthName = _formatMonthYear(_currentMonth);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del Mes & Navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName[0].toUpperCase() + monthName.substring(1),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month - 1,
                          1,
                        );
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      final now = DateTime.now();
                      setState(() {
                        _currentMonth = DateTime(now.year, now.month, 1);
                        _selectedDate = DateTime(now.year, now.month, now.day);
                        _activeFilter = 'Fecha';
                      });
                    },
                    child: Text(
                      'Hoy',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                          1,
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((d) {
              return SizedBox(
                width: 36,
                child: Center(
                  child: Text(
                    d,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Grilla de Días
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 semanas fijas
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayOffset = index - (firstDayOfWeek - 1);
              if (dayOffset < 0 || dayOffset >= daysInMonth) {
                return const SizedBox();
              }

              final dayNumber = dayOffset + 1;
              final cellDate = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                dayNumber,
              );

              final isToday =
                  cellDate.year == DateTime.now().year &&
                  cellDate.month == DateTime.now().month &&
                  cellDate.day == DateTime.now().day;

              final isSelected =
                  cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;

              // Obtener tareas de ese día para dibujar puntos de colores
              final dayTasks = _agendaService.getTasksForDate(cellDate);

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = cellDate;
                    _activeFilter = 'Fecha';
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : (isToday
                              ? (isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9))
                              : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSelected
                        ? Border.all(color: const Color(0xFF10B981), width: 1.2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: (isSelected || isToday)
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A)),
                        ),
                      ),
                      if (dayTasks.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dayTasks.take(3).map((t) {
                            final col = isSelected
                                ? Colors.white
                                : _getTaskTypeColor(t.taskType);
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: col,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Leyenda de Marcadores
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _buildLegendItem('Llamada', const Color(0xFF10B981)),
              _buildLegendItem('Cotización', const Color(0xFF3B82F6)),
              _buildLegendItem('Visita', const Color(0xFF8B5CF6)),
              _buildLegendItem('Cobro', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PANEL DERECHO: TIMELINE Y TAREAS
  // ==========================================

  Widget _buildTaskListPanel(List<CrmTaskItem> tasks, bool isDark) {
    String headerTitle;
    if (_activeFilter == 'Hoy') {
      headerTitle = 'Compromisos para Hoy';
    } else if (_activeFilter == 'Vencidas') {
      headerTitle = 'Compromisos Vencidos / Por Regularizar';
    } else if (_activeFilter == 'Semana') {
      headerTitle = 'Agenda de Esta Semana';
    } else if (_activeFilter == 'Completadas') {
      headerTitle = 'Compromisos Completados';
    } else if (_activeFilter == 'Todas') {
      headerTitle = 'Todos los Compromisos Registrados';
    } else {
      headerTitle = 'Agenda del ${_formatDateLong(_selectedDate)}';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    headerTitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${tasks.length} tareas',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (tasks.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 48,
                      color: const Color(0xFF64748B).withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No hay compromisos pendientes para esta fecha.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () =>
                          _showNewTaskDialog(initialDate: _selectedDate),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Programar Tarea para este Día'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                return _buildTaskCard(tasks[idx], isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(CrmTaskItem task, bool isDark) {
    final typeCol = _getTaskTypeColor(task.taskType);
    final priorityCol = _getPriorityColor(task.priority);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: task.isOverdue
              ? const Color(0xFFEF4444).withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Hora + Tipo + Prioridad + Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.scheduledTimeText,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeCol.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getTaskTypeIcon(task.taskType),
                          size: 12,
                          color: typeCol,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.taskType,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: typeCol,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (task.isOverdue)
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'VENCIDA',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: priorityCol.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.priority,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: priorityCol,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Fila 2: Título y Cliente
          Text(
            task.title,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.business, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  task.clientName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (task.contactPerson.isNotEmpty) ...[
                const SizedBox(width: 8),
                const Text('•', style: TextStyle(color: Color(0xFF64748B))),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    task.contactPerson,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          // Fila 3: Caja de Contexto de la Llamada (Requerimiento del usuario)
          if (task.callContext.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border(
                  left: BorderSide(color: const Color(0xFFF59E0B), width: 3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.callContext,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Fila 4: Acciones Rápidas (Llamar, WhatsApp, Posponer, Completar)
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                children: [
                  if (task.phone.isNotEmpty) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        side: const BorderSide(color: Color(0xFF10B981)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF0F172A),
                            content: Text(
                              'Llamando a ${task.contactPerson} (${task.phone})...',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.phone,
                        size: 14,
                        color: Color(0xFF10B981),
                      ),
                      label: Text(
                        task.phone,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(
                        Icons.chat,
                        size: 16,
                        color: Color(0xFF22C55E),
                      ),
                      tooltip: 'WhatsApp Directo',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF0F172A),
                            content: Text(
                              'Abriendo WhatsApp con ${task.phone}...',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _showPostponeMenu(context, task),
                    icon: const Icon(
                      Icons.update,
                      size: 14,
                      color: Color(0xFFF59E0B),
                    ),
                    label: Text(
                      'Posponer',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted
                          ? const Color(0xFF64748B)
                          : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _agendaService.toggleTaskCompleted(task.id);
                    },
                    icon: Icon(
                      task.isCompleted ? Icons.undo : Icons.check,
                      size: 14,
                    ),
                    label: Text(
                      task.isCompleted ? 'Reabrir' : 'Completada',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
