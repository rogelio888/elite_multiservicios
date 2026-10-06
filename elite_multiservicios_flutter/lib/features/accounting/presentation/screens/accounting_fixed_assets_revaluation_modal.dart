import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RevaluationModal extends StatefulWidget {
  const RevaluationModal({super.key});

  @override
  State<RevaluationModal> createState() => _RevaluationModalState();
}

class _RevaluationModalState extends State<RevaluationModal> {
  final Color _primary = const Color(0xFF4F46E5);
  final Color _dark = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 850,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      '1',
                      'SELECCIÓN DEL BIEN & DATOS DEL PERITAJE',
                    ),
                    const SizedBox(height: 16),
                    _buildStep1(isMobile),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      '2',
                      'VALORACIÓN PERICIAL Y DETERMINACIÓN DE SUPERÁVIT',
                      trailing: 'Técnica: Costo de Reposición Depreciado',
                    ),
                    const SizedBox(height: 16),
                    _buildStep2(isMobile),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      '3',
                      'ASIENTO CONTABLE PROPUESTO (VOUCHER CD-REV-2024-009)',
                      trailing: 'Partida Doble Cuadrada (\$0.00)',
                      trailingColor: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 16),
                    _buildStep3(),
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
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.verified, color: _primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Asentar Revalúo Técnico Pericial',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _badge(
                      'REV-NUEVO',
                      _primary.withValues(alpha: 0.1),
                      _primary,
                    ),
                    const SizedBox(width: 8),
                    _badge(
                      '● Borrador Técnico',
                      const Color(0xFFFEF3C7),
                      const Color(0xFFD97706),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Norma Internacional de Contabilidad N° 16 (Propiedad, Planta y Equipo - Modelo de Revaluación)',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String number,
    String title, {
    String? trailing,
    Color? trailingColor,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: trailingColor ?? _primary,
            ),
          ),
      ],
    );
  }

  Widget _buildStep1(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _inputField(
                'ACTIVO FIJO A REVALUAR',
                value:
                    'ACT-2023-089 - Camioneta Toyota Hilux 4x4 (Costo: \$42,000.00 | VNL Actual: \$26,600.00)',
                isDropdown: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _inputField(
                'FECHA INSPECCIÓN / TASACIÓN',
                value: '28/10/2024',
                isDate: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _inputField(
                'PERITO VALUADOR / FIRMA CERTIFICADORA',
                value: 'Ing. Roberto Siles & Asociados Peritajes',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _inputField(
                'N° MATRÍCULA / ACREDITACIÓN',
                value: 'RNP-8942-IBNORCA',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _inputField(
                'N° INFORME PERICIAL',
                value: 'INF-PER-2024-108',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'DICTAMEN TÉCNICO & ACTA DE TASACIÓN FIRMADA',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF10B981).withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFFF0FDF4),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'dictamen_pericial_firmado_toyota_hilux.pdf',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _dark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _badge(
                          '1.8 MB',
                          const Color(0xFF10B981).withValues(alpha: 0.1),
                          const Color(0xFF10B981),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 12,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Firma Digitalizada Válida y Legalizada (Colegio Departamental de Ingenieros)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.visibility,
                  size: 14,
                  color: Color(0xFF10B981),
                ),
                label: Text(
                  'Ver Acta',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF10B981),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF10B981)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(bool isMobile) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'VALORES EN LIBROS ACTUALES (AL 28/10/2024)',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          'Solo Lectura',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _valRow('Costo Histórico Adquisición:', '\$ 42,000.00'),
                    const SizedBox(height: 8),
                    _valRow(
                      'Depreciación Acumulada:',
                      '-\$ 15,400.00',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _valRow(
                        'Valor Neto en Libros (VNL):',
                        '\$ 26,600.00',
                        isBold: true,
                        valueSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _valRow('Vida Útil Remanente Actual:', '38 meses (de 60)'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: _primary),
                            const SizedBox(width: 6),
                            Text(
                              'NUEVOS VALORES DICTAMINADOS POR PERITO',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _primary,
                              ),
                            ),
                          ],
                        ),
                        _badge(
                          'Auditado',
                          _primary.withValues(alpha: 0.1),
                          _primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      'Nuevo Valor Razonable Tasado (Fair Value)',
                      value: '\$ 45,100.00',
                      textColor: const Color(0xFF059669),
                      borderColor: const Color(0xFF10B981),
                      suffix: 'USD',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            'Extensión Adicional',
                            value: '24 meses',
                            helper: 'Total Vida: 62 meses',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            'Valor Residual Proyectado',
                            value: '\$ 4,500.00',
                            helper: '10% valor revaluado',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            border: Border(
              left: const BorderSide(color: Color(0xFF10B981), width: 4),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFF0F172A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUPERÁVIT PATRIMONIAL RESULTANTE (GANANCIA POR REVALÚO)',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$ 18,500.00',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            '(\$45,100.00 Tasación - \$26,600.00 VNL)',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NUEVA CUOTA DEPRECIACIÓN MENSUAL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _dark,
                    ),
                  ),
                  Text(
                    '\$ 654.84 / mes',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF059669),
                    ),
                  ),
                  Text(
                    'Amortización prospectiva NIC 8',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tipo: Comprobante de Diario\nTraspaso',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Moneda: Dólares Americanos\n(USD)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Glosa: Revalúo técnico pericial Camioneta Hilux s/g\nNIC 16',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 1, child: _colHdr('CÓDIGO CONTABLE')),
                Expanded(flex: 3, child: _colHdr('DESCRIPCIÓN DE LA CUENTA')),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _colHdr('DEBE (DÉBITO)'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _colHdr('HABER (CRÉDITO)'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _journalRow(
            '1.2.01.02',
            'Vehículos - Ajuste Revalúo Técnico',
            'Incremento del valor en libros por informe pericial',
            '\$ 18,500.00',
            '-',
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _journalRow(
            '3.1.03.01',
            'Reserva por Revalúo Técnico Patrimonial',
            'Superávit de revaluación no distribuible (Patrimonio Neto)',
            '-',
            '\$ 18,500.00',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Aprobación con token criptográfico de Harold Eastman\n(CFO)',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: _dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save, size: 16, color: Color(0xFF94A3B8)),
            label: Text(
              'Guardar como\nBorrador',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.lock, size: 16),
            label: Text(
              'Aprobar y Contabilizar en Libro\nMayor',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _valRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
    double valueSize = 12,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isBold ? _dark : const Color(0xFF94A3B8),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: valueSize,
            color: color ?? _dark,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _colHdr(String text) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 9,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF94A3B8),
    ),
  );

  Widget _journalRow(
    String code,
    String name,
    String sub,
    String debe,
    String haber,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              code,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: _primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                debe,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                haber,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String label, {
    String value = '',
    bool isDropdown = false,
    bool isDate = false,
    Color? textColor,
    Color? borderColor,
    String? suffix,
    String? helper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF94A3B8),
              ),
            ),
            if (suffix != null) ...[
              const Spacer(),
              Text(
                suffix,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor ?? const Color(0xFF334155)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: textColor ?? _dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isDropdown)
                const Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              if (isDate)
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
            ],
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 4),
          Text(
            helper,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ],
    );
  }
}
