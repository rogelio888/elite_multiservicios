import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/rrhh_contratacion_tab.dart';
import '../widgets/rrhh_hire_wizard.dart';
import '../widgets/rrhh_personal_directorio_tab.dart';
import '../widgets/rrhh_state_widgets.dart';
import 'rrhh_placeholder_view.dart';

/// Vista raíz de Gestión de Personal (Entrada 02 del acordeón RRHH).
/// Contenedor ejecutivo con 3 tabs: Directorio, Reclutamiento y Contratación.
class RrhhPersonalView extends StatefulWidget {
  final String? initialTab;
  final bool hasPermission;
  final void Function(int index)? onNavigateToTab;

  const RrhhPersonalView({
    super.key,
    this.initialTab,
    this.hasPermission = true,
    this.onNavigateToTab,
  });

  @override
  State<RrhhPersonalView> createState() => _RrhhPersonalViewState();
}

class _RrhhPersonalViewState extends State<RrhhPersonalView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<RrhhPersonalDirectorioTabState> _directorioKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final init = widget.initialTab?.toLowerCase();
    if (init == 'reclutamiento' || init == 'postulantes') {
      tabIndex = 1;
    } else if (init == 'contratacion' || init == 'alta') {
      tabIndex = 2;
    }

    _tabController = TabController(
      length: 3,
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
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(requiredPermission: 'rrhh.personal.view');
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Directorio (Pantalla 02)
              RrhhPersonalDirectorioTab(key: _directorioKey),

              // Tab 2: Reclutamiento & Postulantes (Pantalla 04)
              const RrhhPlaceholderView(
                title: '04. Reclutamiento & Pipeline de Postulantes',
                blockName: 'En construcción - Bloque 1',
                description:
                    'Gestión del embudo de candidatos, evaluación curricular, entrevistas y filtro previo a contratación.',
                icon: Icons.person_search_outlined,
              ),

              // Tab 3: Contratación Formal (Wizard, Pantalla 05)
              RrhhContratacionTab(
                onHireCompleted: () {
                  _directorioKey.currentState?.loadEmployees();
                  _tabController.animateTo(0);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila única: Título + Subtítulo a la izquierda, Acción principal a la derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gestión de Personal',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF8FAFC),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Directorio oficial de colaboradores, embudo de postulantes y contratación formal',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: () {
                  RrhhEmployeeHireWizard.show(
                    context,
                    onCompleted: () {
                      _directorioKey.currentState?.loadEmployees();
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                ),
                icon: const Icon(Icons.person_add_alt_1, size: 15),
                label: Text(
                  '+ Contratar Colaborador',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 2,
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: const Color(0xFF94A3B8),
            labelStyle: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_alt_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Directorio'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_search_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Reclutamiento'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.how_to_reg_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Contratación'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
