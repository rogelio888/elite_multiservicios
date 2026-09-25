import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rrhh_placeholder_view.dart';

/// Vista contenedora de Reportes y Auditoría (Entrada 06 del menú RRHH).
/// Agrupa:
/// - Tab 1: Novedades para Nómina (Pantalla 12 - Entrega a Contabilidad)
/// - Tab 2: Bitácora de Movimientos (Pantalla 14 - Trazabilidad inmutable)
class RrhhReportesTabsView extends StatefulWidget {
  final String? initialTab;
  final void Function(int index)? onNavigateToTab;

  const RrhhReportesTabsView({
    super.key,
    this.initialTab,
    this.onNavigateToTab,
  });

  @override
  State<RrhhReportesTabsView> createState() => _RrhhReportesTabsViewState();
}

class _RrhhReportesTabsViewState extends State<RrhhReportesTabsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final tab = widget.initialTab?.toLowerCase();
    final tabIndex = (tab == 'bitacora' || tab == 'auditoria' || tab == 'movimientos') ? 1 : 0;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: tabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Encabezado y Barra de Pestañas
        Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.assessment_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '06. Reportes y Auditoría',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Consolidado de novedades de nómina y trazabilidad inmutable de personal',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF2563EB),
                indicatorWeight: 2.5,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.request_quote_outlined, size: 18),
                    text: 'Novedades para Nómina',
                  ),
                  Tab(
                    icon: Icon(Icons.history_edu_outlined, size: 18),
                    text: 'Bitácora de Movimientos',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Contenido de cada Tab
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              RrhhPlaceholderView(
                title: '12. Novedades para Nómina (Entrega a Contabilidad)',
                blockName: 'Bloque 4',
                description:
                    'Consolidado administrativo mensual para entrega formal a Contabilidad (PDF Sección 6.1).',
                icon: Icons.request_quote_outlined,
              ),
              RrhhPlaceholderView(
                title: '14. Bitácora / Auditoría de Movimientos',
                blockName: 'Bloque 4',
                description:
                    'Trazabilidad inmutable de todas las novedades laborales del sistema.',
                icon: Icons.history_edu_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
