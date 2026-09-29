import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingFixedAssetsScreen extends ConsumerWidget {
  const AccountingFixedAssetsScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final lifeController = TextEditingController();
    String category = 'Vehículos';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Activo Fijo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Activo (Ej. Camioneta)',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Vehículos',
                      child: Text('Vehículos'),
                    ),
                    DropdownMenuItem(
                      value: 'Equipos',
                      child: Text('Equipos/Maquinaria'),
                    ),
                    DropdownMenuItem(
                      value: 'Mobiliario',
                      child: Text('Mobiliario de Oficina'),
                    ),
                  ],
                  onChanged: (val) => setDialogState(() => category = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor de Compra (Bs)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lifeController,
                  decoration: const InputDecoration(
                    labelText: 'Vida Útil (Meses)',
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
                final val = double.tryParse(valueController.text) ?? 0;
                final life = int.tryParse(lifeController.text) ?? 0;
                if (val > 0 && life > 0 && nameController.text.isNotEmpty) {
                  try {
                    await ref
                        .read(accountingRepositoryProvider)
                        .createFixedAsset(
                          AccountingFixedAsset(
                            name: nameController.text,
                            category: category,
                            purchaseValue: val,
                            purchaseDate: DateTime.now(),
                            usefulLifeMonths: life,
                            accumulatedDepreciation: 0,
                            isFullyDepreciated: false,
                          ),
                        );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(fixedAssetsProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear activo: $e')),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runDepreciation(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ejecutar Depreciación Mensual'),
        content: const Text(
          'Esto calculará la depreciación de todos los activos no depreciados y generará gastos contables para el mes en curso. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ejecutar Depreciación'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ref.read(accountingRepositoryProvider).runMonthlyDepreciation();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Depreciación ejecutada exitosamente')),
        );
        ref.invalidate(fixedAssetsProvider);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al ejecutar depreciación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(fixedAssetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activos Fijos y Depreciación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(fixedAssetsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Activo'),
                  onPressed: () => _showAddDialog(context, ref),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Correr Depreciación Mensual'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _runDepreciation(context, ref),
                ),
              ],
            ),
          ),
          Expanded(
            child: assetsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error cargando activos: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (assets) {
                if (assets.isEmpty) {
                  return const Center(
                    child: Text('No hay activos fijos registrados.'),
                  );
                }
                return AccountingExcelGrid(
                  title: 'Lista de Activos Fijos',
                  columns: [
                    ExcelGridColumn(title: 'Activo'),
                    ExcelGridColumn(title: 'Categoría'),
                    ExcelGridColumn(title: 'Fecha Compra'),
                    ExcelGridColumn(title: 'Valor (Bs)', isNumeric: true),
                    ExcelGridColumn(title: 'Vida Útil'),
                    ExcelGridColumn(
                      title: 'Deprec. Acumulada',
                      isNumeric: true,
                    ),
                    ExcelGridColumn(title: 'Estado'),
                  ],
                  rows: assets.map((asset) {
                    return ExcelGridRow(
                      cells: [
                        Text(asset.name),
                        Text(asset.category),
                        Text(asset.purchaseDate.toString().substring(0, 10)),
                        Text(asset.purchaseValue.toStringAsFixed(2)),
                        Text('${asset.usefulLifeMonths} meses'),
                        Text(
                          asset.accumulatedDepreciation.toStringAsFixed(2),
                        ),
                        Text(
                          asset.isFullyDepreciated ? 'Depreciado' : 'Activo',
                          style: TextStyle(
                            color: asset.isFullyDepreciated
                                ? Colors.grey
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
