import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client

class AccountingBanksScreen extends StatefulWidget {
  const AccountingBanksScreen({super.key});

  @override
  State<AccountingBanksScreen> createState() => _AccountingBanksScreenState();
}

class _AccountingBanksScreenState extends State<AccountingBanksScreen> {
  bool _isLoading = true;
  List<AccountingTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await client.accounting.getTransactions();
      if (!mounted) return;
      setState(() {
        _transactions = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando transacciones: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
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
                  await client.accounting.createTransaction(txn);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _loadData();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancos y Conciliación'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
          ? const Center(child: Text('No hay transacciones registradas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final txn = _transactions[index];
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
            ),
    );
  }
}
