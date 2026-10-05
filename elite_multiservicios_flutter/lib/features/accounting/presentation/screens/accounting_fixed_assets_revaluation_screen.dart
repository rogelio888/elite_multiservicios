import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'accounting_fixed_assets_revaluation_modal.dart';

class AccountingFixedAssetsRevaluationScreen extends ConsumerStatefulWidget {
  const AccountingFixedAssetsRevaluationScreen({super.key});
  @override
  ConsumerState<AccountingFixedAssetsRevaluationScreen> createState() => _AccountingFixedAssetsRevaluationScreenState();
}

class _AccountingFixedAssetsRevaluationScreenState extends ConsumerState<AccountingFixedAssetsRevaluationScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildTabs(),
                  const SizedBox(height: 24),
                  if (_selectedTabIndex == 0) ...[
                    _buildMetricCards(),
                    const SizedBox(height: 24),
                    _buildAlertBanner(),
                    const SizedBox(height: 32),
                    _buildTableSection(),
                  ] else ...[
                    _buildCandidatosAlertBox(),
                    const SizedBox(height: 24),
                    _buildCandidatosActionBar(),
                    const SizedBox(height: 16),
                    _buildCandidatosTableSection(),
                    const SizedBox(height: 24),
                    _buildCandidatosFooterCards(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(4)),
                  child: const Text('BOB', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('USD', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Text('T/C: 6.96', style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(width: 8),
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
          const Spacer(),
          Container(
            width: 250,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white54, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Buscar activo, póliza, voucher...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.keyboard_command_key, color: Colors.white54, size: 12),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Badge(
            child: Icon(Icons.notifications_none, color: Colors.white54, size: 20),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF059669)),
            ),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF34D399), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                const Text('SUCURSAL CENTRAL', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: const [
            Text('MÓDULO CONTABLE', style: TextStyle(color: Colors.white54, fontSize: 10)),
            Icon(Icons.chevron_right, color: Colors.white38, size: 14),
            Text('ACTIVOS FIJOS & BIENES', style: TextStyle(color: Colors.white54, fontSize: 10)),
            Icon(Icons.chevron_right, color: Colors.white38, size: 14),
            Text('REVALÚOS TÉCNICOS (NIC 16)', style: TextStyle(color: Color(0xFF818CF8), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      const Text(
                        'Gestión de Revalúos Técnicos\n& Valor Razonable',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1B4B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF3730A3)),
                        ),
                        child: const Column(
                          children: [
                            Text('NIC 16', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('§31', style: TextStyle(color: Colors.white54, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Actualización pericial de activos fijos, extensión de vida útil técnica y\ndeterminación de superávit patrimonial bajo NIIF / D.S. 24051. Registro\ncertificado por peritos colegiados IBNORCA / SIB.',
                    style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16, color: Colors.white70),
                  label: const Text('Exportar Dictámenes', style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const RevaluationModal(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Asentar Nuevo Revalúo Pericial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () => setState(() => _selectedTabIndex = 0),
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: _selectedTabIndex == 0 ? const Color(0xFF818CF8) : Colors.transparent, width: 2)),
                ),
                child: Row(
                  children: [
                    Text('Historial de Revalúos Asentados', style: TextStyle(color: _selectedTabIndex == 0 ? Colors.white : Colors.white54, fontSize: 13, fontWeight: _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w500)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF1E1B4B), borderRadius: BorderRadius.circular(12)),
                      child: const Text('14', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: _selectedTabIndex == 1 ? const Color(0xFF818CF8) : Colors.transparent, width: 2)),
                ),
                child: Row(
                  children: [
                    Text('Candidatos a Revalúo (Totalmente Depreciados)', style: TextStyle(color: _selectedTabIndex == 1 ? Colors.white : Colors.white54, fontSize: 13, fontWeight: _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w500)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF78350F), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF92400E))),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFFF59E0B), size: 6),
                          SizedBox(width: 4),
                          Text('3 Alertas', style: TextStyle(color: Color(0xFFFCD34D), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Row(
              children: [
                const Text('Plan de\nCuentas:', style: TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.right),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Text('1.2.01 (AF) / 3.1.03\n(Reserva Revalúo)', style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards() {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            title: 'SUPERÁVIT POR REVALÚO\nACUMULADO',
            value: 'Bs. 384,200.00',
            subtitle: 'Patrimonio Neto • Cuenta\n3.1.03.01',
            icon: Icons.account_balance,
            bottomText: 'en ejercicio\nfiscal 2026',
            bottomValue: '+18.5%',
            bottomValueColor: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'ACTIVOS VIDA ÚTIL\nEXTENDIDA',
            value: '14 equipos',
            subtitle: 'Vehículos, Maquinaria\nPesada, TI',
            icon: Icons.search,
            bottomText: '100% amparados con\ninforme pericial',
            bottomValue: '✔',
            bottomValueColor: const Color(0xFFA5B4FC),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'PROMEDIO DE EXTENSIÓN',
            value: '+36 meses',
            valueColor: const Color(0xFF6EE7B7),
            subtitle: 'Amortización prospectiva\n(NIC 8)',
            icon: Icons.update,
            bottomText: 'Base\ntécnica:',
            bottomValue: 'Tasa residual\nestimada 8.2%',
            bottomValueColor: Colors.white70,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            title: 'DICTÁMENES PENDIENTES',
            value: '2 borradores',
            valueColor: const Color(0xFFFBBF24),
            subtitle: 'Avalúos por Ing. Siles &\nLic. Arze',
            icon: Icons.assignment,
            bottomText: 'Requiere firma CFO /\nDirectorio',
            bottomValue: '●',
            bottomValueColor: const Color(0xFFFBBF24),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    Color? valueColor,
    required String subtitle,
    required IconData icon,
    required String bottomText,
    required String bottomValue,
    required Color bottomValueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              Icon(icon, color: const Color(0xFF818CF8), size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(bottomValue, style: TextStyle(color: bottomValueColor, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(child: Text(bottomText, style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF451A03).withValues(alpha: 0.4),
        border: Border.all(color: const Color(0xFFD97706)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF78350F),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF92400E)),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Text('Alerta Contable: Activos Totalmente Depreciados en Operación Activa', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF78350F),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF92400E)),
                      ),
                      child: const Text('D.S. 24051\nArt. 24', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                    children: [
                      TextSpan(text: '3 activos fijos', style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold)),
                      TextSpan(text: ' han alcanzado '),
                      TextSpan(text: 'Bs. 0.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      TextSpan(text: ' de Valor Neto en Libros pero continúan plenamente operativos en planta central (Camión Cisterna Volvo FMX, Torno CNC Industrial Haas, Servidor Backup Dell). Según NIC 16 §51, deben ser inspeccionados para tasación pericial y restitución técnica de valor patrimonial.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Posponer Alerta', style: TextStyle(color: Colors.white54, fontSize: 13)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                label: const Text('Revaluar Activos Depreciados', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        border: Border.all(color: const Color(0xFF334155)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white38, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'Buscar por folio REV, código AF, perito o matrícula...',
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildDropdown('CATEGORÍA:', 'Todas las categorías'),
                const SizedBox(width: 16),
                _buildDropdown('ESTADO:', 'Todos los estados'),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.view_column, size: 16, color: Colors.white70),
                  label: const Text('Columnas', style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF0F172A).withValues(alpha: 0.5),
            child: const Row(
              children: [
                Expanded(flex: 1, child: Text('FOLIO PERICIAL', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('CÓDIGO Y NOMBRE DEL ACTIVO', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('FECHA TASACIÓN', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('PERITO VALUADOR & REGISTRO', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('VNR ANT', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          _buildTableRow('REV-2026-001', 'AF-001', 'Camioneta Toyota Hilux 4x4 (Placa 4022-ABC)', '15/10/2026', 'Ing. Roberto Siles Calvimontes\nRNP-8942-IBNORCA • Reg. Min. 142', false),
          _buildTableRow('REV-2026-002', 'AF-042', 'Torno CNC Haas VF-2 Centro Mecanizado', '28/09/2026', 'Lic. Marco Arze Zalles\nSIB-4410 • Perito Mecánico Industrial', true),
          _buildTableRow('REV-2025-019', 'AF-108', 'Servidor Dell PowerEdge R750 Xeon', '12/08/2026', 'Ing. Roberto Siles Calvimontes\nRNP-8942-IBNORCA • Reg. Min. 142', false),
          _buildTableRow('REV-2025-014', 'AF-015', 'Montacargas Komatsu 3.5T Dual Gas/Gasolina', '03/07/2026', 'Lic. Marco Arze Zalles\nSIB-4410 • Perito Mecánico Industrial', false),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Row(
      children: [
        if (label.isNotEmpty && value.isNotEmpty) Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        if (label.isNotEmpty && value.isNotEmpty) const SizedBox(width: 8),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            border: Border.all(color: const Color(0xFF334155)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(value.isNotEmpty ? value : label, style: const TextStyle(color: Colors.white, fontSize: 12)),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(String folio, String code, String name, String date, String perito, bool hasWarning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.white38, size: 16),
                const SizedBox(width: 8),
                Text(folio, style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                  child: Text(code, style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace')),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))),
                if (hasWarning) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF78350F), borderRadius: BorderRadius.circular(4)),
                    child: const Text('VNR 0', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Expanded(
            flex: 2,
            child: Text(perito, style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.4)),
          ),
          Expanded(flex: 1, child: const Text('Bs. 26,000.00', style: TextStyle(color: Colors.white54, fontSize: 12))),
        ],
      ),
    );
  }

  // --- CANDIDATOS LAYOUT WIDGETS --- //

  Widget _buildCandidatosAlertBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF451A03).withValues(alpha: 0.4),
        border: Border.all(color: const Color(0xFFD97706)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF92400E)),
                ),
                child: const Icon(Icons.assignment_late, color: Color(0xFFFBBF24), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Alerta de Cumplimiento Patrimonial: 3 Activos Plenamente Depreciados en Operación Continua', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text(
                      'Se identificaron 3 activos fijos plenamente depreciados (Valor en libros: Bs. 0.00 / Bs. 1.00) que continúan en operación física reportada en plantas y sucursales. Para reflejar la imagen fiel del patrimonio contable, asigne una orden de peritaje para revalorización técnica con perito colegiado (IBNORCA / SIB) o programe su desincorporación contable definitiva.',
                      style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF92400E)),
                ),
                child: const Text('NIC 16 §51 / D.S. 24051 Art.\n24', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 56), // align with text
              _buildAlertBadge(Icons.account_balance, 'Plan de Cuentas: 1.2.01 (AF) / 3.1.03 (Reserva Revalúo)'),
              const SizedBox(width: 12),
              _buildAlertBadge(Icons.gavel, 'Normativa: D.S. 24051 Art. 24 & NIC 16'),
              const Spacer(),
              const Text('Guía de Procedimiento Pericial (SIB) →', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAlertBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF78350F).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF92400E)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFBBF24), size: 12),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildCandidatosActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        border: Border.all(color: const Color(0xFF334155)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: true,
            onChanged: (v) {},
            fillColor: WidgetStateProperty.all(const Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white70, fontSize: 12),
                children: [
                  TextSpan(text: '3 activos seleccionados ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  TextSpan(text: '(Valor Residual Total: '),
                  TextSpan(text: 'Bs. 0.00', style: TextStyle(fontFamily: 'monospace')),
                  TextSpan(text: ' | Costo Original Acumulado: '),
                  TextSpan(text: 'Bs. 284,000.00', style: TextStyle(fontFamily: 'monospace')),
                  TextSpan(text: ')'),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: const Text('Iniciar Peritaje Técnico en Lote', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 14, color: Color(0xFFFCA5A5)),
                    label: const Text('Rechazar a Bandeja de Bajas', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: const Color(0xFF7F1D1D).withValues(alpha: 0.5)),
                      backgroundColor: const Color(0xFF450A0A).withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 14, color: Colors.white70),
                label: const Text('Exportar Informe Oficial (PDF/XLSX)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCandidatosTableSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.3),
        border: Border.all(color: const Color(0xFF334155)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white38, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Filtrar por código de activo...',
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildDropdown('Categoría: Todas las categorías', ''),
                const SizedBox(width: 12),
                _buildDropdown('Planta / Ubicación: Todas', ''),
                const SizedBox(width: 12),
                _buildDropdown('Severidad: Valor Bs. 0.00', ''),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.view_column, size: 14, color: Colors.white70),
                  label: const Text('Columnas', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Colors.white54, size: 18),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: const BorderSide(color: Color(0xFF334155))),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            color: const Color(0xFF0F172A).withValues(alpha: 0.5),
            child: const Row(
              children: [
                SizedBox(width: 40), // For Checkbox
                Expanded(flex: 1, child: Text('CÓDIGO\nACTIVO', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('NOMBRE Y ESPECIFICACIÓN DEL\nBIEN', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('UBICACIÓN & CUSTODIO\nASIGNADO', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('COSTO ORIGINAL', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                Expanded(flex: 1, child: Text('DEPREC. ACUM.\n(100%)', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                Expanded(flex: 1, child: Text('NETO EN', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                SizedBox(width: 16),
              ],
            ),
          ),
          _buildCandidatoRow('AF-005', 'Camión Cisterna Volvo FMX 440 6x4', 'Placa: 2841-BBA • Motor D13A, 440HP • Tanque acero 20,000 L', 'Planta Industrial La Paz', 'Ing. Mario Méndez (Jefe de Operaciones)', 'Bs. 135,000.00', '-Bs. 135,000.00'),
          _buildCandidatoRow('AF-018', 'Torno CNC Haas VF-2 Centro Mecanizado', 'N/S: CNC-9942 • Husillo 10,000 RPM • 3 ejes de precisión', 'Taller Central Mecánico', 'Tec. Ramiro Suárez (Mantenimiento Industrial)', 'Bs. 98,000.00', '-Bs. 98,000.00'),
          _buildCandidatoRow('AF-042', 'Servidor Rack Dell PowerEdge R750 Xeon', 'Tag TI: SRV-CORP-01 • 128GB RAM • 8TB SAS RAID-10', 'Datacenter Central', 'Lic. Carlos Mendoza (IT Infrastructure Lead)', 'Bs. 51,000.00', '-Bs. 51,000.00'),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                const SizedBox(width: 8),
                const Text('Mostrando 3 de 3 activos candidatos agotados (100% clasificados para peritaje pericial)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const Spacer(),
                const Text('Página 1 de 1', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFF334155)), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left, size: 16, color: Colors.white38), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
                      Container(width: 1, height: 24, color: const Color(0xFF334155)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right, size: 16, color: Colors.white38), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCandidatoRow(String code, String name, String details, String location, String custodian, String cost, String deprec) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(value: true, onChanged: (v) {}, fillColor: WidgetStateProperty.all(const Color(0xFF4F46E5))),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
              child: Text(code, style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace')),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.3)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(custodian, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(cost, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'), textAlign: TextAlign.right)),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(deprec, style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                const Text('(100.0% Depreciado)', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 9)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF7F1D1D).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
                child: const Text('Bs. 0.00', style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildCandidatosFooterCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('IMPACTO ESTIMADO EN PATRIMONIO', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                    Icon(Icons.trending_up, color: Color(0xFF818CF8), size: 16),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('~Bs. 112,500.00', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                const Text('Plusvalía proyectada a Reserva\nRevalúo Técnico (3.1.03)', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 11)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cálculo preliminar basado en\nIBNORCA', style: TextStyle(color: Colors.white54, fontSize: 9)),
                    const Text('+39.6% v/\ncosto', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('REQUISITO D.S. 24051 ART. 24', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                    Icon(Icons.gavel, color: Color(0xFFFCD34D), size: 16),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Perito Valuador Autorizado', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('El informe técnico debe estar sellado por\ningeniero colegiado con registro SIB y no exceder\n180 días contables.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Colegio Departamental de Ing.', style: TextStyle(color: Colors.white54, fontSize: 9)),
                    const Text('Reglamento SIN', style: TextStyle(color: Color(0xFFFCD34D), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF334155))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TRAZABILIDAD FISCAL', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                    Icon(Icons.lock_outline, color: Color(0xFF10B981), size: 16),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('SHA256: 8f4e2b9c7104d5e89a31...fe029d', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                const Text('Cierre fiscal y asientos vinculados con firma\ndigital conforme D.S. 24051.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ledger Node: LPZ-SRV-01', style: TextStyle(color: Colors.white54, fontSize: 9)),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Color(0xFF10B981), size: 6),
                        const SizedBox(width: 4),
                        const Text('Firmado', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
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
}
