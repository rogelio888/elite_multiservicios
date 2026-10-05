import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import 'package:intl/intl.dart';
import '../widgets/accounting_fixed_assets_create_dialog.dart';
import 'accounting_fixed_assets_depreciation_batch_screen.dart';

class AccountingFixedAssetsScreen extends ConsumerStatefulWidget {
  const AccountingFixedAssetsScreen({super.key});

  @override
  ConsumerState<AccountingFixedAssetsScreen> createState() =>
      _AccountingFixedAssetsScreenState();
}

class _AccountingFixedAssetsScreenState
    extends ConsumerState<AccountingFixedAssetsScreen> {
  AccountingFixedAsset? _selectedAsset;
  bool _showBatchScreen = false;

  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AccountingFixedAssetsCreateDialog(),
    ).then((_) {
      ref.invalidate(fixedAssetsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showBatchScreen) {
      return AccountingFixedAssetsDepreciationBatchScreen(
        onBack: () => setState(() => _showBatchScreen = false),
      );
    }

    final assetsAsync = ref.watch(fixedAssetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          _buildSummaryCards(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: List
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildListToolbar(),
                          const Divider(height: 1),
                          Expanded(
                            child: assetsAsync.when(
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, s) => Center(child: Text('Error: $e')),
                              data: (assets) {
                                if (assets.isEmpty) {
                                  return const Center(child: Text('No hay activos registrados.'));
                                }
                                return ListView.separated(
                                  itemCount: assets.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final asset = assets[index];
                                    final isSelected = _selectedAsset?.id == asset.id;
                                    return _buildAssetRow(asset, isSelected);
                                  },
                                );
                              },
                            ),
                          ),
                          _buildListFooter(assetsAsync.value?.length ?? 0),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedAsset != null) ...[
                    const SizedBox(width: 24),
                    // Right side: Detail Panel
                    Expanded(
                      flex: 4,
                      child: _buildDetailPanel(_selectedAsset!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('MÓDULO\nCONTABLE', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('ACTIVOS FIJOS &\nDEPRECIACIONES', style: TextStyle(fontSize: 10, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Gestión de Activos Fijos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const SizedBox(height: 4),
              const Text('Control patrimonial, depreciación lineal acumulada\ny asignación de custodios.', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Exportar Inventario'),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Correr Depreciación'),
                onPressed: () {
                  setState(() {
                    _showBatchScreen = true;
                  });
                },
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Registrar Activo'),
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () => _showAddDialog(context, ref),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Row(
        children: [
          Expanded(child: _buildCard('COSTO ADQUISICIÓN BRUTO', '\$1,850,000', '482 activos registrados', Icons.account_balance, Colors.green, '+4 este mes')),
          const SizedBox(width: 16),
          Expanded(child: _buildCard('DEPRECIACIÓN ACUMULADA', '-\$509,500', '27.5% amortizado', Icons.trending_down, Colors.red, 'Método lineal')),
          const SizedBox(width: 16),
          Expanded(child: _buildCard('VALOR NETO EN LIBROS', '\$1,340,500', 'Base imponible consolidada', Icons.pie_chart_outline, Colors.blue, 'Valor Patrimonial')),
          const SizedBox(width: 16),
          Expanded(child: _buildCard('CUOTA MENSUAL LINEAL', '\$12,450.00', 'Próxima corrida: 31 Oct 2024', Icons.schedule, Colors.orange, '')),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String amount, String subtitle, IconData icon, Color color, String badge) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: amount.startsWith('-') ? Colors.red : Colors.black)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey))),
              if (badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(badge, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListToolbar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por código, serie o descripción...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: 'IT Hardware',
                      items: const [DropdownMenuItem(value: 'IT Hardware', child: Text('IT Hardware'))],
                      onChanged: (v) {},
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Operativo',
                    items: const [DropdownMenuItem(value: 'Operativo', child: Text('Operativo'))],
                    onChanged: (v) {},
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(icon: const Icon(Icons.clear, size: 16), label: const Text('Limpiar', style: TextStyle(color: Colors.grey)), onPressed: () {}),
              const Spacer(),
              OutlinedButton.icon(icon: const Icon(Icons.settings_suggest, size: 16), label: const Text('Ajuste / Baja de Bien'), onPressed: () {}),
              const SizedBox(width: 12),
              OutlinedButton.icon(icon: const Icon(Icons.view_column, size: 16), label: const Text('Columnas'), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAssetRow(AccountingFixedAsset asset, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedAsset = asset),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
          border: isSelected ? const Border(left: BorderSide(color: Color(0xFF4F46E5), width: 3)) : null,
        ),
        child: Row(
          children: [
            Checkbox(value: isSelected, onChanged: (v) {}),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Text('ACT-${asset.purchaseDate.year}-${asset.id ?? '000'}', style: TextStyle(color: isSelected ? const Color(0xFF4F46E5) : Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('S/N: BF21Q93-XLR', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(4)),
                child: Text(asset.category, style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(DateFormat('dd MMM yyyy').format(asset.purchaseDate), style: const TextStyle(fontSize: 12)),
            ),
            Expanded(
              flex: 2,
              child: Text(currencyFormat.format(asset.purchaseValue), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListFooter(int count) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mostrando 1 - $count de $count activos', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(4)),
                child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDetailPanel(AccountingFixedAsset asset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(4)),
                            child: Text('ACT-${asset.purchaseDate.year}-${asset.id ?? '000'}', style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                            child: const Text('● Operativo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _selectedAsset = null)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(asset.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  const SizedBox(height: 4),
                  const Text('Ficha Técnica Patrimonial & Ledger Schedule', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 24),
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.computer, color: Colors.white54, size: 48),
                          const SizedBox(height: 8),
                          Text(asset.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Text('Tag de Inventario Físico: #BO-LPZ-DC2', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSectionTitle('COMPROBANTE DE COMPRA', trailing: 'Ver Factura PDF'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDetailValue('FACTURA COMERCIAL', '#FAC-9842')),
                      Expanded(child: _buildDetailValue('PROVEEDOR HOMOLOGADO', 'Dell Enterprise Bolivia')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.calculate_outlined, size: 16, color: Color(0xFF4F46E5)),
                                SizedBox(width: 8),
                                Text('Programa de Depreciación Lineal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            Text('NIC 16 / DS 24051', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                        const Divider(height: 32),
                        Row(
                          children: [
                            Expanded(child: _buildDetailValue('BASE DEPRECIABLE', currencyFormat.format(asset.purchaseValue))),
                            Expanded(child: _buildDetailValue('VALOR RESIDUAL (10%)', currencyFormat.format(asset.purchaseValue * 0.10))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildDetailValue('VIDA ÚTIL TOTAL', '${asset.usefulLifeMonths} meses')),
                            Expanded(child: _buildDetailValue('CUOTA MENSUAL', '${currencyFormat.format(asset.purchaseValue * 0.90 / asset.usefulLifeMonths)} / mes', valueColor: const Color(0xFF4F46E5))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amortización Transcurrida (14 meses)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text('29.2% (${currencyFormat.format(asset.purchaseValue * 0.292)})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: 0.292, backgroundColor: Colors.grey.shade200, color: const Color(0xFF4F46E5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSectionTitle('CUSTODIA Y ASIGNACIÓN FÍSICA'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: const Color(0xFF4F46E5), child: const Text('CM', style: TextStyle(color: Colors.white, fontSize: 12))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Ing. Carlos Mendoza', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('IT Operations Lead • IT Infra Dept', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                        OutlinedButton(onPressed: () {}, child: const Text('Reasignar')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSectionTitle('HISTORIAL DE MANTENIMIENTOS & AUDITORÍA'),
                  const SizedBox(height: 12),
                  _buildTimelineItem('15 Oct 2024', 'Ticket #MNT-2024-88', 'Mantenimiento preventivo semestral: limpieza física de ventiladores y actualización de firmware BIOS.', Colors.green),
                  _buildTimelineItem('02 May 2024', 'Aprobado por CFO', 'Reasignación formal de custodia aprobada por Harold Eastman desde staging a Producción.', Colors.blue),
                  _buildTimelineItem('10 Ene 2024', 'Alta Inicial', 'Alta en libro de compras, etiquetado con tag RFID e inspección técnica inicial completada.', Colors.grey, isLast: true),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(icon: const Icon(Icons.qr_code, color: Colors.grey), label: const Text('Etiqueta QR', style: TextStyle(color: Colors.grey)), onPressed: () {}),
                Row(
                  children: [
                    TextButton.icon(icon: const Icon(Icons.build, color: Colors.grey), label: const Text('Mantenimiento', style: TextStyle(color: Colors.grey)), onPressed: () {}),
                    const SizedBox(width: 12),
                    TextButton.icon(icon: const Icon(Icons.delete_outline, color: Colors.red), label: const Text('Baja', style: TextStyle(color: Colors.red)), onPressed: () {}),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailSectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        if (trailing != null)
          Text(trailing, style: const TextStyle(fontSize: 11, color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDetailValue(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black)),
      ],
    );
  }

  Widget _buildTimelineItem(String date, String title, String description, Color dotColor, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
              if (!isLast) Expanded(child: Container(width: 1, color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
