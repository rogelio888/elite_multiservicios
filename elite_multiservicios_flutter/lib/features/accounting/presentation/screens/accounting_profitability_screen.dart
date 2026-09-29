import 'package:flutter/material.dart';

class AccountingProfitabilityScreen extends StatelessWidget {
  const AccountingProfitabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rentabilidad por Proyecto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Centros de Costo (Proyectos)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proyecto: Condominio Las Palmas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Código CC: CC-001 | Cliente: Las Palmas Admin'),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.green),
                      title: Text('Ingresos (Facturación CRM)'),
                      trailing: Text(
                        '\$5,000.00',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.people, color: Colors.red),
                      title: Text('Egresos Laborales (Nómina RRHH)'),
                      trailing: Text(
                        '\$2,500.00',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.shopping_cart, color: Colors.orange),
                      title: Text('Gastos Operativos (Materiales en campo)'),
                      trailing: Text(
                        '\$500.00',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text(
                        'Rentabilidad Neta',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$2,000.00 (40%)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catálogo de Cuentas Fiscales',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text('101-01 - Caja General'),
                      subtitle: Text('Activo'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text('201-01 - IVA por Pagar (16%)'),
                      subtitle: Text('Pasivo'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
