import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Control de Accesos Basado en Roles (RBAC)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gestión de roles y asignación granular de permisos a nivel de base de datos',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de Roles (Izquierda)
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          'Roles Registrados (${_roles.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      if (_roles.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Text('No hay roles configurados.'),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _roles.length,
                          itemBuilder: (context, index) {
                            final role = _roles[index];
                            final isSelected = _selectedRole?.id == role.id;

                            return ListTile(
                              selected: isSelected,
                              selectedTileColor: const Color(
                                0xFF1E3A8A,
                              ).withValues(alpha: 0.08),
                              title: Text(
                                role.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF1E3A8A)
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                role.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: role.isSystemRole
                                  ? const StatusBadge(
                                      label: 'Sistema',
                                      variant: BadgeVariant.info,
                                    )
                                  : null,
                              onTap: () => setState(() => _selectedRole = role),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // Catálogo de Permisos Granulares (Derecha)
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedRole != null
                                      ? 'Permisos: ${_selectedRole!.name}'
                                      : 'Permisos del Sistema',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Catálogo canónico de operaciones protegidas',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            StatusBadge(
                              label: '${_permissions.length} permisos',
                              variant: BadgeVariant.neutral,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      if (_permissions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Text('No hay permisos registrados.'),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _permissions.length,
                          separatorBuilder: (ctx, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final perm = _permissions[index];
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4F46E5,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.vpn_key_outlined,
                                  size: 16,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                              title: Text(
                                perm.code,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              subtitle: Text(
                                perm.description,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: StatusBadge(
                                label: perm.module.toUpperCase(),
                                variant: BadgeVariant.info,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
