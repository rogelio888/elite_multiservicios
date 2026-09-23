import 'package:flutter/material.dart';

class AccountingInvoicesScreen extends StatefulWidget {
  const AccountingInvoicesScreen({super.key});

  @override
  State<AccountingInvoicesScreen> createState() => _AccountingInvoicesScreenState();
}

class _AccountingInvoicesScreenState extends State<AccountingInvoicesScreen> {
  // Aquí se llamaría a client.accounting.getInvoices()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación y Cuentas por Cobrar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Facturas Recientes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInvoiceTile('INV-2026-001', 'Condominio Las Palmas', 1200.00, 'Paid'),
          _buildInvoiceTile('INV-2026-002', 'Empresa TechCorp', 3450.00, 'Pending'),
          _buildInvoiceTile('INV-2026-003', 'Colegio San Jorge', 890.00, 'Overdue'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Mostrar formulario para crear nueva factura
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Factura'),
      ),
    );
  }

  Widget _buildInvoiceTile(String number, String client, double amount, String status) {
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
        title: Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(client),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
