import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';

class OpsContractsScreen extends StatefulWidget {
  const OpsContractsScreen({super.key});

  @override
  State<OpsContractsScreen> createState() => _OpsContractsScreenState();
}

class _OpsContractsScreenState extends State<OpsContractsScreen> {
  bool _isLoading = true;
  List<OpsServiceContract> _contracts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final contracts = await client.ops.getContracts();
      if (!mounted) return;
      setState(() {
        _contracts = contracts;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _completeContract(OpsServiceContract contract) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Finalizar Contrato'),
        content: Text(
          '¿Finalizar el contrato #${contract.id}? Esta acción cambiará su estado a Completado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await client.ops.completeContract(contract.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contrato finalizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al finalizar: $e')));
    }
  }

  Future<void> _cancelContract(OpsServiceContract contract) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar Contrato'),
        content: Text(
          '¿Cancelar el contrato #${contract.id}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Volver'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancelar Contrato'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await client.ops.cancelContract(contract.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contrato cancelado'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cancelar: $e')));
    }
  }

  void _showAddDialog() {
    final customerIdController = TextEditingController();
    final totalAmountController = TextEditingController();
    String serviceType = 'Limpieza';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo Contrato'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID del Cliente',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: serviceType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Servicio',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Limpieza',
                      child: Text('Limpieza'),
                    ),
                    DropdownMenuItem(
                      value: 'Mantenimiento',
                      child: Text('Mantenimiento'),
                    ),
                    DropdownMenuItem(
                      value: 'FumigaciÃ³n',
                      child: Text('FumigaciÃ³n'),
                    ),
                    DropdownMenuItem(
                      value: 'Seguridad',
                      child: Text('Seguridad'),
                    ),
                  ],
                  onChanged: (val) => setDialogState(() => serviceType = val!),
                ),
                TextField(
                  controller: totalAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Monto Total (Bs)',
                  ),
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
                final customerId =
                    int.tryParse(customerIdController.text.trim()) ?? 0;
                final amount =
                    double.tryParse(totalAmountController.text.trim()) ?? 0.0;
                if (customerId > 0 && amount > 0) {
                  final now = DateTime.now();
                  await client.ops.createOrUpdateContract(
                    OpsServiceContract(
                      customerId: customerId,
                      serviceType: serviceType,
                      startDate: now,
                      totalAmount: amount,
                      status: 'Activo',
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

  Widget _buildMobileCard(OpsServiceContract item, ThemeData theme) {
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
                      Icon(
                        Icons.assignment_ind,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Contrato #${item.id ?? 'N/A'} - Cliente ${item.customerId}',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.status == 'Activo'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.status == 'Activo'
                          ? Colors.green
                          : Colors.orange,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.serviceType,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Inicio',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(item.startDate),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                      'Monto Total',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${item.totalAmount.toStringAsFixed(2)} Bs',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      color: Colors.green,
                      onPressed: item.status == 'Completado'
                          ? null
                          : () => _completeContract(item),
                      tooltip: 'Finalizar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      color: Colors.red,
                      onPressed: item.status == 'Cancelado'
                          ? null
                          : () => _cancelContract(item),
                      tooltip: 'Cancelar',
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
        title: const Text('Contratos de Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Nuevo Contrato',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contracts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: theme.disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay contratos activos',
                    style: TextStyle(color: theme.disabledColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddDialog,
                    child: const Text('Crear Primer Contrato'),
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
                    itemCount: _contracts.length,
                    itemBuilder: (context, index) {
                      return _buildMobileCard(_contracts[index], theme);
                    },
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 180,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _contracts.length,
                  itemBuilder: (context, index) {
                    return _buildMobileCard(_contracts[index], theme);
                  },
                );
              },
            ),
    );
  }
}
