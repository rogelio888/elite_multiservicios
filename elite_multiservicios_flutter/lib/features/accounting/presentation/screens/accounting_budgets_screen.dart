import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accounting_cashflow_forecast_screen.dart';
import 'accounting_budget_transfer_modal.dart';
import 'accounting_budget_ceiling_modal.dart';
import 'accounting_budget_transfers_screen.dart';

class AccountingBudgetsScreen extends StatefulWidget {
  const AccountingBudgetsScreen({super.key});

  @override
  State<AccountingBudgetsScreen> createState() => _AccountingBudgetsScreenState();
}

class _AccountingBudgetsScreenState extends State<AccountingBudgetsScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 24),
              if (_activeTab == 0) ...[
                _buildMetricsRow(),
                const SizedBox(height: 24),
              ],
              _buildTabBar(),
              const SizedBox(height: 24),
              if (_activeTab == 0) ...[
                _buildFiltersRow(),
                const SizedBox(height: 16),
                _buildDataTable(),
              ] else if (_activeTab == 1) ...[
                const AccountingCashFlowForecastScreen(),
              ] else if (_activeTab == 2) ...[
                const AccountingBudgetTransfersScreen(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _activeTab == 2
                    ? 'Control Presupuestario y Proyección de\nFlujo de Fondos'
                    : (_activeTab == 1 
                      ? 'Proyección de Flujo de\nFondos & Modelo de Liquidez\n(Cash Flow Q3-Q4)' 
                      : 'Control Presupuestario y\nProyección de Flujo de Fondos'),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
            if (_activeTab == 1) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                ),
                child: Text('NIC 7 /\nCash\nFlow\nMatrix', textAlign: TextAlign.center, style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ] else if (_activeTab == 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                ),
                child: Text('Q3\nAuditado', textAlign: TextAlign.center, style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _activeTab == 2
            ? 'Supervisión de Techos Presupuestarios, Traspasos Compensados y Dictamen de Solicitudes\nInterdepartamentales'
            : (_activeTab == 1 
              ? 'Simulación dinámica de tesorería, cobranzas operativas (CxC), egresos (CxP,\nOPEX/CAPEX) y análisis de estrés financiero en moneda nacional (BOB).'
              : 'Supervisión de Techos Presupuestarios, Ejecución por\nCentro de Costos y Desviaciones Fiscales'),
          style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13, height: 1.4),
        ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: Text(
                _activeTab == 2 ? 'Exportar Bitácora (.xlsx)' 
                : (_activeTab == 1 ? 'Descargar Modelo (.xlsx / PDF)' : 'Exportar Matriz Presupuestaria (.xlsx / PDF)'), 
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                _activeTab == 2 ? '+ Nueva Solicitud de Traspaso'
                : (_activeTab == 1 ? '+ Nuevo Asiento de Proyección' : '+ Asignar Techo Presupuestario'), 
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)
              ),
              onPressed: () {
                if (_activeTab == 2) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (context) => const AccountingBudgetTransferModal(),
                  );
                } else if (_activeTab != 1) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (context) => const AccountingBudgetCeilingModal(),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String footerIcon,
    required String footerText,
    required Color valueColor,
    IconData? topIcon,
    Widget? customMiddle,
    Color footerColor = Colors.grey,
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
                Text(title, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                if (topIcon != null)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6)),
                    child: Icon(topIcon, color: const Color(0xFF6366F1), size: 14),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (customMiddle != null)
              customMiddle
            else
              Text(value, style: GoogleFonts.robotoMono(color: valueColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                if (footerIcon == 'check') const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 12)
                else if (footerIcon == 'lock') const Icon(Icons.lock_outline, color: Color(0xFF6366F1), size: 12)
                else const SizedBox(),
                if (footerIcon != '') const SizedBox(width: 6),
                Expanded(child: Text(footerText, style: GoogleFonts.inter(color: footerColor, fontSize: 10), maxLines: 2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricCard(
          title: 'PRESUPUESTO GLOBAL\nASIGNADO',
          topIcon: Icons.account_balance,
          value: 'Bs.\n1,200,000.00',
          valueColor: Colors.white,
          footerIcon: 'check',
          footerText: 'Aprobado por Directorio • 4 Centros de Costo',
          footerColor: Colors.grey[400]!,
        ),
        _buildMetricCard(
          title: 'EJECUTADO / DEVENGADO',
          topIcon: Icons.payments,
          value: 'Bs.\n784,300.00',
          valueColor: Colors.white,
          customMiddle: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Bs.\n784,300.00', style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFB45309).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4)),
                child: Text('65.3%\nde consumo', textAlign: TextAlign.center, style: GoogleFonts.inter(color: const Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          footerIcon: '',
          footerText: '', // Handled custom below
        ),
        _buildMetricCard(
          title: 'SALDO DISPONIBLE TOTAL',
          topIcon: Icons.savings,
          value: 'Bs. 415,700.00',
          valueColor: const Color(0xFF34D399),
          footerIcon: 'lock',
          footerText: 'Disponible para asignación y gastos Q4',
          footerColor: Colors.grey[400]!,
        ),
        _buildMetricCard(
          title: 'DESVIACIÓN NETA GLOBAL',
          topIcon: Icons.show_chart,
          value: '-2.4%',
          valueColor: Colors.white,
          customMiddle: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('-2.4%', style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF064E3B).withValues(alpha: 0.3), border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFF34D399), size: 10),
                    const SizedBox(width: 4),
                    Text('Favorable', style: GoogleFonts.inter(color: const Color(0xFF34D399), fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          footerIcon: '',
          footerText: 'Gasto real menor a la proyección pe...',
          footerColor: Colors.grey[500]!,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _activeTab = 0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 0 ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF6366F1), width: 2))) : null,
              child: Text('Ejecución Presupuestaria por\nCentro de Costo (4)', textAlign: TextAlign.center, style: GoogleFonts.inter(color: _activeTab == 0 ? Colors.white : Colors.grey[400], fontSize: 13, fontWeight: _activeTab == 0 ? FontWeight.bold : FontWeight.normal)),
            ),
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () => setState(() => _activeTab = 1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 1 ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF6366F1), width: 2))) : null,
              child: Row(
                children: [
                  if (_activeTab == 1) const Icon(Icons.save_outlined, color: Color(0xFF6366F1), size: 16),
                  if (_activeTab == 1) const SizedBox(width: 8),
                  Text('Proyección de Flujo de Fondos (Cash Flow Q3-\nQ4)', textAlign: TextAlign.center, style: GoogleFonts.inter(color: _activeTab == 1 ? Colors.white : Colors.grey[400], fontSize: 13, fontWeight: _activeTab == 1 ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(4)),
                    child: Text('Nuevo', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          InkWell(
            onTap: () => setState(() => _activeTab = 2),
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: _activeTab == 2 ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF6366F1), width: 2))) : null,
              child: Row(
                children: [
                  Text('Solicitudes de Modificación &\nTraspasos', textAlign: TextAlign.center, style: GoogleFonts.inter(color: _activeTab == 2 ? Colors.white : Colors.grey[400], fontSize: 13, fontWeight: _activeTab == 2 ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF334155), shape: BoxShape.circle),
                    child: Text('2', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('Base Moneda:\nBolivianos (Bs.)', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ),
        ],
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
                hintText: 'Buscar por partida presupuestaria, código o responsabl...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                prefixIcon: const Icon(Icons.filter_alt_outlined, color: Colors.grey, size: 18),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF334155))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF334155))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Todos los Centros (CC-100 a CC-400)', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF334155))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Todos los estados', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF334155))),
            child: const Icon(Icons.autorenew, color: Colors.grey, size: 18),
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
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('CENTRO DE COSTO', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('PARTIDA\nPRESUPUESTARIA', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('TECHO\nASIGNADO', textAlign: TextAlign.right, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('GASTO\nEJECUTADO', textAlign: TextAlign.right, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('MARGEN\nRESTANTE', textAlign: TextAlign.right, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Padding(padding: const EdgeInsets.only(left: 16), child: Text('% CONSUMO & AVANCE', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)))),
                SizedBox(width: 100, child: Text('ACCIONES', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          _buildRow(
            code: 'CC-\n100',
            name: 'Administración\nCentral',
            resp: 'Resp: Harold\nEastman',
            partida: '6.1.01 • Servicios\nGenerales y Gestión\nCorporativa',
            cuenta: 'Cuenta Contable:\n6101-00-LPZ',
            techo: 'Bs.\n300,000.00',
            ejecutado: 'Bs.\n195,000.00',
            margen: 'Bs.\n105,000.00',
            margenColor: const Color(0xFF34D399),
            porcentaje: '65.0%',
            porcTag: 'Dentro de Límite',
            tagColor: const Color(0xFF064E3B),
            tagTextColor: const Color(0xFF34D399),
            progressVal: 0.65,
          ),
          _buildRow(
            code: 'CC-\n200',
            name: 'Operaciones &\nPlanta Industrial',
            resp: 'Resp: Ing. Mario\nMéndez',
            partida: '6.2.03 •\nMantenimiento de\nMaquinaria y\nProducción',
            cuenta: 'Cuenta Contable:\n6203-02-IND',
            techo: 'Bs.\n550,000.00',
            ejecutado: 'Bs.\n410,000.00',
            margen: 'Bs.\n140,000.00',
            margenColor: const Color(0xFFFBBF24),
            porcentaje: '74.5%',
            porcTag: 'Alerta de Consumo',
            tagColor: const Color(0xFFB45309).withValues(alpha: 0.3),
            tagTextColor: const Color(0xFFFBBF24),
            progressVal: 0.745,
          ),
          _buildRow(
            code: 'CC-\n300',
            name: 'Tecnología &\nSistemas',
            resp: 'Resp: Lic. Ana\nRios',
            partida: '6.3.02 •\nInfraestructura TI,\nLicencias y Servidores',
            cuenta: 'Cuenta Contable:\n6302-05-NAC',
            techo: 'Bs.\n350,000.00',
            ejecutado: 'Bs.\n179,300.00',
            margen: 'Bs.\n170,700.00',
            margenColor: const Color(0xFF34D399),
            porcentaje: '51.2%',
            porcTag: 'Óptimo',
            tagColor: const Color(0xFF064E3B),
            tagTextColor: const Color(0xFF34D399),
            progressVal: 0.512,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String code,
    required String name,
    required String resp,
    required String partida,
    required String cuenta,
    required String techo,
    required String ejecutado,
    required String margen,
    required Color margenColor,
    required String porcentaje,
    required String porcTag,
    required Color tagColor,
    required Color tagTextColor,
    required double progressVal,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFF334155)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(4)),
                  child: Text(code, style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(resp, style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10)),
                    ],
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
                Text(partida, style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(cuenta, style: GoogleFonts.robotoMono(color: Colors.grey[500], fontSize: 9)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(techo, textAlign: TextAlign.right, style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
          Expanded(flex: 1, child: Text(ejecutado, textAlign: TextAlign.right, style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
          Expanded(flex: 1, child: Text(margen, textAlign: TextAlign.right, style: GoogleFonts.robotoMono(color: margenColor, fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(porcentaje, style: GoogleFonts.robotoMono(color: tagTextColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: tagColor, border: Border.all(color: tagTextColor.withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(4)),
                        child: Text(porcTag, style: GoogleFonts.inter(color: tagTextColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressVal,
                    backgroundColor: const Color(0xFF0F172A),
                    valueColor: AlwaysStoppedAnimation<Color>(tagTextColor),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (context) => const AccountingBudgetTransferModal(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    side: const BorderSide(color: Color(0xFF334155)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 12),
                      const SizedBox(width: 4),
                      Text('Ajustar\nTecho', style: GoogleFonts.inter(fontSize: 9), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.visibility_outlined, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
