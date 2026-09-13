import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../services/security_api_service.dart';

/// Metadata de presentación para humanizar los permisos canónicos de la base de datos
class _PermissionMeta {
  final String title;
  final String friendlyDescription;
  final IconData icon;

  const _PermissionMeta({
    required this.title,
    required this.friendlyDescription,
    required this.icon,
  });
}

class RolesRbacView extends StatefulWidget {
  const RolesRbacView({super.key});

  @override
  State<RolesRbacView> createState() => _RolesRbacViewState();
}

class _RolesRbacViewState extends State<RolesRbacView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<AppRole> _roles = [];
  List<AppPermission> _permissions = [];
  AppRole? _selectedRole;

  String _searchQuery = '';
  String _selectedModuleFilter = 'todos';
  final _searchController = TextEditingController();

  static final Map<String, _PermissionMeta> _metaMap = {
    'users.view': const _PermissionMeta(
      title: 'Consultar Directorio de Usuarios',
      friendlyDescription:
          'Visualización de perfiles, roles asignados y estados de colaboradores.',
      icon: Icons.people_outline,
    ),
    'users.create': const _PermissionMeta(
      title: 'Registrar Nuevos Usuarios',
      friendlyDescription:
          'Aprovisionamiento de cuentas e inicio de credenciales corporativas.',
      icon: Icons.person_add_outlined,
    ),
    'users.update': const _PermissionMeta(
      title: 'Modificar Cuentas de Usuarios',
      friendlyDescription:
          'Edición de información de perfil, nombres y configuraciones de cuenta.',
      icon: Icons.manage_accounts_outlined,
    ),
    'users.disable': const _PermissionMeta(
      title: 'Suspender / Desactivar Cuentas',
      friendlyDescription:
          'Pausado preventivo de acceso al sistema sin borrado definitivo.',
      icon: Icons.pause_circle_outline,
    ),
    'users.delete': const _PermissionMeta(
      title: 'Dar de Baja Usuarios',
      friendlyDescription:
          'Revocación definitiva y eliminación permanente de identidades.',
      icon: Icons.person_remove_outlined,
    ),
    'roles.view': const _PermissionMeta(
      title: 'Visualizar Matriz de Roles',
      friendlyDescription:
          'Inspección de roles existentes, jerarquías y políticas de acceso.',
      icon: Icons.admin_panel_settings_outlined,
    ),
    'roles.manage': const _PermissionMeta(
      title: 'Gestionar Políticas de Roles',
      friendlyDescription:
          'Creación, parametrización y mutación de perfiles RBAC del sistema.',
      icon: Icons.shield_outlined,
    ),
    'permissions.view': const _PermissionMeta(
      title: 'Consultar Catálogo de Privilegios',
      friendlyDescription:
          'Auditoría y revisión de vectores de operaciones protegidas.',
      icon: Icons.key_outlined,
    ),
    'permissions.assign': const _PermissionMeta(
      title: 'Asignar Privilegios a Roles',
      friendlyDescription:
          'Vinculación y delegación granular de capacidades operativas.',
      icon: Icons.assignment_turned_in_outlined,
    ),
    'audit.view': const _PermissionMeta(
      title: 'Consultar Bitácora de Auditoría',
      friendlyDescription:
          'Acceso al registro inmutable de transacciones e IPs de origen.',
      icon: Icons.history_edu_outlined,
    ),
    'audit.export': const _PermissionMeta(
      title: 'Exportar Registros de Auditoría',
      friendlyDescription:
          'Generación y descarga forense de la bitácora en formatos estándar.',
      icon: Icons.download_outlined,
    ),
    'sessions.view': const _PermissionMeta(
      title: 'Monitoreo de Sesiones Activas',
      friendlyDescription:
          'Supervisión de dispositivos conectados, IPs y tokens en tiempo real.',
      icon: Icons.devices_outlined,
    ),
    'sessions.revoke': const _PermissionMeta(
      title: 'Revocación Forzosa de Sesiones',
      friendlyDescription:
          'Terminación inmediata de sesiones activas y expulsión de tokens.',
      icon: Icons.power_settings_new_outlined,
    ),
    'metrics.view': const _PermissionMeta(
      title: 'Telemetría y Métricas del Servidor',
      friendlyDescription:
          'Inspección de tiempos de respuesta, carga de memoria y sockets.',
      icon: Icons.analytics_outlined,
    ),
    'system.maintenance': const _PermissionMeta(
      title: 'Mantenimiento y Gobernanza',
      friendlyDescription:
          'Operaciones globales de integridad y parámetros de seguridad del núcleo.',
      icon: Icons.settings_suggest_outlined,
    ),
  };

  _PermissionMeta _getMeta(AppPermission perm) {
    return _metaMap[perm.code] ??
        _PermissionMeta(
          title: perm.code,
          friendlyDescription: perm.description,
          icon: Icons.lock_outline,
        );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final roles = await _service.listRoles();
      final permissions = await _service.listPermissions();

      if (mounted) {
        setState(() {
          _roles = roles;
          _permissions = permissions;
          if (_roles.isNotEmpty) {
            _selectedRole = _roles.first;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<AppPermission> get _filteredPermissions {
    return _permissions.where((perm) {
      final meta = _getMeta(perm);
      final query = _searchQuery.toLowerCase().trim();

      final matchesQuery =
          query.isEmpty ||
          perm.code.toLowerCase().contains(query) ||
          meta.title.toLowerCase().contains(query) ||
          meta.friendlyDescription.toLowerCase().contains(query) ||
          perm.module.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_selectedModuleFilter == 'todos') return true;
      if (_selectedModuleFilter == 'roles') {
        return perm.module == 'roles' || perm.module == 'permissions';
      }
      return perm.module.toLowerCase() == _selectedModuleFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando políticas RBAC...',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1050;
        final isNarrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 32,
            vertical: isNarrow ? 20 : 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Ejecutiva Minimalista
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 24),

              // 2. Paneles de Roles y Permisos (Asimétrico 36 / 64)
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 36,
                      child: _buildRolesPanel(isDark),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 64,
                      child: _buildPermissionsCatalog(isDark),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildRolesPanel(isDark),
                    const SizedBox(height: 24),
                    _buildPermissionsCatalog(isDark),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // --- CABECERA EJECUTIVA ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final infoCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: [
            Text(
              'Roles & Políticas RBAC',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 18 : 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                '${_roles.length} roles • ${_permissions.length} privilegios',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Gobernanza de identidades corporativas, matriz de privilegios y control de acceso granular.',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 12.5 : 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final refreshBtn = OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark
            ? const Color(0xFFCBD5E1)
            : const Color(0xFF475569),
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _loadData,
      icon: const Icon(Icons.refresh, size: 15),
      label: Text(
        'Actualizar',
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 24,
        vertical: isNarrow ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoCol,
                const SizedBox(height: 14),
                refreshBtn,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoCol),
                const SizedBox(width: 16),
                refreshBtn,
              ],
            ),
    );
  }

  // --- PANEL IZQUIERDO: DIRECTORIO DE ROLES ---
  Widget _buildRolesPanel(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Directorio de Roles',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_roles.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 16),

          if (_roles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No hay roles configurados.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            )
          else
            ..._roles.map((role) {
              final isSelected = _selectedRole?.id == role.id;
              return _buildRoleCard(role, isSelected, isDark);
            }),

          const SizedBox(height: 12),
          // Nota sobria de integridad RBAC
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Los roles de tipo Sistema disponen de protección contra eliminación para garantizar la gobernanza del entorno.',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(AppRole role, bool isSelected, bool isDark) {
    final borderColor = isSelected
        ? const Color(0xFF2563EB)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
    final bgColor = isSelected
        ? (isDark
              ? const Color(0xFF1E293B).withValues(alpha: 0.4)
              : const Color(0xFFEFF6FF))
        : (isDark
              ? const Color(0xFF0B1120).withValues(alpha: 0.6)
              : const Color(0xFFF8FAFC));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedRole = role),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              role.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
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
                    if (role.isSystemRole)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'SISTEMA',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF475569),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  role.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                // Cobertura de permisos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cobertura de privilegios',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      '${_permissions.length} / ${_permissions.length}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    minHeight: 3,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- PANEL DERECHO: CATÁLOGO DE PERMISOS ---
  Widget _buildPermissionsCatalog(bool isDark) {
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final filtered = _filteredPermissions;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del catálogo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedRole != null
                          ? 'Privilegios Asignados • ${_selectedRole!.name}'
                          : 'Catálogo de Privilegios',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Operaciones y capacidades autorizadas para esta jerarquía de usuario.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${filtered.length} de ${_permissions.length}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Buscador rápido
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText:
                    'Buscar permiso por código o nombre (ej: users.create, auditoría)...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 17,
                  color: Color(0xFF64748B),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 15),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filtros de módulo tipo segmented tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('todos', 'Todos', _permissions.length, isDark),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'users',
                  'Usuarios',
                  _permissions.where((p) => p.module == 'users').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'roles',
                  'Roles & RBAC',
                  _permissions
                      .where(
                        (p) => p.module == 'roles' || p.module == 'permissions',
                      )
                      .length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'audit',
                  'Auditoría',
                  _permissions.where((p) => p.module == 'audit').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'sessions',
                  'Sesiones',
                  _permissions.where((p) => p.module == 'sessions').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'metrics',
                  'Métricas',
                  _permissions.where((p) => p.module == 'metrics').length,
                  isDark,
                ),
                const SizedBox(width: 6),
                _buildFilterPill(
                  'system',
                  'Sistema',
                  _permissions.where((p) => p.module == 'system').length,
                  isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 14),

          // Lista de tarjetas de permisos
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off_outlined,
                      size: 32,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No se encontraron permisos para "$_searchQuery"',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _selectedModuleFilter = 'todos';
                        });
                      },
                      child: Text(
                        'Restablecer filtros',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final perm = filtered[index];
                return _buildPermissionCard(perm, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    String filterKey,
    String label,
    int count,
    bool isDark,
  ) {
    final isSelected = _selectedModuleFilter == filterKey;
    final activeBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final inactiveBg = isDark
        ? const Color(0xFF0B1120)
        : const Color(0xFFF8FAFC);
    final borderColor = isSelected
        ? (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1))
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedModuleFilter = filterKey),
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? (isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155))
                      : (isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(AppPermission perm, bool isDark) {
    final meta = _getMeta(perm);
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              meta.icon,
              size: 16,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        meta.title,
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
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        perm.code,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  meta.friendlyDescription,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Tooltip(
            message: 'Privilegio canónico activo según política RBAC.',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                  Text(
                    'Activo',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
