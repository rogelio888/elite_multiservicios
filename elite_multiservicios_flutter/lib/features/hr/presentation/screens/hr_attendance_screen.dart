import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';

class HrAttendanceScreen extends StatefulWidget {
  const HrAttendanceScreen({super.key});

  @override
  State<HrAttendanceScreen> createState() => _HrAttendanceScreenState();
}

class _HrAttendanceScreenState extends State<HrAttendanceScreen> {
  bool _isLoading = true;
  List<HrAttendance> _records = [];
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final records = await client.hr.getAttendance(_selectedDate);

      if (!mounted) return;
      setState(() {
        _records = records;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    final employeeIdController = TextEditingController();
    String status = 'Presente';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar Asistencia'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: employeeIdController,
                  decoration: const InputDecoration(labelText: 'ID del Empleado'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Presente', child: Text('âœ… Presente')),
                    DropdownMenuItem(
                        value: 'Ausente', child: Text('âŒ Ausente')),
                    DropdownMenuItem(
                        value: 'Tardanza', child: Text('âš ï¸ Tardanza')),
                    DropdownMenuItem(
                        value: 'Permiso', child: Text('ðŸ“‹ Permiso')),
                  ],
                  onChanged: (val) =>
                      setDialogState(() => status = val!),
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
                if (empId > 0) {
                  final now = DateTime.now();
                  await client.hr.markAttendance(
                    HrAttendance(
                      employeeId: empId,
                      date: now,
                      checkIn: now,
                      status: status,
                      createdAt: now,
                      updatedAt: now,
                    ),
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Presente':
        return Colors.green;
      case 'Ausente':
        return Colors.red;
      case 'Tardanza':
        return Colors.orange;
      case 'Permiso':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMobileCard(HrAttendance item, ThemeData theme) {
    final color = _statusColor(item.status);
    final fmt = DateFormat('HH:mm');
    final checkInStr =
        item.checkIn != null ? fmt.format(item.checkIn!) : 'â€”';
    final checkOutStr =
        item.checkOut != null ? fmt.format(item.checkOut!) : 'â€”';

    double? hours;
    if (item.checkIn != null && item.checkOut != null) {
      hours = item.checkOut!
          .difference(item.checkIn!)
          .inMinutes
          .toDouble() /
          60;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
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
                    Icon(Icons.person_outline,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Emp #${item.employeeId}',
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Entrada',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5))),
                      Text(checkInStr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Salida',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5))),
                      Text(checkOutStr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (hours != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Horas',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5))),
                      Text('${hours.toStringAsFixed(1)}h',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: hours >= 8 ? Colors.green : Colors.orange)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, dd MMM yyyy', 'es').format(item.date),
              style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Stats
    final total = _records.length;
    final presentes =
        _records.where((r) => r.status == 'Presente').length;
    final ausentes =
        _records.where((r) => r.status == 'Ausente').length;
    final tardanzas =
        _records.where((r) => r.status == 'Tardanza').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Registrar Asistencia',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Stats header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatChip(
                          label: 'Total',
                          value: '$total',
                          color: theme.colorScheme.primary),
                      _StatChip(
                          label: 'Presentes',
                          value: '$presentes',
                          color: Colors.green),
                      _StatChip(
                          label: 'Ausentes',
                          value: '$ausentes',
                          color: Colors.red),
                      _StatChip(
                          label: 'Tardanzas',
                          value: '$tardanzas',
                          color: Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: _records.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.event_note_outlined,
                                  size: 64, color: theme.disabledColor),
                              const SizedBox(height: 16),
                              Text('Sin registros este mes',
                                  style:
                                      TextStyle(color: theme.disabledColor)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _showAddDialog,
                                child: const Text('Registrar Asistencia'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _records.length,
                          itemBuilder: (context, index) {
                            return _buildMobileCard(
                                _records[index], theme);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ],
    );
  }
}

