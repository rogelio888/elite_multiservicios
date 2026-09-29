import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingLedgerScreen extends ConsumerWidget {
  const AccountingLedgerScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Cuenta Contable'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Código (ej. 1001)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Cuenta',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: typeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tipo (Activo, Pasivo, etc)',
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
                if (codeCtrl.text.isNotEmpty &&
                    nameCtrl.text.isNotEmpty &&
                    typeCtrl.text.isNotEmpty) {
                  try {
                    final acc = AccountingLedgerAccount(
                      code: codeCtrl.text,
                      name: nameCtrl.text,
                      type: typeCtrl.text,
                      isActive: true,
                    );
                    
                    await ref.read(accountingRepositoryProvider).createLedgerAccount(acc);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(ledgerAccountsProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear cuenta: $e')),
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
    final accountsAsync = ref.watch(ledgerAccountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Cuentas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(ledgerAccountsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error cargando catálogo: $error',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('No hay cuentas registradas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final acc = accounts[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(acc.code.isNotEmpty ? acc.code.substring(0, 1) : '?'),
                  ),
                  title: Text('${acc.code} - ${acc.name}'),
                  subtitle: Text(
                    'Tipo: ${acc.type} | Estado: ${acc.isActive ? 'Activo' : 'Inactivo'}',
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
