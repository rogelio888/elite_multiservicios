import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingBudgetTransfersScreen extends StatelessWidget {
  const AccountingBudgetTransfersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricsRow(),
        const SizedBox(height: 24),
        _buildFiltersRow(),
        const SizedBox(height: 16),
        _buildDataTable(),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricCard(
          title: 'TECHO GLOBAL AUTORIZADO',
          icon: Icons.account_balance,
          value: 'Bs.\n1,200,000.00',
          valueColor: Colors.white,
          footerIcon: Icons.circle,
          footerColor: Colors.grey,
          footerText: 'Balanceado • Variación Neta\n0.00 Bs.',
        ),
        _buildMetricCard(
          title: 'TRASPASOS COMPENSADOS Q3',
          icon: Icons.swap_horiz,
          value: 'Bs. 145,000.00',
          valueColor: Colors.white,
          footerIcon: Icons.circle,
          footerColor: const Color(0xFF6366F1),
          footerText: '6 ejecutadas sin\ntransacciones déficit',
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB45309).withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SOLICITUDES EN DICTAMEN',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFBBF24),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.assignment_late,
                      color: Color(0xFFFBBF24),
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '2\nPendientes',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFFFBBF24),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB45309).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Requiere\nDictamen\nCFO',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFBBF24),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Impacto\npotencial:',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      'Bs.\n43,500.00',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFFFBBF24),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF064E3B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ESTATUS DE RIGIDEZ',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF34D399),
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Control\nEstricto',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF34D399),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bloqueo\nactivo',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF34D399),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'de sobregiro (SHA-\n256)',
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
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required String value,
    required Color valueColor,
    required IconData footerIcon,
    required Color footerColor,
    required String footerText,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(icon, color: Colors.grey[500], size: 14),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.robotoMono(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(footerIcon, color: footerColor, size: 8),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    footerText,
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
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por folio, partida cedente o receptor...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 18,
                ),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Centro: Todos Los Centros',
                    style: GoogleFonts.inter(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tipo: Compensación 1:1',
                    style: GoogleFonts.inter(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(Icons.autorenew, color: Colors.grey, size: 18),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Estado: Pendientes de Dictamen (2)',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              '+ Nueva Solicitud de Traspaso',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.assignment,
                  color: Color(0xFF6366F1),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bandeja de Dictamen de Solicitudes Presupuestarias',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Modo: Aprobación Dual CFO',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.circle, color: Color(0xFF34D399), size: 8),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'FOLIO /\nCÓDIGO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'FECHA DE\nENVÍO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'SOLICITANTE\n& CENTRO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PARTIDA\nCEDENTE\n(ORIGEN)',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    'FLUJO',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PARTIDA\nRECEPTORA\n(DESTINO)',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'MONTO A\nREASIGNAR',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'IMPACTO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'ESTADO / DICTAMEN',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
          ),
          _buildRow(
            folio: 'SOL-\nTRASP-\n2026-\n04',
            fecha: '02/Oct/2026\n14:35 hrs',
            centro: 'CC-200\nOperaciones &\nPlanta',
            solicitante: 'Ing. Mario\nMéndez',
            origenPartida: '6.1.01 Admin\nCentral',
            origenDisp: 'Bs.\n105,000.00',
            destinoPartida: '6.2.03\nMantenimiento\nMaquinaria',
            destinoSaldoTag: 'Saldo\nCrítico:\nBs.\n15,000.00',
            monto: 'Bs.\n25,000.00',
            usd: '3,591.95',
            impacto: 'Compensación\n1:1',
            estado: 'Pendiente\nAprobación CFO',
            isWarning: true,
          ),
          _buildRow(
            folio: 'SOL-\nTRASP-\n2026-\n05',
            fecha: '03/Oct/2026\n09:12 hrs',
            centro: 'CC-300\nTecnología &\nSistemas',
            solicitante: 'Lic. Carlos\nMendoza',
            origenPartida: '6.4.01\nMarketing &\nVentas',
            origenDisp: 'Bs.\n85,700.00',
            destinoPartida: '6.3.02 Nube y\nLicencias Core',
            destinoSaldoTag: 'Requiere\nampliación',
            monto: 'Bs.\n18,500.00',
            usd: '2,658.05',
            impacto: 'Compensación\n1:1',
            estado: 'Pendiente\nAprobación CFO',
            isWarning: true,
          ),
          _buildRow(
            folio: 'SOL-\nTRASP-\n2026-\n03',
            fecha: '15/Sep/2026\n16:40 hrs',
            centro: 'CC-100\nAdministración\nCentral',
            solicitante: 'Lic. Harold\nEastman',
            origenPartida: '6.1.01 Admin\nCentral',
            origenDisp: 'Bs. 130,000',
            destinoPartida: '6.2.01\nSeguridad &\nVigilancia',
            destinoSaldoTag: 'Presupuesto\nnormalizado',
            monto: 'Bs.\n12,000.00',
            usd: '1,724.13',
            impacto: 'Compensación\n1:1',
            estado: 'Aprobado\ny Asentado',
            isApproved: true,
          ),
          _buildRow(
            folio: 'SOL-\nTRASP-\n2026-\n02',
            fecha: '28/Ago/2026\n11:30 hrs',
            centro: 'CC-200\nOperaciones &\nPlanta',
            solicitante: 'Ing. Mario\nMéndez',
            origenPartida: '6.3.02\nInfraestructura\nTI',
            origenDisp: 'Bs. 95,000',
            destinoPartida: '6.2.05\nRepuestos de\nCaldera\nEmergencia técnica',
            destinoSaldoTag: '',
            monto: 'Bs.\n40,000.00',
            usd: '5,747.12',
            impacto: 'Compensación\n1:1',
            estado: 'Aprobado\ny Asentado',
            isApproved: true,
            isLast: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mostrando 1 a 4 de 8 solicitudes registradas en la gestión 2026',
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
                Row(
                  children: [
                    _buildPageButton('<', false),
                    _buildPageButton('1', true),
                    _buildPageButton('2', false),
                    _buildPageButton('>', false),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF334155))),
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: Colors.grey, size: 14),
                const SizedBox(width: 8),
                Text(
                  'Auditoría en línea: Harold Eastman (CFO)',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '| Hash SHA-256 inmutable: 9b2f...81e4',
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Text(
                  'T/C Oficial BCB: 6.96 Bs./USD • Sincronización continua activa',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String folio,
    required String fecha,
    required String centro,
    required String solicitante,
    required String origenPartida,
    required String origenDisp,
    required String destinoPartida,
    required String destinoSaldoTag,
    required String monto,
    required String usd,
    required String impacto,
    required String estado,
    bool isWarning = false,
    bool isApproved = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              folio,
              style: GoogleFonts.robotoMono(
                color: Colors.grey[300],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              fecha,
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  centro,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  solicitante,
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  origenPartida,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    border: Border.all(color: const Color(0xFF334155)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Saldo Disp:\n$origenDisp',
                    style: GoogleFonts.robotoMono(
                      color: Colors.grey[400],
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 40,
            child: Center(
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFF6366F1),
                size: 16,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destinoPartida,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (destinoSaldoTag.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isWarning
                          ? const Color(0xFFB45309).withValues(alpha: 0.2)
                          : Colors.transparent,
                      border: isWarning
                          ? Border.all(
                              color: const Color(
                                0xFFB45309,
                              ).withValues(alpha: 0.5),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      destinoSaldoTag,
                      style: GoogleFonts.inter(
                        color: isWarning
                            ? const Color(0xFFFBBF24)
                            : Colors.grey[500],
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  monto,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'equiv. USD\n$usd',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    color: Colors.grey[500],
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  impacto,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF34D399),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isWarning
                      ? const Color(0xFFB45309).withValues(alpha: 0.1)
                      : (isApproved
                            ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                            : Colors.transparent),
                  border: Border.all(
                    color: isWarning
                        ? const Color(0xFFB45309).withValues(alpha: 0.5)
                        : (isApproved
                              ? const Color(0xFF34D399).withValues(alpha: 0.5)
                              : Colors.transparent),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: isWarning
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF34D399),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      estado,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: isWarning
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFF34D399),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isWarning) ...[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064E3B),
                      foregroundColor: const Color(0xFF34D399),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Aprobar\nDictamen',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (isApproved) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.print_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(4),
        border: isActive ? null : Border.all(color: const Color(0xFF334155)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isActive ? Colors.white : Colors.grey[400],
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
