import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'views/security_dashboard_view.dart';
import 'views/users_management_view.dart';
import 'views/roles_rbac_view.dart';
import 'views/audit_log_view.dart';
import 'views/active_sessions_view.dart';

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
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 22),
            SizedBox(width: 10),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar tu sesión actual? '
          'La sesión se revocará en el servidor y se registrará en la bitácora de auditoría.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cerrar Sesión'),
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      (Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
      (Icons.people_outline, Icons.people, 'Usuarios'),
      (Icons.security_outlined, Icons.security, 'Roles & RBAC'),
      (Icons.history_edu_outlined, Icons.history_edu, 'Auditoría'),
      (Icons.devices_outlined, Icons.devices, 'Sesiones'),
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
      default:
        currentView = const Center(child: Text('Vista no encontrada'));
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Corporativo
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSidebarCollapsed ? 80 : 260,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF334155),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      if (!_isSidebarCollapsed) ...[
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ELITE MULTISERVICIOS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                'Módulo de Seguridad',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 16),

                // Elementos de Navegación
                Expanded(
                  child: ListView.builder(
                    itemCount: navItems.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final item = navItems[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => setState(() => _selectedIndex = index),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(
                                        0xFF3B82F6,
                                      ).withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(
                                          0xFF3B82F6,
                                        ).withValues(alpha: 0.5),
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? item.$2 : item.$1,
                                    color: isSelected
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF94A3B8),
                                    size: 20,
                                  ),
                                  if (!_isSidebarCollapsed) ...[
                                    const SizedBox(width: 14),
                                    Text(
                                      item.$3,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFFCBD5E1),
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
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

                // Botón de Cerrar Sesión en Sidebar
                const Divider(color: Color(0xFF334155), height: 1),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                  title: _isSidebarCollapsed
                      ? null
                      : const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onTap: _confirmAndLogout,
                ),

                // Botón para colapsar Sidebar
                ListTile(
                  dense: true,
                  leading: Icon(
                    _isSidebarCollapsed
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    color: const Color(0xFF94A3B8),
                    size: 16,
                  ),
                  title: _isSidebarCollapsed
                      ? null
                      : const Text(
                          'Colapsar Menú',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                  onTap: () => setState(
                    () => _isSidebarCollapsed = !_isSidebarCollapsed,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Área de Trabajo Principal
          Expanded(
            child: Column(
              children: [
                // Barra Superior
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _titles[_selectedIndex],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              widget.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                            ),
                            tooltip: 'Cambiar Tema',
                            onPressed: widget.onToggleTheme,
                          ),
                          const SizedBox(width: 8),
                          if (_authService.currentUser != null) ...[
                            Text(
                              _authService.currentDisplayName ?? 'Usuario',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFF1E3A8A),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            tooltip: 'Cerrar Sesión',
                            onPressed: _confirmAndLogout,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contenido de la Vista
                Expanded(child: currentView),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
