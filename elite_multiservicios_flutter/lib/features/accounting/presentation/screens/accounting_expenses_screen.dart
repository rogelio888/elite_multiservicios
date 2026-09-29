import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingExpensesScreen extends ConsumerWidget {
  const AccountingExpensesScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final supplierCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Nuevo Gasto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: supplierCtrl,
                  decoration: const InputDecoration(labelText: 'Proveedor / Destinatario'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Categoría (ej. Nómina, Insumos)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountCtrl,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción / Notas'),
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
                final amount = double.tryParse(amountCtrl.text);
                if (amount != null && supplierCtrl.text.isNotEmpty && categoryCtrl.text.isNotEmpty) {
                  try {
                    final expense = AccountingExpense(
                      supplierName: supplierCtrl.text,
                      category: categoryCtrl.text,
                      amount: amount,
                      date: DateTime.now(),
                      status: 'Paid',
                      description: descCtrl.text.isEmpty ? null : descCtrl.text,
                      isDeleted: false,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    
                    await ref.read(accountingRepositoryProvider).createExpense(expense);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(expensesProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al registrar gasto: $e')),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Egresos y Gastos Operativos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(expensesProvider),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error cargando gastos: $error',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('No hay gastos registrados.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildExpenseTile(
                expense.supplierName,
                expense.category,
                expense.amount,
                expense.status,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.money_off),
        label: const Text('Registrar Gasto'),
      ),
    );
  }

  Widget _buildExpenseTile(
    String supplier,
    String category,
    double amount,
    String status,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          child: const Icon(Icons.outbound, color: Colors.red),
        ),
        title: Text(
          supplier,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '-\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: status == 'Paid' ? Colors.green : Colors.orange,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          // Ver detalle de gasto
        },
      ),
    );
  }
}
