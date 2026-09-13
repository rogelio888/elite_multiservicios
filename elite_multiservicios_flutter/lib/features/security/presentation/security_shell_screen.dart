import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'views/security_dashboard_view.dart';
import 'views/users_management_view.dart';
import 'views/roles_rbac_view.dart';
import 'views/audit_log_view.dart';
import 'views/active_sessions_view.dart';
import 'views/server_metrics_view.dart';

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
  late final AuthService _authService;
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
  }

  Future<void> _confirmAndLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: GoogleFonts.hankenGrotesk(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: widget.isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar tu sesión actual? '
          'La sesión se revocará en el servidor y se registrará en la bitácora de auditoría.',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            color: widget.isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.hankenGrotesk(
                color: widget.isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Cerrar Sesión',
              style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700),
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
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final navItems = [
      (Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', null),
      (Icons.group_outlined, Icons.group, 'Usuarios', '12'),
      (Icons.admin_panel_settings_outlined, Icons.admin_panel_settings, 'Roles & RBAC', '4'),
      (Icons.history_edu_outlined, Icons.history_edu, 'Auditoría', 'dot'),
      (Icons.devices_outlined, Icons.devices, 'Sesiones', '3 vivas'),
      (Icons.analytics_outlined, Icons.analytics, 'Métricas', null),
    ];

    Widget currentView;
    switch (_selectedIndex) {
      case 0:
        currentView = SecurityDashboardView(
          onNavigateToTab: (idx) => setState(() => _selectedIndex = idx),
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
      default:
        currentView = const Center(child: Text('Vista no encontrada'));
    }

    final userEmail = _authService.currentDisplayName ?? 'admin@elitemultiservicios.com';
    final userInitials = userEmail.isNotEmpty && userEmail.length >= 2
        ? userEmail.substring(0, 2).toUpperCase()
        : 'AD';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF080D1A) : const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Sidebar de Navegación Completo (#0B1120)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSidebarCollapsed ? 76 : 260,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFF0F172A),
              border: Border(
                right: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFF334155),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding Header
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF080D1A).withValues(alpha: 0.6)
                        : const Color(0xFF0A0F1D),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF60A5FA).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      if (!_isSidebarCollapsed) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ELITE MULTISERVICIOS',
                                style: GoogleFonts.hankenGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.6,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF34D399),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Módulo de Seguridad',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: const Color(0xFF60A5FA),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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

                const SizedBox(height: 12),
                if (!_isSidebarCollapsed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: Text(
                      'OPERACIONES PRINCIPALES',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                // Lista de Navegación
                Expanded(
                  child: ListView.builder(
                    itemCount: navItems.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    itemBuilder: (context, index) {
                      final item = navItems[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _selectedIndex = index),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: _isSidebarCollapsed ? 12 : 14,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF60A5FA).withValues(alpha: 0.4),
                                      )
                                    : Border.all(color: Colors.transparent),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? item.$2 : item.$1,
                                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                                    size: 19,
                                  ),
                                  if (!_isSidebarCollapsed) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.$3,
                                        style: GoogleFonts.hankenGrotesk(
                                          color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (item.$4 != null) ...[
                                      if (item.$4 == 'dot')
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF59E0B),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFF59E0B),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withValues(alpha: 0.2)
                                                : (item.$4!.contains('vivas')
                                                    ? const Color(0xFF064E3B).withValues(alpha: 0.6)
                                                    : const Color(0xFF1E293B)),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white.withValues(alpha: 0.3)
                                                  : (item.$4!.contains('vivas')
                                                      ? const Color(0xFF10B981).withValues(alpha: 0.4)
                                                      : const Color(0xFF334155)),
                                            ),
                                          ),
                                          child: Text(
                                            item.$4!,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : (item.$4!.contains('vivas')
                                                      ? const Color(0xFF34D399)
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
                        ),
                      );
                    },
                  ),
                ),

                // Footer Actions: Cerrar Sesión & Colapsar Menú
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF080D1A).withValues(alpha: 0.7)
                        : const Color(0xFF0A0F1D),
                    border: Border(
                      top: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFF334155),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _confirmAndLogout,
                          borderRadius: BorderRadius.circular(10),
                          hoverColor: Colors.redAccent.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Color(0xFFF87171),
                                  size: 18,
                                ),
                                if (!_isSidebarCollapsed) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    'Cerrar Sesión',
                                    style: GoogleFonts.hankenGrotesk(
                                      color: const Color(0xFFF87171),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  _isSidebarCollapsed
                                      ? Icons.chevron_right
                                      : Icons.chevron_left,
                                  color: const Color(0xFF94A3B8),
                                  size: 18,
                                ),
                                if (!_isSidebarCollapsed) ...[
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Colapsar Menú',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFF334155)),
                                    ),
                                    child: Text(
                                      'Ctrl+B',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 9,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Área de Trabajo Principal y Top App Bar
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1120).withValues(alpha: 0.8)
                        : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Breadcrumb
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Seguridad',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 13,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '/',
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _titles[_selectedIndex],
                                style: GoogleFonts.hankenGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Top Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Theme Toggle Button
                          IconButton(
                            icon: Icon(
                              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                              color: widget.isDarkMode
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF475569),
                              size: 20,
                            ),
                            tooltip: 'Cambiar Tema',
                            onPressed: widget.onToggleTheme,
                          ),
                          const SizedBox(width: 4),

                          // Notification Bell
                          IconButton(
                            icon: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                  size: 20,
                                ),
                                Positioned(
                                  top: -1,
                                  right: -1,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF3B82F6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            tooltip: 'Notificaciones',
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),

                          Container(
                            height: 24,
                            width: 1,
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          ),
                          const SizedBox(width: 12),

                          // User Identity Pill
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        userInitials,
                                        style: GoogleFonts.jetBrainsMono(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -1,
                                    right: -1,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDark ? const Color(0xFF0B1120) : Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 130),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Usuario',
                                      style: GoogleFonts.hankenGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    Text(
                                      userEmail,
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 10,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Direct Logout Action
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Color(0xFFF87171),
                              size: 18,
                            ),
                            tooltip: 'Cerrar Sesión',
                            onPressed: _confirmAndLogout,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contenido de la Vista Principal
                Expanded(
                  child: currentView,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
