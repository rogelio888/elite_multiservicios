import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingProfitabilityScreen extends ConsumerStatefulWidget {
  const AccountingProfitabilityScreen({super.key});
  @override
  ConsumerState<AccountingProfitabilityScreen> createState() =>
      _AccountingProfitabilityScreenState();
}

class _AccountingProfitabilityScreenState
    extends ConsumerState<AccountingProfitabilityScreen> {
  @override
  Widget build(BuildContext context) {
    final costCentersAsync = ref.watch(costCentersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rentabilidad por Proyecto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(costCentersProvider),
          ),
        ],
      ),
      body: costCentersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (costCenters) {
          if (costCenters.isEmpty) {
            return const Center(
              child: Text('No hay centros de costo registrados.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: costCenters.length,
            itemBuilder: (context, index) {
              final cc = costCenters[index];
              return _buildCostCenterCard(context, cc);
            },
          );
        },
      ),
    );
  }

  Widget _buildCostCenterCard(BuildContext context, AccountingCostCenter cc) {
    // In a real app, these values would come from related transactions/budget
    // For now, we use placeholder calculations for demo purposes.
    final incomes = 5000.00;
    final laborCosts = 2500.00;
    final operationalCosts = 500.00;
    final netProfit = incomes - laborCosts - operationalCosts;
    final profitMargin = incomes > 0 ? (netProfit / incomes) * 100 : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text(
              'Proyecto: ${cc.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Contrato CRM #${cc.contractId ?? "N/A"} | Estado: ${cc.status}',
            ),
            if (cc.description != null && cc.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Desc: ${cc.description}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const Divider(),
            const ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.green),
              title: Text('Ingresos (Facturación)'),
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
              title: Text('Egresos Laborales'),
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
              title: Text('Gastos Operativos'),
              trailing: Text(
                '\$500.00',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Rentabilidad Neta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$${netProfit.toStringAsFixed(2)} (${profitMargin.toStringAsFixed(1)}%)',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
