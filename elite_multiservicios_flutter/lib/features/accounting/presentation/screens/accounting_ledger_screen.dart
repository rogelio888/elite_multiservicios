import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountNode {
  final String code;
  final String name;
  final List<AccountNode> children;
  bool isExpanded;

  AccountNode({required this.code, required this.name, this.children = const [], this.isExpanded = false});
}

class AccountingLedgerScreen extends StatefulWidget {
  const AccountingLedgerScreen({super.key});

  @override
  State<AccountingLedgerScreen> createState() => _AccountingLedgerScreenState();
}

class _AccountingLedgerScreenState extends State<AccountingLedgerScreen> {
  String _searchQuery = '';
  
  final List<AccountNode> _accounts = [
    AccountNode(code: '1', name: 'ACTIVO', children: [
      AccountNode(code: '1.1', name: 'Disponible', children: [
        AccountNode(code: '1.1.01', name: 'Caja Principal'),
        AccountNode(code: '1.1.02', name: 'Cajas Chicas'),
        AccountNode(code: '1.1.03', name: 'Bancos Nacionales'),
        AccountNode(code: '1.1.04', name: 'Bancos Extranjeros USD'),
      ]),
      AccountNode(code: '1.2', name: 'Activo Fijo', children: [
        AccountNode(code: '1.2.01', name: 'Terrenos y Edificaciones'),
        AccountNode(code: '1.2.02', name: 'Maquinaria y Equipo'),
        AccountNode(code: '1.2.03', name: 'Vehículos'),
        AccountNode(code: '1.2.04', name: 'Equipos de Computación'),
        AccountNode(code: '1.2.99', name: 'Depreciación Acumulada (-)'),
      ]),
    ]),
    AccountNode(code: '2', name: 'PASIVO', children: [
      AccountNode(code: '2.1', name: 'Pasivo Corriente', children: [
        AccountNode(code: '2.1.01', name: 'Cuentas por Pagar Proveedores'),
        AccountNode(code: '2.1.02', name: 'Impuestos por Pagar'),
        AccountNode(code: '2.1.03', name: 'Beneficios Sociales por Pagar'),
      ]),
    ]),
    AccountNode(code: '3', name: 'PATRIMONIO', children: [
      AccountNode(code: '3.1', name: 'Capital y Reservas', children: [
        AccountNode(code: '3.1.01', name: 'Capital Social'),
        AccountNode(code: '3.1.02', name: 'Resultados Acumulados'),
        AccountNode(code: '3.1.03', name: 'Reserva por Revalúos Técnicos'),
      ]),
    ]),
    AccountNode(code: '4', name: 'INGRESOS', children: [
      AccountNode(code: '4.1', name: 'Ingresos Operativos', children: [
        AccountNode(code: '4.1.01', name: 'Ventas de Servicios'),
        AccountNode(code: '4.1.02', name: 'Ventas de Productos'),
      ]),
      AccountNode(code: '4.2', name: 'Ingresos Extraordinarios', children: [
        AccountNode(code: '4.2.01', name: 'Ingreso por Enajenación de Activos'),
      ]),
    ]),
    AccountNode(code: '5', name: 'GASTOS', children: [
      AccountNode(code: '5.1', name: 'Costos Operativos'),
      AccountNode(code: '5.2', name: 'Gastos Administrativos', children: [
        AccountNode(code: '5.2.01', name: 'Sueldos y Salarios'),
        AccountNode(code: '5.2.02', name: 'Servicios Básicos'),
      ]),
      AccountNode(code: '5.3', name: 'Gastos No Efectivos', children: [
        AccountNode(code: '5.3.01', name: 'Gasto Depreciación Activos Fijos'),
        AccountNode(code: '5.3.02', name: 'Pérdida por Baja de Activos'),
      ]),
    ]),
  ];

  List<Widget> _buildTree(List<AccountNode> nodes, int level) {
    List<Widget> list = [];
    for (var node in nodes) {
      if (_searchQuery.isNotEmpty && !node.name.toLowerCase().contains(_searchQuery.toLowerCase()) && !node.code.contains(_searchQuery)) {
        // If searching and this doesn't match, we still need to check children
        bool hasMatchingChild = _hasMatchingChild(node, _searchQuery);
        if (!hasMatchingChild) continue;
      }

      list.add(
        InkWell(
          onTap: node.children.isNotEmpty ? () {
            setState(() {
              node.isExpanded = !node.isExpanded;
            });
          } : null,
          child: Container(
            padding: EdgeInsets.only(left: 16.0 + (level * 24.0), top: 12, bottom: 12, right: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: const Color(0xFF334155).withValues(alpha: 0.5))),
            ),
            child: Row(
              children: [
                if (node.children.isNotEmpty)
                  Icon(node.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: Colors.grey[400], size: 16)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(node.code, style: GoogleFonts.inter(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    node.name,
                    style: GoogleFonts.inter(
                      color: level == 0 ? Colors.white : Colors.grey[300],
                      fontWeight: level == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (node.isExpanded || _searchQuery.isNotEmpty) {
        list.addAll(_buildTree(node.children, level + 1));
      }
    }
    return list;
  }

  bool _hasMatchingChild(AccountNode node, String query) {
    for (var child in node.children) {
      if (child.name.toLowerCase().contains(query.toLowerCase()) || child.code.contains(query)) {
        return true;
      }
      if (_hasMatchingChild(child, query)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Catálogo de Cuentas', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showNewAccountModal(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text('Nueva Cuenta Inmutable', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar cuenta por código o nombre...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: ListView(
                  children: _buildTree(_accounts, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewAccountModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _NewAccountModal(),
    );
  }
}

class _NewAccountModal extends StatefulWidget {
  const _NewAccountModal();

  @override
  State<_NewAccountModal> createState() => _NewAccountModalState();
}

class _NewAccountModalState extends State<_NewAccountModal> {
  String _nature = 'Deudora';
  String _currency = 'BOB';
  bool _allowManual = true;
  bool _requireCostCenter = false;

  Widget _buildFieldLabel(String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          children: [
            if (required)
              TextSpan(text: ' *', style: GoogleFonts.inter(color: const Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value) {
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
          Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(bottom: BorderSide(color: Color(0xFF334155))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.playlist_add, color: Color(0xFF818CF8)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Nueva Cuenta Inmutable (Nivel 4)', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                              ),
                              child: Text('Inmutable / Operativa', style: GoogleFonts.inter(color: const Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Las cuentas inmutables reciben comprobantes de diario, cobros, pagos y asientos\nautomáticos de depreciación.', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Cuenta Padre / Mayor Superior (Nivel 3)'),
                  _buildDropdown('1.1.01 - Disponible en Caja y Bancos (Activo Corriente)'),
                  const SizedBox(height: 6),
                  Text('Ruta jerárquica: 1. ACTIVO > 1.1 ACTIVO CORRIENTE > 1.1.01 Disponible en Caja y Bancos', style: GoogleFonts.robotoMono(color: Colors.grey[500], fontSize: 10)),
                  const SizedBox(height: 20),

                  _buildFieldLabel('Código Contable Correlativo Asignado'),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('1.1.01.', style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF818CF8)),
                        ),
                        child: Text('04', style: GoogleFonts.robotoMono(color: const Color(0xFF818CF8), fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF064E3B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 16),
                              const SizedBox(width: 8),
                              Text('Código disponible (libre de colisión)', style: GoogleFonts.robotoMono(color: const Color(0xFF10B981), fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildFieldLabel('Nombre Oficial de la Cuenta Contable'),
                  _buildTextField('Banco BISA Cta. Corriente Empresarial BOB'),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Naturaleza del Saldo'),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => _nature = 'Deudora'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _nature == 'Deudora' ? const Color(0xFF1E293B) : Colors.transparent,
                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                                          border: _nature == 'Deudora' ? Border.all(color: const Color(0xFF6366F1)) : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(width: 8, height: 8, decoration: BoxDecoration(color: _nature == 'Deudora' ? const Color(0xFF6366F1) : Colors.grey[600], shape: BoxShape.circle)),
                                            const SizedBox(width: 8),
                                            Text('Deudora', style: GoogleFonts.inter(color: _nature == 'Deudora' ? const Color(0xFF818CF8) : Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => _nature = 'Acreedora'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _nature == 'Acreedora' ? const Color(0xFF1E293B) : Colors.transparent,
                                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
                                          border: _nature == 'Acreedora' ? Border.all(color: const Color(0xFF6366F1)) : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(width: 8, height: 8, decoration: BoxDecoration(color: _nature == 'Acreedora' ? const Color(0xFF6366F1) : Colors.grey[600], shape: BoxShape.circle)),
                                            const SizedBox(width: 8),
                                            Text('Acreedora', style: GoogleFonts.inter(color: _nature == 'Acreedora' ? const Color(0xFF818CF8) : Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
                            _buildFieldLabel('Mapeo de Módulo Operativo'),
                            _buildDropdown('Tesorería & Bancos'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildFieldLabel('Moneda Operativa Autorizada', required: false),
                  Row(
                    children: [
                      _buildCurrencyToggle('BOB', 'BOB - Bolivianos (Moneda Base)'),
                      const SizedBox(width: 8),
                      _buildCurrencyToggle('USD', 'USD - Dólares Americanos'),
                      const SizedBox(width: 8),
                      _buildCurrencyToggle('MULTI', 'Multimoneda'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () => setState(() => _allowManual = !_allowManual),
                    child: Row(
                      children: [
                        Icon(_allowManual ? Icons.check_box : Icons.check_box_outline_blank, color: _allowManual ? const Color(0xFF6366F1) : Colors.grey[500], size: 20),
                        const SizedBox(width: 8),
                        Text('Permite asientos manuales directos en Libro Diario', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => setState(() => _requireCostCenter = !_requireCostCenter),
                    child: Row(
                      children: [
                        Icon(_requireCostCenter ? Icons.check_box : Icons.check_box_outline_blank, color: _requireCostCenter ? const Color(0xFF6366F1) : Colors.grey[500], size: 20),
                        const SizedBox(width: 8),
                        Text('Exigir Centro de Costos en cada registro contable', style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Auditoría activa: Harold Eastman\n(CFO)', style: GoogleFonts.robotoMono(color: Colors.grey[500], fontSize: 10)),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.lock_outline, size: 16),
                    label: const Text('Guardar y Habilitar en Libro\nMayor', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyToggle(String id, String label) {
    final isSelected = _currency == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currency = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.1) : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF334155)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? const Color(0xFF818CF8) : Colors.grey[400],
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

