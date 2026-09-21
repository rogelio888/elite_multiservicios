import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/crm_leads_service.dart';
import '../../data/crm_agenda_service.dart';
import '../../data/crm_catalog_service.dart';
import '../../data/crm_pipeline_service.dart';
import '../views/crm_pipeline_view.dart' show OpportunityItem;
import '../../../security/services/auth_service.dart';

/// Vista ejecutiva y operativa del submódulo de Prospectos (Outbound / Maps / Directorios).
/// Diseñada bajo directrices de diseño suizo enterprise, sin datos hardcodeados y con flujo de conversión a Pipeline.
class CrmLeadsView extends StatefulWidget {
  const CrmLeadsView({super.key});

  @override
  State<CrmLeadsView> createState() => _CrmLeadsViewState();
}

class _CrmLeadsViewState extends State<CrmLeadsView> {
  final CrmLeadsService _leadsService = CrmLeadsService();
  final CrmAgendaService _agendaService = CrmAgendaService();

  String _searchQuery = '';
  String _selectedSector = 'Todos';
  String _selectedAdvisor = 'Todos';
  String _selectedStatus = 'Todos';
  bool _isTableView =
      false; // Alternar entre Vista Mosaico Enterprise y Vista Hoja de Cálculo

  final List<String> _sectors = const [
    'Todos',
    'Clínicas y centros médicos',
    'Corporativo / Oficinas',
    'Colegios & Educación',
    'Banca & Finanzas',
    'Industria & Bodegas',
  ];

  final List<String> _advisors = const [
    'Todos',
    'Rodrigo Acha',
    'Vanessa Requejo',
    'Sara',
    'Juan',
    'Paola',
  ];

  final List<String> _statuses = const [
    'Todos',
    'Prospectado',
    'Contactado',
    'En Espera de Respuesta',
    'Interesado (Calificado)',
    'Descartado',
  ];

  List<String> get _dynamicSectors {
    final catalogSectors = CrmCatalogService.instance.sectors
        .map((s) => s.name)
        .toList();
    if (catalogSectors.isNotEmpty) {
      return ['Todos', ...catalogSectors];
    }
    return _sectors;
  }

  @override
  void initState() {
    super.initState();
    _leadsService.loadLeads();
    CrmCatalogService.instance.loadSectors();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<LeadModel>>(
      valueListenable: _leadsService.leadsNotifier,
      builder: (context, leads, _) {
        final filtered = _getFilteredLeads(leads);

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
                  // 1. Cabecera Ejecutiva & Botón de Acción Principal
                  _buildHeader(isDark, isMobile),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<bool>(
                    valueListenable: _leadsService.isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      if (!isLoading) return const SizedBox.shrink();
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(
                          color: Color(0xFF10B981),
                          backgroundColor: Color(0xFFE2E8F0),
                          minHeight: 3,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // 2. Tablero de KPIs y Tasa de Conversión Dinámica
                  _buildKpiSection(isDark, isMobile, isTablet),
                  const SizedBox(height: 22),

                  // 3. Barra de Filtros de Rubro (Pills con Contador)
                  _buildSectorChips(isDark, leads),
                  const SizedBox(height: 14),

                  // 4. Barra de Búsqueda, Asesor, Temperatura y Alternador de Vistas
                  _buildFilterToolbar(isDark, isMobile),
                  const SizedBox(height: 18),

                  // 5. Contenido Principal: Grid Fluido sin Overflow o Tabla de Alta Densidad
                  if (filtered.isEmpty)
                    _buildEmptyState(isDark)
                  else if (_isTableView)
                    _buildTableView(filtered, isDark)
                  else
                    _buildGridView(filtered, isDark, isMobile, isTablet),
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
        Row(
          mainAxisSize: MainAxisSize.min,
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
                  const Icon(Icons.explore, size: 13, color: Color(0xFF10B981)),
                  const SizedBox(width: 5),
                  Text(
                    'PROSPECCIÓN OUTBOUND & MAPS',
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
            const SizedBox(width: 8),
            Text(
              'Directorio de Oportunidades en Frío',
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
          'Prospectos & Nuevos Negocios',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 20 : 23,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Base comercial viva con geolocalización, seguimiento de contacto y conversión directa a Oportunidad.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final newLeadButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        elevation: 0,
      ),
      onPressed: _showNewLeadDialog,
      icon: const Icon(Icons.person_add_alt_1, size: 18),
      label: Text(
        'Nuevo Prospecto',
        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleColumn,
          const SizedBox(height: 12),
          newLeadButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleColumn),
        const SizedBox(width: 16),
        newLeadButton,
      ],
    );
  }

  // ===========================================================================
  // 2. TABLERO DE KPIS CON TASA DE EFECTIVIDAD
  // ===========================================================================

  Widget _buildKpiSection(bool isDark, bool isMobile, bool isTablet) {
    final total = _leadsService.totalCount;
    final contactados = _leadsService.contactedCount;
    final enEspera = _leadsService.waitingCount;
    final calificados = _leadsService.qualifiedCount;
    final convRate = _leadsService.conversionRate;

    final kpis = [
      _buildKpiCard(
        title: 'TOTAL PROSPECTOS',
        value: '$total',
        subtitle: 'Cuentas en seguimiento',
        icon: Icons.contacts_outlined,
        accentColor: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'CONTACTADOS',
        value: '$contactados',
        subtitle: 'Primer contacto realizado',
        icon: Icons.phone_forwarded,
        accentColor: const Color(0xFF6366F1),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'EN ESPERA',
        value: '$enEspera',
        subtitle: 'Pendientes de respuesta',
        icon: Icons.hourglass_top,
        accentColor: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
      _buildKpiCard(
        title: 'CALIFICADOS (INTERÉS)',
        value: '$calificados',
        subtitle: '${convRate.toStringAsFixed(1)}% tasa de éxito',
        icon: Icons.verified,
        accentColor: const Color(0xFF10B981),
        badgeText: '$calificados calificados',
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
    String? badgeText,
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
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              Icon(icon, size: 17, color: accentColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    badgeText,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
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
  // 3. BARRA DE FILTROS POR RUBRO CON CONTADORES
  // ===========================================================================

  Widget _buildSectorChips(bool isDark, List<LeadModel> allLeads) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _dynamicSectors.map((sec) {
          final isSelected = _selectedSector == sec;
          final count = sec == 'Todos'
              ? allLeads.length
              : allLeads
                    .where(
                      (l) => l.sector.toLowerCase().contains(
                        sec.toLowerCase().split(' ')[0],
                      ),
                    )
                    .length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedSector = sec),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : (isDark ? const Color(0xFF111C30) : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : (isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sec,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF475569)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
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
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // 4. BARRA DE BÚSQUEDA Y FILTROS AVANZADOS
  // ===========================================================================

  Widget _buildFilterToolbar(bool isDark, bool isMobile) {
    final searchField = TextField(
      onChanged: (val) => setState(() => _searchQuery = val),
      style: GoogleFonts.inter(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Buscar por empresa, contacto, dirección, teléfono...',
        hintStyle: GoogleFonts.inter(
          fontSize: 12.5,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
        prefixIcon: const Icon(Icons.search, size: 18),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );

    final advisorDropdown = DropdownButtonFormField<String>(
      key: ValueKey('advisor_$_selectedAdvisor'),
      initialValue: _selectedAdvisor,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Asesor', isDense: true),
      items: _advisors
          .map(
            (adv) => DropdownMenuItem(
              value: adv,
              child: Text(adv, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val != null) setState(() => _selectedAdvisor = val);
      },
    );

    final statusDropdown = DropdownButtonFormField<String>(
      key: ValueKey('status_$_selectedStatus'),
      initialValue: _selectedStatus,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Estado', isDense: true),
      items: _statuses
          .map(
            (st) => DropdownMenuItem(
              value: st,
              child: Text(st, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val != null) setState(() => _selectedStatus = val);
      },
    );

    final viewToggle = Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.grid_view_rounded,
              size: 18,
              color: !_isTableView
                  ? const Color(0xFF10B981)
                  : const Color(0xFF64748B),
            ),
            tooltip: 'Vista Mosaico',
            onPressed: () => setState(() => _isTableView = false),
          ),
          IconButton(
            icon: Icon(
              Icons.table_rows_rounded,
              size: 18,
              color: _isTableView
                  ? const Color(0xFF10B981)
                  : const Color(0xFF64748B),
            ),
            tooltip: 'Vista Hoja de Cálculo',
            onPressed: () => setState(() => _isTableView = true),
          ),
        ],
      ),
    );

    return Container(
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
                searchField,
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: advisorDropdown),
                    const SizedBox(width: 8),
                    Expanded(child: statusDropdown),
                    const SizedBox(width: 8),
                    viewToggle,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: searchField),
                const SizedBox(width: 12),
                SizedBox(width: 160, child: advisorDropdown),
                const SizedBox(width: 12),
                SizedBox(width: 200, child: statusDropdown),
                const SizedBox(width: 12),
                viewToggle,
              ],
            ),
    );
  }

  // ===========================================================================
  // 5. VISTA EN CUADRÍCULA FLUIDA (SIN OVERFLOW)
  // ===========================================================================

  Widget _buildGridView(
    List<LeadModel> filtered,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtered.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, idx) => _buildLeadCard(filtered[idx], isDark),
      );
    }

    // Grid adaptable de 2 columnas en Desktop con Wrap o Column de pares para evitar el bug de mainAxisExtent
    final List<Widget> rows = [];
    for (int i = 0; i < filtered.length; i += 2) {
      final item1 = filtered[i];
      final item2 = (i + 1 < filtered.length) ? filtered[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLeadCard(item1, isDark)),
              const SizedBox(width: 14),
              if (item2 != null)
                Expanded(child: _buildLeadCard(item2, isDark))
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  // ===========================================================================
  // 6. TARJETA INDIVIDUAL DE PROSPECTO (ENTERPRISE UI)
  // ===========================================================================

  Widget _buildLeadCard(LeadModel item, bool isDark) {
    final statusColor = _getStatusColor(item.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isPromoted
              ? const Color(0xFF10B981).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          width: item.isPromoted ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Avatar de la Empresa + Nombre + Temperatura + Estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar con iniciales
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _getSectorColor(item.sector).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _getSectorColor(item.sector).withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    item.company.isNotEmpty
                        ? item.company
                              .substring(0, math.min(2, item.company.length))
                              .toUpperCase()
                        : 'PR',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _getSectorColor(item.sector),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Empresa & Asesor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.company,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isPromoted)
                          InkWell(
                            onTap: () => _promoteLeadToOpportunity(item),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.rocket_launch,
                                    size: 11,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'En Pipeline',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.sector,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getSectorColor(item.sector),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.badge_outlined,
                          size: 12,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.advisor,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Fila 2: Decisor / Contacto (Clickable para editar datos reales del encargado)
          InkWell(
            onTap: () => _showContactDetailsUpdateDialog(item),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.contactPerson,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    size: 13,
                    color: Color(0xFFF59E0B),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Fila 3: Dirección en Maps
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 15,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.address,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(item.address, 'Dirección'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.copy, size: 13, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Fila 4: Teléfono con WhatsApp directo & Web
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 15,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Text(
                item.phone,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _copyToClipboard(item.phone, 'Teléfono'),
                child: const Icon(
                  Icons.copy,
                  size: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              if (item.emailOrWeb != null)
                InkWell(
                  onTap: () => _copyToClipboard(
                    item.emailOrWeb!,
                    item.emailOrWeb!.contains('@') ? 'Correo' : 'Enlace Web',
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.emailOrWeb!.contains('@')
                            ? Icons.email_outlined
                            : Icons.link,
                        size: 13,
                        color: const Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.emailOrWeb!.contains('@')
                            ? item.emailOrWeb!
                            : 'Sitio Web',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF8B5CF6),
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Fila 5: Notas de Seguimiento
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                'Nota: ${item.notes!}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Fila 6: Barra de Acciones Operativas (Estado, Agenda y Promover a Oportunidad)
          Row(
            children: [
              // Selector de Estado o Badge Bloqueado si ya está en Pipeline
              if (item.isPromoted)
                Tooltip(
                  message:
                      'Oportunidad activa en Pipeline Comercial. La evolución se gestiona desde Pipeline & Embudo.',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 12,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Calificado (En Pipeline)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                PopupMenuButton<String>(
                  tooltip: item.status == 'Interesado (Calificado)'
                      ? 'Prospecto calificado (Solo promover a Pipeline o Descartar)'
                      : 'Cambiar estado',
                  onSelected: (newSt) {
                    if (newSt == 'Interesado (Calificado)') {
                      _promoteLeadToOpportunity(item);
                    } else if (newSt == 'En Espera de Respuesta') {
                      _showContactDetailsUpdateDialog(item, newStatus: newSt);
                    } else {
                      _leadsService.updateStatus(item.id, newSt);
                    }
                  },
                  itemBuilder: (ctx) {
                    // Si ya está calificado, no permitir degradar hacia atrás a Prospectado/Contactado/En Espera
                    final allowedStatuses =
                        item.status == 'Interesado (Calificado)'
                        ? ['Interesado (Calificado)', 'Descartado']
                        : _statuses.where((s) => s != 'Todos').toList();
                    return allowedStatuses
                        .map(
                          (s) => PopupMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(s),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(s, style: GoogleFonts.inter(fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                        .toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item.status,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 14,
                          color: statusColor,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(width: 8),

              // Botón rápido para actualizar datos de contacto real
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 17),
                tooltip: 'Actualizar contacto directo del encargado',
                color: const Color(0xFFF59E0B),
                visualDensity: VisualDensity.compact,
                onPressed: () => _showContactDetailsUpdateDialog(item),
              ),

              // Botón rápido de llamada / agenda
              IconButton(
                icon: const Icon(Icons.add_task, size: 17),
                tooltip: 'Agendar compromiso / llamada en Agenda CRM',
                color: const Color(0xFF6366F1),
                visualDensity: VisualDensity.compact,
                onPressed: () => _scheduleQuickTask(item),
              ),

              // Botón rápido para promover al Pipeline Comercial (o indicador si ya está en Pipeline)
              if (!item.isPromoted)
                IconButton(
                  icon: const Icon(Icons.rocket_launch, size: 17),
                  tooltip: 'Promover al Pipeline Comercial',
                  color: const Color(0xFF2563EB),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _promoteLeadToOpportunity(item),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Tooltip(
                    message: 'Ya promovido al Pipeline Comercial',
                    child: Icon(
                      Icons.check_circle,
                      size: 17,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. VISTA HOJA DE CÁLCULO (DATA TABLE ENTERPRISE)
  // ===========================================================================

  Widget _buildTableView(List<LeadModel> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF16233B) : const Color(0xFFF8FAFC),
            ),
            dataRowMaxHeight: 56,
            columnSpacing: 22,
            columns: [
              DataColumn(
                label: Text(
                  'EMPRESA / NEGOCIO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUBRO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'TEMPERATURA',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ASESOR',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'CONTACTO / TELÉFONO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ESTADO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ACCIONES',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
            rows: items.map((item) {
              final statusCol = _getStatusColor(item.status);
              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.company,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          item.address,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      item.sector,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getSectorColor(item.sector),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(item.advisor, style: GoogleFonts.inter(fontSize: 12)),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () => _showContactDetailsUpdateDialog(item),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.contactPerson,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 12,
                                  color: Color(0xFFF59E0B),
                                ),
                              ],
                            ),
                            Text(
                              item.phone,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    item.isPromoted
                        ? Tooltip(
                            message:
                                'Oportunidad activa en Pipeline Comercial. La evolución se gestiona desde Pipeline & Embudo.',
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                    size: 11,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'En Pipeline',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : PopupMenuButton<String>(
                            tooltip: item.status == 'Interesado (Calificado)'
                                ? 'Prospecto calificado (Solo promover a Pipeline o Descartar)'
                                : 'Cambiar estado',
                            onSelected: (newSt) {
                              if (newSt == 'Interesado (Calificado)') {
                                _promoteLeadToOpportunity(item);
                              } else if (newSt == 'En Espera de Respuesta') {
                                _showContactDetailsUpdateDialog(
                                  item,
                                  newStatus: newSt,
                                );
                              } else {
                                _leadsService.updateStatus(item.id, newSt);
                              }
                            },
                            itemBuilder: (ctx) {
                              final allowedStatuses =
                                  item.status == 'Interesado (Calificado)'
                                  ? ['Interesado (Calificado)', 'Descartado']
                                  : _statuses
                                        .where((s) => s != 'Todos')
                                        .toList();
                              return allowedStatuses
                                  .map(
                                    (s) => PopupMenuItem(
                                      value: s,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(s),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            s,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusCol.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: statusCol.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.status,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: statusCol,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 14,
                                    color: statusCol,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Color(0xFFF59E0B),
                          ),
                          tooltip: 'Actualizar contacto directo',
                          onPressed: () =>
                              _showContactDetailsUpdateDialog(item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_task,
                            size: 16,
                            color: Color(0xFF6366F1),
                          ),
                          tooltip: 'Agendar Tarea',
                          onPressed: () => _scheduleQuickTask(item),
                        ),
                        if (!item.isPromoted)
                          IconButton(
                            icon: const Icon(
                              Icons.rocket_launch,
                              size: 16,
                              color: Color(0xFF2563EB),
                            ),
                            tooltip: 'Promover a Oportunidad',
                            onPressed: () => _promoteLeadToOpportunity(item),
                          )
                        else
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFF10B981),
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
    );
  }

  // ===========================================================================
  // 8. ACCIONES COMERCIALES & MODALES ENTERPRISE
  // ===========================================================================

  void _promoteLeadToOpportunity(LeadModel item) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final titleCtrl = TextEditingController(
          text: 'Servicio Integral para ${item.company}',
        );
        final contactCtrl = TextEditingController(
          text: item.contactPerson == 'Encargado de Compras / Administración'
              ? ''
              : item.contactPerson,
        );
        final phoneCtrl = TextEditingController(
          text: item.phone,
        );
        final emailCtrl = TextEditingController(
          text: item.emailOrWeb ?? '',
        );
        String serviceType = item.sector.contains('Clínicas')
            ? 'Limpieza Hospitalaria & Bioseguridad'
            : (item.sector.contains('Colegios')
                  ? 'Mantenimiento & Jardinería Educativa'
                  : 'Mantenimiento Corporativo');
        bool scheduleReminder = false;

        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2563EB,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.rocket_launch,
                                color: Color(0xFF2563EB),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Promover Prospecto al Pipeline',
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Convierte este prospecto verificado en una Oportunidad de Negocio activa',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Resumen del Prospecto
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EMPRESA / PROSPECTO: ${item.company}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ubicación / Sede: ${item.address}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Título de la Oportunidad / Negocio *',
                            hintText:
                                'Ej: Servicio de Limpieza y Mantenimiento',
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        DropdownButtonFormField<String>(
                          initialValue: serviceType,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Servicio a Cotizar',
                            isDense: true,
                          ),
                          items:
                              [
                                    'Limpieza Hospitalaria & Bioseguridad',
                                    'Mantenimiento Corporativo',
                                    'Mantenimiento & Jardinería Educativa',
                                    'Seguridad & Vigilancia Física',
                                    'Desinfección & Fumigación Integral',
                                  ]
                                  .map(
                                    (st) => DropdownMenuItem(
                                      value: st,
                                      child: Text(
                                        st,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) serviceType = v;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Campos de contacto real/confirmado
                        TextFormField(
                          controller: contactCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Contacto Clave / Decisor *',
                            hintText:
                                'Ej: Lic. Roberto Gómez - Gerente Administrativo',
                            prefixIcon: Icon(Icons.person_outline, size: 18),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: phoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Teléfono / WhatsApp Directo *',
                                  hintText: 'Ej: 70012345',
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    size: 18,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: emailCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  hintText: 'Ej: contacto@empresa.com',
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Opción de agendar recordatorio manual (desmarcado por defecto)
                        InkWell(
                          onTap: () {
                            setDialogState(() {
                              scheduleReminder = !scheduleReminder;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(
                                      0xFF1E293B,
                                    ).withValues(alpha: 0.5)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: scheduleReminder
                                    ? const Color(0xFF2563EB)
                                    : (isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFE2E8F0)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: scheduleReminder,
                                  activeColor: const Color(0xFF2563EB),
                                  onChanged: (val) {
                                    setDialogState(() {
                                      scheduleReminder = val ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Agendar recordatorio en Agenda CRM (Opcional)',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Desmarcado por defecto. Si no lo marcas, no se creará ninguna tarea.',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final companyName = item.company;
                                final oppTitle =
                                    titleCtrl.text.trim().isNotEmpty
                                    ? titleCtrl.text.trim()
                                    : 'Servicio Integral para $companyName';
                                final confirmedContact =
                                    contactCtrl.text.trim().isNotEmpty
                                    ? contactCtrl.text.trim()
                                    : item.contactPerson;
                                final confirmedPhone =
                                    phoneCtrl.text.trim().isNotEmpty
                                    ? phoneCtrl.text.trim()
                                    : item.phone;
                                final confirmedEmail =
                                    emailCtrl.text.trim().isNotEmpty
                                    ? emailCtrl.text.trim()
                                    : item.emailOrWeb;

                                // 1. Actualizar prospecto en PostgreSQL con los datos reales de contacto
                                final updatedLead = item.copyWith(
                                  contactPerson: confirmedContact,
                                  phone: confirmedPhone,
                                  emailOrWeb: confirmedEmail,
                                );
                                await _leadsService.updateLead(updatedLead);

                                // 2. Registrar Oportunidad en PostgreSQL vía CrmPipelineService
                                final pipelineService = CrmPipelineService();
                                final createdOpp = await pipelineService
                                    .addDeal(
                                      OpportunityItem(
                                        id: '',
                                        title: oppTitle,
                                        clientName: companyName,
                                        contactPerson: confirmedContact,
                                        phone: confirmedPhone,
                                        serviceType: serviceType,
                                        amount: item.estimatedValue > 0
                                            ? item.estimatedValue
                                            : 0.0,
                                        stage: 'Calificación',
                                        probability: 30,
                                        owner: item.advisor,
                                        closingDate: '',
                                        notes: item.notes ?? '',
                                        businessSegment: item.sector,
                                        siteName: companyName,
                                        siteAddress: item.address,
                                        siteContactName: confirmedContact,
                                        siteContactPhone: confirmedPhone,
                                        isSiteHeadquarters: true,
                                      ),
                                    );

                                // 3. Marcar como promovido en el servicio de prospectos vinculando la Oportunidad
                                await _leadsService.markPromoted(
                                  item.id,
                                  opportunityId: createdOpp?.id,
                                );

                                // 4. Agendar tarea en Agenda CRM sólo si el usuario lo solicitó explícitamente
                                if (scheduleReminder) {
                                  await _agendaService.addTask(
                                    CrmTaskItem(
                                      id: 'TSK-${DateTime.now().millisecondsSinceEpoch}',
                                      title:
                                          'Reunión de Calificación: $companyName',
                                      taskType: CrmTaskType.meeting,
                                      clientName: companyName,
                                      contactPerson: confirmedContact,
                                      phone: confirmedPhone,
                                      scheduledAt: DateTime.now().add(
                                        const Duration(days: 1),
                                      ),
                                      scheduledTimeText: '10:00',
                                      priority: 'Alta / Urgente',
                                      status: 'Pendiente',
                                      callContext:
                                          'Prospecto promovido desde Outbound Maps. Requiere propuesta formal.',
                                      createdAt: DateTime.now(),
                                      relatedOpportunityId: createdOpp?.id,
                                    ),
                                  );
                                }

                                if (ctx.mounted) Navigator.pop(ctx);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF065F46),
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '¡Oportunidad "$oppTitle" creada con éxito en el Pipeline!',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Promover al Pipeline'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showContactDetailsUpdateDialog(LeadModel item, {String? newStatus}) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final contactCtrl = TextEditingController(
          text: item.contactPerson == 'Encargado de Compras / Administración'
              ? ''
              : item.contactPerson,
        );
        final phoneCtrl = TextEditingController(text: item.phone);
        final emailCtrl = TextEditingController(text: item.emailOrWeb ?? '');
        final notesCtrl = TextEditingController(text: item.notes ?? '');
        String selectedStatus = newStatus ?? item.status;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person_pin_outlined,
                                color: Color(0xFFF59E0B),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Actualizar Datos de Contacto Directo',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '${item.company} • ${item.sector}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF16233B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Color(0xFF3B82F6),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Si los datos iniciales de Google Maps no tenían el encargado o el número directo, regístralos aquí para mantener la información real.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Campo: Nombre del Encargado / Tomador de decisión
                        TextFormField(
                          controller: contactCtrl,
                          decoration: const InputDecoration(
                            labelText:
                                'Nombre y Cargo del Encargado / Decisor *',
                            hintText:
                                'Ej: Lic. Carlos Mendoza - Administrador General',
                            prefixIcon: Icon(Icons.person_outline, size: 18),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Campo: Teléfono directo o nuevo número proporcionado
                        TextFormField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(
                            labelText:
                                'Teléfono Directo / WhatsApp Confirmado *',
                            hintText: 'Ej: +591 70012345 o (3) 3456789',
                            prefixIcon: Icon(Icons.phone_outlined, size: 18),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Campo: Correo electrónico directo
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico Directo',
                            hintText: 'Ej: carlos.mendoza@empresa.com',
                            prefixIcon: Icon(Icons.email_outlined, size: 18),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Selector de Estado
                        DropdownButtonFormField<String>(
                          initialValue: selectedStatus,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Estado Comercial',
                            isDense: true,
                            prefixIcon: Icon(Icons.flag_outlined, size: 18),
                          ),
                          items: _statuses
                              .where((s) => s != 'Todos')
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    style: GoogleFonts.inter(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setModalState(() => selectedStatus = v);
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Notas de la llamada / interacción
                        TextFormField(
                          controller: notesCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Notas de la Llamada / Contacto',
                            hintText:
                                'Ej: Se llamó y dieron el celular directo del jefe de compras...',
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF59E0B),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final realContact =
                                    contactCtrl.text.trim().isNotEmpty
                                    ? contactCtrl.text.trim()
                                    : item.contactPerson;
                                final realPhone =
                                    phoneCtrl.text.trim().isNotEmpty
                                    ? phoneCtrl.text.trim()
                                    : item.phone;
                                final realEmail =
                                    emailCtrl.text.trim().isNotEmpty
                                    ? emailCtrl.text.trim()
                                    : item.emailOrWeb;
                                final realNotes =
                                    notesCtrl.text.trim().isNotEmpty
                                    ? notesCtrl.text.trim()
                                    : item.notes;

                                final updatedLead = item.copyWith(
                                  contactPerson: realContact,
                                  phone: realPhone,
                                  emailOrWeb: realEmail,
                                  notes: realNotes,
                                  status: selectedStatus,
                                );

                                final messenger = ScaffoldMessenger.of(context);
                                await _leadsService.updateLead(updatedLead);

                                if (ctx.mounted) Navigator.pop(ctx);
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF065F46),
                                    content: Text(
                                      'Datos de contacto y estado actualizados para ${item.company}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.save, size: 16),
                              label: const Text(
                                'Guardar Datos Reales',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _scheduleQuickTask(LeadModel item) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    String taskType = CrmTaskType.call;
    String priority = 'Media';

    final titleCtrl = TextEditingController(
      text: 'Llamar a ${item.contactPerson} (${item.company})',
    );
    final contextCtrl = TextEditingController(
      text:
          'Coordinar visita técnica y presentación de portafolio de servicios.',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final dateText =
                '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
            final timeText =
                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.alarm_add_rounded,
                                color: Color(0xFF6366F1),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Agendar Seguimiento en CRM Agenda',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16.5,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Cuenta: ${item.company} • Tel: ${item.phone}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Título del compromiso / tarea
                        TextFormField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Título del compromiso / tarea *',
                            hintText: 'Ej: Llamar para confirmar cita técnica',
                            prefixIcon: Icon(Icons.title, size: 18),
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Tipo de Acción y Prioridad
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<String>(
                                initialValue: taskType,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de Tarea',
                                  prefixIcon: Icon(Icons.task_alt, size: 18),
                                  isDense: true,
                                ),
                                items: CrmTaskType.all
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          t,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => taskType = v);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: priority,
                                decoration: const InputDecoration(
                                  labelText: 'Prioridad',
                                  isDense: true,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Alta / Urgente',
                                    child: Text('🔴 Alta'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Media',
                                    child: Text('🟡 Media'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Normal',
                                    child: Text('🟢 Normal'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => priority = v);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Fecha y Hora Programada
                        Row(
                          children: [
                            // Selector de Fecha
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 1),
                                    ),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  );
                                  if (picked != null) {
                                    setDialogState(() => selectedDate = picked);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Fecha Programada *',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                    ),
                                    isDense: true,
                                  ),
                                  child: Text(
                                    dateText,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Selector de Hora
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime,
                                  );
                                  if (picked != null) {
                                    setDialogState(() => selectedTime = picked);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Hora Programada *',
                                    prefixIcon: Icon(
                                      Icons.access_time,
                                      size: 18,
                                    ),
                                    isDense: true,
                                  ),
                                  child: Text(
                                    timeText,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Contexto e Instrucciones
                        TextFormField(
                          controller: contextCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText:
                                'Contexto de la llamada / Instrucción para el Asesor *',
                            hintText:
                                'Ej: Llamar a las 16:00 porque el encargado llega a esa hora...',
                            alignLabelWithHint: true,
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final finalTitle =
                                    titleCtrl.text.trim().isNotEmpty
                                    ? titleCtrl.text.trim()
                                    : 'Seguimiento con ${item.company}';

                                final scheduledDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );

                                _agendaService.addTask(
                                  CrmTaskItem(
                                    id: 'TSK-${DateTime.now().millisecondsSinceEpoch}',
                                    title: finalTitle,
                                    taskType: taskType,
                                    clientName: item.company,
                                    contactPerson: item.contactPerson,
                                    phone: item.phone,
                                    scheduledAt: scheduledDateTime,
                                    scheduledTimeText: timeText,
                                    priority: priority,
                                    status: 'Pendiente',
                                    callContext: contextCtrl.text.trim(),
                                    createdAt: DateTime.now(),
                                    customerId: item.id,
                                  ),
                                );

                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF312E81),
                                    content: Text(
                                      'Tarea programada para el $dateText a las $timeText en CRM Agenda.',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.event_available, size: 18),
                              label: const Text('Guardar en Agenda'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewLeadDialog() {
    final companyCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String sectorVal = 'Clínicas y centros médicos';
    final currentAdvisor = AuthService().currentDisplayName ?? 'Administrador';
    final advisorVal = currentAdvisor;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: SizedBox(
            width: math.min(680.0, MediaQuery.of(ctx).size.width - 40),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1,
                          color: Color(0xFF10B981),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registrar Nuevo Prospecto',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Añadí prospectos descubiertos en Google Maps, cartelería o directorios comerciales.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Campos de datos
                  TextFormField(
                    controller: companyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Empresa / Edificio / Razón Comercial *',
                      hintText: 'Ej: Clínica Los Olivos Equipetrol',
                      prefixIcon: Icon(Icons.business),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: sectorVal,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Rubro / Industria *',
                            isDense: true,
                          ),
                          items: _sectors
                              .where((s) => s != 'Todos')
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) sectorVal = v;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          initialValue: advisorVal,
                          readOnly: true,
                          enabled: false,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF334155),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Asesor Asignado *',
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.verified_user_outlined,
                              size: 18,
                              color: Color(0xFF10B981),
                            ),
                            suffixIcon: const Tooltip(
                              message:
                                  'Asignado automáticamente al usuario con sesión activa (Inmutable)',
                              child: Icon(
                                Icons.lock_outline,
                                size: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                                : const Color(0xFFF1F5F9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: contactCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Contacto / Decisor',
                            hintText: 'Ej: Lic. Carlos Perez (Administrador)',
                            prefixIcon: Icon(Icons.person_outline),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono / WhatsApp *',
                            hintText: 'Ej: 77042047',
                            prefixIcon: Icon(Icons.phone),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            hintText: 'Ej: contacto@empresa.com.bo',
                            prefixIcon: Icon(Icons.email_outlined),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: urlCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Sitio Web / Perfil Maps',
                            hintText: 'https://...',
                            prefixIcon: Icon(Icons.link),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Dirección física / Ubicación Maps *',
                      hintText: 'Ej: Av. San Martín #245, Barrio Equipetrol',
                      prefixIcon: Icon(Icons.place),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notas de Prospección / Observaciones',
                      hintText:
                          'Requerimientos preliminares, tamaño del predio, etc...',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (companyCtrl.text.trim().isNotEmpty) {
                            final emailText = emailCtrl.text.trim();
                            final urlText = urlCtrl.text.trim();
                            _leadsService.addLead(
                              LeadModel(
                                id: 'PROSP-${DateTime.now().millisecondsSinceEpoch % 10000}',
                                date: 'Hoy',
                                advisor: advisorVal,
                                company: companyCtrl.text.trim(),
                                companyUrl: urlText.isNotEmpty ? urlText : null,
                                sector: sectorVal,
                                address: addressCtrl.text.trim().isNotEmpty
                                    ? addressCtrl.text.trim()
                                    : 'Santa Cruz de la Sierra',
                                phone: phoneCtrl.text.trim().isNotEmpty
                                    ? phoneCtrl.text.trim()
                                    : 'Sin teléfono',
                                emailOrWeb: emailText.isNotEmpty
                                    ? emailText
                                    : (urlText.isNotEmpty ? urlText : null),
                                status: 'Prospectado',
                                temperature: 'Normal',
                                contactPerson:
                                    contactCtrl.text.trim().isNotEmpty
                                    ? contactCtrl.text.trim()
                                    : 'Encargado de compras',
                                notes: notesCtrl.text.trim().isNotEmpty
                                    ? notesCtrl.text.trim()
                                    : 'Prospecto recién ingresado.',
                                estimatedValue: 0.0,
                              ),
                            );

                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFF065F46),
                                content: Text(
                                  'Prospecto guardado exitosamente en el CRM.',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Guardar Prospecto'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 9. HELPERS Y UTILIDADES
  // ===========================================================================

  List<LeadModel> _getFilteredLeads(List<LeadModel> all) {
    return all.where((item) {
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch =
          q.isEmpty ||
          item.company.toLowerCase().contains(q) ||
          item.address.toLowerCase().contains(q) ||
          item.phone.contains(q) ||
          item.advisor.toLowerCase().contains(q) ||
          item.contactPerson.toLowerCase().contains(q);

      final matchesSector =
          _selectedSector == 'Todos' ||
          item.sector.toLowerCase().contains(
            _selectedSector.toLowerCase().split(' ')[0],
          );

      final matchesAdvisor =
          _selectedAdvisor == 'Todos' || item.advisor == _selectedAdvisor;
      final matchesStatus =
          _selectedStatus == 'Todos' || item.status == _selectedStatus;

      return matchesSearch && matchesSector && matchesAdvisor && matchesStatus;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Prospectado':
        return const Color(0xFF64748B);
      case 'Contactado':
        return const Color(0xFF3B82F6);
      case 'En Espera de Respuesta':
        return const Color(0xFFF59E0B);
      case 'Interesado (Calificado)':
        return const Color(0xFF10B981);
      case 'Descartado':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getSectorColor(String sector) {
    if (sector.contains('Clínicas')) {
      return const Color(0xFF06B6D4);
    }
    if (sector.contains('Corporativo')) {
      return const Color(0xFF3B82F6);
    }
    if (sector.contains('Colegios') || sector.contains('Educación')) {
      return const Color(0xFF8B5CF6);
    }
    if (sector.contains('Banca')) {
      return const Color(0xFF10B981);
    }
    if (sector.contains('Industria')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF64748B);
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111C30) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 44, color: Color(0xFF64748B)),
          const SizedBox(height: 12),
          Text(
            'No se encontraron prospectos con los filtros seleccionados',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Probá ajustando la búsqueda o seleccionando "Todos" en rubro o estado.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1400),
        backgroundColor: const Color(0xFF0F172A),
        content: Text('$label copiado al portapapeles: $text'),
      ),
    );
  }
}
