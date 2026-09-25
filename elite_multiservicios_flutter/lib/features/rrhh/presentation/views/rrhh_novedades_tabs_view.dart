import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rrhh_placeholder_view.dart';

/// Vista contenedora de Novedades Laborales (Entrada 04 del menú RRHH).
/// Agrupa:
/// - Tab 1: Permisos y Licencias (Pantalla 08)
/// - Tab 2: Control de Vacaciones (Pantalla 09)
/// - Tab 3: Régimen Disciplinario e Incidencias (Pantalla 10)
/// - Tab 4: Desvinculaciones y Bajas (Pantalla 11)
class RrhhNovedadesTabsView extends StatefulWidget {
  final String? initialTab;
  final void Function(int index)? onNavigateToTab;

  const RrhhNovedadesTabsView({
    super.key,
    this.initialTab,
    this.onNavigateToTab,
  });

  @override
  State<RrhhNovedadesTabsView> createState() => _RrhhNovedadesTabsViewState();
}

class _RrhhNovedadesTabsViewState extends State<RrhhNovedadesTabsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final tab = widget.initialTab?.toLowerCase();
    if (tab == 'vacaciones') {
      tabIndex = 1;
    } else if (tab == 'incidencias' || tab == 'disciplina') {
      tabIndex = 2;
    } else if (tab == 'bajas' || tab == 'desvinculaciones' || tab == 'finiquitos') {
      tabIndex = 3;
    }

    _tabController = TabController(
      length: 4,
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
                      Icons.assignment_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '04. Novedades Laborales',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Control de permisos, vacaciones, incidencias y egresos del personal',
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
                    icon: Icon(Icons.fact_check_outlined, size: 18),
                    text: 'Permisos y Licencias',
                  ),
                  Tab(
                    icon: Icon(Icons.beach_access_outlined, size: 18),
                    text: 'Vacaciones',
                  ),
                  Tab(
                    icon: Icon(Icons.gavel_outlined, size: 18),
                    text: 'Incidencias y Disciplina',
                  ),
                  Tab(
                    icon: Icon(Icons.person_remove_outlined, size: 18),
                    text: 'Desvinculaciones',
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
                title: '08. Permisos y Licencias Médicas',
                blockName: 'Bloque 3',
                description:
                    'Recepción, validación de certificados médicos (CNS) y resolución de licencias.',
                icon: Icons.fact_check_outlined,
              ),
              RrhhPlaceholderView(
                title: '09. Control de Vacaciones (Ley Laboral Bolivia)',
                blockName: 'Bloque 3',
                description:
                    'Cómputo legal de días de vacación según antigüedad en Bolivia y control de saldos.',
                icon: Icons.beach_access_outlined,
              ),
              RrhhPlaceholderView(
                title: '10. Régimen Disciplinario e Incidencias',
                blockName: 'Bloque 3',
                description:
                    'Emisión y registro de sanciones, memorándums de llamada de atención y felicitaciones.',
                icon: Icons.gavel_outlined,
              ),
              RrhhPlaceholderView(
                title: '11. Desvinculación & Bajas Laborales',
                blockName: 'Bloque 3',
                description:
                    'Proceso de egreso laboral, cálculo para finiquito y congelamiento (Regla de Oro Inactivo).',
                icon: Icons.person_remove_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
