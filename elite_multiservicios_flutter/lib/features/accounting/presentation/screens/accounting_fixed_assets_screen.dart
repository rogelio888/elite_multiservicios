import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client
import '../widgets/accounting_excel_grid.dart';

class AccountingFixedAssetsScreen extends StatefulWidget {
  const AccountingFixedAssetsScreen({super.key});

  @override
  State<AccountingFixedAssetsScreen> createState() => _AccountingFixedAssetsScreenState();
}

class _AccountingFixedAssetsScreenState extends State<AccountingFixedAssetsScreen> {
  bool _isLoading = true;
  List<AccountingFixedAsset> _assets = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final assets = await client.accounting.getFixedAssets();
      if (!mounted) return;
      setState(() {
        _assets = assets;
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
    final valueController = TextEditingController();
    final lifeController = TextEditingController();
    String category = 'Vehículos';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Activo Fijo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del Activo (Ej. Camioneta)')),
              DropdownButton<String>(
                value: category,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Vehículos', child: Text('Vehículos')),
                  DropdownMenuItem(value: 'Equipos', child: Text('Equipos/Maquinaria')),
                  DropdownMenuItem(value: 'Mobiliario', child: Text('Mobiliario de Oficina')),
                ],
                onChanged: (val) => setDialogState(() => category = val!),
              ),
              TextField(controller: valueController, decoration: const InputDecoration(labelText: 'Valor de Compra (Bs)'), keyboardType: TextInputType.number),
              TextField(controller: lifeController, decoration: const InputDecoration(labelText: 'Vida Útil (Meses)'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final val = double.tryParse(valueController.text) ?? 0;
                final life = int.tryParse(lifeController.text) ?? 0;
                if (val > 0 && life > 0 && nameController.text.isNotEmpty) {
                  await client.accounting.createFixedAsset(
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

  Future<void> _runDepreciation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ejecutar Depreciación Mensual'),
        content: const Text('Esto calculará la depreciación de todos los activos no depreciados y generará gastos contables para el mes en curso. ¿Deseas continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ejecutar Depreciación'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await client.accounting.runMonthlyDepreciation();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Depreciación ejecutada exitosamente')));
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activos Fijos y Depreciación')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Registrar Activo'),
                        onPressed: _showAddDialog,
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calculate),
                        label: const Text('Correr Depreciación Mensual'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        onPressed: _runDepreciation,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AccountingExcelGrid(
                    title: 'Lista de Activos Fijos',
                    columns: [
                      ExcelGridColumn(title: 'Activo'),
                      ExcelGridColumn(title: 'Categoría'),
                      ExcelGridColumn(title: 'Fecha Compra'),
                      ExcelGridColumn(title: 'Valor (Bs)', isNumeric: true),
                      ExcelGridColumn(title: 'Vida Útil'),
                      ExcelGridColumn(title: 'Deprec. Acumulada', isNumeric: true),
                      ExcelGridColumn(title: 'Estado'),
                    ],
                    rows: _assets.map((asset) {
                      return ExcelGridRow(
                        cells: [
                          Text(asset.name),
                          Text(asset.category),
                          Text(asset.purchaseDate.toString().substring(0, 10)),
                          Text(asset.purchaseValue.toStringAsFixed(2)),
                          Text('${asset.usefulLifeMonths} meses'),
                          Text(asset.accumulatedDepreciation.toStringAsFixed(2)),
                          Text(
                            asset.isFullyDepreciated ? 'Depreciado' : 'Activo',
                            style: TextStyle(color: asset.isFullyDepreciated ? Colors.grey : Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
