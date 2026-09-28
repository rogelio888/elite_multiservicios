import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';

class HrEmployeesScreen extends StatefulWidget {
  const HrEmployeesScreen({super.key});

  @override
  State<HrEmployeesScreen> createState() => _HrEmployeesScreenState();
}

class _HrEmployeesScreenState extends State<HrEmployeesScreen> {
  bool _isLoading = true;
  List<HrEmployee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final employees = await client.hr.getEmployees();
      if (!mounted) return;
      setState(() {
        _employees = employees;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final positionController = TextEditingController();
    final salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo Empleado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre Completo'),
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Cargo'),
                ),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(labelText: 'Salario Base (Bs)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final position = positionController.text.trim();
                final salary = double.tryParse(salaryController.text.trim()) ?? 0.0;
                
                if (name.isNotEmpty && position.isNotEmpty && salary >= 0) {
                  final now = DateTime.now();
                  await client.hr.createOrUpdateEmployee(
                    HrEmployee(
                      name: name,
                      position: position,
                      baseSalary: salary,
                      joinDate: now,
                      isActive: true,
                      createdAt: now,
                      updatedAt: now,
                    ),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCard(HrEmployee item, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    item.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.position,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: item.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salario Base',
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                    ),
                    Text(
                      '${item.baseSalary.toStringAsFixed(2)} Bs',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Ingreso',
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(item.joinDate),
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('GestiÃ³n de Personal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddDialog,
            tooltip: 'Nuevo Empleado',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('No hay empleados registrados', style: TextStyle(color: theme.disabledColor)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddDialog,
                        child: const Text('Registrar Primer Empleado'),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    
                    if (isMobile) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _employees.length,
                        itemBuilder: (context, index) {
                          return _buildMobileCard(_employees[index], theme);
                        },
                      );
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 160,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _employees.length,
                      itemBuilder: (context, index) {
                        return _buildMobileCard(_employees[index], theme);
                      },
                    );
                  },
                ),
    );
  }
}

