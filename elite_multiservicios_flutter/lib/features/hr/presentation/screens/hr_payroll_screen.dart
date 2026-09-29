import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';

class HrPayrollScreen extends StatefulWidget {
  const HrPayrollScreen({super.key});

  @override
  State<HrPayrollScreen> createState() => _HrPayrollScreenState();
}

class _HrPayrollScreenState extends State<HrPayrollScreen> {
  bool _isLoading = true;
  List<HrPayroll> _payrolls = [];
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final payrolls = await client.hr.getPayroll(_now.year, _now.month);
      if (!mounted) return;
      setState(() {
        _payrolls = payrolls;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showGenerateDialog() {
    final employeeIdController = TextEditingController();
    final baseSalaryController = TextEditingController();
    final bonusesController = TextEditingController();
    final deductionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          double base = double.tryParse(baseSalaryController.text) ?? 0;
          double bonuses = double.tryParse(bonusesController.text) ?? 0;
          double deductions = double.tryParse(deductionsController.text) ?? 0;
          double net = base + bonuses - deductions;

          return AlertDialog(
            title: const Text('Generar NÃ³mina'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: employeeIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID del Empleado',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: baseSalaryController,
                    decoration: const InputDecoration(
                      labelText: 'Salario Base (Bs)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  TextField(
                    controller: bonusesController,
                    decoration: const InputDecoration(
                      labelText: 'Bonificaciones (Bs)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  TextField(
                    controller: deductionsController,
                    decoration: const InputDecoration(
                      labelText: 'Deducciones (Bs)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const Divider(height: 28),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pago Neto:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${net.toStringAsFixed(2)} Bs',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                  final empId =
                      int.tryParse(employeeIdController.text.trim()) ?? 0;
                  final base =
                      double.tryParse(baseSalaryController.text.trim()) ?? 0;
                  final bons =
                      double.tryParse(bonusesController.text.trim()) ?? 0;
                  final deds =
                      double.tryParse(deductionsController.text.trim()) ?? 0;
                  final netFinal = base + bons - deds;

                  if (empId > 0 && base >= 0) {
                    final now = DateTime.now();
                    await client.hr.processPayroll(
                      HrPayroll(
                        employeeId: empId,
                        month: _now.month,
                        year: _now.year,
                        baseSalary: base,
                        bonuses: bons,
                        deductions: deds,
                        netPay: netFinal,
                        isPaid: false,
                        createdAt: now,
                        updatedAt: now,
                      ),
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    _loadData();
                  }
                },
                child: const Text('Generar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _markAsPaid(HrPayroll payroll) async {
    try {
      await client.hr.payPayroll(payroll.id!);
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildPayrollCard(HrPayroll item, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isPaid
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        '${item.employeeId}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emp #${item.employeeId}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.month}/${item.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.isPaid
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.isPaid ? 'Pagado' : 'Pendiente',
                    style: TextStyle(
                      color: item.isPaid ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PayItem(
                  label: 'Salario Base',
                  value: '${item.baseSalary.toStringAsFixed(2)} Bs',
                  color: theme.colorScheme.onSurface,
                ),
                _PayItem(
                  label: 'Bonif.',
                  value: '+${item.bonuses.toStringAsFixed(2)} Bs',
                  color: Colors.green,
                ),
                _PayItem(
                  label: 'Deduc.',
                  value: '-${item.deductions.toStringAsFixed(2)} Bs',
                  color: Colors.red,
                ),
                _PayItem(
                  label: 'NETO',
                  value: '${item.netPay.toStringAsFixed(2)} Bs',
                  color: Colors.blue,
                  isLarge: true,
                ),
              ],
            ),
            if (!item.isPaid) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _markAsPaid(item),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Marcar como Pagado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalNomina = _payrolls.fold(0.0, (s, p) => s + p.netPay);
    final pagados = _payrolls
        .where((p) => p.isPaid)
        .fold(0.0, (s, p) => s + p.netPay);
    final pendientes = totalNomina - pagados;

    return Scaffold(
      appBar: AppBar(
        title: Text('NÃ³mina ${_now.month}/${_now.year}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showGenerateDialog,
            tooltip: 'Generar NÃ³mina',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: 'Total NÃ³mina',
                          value: '${totalNomina.toStringAsFixed(2)} Bs',
                          icon: Icons.payments_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Pagado',
                          value: '${pagados.toStringAsFixed(2)} Bs',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryTile(
                          label: 'Pendiente',
                          value: '${pendientes.toStringAsFixed(2)} Bs',
                          icon: Icons.pending_outlined,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _payrolls.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                size: 64,
                                color: theme.disabledColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay nÃ³mina este mes',
                                style: TextStyle(color: theme.disabledColor),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _showGenerateDialog,
                                child: const Text('Generar NÃ³mina'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _payrolls.length,
                          itemBuilder: (context, index) {
                            return _buildPayrollCard(_payrolls[index], theme);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _PayItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isLarge;

  const _PayItem({
    required this.label,
    required this.value,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 15 : 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
