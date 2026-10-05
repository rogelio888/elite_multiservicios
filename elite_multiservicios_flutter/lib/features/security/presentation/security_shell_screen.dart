import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/web_url_sync.dart';
import '../../crm/data/crm_agenda_service.dart';
import '../../crm/presentation/views/crm_activities_view.dart';
import '../../crm/presentation/views/crm_customers_view.dart';
import '../../crm/presentation/views/crm_catalog_management_view.dart';
import '../../crm/presentation/views/crm_leads_view.dart';
import '../../crm/presentation/views/crm_pipeline_view.dart';
import '../../rrhh/rrhh_routes.dart';
import '../services/auth_service.dart';
import '../services/security_api_service.dart';
import 'views/security_dashboard_view.dart';
import 'views/users_management_view.dart';
import 'views/roles_rbac_view.dart';
import 'views/audit_log_view.dart';
import 'views/active_sessions_view.dart';
import '../../accounting/presentation/screens/accounting_dashboard_screen.dart';
import '../../accounting/presentation/screens/accounting_receivables_screen.dart';
import '../../accounting/presentation/screens/accounting_expenses_screen.dart';
import '../../accounting/presentation/screens/accounting_petty_cash_screen.dart';
import '../../accounting/presentation/screens/accounting_payroll_screen.dart';
import '../../accounting/presentation/screens/accounting_budgets_screen.dart';
import '../../accounting/presentation/screens/accounting_banks_screen.dart';
import '../../accounting/presentation/screens/accounting_reconciliation_screen.dart';
import '../../accounting/presentation/screens/accounting_fixed_assets_screen.dart';
import '../../accounting/presentation/screens/accounting_fixed_assets_depreciation_batch_screen.dart';
import '../../accounting/presentation/screens/accounting_fixed_assets_revaluation_screen.dart';
import '../../accounting/presentation/screens/accounting_fixed_assets_disposals_screen.dart';
import '../../accounting/presentation/screens/accounting_fixed_assets_config_screen.dart';
import '../../accounting/presentation/screens/accounting_ledger_screen.dart';
import '../../accounting/presentation/screens/accounting_taxes_screen.dart';
import '../../accounting/presentation/screens/accounting_profitability_screen.dart';
import '../../accounting/presentation/screens/accounting_financial_statements_screen.dart';
import '../../accounting/presentation/screens/accounting_period_closure_screen.dart';
import '../../accounting/presentation/screens/accounting_kardex_screen.dart';
import '../../accounting/presentation/screens/accounting_work_order_costing_screen.dart';
import '../../ops/presentation/screens/ops_inventory_screen.dart';
import '../../ops/presentation/screens/ops_contracts_screen.dart';
import '../../ops/presentation/screens/ops_work_orders_screen.dart';

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
    // 6 Entradas Reorganizadas del Módulo RRHH
    'rrhh-dashboard',
    'rrhh-personal',
    'rrhh-organizacion',
    'rrhh-novedades',
    'rrhh-asistencia',
    'rrhh-reportes',
    'crm-catalogo',
    // Módulo Contabilidad
    'accounting-dashboard',
    'accounting-invoices',
    'accounting-expenses',
    'accounting-petty-cash',
    'accounting-payroll',
    'accounting-profitability',
    'accounting-ledger',
    'accounting-taxes',
    'accounting-banks',
    'accounting-fixed-assets',
    'accounting-reports',
    'accounting-budgets',
    'accounting-reconciliation',
    'accounting-closures',
    'accounting-kardex',
    'accounting-costing',
    // Módulo Operaciones
    'ops-inventory',
    'ops-contracts',
    'ops-work-orders',
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
      case 'bitacora-seguridad':
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
      case 'directorio-clientes':
        return 7;
      case 'crm-actividades':
      case 'actividades':
      case 'agenda':
        return 8;

      case 'rrhh-dashboard':
      case 'dashboard-rrhh':
        return 9;

      case 'rrhh-personal':
      case 'rrhhpersonal':
      case 'rrhh-colaboradores':
      case 'colaboradores':
      case 'empleados':
      case 'personal':
      case 'rrhh':
      case 'rrhh-expediente':
      case 'expediente':
      case 'rrhh-postulantes':
      case 'postulantes':
      case 'reclutamiento':
      case 'rrhh-contratacion':
      case 'contratacion':
      case 'rrhh-contrataciones':
      case 'contrataciones':
      case 'contrataciones-en-curso':
      case 'alta':
      case 'directorio':
        return 10;

      case 'rrhh-organizacion':
      case 'organizacion':
      case 'areas':
      case 'cargos':
      case 'especialidades':
      case 'rrhh-turnos':
      case 'turnos':
      case 'horarios':
        return 11;

      case 'rrhh-novedades':
      case 'novedades':
      case 'rrhh-permisos':
      case 'permisos':
      case 'licencias':
      case 'rrhh-vacaciones':
      case 'vacaciones':
      case 'rrhh-disciplina':
      case 'disciplina':
      case 'incidencias':
      case 'memorandums':
      case 'rrhh-bajas':
      case 'bajas':
      case 'desvinculaciones':
      case 'finiquitos':
        return 12;

      case 'rrhh-asistencia':
      case 'rrhh-asistencia-campo':
      case 'asistencia-campo':
      case 'asistencia':
        return 13;

      case 'rrhh-reportes':
      case 'reportes':
      case 'rrhh-novedades-nomina':
      case 'novedades-nomina':
      case 'nomina-rrhh':
      case 'rrhh-bitacora':
      case 'bitacora-rrhh':
      case 'auditoria-rrhh':
      case 'bitacora':
        return 14;

      case 'crm-catalogo':
      case 'catalogo':
      case 'tarifario':
      case 'partidas-crm':
        return 15;

      case 'accounting-dashboard':
      case 'contabilidad':
      case 'accounting':
        return 16;
      case 'accounting-invoices':
      case 'facturas':
      case 'facturacion':
        return 17;
      case 'accounting-expenses':
      case 'egresos':
      case 'gastos':
        return 18;
      case 'accounting-petty-cash':
      case 'caja-chica':
      case 'cajachica':
        return 19;
      case 'accounting-payroll':
      case 'nomina-contabilidad':
      case 'sueldos':
      case 'nomina':
        return 20;
      case 'accounting-profitability':
      case 'rentabilidad':
      case 'margenes':
        return 21;
      case 'accounting-ledger':
      case 'catalogo-de-cuentas':
      case 'catalogo-cuentas':
      case 'libro-mayor':
      case 'asientos':
        return 22;
      case 'accounting-taxes':
      case 'impuestos':
      case 'retenciones':
        return 23;
      case 'accounting-banks':
      case 'bancos':
      case 'bancos-trans':
      case 'cuentas-bancarias':
        return 24;
      case 'accounting-fixed-assets':
      case 'activos-fijos':
      case 'activos':
        return 25;
      case 'accounting-reports':
      case 'reportes-y-morosidad':
      case 'reportes-financieros':
      case 'morosidad':
      case 'estados-financieros':
        return 26;
      case 'accounting-budgets':
      case 'presupuestos':
      case 'partidas':
        return 27;
      case 'accounting-reconciliation':
      case 'conciliacion':
      case 'conciliacion-bancaria':
        return 28;

      case 'accounting-closures':
      case 'cierres':
      case 'cierres-contables':
      case 'cierres-periodo':
        return 32;
      case 'accounting-kardex':
      case 'kardex':
      case 'kardex-valuado':
        return 33;
      case 'accounting-costing':
      case 'costeo-ordenes':
      case 'costeo-ots':
      case 'costeo':
        return 34;

      case 'bajas-y-retiros':
      case 'bajas-activos':
      case 'retiros-activos':
      case 'accounting-disposals':
        return 39;

      case 'configuracion-contable':
      case 'configuracion-activos':
      case 'accounting-config':
        return 37;

      case 'ops-inventory':
      case 'inventario':
      case 'almacen':
      case 'insumos':
        return 29;
      case 'ops-contracts':
      case 'contratos-ops':
      case 'contratos-servicio':
        return 30;
      case 'ops-work-orders':
      case 'ordenes-trabajo':
      case 'ordenes':
      case 'ots':
        return 31;

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
  bool _isAccountingExpanded = true;
  bool _isFixedAssetsExpanded = false;

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
    } else if ((initialIndex >= 16 && initialIndex <= 28) || (initialIndex >= 32 && initialIndex <= 39)) {
      _isAccountingExpanded = true;
      if (initialIndex == 25 || (initialIndex >= 35 && initialIndex <= 39)) _isFixedAssetsExpanded = true;
    } else if (initialIndex >= 29 && initialIndex <= 31) {
      // _isOpsExpanded = true;
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
            if ((newIndex >= 16 && newIndex <= 28) || (newIndex >= 32 && newIndex <= 39)) {
              _isAccountingExpanded = true;
              if (newIndex == 25 || (newIndex >= 35 && newIndex <= 39)) _isFixedAssetsExpanded = true;
            }
            if (newIndex >= 29 && newIndex <= 31) {
              // _isOpsExpanded = true;
            }
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
        } else if ((index >= 16 && index <= 28) || (index >= 32 && index <= 39)) {
          _isAccountingExpanded = true;
          if (index == 25 || (index >= 35 && index <= 39)) _isFixedAssetsExpanded = true;
        } else if (index >= 29 && index <= 31) {
          // _isOpsExpanded = true;
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
    // 6 Entradas Reorganizadas de RRHH
    'RRHH: Dashboard',
    'RRHH: Personal',
    'RRHH: Organización y Turnos',
    'RRHH: Novedades Laborales',
    'RRHH: Asistencia de Campo',
    'RRHH: Reportes y Auditoría',
    'CRM: Catálogo & Tarifario',
    'Contabilidad: Dashboard',
    'Contabilidad: Facturación',
    'Contabilidad: Egresos',
    'Contabilidad: Caja Chica',
    'Contabilidad: Nómina',
    'Contabilidad: Rentabilidad',
    'Contabilidad: Catálogo de Cuentas',
    'Contabilidad: Impuestos',
    'Contabilidad: Bancos / Trans.',
    'Contabilidad: Activos Fijos',
    'Contabilidad: Reportes y Morosidad',
    'Contabilidad: Presupuestos',
    'Contabilidad: Conciliación Bancaria',
    'Operaciones: Inventario / Almacén',
    'Operaciones: Contratos de Servicio',
    'Operaciones: Órdenes de Trabajo',
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
    final isAccountingItem =
        (index >= 16 && index <= 28) || (index >= 32 && index <= 39);
    final isOpsItem = index >= 29 && index <= 31;

    final Color activeAccent = isCrmItem
        ? const Color(0xFF10B981)
        : (isRrhhItem
              ? const Color(0xFF8B5CF6)
              : (isAccountingItem
                    ? const Color(0xFF6366F1)
                    : (isOpsItem
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF2563EB))));
    final Color activeAccentLight = isCrmItem
        ? const Color(0xFF34D399)
        : (isRrhhItem
              ? const Color(0xFFA78BFA)
              : (isAccountingItem
                    ? const Color(0xFF818CF8)
                    : (isOpsItem
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF60A5FA))));
    final Color activeBg = isDark
        ? (isCrmItem
              ? const Color(0xFF10B981).withValues(alpha: 0.12)
              : (isRrhhItem
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                    : (isAccountingItem
                          ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                          : (isOpsItem
                                ? const Color(
                                    0xFFF59E0B,
                                  ).withValues(alpha: 0.12)
                                : const Color(0xFF161F30)))))
        : (isCrmItem
              ? const Color(0xFF10B981).withValues(alpha: 0.08)
              : (isRrhhItem
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.08)
                    : (isAccountingItem
                          ? const Color(0xFF6366F1).withValues(alpha: 0.08)
                          : (isOpsItem
                                ? const Color(
                                    0xFFF59E0B,
                                  ).withValues(alpha: 0.08)
                                : const Color(0xFFF1F5F9)))));

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
        label: 'Dashboard',
        badge: null,
        index: 9,
        isSubItem: false,
      ),
      (
        icon: Icons.badge_outlined,
        selectedIcon: Icons.badge,
        label: 'Personal',
        badge: null,
        index: 10,
        isSubItem: false,
      ),
      (
        icon: Icons.account_tree_outlined,
        selectedIcon: Icons.account_tree,
        label: 'Organización y Turnos',
        badge: null,
        index: 11,
        isSubItem: false,
      ),
      (
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment,
        label: 'Novedades Laborales',
        badge: null,
        index: 12,
        isSubItem: false,
      ),
      (
        icon: Icons.location_on_outlined,
        selectedIcon: Icons.location_on,
        label: 'Asistencia de Campo',
        badge: null,
        index: 13,
        isSubItem: false,
      ),
      (
        icon: Icons.assessment_outlined,
        selectedIcon: Icons.assessment,
        label: 'Reportes y Auditoría',
        badge: null,
        index: 14,
        isSubItem: false,
      ),
    ];

    final isAnyAccountingActive =
        (_selectedIndex >= 16 && _selectedIndex <= 28) ||
        (_selectedIndex >= 32 && _selectedIndex <= 39);
    final accountingItems = [
      (
        icon: Icons.space_dashboard_outlined,
        selectedIcon: Icons.space_dashboard,
        label: 'Dashboard',
        badge: null,
        index: 16,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'Facturación',
        badge: null,
        index: 17,
      ),
      (
        icon: Icons.money_off_outlined,
        selectedIcon: Icons.money_off,
        label: 'Egresos',
        badge: null,
        index: 18,
      ),
      (
        icon: Icons.point_of_sale_outlined,
        selectedIcon: Icons.point_of_sale,
        label: 'Caja Chica',
        badge: null,
        index: 19,
      ),
      (
        icon: Icons.groups_outlined,
        selectedIcon: Icons.groups,
        label: 'Nómina',
        badge: null,
        index: 20,
      ),
      (
        icon: Icons.trending_up_outlined,
        selectedIcon: Icons.trending_up,
        label: 'Rentabilidad',
        badge: null,
        index: 21,
      ),
      (
        icon: Icons.account_tree_outlined,
        selectedIcon: Icons.account_tree,
        label: 'Catálogo de Cuentas',
        badge: null,
        index: 22,
      ),
      (
        icon: Icons.percent_outlined,
        selectedIcon: Icons.percent,
        label: 'Impuestos',
        badge: null,
        index: 23,
      ),
      (
        icon: Icons.account_balance_outlined,
        selectedIcon: Icons.account_balance,
        label: 'Bancos / Trans.',
        badge: null,
        index: 24,
      ),
      (
        icon: Icons.domain_outlined,
        selectedIcon: Icons.domain,
        label: 'Activos Fijos',
        badge: null,
        index: 25,
      ),
      (
        icon: Icons.delete_outline,
        selectedIcon: Icons.delete,
        label: 'Bajas y Retiros',
        badge: null,
        index: 39,
      ),
      (
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: 'Configuración Contable',
        badge: null,
        index: 37,
      ),
      (
        icon: Icons.pie_chart_outline,
        selectedIcon: Icons.pie_chart,
        label: 'Reportes y Morosidad',
        badge: null,
        index: 26,
      ),
      (
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
        label: 'Presupuestos',
        badge: null,
        index: 27,
      ),
      (
        icon: Icons.sync_alt_outlined,
        selectedIcon: Icons.sync_alt,
        label: 'Conciliación Bancaria',
        badge: null,
        index: 28,
      ),
      (
        icon: Icons.lock_clock_outlined,
        selectedIcon: Icons.lock_clock,
        label: 'Cierres y Bloqueos',
        badge: null,
        index: 32,
      ),
      (
        icon: Icons.inventory_outlined,
        selectedIcon: Icons.inventory,
        label: 'Kárdex Valuado',
        badge: null,
        index: 33,
      ),
      (
        icon: Icons.price_check_outlined,
        selectedIcon: Icons.price_check,
        label: 'Costeo de Órdenes (OT)',
        badge: null,
        index: 34,
      ),
    ];

    final isAnyOpsActive = _selectedIndex >= 29 && _selectedIndex <= 31;
    final opsItems = [
      (
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Inventario / Almacén',
        badge: null,
        index: 29,
      ),
      (
        icon: Icons.description_outlined,
        selectedIcon: Icons.description,
        label: 'Contratos de Servicio',
        badge: null,
        index: 30,
      ),
      (
        icon: Icons.assignment_turned_in_outlined,
        selectedIcon: Icons.assignment_turned_in,
        label: 'Órdenes de Trabajo',
        badge: null,
        index: 31,
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
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.dashboard,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 10:
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.personal,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 11:
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.organizacion,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 12:
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.novedades,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 13:
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.asistencia,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 14:
        currentView = RrhhRoutes.buildTopLevelView(
          RrhhRoutes.reportes,
          onNavigateToTab: _onTabSelected,
        );
        break;
      case 15:
        currentView = const CrmCatalogManagementView();
        break;
      case 16:
        currentView = const AccountingDashboardScreen();
        break;
      case 17:
        currentView = const AccountingReceivablesScreen();
        break;
      case 18:
        currentView = const AccountingExpensesScreen();
        break;
      case 19:
        currentView = const AccountingPettyCashScreen();
        break;
      case 20:
        currentView = const AccountingPayrollScreen();
        break;
      case 21:
        currentView = const AccountingProfitabilityScreen();
        break;
      case 22:
        currentView = const AccountingLedgerScreen();
        break;
      case 23:
        currentView = const AccountingTaxesScreen();
        break;
      case 24:
        currentView = const AccountingBanksScreen();
        break;
      case 25:
        currentView = const AccountingFixedAssetsScreen();
        break;
      case 26:
        currentView = const AccountingFinancialStatementsScreen();
        break;
      case 27:
        currentView = const AccountingBudgetsScreen();
        break;
      case 28:
        currentView = const AccountingBankReconciliationScreen();
        break;
      case 29:
        currentView = const OpsInventoryScreen();
        break;
      case 30:
        currentView = const OpsContractsScreen();
        break;
      case 31:
        currentView = const OpsWorkOrdersScreen();
        break;
      case 32:
        currentView = const AccountingPeriodClosureScreen();
        break;
      case 33:
        currentView = const AccountingKardexScreen();
        break;
      case 34:
        currentView = const AccountingWorkOrderCostingScreen();
        break;
      case 35:
        currentView = const AccountingFixedAssetsDepreciationBatchScreen();
        break;
      case 36:
        currentView = const AccountingFixedAssetsRevaluationScreen();
        break;
      case 37:
        currentView = const AccountingFixedAssetsConfigScreen();
        break;
      case 39:
        currentView = const AccountingFixedAssetsDisposalsScreen();
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
                                  : (_selectedIndex >= 16 &&
                                            _selectedIndex <= 28
                                        ? 'Contabilidad'
                                        : (_selectedIndex >= 29 &&
                                                  _selectedIndex <= 31
                                              ? 'Operaciones'
                                              : 'Seguridad'))),
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
                      accountingItems: accountingItems,
                      isAnyAccountingActive: isAnyAccountingActive,
                      opsItems: opsItems,
                      isAnyOpsActive: isAnyOpsActive,
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
              : Stack(
                  children: [
                    Row(
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
                          accountingItems: accountingItems,
                          isAnyAccountingActive: isAnyAccountingActive,
                          opsItems: opsItems,
                          isAnyOpsActive: isAnyOpsActive,
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
                    if (!isMobile)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        top:
                            3, // alineado con el logo en la barra superior (54px de altura)
                        left: _isSidebarCollapsed ? 0 : 248,
                        child: Material(
                          elevation: 3,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          child: InkWell(
                            onTap: () => setState(
                              () => _isSidebarCollapsed = !_isSidebarCollapsed,
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Container(
                              width: 32,
                              height: 48,
                              alignment: Alignment.center,
                              child: Icon(
                                _isSidebarCollapsed
                                    ? Icons.chevron_right
                                    : Icons.chevron_left,
                                size: 20,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
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
        bool isSubItem,
      })
    >
    rrhhItems,

    required bool isAnyRrhhActive,
    required List<
      ({
        IconData icon,
        IconData selectedIcon,
        String label,
        String? badge,
        int index,
      })
    >
    accountingItems,
    required bool isAnyAccountingActive,
    required List<
      ({
        IconData icon,
        IconData selectedIcon,
        String label,
        String? badge,
        int index,
      })
    >
    opsItems,
    required bool isAnyOpsActive,
  }) {
    final collapsed = !isDrawer && _isSidebarCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: isDrawer ? 280 : (collapsed ? 0 : 248),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D111C) : Colors.white,
        border: isDrawer || collapsed
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
                const SizedBox(height: 6),

                // 8. Acordeón Colapsable "Contabilidad"
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_accounting'),
                    onTap: () {
                      setState(() {
                        _isAccountingExpanded = !_isAccountingExpanded;
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
                        color: (isAnyAccountingActive && !_isAccountingExpanded)
                            ? (isDark
                                  ? const Color(0xFF1E1B4B)
                                  : const Color(0xFFEEF2FF))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            (isAnyAccountingActive && !_isAccountingExpanded)
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
                            Icons.monetization_on_outlined,
                            color: isAnyAccountingActive
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
                                      'Contabilidad',
                                      style: GoogleFonts.inter(
                                        color: isAnyAccountingActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnyAccountingActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isAccountingExpanded ? 0.5 : 0.0,
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

                if (_isAccountingExpanded)
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
                        children: [
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Dashboard Contable', index: 16, isSubItem: true, isDrawer: isDrawer)),
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'Facturación y CxC', index: 17, isSubItem: true, isDrawer: isDrawer)),
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.money_off_outlined, selectedIcon: Icons.money_off, label: 'Egresos y CxP', index: 18, isSubItem: true, isDrawer: isDrawer)),
                          
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.account_balance_outlined, selectedIcon: Icons.account_balance, label: 'Bancos & Tesorería', index: 24, isSubItem: true, isDrawer: isDrawer)),

                          // Activos Fijos Accordion
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isFixedAssetsExpanded = !_isFixedAssetsExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.domain_outlined, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Activos Fijos', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500))),
                                  Icon(_isFixedAssetsExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ],
                              ),
                            ),
                          ),
                          if (_isFixedAssetsExpanded)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                children: [
                                  Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, label: 'Catálogo de Activos', index: 25, isSubItem: true, isDrawer: isDrawer)),
                                  Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.calculate_outlined, selectedIcon: Icons.calculate, label: 'Cálculo de Depreciaciones', index: 35, isSubItem: true, isDrawer: isDrawer)),
                                  Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.price_change_outlined, selectedIcon: Icons.price_change, label: 'Revalúos Técnicos', index: 36, isSubItem: true, isDrawer: isDrawer)),
                                  Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.delete_outline, selectedIcon: Icons.delete, label: 'Bajas y Retiros', index: 39, isSubItem: true, isDrawer: isDrawer)),
                                  Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Configuración Contable', index: 37, isSubItem: true, isDrawer: isDrawer)),
                                ],
                              ),
                            ),

                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.bar_chart_outlined, selectedIcon: Icons.bar_chart, label: 'Presupuestos & Flujo', index: 27, isSubItem: true, isDrawer: isDrawer)),
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.insert_chart_outlined, selectedIcon: Icons.insert_chart, label: 'Estados Financieros', index: 26, isSubItem: true, isDrawer: isDrawer)),
                          Padding(padding: const EdgeInsets.only(bottom: 2), child: _buildNavItem(icon: Icons.account_tree_outlined, selectedIcon: Icons.account_tree, label: 'Catálogo de Cuentas', index: 22, isSubItem: true, isDrawer: isDrawer)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 6),

                // 9. Acordeón Colapsable "Operaciones"
                /* Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_ops'),
                    onTap: () {
                      setState(() {
                        _isOpsExpanded = !_isOpsExpanded;
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
                        color: (isAnyOpsActive && !_isOpsExpanded)
                            ? (isDark
                                  ? const Color(0xFF451A03)
                                  : const Color(0xFFFFFBEB))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: (isAnyOpsActive && !_isOpsExpanded)
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFFF59E0B),
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
                            Icons.handyman_outlined,
                            color: isAnyOpsActive
                                ? (isDark
                                      ? const Color(0xFFFBBF24)
                                      : const Color(0xFFD97706))
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
                                      'Operaciones',
                                      style: GoogleFonts.inter(
                                        color: isAnyOpsActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnyOpsActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isOpsExpanded ? 0.5 : 0.0,
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

                if (_isOpsExpanded)
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
                        children: opsItems.map((item) {
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
                  ), */
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
