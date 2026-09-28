import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client

class AccountingPayrollScreen extends StatefulWidget {
  const AccountingPayrollScreen({super.key});

  @override
  State<AccountingPayrollScreen> createState() =>
      _AccountingPayrollScreenState();
}

class _AccountingPayrollScreenState extends State<AccountingPayrollScreen> {
  bool _isLoading = true;
  List<AccountingPayrollEstimation> _estimations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await client.accounting.getPayrollEstimations();
      if (!mounted) return;
      setState(() {
        _estimations = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando nómina: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showAddDialog() {
    final salaryController = TextEditingController();
    final bonusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Estimación Salarial'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salario Base (Bs)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bonusController,
                decoration: const InputDecoration(
                  labelText: 'Bonos Estimados (Bs)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
                  final est = AccountingPayrollEstimation(
                    userId: 1, // Usuario Genérico
                    baseSalary: base,
                    bonuses: bonus,
                    estimatedTotal: base + bonus,
                    month: DateTime.now().month,
                    year: DateTime.now().year,
                  );
                  await client.accounting.createPayrollEstimation(est);
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
        title: const Text('Estimación de Nómina (RRHH)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _estimations.isEmpty
          ? const Center(child: Text('No hay estimaciones registradas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _estimations.length,
              itemBuilder: (context, index) {
                final est = _estimations[index];
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
            ),
    );
  }
}
