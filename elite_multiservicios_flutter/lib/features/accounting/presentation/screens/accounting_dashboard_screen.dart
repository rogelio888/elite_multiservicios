import 'package:flutter/material.dart';
// import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'; // Asegúrate de importar el cliente

class AccountingDashboardScreen extends StatefulWidget {
  const AccountingDashboardScreen({super.key});

  @override
  State<AccountingDashboardScreen> createState() =>
      _AccountingDashboardScreenState();
}

class _AccountingDashboardScreenState extends State<AccountingDashboardScreen> {
  bool _isLoading = true;
  double _totalIncome = 0;
  double _totalExpenses = 0;
  double _balance = 0;

  @override
  void initState() {
    super.initState();
    _loadFinancialSummary();
  }

  Future<void> _loadFinancialSummary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Aquí haríamos la llamada al servidor:
      // final summary = await client.accounting.getFinancialSummary();
      // setState(() {
      //   _totalIncome = summary.totalIncome;
      //   _totalExpenses = summary.totalExpenses;
      //   _balance = summary.balance;
      // });

      // Mock data temporal para visualizar:
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _totalIncome = 15000.0;
        _totalExpenses = 8500.0;
        _balance = 6500.0;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando el resumen financiero: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Contabilidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFinancialSummary,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen del Mes',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Ingresos',
                          _totalIncome,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Egresos',
                          _totalExpenses,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Balance',
                          _balance,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Acciones Rápidas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a Facturas
                        },
                        icon: const Icon(Icons.receipt),
                        label: const Text('Facturación a Clientes'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a Gastos
                        },
                        icon: const Icon(Icons.money_off),
                        label: const Text('Registrar Gasto Operativo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
