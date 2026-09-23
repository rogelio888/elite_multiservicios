import 'package:flutter/material.dart';

class AccountingExpensesScreen extends StatefulWidget {
  const AccountingExpensesScreen({super.key});

  @override
  State<AccountingExpensesScreen> createState() =>
      _AccountingExpensesScreenState();
}

class _AccountingExpensesScreenState extends State<AccountingExpensesScreen> {
  // Aquí se llamaría a client.accounting.getExpenses()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egresos y Gastos Operativos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Historial de Gastos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExpenseTile(
            'Ferretería El Maestro',
            'Insumos Jardinería',
            250.00,
            'Paid',
          ),
          _buildExpenseTile('Juan Pérez', 'Nómina', 1200.00, 'Pending'),
          _buildExpenseTile(
            'Estación de Servicio',
            'Combustible',
            45.00,
            'Paid',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Mostrar formulario para registrar gasto
        },
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
