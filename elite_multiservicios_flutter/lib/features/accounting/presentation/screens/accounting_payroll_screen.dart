import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';

class AccountingPayrollScreen extends ConsumerStatefulWidget {
  const AccountingPayrollScreen({super.key});
  @override
  ConsumerState<AccountingPayrollScreen> createState() => _AccountingPayrollScreenState();
}
class _AccountingPayrollScreenState extends ConsumerState<AccountingPayrollScreen> {

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final salaryController = TextEditingController();
    final bonusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Estimación Salarial'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(
                    labelText: 'Salario Base (Bs)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bonusController,
                  decoration: const InputDecoration(
                    labelText: 'Bonos Estimados (Bs)',
                  ),
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
                final base = double.tryParse(salaryController.text) ?? 0;
                final bonus = double.tryParse(bonusController.text) ?? 0;
                if (base > 0) {
                  try {
                    final est = AccountingPayrollEstimation(
                      userId: 1, // Usuario Genérico
                      baseSalary: base,
                      bonuses: bonus,
                      estimatedTotal: base + bonus,
                      month: DateTime.now().month,
                      year: DateTime.now().year,
                    );

                    await ref
                        .read(accountingRepositoryProvider)
                        .createPayrollEstimation(est);

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ref.invalidate(payrollEstimationsProvider);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear estimación: $e')),
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
  Widget build(BuildContext context) {
    final estimationsAsync = ref.watch(payrollEstimationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimación de Nómina (RRHH)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(payrollEstimationsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: estimationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error cargando nómina: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (estimations) {
          if (estimations.isEmpty) {
            return const Center(
              child: Text('No hay estimaciones registradas.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: estimations.length,
            itemBuilder: (context, index) {
              final est = estimations[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    'Usuario ID: ${est.userId} - ${est.month}/${est.year}',
                  ),
                  subtitle: Text(
                    'Base: Bs ${est.baseSalary} | Bonos: Bs ${est.bonuses}',
                  ),
                  trailing: Text(
                    'Total: Bs ${est.estimatedTotal}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
