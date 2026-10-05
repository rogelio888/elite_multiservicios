import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingBanksScreen extends StatelessWidget {
  const AccountingBanksScreen({super.key});

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? rightBadge,
    Widget? extraSubtitleWidget,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Dark surface
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)), // Subtle border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                  ),
                ),
                if (rightBadge != null) rightBadge else Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (extraSubtitleWidget != null)
              extraSubtitleWidget
            else
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String badgeText,
    required Color badgeColor,
    required Map<String, String> details,
    required String balanceLabel,
    required String balanceValue,
    required String balanceSub,
    bool showButton = false,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: badgeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            color: badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: details.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.key,
                          style: GoogleFonts.robotoMono(color: Colors.grey[400], fontSize: 11),
                        ),
                        Text(
                          e.value,
                          style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        balanceLabel,
                        style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            balanceValue,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            balanceSub,
                            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (showButton)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Rendir Caja',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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

  Widget _buildExtractItem({
    required bool isChecked,
    required String date,
    required String title,
    required String ref,
    required String amount,
    required Color amountColor,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked ? const Color(0xFF6366F1).withValues(alpha: 0.5) : const Color(0xFF334155),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            color: isChecked ? const Color(0xFF6366F1) : const Color(0xFF475569),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'REF: $ref',
                      style: GoogleFonts.robotoMono(color: Colors.grey[500], fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    if (subtitle.contains('Asiento'))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB45309).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          subtitle,
                          style: GoogleFonts.inter(color: const Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                            color: subtitle.contains('Crédito') ? Colors.greenAccent : Colors.redAccent, fontSize: 11),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.inter(color: amountColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (isChecked) ...[
                const SizedBox(height: 4),
                Text(
                  'Coincidencia 100%',
                  style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10),
                ),
              ],
              if (!isChecked) ...[
                const SizedBox(height: 4),
                Text(
                  '+ Auto-generar\nAsiento',
                  style: GoogleFonts.inter(color: const Color(0xFF6366F1), fontSize: 10),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerItem({
    required bool isChecked,
    required String comp,
    required String account,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked ? const Color(0xFF6366F1).withValues(alpha: 0.5) : const Color(0xFF334155),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            color: isChecked ? const Color(0xFF6366F1) : const Color(0xFF475569),
            size: 20,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF334155).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comp, style: GoogleFonts.robotoMono(color: Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Cta: $account', style: GoogleFonts.robotoMono(color: Colors.grey[400], fontSize: 9)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.inter(color: amountColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.greenAccent, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'Verificado',
                    style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Gestión de Tesorería,\nCuentas & Conciliación',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF059669)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user_outlined, color: Color(0xFF10B981), size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'ASFI-\nCOMPLIANT',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF10B981),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Control de Flujo de Fondos, Posición de Liquidez & Conciliación Automática',
                      style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
                // Tabs
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text('Cuentas Bancarias\n& Cajas Chicas', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Text('Mesa de\nConciliación Bancaria', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12), textAlign: TextAlign.center),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB45309).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFF59E0B)),
                            ),
                            child: const Text('2\npendientes', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Historial de\nTransferencias\nInternas', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12), textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Metrics
            Row(
              children: [
                _buildMetricCard(
                  title: 'TOTAL DISPONIBILIDAD\nLÍQUIDA',
                  value: 'Bs. 482,900.00',
                  subtitle: '',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFF10B981),
                  extraSubtitleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
                          const SizedBox(width: 4),
                          Text('+4.2%', style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text('flujo semanal\nneto', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10)),
                        ],
                      ),
                      Text('Consolidado', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                ),
                _buildMetricCard(
                  title: 'BANCO NACIONAL (CTA.\nCORRIENTE BOB)',
                  value: 'Bs. 312,450.00',
                  subtitle: '',
                  icon: Icons.account_balance,
                  iconColor: Colors.grey,
                  rightBadge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text('En\nLínea', style: TextStyle(color: Color(0xFF10B981), fontSize: 10)),
                      ],
                    ),
                  ),
                  extraSubtitleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('N° 1000-84920-BOB', style: GoogleFonts.robotoMono(color: Colors.grey[400], fontSize: 10)),
                      Text('64.7% Liquidez', style: GoogleFonts.inter(color: const Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                _buildMetricCard(
                  title: 'BANCO SANTANDER (CTA.\nOPERATIVA USD)',
                  value: '\$24,500.00 USD',
                  subtitle: 'Equiv: Bs. 170,520.00   T/C: 6.96',
                  icon: Icons.sync,
                  iconColor: const Color(0xFF3B82F6),
                  extraSubtitleWidget: Row(
                    children: [
                      Text('Equiv: ', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                      Text('Bs. 170,520.00', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('T/C: 6.96', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                ),
                _buildMetricCard(
                  title: 'CAJAS CHICAS CENTRAL Y\nSUCURSALES',
                  value: 'Bs. 8,500.00',
                  subtitle: '',
                  icon: Icons.point_of_sale,
                  iconColor: const Color(0xFFF59E0B),
                  extraSubtitleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Límite: Bs.\n15,000.00', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10)),
                      Text('56.6%\ndisponible', style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Posición Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.credit_card, color: Color(0xFF6366F1), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Posición por Entidad & Bóveda',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  'Gestionar Cuentas Bancarias →',
                  style: GoogleFonts.inter(color: const Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  _buildEntityCard(
                    title: 'Banco Nacional de\nBolivia',
                    subtitle: 'Cuenta Corriente Empresa',
                    icon: Icons.account_balance,
                    iconColor: const Color(0xFF10B981),
                    badgeText: 'Conectado\nAPI',
                    badgeColor: const Color(0xFF10B981),
                    details: {
                      'N° Cuenta:': '1000-84920-BOB',
                      'Titular:': 'Elite Multiservicios ...',
                      'BIC / Swift:': 'BNBOBOLPXXX',
                    },
                    balanceLabel: 'SALDO EN VIVO',
                    balanceValue: 'Bs. 312,450.00',
                    balanceSub: 'Hoy 10:45 AM',
                  ),
                  _buildEntityCard(
                    title: 'Banco Santander\nInternational',
                    subtitle: 'Cuenta Ahorro Operativa USD',
                    icon: Icons.public,
                    iconColor: const Color(0xFFEF4444),
                    badgeText: 'Conectado\nSwift',
                    badgeColor: const Color(0xFF10B981),
                    details: {
                      'N° Cuenta:': '4022-99102-USD',
                      'ABA Routing:': '021000021',
                      'T/C Aplicado:': '6.96 BOB/USD',
                    },
                    balanceLabel: 'SALDO EN VIVO (USD / BOB)',
                    balanceValue: '\$24,500.00',
                    balanceSub: '(Bs. 170,520)   Audited',
                  ),
                  _buildEntityCard(
                    title: 'Caja Chica\nAdministración',
                    subtitle: 'Fondo Fijo Operativo Central',
                    icon: Icons.lock,
                    iconColor: const Color(0xFFF59E0B),
                    badgeText: 'Custodio\nAutorizado',
                    badgeColor: const Color(0xFF6366F1),
                    details: {
                      'Responsable:': 'Lic. M. Arze (Finan...',
                      'Límite de Fondo:': 'Bs. 5,000.00',
                      'Disponibilidad:': '77.0% Restante',
                    },
                    balanceLabel: 'SALDO ACTUAL EN BÓVEDA',
                    balanceValue: 'Bs. 3,850.00',
                    balanceSub: '',
                    showButton: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Conciliación Row
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.compare_arrows, color: Color(0xFF6366F1), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mesa de Conciliación Bancaria Automática',
                                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Cruce de Comprobantes vs. Extracto Bancario BNB\n(Período: Septiembre 2026)',
                                  style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF064E3B).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF059669)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.link, color: Color(0xFF10B981), size: 16),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Diferencia de Cruce:', style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 10)),
                                      Text('Bs. 0.00', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.playlist_add_check),
                              label: const Text('Conciliar Partidas\nSeleccionadas', textAlign: TextAlign.center),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xFF334155)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6)),
                              label: const Text('Cruzar por IA /\nAlgoritmo', textAlign: TextAlign.center),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF334155), height: 1),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Text('EXTRACTO BANCARIO IMPORTADO (BNB 1000-84920)', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text('3 partidas activas', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildExtractItem(
                                  isChecked: true,
                                  date: '24/Sep 09:12',
                                  title: 'Depósito Transf. Minera San Cristóbal',
                                  ref: 'BNB-TRF-994012',
                                  amount: '+Bs. 45,000.00',
                                  amountColor: Colors.greenAccent,
                                  subtitle: 'Crédito',
                                ),
                                _buildExtractItem(
                                  isChecked: true,
                                  date: '23/Sep 16:40',
                                  title: 'Débito Proveedor Combustibles YPFB',
                                  ref: 'DKB-OPS-881920',
                                  amount: '-Bs. 18,200.00',
                                  amountColor: Colors.redAccent,
                                  subtitle: 'Débito',
                                ),
                                _buildExtractItem(
                                  isChecked: false,
                                  date: '23/Sep\n18:00',
                                  title: 'Comisión Mantenimiento de Cuenta BNB',
                                  ref: 'COM-BNB-0926',
                                  amount: '-Bs. 150.00',
                                  amountColor: Colors.redAccent,
                                  subtitle: 'Sin Asiento',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(color: Color(0xFF334155), width: 1),
                        // Right Column
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Text('LIBRO MAYOR DE TESORERÍA (ASIENTOS\nINTERNOS)', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text('2 seleccionados para\ncruce', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildLedgerItem(
                                  isChecked: true,
                                  comp: 'COMP-ING-2026-\n89',
                                  account: '111-01 BNB',
                                  title: 'Factura 004612 Cobranza\nMetalúrgica',
                                  subtitle: 'Cliente: Minera San\nCristóbal',
                                  amount: '+Bs.\n45,000.00',
                                  amountColor: Colors.greenAccent,
                                ),
                                _buildLedgerItem(
                                  isChecked: true,
                                  comp: 'COMP-EGR-2026-\n112',
                                  account: '111-01 BNB',
                                  title: 'Pago Factura 9012 Yacimientos\nPetrolíferos',
                                  subtitle: 'Prov: YPFB Refinación',
                                  amount: '-Bs.\n18,200.00',
                                  amountColor: Colors.redAccent,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Sin voucher registrado para conciliar la comisión\nbancaria de Bs.150.00',
                                          style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11),
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(color: Color(0xFF334155)),
                                          backgroundColor: const Color(0xFF334155),
                                        ),
                                        child: const Text('Crear Asiento\nRápido', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
