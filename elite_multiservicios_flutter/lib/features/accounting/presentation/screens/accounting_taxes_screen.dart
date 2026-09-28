import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client

class AccountingTaxesScreen extends StatefulWidget {
  const AccountingTaxesScreen({super.key});

  @override
  State<AccountingTaxesScreen> createState() => _AccountingTaxesScreenState();
}

class _AccountingTaxesScreenState extends State<AccountingTaxesScreen> {
  bool _isLoading = true;
  List<AccountingTax> _taxes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await client.accounting.getTaxes();
      if (!mounted) return;
      setState(() {
        _taxes = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando impuestos: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    final typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Impuesto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre (ej. IVA)')),
              TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'Tasa (ej. 0.16)'), keyboardType: TextInputType.number),
              TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Tipo (Venta, Compra, etc)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final rate = double.tryParse(rateCtrl.text);
                if (nameCtrl.text.isNotEmpty && rate != null && typeCtrl.text.isNotEmpty) {
                  final tax = AccountingTax(
                    name: nameCtrl.text,
                    rate: rate,
                    type: typeCtrl.text,
                    isActive: true,
                  );
                  await client.accounting.createTax(tax);
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
        title: const Text('Gestión de Impuestos'),
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
          : _taxes.isEmpty
              ? const Center(child: Text('No hay impuestos registrados.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _taxes.length,
                  itemBuilder: (context, index) {
                    final tax = _taxes[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.percent),
                        title: Text(tax.name),
                        subtitle: Text('Tipo: ${tax.type} | Tasa: ${(tax.rate * 100).toStringAsFixed(2)}%'),
                        trailing: Icon(tax.isActive ? Icons.check_circle : Icons.cancel, color: tax.isActive ? Colors.green : Colors.red),
                      ),
                    );
                  },
                ),
    );
  }
}
