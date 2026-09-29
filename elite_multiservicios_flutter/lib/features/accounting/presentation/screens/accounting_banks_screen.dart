import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingBanksScreen extends ConsumerWidget {
  const AccountingBanksScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final amountCtrl = TextEditingController();
    final typeCtrl = TextEditingController(text: 'Income');
    final accountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Transacción Bancaria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountCtrl,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: typeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tipo (Income / Expense)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: accountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cuenta Bancaria',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notas'),
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
                if (amount != null && typeCtrl.text.isNotEmpty) {
                  final txn = AccountingTransaction(
                    date: DateTime.now(),
                    amount: amount,
                    type: typeCtrl.text,
                    account: accountCtrl.text,
                    notes: notesCtrl.text,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  
                  try {
                    await ref.read(accountingRepositoryProvider).createTransaction(txn);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(transactionsProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear transacción: $e')),
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
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancos y Conciliación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(transactionsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error cargando transacciones: $error',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No hay transacciones registradas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              final isIncome = txn.type == 'Income';
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isIncome
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text('Monto: \$${txn.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    'Cuenta: ${txn.account ?? "N/A"} | ${txn.date.toLocal().toString().split('.')[0]}',
                  ),
                  trailing: Text(
                    txn.type,
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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
