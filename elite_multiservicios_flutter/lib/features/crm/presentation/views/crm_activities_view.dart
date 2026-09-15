import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de Actividad / Tarea Comercial.
class ActivityItem {
  final String id;
  final String title;
  final String
  type; // 'Visita Técnica', 'Reunión', 'Llamada', 'WhatsApp', 'Propuesta'
  final String clientName;
  final String date;
  final String time;
  final String agent;
  final String priority; // 'Alta', 'Media', 'Normal'
  final bool isCompleted;
  final String notes;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.type,
    required this.clientName,
    required this.date,
    required this.time,
    required this.agent,
    required this.priority,
    required this.isCompleted,
    required this.notes,
  });

  ActivityItem copyWith({bool? isCompleted}) {
    return ActivityItem(
      id: id,
      title: title,
      type: type,
      clientName: clientName,
      date: date,
      time: time,
      agent: agent,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes,
    );
  }
}

/// Vista de Agenda Comercial y Bitácora de Interacciones.
class CrmActivitiesView extends StatefulWidget {
  const CrmActivitiesView({super.key});

  @override
  State<CrmActivitiesView> createState() => _CrmActivitiesViewState();
}

class _CrmActivitiesViewState extends State<CrmActivitiesView> {
  String _selectedType = 'Todas';

  final List<ActivityItem> _activities = [
    const ActivityItem(
      id: 'ACT-01',
      title: 'Levantamiento técnico de áreas comunes y perímetros',
      type: 'Visita Técnica',
      clientName: 'Condominio Las Palmas Real',
      date: 'Hoy, 14 Sep',
      time: '15:30',
      agent: 'Ing. Carlos Mendoza (Técnico)',
      priority: 'Alta',
      isCompleted: false,
      notes:
          'Calcular metros lineales de reja perimetral y puntos ciegos para 3 guardias de seguridad.',
    ),
    const ActivityItem(
      id: 'ACT-02',
      title: 'Reunión de presentación de propuesta de software',
      type: 'Reunión',
      clientName: 'TechLogistics Bolivia S.R.L.',
      date: 'Mañana, 15 Sep',
      time: '10:00',
      agent: 'Rogelio A. (Tech Lead)',
      priority: 'Alta',
      isCompleted: false,
      notes:
          'Demostración de módulos de trazabilidad de pedidos y arquitectura Serverpod/Flutter.',
    ),
    const ActivityItem(
      id: 'ACT-03',
      title: 'Llamada de seguimiento a licitación de limpieza',
      type: 'Llamada',
      clientName: 'Torre Corporativa Titanium',
      date: 'Hoy, 14 Sep',
      time: '11:00',
      agent: 'Elena R. (Ejecutiva)',
      priority: 'Media',
      isCompleted: true,
      notes:
          'Confirmaron recepción de cotización revisada. Decisión final del directorio el jueves.',
    ),
    const ActivityItem(
      id: 'ACT-04',
      title: 'Envío de cotización formal de jardinería trimestral',
      type: 'Propuesta',
      clientName: 'Colegio Saint Peter Campus Norte',
      date: '12 Sep 2026',
      time: '16:45',
      agent: 'Carlos V. (Comercial)',
      priority: 'Normal',
      isCompleted: true,
      notes:
          'Se adjuntó tarifario por corte, abono orgánico y control de malezas.',
    ),
  ];

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'Visita Técnica':
        return Icons.pin_drop_outlined;
      case 'Reunión':
        return Icons.videocam_outlined;
      case 'Llamada':
        return Icons.phone_in_talk_outlined;
      case 'WhatsApp':
        return Icons.chat_bubble_outline;
      case 'Propuesta':
        return Icons.description_outlined;
      default:
        return Icons.event_note_outlined;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'Visita Técnica':
        return const Color(0xFF3B82F6);
      case 'Reunión':
        return const Color(0xFF8B5CF6);
      case 'Llamada':
        return const Color(0xFF10B981);
      case 'WhatsApp':
        return const Color(0xFF22C55E);
      case 'Propuesta':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return const Color(0xFFEF4444);
      case 'Media':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF64748B);
    }
  }

  void _toggleCompleted(int index) {
    setState(() {
      final current = _activities[index];
      _activities[index] = current.copyWith(isCompleted: !current.isCompleted);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _selectedType == 'Todas'
        ? _activities
        : _activities.where((a) => a.type == _selectedType).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          Row(
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
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ACTIVIDADES & AGENDA',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8B5CF6),
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
                      'Agenda Comercial & Seguimiento',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Historial y compromisos de visitas a instalaciones, reuniones y llamadas.',
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF1E293B),
                      content: Text('Formulario de agendamiento rápido.'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_task, size: 18),
                label: Text(
                  'Programar Tarea',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 2. Filtros por Tipo de Actividad
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ['Todas', 'Visita Técnica', 'Reunión', 'Llamada', 'Propuesta']
                    .map(
                      (type) => ChoiceChip(
                        label: Text(type),
                        selected: _selectedType == type,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: _selectedType == type
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _selectedType == type
                              ? Colors.white
                              : (isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B)),
                        ),
                        selectedColor: const Color(0xFF10B981),
                        backgroundColor: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onSelected: (sel) {
                          if (sel) setState(() => _selectedType = type);
                        },
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 20),

          // 3. Timeline / Lista de Actividades
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final act = filtered[idx];
              final typeCol = _getActivityColor(act.type);
              final priorityCol = _getPriorityColor(act.priority);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox de estado completado
                    Checkbox(
                      value: act.isCompleted,
                      activeColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (_) =>
                          _toggleCompleted(_activities.indexOf(act)),
                    ),
                    const SizedBox(width: 8),

                    // Icono de tipo de actividad
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeCol.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getActivityIcon(act.type),
                        color: typeCol,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Información principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                act.title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: act.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: act.isCompleted
                                      ? const Color(0xFF94A3B8)
                                      : (isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A)),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                                  'Prioridad ${act.priority}',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: priorityCol,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            act.clientName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            act.notes,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 13,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${act.date} a las ${act.time}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.person_outline,
                                size: 13,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                act.agent,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
