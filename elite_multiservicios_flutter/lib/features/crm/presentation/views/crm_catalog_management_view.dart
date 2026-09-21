import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/crm_catalog_service.dart';

/// Vista de Administración del Catálogo de Servicios, Rubros Industriales,
/// Líneas de Servicio y Tarifario Maestro con Precios Diferenciados (Scopes).
/// Diseñada bajo la misma identidad visual, tokens cromáticos (#111C30, #10B981, #090D16)
/// y directrices de diseño suizo enterprise que el resto de submódulos CRM.
class CrmCatalogManagementView extends StatefulWidget {
  const CrmCatalogManagementView({super.key});

  @override
  State<CrmCatalogManagementView> createState() =>
      _CrmCatalogManagementViewState();
}

class _CrmCatalogManagementViewState extends State<CrmCatalogManagementView> {
  final CrmCatalogService _catalogService = CrmCatalogService.instance;

  int _selectedTabIndex = 0;
  String _searchQuery = '';
  int? _selectedServiceLineFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _catalogService.loadAll();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _catalogService,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, rootConstraints) {
            final isMobile = rootConstraints.maxWidth < 720;
            final isTablet = rootConstraints.maxWidth < 1080;
            final hPad = isMobile ? 14.0 : 24.0;
            final vPad = isMobile ? 16.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Cabecera Ejecutiva & Botones de Acción
                  _buildHeader(isDark, isMobile),
                  const SizedBox(height: 14),

                  if (_catalogService.isLoading) ...[
                    const LinearProgressIndicator(
                      color: Color(0xFF10B981),
                      backgroundColor: Color(0xFFE2E8F0),
                      minHeight: 3,
                    ),
                    const SizedBox(height: 14),
                  ],

                  // 2. Tablero Compacto de KPIs
                  _buildKpiSection(isDark, isMobile, isTablet),
                  const SizedBox(height: 20),

                  // 3. Barra de Navegación de Pestañas (Segmented Bar)
                  _buildTabsBar(isDark, isMobile),
                  const SizedBox(height: 16),

                  // 4. Contenido de la Pestaña Activa
                  if (_selectedTabIndex == 0)
                    _buildItemsTab(isDark, isMobile)
                  else if (_selectedTabIndex == 1)
                    _buildSectorsTab(isDark, isMobile)
                  else
                    _buildServiceLinesTab(isDark, isMobile),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // 1. CABECERA EJECUTIVA
  // ===========================================================================

  Widget _buildHeader(bool isDark, bool isMobile) {
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 13,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'CATÁLOGO MAESTRO & TARIFARIO',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Precios Base & Reglas por Rubro',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Catálogo & Tarifario Maestro',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 20 : 23,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configuración de partidas, fórmulas por m²/puesto/hora y tarifas diferenciadas por rubro industrial.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
            foregroundColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
            side: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleColumn,
          const SizedBox(height: 12),
          actionsWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleColumn),
        const SizedBox(width: 16),
        actionsWidget,
      ],
    );
  }

  String _getCreateButtonLabel() {
    switch (_selectedTabIndex) {
      case 1:
        return 'Nuevo Rubro';
      case 2:
        return 'Nueva Línea';
      default:
        return 'Nueva Partida';
    }
  }

  void _onPrimaryCreateAction() {
    switch (_selectedTabIndex) {
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

  // ===========================================================================
  // 2. TABLERO DE KPIS
  // ===========================================================================

  Widget _buildKpiSection(bool isDark, bool isMobile, bool isTablet) {
    final totalItems = _catalogService.catalogItems.length;
    final totalSectors = _catalogService.sectors.length;
    final totalLines = _catalogService.serviceLines.length;
    final avgPrice = _catalogService.catalogItems.isEmpty
        ? 0.0
        : _catalogService.catalogItems.fold<double>(
                0.0,
                (acc, i) => acc + i.basePrice,
              ) /
              _catalogService.catalogItems.length;

    final kpis = [
      _buildKpiCard(
        title: 'TOTAL PARTIDAS',
        value: '$totalItems',
        subtitle: 'Servicios en tarifario',
        icon: Icons.sell_outlined,
        accentColor: const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'RUBROS INDUSTRIALES',
        value: '$totalSectors',
        subtitle: 'Sectores con tarifas',
        icon: Icons.domain_rounded,
        accentColor: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'LÍNEAS DE SERVICIO',
        value: '$totalLines',
        subtitle: 'Familias operativas',
        icon: Icons.account_tree_outlined,
        accentColor: const Color(0xFF8B5CF6),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'TARIFA BASE MEDIA',
        value: 'Bs. ${avgPrice.toStringAsFixed(0)}',
        subtitle: 'Promedio general catálogo',
        icon: Icons.monetization_on_outlined,
        accentColor: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: kpis[0]),
              const SizedBox(width: 10),
              Expanded(child: kpis[1]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: kpis[2]),
              const SizedBox(width: 10),
              Expanded(child: kpis[3]),
            ],
          ),
        ],
      );
    } else if (isTablet) {
      return Row(
        children: [
          Expanded(child: kpis[0]),
          const SizedBox(width: 12),
          Expanded(child: kpis[1]),
          const SizedBox(width: 12),
          Expanded(child: kpis[2]),
          const SizedBox(width: 12),
          Expanded(child: kpis[3]),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: kpis[0]),
        const SizedBox(width: 14),
        Expanded(child: kpis[1]),
        const SizedBox(width: 14),
        Expanded(child: kpis[2]),
        const SizedBox(width: 14),
        Expanded(child: kpis[3]),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
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
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. BARRA DE PESTAÑAS (SEGMENTED BAR)
  // ===========================================================================

  Widget _buildTabsBar(bool isDark, bool isMobile) {
    final tabs = [
      (
        icon: Icons.sell_outlined,
        label: 'Partidas de Servicio',
        count: _catalogService.catalogItems.length,
      ),
      (
        icon: Icons.domain_rounded,
        label: 'Rubros Industriales',
        count: _catalogService.sectors.length,
      ),
      (
        icon: Icons.account_tree_outlined,
        label: 'Líneas de Servicio',
        count: _catalogService.serviceLines.length,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: isMobile
          ? Column(
              children: tabs.asMap().entries.map((entry) {
                final idx = entry.key;
                final t = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildTabButton(
                    idx: idx,
                    icon: t.icon,
                    label: t.label,
                    count: t.count,
                    isDark: isDark,
                  ),
                );
              }).toList(),
            )
          : Row(
              children: tabs.asMap().entries.map((entry) {
                final idx = entry.key;
                final t = entry.value;
                return Expanded(
                  child: _buildTabButton(
                    idx: idx,
                    icon: t.icon,
                    label: t.label,
                    count: t.count,
                    isDark: isDark,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildTabButton({
    required int idx,
    required IconData icon,
    required String label,
    required int count,
    required bool isDark,
  }) {
    final isSelected = _selectedTabIndex == idx;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = idx),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF161F30) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.35),
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.04,
                      ),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? const Color(0xFF10B981)
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B)),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : (isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 4. TAB 1: PARTIDAS DE SERVICIO (TARIFARIO)
  // ===========================================================================

  Widget _buildItemsTab(bool isDark, bool isMobile) {
    final items = _catalogService.catalogItems.where((item) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match =
            item.concept.toLowerCase().contains(q) ||
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de Filtros
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111C30) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: isMobile
              ? Column(
                  children: [
                    _buildSearchField(isDark),
                    const SizedBox(height: 10),
                    _buildServiceLineDropdown(isDark),
                  ],
                )
              : Row(
                  children: [
                    Expanded(flex: 3, child: _buildSearchField(isDark)),
                    const SizedBox(width: 14),
                    Expanded(flex: 2, child: _buildServiceLineDropdown(isDark)),
                  ],
                ),
        ),
        const SizedBox(height: 16),

        // Lista de Partidas
        if (items.isEmpty)
          _buildEmptyState(
            isDark: isDark,
            icon: Icons.inventory_2_outlined,
            title: 'No se encontraron partidas',
            description:
                'No hay partidas que coincidan con los filtros de búsqueda.',
          )
        else
          Column(
            children: items
                .map((item) => _buildCatalogItemCard(item, isDark))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildSearchField(bool isDark) {
    return TextField(
      style: GoogleFonts.inter(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por concepto o código (ej. CCTV, Guardia)...',
        hintStyle: GoogleFonts.inter(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontSize: 12.5,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: Color(0xFF64748B),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF10B981)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
      ),
      onChanged: (val) => setState(() => _searchQuery = val.trim()),
    );
  }

  Widget _buildServiceLineDropdown(bool isDark) {
    return DropdownButtonFormField<int?>(
      isExpanded: true,
      initialValue: _selectedServiceLineFilter,
      dropdownColor: isDark ? const Color(0xFF111C30) : Colors.white,
      style: GoogleFonts.inter(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontSize: 13,
      ),
      isDense: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        labelText: 'Filtrar por Línea de Servicio',
        labelStyle: GoogleFonts.inter(
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
          ),
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
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Todas las Líneas', overflow: TextOverflow.ellipsis),
        ),
        ..._catalogService.serviceLines.map(
          (l) => DropdownMenuItem<int?>(
            value: l.id,
            child: Text(l.name, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: (val) => setState(() => _selectedServiceLineFilter = val),
    );
  }

  Widget _buildCatalogItemCard(CrmCatalogItem item, bool isDark) {
    final line = _catalogService.serviceLines
        .cast<CrmServiceLine?>()
        .firstWhere(
          (l) => l?.id == item.serviceLineId,
          orElse: () => null,
        );

    final calcBadge = _getCalcBadge(item.calculationType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isActive
              ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
              : const Color(0xFFEF4444).withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 680;

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
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      item.code,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  if (line != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        line.name,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
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
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                      ),
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
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'por ${item.unitType}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
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
                    onPressed: () => _showScopesDialog(item, isDark),
                  ),
                  IconButton(
                    tooltip: 'Editar partida',
                    icon: Icon(
                      Icons.edit_outlined,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () =>
                        _showCatalogItemDialog(item: item, isDark: isDark),
                  ),
                  IconButton(
                    tooltip: 'Eliminar partida',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    onPressed: () => _confirmDeleteItem(item, isDark),
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
        bg = const Color(0xFF0284C7).withValues(alpha: 0.12);
        fg = const Color(0xFF38BDF8);
        label = 'Área (m²)';
        break;
      case 'PER_POSITION':
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF34D399);
        label = 'Puesto Operativo';
        break;
      case 'PER_HOUR':
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
        fg = const Color(0xFFFBBF24);
        label = 'Por Hora';
        break;
      case 'PER_UNIT':
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.12);
        fg = const Color(0xFFA78BFA);
        label = 'Por Unidad';
        break;
      case 'FIXED':
        bg = const Color(0xFF64748B).withValues(alpha: 0.12);
        fg = const Color(0xFF94A3B8);
        label = 'Tarifa Fija';
        break;
      default:
        bg = const Color(0xFF64748B).withValues(alpha: 0.12);
        fg = const Color(0xFF94A3B8);
        label = type;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. TAB 2: SECTORES / RUBROS
  // ===========================================================================

  Widget _buildSectorsTab(bool isDark, bool isMobile) {
    final sectors = _catalogService.sectors;

    if (sectors.isEmpty) {
      return _buildEmptyState(
        isDark: isDark,
        icon: Icons.domain_rounded,
        title: 'No hay rubros industriales',
        description:
            'Crea el primer rubro industrial para asignar tarifas diferenciadas.',
      );
    }

    return Column(
      children: sectors.map((sector) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111C30) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sector.isActive
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                  : const Color(0xFFEF4444).withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.domain_rounded,
                  color: Color(0xFF10B981),
                  size: 22,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            sector.code,
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar Rubro',
                icon: Icon(
                  Icons.edit_outlined,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () =>
                    _showSectorDialog(sector: sector, isDark: isDark),
              ),
              IconButton(
                tooltip: 'Eliminar Rubro',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                onPressed: () => _confirmDeleteSector(sector, isDark),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // 6. TAB 3: LÍNEAS DE SERVICIO
  // ===========================================================================

  Widget _buildServiceLinesTab(bool isDark, bool isMobile) {
    final lines = _catalogService.serviceLines;

    if (lines.isEmpty) {
      return _buildEmptyState(
        isDark: isDark,
        icon: Icons.account_tree_outlined,
        title: 'No hay líneas de servicio',
        description:
            'Registra una nueva línea operativa para clasificar tus partidas.',
      );
    }

    return Column(
      children: lines.map((line) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111C30) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: line.isActive
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                  : const Color(0xFFEF4444).withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.account_tree_outlined,
                  color: Color(0xFF3B82F6),
                  size: 22,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            line.code,
                            style: GoogleFonts.robotoMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Text(
                            line.category,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
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
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar Línea',
                icon: Icon(
                  Icons.edit_outlined,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () =>
                    _showServiceLineDialog(line: line, isDark: isDark),
              ),
              IconButton(
                tooltip: 'Eliminar Línea',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                onPressed: () => _confirmDeleteServiceLine(line, isDark),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // ESTADO VACÍO (EMPTY STATE)
  // ===========================================================================

  Widget _buildEmptyState({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: const Color(0xFF10B981)),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DIÁLOGOS DE CREACIÓN Y EDICIÓN
  // ===========================================================================

  void _showCatalogItemDialog({CrmCatalogItem? item, bool? isDark}) {
    final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
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

    int? selectedLineId =
        item?.serviceLineId ??
        (_catalogService.serviceLines.isNotEmpty
            ? _catalogService.serviceLines.first.id
            : null);

    showDialog(
      context: context,
      builder: (ctx) {
        final isMobileDialog = MediaQuery.of(ctx).size.width < 560;

        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: dark ? const Color(0xFF111C30) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: dark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              title: Text(
                isEditing
                    ? 'Editar Partida de Catálogo'
                    : 'Nueva Partida de Catálogo',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: dark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMobileDialog) ...[
                        TextField(
                          controller: codeCtrl,
                          enabled: !isEditing,
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco(
                            'Código Único (ej. LIMP-01)',
                            dark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int?>(
                          isExpanded: true,
                          initialValue: selectedLineId,
                          dropdownColor: dark
                              ? const Color(0xFF111C30)
                              : Colors.white,
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco('Línea de Servicio', dark),
                          items: _catalogService.serviceLines.map((l) {
                            return DropdownMenuItem<int?>(
                              value: l.id,
                              child: Text(
                                l.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setDialogState(() => selectedLineId = val),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: codeCtrl,
                                enabled: !isEditing,
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco(
                                  'Código Único (ej. LIMP-01)',
                                  dark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int?>(
                                isExpanded: true,
                                initialValue: selectedLineId,
                                dropdownColor: dark
                                    ? const Color(0xFF111C30)
                                    : Colors.white,
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco(
                                  'Línea de Servicio',
                                  dark,
                                ),
                                items: _catalogService.serviceLines.map((l) {
                                  return DropdownMenuItem<int?>(
                                    value: l.id,
                                    child: Text(
                                      l.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setDialogState(() => selectedLineId = val),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextField(
                        controller: conceptCtrl,
                        style: GoogleFonts.inter(
                          color: dark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: _inputDeco('Concepto del Servicio', dark),
                      ),
                      const SizedBox(height: 12),
                      if (isMobileDialog) ...[
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: calcType,
                          dropdownColor: dark
                              ? const Color(0xFF111C30)
                              : Colors.white,
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco('Fórmula / Regla', dark),
                          items: const [
                            DropdownMenuItem(
                              value: 'PER_AREA',
                              child: Text(
                                'Por Área (m²)',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'PER_POSITION',
                              child: Text(
                                'Por Puesto Operativo',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'PER_HOUR',
                              child: Text(
                                'Por Hora de Trabajo',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'PER_UNIT',
                              child: Text(
                                'Por Unidad',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'FIXED',
                              child: Text(
                                'Tarifa Fija',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'GLOBAL',
                              child: Text(
                                'Global',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                calcType = val;
                                if (val == 'PER_AREA') {
                                  unitCtrl.text = 'm²';
                                }
                                if (val == 'PER_POSITION') {
                                  unitCtrl.text = 'puesto';
                                }
                                if (val == 'PER_HOUR') {
                                  unitCtrl.text = 'hora';
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: unitCtrl,
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco(
                            'Unidad (m², puesto, etc)',
                            dark,
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: calcType,
                                dropdownColor: dark
                                    ? const Color(0xFF111C30)
                                    : Colors.white,
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco('Fórmula / Regla', dark),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'PER_AREA',
                                    child: Text(
                                      'Por Área (m²)',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'PER_POSITION',
                                    child: Text(
                                      'Por Puesto Operativo',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'PER_HOUR',
                                    child: Text(
                                      'Por Hora de Trabajo',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'PER_UNIT',
                                    child: Text(
                                      'Por Unidad',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'FIXED',
                                    child: Text(
                                      'Tarifa Fija',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'GLOBAL',
                                    child: Text(
                                      'Global',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() {
                                      calcType = val;
                                      if (val == 'PER_AREA') {
                                        unitCtrl.text = 'm²';
                                      }
                                      if (val == 'PER_POSITION') {
                                        unitCtrl.text = 'puesto';
                                      }
                                      if (val == 'PER_HOUR') {
                                        unitCtrl.text = 'hora';
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: unitCtrl,
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco(
                                  'Unidad (m², puesto, etc)',
                                  dark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (isMobileDialog) ...[
                        TextField(
                          controller: priceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco('Precio Base (Bs.)', dark),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: minQtyCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(
                            color: dark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          decoration: _inputDeco('Cantidad Mínima', dark),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: priceCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco(
                                  'Precio Base (Bs.)',
                                  dark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: minQtyCtrl,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(
                                  color: dark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                decoration: _inputDeco('Cantidad Mínima', dark),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (calcType == 'PER_POSITION') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.3),
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
                              if (isMobileDialog) ...[
                                TextField(
                                  controller: hoursShiftCtrl,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    color: dark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  decoration: _inputDeco(
                                    'Horas/Turno (ej. 12)',
                                    dark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: daysMonthCtrl,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    color: dark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  decoration: _inputDeco(
                                    'Días/Mes (ej. 26)',
                                    dark,
                                  ),
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: hoursShiftCtrl,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.inter(
                                          color: dark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                        decoration: _inputDeco(
                                          'Horas/Turno (ej. 12)',
                                          dark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: daysMonthCtrl,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.inter(
                                          color: dark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                        decoration: _inputDeco(
                                          'Días/Mes (ej. 26)',
                                          dark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      color: dark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final cleanCode = codeCtrl.text.trim();
                    final cleanConcept = conceptCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text) ?? 0.0;
                    final minQty = double.tryParse(minQtyCtrl.text) ?? 1.0;

                    if (cleanCode.isEmpty ||
                        cleanConcept.isEmpty ||
                        price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Complete todos los campos requeridos con valores válidos.',
                          ),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                      return;
                    }

                    String? metadata;
                    if (calcType == 'PER_POSITION') {
                      final h = int.tryParse(hoursShiftCtrl.text) ?? 12;
                      final d = int.tryParse(daysMonthCtrl.text) ?? 26;
                      metadata = jsonEncode({
                        'hoursPerShift': h,
                        'daysPerMonth': d,
                      });
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

  void _showScopesDialog(CrmCatalogItem item, bool isDark) async {
    final scopes = await _catalogService.loadScopesForItem(item.id!);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF111C30) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarifas Diferenciadas por Rubro',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.concept,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Text(
                    'Precio Base Referencial: Bs. ${item.basePrice.toStringAsFixed(2)} / ${item.unitType}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _catalogService.sectors.map((sector) {
                      final existingScope = scopes
                          .cast<CrmCatalogItemScope?>()
                          .firstWhere(
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
                          color: isDark
                              ? const Color(0xFF161F30)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: existingScope != null
                                ? const Color(0xFF10B981).withValues(alpha: 0.5)
                                : (isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0)),
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
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    sector.code,
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 11,
                                      color: const Color(0xFF10B981),
                                      fontWeight: FontWeight.w600,
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Bs. Base (${item.basePrice.toStringAsFixed(2)})',
                                  hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFF64748B),
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? const Color(0xFF111C30)
                                      : Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFCBD5E1),
                                    ),
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
                                final price = text.isEmpty
                                    ? null
                                    : double.tryParse(text);

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

                                await _catalogService.setCatalogItemScope(
                                  newScope,
                                );
                                final reloaded = await _catalogService
                                    .loadScopesForItem(item.id!);
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
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
                  child: Text(
                    'Cerrar',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSectorDialog({CrmSector? sector, bool? isDark}) {
    final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final isEditing = sector != null;
    final codeCtrl = TextEditingController(text: sector?.code ?? '');
    final nameCtrl = TextEditingController(text: sector?.name ?? '');
    final descCtrl = TextEditingController(text: sector?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF111C30) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          title: Text(
            isEditing ? 'Editar Rubro Industrial' : 'Nuevo Rubro Industrial',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: dark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  enabled: !isEditing,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Código (ej. SALUD, BANCA)', dark),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Nombre del Rubro', dark),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Descripción del Sector', dark),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  color: dark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
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

  void _showServiceLineDialog({CrmServiceLine? line, bool? isDark}) {
    final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final isEditing = line != null;
    final codeCtrl = TextEditingController(text: line?.code ?? '');
    final nameCtrl = TextEditingController(text: line?.name ?? '');
    final catCtrl = TextEditingController(text: line?.category ?? 'General');
    final descCtrl = TextEditingController(text: line?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF111C30) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          title: Text(
            isEditing ? 'Editar Línea de Servicio' : 'Nueva Línea de Servicio',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: dark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  enabled: !isEditing,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco(
                    'Código (ej. LIMPIEZA, SEGURIDAD)',
                    dark,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Nombre de la Línea', dark),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: catCtrl,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Categoría', dark),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDeco('Descripción', dark),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  color: dark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
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

  void _confirmDeleteItem(CrmCatalogItem item, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111C30) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Text(
          'Eliminar Partida',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          '¿Desea dar de baja "${item.concept}"? Las cotizaciones históricas conservarán su snapshot.',
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
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

  void _confirmDeleteSector(CrmSector sector, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111C30) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Text(
          'Eliminar Rubro',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          '¿Desea dar de baja el rubro "${sector.name}"? Los precios diferenciados asociados se desactivarán lógicamente.',
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
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

  void _confirmDeleteServiceLine(CrmServiceLine line, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111C30) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Text(
          'Eliminar Línea',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          '¿Desea dar de baja la línea "${line.name}"?',
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
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

  InputDecoration _inputDeco(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        fontSize: 12.5,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
