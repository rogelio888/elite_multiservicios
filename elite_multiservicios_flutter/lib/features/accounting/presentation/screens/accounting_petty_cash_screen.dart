import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart'; // Importa el client
import '../widgets/accounting_excel_grid.dart';

class AccountingPettyCashScreen extends StatefulWidget {
  const AccountingPettyCashScreen({super.key});

  @override
  State<AccountingPettyCashScreen> createState() =>
      _AccountingPettyCashScreenState();
}

class _AccountingPettyCashScreenState extends State<AccountingPettyCashScreen> {
  bool _isLoading = true;
  List<AccountingPettyCash> _pettyCashFunds = [];
  List<AccountingPettyCashTransaction> _transactions = [];

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
      final funds = await client.accounting.getPettyCash();
      final txns = await client.accounting.getPettyCashTransactions();
      if (!mounted) return;
      setState(() {
        _pettyCashFunds = funds;
        _transactions = txns;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando caja chica: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showAddTransactionDialog(AccountingPettyCash fund) {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    final creditController = TextEditingController();
    final debitController = TextEditingController();

    String txnType = 'EXPENSE';
    bool hasInvoice = false;
    bool isFixedPayment = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Registrar Transacción'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: txnType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'EXPENSE',
                          child: Text('Gasto (Salida)'),
                        ),
                        DropdownMenuItem(
                          value: 'REPLENISHMENT',
                          child: Text('Reembolso (Entrada)'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          txnType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto (Bs)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Tiene Factura'),
                      value: hasInvoice,
                      onChanged: (val) {
                        setDialogState(() => hasInvoice = val ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Es Pago Fijo (Servicios básicos)'),
                      value: isFixedPayment,
                      onChanged: (val) {
                        setDialogState(() => isFixedPayment = val ?? false);
                      },
                    ),
                    if (hasInvoice) ...[
                      TextField(
                        controller: creditController,
                        decoration: const InputDecoration(
                          labelText: 'Crédito Fiscal (Bs)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: debitController,
                        decoration: const InputDecoration(
                          labelText: 'Débito Fiscal (Bs)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
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
                    final amount = double.tryParse(amountController.text) ?? 0;
                    final credit = double.tryParse(creditController.text);
                    final debit = double.tryParse(debitController.text);

                    if (amount > 0 && descController.text.isNotEmpty) {
                      final txn = AccountingPettyCashTransaction(
                        pettyCashId: fund.id!,
                        amount: amount,
                        type: txnType,
                        description: descController.text,
                        date: DateTime.now(),
                        hasInvoice: hasInvoice,
                        isFixedPayment: isFixedPayment,
                        fiscalCredit: hasInvoice ? credit : null,
                        fiscalDebit: hasInvoice ? debit : null,
                      );
                      await client.accounting.addPettyCashTransaction(txn);
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
      },
    );
  }

  void _showEditTransactionDialog(AccountingPettyCashTransaction txn) {
    final amountController = TextEditingController(
      text: txn.amount.toStringAsFixed(2),
    );
    final descController = TextEditingController(text: txn.description);
    final creditController = TextEditingController(
      text: txn.fiscalCredit?.toStringAsFixed(2) ?? '',
    );
    final debitController = TextEditingController(
      text: txn.fiscalDebit?.toStringAsFixed(2) ?? '',
    );

    String txnType = txn.type;
    bool hasInvoice = txn.hasInvoice;
    bool isFixedPayment = txn.isFixedPayment;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Editar Transacción'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: txnType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'EXPENSE',
                          child: Text('Gasto (Salida)'),
                        ),
                        DropdownMenuItem(
                          value: 'REPLENISHMENT',
                          child: Text('Reembolso (Entrada)'),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => txnType = value!),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto (Bs)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Tiene Factura'),
                      value: hasInvoice,
                      onChanged: (val) =>
                          setDialogState(() => hasInvoice = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Es Pago Fijo (Servicios básicos)'),
                      value: isFixedPayment,
                      onChanged: (val) =>
                          setDialogState(() => isFixedPayment = val ?? false),
                    ),
                    if (hasInvoice) ...[
                      TextField(
                        controller: creditController,
                        decoration: const InputDecoration(
                          labelText: 'Crédito Fiscal (Bs)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: debitController,
                        decoration: const InputDecoration(
                          labelText: 'Débito Fiscal (Bs)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    final amount =
                        double.tryParse(amountController.text) ?? txn.amount;
                    final credit = double.tryParse(creditController.text);
                    final debit = double.tryParse(debitController.text);
                    if (amount > 0 && descController.text.isNotEmpty) {
                      final updated = txn.copyWith(
                        amount: amount,
                        type: txnType,
                        description: descController.text,
                        hasInvoice: hasInvoice,
                        isFixedPayment: isFixedPayment,
                        fiscalCredit: hasInvoice ? credit : null,
                        fiscalDebit: hasInvoice ? debit : null,
                      );
                      await client.accounting.updatePettyCashTransaction(
                        updated,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _loadData();
                    }
                  },
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTransaction(AccountingPettyCashTransaction txn) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Transacción'),
        content: Text(
          '¿Eliminar "${txn.description}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await client.accounting.deletePettyCashTransaction(txn.id!);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo de Caja Chica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                  if (_pettyCashFunds.isEmpty)
                    ElevatedButton(
                      onPressed: () async {
                        await client.accounting.createPettyCash(
                          AccountingPettyCash(
                            name: 'Caja Chica Principal',
                            balance: 100.0,
                            maxLimit: 100.0,
                            custodianId: 1, // Dummy ID
                          ),
                        );
                        _loadData();
                      },
                      child: const Text('Inicializar Caja Chica (100 Bs)'),
                    )
                  else
                    ..._pettyCashFunds.map((fund) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fund.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Límite: Bs ${fund.maxLimit}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(
                                'Saldo: Bs ${fund.balance}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  if (_pettyCashFunds.isNotEmpty)
                    Expanded(
                      child: AccountingExcelGrid(
                        title: 'Libro Diario - Caja Chica',
                        onAddRow: () =>
                            _showAddTransactionDialog(_pettyCashFunds.first),
                        columns: [
                          ExcelGridColumn(title: 'Fecha'),
                          ExcelGridColumn(title: 'Descripción'),
                          ExcelGridColumn(title: 'Tipo'),
                          ExcelGridColumn(title: 'Monto', isNumeric: true),
                          ExcelGridColumn(title: 'Factura'),
                          ExcelGridColumn(title: 'Fijo/Servicios'),
                          ExcelGridColumn(title: 'Crédito F.', isNumeric: true),
                          ExcelGridColumn(title: 'Débito F.', isNumeric: true),
                        ],
                        rows: _transactions.map((txn) {
                          final isExp = txn.type == 'EXPENSE';
                          return ExcelGridRow(
                            onEdit: () => _showEditTransactionDialog(txn),
                            onDelete: () => _deleteTransaction(txn),
                            cells: [
                              Text(txn.date.toString().substring(0, 16)),
                              Text(txn.description),
                              Text(
                                isExp ? 'Gasto' : 'Ingreso/Reembolso',
                                style: TextStyle(
                                  color: isExp ? Colors.red : Colors.green,
                                ),
                              ),
                              Text(txn.amount.toStringAsFixed(2)),
                              Icon(
                                txn.hasInvoice
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.blue,
                              ),
                              Icon(
                                txn.isFixedPayment
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.orange,
                              ),
                              Text(txn.fiscalCredit?.toStringAsFixed(2) ?? '-'),
                              Text(txn.fiscalDebit?.toStringAsFixed(2) ?? '-'),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
