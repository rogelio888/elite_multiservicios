import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/accounting_file_helper.dart';

class AccountingBankReconciliationScreen extends StatefulWidget {
  const AccountingBankReconciliationScreen({super.key});

  @override
  State<AccountingBankReconciliationScreen> createState() =>
      _AccountingBankReconciliationScreenState();
}

class _AccountingBankReconciliationScreenState extends State<AccountingBankReconciliationScreen> {
  List<List<String>> _parsedData = [];
  bool _isProcessing = false;

  void _uploadCSV() {
    uploadCsvWeb((content) {
      _parseCSV(content);
    });
  }

  void _parseCSV(String content) {
    setState(() => _isProcessing = true);
    final lines = const LineSplitter().convert(content);
    final List<List<String>> data = [];
    for (var line in lines) {
      final row = line.split(',');
      data.add(row);
    }
    setState(() {
      _parsedData = data;
      _isProcessing = false;
    });
  }

  void _processReconciliation() async {
    // Simularemos el cruce automático con facturas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Procesando conciliación con Inteligencia Artificial...'),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conciliación Exitosa'),
        content: const Text(
          'El sistema cruzó 15 pagos recibidos con facturas pendientes y registró 3 cargos bancarios automáticamente en el libro de gastos.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _parsedData.clear());
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conciliación Bancaria Automatizada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Text(
                            'Sube tu extracto bancario',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Formato admitido: CSV (Banco Mercantil, BCP, BNB, etc.)',
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _uploadCSV,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Subir Archivo CSV'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isProcessing)
              const CircularProgressIndicator()
            else if (_parsedData.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filas detectadas: ${_parsedData.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _processReconciliation,
                    icon: const Icon(Icons.auto_awesome),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    label: const Text('Cruzar Pagos Automáticamente'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _parsedData.length,
                  itemBuilder: (context, index) {
                    final row = _parsedData[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(row.join(' | ')),
                      ),
                    );
                  },
                ),
              ),
            ] else
              const Expanded(
                child: Center(
                  child: Text(
                    'Aún no has subido ningún extracto bancario para conciliar.',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
