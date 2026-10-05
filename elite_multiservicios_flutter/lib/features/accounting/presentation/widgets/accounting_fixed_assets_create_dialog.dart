import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingFixedAssetsCreateDialog extends StatefulWidget {
  const AccountingFixedAssetsCreateDialog({super.key});

  @override
  State<AccountingFixedAssetsCreateDialog> createState() =>
      _AccountingFixedAssetsCreateDialogState();
}

class _AccountingFixedAssetsCreateDialogState
    extends State<AccountingFixedAssetsCreateDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 850,
        height: 800,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildStepper(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection1(),
                    const SizedBox(height: 16),
                    _buildSection2(),
                    const SizedBox(height: 16),
                    _buildSection3(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Borrador #REG-2024-118',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4F46E5),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Fecha Registro: 15/10/2024',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Registro de Nuevo Activo Fijo',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ingreso patrimonial y configuración de amortización contable (Norma NIC 16 / DS 24051)',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildStepItem(
            1,
            '1. Datos Generales',
            true, // isCompleted
            false, // isCurrent
          ),
          _buildStepDivider(true),
          _buildStepItem(
            2,
            '2. Valuación & Depreciación',
            false, // isCompleted
            true, // isCurrent
          ),
          _buildStepDivider(false),
          _buildStepItem(
            3,
            '3. Asignación Física',
            false, // isCompleted
            false, // isCurrent
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
      int stepNumber, String title, bool isCompleted, bool isCurrent) {
    Color color;
    if (isCompleted) {
      color = const Color(0xFF10B981);
    } else if (isCurrent) {
      color = const Color(0xFF4F46E5);
    } else {
      color = const Color(0xFF94A3B8);
    }

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.transparent
                : (isCurrent ? color : const Color(0xFFF1F5F9)),
            border: isCompleted ? Border.all(color: color, width: 1.5) : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 14, color: color)
                : Text(
                    stepNumber.toString(),
                    style: GoogleFonts.inter(
                      color: isCurrent ? Colors.white : color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 13,
            fontWeight: isCurrent || isCompleted
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color:
            isCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildSectionContainer({
    required Widget title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
                ?trailing,
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSection1() {
    return _buildSectionContainer(
      title: Row(
        children: [
          const Icon(Icons.archive_outlined,
              size: 20, color: Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Text(
            '1. Información General del Activo',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'NOMBRE / DENOMINACIÓN DEL ACTIVO *',
            initialValue: 'Workstation Dell Precision 5860 Tower',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'NÚMERO DE SERIE (S/N)',
                  initialValue: 'SN: 9K2L-4091-B7',
                  suffixIcon: Icons.tag,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'CÓDIGO DE BARRA FÍSICO / PLACA INTERNA *',
                  initialValue: 'BC-ACT-2024-8849',
                  suffixIcon: Icons.qr_code_2,
                  isHighlighted: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'MARCA & MODELO DE FABRICANTE',
            initialValue: 'Dell / Precision 5860',
          ),
        ],
      ),
    );
  }

  Widget _buildSection2() {
    return _buildSectionContainer(
      title: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              size: 20, color: Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Text(
            '2. Contabilidad, Valuación & Reglas',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          border: Border.all(color: const Color(0xFFA7F3D0)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'NIC 16 Auditor-Verified',
          style: GoogleFonts.inter(
            color: const Color(0xFF059669),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FACTURA DE COMPRA VINCULADA (SOPORTE FISCAL)',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long,
                              size: 16, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '#FAC-10492 - Dell Solutions Bolivia SRL (Validado SIN)',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF334155),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_outlined,
                            size: 16, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 6),
                        Text(
                          'Ver XML',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF4F46E5),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'FECHA ADQUISICIÓN',
                  initialValue: '15/10/2024',
                  suffixIcon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'INICIO DEPRECIACIÓN',
                  initialValue: '01/11/2024',
                  suffixIcon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'COSTO INICIAL (USD) *',
                  initialValue: '\$             4,850.00',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'VALOR SALVAMENTO (%)',
                  initialValue: '10% (\$485.00)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CATEGORÍA CONTABLE & VIDA ÚTIL LEGAL',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Equipo de Computación - 4 años / 48 meses (25% anual)',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF334155),
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 16, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MÉTODO DE DEPRECIACIÓN',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.radio_button_checked,
                                size: 18, color: Color(0xFF4F46E5)),
                            const SizedBox(width: 8),
                            Text(
                              'Línea Recta / Constante',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF334155),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Row(
                          children: [
                            const Icon(Icons.radio_button_off,
                                size: 18, color: Color(0xFFCBD5E1)),
                            const SizedBox(width: 8),
                            Text(
                              'Saldos Decrecientes',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_down,
                        size: 16, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Base Amortizable: ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF334155),
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: '\$4,365.00 ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '(Costo - Salvamento)',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'CUOTA MENSUAL CALCULADA: ',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\$90.94 ',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF4F46E5),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '/ mes',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF4F46E5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection3() {
    return _buildSectionContainer(
      title: Row(
        children: [
          const Icon(Icons.domain_outlined, size: 20, color: Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Text(
            '3. Asignación Física y Custodia',
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUCURSAL OPERATIVA',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Sucursal Central / La Paz',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF334155),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEPARTAMENTO / CENTRO DE COSTOS',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'CC-402: Ingeniería & DevOps',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF334155),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    IconData? suffixIcon,
    bool isHighlighted = false,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFEEF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isHighlighted
                  ? const Color(0xFFC7D2FE)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                initialValue,
                style: GoogleFonts.inter(
                  color: isHighlighted
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF334155),
                  fontSize: 13,
                  fontWeight: fontWeight,
                ),
              ),
              if (suffixIcon != null)
                Icon(
                  suffixIcon,
                  size: 16,
                  color: isHighlighted
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF94A3B8),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.save_outlined,
                  size: 18, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                'Guardar como Borrador',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF334155),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF10B981)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(Icons.add,
                          size: 12, color: Color(0xFF10B981)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Guardar e Ingresar a Libros Contables',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
