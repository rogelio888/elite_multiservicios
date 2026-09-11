import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../widgets/status_badge.dart';
import '../../services/security_api_service.dart';

class UsersManagementView extends StatefulWidget {
  const UsersManagementView({super.key});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  final _service = SecurityApiService();
  bool _isLoading = true;
  List<AppUser> _users = [];
  List<AppRole> _availableRoles = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final users = await _service.listUsers();
      final roles = await _service.listRoles();

      if (mounted) {
        setState(() {
          _users = users;
          _availableRoles = roles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor: $e')),
        );
      }
    }
  }

  void _showCreateUserDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final selectedRoleIds = <int>{};

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Crear Nuevo Colaborador'),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico Corporativo',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Asignar Roles Iniciales (RBAC)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  if (_availableRoles.isEmpty)
                    const Text(
                      'No hay roles disponibles en el sistema.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      children: _availableRoles.map((role) {
                        final isSelected = selectedRoleIds.contains(role.id);
                        return FilterChip(
                          label: Text(role.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                if (role.id != null) {
                                  selectedRoleIds.add(role.id!);
                                }
                              } else {
                                selectedRoleIds.remove(role.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      nameController.text.isEmpty) {
                    return;
                  }
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(dialogCtx);
                  try {
                    await _service.createUser(
                      email: emailController.text.trim(),
                      fullName: nameController.text.trim(),
                      roleIds: selectedRoleIds.toList(),
                    );
                    _loadData();
                    if (mounted) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Usuario registrado con éxito.'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Error al crear usuario: $e')),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredUsers = _users.where((u) {
      final q = _searchQuery.toLowerCase();
      return u.fullName.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y botón de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestión de Usuarios',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Administración de cuentas, roles asignados y estados de acceso',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: _showCreateUserDialog,
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Nuevo Usuario'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Barra de Búsqueda y Filtros
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o correo corporativo...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: theme.cardTheme.color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tabla de Usuarios
          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : filteredUsers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('No se encontraron usuarios registrados.'),
                        ],
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        horizontalMargin: 20,
                        columns: const [
                          DataColumn(label: Text('Usuario')),
                          DataColumn(label: Text('Correo')),
                          DataColumn(label: Text('Estado')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: const Color(
                                        0xFF1E3A8A,
                                      ).withValues(alpha: 0.1),
                                      child: Text(
                                        user.fullName.isNotEmpty
                                            ? user.fullName[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(user.email)),
                              DataCell(
                                StatusBadge(
                                  label: user.isActive ? 'Activo' : 'Inactivo',
                                  variant: user.isActive
                                      ? BadgeVariant.success
                                      : BadgeVariant.neutral,
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        user.isActive
                                            ? Icons.toggle_on
                                            : Icons.toggle_off,
                                        color: user.isActive
                                            ? const Color(0xFF059669)
                                            : Colors.grey,
                                      ),
                                      tooltip: user.isActive
                                          ? 'Desactivar'
                                          : 'Activar',
                                      onPressed: () async {
                                        if (user.id == null) return;
                                        await _service.setUserActive(
                                          id: user.id!,
                                          isActive: !user.isActive,
                                        );
                                        _loadData();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Borrado Lógico',
                                      onPressed: () async {
                                        if (user.id == null) return;
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                              'Confirmar Eliminación',
                                            ),
                                            content: Text(
                                              '¿Desea dar de baja a ${user.fullName}?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text('Cancelar'),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                child: const Text(
                                                  'Dar de Baja',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await _service.deleteUser(user.id!);
                                          _loadData();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
