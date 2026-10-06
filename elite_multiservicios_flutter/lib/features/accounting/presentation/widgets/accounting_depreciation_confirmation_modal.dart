import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingDepreciationConfirmationModal extends StatefulWidget {
  final String period;
  final String amount;
  final String assetsCount;

  const AccountingDepreciationConfirmationModal({
    super.key,
    required this.period,
    required this.amount,
    required this.assetsCount,
  });

  @override
  State<AccountingDepreciationConfirmationModal> createState() =>
      _AccountingDepreciationConfirmationModalState();
}

class _AccountingDepreciationConfirmationModalState
    extends State<AccountingDepreciationConfirmationModal> {
  bool _isChecked = false;
  String _confirmationText = '';
  final TextEditingController _textController = TextEditingController();

  bool get _isUnlocked => _isChecked && _confirmationText == 'CONFIRMAR';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 750,
        constraints: const BoxConstraints(maxHeight: 850),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAlertBox(),
                  const SizedBox(height: 24),
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  _buildCheckbox(),
                  const SizedBox(height: 24),
                  _buildConfirmationInput(),
                  const SizedBox(height: 24),
                  _buildApprovalInfo(),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.gavel, color: Color(0xFFE11D48), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                      ),
                      child: Text(
                        'COMPUERTA DE SEGURIDAD CRÍTICA',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFBE123C),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      'MODAL ID: #CONF-DEP-99',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Acción Contable Irreversible & Asiento Definitivo',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF475569),
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Cierre y Contabilización de Depreciación Mensual (',
                      ),
                      TextSpan(
                        text: 'Periodo ${widget.period}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF64748B)),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        border: Border.all(color: const Color(0xFFFECDD3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFE11D48),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF9F1239),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Al confirmar, se generará el asiento contable definitivo en el Libro Mayor por un valor de ',
                  ),
                  TextSpan(
                    text: widget.amount,
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. Una vez registrado, los libros del periodo quedarán bloqueados contra modificaciones manuales y se generará hash inmutable SHA-256 en WORM storage.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RESUMEN DE IMPACTO EN BALANCE & P&L',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                Text(
                  'EJERCICIO 2026',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Activos a Depreciar',
                    widget.assetsCount,
                    const Color(0xFF0F172A),
                    isMono: true,
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: _buildSummaryItem(
                    'Total Cuota Débito',
                    widget.amount,
                    const Color(0xFFE11D48),
                    isMono: true,
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: _buildSummaryItem(
                    'Total Crédito',
                    widget.amount,
                    const Color(0xFF334155),
                    isMono: true,
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF0FDF4),
                    child: _buildSummaryItem(
                      'Balance Partida Doble',
                      '\$0.00 diff',
                      const Color(0xFF16A34A),
                      isMono: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color valueColor, {
    bool isMono = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: isMono
                ? GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  )
                : GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: _isChecked,
            activeColor: const Color(0xFF4F46E5),
            onChanged: (val) {
              setState(() {
                _isChecked = val ?? false;
              });
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF334155),
                ),
                children: const [
                  TextSpan(
                    text:
                        'Comprendo que este proceso es irreversible y afectará los estados financieros oficiales (',
                  ),
                  TextSpan(
                    text: 'Balance General y P&L',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ').'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationInput() {
    final bool isCorrect = _confirmationText == 'CONFIRMAR';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
            children: const [
              TextSpan(text: 'Escriba "'),
              TextSpan(
                text: 'CONFIRMAR',
                style: TextStyle(color: Color(0xFFE11D48)),
              ),
              TextSpan(text: '" para autorizar el asiento contable:'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _textController,
          onChanged: (val) {
            setState(() {
              _confirmationText = val;
            });
          },
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFCBD5E1),
                width: isCorrect ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFF4F46E5),
                width: 2,
              ),
            ),
            suffixIcon: isCorrect
                ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                : null,
          ),
        ),
        if (isCorrect)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.check, color: Color(0xFF10B981), size: 14),
                const SizedBox(width: 6),
                Text(
                  'Palabra clave verificada correctamente. Protocolo desbloqueado.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildApprovalInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF3B82F6),
                size: 16,
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFF475569),
                  ),
                  children: const [
                    TextSpan(text: 'Aprobación Requerida: '),
                    TextSpan(
                      text: 'HAROLD EASTMAN (CFO)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'CÓDIGO: HE-DEP-202609-WORM',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Cancelar Operación',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isUnlocked
                ? () {
                    Navigator.of(context).pop(true);
                  }
                : null,
            icon: const Icon(Icons.lock_outline, size: 18, color: Colors.white),
            label: Text(
              'Asentar en Libro Mayor',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E), // Rose 500
              disabledBackgroundColor: const Color(0xFFFDA4AF), // Rose 300
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
