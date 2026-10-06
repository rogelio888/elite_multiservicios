import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountingFixedAssetsDisposalsScreen extends StatefulWidget {
  const AccountingFixedAssetsDisposalsScreen({super.key});

  @override
  State<AccountingFixedAssetsDisposalsScreen> createState() =>
      _AccountingFixedAssetsDisposalsScreenState();
}

class _AccountingFixedAssetsDisposalsScreenState
    extends State<AccountingFixedAssetsDisposalsScreen> {
  final List<Map<String, dynamic>> _disposals = [
    {
      'folio': 'BAJ-2024-001',
      'activo': 'Camioneta Hilux 2018 (PL-458)',
      'fecha': '2024-03-15',
      'causa': 'Venta / Enajenación',
      'libros': 125000.00,
      'venta': 140000.00,
      'pnl': 15000.00,
      'pdf': 'acta_001.pdf',
    },
    {
      'folio': 'BAJ-2024-002',
      'activo': 'Servidor Dell PowerEdge R740',
      'fecha': '2024-06-20',
      'causa': 'Obsolescencia Técnica',
      'libros': 4500.00,
      'venta': 0.00,
      'pnl': -4500.00,
      'pdf': 'acta_002.pdf',
    },
    {
      'folio': 'BAJ-2024-003',
      'activo': 'Escritorio Gerencial Roble',
      'fecha': '2024-08-10',
      'causa': 'Siniestro / Destrucción',
      'libros': 2100.00,
      'venta': 0.00,
      'pnl': -2100.00,
      'pdf': 'acta_003.pdf',
    },
  ];

  void _showDisposalModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DisposalLiquidationModal(
        onDisposalAdded: (newDisposal) {
          setState(() {
            _disposals.insert(0, newDisposal);
          });
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
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
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          'Bajas y Retiros de Activos Fijos',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: _buildMetricCard(
                      'Costo Bruto Retirado',
                      'Bs. 340,500.00',
                      Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: _buildMetricCard(
                      'Depreciación Revertida',
                      'Bs. -208,900.00',
                      Colors.orangeAccent,
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: _buildMetricCard(
                      'Ingreso por Enajenación',
                      'Bs. 140,000.00',
                      Colors.greenAccent,
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: _buildMetricCard(
                      'Efecto Neto en P&L',
                      'Bs. 8,400.00',
                      Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de Bajas',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Procesar Baja de Activo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                  ),
                  onPressed: _showDisposalModal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                  dataTextStyle: GoogleFonts.inter(color: Colors.white),
                  columns: const [
                    DataColumn(label: Text('Folio')),
                    DataColumn(label: Text('Activo')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Causa Legal')),
                    DataColumn(label: Text('Valor Libros')),
                    DataColumn(label: Text('Precio Venta')),
                    DataColumn(label: Text('P&L')),
                    DataColumn(label: Text('Acta PDF')),
                  ],
                  rows: _disposals.map((d) {
                    final pnl = d['pnl'] as double;
                    return DataRow(
                      cells: [
                        DataCell(Text(d['folio'] as String)),
                        DataCell(Text(d['activo'] as String)),
                        DataCell(Text(d['fecha'] as String)),
                        DataCell(Text(d['causa'] as String)),
                        DataCell(
                          Text(
                            'Bs. ${(d['libros'] as double).toStringAsFixed(2)}',
                          ),
                        ),
                        DataCell(
                          Text(
                            'Bs. ${(d['venta'] as double).toStringAsFixed(2)}',
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: pnl >= 0
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Bs. ${pnl.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: pnl >= 0
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                d['pdf'] as String,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal de Desincorporación Definitiva y Liquidación Contable bajo D.S. 24051 y NIC 16.
class DisposalLiquidationModal extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDisposalAdded;

  const DisposalLiquidationModal({super.key, required this.onDisposalAdded});

  @override
  State<DisposalLiquidationModal> createState() =>
      _DisposalLiquidationModalState();
}

class _DisposalLiquidationModalState extends State<DisposalLiquidationModal> {
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _sampleAssets = [
    {
      'code': 'AF-2024-004',
      'name': 'Camión Cisterna Volvo FMX 440',
      'costoBruto': 450000.0,
      'deprecAcum': 320000.0,
      'valorLibros': 130000.0,
      'cuentaActivo': '1.2.01.02 - Vehículos y Maquinaria Pesada',
    },
    {
      'code': 'AF-2024-009',
      'name': 'Torno CNC Industrial Haas ST-30',
      'costoBruto': 280000.0,
      'deprecAcum': 210000.0,
      'valorLibros': 70000.0,
      'cuentaActivo': '1.2.01.01 - Maquinaria y Equipos Industriales',
    },
    {
      'code': 'AF-2024-015',
      'name': 'Servidor Backup Dell PowerEdge',
      'costoBruto': 35000.0,
      'deprecAcum': 30000.0,
      'valorLibros': 5000.0,
      'cuentaActivo': '1.2.01.03 - Equipos de Computación',
    },
  ];

  late Map<String, dynamic> _selectedAsset;
  String _causaLegal = 'venta';
  final _precioVentaCtrl = TextEditingController(text: '145000.00');
  final _nroActaCtrl = TextEditingController(text: 'ACT-2024-089');
  final _observacionesCtrl = TextEditingController(
    text: 'Aviso previo al SIN enviado conforme Art. 24 D.S. 24051.',
  );

  @override
  void initState() {
    super.initState();
    _selectedAsset = _sampleAssets.first;
    _precioVentaCtrl.addListener(_rebuild);
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    _precioVentaCtrl.removeListener(_rebuild);
    _precioVentaCtrl.dispose();
    _nroActaCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  double get _precioVenta =>
      double.tryParse(_precioVentaCtrl.text.replaceAll(',', '.')) ?? 0.0;
  double get _costoBruto => _selectedAsset['costoBruto'] as double;
  double get _deprecAcum => _selectedAsset['deprecAcum'] as double;
  double get _valorLibros => _selectedAsset['valorLibros'] as double;
  double get _pnlNeto => _precioVenta - _valorLibros;

  String get _causaLabel {
    switch (_causaLegal) {
      case 'venta':
        return 'Venta / Enajenación';
      case 'obsolescencia':
        return 'Obsolescencia Técnica';
      case 'siniestro':
        return 'Siniestro / Robo';
      case 'donacion':
        return 'Donación Institucional';
      default:
        return 'Baja Definitiva';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pnl = _pnlNeto;
    final isGanancia = pnl >= 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 850,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
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
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                        '1',
                        'SELECCIÓN DEL ACTIVO Y CAUSA DE SALIDA',
                      ),
                      const SizedBox(height: 16),
                      _buildAssetSelector(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildCausaDropdown()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPrecioVentaField()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _nroActaCtrl,
                              'Nro. Acta / Resolución Legal',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              _observacionesCtrl,
                              'Observaciones D.S. 24051 / Notaría',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        '2',
                        'LIQUIDACIÓN Y EFECTO EN RESULTADOS (P&L)',
                      ),
                      const SizedBox(height: 16),
                      _buildPnlSummaryBox(pnl, isGanancia),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        '3',
                        'PREVISUALIZACIÓN ASIENTO AUTOMÁTICO (VOUCHER CD-BAJ)',
                        trailing: 'Partida Doble Cuadrada',
                      ),
                      const SizedBox(height: 16),
                      _buildVoucherTable(pnl, isGanancia),
                      const SizedBox(height: 20),
                      _buildNormativeAlert(),
                    ],
                  ),
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
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.remove_circle_outline,
              color: Color(0xFF818CF8),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Desincorporación Definitiva & Liquidación Contable',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF312E81),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF4338CA)),
                      ),
                      child: Text(
                        'D.S. 24051',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFFA5B4FC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Extinción de bien patrimonial, reversión de depreciación y determinación de Ganancia/Pérdida en Disposición (NIC 16).',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String num, String title, {String? trailing}) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF34D399),
            ),
          ),
      ],
    );
  }

  Widget _buildAssetSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seleccionar Activo Fijo a Dar de Baja',
          style: GoogleFonts.inter(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<Map<String, dynamic>>(
          initialValue: _selectedAsset,
          dropdownColor: const Color(0xFF0F172A),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: _sampleAssets.map((asset) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: asset,
              child: Text(
                '${asset['code']} — ${asset['name']} (Libros: Bs. ${(asset['valorLibros'] as double).toStringAsFixed(2)})',
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedAsset = val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCausaDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Causa Legal de Salida (D.S. 24051)',
          style: GoogleFonts.inter(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _causaLegal,
          dropdownColor: const Color(0xFF0F172A),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'venta',
              child: Text('Venta / Enajenación Pactada'),
            ),
            DropdownMenuItem(
              value: 'obsolescencia',
              child: Text('Obsolescencia Técnica / Chatarra'),
            ),
            DropdownMenuItem(
              value: 'siniestro',
              child: Text('Siniestro / Destrucción / Robo'),
            ),
            DropdownMenuItem(
              value: 'donacion',
              child: Text('Donación Institucional'),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _causaLegal = val;
                if (val != 'venta') {
                  _precioVentaCtrl.text = '0.00';
                }
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPrecioVentaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precio de Rescate / Venta Pactado (Bs.)',
          style: GoogleFonts.inter(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _precioVentaCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            prefixText: 'Bs. ',
            prefixStyle: GoogleFonts.inter(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.grey[300],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPnlSummaryBox(double pnl, bool isGanancia) {
    final Color color = pnl == 0
        ? Colors.white
        : (isGanancia ? const Color(0xFF34D399) : const Color(0xFFF87171));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricItem(
              'COSTO ADQUISICIÓN BRUTO',
              'Bs. ${_costoBruto.toStringAsFixed(2)}',
              Colors.white70,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF334155)),
          Expanded(
            child: _buildMetricItem(
              'DEPRECIACIÓN REVERTIDA',
              'Bs. -${_deprecAcum.toStringAsFixed(2)}',
              const Color(0xFFFBBF24),
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF334155)),
          Expanded(
            child: _buildMetricItem(
              'VALOR NETO EN LIBROS',
              'Bs. ${_valorLibros.toStringAsFixed(2)}',
              Colors.white,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF334155)),
          Expanded(
            child: _buildMetricItem(
              'PRECIO DE VENTA / RESCATE',
              'Bs. ${_precioVenta.toStringAsFixed(2)}',
              const Color(0xFF60A5FA),
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF334155)),
          Expanded(
            child: _buildMetricItem(
              isGanancia ? 'GANANCIA EN DISPOSICIÓN' : 'PÉRDIDA EN DISPOSICIÓN',
              'Bs. ${pnl.abs().toStringAsFixed(2)}',
              color,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String val,
    Color valColor, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: valColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherTable(double pnl, bool isGanancia) {
    final double debeTotal =
        _precioVenta + _deprecAcum + (pnl < 0 ? pnl.abs() : 0.0);
    final double haberTotal = _costoBruto + (pnl > 0 ? pnl : 0.0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(4.5),
          2: FlexColumnWidth(2.0),
          3: FlexColumnWidth(2.0),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            children: [
              _cellHeader('Cuenta'),
              _cellHeader('Concepto'),
              _cellHeader('Debe (Bs.)', alignRight: true),
              _cellHeader('Haber (Bs.)', alignRight: true),
            ],
          ),
          if (_precioVenta > 0)
            TableRow(
              children: [
                _cell('1.1.01.01', isCode: true),
                _cell('Caja / Bancos (Cobro enajenación)'),
                _cell(_precioVenta.toStringAsFixed(2), alignRight: true),
                _cell('0.00', alignRight: true),
              ],
            ),
          TableRow(
            children: [
              _cell('1.2.04.01', isCode: true),
              _cell('Depreciación Acumulada Revertida'),
              _cell(_deprecAcum.toStringAsFixed(2), alignRight: true),
              _cell('0.00', alignRight: true),
            ],
          ),
          if (pnl < 0)
            TableRow(
              children: [
                _cell('5.1.08.01', isCode: true),
                _cell('Pérdida por Baja de Activos Fijos (D.S. 24051)'),
                _cell(
                  pnl.abs().toStringAsFixed(2),
                  alignRight: true,
                  textColor: const Color(0xFFF87171),
                ),
                _cell('0.00', alignRight: true),
              ],
            ),
          if (pnl > 0)
            TableRow(
              children: [
                _cell('4.2.03.01', isCode: true),
                _cell('Ganancia en Venta de Activos Fijos'),
                _cell('0.00', alignRight: true),
                _cell(
                  pnl.toStringAsFixed(2),
                  alignRight: true,
                  textColor: const Color(0xFF34D399),
                ),
              ],
            ),
          TableRow(
            children: [
              _cell(_selectedAsset['cuentaActivo'] as String, isCode: true),
              _cell('Extinción de ${_selectedAsset['name']}'),
              _cell('0.00', alignRight: true),
              _cell(_costoBruto.toStringAsFixed(2), alignRight: true),
            ],
          ),
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            children: [
              _cell('TOTALES', isBold: true),
              _cell(
                'Partida Doble Verificada',
                isBold: true,
                textColor: const Color(0xFF34D399),
              ),
              _cell(
                debeTotal.toStringAsFixed(2),
                alignRight: true,
                isBold: true,
              ),
              _cell(
                haberTotal.toStringAsFixed(2),
                alignRight: true,
                isBold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cellHeader(String text, {bool alignRight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.grey[400],
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _cell(
    String text, {
    bool isCode = false,
    bool alignRight = false,
    bool isBold = false,
    Color? textColor,
  }) {
    final style = isCode
        ? GoogleFonts.jetBrainsMono(
            color: textColor ?? (isBold ? Colors.white : Colors.white70),
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          )
        : GoogleFonts.inter(
            color: textColor ?? (isBold ? Colors.white : Colors.white70),
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        text,
        style: style,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _buildNormativeAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4338CA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.gavel, color: Color(0xFFA5B4FC), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Validación D.S. 24051 (Art. 24): Para bajas por obsolescencia o siniestro, se exige aviso previo al SIN (10 días) e informe de laboratorio / notario para deducibilidad fiscal.',
              style: GoogleFonts.inter(
                color: const Color(0xFFC7D2FE),
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF475569)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Asentar Baja & Liquidación',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () {
              final newDisposal = {
                'folio': 'BAJ-2024-00${DateTime.now().second}',
                'activo': '${_selectedAsset['name']}',
                'fecha': DateTime.now().toString().split(' ')[0],
                'causa': _causaLabel,
                'libros': _valorLibros,
                'venta': _precioVenta,
                'pnl': _pnlNeto,
                'pdf': 'acta_${_nroActaCtrl.text}.pdf',
              };
              widget.onDisposalAdded(newDisposal);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
