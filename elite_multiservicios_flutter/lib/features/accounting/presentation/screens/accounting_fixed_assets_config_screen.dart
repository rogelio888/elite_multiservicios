import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pantalla de Configuración Contable - Sub-módulo Activos Fijos.
class AccountingFixedAssetsConfigScreen extends StatefulWidget {
  const AccountingFixedAssetsConfigScreen({super.key});

  @override
  State<AccountingFixedAssetsConfigScreen> createState() =>
      _AccountingFixedAssetsConfigScreenState();
}

class _AccountingFixedAssetsConfigScreenState
    extends State<AccountingFixedAssetsConfigScreen> {
  final _nombreCtrl = TextEditingController(
    text: 'Equipos de Computación y Periféricos',
  );
  final _codigoCtrl = TextEditingController(text: 'CAT-IT-01');
  final _vidaUtilCtrl = TextEditingController(text: '48 meses (4 años)');
  final _dsCtrl = TextEditingController(text: 'DS 24051');
  final _tasaCtrl = TextEditingController(text: '25.00');
  final _valorResidualCtrl = TextEditingController(text: '10.00');

  String _metodoDepreciacion = 'Línea Recta (Fiscal / Contable NIC 16)';
  String _cuentaActivoFijo =
      '1.2.01.03 - Equipos de Procesamiento de Datos y Computación';
  String _cuentaGastoDeprec =
      '5.1.04.01 - Gasto Depreciación Equipos de Computación';
  String _cuentaDeprecAcum =
      '1.2.04.01 - Deprec. Acumulada Equipos de Computación';

  bool _mapeoOC = true;
  bool _requerirAprobacion = true;

  static const Color _indigo = Color(0xFF4F46E5);
  static const Color _border = Color(0xFF334155);
  static const Color _textDark = Color(0xFFFFFFFF);
  static const Color _textMid = Color(0xFF94A3B8);
  static const Color _textLight = Color(0xFF94A3B8);

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _codigoCtrl.dispose();
    _vidaUtilCtrl.dispose();
    _dsCtrl.dispose();
    _tasaCtrl.dispose();
    _valorResidualCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection1(),
            const SizedBox(height: 16),
            _buildSection2(),
            const SizedBox(height: 16),
            _buildSection3(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      scrolledUnderElevation: 0.5,
      titleSpacing: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 12),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _indigo,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'IT',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurar Reglas Contables de Categoria',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 2),
            Wrap(
              spacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Codigo: CAT-IT-01',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _textMid,
                  ),
                ),
                _badge(
                  'Activa',
                  const Color(0xFF10B981),
                  const Color(0xFFD1FAE5),
                ),
                _badge(
                  'Mapeada',
                  const Color(0xFF6366F1),
                  const Color(0xFFEDE9FE),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _badge(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // SECTION 1 -------------------------------------------
  Widget _buildSection1() {
    return _sectionCard(
      number: '1',
      title: 'DATOS GENERALES & VIDA FISCAL',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Nombre Descriptivo de la Categoría *'),
          const SizedBox(height: 6),
          _textField(controller: _nombreCtrl),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Código Contable Interno'),
                    const SizedBox(height: 6),
                    _textField(controller: _codigoCtrl),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Vida Útil Estándar *'),
                    const SizedBox(height: 6),
                    _textFieldWithSuffix(
                      controller: _vidaUtilCtrl,
                      suffix: _dsCtrl.text,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Tasa de Amortización Anual (%)'),
                    const SizedBox(height: 6),
                    _textFieldWithSuffix(
                      controller: _tasaCtrl,
                      suffix: '% / año',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Valor Residual Sugerido (%)'),
                    const SizedBox(height: 6),
                    _textFieldWithSuffix(
                      controller: _valorResidualCtrl,
                      suffix: '% rescate',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Método de Depreciación Predeterminado *'),
          const SizedBox(height: 6),
          _dropdownField(
            value: _metodoDepreciacion,
            items: const [
              'Línea Recta (Fiscal / Contable NIC 16)',
              'Saldo Decreciente',
              'Unidades de Producción',
            ],
            onChanged: (v) => setState(() => _metodoDepreciacion = v!),
          ),
          const SizedBox(height: 8),
          Text(
            'Base no amortizable sujeta a valor de rescate fijado por política contable institucional.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF4F46E5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 2 -------------------------------------------
  Widget _buildSection2() {
    return _sectionCard(
      number: '2',
      title: 'MAPEO DE CUENTAS CONTABLES (CATÁLOGO LIBRO MAYOR)',
      child: Column(
        children: [
          _cuentaRow(
            tipo: 'DEBITO / ACTIVO',
            tipoBg: const Color(0xFFDBEAFE),
            tipoFg: const Color(0xFF1E40AF),
            label: 'Cuenta de Activo Fijo (Alta Inicial en Balance) *',
            value: _cuentaActivoFijo,
            items: const [
              '1.2.01.03 - Equipos de Procesamiento de Datos y Computación',
              '1.2.01.01 - Maquinaria y Equipos',
              '1.2.01.04 - Mobiliario y Enseres',
            ],
            onChanged: (v) => setState(() => _cuentaActivoFijo = v!),
          ),
          const SizedBox(height: 14),
          _cuentaRow(
            tipo: 'DEBITO / P&L',
            tipoBg: const Color(0xFFFEF3C7),
            tipoFg: const Color(0xFF92400E),
            label: 'Cuenta de Gasto por Depreciación Periódica *',
            value: _cuentaGastoDeprec,
            items: const [
              '5.1.04.01 - Gasto Depreciación Equipos de Computación',
              '5.1.04.02 - Gasto Depreciación Maquinaria',
              '5.1.04.03 - Gasto Depreciación Vehículos',
            ],
            onChanged: (v) => setState(() => _cuentaGastoDeprec = v!),
          ),
          const SizedBox(height: 14),
          _cuentaRow(
            tipo: 'CREDITO / COMPENSACION',
            tipoBg: const Color(0xFFDCFCE7),
            tipoFg: const Color(0xFF166534),
            label: 'Cuenta de Depreciación Acumulada (Contrapartida) *',
            value: _cuentaDeprecAcum,
            items: const [
              '1.2.04.01 - Deprec. Acumulada Equipos de Computación',
              '1.2.04.02 - Deprec. Acumulada Maquinaria',
              '1.2.04.03 - Deprec. Acumulada Vehículos',
            ],
            onChanged: (v) => setState(() => _cuentaDeprecAcum = v!),
          ),
        ],
      ),
    );
  }

  Widget _cuentaRow({
    required String tipo,
    required Color tipoBg,
    required Color tipoFg,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: tipoBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tipo,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: tipoFg,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(fontSize: 12, color: _textMid),
              ),
            ),
            Text(
              'Verificada',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _dropdownField(value: value, items: items, onChanged: onChanged),
      ],
    );
  }

  // SECTION 3 -------------------------------------------
  Widget _buildSection3() {
    return _sectionCard(
      number: '3',
      title: 'REGLAS DE AUTOMATIZACIÓN & GOBERNANZA',
      child: Column(
        children: [
          _checkRow(
            value: _mapeoOC,
            label: 'Mapeo Automático en Órdenes de Compra (OC)',
            description:
                'Aplicar automáticamente a nuevas altas de compras cuando la factura recepcionada coincida con los códigos tributarios de computación.',
            onChanged: (v) => setState(() => _mapeoOC = v!),
          ),
          const SizedBox(height: 14),
          _checkRow(
            value: _requerirAprobacion,
            label: 'Requerir Aprobación de Harold Eastman (CFO)',
            description:
                'Cualquier baja anticipada, cambio de vida útil o modificación en la tasa residual exigirá firma digital criptográfica de auditoría.',
            onChanged: (v) => setState(() => _requerirAprobacion = v!),
          ),
        ],
      ),
    );
  }

  Widget _checkRow({
    required bool value,
    required String label,
    required String description,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: _indigo,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _textMid,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------

  Widget _sectionCard({
    required String number,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  void _onGuardarPlantilla() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Guardar plantilla')));
  }

  void _onGuardarCambios() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Guardar cambios')));
  }

  // BOTTOM BAR -------------------------------------------
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF94A3B8)),
              foregroundColor: const Color(0xFF64748B),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: _onGuardarPlantilla,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF94A3B8)),
              foregroundColor: const Color(0xFF64748B),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Guardar como Plantilla',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _onGuardarCambios,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Guardar Configuración',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _textMid,
      ),
    );
  }

  InputDecoration _inputDecoration({String? suffix}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      suffixText: suffix,
      suffixStyle: GoogleFonts.inter(fontSize: 11, color: _textLight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _indigo, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFF0F172A),
    );
  }

  Widget _textField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 13, color: _textDark),
      decoration: _inputDecoration(),
    );
  }

  Widget _textFieldWithSuffix({
    required TextEditingController controller,
    required String suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 13, color: _textDark),
      decoration: _inputDecoration(suffix: suffix),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: value,
      isExpanded: true,
      style: GoogleFonts.inter(fontSize: 12.5, color: _textDark),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 18,
        color: Color(0xFF94A3B8),
      ),
      decoration: _inputDecoration(),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 12.5, color: _textDark),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
