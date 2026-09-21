import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/crm_catalog_service.dart';

/// Vista de Administración del Catálogo de Servicios, Rubros Industriales,
/// Líneas de Servicio y Tarifario Maestro con Precios Diferenciados (Scopes).
class CrmCatalogManagementView extends StatefulWidget {
  const CrmCatalogManagementView({super.key});

  @override
  State<CrmCatalogManagementView> createState() =>
      _CrmCatalogManagementViewState();
}

class _CrmCatalogManagementViewState extends State<CrmCatalogManagementView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CrmCatalogService _catalogService = CrmCatalogService.instance;

  String _searchQuery = '';
  int? _selectedServiceLineFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _catalogService.loadAll();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _catalogService,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: _catalogService.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF10B981),
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildItemsTab(),
                          _buildSectorsTab(),
                          _buildServiceLinesTab(),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HEADER Y TABS
  // ===========================================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Color(0xFF334155), width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 820;
          final titleWidget = Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catálogo & Tarifario Maestro',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Configuración de partidas, fórmulas por m²/puesto/hora y rubros objetivo',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );

          final actionsWidget = Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Actualizar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF94A3B8),
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onPrimaryCreateAction,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(_getCreateButtonLabel()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                const SizedBox(height: 14),
                actionsWidget,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              const SizedBox(width: 16),
              actionsWidget,
            ],
          );
        },
      ),
    );
  }

  String _getCreateButtonLabel() {
    switch (_tabController.index) {
      case 1:
        return 'Nuevo Rubro';
      case 2:
        return 'Nueva Línea';
      default:
        return 'Nueva Partida';
    }
  }

  void _onPrimaryCreateAction() {
    switch (_tabController.index) {
      case 1:
        _showSectorDialog();
        break;
      case 2:
        _showServiceLineDialog();
        break;
      default:
        _showCatalogItemDialog();
        break;
    }
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF1E293B),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: const Color(0xFF10B981),
        indicatorWeight: 3,
        labelColor: const Color(0xFF10B981),
        unselectedLabelColor: const Color(0xFF94A3B8),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            icon: const Icon(Icons.sell_outlined, size: 18),
            text: 'Partidas de Servicio (${_catalogService.catalogItems.length})',
          ),
          Tab(
            icon: const Icon(Icons.domain_rounded, size: 18),
            text: 'Rubros Industriales (${_catalogService.sectors.length})',
          ),
          Tab(
            icon: const Icon(Icons.account_tree_outlined, size: 18),
            text: 'Líneas de Servicio (${_catalogService.serviceLines.length})',
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 1: PARTIDAS DE SERVICIO (TARIFARIO)
  // ===========================================================================

  Widget _buildItemsTab() {
    final items = _catalogService.catalogItems.where((item) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = item.concept.toLowerCase().contains(q) ||
            item.code.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedServiceLineFilter != null &&
          item.serviceLineId != _selectedServiceLineFilter) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Barra de filtros
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            border: Border(
              bottom: BorderSide(color: Color(0xFF334155), width: 1),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              final searchWidget = TextField(
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por concepto o código...',
                  hintStyle: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF10B981)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              );

              final dropdownWidget = DropdownButtonFormField<int?>(
                initialValue: _selectedServiceLineFilter,
                dropdownColor: const Color(0xFF1E293B),
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  labelText: 'Filtrar por Línea',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todas las Líneas'),
                  ),
                  ..._catalogService.serviceLines.map(
                    (l) => DropdownMenuItem<int?>(
                      value: l.id,
                      child: Text(l.name),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    setState(() => _selectedServiceLineFilter = val),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    searchWidget,
                    const SizedBox(height: 12),
                    dropdownWidget,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 2, child: searchWidget),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: dropdownWidget),
                ],
              );
            },
          ),
        ),

        // Lista de partidas
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: const Color(0xFF64748B).withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No se encontraron partidas con los filtros seleccionados',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCatalogItemCard(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCatalogItemCard(CrmCatalogItem item) {
    final line = _catalogService.serviceLines.cast<CrmServiceLine?>().firstWhere(
          (l) => l?.id == item.serviceLineId,
          orElse: () => null,
        );

    final calcBadge = _getCalcBadge(item.calculationType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.isActive
              ? const Color(0xFF334155)
              : const Color(0xFFEF4444).withValues(alpha: 0.4),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;
          final infoWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.code,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  if (line != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        line.name,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  calcBadge,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'v${item.version}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA78BFA),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.concept,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (item.metadata != null && item.metadata!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Parámetros: ${item.metadata}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          );

          final priceAndActionsWidget = Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Bs. ${item.basePrice.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'por ${item.unitType}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Tarifas Diferenciadas por Rubro',
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    onPressed: () => _showScopesDialog(item),
                  ),
                  IconButton(
                    tooltip: 'Editar partida',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    onPressed: () => _showCatalogItemDialog(item: item),
                  ),
                  IconButton(
                    tooltip: 'Eliminar partida',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    onPressed: () => _confirmDeleteItem(item),
                  ),
                ],
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoWidget,
                const SizedBox(height: 12),
                priceAndActionsWidget,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: infoWidget),
              const SizedBox(width: 16),
              priceAndActionsWidget,
            ],
          );
        },
      ),
    );
  }

  Widget _getCalcBadge(String type) {
    Color bg;
    Color fg;
    String label;

    switch (type) {
      case 'PER_AREA':
        bg = const Color(0xFF0284C7).withValues(alpha: 0.15);
        fg = const Color(0xFF38BDF8);
        label = 'Área (m²)';
        break;
      case 'PER_POSITION':
        bg = const Color(0xFF10B981).withValues(alpha: 0.15);
        fg = const Color(0xFF34D399);
        label = 'Puesto Operativo';
        break;
      case 'PER_HOUR':
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        fg = const Color(0xFFFBBF24);
        label = 'Por Hora';
        break;
      case 'PER_UNIT':
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
        fg = const Color(0xFFA78BFA);
        label = 'Por Unidad';
        break;
      case 'FIXED':
        bg = const Color(0xFF64748B).withValues(alpha: 0.15);
        fg = const Color(0xFF94A3B8);
        label = 'Tarifa Fija';
        break;
      default:
        bg = const Color(0xFF64748B).withValues(alpha: 0.15);
        fg = const Color(0xFF94A3B8);
        label = type;
    }

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

  // ===========================================================================
  // TAB 2: SECTORES / RUBROS
  // ===========================================================================

  Widget _buildSectorsTab() {
    final sectors = _catalogService.sectors;

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: sectors.length,
      itemBuilder: (context, index) {
        final sector = sectors[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: sector.isActive
                  ? const Color(0xFF334155)
                  : const Color(0xFFEF4444).withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: const Icon(
                  Icons.domain_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          sector.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            sector.code,
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (sector.description != null &&
                        sector.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sector.description!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar Rubro',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                onPressed: () => _showSectorDialog(sector: sector),
              ),
              IconButton(
                tooltip: 'Eliminar Rubro',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                onPressed: () => _confirmDeleteSector(sector),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // TAB 3: LÍNEAS DE SERVICIO
  // ===========================================================================

  Widget _buildServiceLinesTab() {
    final lines = _catalogService.serviceLines;

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: line.isActive
                  ? const Color(0xFF334155)
                  : const Color(0xFFEF4444).withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: const Icon(
                  Icons.account_tree_outlined,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          line.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            line.code,
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Text(
                            line.category,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (line.description != null &&
                        line.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        line.description!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar Línea',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                onPressed: () => _showServiceLineDialog(line: line),
              ),
              IconButton(
                tooltip: 'Eliminar Línea',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                onPressed: () => _confirmDeleteServiceLine(line),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // DIÁLOGOS Y MODALES
  // ===========================================================================

  /// Diálogo para Crear / Editar Partida de Catálogo
  void _showCatalogItemDialog({CrmCatalogItem? item}) {
    final isEditing = item != null;
    final codeCtrl = TextEditingController(text: item?.code ?? '');
    final conceptCtrl = TextEditingController(text: item?.concept ?? '');
    final categoryCtrl = TextEditingController(
      text: item?.category ?? 'Limpieza y Mantenimiento',
    );
    final priceCtrl = TextEditingController(
      text: item != null ? item.basePrice.toString() : '',
    );
    final unitCtrl = TextEditingController(text: item?.unitType ?? 'm²');
    final minQtyCtrl = TextEditingController(
      text: (item?.minQuantity ?? 1).toString(),
    );

    // Campos de metadata para PER_POSITION
    String calcType = item?.calculationType ?? 'PER_AREA';
    final hoursShiftCtrl = TextEditingController(text: '12');
    final daysMonthCtrl = TextEditingController(text: '26');

    if (item?.metadata != null && item!.metadata!.isNotEmpty) {
      try {
        final decoded = jsonDecode(item.metadata!) as Map<String, dynamic>;
        if (decoded['hoursPerShift'] != null) {
          hoursShiftCtrl.text = decoded['hoursPerShift'].toString();
        }
        if (decoded['daysPerMonth'] != null) {
          daysMonthCtrl.text = decoded['daysPerMonth'].toString();
        }
      } catch (_) {}
    }

    int? selectedLineId = item?.serviceLineId ??
        (_catalogService.serviceLines.isNotEmpty
            ? _catalogService.serviceLines.first.id
            : null);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: Text(
                isEditing ? 'Editar Partida de Catálogo' : 'Nueva Partida',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Código y Línea
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: codeCtrl,
                              enabled: !isEditing, // Inmutable al editar
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Código Único (ej. LIMP-01)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              initialValue: selectedLineId,
                              dropdownColor: const Color(0xFF1E293B),
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Línea de Servicio'),
                              items: _catalogService.serviceLines.map((l) {
                                return DropdownMenuItem<int?>(
                                  value: l.id,
                                  child: Text(l.name),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setDialogState(() => selectedLineId = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Concepto
                      TextField(
                        controller: conceptCtrl,
                        style: GoogleFonts.inter(color: Colors.white),
                        decoration: _inputDeco('Concepto del Servicio'),
                      ),
                      const SizedBox(height: 12),

                      // Tipo de cálculo y Unidad
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: calcType,
                              dropdownColor: const Color(0xFF1E293B),
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Fórmula / Regla'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'PER_AREA',
                                  child: Text('Por Área (m²)'),
                                ),
                                DropdownMenuItem(
                                  value: 'PER_POSITION',
                                  child: Text('Por Puesto Operativo'),
                                ),
                                DropdownMenuItem(
                                  value: 'PER_HOUR',
                                  child: Text('Por Hora de Trabajo'),
                                ),
                                DropdownMenuItem(
                                  value: 'PER_UNIT',
                                  child: Text('Por Unidad'),
                                ),
                                DropdownMenuItem(
                                  value: 'FIXED',
                                  child: Text('Tarifa Fija'),
                                ),
                                DropdownMenuItem(
                                  value: 'GLOBAL',
                                  child: Text('Global'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    calcType = val;
                                    if (val == 'PER_AREA') unitCtrl.text = 'm²';
                                    if (val == 'PER_POSITION') unitCtrl.text = 'puesto';
                                    if (val == 'PER_HOUR') unitCtrl.text = 'hora';
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: unitCtrl,
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Unidad (m², puesto, etc)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Precio Base y Cantidad Mínima
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceCtrl,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Precio Base (Bs.)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: minQtyCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(color: Colors.white),
                              decoration: _inputDeco('Cantidad Mínima'),
                            ),
                          ),
                        ],
                      ),

                      // Campos dinámicos si es PER_POSITION
                      if (calcType == 'PER_POSITION') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parámetros del Puesto Operativo',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: hoursShiftCtrl,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.inter(color: Colors.white),
                                      decoration: _inputDeco('Horas/Turno (ej. 12)'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: daysMonthCtrl,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.inter(color: Colors.white),
                                      decoration: _inputDeco('Días/Mes (ej. 26)'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final cleanCode = codeCtrl.text.trim();
                    final cleanConcept = conceptCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text) ?? 0.0;
                    final minQty = double.tryParse(minQtyCtrl.text) ?? 1.0;

                    if (cleanCode.isEmpty || cleanConcept.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Complete todos los campos requeridos con valores válidos.'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                      return;
                    }

                    String? metadata;
                    if (calcType == 'PER_POSITION') {
                      final h = int.tryParse(hoursShiftCtrl.text) ?? 12;
                      final d = int.tryParse(daysMonthCtrl.text) ?? 26;
                      metadata = jsonEncode({'hoursPerShift': h, 'daysPerMonth': d});
                    }

                    try {
                      if (isEditing) {
                        final toUpdate = item.copyWith(
                          concept: cleanConcept,
                          category: categoryCtrl.text.trim(),
                          calculationType: calcType,
                          unitType: unitCtrl.text.trim(),
                          basePrice: price,
                          minQuantity: minQty,
                          metadata: metadata,
                          serviceLineId: selectedLineId ?? item.serviceLineId,
                        );
                        await _catalogService.updateCatalogItem(toUpdate);
                      } else {
                        final toCreate = CrmCatalogItem(
                          code: cleanCode,
                          serviceLineId: selectedLineId ?? 1,
                          concept: cleanConcept,
                          category: categoryCtrl.text.trim(),
                          calculationType: calcType,
                          unitType: unitCtrl.text.trim(),
                          basePrice: price,
                          minQuantity: minQty,
                          metadata: metadata,
                          isActive: true,
                          version: 1,
                          createdAt: DateTime.now().toUtc(),
                          updatedAt: DateTime.now().toUtc(),
                          isDeleted: false,
                        );
                        await _catalogService.createCatalogItem(toCreate);
                      }
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) setState(() {});
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isEditing ? 'Guardar Cambios' : 'Crear Partida'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Diálogo para Precios Diferenciados por Rubro (Scopes)
  void _showScopesDialog(CrmCatalogItem item) async {
    final scopes = await _catalogService.loadScopesForItem(item.id!);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarifas por Rubro',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.concept,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'Precio Base: Bs. ${item.basePrice.toStringAsFixed(2)} / ${item.unitType}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _catalogService.sectors.map((sector) {
                      final existingScope = scopes.cast<CrmCatalogItemScope?>().firstWhere(
                            (s) => s?.sectorId == sector.id,
                            orElse: () => null,
                          );

                      final priceCtrl = TextEditingController(
                        text: existingScope?.priceOverride != null
                            ? existingScope!.priceOverride.toString()
                            : '',
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: existingScope != null
                                ? const Color(0xFF10B981).withValues(alpha: 0.5)
                                : const Color(0xFF334155),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sector.name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    sector.code,
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 11,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: priceCtrl,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: GoogleFonts.inter(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Bs. Base (${item.basePrice.toStringAsFixed(2)})',
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF1E293B),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final text = priceCtrl.text.trim();
                                final price = text.isEmpty ? null : double.tryParse(text);

                                final newScope = CrmCatalogItemScope(
                                  id: existingScope?.id,
                                  catalogItemId: item.id!,
                                  sectorId: sector.id!,
                                  priceOverride: price,
                                  isActive: true,
                                  createdAt: DateTime.now().toUtc(),
                                  updatedAt: DateTime.now().toUtc(),
                                  isDeleted: false,
                                );

                                await _catalogService.setCatalogItemScope(newScope);
                                final reloaded =
                                    await _catalogService.loadScopesForItem(item.id!);
                                setDialogState(() {
                                  scopes.clear();
                                  scopes.addAll(reloaded);
                                });

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Tarifa guardada para ${sector.name}',
                                      ),
                                      backgroundColor: const Color(0xFF10B981),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Diálogo para Crear / Editar Sector / Rubro
  void _showSectorDialog({CrmSector? sector}) {
    final isEditing = sector != null;
    final codeCtrl = TextEditingController(text: sector?.code ?? '');
    final nameCtrl = TextEditingController(text: sector?.name ?? '');
    final descCtrl = TextEditingController(text: sector?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            isEditing ? 'Editar Rubro Industrial' : 'Nuevo Rubro Industrial',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  enabled: !isEditing,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Código (ej. SALUD, BANCA)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Nombre del Rubro'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Descripción del Sector'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final cleanCode = codeCtrl.text.trim();
                final cleanName = nameCtrl.text.trim();
                if (cleanCode.isEmpty || cleanName.isEmpty) return;

                try {
                  if (isEditing) {
                    await _catalogService.updateSector(
                      sector.copyWith(
                        name: cleanName,
                        description: descCtrl.text.trim(),
                      ),
                    );
                  } else {
                    await _catalogService.createSector(
                      CrmSector(
                        code: cleanCode,
                        name: cleanName,
                        description: descCtrl.text.trim(),
                        isActive: true,
                        createdAt: DateTime.now().toUtc(),
                        updatedAt: DateTime.now().toUtc(),
                        isDeleted: false,
                      ),
                    );
                  }
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (mounted) setState(() {});
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$e'),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEditing ? 'Guardar' : 'Crear'),
            ),
          ],
        );
      },
    );
  }

  /// Diálogo para Crear / Editar Línea de Servicio
  void _showServiceLineDialog({CrmServiceLine? line}) {
    final isEditing = line != null;
    final codeCtrl = TextEditingController(text: line?.code ?? '');
    final nameCtrl = TextEditingController(text: line?.name ?? '');
    final catCtrl = TextEditingController(text: line?.category ?? 'General');
    final descCtrl = TextEditingController(text: line?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            isEditing ? 'Editar Línea de Servicio' : 'Nueva Línea de Servicio',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  enabled: !isEditing,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Código (ej. LIMPIEZA, SEGURIDAD)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Nombre de la Línea'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: catCtrl,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Categoría'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _inputDeco('Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final cleanCode = codeCtrl.text.trim();
                final cleanName = nameCtrl.text.trim();
                if (cleanCode.isEmpty || cleanName.isEmpty) return;

                try {
                  if (isEditing) {
                    await _catalogService.updateServiceLine(
                      line.copyWith(
                        name: cleanName,
                        category: catCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                      ),
                    );
                  } else {
                    await _catalogService.createServiceLine(
                      CrmServiceLine(
                        code: cleanCode,
                        name: cleanName,
                        category: catCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        isActive: true,
                        createdAt: DateTime.now().toUtc(),
                        updatedAt: DateTime.now().toUtc(),
                        isDeleted: false,
                      ),
                    );
                  }
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (mounted) setState(() {});
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$e'),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEditing ? 'Guardar' : 'Crear'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteItem(CrmCatalogItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Eliminar Partida', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Desea dar de baja "${item.concept}"? Las cotizaciones históricas conservarán su snapshot.',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              await _catalogService.deleteCatalogItem(item.id!);
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) setState(() {});
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSector(CrmSector sector) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Eliminar Rubro', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Desea dar de baja el rubro "${sector.name}"? Los precios diferenciados asociados se desactivarán lógicamente.',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              await _catalogService.deleteSector(sector.id!);
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) setState(() {});
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteServiceLine(CrmServiceLine line) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Eliminar Línea', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Desea dar de baja la línea "${line.name}"?',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              await _catalogService.deleteServiceLine(line.id!);
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) setState(() {});
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
