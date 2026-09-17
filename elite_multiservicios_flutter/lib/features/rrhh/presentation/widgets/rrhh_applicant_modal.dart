import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_applicant.dart';
import '../../data/services/rrhh_state_service.dart';
import 'rrhh_hire_dialog.dart';
import 'rrhh_shared_widgets.dart';

/// Modal para ver el detalle de un postulante y gestionar su ciclo de selección
class RrhhApplicantModal extends StatefulWidget {
  final RrhhApplicant applicant;

  const RrhhApplicantModal({super.key, required this.applicant});

  @override
  State<RrhhApplicantModal> createState() => _RrhhApplicantModalState();
}

class _RrhhApplicantModalState extends State<RrhhApplicantModal> {
  final _rrhhService = RrhhStateService();
  late String _status;
  late final TextEditingController _interviewNotesController;

  @override
  void initState() {
    super.initState();
    _status = widget.applicant.status;
    _interviewNotesController = TextEditingController(
      text: widget.applicant.interviewNotes ?? '',
    );
  }

  @override
  void dispose() {
    _interviewNotesController.dispose();
    super.dispose();
  }

  void _saveStatus() {
    _rrhhService.updateApplicantStatus(
      widget.applicant.id,
      _status,
      notes: _interviewNotesController.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Estado de postulación actualizado.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _openHireFlow() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) => RrhhHireDialog(initialApplicant: widget.applicant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = widget.applicant;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(
                        0xFF10B981,
                      ).withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.person_search,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.fullName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${app.code} • C.I. ${app.identityCard}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                RrhhStatusChip(status: _status),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              height: 1,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Perfil postulado
                    Row(
                      children: [
                        RrhhEmployeeTypeBadge(employeeType: app.targetType),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Puesto: ${app.targetPosition}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Detalles de contacto
                    _buildSectionHeader('INFORMACIÓN DE CONTACTO Y UBICACIÓN:'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Teléfono:', app.phone, isDark),
                    _buildInfoRow('Correo personal:', app.email, isDark),
                    _buildInfoRow('Dirección:', app.address, isDark),
                    _buildInfoRow(
                      'Contacto emergencia:',
                      '${app.emergencyContact} (${app.emergencyPhone})',
                      isDark,
                    ),
                    const SizedBox(height: 16),

                    // Experiencia y Habilidades
                    _buildSectionHeader('EXPERIENCIA Y FORMACIÓN:'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Formación:', app.education, isDark),
                    _buildInfoRow('Especialidad:', app.specialty, isDark),
                    _buildInfoRow('Resumen:', app.experienceSummary, isDark),
                    _buildInfoRow('Habilidades:', app.skills, isDark),
                    _buildInfoRow(
                      'Referencia:',
                      '${app.referencePerson} (${app.referencePhone})',
                      isDark,
                    ),
                    const SizedBox(height: 16),

                    // Gestión del Estado del Postulante
                    _buildSectionHeader('EVALUACIÓN Y DECISIÓN DE SELECCIÓN:'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: const InputDecoration(
                        labelText: 'Etapa del Postulante',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'NUEVO',
                          child: Text('Nuevo / Recibido'),
                        ),
                        DropdownMenuItem(
                          value: 'EN_EVALUACION',
                          child: Text('En Evaluación / Entrevista'),
                        ),
                        DropdownMenuItem(
                          value: 'SELECCIONADO',
                          child: Text('Seleccionado (Listo para contratar)'),
                        ),
                        DropdownMenuItem(
                          value: 'RECHAZADO',
                          child: Text('Rechazado'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? _status),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _interviewNotesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText:
                            'Notas de Entrevista / Observaciones del Evaluador',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_status == 'SELECCIONADO' || _status == 'EN_EVALUACION')
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF10B981,
                      ).withValues(alpha: 0.15),
                    ),
                    icon: const Icon(
                      Icons.handshake_outlined,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    label: const Text(
                      'Contratar y Crear Expediente',
                      style: TextStyle(color: Color(0xFF10B981)),
                    ),
                    onPressed: _openHireFlow,
                  )
                else
                  const SizedBox(),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: _saveStatus,
                      child: const Text('Guardar Evaluación'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2563EB),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
