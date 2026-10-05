import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingBudgetCeilingModal extends StatelessWidget {
  const AccountingBudgetCeilingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 700,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF334155))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calculate_outlined, color: Color(0xFF818CF8), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Asignar Techo Presupuestario', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(12)),
                              child: Text('FinTrack Ent.', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Definición de límites máximos de gasto por Centro de Costo y Partida Contable', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('1. GESTIÓN Y PERIODO DE VIGENCIA'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFormField('Ejercicio Fiscal', _buildDropdown('Gestión Fiscal 2026', true))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormField('Periodo de Vigencia', _buildPeriodSelector())),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('2. CENTRO DE COSTO Y RESPONSABLE ASIGNADO'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFormField('Selector Centro de Costo', _buildDropdown('CC-200 • Operaciones & Planta Industrial', true))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormField('Responsable Asignado', _buildReadOnlyInput('Ing. Mario Méndez (Jefe de Planta)', icon: Icons.check_circle_outline, iconColor: const Color(0xFF34D399)), extraTag: 'Auto-detectado')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('3. PARTIDA Y CUENTA CONTABLE VINCULADA'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFormField('Código y Nombre de Partida', _buildReadOnlyInput('6.2.03 • Mantenimiento Maquinaria & Plant...'))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormField('Cuenta Libro Mayor (Mayor General)', _buildReadOnlyInput('6203-02-IND (Gasto Operativo D...', icon: Icons.lock_outline, iconColor: Colors.grey))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('4. ASIGNACIÓN ECONÓMICA Y POLÍTICA DE CONTROL'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Techo Límite Aprobado (Moneda Nacional BOB)', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Equiv. USD 79,022.98 (T/C 6.96)', style: GoogleFonts.inter(color: const Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Text('Bs.', style: GoogleFonts.robotoMono(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text('550,000.00', style: GoogleFonts.robotoMono(color: const Color(0xFF34D399), fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildControlPolicyCard(true, 'Estricto / Bloqueante', 'No permite emitir órdenes de compra ni devengar facturas sin saldo disponible en el balance.', Icons.lock_outline, const Color(0xFF818CF8))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildControlPolicyCard(false, 'Informativo / Advertencia', 'Permite sobregiro temporal notificando automáticamente al CFO Harold Eastman.', Icons.warning_amber_rounded, const Color(0xFFF59E0B))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('5. RESPALDO LEGAL Y NOTIFICACIÓN'),
                    const SizedBox(height: 12),
                    _buildFormField('Nº de Resolución o Acta de Directorio', _buildReadOnlyInput('ACTA-DIR-2026-N088 (Aprobado en Sesión Ordinaria)', icon: Icons.description_outlined, iconColor: Colors.grey)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(4)),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Notificar al responsable de Centro de Costo y habilitar inmediatamente en módulo de Contratos / Compras.', style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF334155))),
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fingerprint, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Auditoría activa: Harold Eastman (CFO) •\nHash SHA-256', style: GoogleFonts.robotoMono(color: Colors.grey[500], fontSize: 10)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFF334155))),
                    ),
                    child: Text('Cancelar', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text('Asignar y Bloquear Techo en Libros', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.robotoMono(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1));
  }

  Widget _buildFormField(String label, Widget field, {String? extraTag}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            if (extraTag != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), border: Border.all(color: const Color(0xFF334155)), borderRadius: BorderRadius.circular(4)),
                child: Text(extraTag, style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 9)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildDropdown(String text, bool hasIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis)),
          if (hasIcon) const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInput(String text, {IconData? icon, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(text, style: GoogleFonts.robotoMono(color: Colors.grey[300], fontSize: 11), overflow: TextOverflow.ellipsis)),
          if (icon != null) Icon(icon, color: iconColor, size: 16),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildPeriodOption('Anual', false)),
          Container(width: 1, height: 20, color: const Color(0xFF334155)),
          Expanded(child: _buildPeriodOption('Q1', false)),
          Container(width: 1, height: 20, color: const Color(0xFF334155)),
          Expanded(child: _buildPeriodOption('Q2', false)),
          Container(width: 1, height: 20, color: const Color(0xFF334155)),
          Expanded(child: _buildPeriodOption('Q3', true)),
          Container(width: 1, height: 20, color: const Color(0xFF334155)),
          Expanded(child: _buildPeriodOption('Q4', false)),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : Colors.grey[400],
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildControlPolicyCard(bool isSelected, String title, String subtitle, IconData tagIcon, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.1) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? const Color(0xFF6366F1) : Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Icon(tagIcon, color: tagColor, size: 14),
                  ],
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
