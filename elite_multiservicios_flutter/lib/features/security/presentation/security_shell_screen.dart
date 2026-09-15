import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/web_url_sync.dart';
import '../../crm/presentation/views/crm_activities_view.dart';
import '../../crm/presentation/views/crm_customers_view.dart';
import '../../crm/presentation/views/crm_leads_view.dart';
import '../../crm/presentation/views/crm_pipeline_view.dart';
import '../../rrhh/presentation/views/rrhh_absences_view.dart';
import '../../rrhh/presentation/views/rrhh_audit_view.dart';
import '../../rrhh/presentation/views/rrhh_contracts_view.dart';
import '../../rrhh/presentation/views/rrhh_employees_view.dart';
import '../../rrhh/presentation/views/rrhh_history_view.dart';
import '../services/auth_service.dart';
import '../services/security_api_service.dart';
import 'views/security_dashboard_view.dart';
import 'views/users_management_view.dart';
import 'views/roles_rbac_view.dart';
import 'views/audit_log_view.dart';
import 'views/active_sessions_view.dart';
import 'views/server_metrics_view.dart';

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
    'metrics',
    'crm-leads',
    'crm-pipeline',
    'crm-clientes',
    'crm-actividades',
    'rrhh-colaboradores',
    'rrhh-contratos',
    'rrhh-permisos',
    'rrhh-bajas',
    'rrhh-bitacora',
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
      case 'metrics':
      case 'metricas':
      case 'telemetria':
        return 5;
      case 'crm-leads':
      case 'leads':
      case 'prospectos':
        return 6;
      case 'crm-pipeline':
      case 'pipeline':
      case 'embudo':
        return 7;
      case 'crm-clientes':
      case 'clientes':
      case 'directorio':
        return 8;
      case 'crm-actividades':
      case 'actividades':
      case 'agenda':
        return 9;
      case 'rrhh-colaboradores':
      case 'colaboradores':
      case 'empleados':
      case 'rrhh':
        return 10;
      case 'rrhh-contratos':
      case 'contratos':
        return 11;
      case 'rrhh-permisos':
      case 'permisos':
      case 'vacaciones':
        return 12;
      case 'rrhh-bajas':
      case 'bajas':
      case 'historial-laboral':
        return 13;
      case 'rrhh-bitacora':
      case 'rrhh-auditoria':
      case 'bitacora-rrhh':
        return 14;
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
    if (initialIndex >= 1 && initialIndex <= 5) {
      _isSecurityExpanded = true;
    } else if (initialIndex >= 6 && initialIndex <= 9) {
      _isCrmExpanded = true;
    } else if (initialIndex >= 10 && initialIndex <= 14) {
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
            if (newIndex >= 1 && newIndex <= 5) _isSecurityExpanded = true;
            if (newIndex >= 6 && newIndex <= 9) _isCrmExpanded = true;
            if (newIndex >= 10 && newIndex <= 14) _isRrhhExpanded = true;
          });
          _loadSidebarMetrics();
        }
      }
    });

    _loadSidebarMetrics();
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
        if (index >= 1 && index <= 5) {
          _isSecurityExpanded = true;
        } else if (index >= 6 && index <= 9) {
          _isCrmExpanded = true;
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
    'Telemetría y Métricas',
    'CRM: Prospectos & Leads',
    'CRM: Pipeline Comercial',
    'CRM: Directorio Clientes 360°',
    'CRM: Agenda & Actividades',
    'RRHH: Colaboradores & Personal',
    'RRHH: Contratos & Asignaciones',
    'RRHH: Permisos & Vacaciones',
    'RRHH: Bajas & Historial Laboral',
    'RRHH: Bitácora de Auditoría',
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
            color: isSelected
                ? (isDark ? const Color(0xFF161F30) : const Color(0xFFF1F5F9))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border(
                    left: BorderSide(
                      color: const Color(0xFF2563EB),
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
                    ? (isDark
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF2563EB))
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
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0))
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
                                    ? const Color(0xFF93C5FD)
                                    : const Color(0xFF1D4ED8))
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
      (
        icon: Icons.speed_outlined,
        selectedIcon: Icons.speed,
        label: 'Métricas',
        badge: null,
        index: 5,
      ),
    ];

    final crmItems = [
      (
        icon: Icons.person_search_outlined,
        selectedIcon: Icons.person_search,
        label: 'Prospectos / Leads',
        badge: 'Nuevo',
        index: 6,
      ),
      (
        icon: Icons.view_kanban_outlined,
        selectedIcon: Icons.view_kanban,
        label: 'Pipeline & Embudo',
        badge: null,
        index: 7,
      ),
      (
        icon: Icons.business_outlined,
        selectedIcon: Icons.business,
        label: 'Clientes 360°',
        badge: null,
        index: 8,
      ),
      (
        icon: Icons.event_available_outlined,
        selectedIcon: Icons.event_available,
        label: 'Agenda & Tareas',
        badge: 'dot',
        index: 9,
      ),
    ];

    final isAnySecurityActive = _selectedIndex >= 1 && _selectedIndex <= 5;
    final isAnyCrmActive = _selectedIndex >= 6 && _selectedIndex <= 9;
    final isAnyRrhhActive = _selectedIndex >= 10 && _selectedIndex <= 14;

    final rrhhItems = [
      (
        icon: Icons.people_alt_outlined,
        selectedIcon: Icons.people_alt,
        label: 'Colaboradores',
        badge: null,
        index: 10,
      ),
      (
        icon: Icons.description_outlined,
        selectedIcon: Icons.description,
        label: 'Contratos & Cargos',
        badge: null,
        index: 11,
      ),
      (
        icon: Icons.event_note_outlined,
        selectedIcon: Icons.event_note,
        label: 'Permisos & Vacaciones',
        badge: null,
        index: 12,
      ),
      (
        icon: Icons.history_edu_outlined,
        selectedIcon: Icons.history_edu,
        label: 'Bajas & Historial',
        badge: null,
        index: 13,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'Bitácora RRHH',
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
        currentView = const ServerMetricsView();
        break;
      case 6:
        currentView = const CrmLeadsView();
        break;
      case 7:
        currentView = const CrmPipelineView();
        break;
      case 8:
        currentView = const CrmCustomersView();
        break;
      case 9:
        currentView = const CrmActivitiesView();
        break;
      case 10:
        currentView = const RrhhEmployeesView();
        break;
      case 11:
        currentView = const RrhhContractsView();
        break;
      case 12:
        currentView = const RrhhAbsencesView();
        break;
      case 13:
        currentView = const RrhhHistoryView();
        break;
      case 14:
        currentView = const RrhhAuditView();
        break;
      default:
        currentView = const Center(child: Text('Vista no encontrada'));
    }

    final userName = _authService.currentDisplayName ?? 'Administrador';
    const userEmail = 'admin@elitemultiservicios.com';
    const userInitials = 'AD';
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
                        _selectedIndex >= 10
                            ? 'RRHH'
                            : (_selectedIndex >= 6 ? 'CRM' : 'Seguridad'),
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
                        _titles[_selectedIndex],
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

                  // Notification Bell
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          size: 18,
                        ),
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    tooltip: 'Notificaciones',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
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
