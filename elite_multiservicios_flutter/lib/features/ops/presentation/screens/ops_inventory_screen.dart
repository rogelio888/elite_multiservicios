import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';

class OpsInventoryScreen extends StatefulWidget {
  const OpsInventoryScreen({super.key});

  @override
  State<OpsInventoryScreen> createState() => _OpsInventoryScreenState();
}

class _OpsInventoryScreenState extends State<OpsInventoryScreen> {
  bool _isLoading = true;
  List<OpsInventoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await client.ops.getInventory();
      if (!mounted) return;
      setState(() {
        _items = items;
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
    final descriptionController = TextEditingController();
    String unit = 'Unidad';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuevo Artículo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre del Artículo'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción (Opcional)'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: unit,
                  decoration: const InputDecoration(labelText: 'Unidad de Medida'),
                  items: const [
                    DropdownMenuItem(value: 'Unidad', child: Text('Unidad')),
                    DropdownMenuItem(value: 'Litro', child: Text('Litro')),
                    DropdownMenuItem(value: 'Galón', child: Text('Galón')),
                    DropdownMenuItem(value: 'Kg', child: Text('Kilogramo')),
                    DropdownMenuItem(value: 'Caja', child: Text('Caja')),
                  ],
                  onChanged: (val) => setDialogState(() => unit = val!),
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
                if (name.isNotEmpty) {
                  final now = DateTime.now();
                  await client.ops.createOrUpdateItem(
                    OpsInventoryItem(
                      name: name,
                      description: descriptionController.text.trim(),
                      unit: unit,
                      quantityInStock: 0,
                      averageCost: 0,
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

  Widget _buildMobileCard(OpsInventoryItem item, ThemeData theme) {
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
                  child: Text(
                    item.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.quantityInStock <= 5
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${item.quantityInStock} ${item.unit}',
                    style: TextStyle(
                      color: item.quantityInStock <= 5 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (item.description != null && item.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.description!,
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Costo Promedio',
                      style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12),
                    ),
                    Text(
                      '${item.averageCost.toStringAsFixed(2)} Bs',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      color: theme.colorScheme.primary,
                      onPressed: () {},
                      tooltip: 'Registrar Entrada',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_shopping_cart, size: 20),
                      color: Colors.orange,
                      onPressed: () {},
                      tooltip: 'Registrar Salida',
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
        title: const Text('Almacén e Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Nuevo Artículo',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('No hay artículos en el inventario',
                          style: TextStyle(color: theme.disabledColor)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddDialog,
                        child: const Text('Crear Primer Artículo'),
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
                        itemCount: _items.length,
                        itemBuilder: (context, index) =>
                            _buildMobileCard(_items[index], theme),
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
                      itemCount: _items.length,
                      itemBuilder: (context, index) =>
                          _buildMobileCard(_items[index], theme),
                    );
                  },
                ),
    );
  }
}
