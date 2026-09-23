import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/web_url_sync.dart';
import '../../crm/data/crm_agenda_service.dart';
import '../../crm/presentation/views/crm_activities_view.dart';
import '../../crm/presentation/views/crm_customers_view.dart';
import '../../crm/presentation/views/crm_catalog_management_view.dart';
import '../../crm/presentation/views/crm_leads_view.dart';
import '../../crm/presentation/views/crm_pipeline_view.dart';
import '../../rrhh/presentation/views/rrhh_dashboard_view.dart';
import '../../rrhh/presentation/views/rrhh_personal_view.dart';
import '../../rrhh/presentation/views/rrhh_organization_view.dart';
import '../../rrhh/presentation/views/rrhh_assignments_view.dart';
import '../../rrhh/presentation/views/rrhh_labor_view.dart';
import '../../rrhh/presentation/views/rrhh_reports_view.dart';
import '../services/auth_service.dart';
import '../services/security_api_service.dart';
import 'views/security_dashboard_view.dart';
import 'views/users_management_view.dart';
import 'views/roles_rbac_view.dart';
import 'views/audit_log_view.dart';
import 'views/active_sessions_view.dart';

/// Shell principal de navegación para el módulo de seguridad de Elite Multiservicios.
/// Diseñado con estética minimalista ejecutiva, contención visual y escala suiza.
class SecurityShellScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;
  final AuthService? authService;

  const SecurityShellScreen({
    super.key,
    this.onToggleTheme,
    this.isDarkMode = false,
    this.authService,
  });

  @override
  State<SecurityShellScreen> createState() => _SecurityShellScreenState();
}

class _SecurityShellScreenState extends State<SecurityShellScreen> {
  static const List<String> _tabSlugs = [
    'dashboard',
    'users',
    'roles',
    'audit',
    'sessions',
    'crm-leads',
    'crm-pipeline',
    'crm-clientes',
    'crm-actividades',
    'rrhh-dashboard',
    'rrhh-personal',
    'rrhh-organizacion',
    'rrhh-asignaciones',
    'rrhh-laboral',
    'rrhh-reportes',
    'crm-catalogo',
  ];

  static int _indexFromRouteOrHash(String raw) {
    final clean = raw
        .toLowerCase()
        .replaceAll('#', '')
        .replaceAll('/', '')
        .trim();
    switch (clean) {
      case 'users':
      case 'usuarios':
        return 1;
      case 'roles':
      case 'rbac':
        return 2;
      case 'audit':
      case 'auditoria':
      case 'bitacora':
        return 3;
      case 'sessions':
      case 'sesiones':
        return 4;

      case 'crm-leads':
      case 'leads':
      case 'prospectos':
        return 5;
      case 'crm-pipeline':
      case 'pipeline':
      case 'embudo':
        return 6;
      case 'crm-clientes':
      case 'clientes':
      case 'directorio':
        return 7;
      case 'crm-actividades':
      case 'actividades':
      case 'agenda':
        return 8;
      case 'rrhh-dashboard':
      case 'dashboard-rrhh':
        return 9;
      case 'rrhh-personal':
      case 'rrhh-colaboradores':
      case 'colaboradores':
      case 'empleados':
      case 'personal':
      case 'rrhh':
        return 10;
      case 'rrhh-organizacion':
      case 'organizacion':
      case 'areas':
      case 'cargos':
      case 'especialidades':
        return 11;
      case 'rrhh-asignaciones':
      case 'asignaciones':
      case 'horarios':
      case 'turnos':
      case 'rrhh-contratos':
      case 'contratos':
        return 12;
      case 'rrhh-laboral':
      case 'rrhh-permisos':
      case 'permisos':
      case 'vacaciones':
      case 'incidencias':
      case 'rrhh-bajas':
      case 'bajas':
        return 13;
      case 'rrhh-reportes':
      case 'reportes':
      case 'rrhh-bitacora':
      case 'rrhh-auditoria':
      case 'bitacora-rrhh':
        return 14;
      case 'crm-catalogo':
      case 'catalogo':
      case 'tarifario':
      case 'partidas':
        return 15;
      case 'dashboard':
      default:
        return 0;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AuthService _authService;
  final _service = SecurityApiService();
  SecurityDashboardMetrics? _sidebarMetrics;
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;
  bool _isSecurityExpanded = true;
  bool _isCrmExpanded = true;
  bool _isRrhhExpanded = true;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();

    // 1. Detección del módulo activo al cargar/recargar la página
    final browserHash = getBrowserHash();
    int initialIndex = 0;
    if (browserHash.isNotEmpty) {
      initialIndex = _indexFromRouteOrHash(browserHash);
    } else {
      final fragment = Uri.base.fragment;
      if (fragment.isNotEmpty) {
        initialIndex = _indexFromRouteOrHash(fragment);
      } else {
        final queryTab =
            Uri.base.queryParameters['tab'] ??
            Uri.base.queryParameters['module'];
        if (queryTab != null && queryTab.isNotEmpty) {
          initialIndex = _indexFromRouteOrHash(queryTab);
        }
      }
    }

    _selectedIndex = initialIndex;
    if (initialIndex >= 1 && initialIndex <= 4) {
      _isSecurityExpanded = true;
    } else if ((initialIndex >= 5 && initialIndex <= 8) || initialIndex == 15) {
      _isCrmExpanded = true;
    } else if (initialIndex >= 9 && initialIndex <= 14) {
      _isRrhhExpanded = true;
    }

    // Sincronizar URL del navegador con el slug activo
    setBrowserHash('/${_tabSlugs[_selectedIndex]}');

    // Escuchar navegación del navegador (Atrás / Adelante)
    listenBrowserHashChange((newHash) {
      if (mounted) {
        final newIndex = _indexFromRouteOrHash(newHash);
        if (newIndex != _selectedIndex) {
          setState(() {
            _selectedIndex = newIndex;
            if (newIndex >= 1 && newIndex <= 4) _isSecurityExpanded = true;
            if ((newIndex >= 5 && newIndex <= 8) || newIndex == 15) {
              _isCrmExpanded = true;
            }
            if (newIndex >= 9 && newIndex <= 14) _isRrhhExpanded = true;
          });
          _loadSidebarMetrics();
        }
      }
    });

    _loadSidebarMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        CrmAgendaService().loadTasks();
      }
    });
  }

  Future<void> _loadSidebarMetrics() async {
    try {
      final metrics = await _service.getDashboardMetrics();
      if (mounted) {
        setState(() => _sidebarMetrics = metrics);
      }
    } catch (_) {}
  }

  void _onTabSelected(int index, {bool isDrawer = false}) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        if (index >= 1 && index <= 4) {
          _isSecurityExpanded = true;
        } else if ((index >= 5 && index <= 8) || index == 15) {
          _isCrmExpanded = true;
        } else if (index >= 9 && index <= 14) {
          _isRrhhExpanded = true;
        }
      });
      // Sincronizar URL visible en la barra de direcciones del navegador
      if (index >= 0 && index < _tabSlugs.length) {
        setBrowserHash('/${_tabSlugs[index]}');
      }
    }
    if (isDrawer && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    _loadSidebarMetrics();
  }

  Future<void> _confirmAndLogout() async {
    final isDark = widget.isDarkMode;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFEF4444),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar tu sesión actual? '
          'La sesión se revocará en el servidor y se registrará en la bitácora.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Cerrar Sesión',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
    }
  }

  final List<String> _titles = [
    'Dashboard General',
    'Gestión de Usuarios',
    'Roles y Permisos RBAC',
    'Bitácora de Auditoría',
    'Sesiones Activas',
    'CRM: Prospectos & Leads',
    'CRM: Pipeline Comercial',
    'CRM: Directorio Clientes 360°',
    'CRM: Agenda & Actividades',
    'RRHH: Dashboard Ejecutivo',
    'RRHH: Personal & Expedientes',
    'RRHH: Organización & Estructura',
    'RRHH: Asignaciones & Horarios',
    'RRHH: Gestión Laboral & Novedades',
    'RRHH: Centro de Reportes & Métricas',
    'CRM: Catálogo & Tarifario',
  ];

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    String? badge,
    bool isSubItem = false,
    bool isDrawer = false,
  }) {
    final isDark = widget.isDarkMode;
    final isSelected = _selectedIndex == index;
    final collapsed = !isDrawer && _isSidebarCollapsed;

    final isCrmItem = (index >= 5 && index <= 8) || index == 15;
    final isRrhhItem = index >= 9 && index <= 14;
    final Color activeAccent = isCrmItem
        ? const Color(0xFF10B981)
        : (isRrhhItem ? const Color(0xFF8B5CF6) : const Color(0xFF2563EB));
    final Color activeAccentLight = isCrmItem
        ? const Color(0xFF34D399)
        : (isRrhhItem ? const Color(0xFFA78BFA) : const Color(0xFF60A5FA));
    final Color activeBg = isDark
        ? (isCrmItem
              ? const Color(0xFF10B981).withValues(alpha: 0.12)
              : (isRrhhItem
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                    : const Color(0xFF161F30)))
        : (isCrmItem
              ? const Color(0xFF10B981).withValues(alpha: 0.08)
              : (isRrhhItem
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.08)
                    : const Color(0xFFF1F5F9)));

    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTabSelected(index, isDrawer: isDrawer),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 12 : (isSubItem ? 12 : 12),
            vertical: isSubItem ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border(
                    left: BorderSide(
                      color: activeAccent,
                      width: 2.5,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: collapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? (isDark ? activeAccentLight : activeAccent)
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
                size: isSubItem ? 16 : 18,
              ),
              if (!collapsed) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF0F172A))
                          : (isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B)),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: isSubItem ? 12.5 : 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badge != null) ...[
                  if (badge == 'dot')
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD97706),
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? (isCrmItem
                                        ? const Color(0xFF064E3B)
                                        : const Color(0xFF1E293B))
                                  : (isCrmItem
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFE2E8F0)))
                            : (isDark
                                  ? const Color(0xFF111827)
                                  : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? (isDark
                                    ? (isCrmItem
                                          ? const Color(0xFF6EE7B7)
                                          : const Color(0xFF93C5FD))
                                    : (isCrmItem
                                          ? const Color(0xFF047857)
                                          : const Color(0xFF1D4ED8)))
                              : (isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    if (collapsed) {
      return Tooltip(
        message: label,
        waitDuration: const Duration(milliseconds: 300),
        child: content,
      );
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final securityItems = [
      (
        icon: Icons.group_outlined,
        selectedIcon: Icons.group,
        label: 'Usuarios',
        badge: _sidebarMetrics != null
            ? '${_sidebarMetrics!.totalUsers}'
            : null,
        index: 1,
      ),
      (
        icon: Icons.admin_panel_settings_outlined,
        selectedIcon: Icons.admin_panel_settings,
        label: 'Roles & RBAC',
        badge: _sidebarMetrics != null
            ? '${_sidebarMetrics!.totalRoles}'
            : null,
        index: 2,
      ),
      (
        icon: Icons.history_edu_outlined,
        selectedIcon: Icons.history_edu,
        label: 'Auditoría',
        badge: 'dot',
        index: 3,
      ),
      (
        icon: Icons.devices_outlined,
        selectedIcon: Icons.devices,
        label: 'Sesiones',
        badge: _sidebarMetrics != null
            ? '${_sidebarMetrics!.activeSessions}'
            : null,
        index: 4,
      ),
    ];

    final crmItems = [
      (
        icon: Icons.person_search_outlined,
        selectedIcon: Icons.person_search,
        label: 'Prospectos / Leads',
        badge: null,
        index: 5,
      ),
      (
        icon: Icons.view_kanban_outlined,
        selectedIcon: Icons.view_kanban,
        label: 'Pipeline & Embudo',
        badge: null,
        index: 6,
      ),
      (
        icon: Icons.business_outlined,
        selectedIcon: Icons.business,
        label: 'Clientes 360°',
        badge: null,
        index: 7,
      ),
      (
        icon: Icons.event_available_outlined,
        selectedIcon: Icons.event_available,
        label: 'Agenda & Tareas',
        badge: 'dot',
        index: 8,
      ),
      (
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: 'Catálogo & Tarifario',
        badge: null,
        index: 15,
      ),
    ];

    final isAnySecurityActive = _selectedIndex >= 1 && _selectedIndex <= 4;
    final isAnyCrmActive =
        (_selectedIndex >= 5 && _selectedIndex <= 8) || _selectedIndex == 15;
    final isAnyRrhhActive = _selectedIndex >= 9 && _selectedIndex <= 14;

    final rrhhItems = [
      (
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard RRHH',
        badge: null,
        index: 9,
      ),
      (
        icon: Icons.badge_outlined,
        selectedIcon: Icons.badge,
        label: 'Personal & Expedientes',
        badge: null,
        index: 10,
      ),
      (
        icon: Icons.account_tree_outlined,
        selectedIcon: Icons.account_tree,
        label: 'Organización',
        badge: null,
        index: 11,
      ),
      (
        icon: Icons.work_history_outlined,
        selectedIcon: Icons.work_history,
        label: 'Asignaciones & Turnos',
        badge: null,
        index: 12,
      ),
      (
        icon: Icons.fact_check_outlined,
        selectedIcon: Icons.fact_check,
        label: 'Gestión Laboral',
        badge: null,
        index: 13,
      ),
      (
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        label: 'Centro de Reportes',
        badge: null,
        index: 14,
      ),
    ];

    Widget currentView;
    switch (_selectedIndex) {
      case 0:
        currentView = SecurityDashboardView(
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 1:
        currentView = const UsersManagementView();
        break;
      case 2:
        currentView = const RolesRbacView();
        break;
      case 3:
        currentView = const AuditLogView();
        break;
      case 4:
        currentView = const ActiveSessionsView();
        break;
      case 5:
        currentView = const CrmLeadsView();
        break;
      case 6:
        currentView = CrmPipelineView(
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 7:
        currentView = const CrmCustomersView();
        break;
      case 8:
        currentView = const CrmActivitiesView();
        break;
      case 9:
        currentView = RrhhDashboardView(
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 10:
        currentView = const RrhhPersonalView();
        break;
      case 11:
        currentView = const RrhhOrganizationView();
        break;
      case 12:
        currentView = const RrhhAssignmentsView();
        break;
      case 13:
        currentView = const RrhhLaborView();
        break;
      case 14:
        currentView = const RrhhReportsView();
        break;
      case 15:
        currentView = const CrmCatalogManagementView();
        break;
      default:
        currentView = const Center(child: Text('Vista no encontrada'));
    }

    final userName = _authService.currentDisplayName ?? 'Super Administrador';
    final userEmail =
        _authService.currentUserEmail ?? 'rogeliovladimir2016@gmail.com';
    final isSuperAdmin =
        userEmail.trim().toLowerCase() == 'rogeliovladimir2016@gmail.com';
    final userInitials = isSuperAdmin
        ? 'RH'
        : (userEmail.isNotEmpty && userEmail.length >= 2
              ? userEmail.substring(0, 2).toUpperCase()
              : 'AD');
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 850;

        final topBar = Container(
          height: 54,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF090D16) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lado Izquierdo: Menú hamburguesa (móvil) + Breadcrumbs
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMobile) ...[
                      IconButton(
                        icon: const Icon(Icons.menu, size: 20),
                        tooltip: 'Abrir Menú',
                        visualDensity: VisualDensity.compact,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (!isMobile) ...[
                      Text(
                        ((_selectedIndex >= 5 && _selectedIndex <= 8) ||
                                _selectedIndex == 15)
                            ? 'CRM'
                            : (_selectedIndex >= 9 && _selectedIndex <= 14
                                  ? 'RRHH'
                                  : 'Seguridad'),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '/',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    Flexible(
                      child: Text(
                        _selectedIndex >= 0 && _selectedIndex < _titles.length
                            ? _titles[_selectedIndex]
                            : 'Elite Multiservicios',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Top Actions: Atajo de búsqueda (Desktop) + Tema + Notificaciones + Perfil
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMobile) ...[
                    // Cápsula sutil de búsqueda rápida
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0D111C)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search,
                            size: 14,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Buscar...',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '⌘K',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Theme Toggle Button
                  IconButton(
                    icon: Icon(
                      widget.isDarkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      size: 18,
                    ),
                    tooltip: 'Cambiar Tema',
                    visualDensity: VisualDensity.compact,
                    onPressed: widget.onToggleTheme,
                  ),

                  // Notification Bell Reactivo con CRM Agenda
                  ListenableBuilder(
                    listenable: CrmAgendaService(),
                    builder: (context, _) {
                      final agendaService = CrmAgendaService();
                      final pendingTasks =
                          agendaService.urgentOrTodayPendingTasks;
                      final count = pendingTasks.length;
                      final hasOverdue = pendingTasks.any((t) => t.isOverdue);
                      final alertColor = hasOverdue
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFF59E0B);

                      return PopupMenuButton<String>(
                        tooltip: count > 0
                            ? '$count compromisos pendientes para hoy'
                            : 'Sin notificaciones pendientes',
                        offset: const Offset(0, 42),
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        itemBuilder: (ctx) {
                          if (pendingTasks.isEmpty) {
                            return [
                              PopupMenuItem<String>(
                                enabled: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 18,
                                        color: Color(0xFF10B981),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'No tienes tareas pendientes hoy',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ];
                          }

                          return [
                            PopupMenuItem<String>(
                              enabled: false,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      hasOverdue
                                          ? 'ALERTAS Y VENCIDAS'
                                          : 'COMPROMISOS DE HOY',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                        color: alertColor,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: alertColor.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$count activas',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: alertColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...pendingTasks.take(5).map((t) {
                              final isDue = t.isOverdue;
                              return PopupMenuItem<String>(
                                value: 'task_${t.id}',
                                onTap: () {
                                  _onTabSelected(8);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color:
                                              (isDue
                                                      ? const Color(0xFFEF4444)
                                                      : const Color(0xFFF59E0B))
                                                  .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isDue
                                              ? Icons.alarm
                                              : Icons.phone_in_talk,
                                          size: 14,
                                          color: isDue
                                              ? const Color(0xFFEF4444)
                                              : const Color(0xFFF59E0B),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              t.title,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${t.scheduledTimeText} • ${t.clientName} (${t.phone})',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                color: isDue
                                                    ? const Color(0xFFEF4444)
                                                    : const Color(0xFF64748B),
                                                fontWeight: isDue
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'go_to_agenda',
                              onTap: () {
                                _onTabSelected(8);
                              },
                              child: Center(
                                child: Text(
                                  'Ver todas en Agenda & Tareas →',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                count > 0
                                    ? Icons.notifications_active
                                    : Icons.notifications_none_outlined,
                                color: count > 0
                                    ? alertColor
                                    : (isDark
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF64748B)),
                                size: 19,
                              ),
                              if (count > 0)
                                Positioned(
                                  top: -4,
                                  right: -6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: alertColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      '$count',
                                      style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),

                  Container(
                    height: 18,
                    width: 1,
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                  const SizedBox(width: 12),

                  // User Identity
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            userInitials,
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF1E293B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                userEmail,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDark
              ? const Color(0xFF090D16)
              : const Color(0xFFF8FAFC),
          drawer: isMobile
              ? Drawer(
                  backgroundColor: isDark
                      ? const Color(0xFF0D111C)
                      : Colors.white,
                  child: SafeArea(
                    child: _buildSidebarContent(
                      isDark: isDark,
                      isDrawer: true,
                      securityItems: securityItems,
                      isAnySecurityActive: isAnySecurityActive,
                      crmItems: crmItems,
                      isAnyCrmActive: isAnyCrmActive,
                      rrhhItems: rrhhItems,
                      isAnyRrhhActive: isAnyRrhhActive,
                    ),
                  ),
                )
              : null,
          body: isMobile
              ? Column(
                  children: [
                    topBar,
                    Expanded(child: currentView),
                  ],
                )
              : Row(
                  children: [
                    _buildSidebarContent(
                      isDark: isDark,
                      isDrawer: false,
                      securityItems: securityItems,
                      isAnySecurityActive: isAnySecurityActive,
                      crmItems: crmItems,
                      isAnyCrmActive: isAnyCrmActive,
                      rrhhItems: rrhhItems,
                      isAnyRrhhActive: isAnyRrhhActive,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          topBar,
                          Expanded(child: currentView),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSidebarContent({
    required bool isDark,
    required bool isDrawer,
    required List<
      ({
        IconData icon,
        IconData selectedIcon,
        String label,
        String? badge,
        int index,
      })
    >
    securityItems,
    required bool isAnySecurityActive,
    required List<
      ({
        IconData icon,
        IconData selectedIcon,
        String label,
        String? badge,
        int index,
      })
    >
    crmItems,
    required bool isAnyCrmActive,
    required List<
      ({
        IconData icon,
        IconData selectedIcon,
        String label,
        String? badge,
        int index,
      })
    >
    rrhhItems,
    required bool isAnyRrhhActive,
  }) {
    final collapsed = !isDrawer && _isSidebarCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: isDrawer ? 280 : (collapsed ? 68 : 248),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D111C) : Colors.white,
        border: isDrawer
            ? null
            : Border(
                right: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branding Header
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ELITE MULTISERVICIOS',
                          style: GoogleFonts.inter(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                            letterSpacing: 0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Módulo de Seguridad',
                                style: GoogleFonts.inter(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isDrawer)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: const Color(0xFF94A3B8),
                      onPressed: () => Navigator.pop(context),
                    ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 10),
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'NAVEGACIÓN',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                  letterSpacing: 0.8,
                ),
              ),
            ),

          // Lista de Navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              children: [
                // 1. Dashboard
                _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: 'Dashboard',
                  index: 0,
                  isDrawer: isDrawer,
                ),
                const SizedBox(height: 4),

                // 2. Acordeón Colapsable "Seguridad"
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_seguridad'),
                    onTap: () {
                      setState(() {
                        _isSecurityExpanded = !_isSecurityExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: (isAnySecurityActive && !_isSecurityExpanded)
                            ? (isDark
                                  ? const Color(0xFF161F30)
                                  : const Color(0xFFEFF6FF))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: (isAnySecurityActive && !_isSecurityExpanded)
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 2.5,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: isAnySecurityActive
                                ? (isDark
                                      ? const Color(0xFF60A5FA)
                                      : const Color(0xFF2563EB))
                                : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B)),
                            size: 18,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Seguridad',
                                      style: GoogleFonts.inter(
                                        color: isAnySecurityActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnySecurityActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isAnySecurityActive &&
                                      !_isSecurityExpanded) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF38BDF8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isSecurityExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Sub-pestañas pertenecientes a "Seguridad"
                if (_isSecurityExpanded)
                  Padding(
                    padding: EdgeInsets.only(
                      left: collapsed ? 0 : 10,
                      top: 2,
                    ),
                    child: Container(
                      decoration: collapsed
                          ? null
                          : BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                            ),
                      padding: EdgeInsets.only(
                        left: collapsed ? 0 : 6,
                      ),
                      child: Column(
                        children: securityItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _buildNavItem(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: item.label,
                              index: item.index,
                              badge: item.badge,
                              isSubItem: true,
                              isDrawer: isDrawer,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),

                // 4. Acordeón Colapsable "CRM (Clientes y Prospectos)"
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_crm'),
                    onTap: () {
                      setState(() {
                        _isCrmExpanded = !_isCrmExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: (isAnyCrmActive && !_isCrmExpanded)
                            ? (isDark
                                  ? const Color(0xFF0D251D)
                                  : const Color(0xFFECFDF5))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: (isAnyCrmActive && !_isCrmExpanded)
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFF10B981),
                                  width: 2.5,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.handshake_outlined,
                            color: isAnyCrmActive
                                ? (isDark
                                      ? const Color(0xFF34D399)
                                      : const Color(0xFF059669))
                                : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B)),
                            size: 18,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Clientes y CRM',
                                      style: GoogleFonts.inter(
                                        color: isAnyCrmActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnyCrmActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isAnyCrmActive && !_isCrmExpanded) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isCrmExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // 5. Sub-pestañas pertenecientes a "CRM"
                if (_isCrmExpanded)
                  Padding(
                    padding: EdgeInsets.only(
                      left: collapsed ? 0 : 10,
                      top: 2,
                    ),
                    child: Container(
                      decoration: collapsed
                          ? null
                          : BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                            ),
                      padding: EdgeInsets.only(
                        left: collapsed ? 0 : 6,
                      ),
                      child: Column(
                        children: crmItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _buildNavItem(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: item.label,
                              index: item.index,
                              badge: item.badge,
                              isSubItem: true,
                              isDrawer: isDrawer,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),

                // 6. Acordeón Colapsable "RRHH (Recursos Humanos)"
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_rrhh'),
                    onTap: () {
                      setState(() {
                        _isRrhhExpanded = !_isRrhhExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: (isAnyRrhhActive && !_isRrhhExpanded)
                            ? (isDark
                                  ? const Color(0xFF1E1B4B)
                                  : const Color(0xFFEEF2FF))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: (isAnyRrhhActive && !_isRrhhExpanded)
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFF6366F1),
                                  width: 2.5,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            color: isAnyRrhhActive
                                ? (isDark
                                      ? const Color(0xFF818CF8)
                                      : const Color(0xFF4F46E5))
                                : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B)),
                            size: 18,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Recursos Humanos',
                                      style: GoogleFonts.inter(
                                        color: isAnyRrhhActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnyRrhhActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isAnyRrhhActive && !_isRrhhExpanded) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6366F1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isRrhhExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // 7. Sub-pestañas pertenecientes a "RRHH"
                if (_isRrhhExpanded)
                  Padding(
                    padding: EdgeInsets.only(
                      left: collapsed ? 0 : 10,
                      top: 2,
                    ),
                    child: Container(
                      decoration: collapsed
                          ? null
                          : BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                            ),
                      padding: EdgeInsets.only(
                        left: collapsed ? 0 : 6,
                      ),
                      child: Column(
                        children: rrhhItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _buildNavItem(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: item.label,
                              index: item.index,
                              badge: item.badge,
                              isSubItem: true,
                              isDrawer: isDrawer,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Footer Actions: Cerrar Sesión & Colapsar Menú (Colapsar solo en desktop)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _confirmAndLogout,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Color(0xFFEF4444),
                            size: 16,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 10),
                            Text(
                              'Cerrar Sesión',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFEF4444),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isDrawer) ...[
                  const SizedBox(height: 2),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(
                        () => _isSidebarCollapsed = !_isSidebarCollapsed,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isSidebarCollapsed
                                  ? Icons.chevron_right
                                  : Icons.chevron_left,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                              size: 16,
                            ),
                            if (!_isSidebarCollapsed) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Colapsar Menú',
                                  style: GoogleFonts.inter(
                                    color: isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
