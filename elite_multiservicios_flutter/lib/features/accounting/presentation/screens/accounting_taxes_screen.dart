import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingTaxesScreen extends ConsumerStatefulWidget {
  const AccountingTaxesScreen({super.key});
  @override
  ConsumerState<AccountingTaxesScreen> createState() =>
      _AccountingTaxesScreenState();
}

class _AccountingTaxesScreenState extends ConsumerState<AccountingTaxesScreen> {
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    final typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Impuesto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre (ej. IVA)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tasa (ej. 0.16)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: typeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tipo (Venta, Compra, etc)',
                  ),
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
                final rate = double.tryParse(rateCtrl.text);
                if (nameCtrl.text.isNotEmpty &&
                    rate != null &&
                    typeCtrl.text.isNotEmpty) {
                  final tax = AccountingTax(
                    name: nameCtrl.text,
                    rate: rate,
                    type: typeCtrl.text,
                    isActive: true,
                  );

                  try {
                    await ref.read(accountingRepositoryProvider).createTax(tax);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(taxesProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error guardando impuesto: $e')),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taxesAsync = ref.watch(taxesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Impuestos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(taxesProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: taxesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (taxes) {
          if (taxes.isEmpty) {
            return const Center(child: Text('No hay impuestos registrados.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taxes.length,
            itemBuilder: (context, index) {
              final tax = taxes[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.percent),
                  title: Text(tax.name),
                  subtitle: Text(
                    'Tipo: ${tax.type} | Tasa: ${(tax.rate * 100).toStringAsFixed(2)}%',
                  ),
                  trailing: Icon(
                    tax.isActive ? Icons.check_circle : Icons.cancel,
                    color: tax.isActive ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
