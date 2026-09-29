import 'package:flutter/material.dart';

class ExcelGridColumn {
  final String title;
  final bool isNumeric;
  final double? width;

  ExcelGridColumn({
    required this.title,
    this.isNumeric = false,
    this.width,
  });
}

class ExcelGridRow {
  final List<Widget> cells;

  /// Callback de doble tap (legacy, se mantiene por compatibilidad)
  final VoidCallback? onDoubleTap;

  /// Callback cuando el usuario presiona el botón de edición
  final VoidCallback? onEdit;

  /// Callback cuando el usuario presiona el botón de eliminar
  final VoidCallback? onDelete;

  ExcelGridRow({
    required this.cells,
    this.onDoubleTap,
    this.onEdit,
    this.onDelete,
  });
}

class AccountingExcelGrid extends StatelessWidget {
  final List<ExcelGridColumn> columns;
  final List<ExcelGridRow> rows;
  final String title;
  final VoidCallback? onAddRow;

  const AccountingExcelGrid({
    super.key,
    required this.columns,
    required this.rows,
    required this.title,
    this.onAddRow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final divider = theme.dividerColor;

    // Determina si alguna fila tiene acciones (editar/eliminar)
    final hasActions = rows.any((r) => r.onEdit != null || r.onDelete != null);

    // Columnas: "Acciones" PRIMERO para que sea siempre visible, luego las definidas
    final allColumns = [
      if (hasActions)
        const DataColumn(
          label: Text(
            'Acciones',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ...columns.map(
        (col) => DataColumn(
          label: Text(
            col.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          numeric: col.isNumeric,
        ),
      ),
    ];

    // Filas con celdas de acciones añadidas al final
    final allRows = rows.map((row) {
      final actionCell = DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (row.onEdit != null)
              Tooltip(
                message: 'Editar',
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: row.onEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            if (row.onEdit != null && row.onDelete != null)
              const SizedBox(width: 4),
            if (row.onDelete != null)
              Tooltip(
                message: 'Eliminar',
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: row.onDelete,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

      return DataRow(
        cells: [
          // Acciones PRIMERO — siempre visible
          if (hasActions) actionCell,
          ...row.cells.map(
            (widget) => DataCell(
              Container(
                alignment: Alignment.centerLeft,
                child: widget,
              ),
            ),
          ),
        ],
      );
    }).toList();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border(bottom: BorderSide(color: divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onAddRow != null)
                  ElevatedButton.icon(
                    onPressed: onAddRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Nueva Fila'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // ── Tabla ─────────────────────────────────────────────
          if (rows.isEmpty)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.table_rows_outlined,
                        size: 48,
                        color: theme.disabledColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No hay registros aún',
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 14,
                        ),
                      ),
                      if (onAddRow != null) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: onAddRow,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar primer registro'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Theme(
                    data: theme.copyWith(dividerColor: divider),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        primary.withValues(alpha: 0.1),
                      ),
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 56,
                      border: TableBorder(
                        verticalInside: BorderSide(color: divider, width: 1),
                        horizontalInside: BorderSide(color: divider, width: 1),
                        top: BorderSide(color: divider, width: 1),
                        bottom: BorderSide(color: divider, width: 1),
                        left: BorderSide(color: divider, width: 1),
                        right: BorderSide(color: divider, width: 1),
                      ),
                      columns: allColumns,
                      rows: allRows,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
