import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingBudgetTransferModal extends StatelessWidget {
  const AccountingBudgetTransferModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 800,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Crear Solicitud de Traspaso Presupuestario',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reasignación de techos entre centros de costo sin alterar el presupuesto global aprobado.',
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
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
                    Row(
                      children: [
                        Expanded(child: _buildOriginCard()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDestinationCard()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Monto a Transferir (Bolivianos - BOB)',
                      style: GoogleFonts.inter(
                        color: Colors.grey[300],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Bs.',
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF818CF8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '25,000.00',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'EQUIV. USD 3,591.95',
                            style: GoogleFonts.robotoMono(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Justificación Técnica y Causa Operativa (Auditoría CFO)',
                      style: GoogleFonts.inter(
                        color: Colors.grey[300],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        'Urgencia mantenimiento preventivo torno CNC y calibración de bancada para evitar parada no programada de línea 2.',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSimulatorCard(),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF334155)),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.send_outlined, size: 16),
                    label: Text(
                      'Enviar Solicitud a Dictamen CFO',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161F30), // Un poco más claro
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
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
                    Icons.remove_circle_outline,
                    color: Color(0xFFFCA5A5),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ORIGEN (CEDE TECHO)',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFCA5A5),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Disminución',
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Centro de Costo Origen',
            style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11),
          ),
          const SizedBox(height: 4),
          _buildDropdown('CC-100 • Administración Central (Saldo libre: B...'),
          const SizedBox(height: 12),
          Text(
            'Partida Presupuestaria Origen',
            style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11),
          ),
          const SizedBox(height: 4),
          _buildDropdown('6.1.01 • Servicios Generales y Gestión Corporat...'),
        ],
      ),
    );
  }

  Widget _buildDestinationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161F30), // Un poco más claro
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
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
                    Icons.add_circle_outline,
                    color: Color(0xFF34D399),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DESTINO (RECIBE TECHO)',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Incremento',
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Centro de Costo Destino',
            style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11),
          ),
          const SizedBox(height: 4),
          _buildDropdown('CC-200 • Operaciones & Planta Industrial', true),
          const SizedBox(height: 12),
          Text(
            'Partida Presupuestaria Destino',
            style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 11),
          ),
          const SizedBox(height: 4),
          _buildDropdown('6.2.03 • Mantenimiento Maquinaria (Consumo...'),
        ],
      ),
    );
  }

  Widget _buildDropdown(String text, [bool hasIcon = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasIcon)
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildSimulatorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bar_chart,
                    color: Color(0xFF818CF8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SIMULADOR DE IMPACTO PRESUPUESTARIO EN TIEMPO REAL',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF818CF8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Variación Neta: Bs. 0.00',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF34D399),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORIGEN: CC-100 (6.1.01)',
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Techo Anterior:',
                          style: GoogleFonts.inter(
                            color: Colors.grey[300],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bs. 300,000.00',
                          style: GoogleFonts.robotoMono(
                            color: Colors.grey[400],
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nuevo Techo:',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFCA5A5),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bs. 275,000.00 ',
                                style: GoogleFonts.robotoMono(
                                  color: const Color(0xFFFCA5A5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '(-25k)',
                                style: GoogleFonts.robotoMono(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nuevo margen libre: Bs. 80,000.00',
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: const Color(0xFF334155),
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESTINO: CC-200 (6.2.03)',
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Techo Anterior:',
                          style: GoogleFonts.inter(
                            color: Colors.grey[300],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bs. 550,000.00',
                          style: GoogleFonts.robotoMono(
                            color: Colors.grey[400],
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nuevo Techo:',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF34D399),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bs. 575,000.00 ',
                                style: GoogleFonts.robotoMono(
                                  color: const Color(0xFF34D399),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '(+25k)',
                                style: GoogleFonts.robotoMono(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nuevo margen libre: Bs. 165,000.00',
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF34D399),
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Compensación perfecta 1:1 verificada. No requiere autorización de directorio por incremento de deuda.',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
