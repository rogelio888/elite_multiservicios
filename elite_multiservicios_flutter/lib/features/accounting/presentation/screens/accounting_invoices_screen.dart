import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingInvoicesScreen extends ConsumerWidget {
  const AccountingInvoicesScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final clientCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final numberCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Factura'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numberCtrl,
                  decoration: const InputDecoration(labelText: 'Nº Factura (ej. INV-001)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: clientCtrl,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountCtrl,
                  decoration: const InputDecoration(labelText: 'Monto Total'),
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
                final amount = double.tryParse(amountCtrl.text);
                if (amount != null && clientCtrl.text.isNotEmpty && numberCtrl.text.isNotEmpty) {
                  try {
                    final invoice = AccountingInvoice(
                      invoiceNumber: numberCtrl.text,
                      customerId: 1, // Generic customer ID until CRM is linked
                      totalAmount: amount,
                      issueDate: DateTime.now(),
                      dueDate: DateTime.now().add(const Duration(days: 30)),
                      status: 'Pending',
                      isDeleted: false,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    
                    await ref.read(accountingRepositoryProvider).createInvoice(invoice);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(invoicesProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear factura: $e')),
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
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación y Cuentas por Cobrar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(invoicesProvider),
          ),
        ],
      ),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error cargando facturas: $error',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (invoices) {
          if (invoices.isEmpty) {
            return const Center(child: Text('No hay facturas registradas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return _buildInvoiceTile(
                invoice.invoiceNumber,
                'Cliente #${invoice.customerId}',
                invoice.totalAmount,
                invoice.status,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Factura'),
      ),
    );
  }

  Widget _buildInvoiceTile(
    String number,
    String client,
    double amount,
    String status,
  ) {
    Color statusColor;
    switch (status) {
      case 'Paid':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Overdue':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(Icons.receipt, color: statusColor),
        ),
        title: Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(client),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
          ],
        ),
        onTap: () {
          // Ver detalle de factura
        },
      ),
    );
  }
}
