import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client

class AccountingLedgerScreen extends StatefulWidget {
  const AccountingLedgerScreen({super.key});

  @override
  State<AccountingLedgerScreen> createState() => _AccountingLedgerScreenState();
}

class _AccountingLedgerScreenState extends State<AccountingLedgerScreen> {
  bool _isLoading = true;
  List<AccountingLedgerAccount> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await client.accounting.getLedgerAccounts();
      if (!mounted) return;
      setState(() {
        _accounts = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando catálogo: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Cuenta Contable'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Código (ej. 1001)')),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de la Cuenta')),
              TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Tipo (Activo, Pasivo, etc)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (codeCtrl.text.isNotEmpty && nameCtrl.text.isNotEmpty && typeCtrl.text.isNotEmpty) {
                  final acc = AccountingLedgerAccount(
                    code: codeCtrl.text,
                    name: nameCtrl.text,
                    type: typeCtrl.text,
                    isActive: true,
                  );
                  await client.accounting.createLedgerAccount(acc);
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
        title: const Text('Catálogo de Cuentas'),
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
          : _accounts.isEmpty
              ? const Center(child: Text('No hay cuentas registradas.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _accounts.length,
                  itemBuilder: (context, index) {
                    final acc = _accounts[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text(acc.code.substring(0, 1))),
                        title: Text('${acc.code} - ${acc.name}'),
                        subtitle: Text('Tipo: ${acc.type} | Estado: ${acc.isActive ? 'Activo' : 'Inactivo'}'),
                      ),
                    );
                  },
                ),
    );
  }
}
