import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../providers/accounting_providers.dart';
import '../widgets/accounting_excel_grid.dart';

class AccountingPettyCashScreen extends ConsumerStatefulWidget {
  const AccountingPettyCashScreen({super.key});

  @override
  ConsumerState<AccountingPettyCashScreen> createState() =>
      _AccountingPettyCashScreenState();
}

class _AccountingPettyCashScreenState extends ConsumerState<AccountingPettyCashScreen> {
  String _searchQuery = '';
  String _filterType = 'ALL'; // ALL, EXPENSE, REPLENISHMENT, INVOICE, FIXED

  void _loadData() {
    ref.invalidate(pettyCashProvider);
    ref.invalidate(pettyCashTransactionsProvider);
  }


  // Abre diálogo para crear / aperturar nueva caja chica
  void _showCreatePettyCashDialog() {
    final nameController = TextEditingController(
      text: 'Caja Chica Sucursal Principal',
    );
    final limitController = TextEditingController(text: '1000.00');
    final initialBalanceController = TextEditingController(text: '1000.00');
    DateTime openingDateTime = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Apertura de Caja Chica',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre del Fondo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Ej: Caja Chica Principal / Operaciones',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Límite Máximo (Bs)',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: limitController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '1000.00',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo Inicial (Bs)',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: initialBalanceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '1000.00',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_filled,
                            size: 18,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha y Hora de Apertura',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy HH:mm',
                                  ).format(openingDateTime),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar', style: GoogleFonts.inter()),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final name = nameController.text.trim();
                  final maxLimit =
                      double.tryParse(limitController.text.trim()) ?? 1000.0;
                  final balance =
                      double.tryParse(initialBalanceController.text.trim()) ??
                      maxLimit;

                  if (name.isNotEmpty) {
                    await ref.read(accountingRepositoryProvider).createPettyCash(
                      AccountingPettyCash(
                        name: name,
                        balance: balance,
                        maxLimit: maxLimit,
                        custodianId: 1,
                      ),
                    );
                    if (!context.mounted) return;
                    Navigator.pop(ctx);
                    _loadData();
                  }
                },
                icon: const Icon(Icons.check, size: 18),
                label: Text('Aperturar Fondo', style: GoogleFonts.inter()),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddTransactionDialog(AccountingPettyCash fund) {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    final creditController = TextEditingController();
    final debitController = TextEditingController();
    DateTime txnDate = DateTime.now();

    String txnType = 'EXPENSE';
    bool hasInvoice = false;
    bool isFixedPayment = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.post_add,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Registrar Movimiento en Caja Chica',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipo de Operación',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: txnType,
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'EXPENSE',
                                          child: Text('🔴 Gasto (Salida)'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'REPLENISHMENT',
                                          child: Text('🟢 Reembolso (Entrada)'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setDialogState(() {
                                          txnType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monto (Bs)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    prefixText: 'Bs ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Descripción / Concepto',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          hintText:
                              'Ej: Compra de insumos de limpieza para oficina',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Fecha y Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(txnDate)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Tiene Factura / Comprobante Fiscal',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        value: hasInvoice,
                        onChanged: (val) {
                          setDialogState(() => hasInvoice = val);
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Es Pago Fijo (Servicios básicos, internet, etc.)',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        value: isFixedPayment,
                        onChanged: (val) {
                          setDialogState(() => isFixedPayment = val);
                        },
                      ),
                      if (hasInvoice) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: creditController,
                                decoration: InputDecoration(
                                  labelText: 'Crédito Fiscal (Bs)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: debitController,
                                decoration: InputDecoration(
                                  labelText: 'Débito Fiscal (Bs)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: GoogleFonts.inter()),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final amount =
                        double.tryParse(amountController.text.trim()) ?? 0;
                    final credit = double.tryParse(
                      creditController.text.trim(),
                    );
                    final debit = double.tryParse(debitController.text.trim());

                    if (amount > 0 && descController.text.trim().isNotEmpty) {
                      final txn = AccountingPettyCashTransaction(
                        pettyCashId: fund.id!,
                        amount: amount,
                        type: txnType,
                        description: descController.text.trim(),
                        date: txnDate,
                        hasInvoice: hasInvoice,
                        isFixedPayment: isFixedPayment,
                        fiscalCredit: hasInvoice ? credit : null,
                        fiscalDebit: hasInvoice ? debit : null,
                      );
                      await ref.read(accountingRepositoryProvider).addPettyCashTransaction(txn);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _loadData();
                    }
                  },
                  icon: const Icon(Icons.save, size: 18),
                  label: Text('Guardar', style: GoogleFonts.inter()),
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
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Editar Transacción',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: txnType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Transacción',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'EXPENSE',
                            child: Text('🔴 Gasto (Salida)'),
                          ),
                          DropdownMenuItem(
                            value: 'REPLENISHMENT',
                            child: Text('🟢 Reembolso (Entrada)'),
                          ),
                        ],
                        onChanged: (value) =>
                            setDialogState(() => txnType = value!),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          labelText: 'Monto (Bs)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Tiene Factura',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        value: hasInvoice,
                        onChanged: (val) =>
                            setDialogState(() => hasInvoice = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Es Pago Fijo (Servicios básicos)',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        value: isFixedPayment,
                        onChanged: (val) =>
                            setDialogState(() => isFixedPayment = val),
                      ),
                      if (hasInvoice) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: creditController,
                                decoration: InputDecoration(
                                  labelText: 'Crédito Fiscal (Bs)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: debitController,
                                decoration: InputDecoration(
                                  labelText: 'Débito Fiscal (Bs)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: GoogleFonts.inter()),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                      await ref.read(accountingRepositoryProvider).updatePettyCashTransaction(
                        updated,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _loadData();
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: Text('Guardar Cambios', style: GoogleFonts.inter()),
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
      await ref.read(accountingRepositoryProvider).deletePettyCashTransaction(txn.id!);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pettyCashAsync = ref.watch(pettyCashProvider);
    final txnsAsync = ref.watch(pettyCashTransactionsProvider);

    if (pettyCashAsync.isLoading || txnsAsync.isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pettyCashAsync.hasError || txnsAsync.hasError) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error: ${pettyCashAsync.error ?? txnsAsync.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final pettyCashFunds = pettyCashAsync.value ?? [];
    final transactions = txnsAsync.value ?? [];

    // Caja chica activa
    final activeFund = pettyCashFunds.isNotEmpty
        ? pettyCashFunds.first
        : null;

    // Totales calculados
    double totalExpenses = 0.0;
    double totalReplenishments = 0.0;
    for (final t in transactions) {
      if (t.type == 'EXPENSE') {
        totalExpenses += t.amount;
      } else {
        totalReplenishments += t.amount;
      }
    }

    // Filtrar transacciones
    final filteredTxns = transactions.where((t) {
      final matchesQuery =
          _searchQuery.isEmpty ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesQuery) return false;

      switch (_filterType) {
        case 'EXPENSE':
          return t.type == 'EXPENSE';
        case 'REPLENISHMENT':
          return t.type == 'REPLENISHMENT';
        case 'INVOICE':
          return t.hasInvoice;
        case 'FIXED':
          return t.isFixedPayment;
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0F19)
          : const Color(0xFFF8FAFC),
      body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header principal con botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control de Caja Chica',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Administración de fondos fijos, comprobantes, créditos fiscales y rendiciones.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            tooltip: 'Actualizar datos',
                            onPressed: _loadData,
                          ),
                          const SizedBox(width: 8),
                          if (activeFund == null)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _showCreatePettyCashDialog,
                              icon: const Icon(Icons.add, size: 18),
                              label: Text(
                                'Aperturar Caja Chica',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else ...[
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _showCreatePettyCashDialog,
                              icon: const Icon(
                                Icons.account_balance_wallet,
                                size: 16,
                              ),
                              label: Text(
                                'Nueva Caja',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () =>
                                  _showAddTransactionDialog(activeFund),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 18,
                              ),
                              label: Text(
                                'Nueva Transacción',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2. Tarjetas de Resumen & KPIs
                  if (activeFund != null) ...[
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        // Tarjeta Principal: Estado y Fecha de Apertura
                        Container(
                          width: 320,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      activeFund.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'ABIERTA',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_note,
                                    size: 15,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Apertura: ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    transactions.isNotEmpty
                                        ? DateFormat(
                                            'dd/MM/yyyy HH:mm',
                                          ).format(transactions.first.date)
                                        : DateFormat(
                                            'dd/MM/yyyy HH:mm',
                                          ).format(DateTime.now()),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? const Color(0xFFE2E8F0)
                                          : const Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_pin,
                                    size: 15,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Responsable: ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'Super Admin (ID #${activeFund.custodianId})',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Tarjeta de Saldo Disponible
                        Container(
                          width: 240,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo Disponible',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bs ${activeFund.balance.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Límite Máximo: Bs ${activeFund.maxLimit.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tarjeta Total Gastos
                        Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Egresos',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bs ${totalExpenses.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${transactions.where((t) => t.type == "EXPENSE").length} movimientos',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tarjeta Total Reembolsos
                        Container(
                          width: 220,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Reembolsos',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bs ${totalReplenishments.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${transactions.where((t) => t.type == "REPLENISHMENT").length} ingresos',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 3. Barra de búsqueda y Filtros
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText:
                                  'Buscar transacción por concepto o descripción...',
                              hintStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.search, size: 18),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161F30)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _filterType,
                            items: const [
                              DropdownMenuItem(
                                value: 'ALL',
                                child: Text('Todos los Registros'),
                              ),
                              DropdownMenuItem(
                                value: 'EXPENSE',
                                child: Text('Solo Gastos'),
                              ),
                              DropdownMenuItem(
                                value: 'REPLENISHMENT',
                                child: Text('Solo Reembolsos'),
                              ),
                              DropdownMenuItem(
                                value: 'INVOICE',
                                child: Text('Con Factura'),
                              ),
                              DropdownMenuItem(
                                value: 'FIXED',
                                child: Text('Pagos Fijos'),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _filterType = val ?? 'ALL';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4. Tabla de Transacciones (Excel Grid con scroll seguro)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161F30) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AccountingExcelGrid(
                        title: 'Libro Diario - Movimientos de Caja Chica',
                        onAddRow: activeFund != null
                            ? () => _showAddTransactionDialog(activeFund)
                            : null,
                        columns: [
                          ExcelGridColumn(title: 'Fecha y Hora'),
                          ExcelGridColumn(title: 'Descripción / Concepto'),
                          ExcelGridColumn(title: 'Tipo'),
                          ExcelGridColumn(title: 'Monto (Bs)', isNumeric: true),
                          ExcelGridColumn(title: 'Factura'),
                          ExcelGridColumn(title: 'Fijo/Servicio'),
                          ExcelGridColumn(
                            title: 'Crédito Fiscal',
                            isNumeric: true,
                          ),
                          ExcelGridColumn(
                            title: 'Débito Fiscal',
                            isNumeric: true,
                          ),
                        ],
                        rows: filteredTxns.map((txn) {
                          final isExp = txn.type == 'EXPENSE';
                          return ExcelGridRow(
                            onEdit: () => _showEditTransactionDialog(txn),
                            onDelete: () => _deleteTransaction(txn),
                            cells: [
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(txn.date),
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              Text(
                                txn.description,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (isExp
                                              ? const Color(0xFFEF4444)
                                              : const Color(0xFF10B981))
                                          .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isExp ? 'Gasto' : 'Reembolso',
                                  style: GoogleFonts.inter(
                                    color: isExp
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF10B981),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Text(
                                'Bs ${txn.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  color: isExp
                                      ? (isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A))
                                      : const Color(0xFF10B981),
                                ),
                              ),
                              Icon(
                                txn.hasInvoice
                                    ? Icons.check_circle
                                    : Icons.remove_circle_outline,
                                size: 18,
                                color: txn.hasInvoice
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF94A3B8),
                              ),
                              Icon(
                                txn.isFixedPayment
                                    ? Icons.check_circle
                                    : Icons.remove_circle_outline,
                                size: 18,
                                color: txn.isFixedPayment
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF94A3B8),
                              ),
                              Text(
                                txn.fiscalCredit != null
                                    ? 'Bs ${txn.fiscalCredit!.toStringAsFixed(2)}'
                                    : '-',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              Text(
                                txn.fiscalDebit != null
                                    ? 'Bs ${txn.fiscalDebit!.toStringAsFixed(2)}'
                                    : '-',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
