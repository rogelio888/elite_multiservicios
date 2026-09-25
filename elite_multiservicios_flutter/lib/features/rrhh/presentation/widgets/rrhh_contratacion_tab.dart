import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_hire_wizard.dart';

/// Tab 3 en Personal: Pantalla 05 — Contratación Formal (Wizard / Stepper).
class RrhhContratacionTab extends StatelessWidget {
  final VoidCallback? onHireCompleted;

  const RrhhContratacionTab({
    super.key,
    this.onHireCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.how_to_reg_outlined,
                    color: Color(0xFF60A5FA),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Contratación Formal de Personal',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Asistente guiado de 3 pasos para la incorporación oficial en nómina institucional, validación de documentos y aprovisionamiento de credenciales APK.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Lista de Pasos Resumidos
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    children: [
                      _buildStepItem(
                        step: '1',
                        title: 'Datos Laborales & Clasificación',
                        description: 'Tipo de trabajador (Oficina / Campo), departamento, cargo oficial, especialidad y turno convenido.',
                      ),
                      const Divider(height: 20, color: Color(0xFF1E293B)),
                      _buildStepItem(
                        step: '2',
                        title: 'Términos de Contrato & Salario',
                        description: 'Modalidad de contratación (Indefinido / Plazo Fijo), sueldo base confidencial y jornada laboral.',
                      ),
                      const Divider(height: 20, color: Color(0xFF1E293B)),
                      _buildStepItem(
                        step: '3',
                        title: 'Validación Legal & 6 Documentos de Ley',
                        description: 'Verificación de CI, croquis, facturas y bloqueo legal estricto de Certificado FELCC para seguridad.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Botón Principal para Abrir el Wizard
                FilledButton.icon(
                  onPressed: () {
                    RrhhEmployeeHireWizard.show(
                      context,
                      onCompleted: onHireCompleted,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(
                    'Iniciar Asistente de Contratación',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required String step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              step,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
