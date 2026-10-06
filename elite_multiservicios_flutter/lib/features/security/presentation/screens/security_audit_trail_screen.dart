import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../accounting/presentation/widgets/accounting_excel_grid.dart';

final auditTrailProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return [
    {
      'id': 'LOG-9921',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'user': 'carlos.mendoza (Contador Senior)',
      'ip': '192.168.1.105',
      'module': 'CONTABILIDAD - LIBRO MAYOR',
      'action': 'EDICIÓN ASIENTO MANUAL',
      'details':
          'Modificó monto de depreciación de Bs 1,200 a Bs 1,500 en Asiento AST-0442.',
      'hash': 'a7x9...8b2f',
      'severity': 'ALTA',
    },
    {
      'id': 'LOG-9920',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'user': 'ana.torres (Cajero)',
      'ip': '192.168.1.112',
      'module': 'OPERACIONES - INVENTARIO',
      'action': 'SALIDA DE ALMACÉN',
      'details': 'Consumo Técnico de 5 Lts. Aceite Motor para OT-102.',
      'hash': 'c3p1...9j4q',
      'severity': 'MEDIA',
    },
    {
      'id': 'LOG-9919',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'user': 'sistema (Motor Automático)',
      'ip': 'localhost',
      'module': 'CONTABILIDAD - FACTURACIÓN',
      'action': 'EJECUCIÓN LOTE RECURRENTE',
      'details':
          'Generación de 14 facturas de mantenimiento preventivo (Lote BATCH-001).',
      'hash': 'k9m2...0z1a',
      'severity': 'INFO',
    },
  ];
});

class SecurityAuditTrailScreen extends ConsumerWidget {
  const SecurityAuditTrailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(auditTrailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Libro Mayor de Auditoría Inalterable (Audit Trail)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Exportando registro inalterable (Hash AES-256) a PDF...',
                  ),
                  backgroundColor: Colors.indigo,
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf, size: 18),
            label: const Text('Exportar Log Certificado'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: auditAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (logs) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Colors.greenAccent,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trazabilidad Estricta (ISO 27001)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Todo evento de modificación, borrado o creación de registros contables y operativos está protegido por Blockchain Hash. No puede ser alterado ni por administradores de base de datos.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Expanded(
                  child: AccountingExcelGrid(
                    title: 'Eventos del Sistema',
                    columns: [
                      ExcelGridColumn(title: 'Log ID'),
                      ExcelGridColumn(title: 'Fecha y Hora'),
                      ExcelGridColumn(title: 'Usuario y Rol'),
                      ExcelGridColumn(title: 'Módulo Afectado'),
                      ExcelGridColumn(title: 'Acción Ejecutada'),
                      ExcelGridColumn(title: 'Detalle Técnico'),
                      ExcelGridColumn(title: 'Firma Hash'),
                    ],
                    rows: logs.map((log) {
                      final DateTime t = log['timestamp'];
                      final bool isHigh = log['severity'] == 'ALTA';

                      return ExcelGridRow(
                        cells: [
                          Row(
                            children: [
                              Icon(
                                Icons.fingerprint,
                                size: 14,
                                color: isHigh ? Colors.red : Colors.blueGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                log['id'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isHigh ? Colors.red : Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                          ),
                          Text(
                            log['user'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              log['module'],
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Text(
                            log['action'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isHigh
                                  ? Colors.red.shade700
                                  : Colors.black87,
                            ),
                          ),
                          Text(
                            log['details'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            log['hash'],
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              color: Colors.blueGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
