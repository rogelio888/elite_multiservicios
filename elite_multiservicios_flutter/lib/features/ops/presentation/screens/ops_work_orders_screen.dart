import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';

class OpsWorkOrdersScreen extends StatefulWidget {
  const OpsWorkOrdersScreen({super.key});

  @override
  State<OpsWorkOrdersScreen> createState() => _OpsWorkOrdersScreenState();
}

class _OpsWorkOrdersScreenState extends State<OpsWorkOrdersScreen> {
  bool _isLoading = true;
  List<OpsWorkOrder> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final orders = await client.ops.getWorkOrders(DateTime.now());
      if (!mounted) return;
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final contractIdController = TextEditingController();
    final employeeIdController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nueva Orden de Trabajo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contractIdController,
                  decoration: const InputDecoration(labelText: 'ID del Contrato'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: employeeIdController,
                  decoration: const InputDecoration(labelText: 'ID del Empleado (Opcional)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas / Observaciones'),
                  maxLines: 2,
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
                final contractId = int.tryParse(contractIdController.text.trim()) ?? 0;
                final employeeId = int.tryParse(employeeIdController.text.trim());
                if (contractId > 0) {
                  final now = DateTime.now();
                  await client.ops.createOrUpdateWorkOrder(
                    OpsWorkOrder(
                      contractId: contractId,
                      date: now,
                      assignedEmployeeId: employeeId,
                      status: 'Pendiente',
                      notes: notesController.text.trim(),
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

  Widget _buildMobileCard(OpsWorkOrder item, ThemeData theme) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.build_circle, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'OT #${item.id ?? 'N/A'} - Contrato #${item.contractId}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status == 'Pendiente'
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.status == 'Pendiente' ? Colors.orange : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (item.assignedEmployeeId != null) ...[
                  Icon(Icons.person_outline, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text(
                    'Emp ID: ${item.assignedEmployeeId}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Fecha de Trabajo',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(item.date),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'Notas:',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                item.notes!,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.inventory_2_outlined, size: 20),
                  color: Colors.blue,
                  onPressed: () {
                    // TODO: Implement Inventory Usage for this Work Order
                  },
                  tooltip: 'Asignar Insumos',
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  color: Colors.green,
                  onPressed: () {
                    // TODO: Implement Complete
                  },
                  tooltip: 'Completar Orden',
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
        title: const Text('Ã“rdenes de Trabajo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Nueva Orden',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.build_outlined, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('No hay Ã³rdenes de trabajo', style: TextStyle(color: theme.disabledColor)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddDialog,
                        child: const Text('Crear Orden de Trabajo'),
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
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return _buildMobileCard(_orders[index], theme);
                        },
                      );
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return _buildMobileCard(_orders[index], theme);
                      },
                    );
                  },
                ),
    );
  }
}

