import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum StatusType { success, warning, danger, info, neutral }

/// KPI Card ejecutiva con icono, valor y etiqueta
class RrhhKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool? isDark;

  const RrhhKpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDark =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: effectiveDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: effectiveDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: effectiveDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de estado con colores corporativos limpios
class RrhhStatusChip extends StatelessWidget {
  final String? status;
  final String? label;
  final StatusType? statusType;

  const RrhhStatusChip({
    super.key,
    this.status,
    this.label,
    this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveText = label ?? status ?? 'N/A';
    Color bg;
    Color fg;

    if (statusType != null) {
      switch (statusType!) {
        case StatusType.success:
          bg = const Color(0xFF10B981).withValues(alpha: 0.15);
          fg = const Color(0xFF10B981);
          break;
        case StatusType.warning:
          bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
          fg = const Color(0xFFF59E0B);
          break;
        case StatusType.danger:
          bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
          fg = const Color(0xFFEF4444);
          break;
        case StatusType.info:
          bg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
          fg = const Color(0xFF3B82F6);
          break;
        case StatusType.neutral:
          bg = Colors.grey.withValues(alpha: 0.15);
          fg = Colors.grey;
          break;
      }
    } else {
      switch (effectiveText.toUpperCase()) {
        case 'ACTIVO':
        case 'ACTIVA':
        case 'APROBADO':
        case 'SELECCIONADO':
          bg = const Color(0xFF10B981).withValues(alpha: 0.15);
          fg = const Color(0xFF10B981);
          break;
        case 'PENDIENTE':
        case 'EN_EVALUACION':
        case 'PROGRAMADA':
          bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
          fg = const Color(0xFFF59E0B);
          break;
        case 'INACTIVO':
        case 'RECHAZADO':
        case 'FINALIZADA':
        case 'CANCELADA':
          bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
          fg = const Color(0xFFEF4444);
          break;
        case 'NUEVO':
          bg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
          fg = const Color(0xFF3B82F6);
          break;
        case 'CONTRATADO':
          bg = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
          fg = const Color(0xFF8B5CF6);
          break;
        default:
          bg = Colors.grey.withValues(alpha: 0.15);
          fg = Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        effectiveText,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

/// Badge para identificar si el colaborador es de Oficina o de Campo
class RrhhEmployeeTypeBadge extends StatelessWidget {
  final String? employeeType;
  final String? type;

  const RrhhEmployeeTypeBadge({
    super.key,
    this.employeeType,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveType = employeeType ?? type ?? 'CAMPO';
    final isOffice =
        effectiveType.toUpperCase() == 'OFICINA' ||
        effectiveType.toUpperCase() == 'ADMINISTRATIVO';
    final color = isOffice ? const Color(0xFF8B5CF6) : const Color(0xFF06B6D4);
    final label = isOffice ? 'Oficina' : 'Campo';
    final icon = isOffice
        ? Icons.corporate_fare_outlined
        : Icons.storefront_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo con botón de copiado rápido al portapapeles
class RrhhCopyableField extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isSensitive;

  const RrhhCopyableField({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isSensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 15),
            tooltip: 'Copiar',
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado al portapapeles'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Estado vacío reutilizable
class RrhhEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final bool? isDark;
  final VoidCallback? onAction;
  final String? actionLabel;

  const RrhhEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off,
    this.isDark,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDark =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: effectiveDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: effectiveDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: effectiveDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add, size: 16),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Selector interactivo con buscador integrado en el menú (estilo Notion / Slack / Linear).
/// El campo principal se mantiene limpio y elegante; al abrirlo se despliega un panel
/// con barra de búsqueda dedicada en la cabecera para filtrar instantáneamente en tiempo real.
class RrhhSearchableSelector<T extends Object> extends StatelessWidget {
  final String label;
  final String hintText;
  final T? initialValue;
  final List<T> items;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final IconData? prefixIcon;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const RrhhSearchableSelector({
    super.key,
    required this.label,
    this.hintText = 'Seleccionar...',
    this.initialValue,
    required this.items,
    required this.itemLabel,
    this.itemSubtitle,
    this.prefixIcon,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = initialValue != null;
    final displayLabel = hasValue ? itemLabel(initialValue!) : hintText;
    final displaySubtitle = hasValue ? itemSubtitle?.call(initialValue!) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _openSearchPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasValue
                    ? (isDark
                          ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                          : const Color(0xFF93C5FD))
                    : (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1)),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  prefixIcon ??
                      (hasValue ? Icons.check_circle_outline : Icons.search),
                  size: 17,
                  color: hasValue
                      ? const Color(0xFF3B82F6)
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayLabel,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: hasValue
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: hasValue
                              ? (isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A))
                              : (isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8)),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (displaySubtitle != null &&
                          displaySubtitle.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          displaySubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF3B82F6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buscar',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.unfold_more,
                        size: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openSearchPicker(BuildContext context) async {
    final selected = await showDialog<T>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => _RrhhSearchPickerModal<T>(
        title: label,
        initialValue: initialValue,
        items: items,
        itemLabel: itemLabel,
        itemSubtitle: itemSubtitle,
        prefixIcon: prefixIcon,
      ),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _RrhhSearchPickerModal<T extends Object> extends StatefulWidget {
  final String title;
  final T? initialValue;
  final List<T> items;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final IconData? prefixIcon;

  const _RrhhSearchPickerModal({
    required this.title,
    required this.initialValue,
    required this.items,
    required this.itemLabel,
    this.itemSubtitle,
    this.prefixIcon,
  });

  @override
  State<_RrhhSearchPickerModal<T>> createState() =>
      _RrhhSearchPickerModalState<T>();
}

class _RrhhSearchPickerModalState<T extends Object>
    extends State<_RrhhSearchPickerModal<T>> {
  late TextEditingController _searchCtrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final normalizedQuery = _query.trim().toLowerCase();

    final filtered = widget.items.where((item) {
      if (normalizedQuery.isEmpty) return true;
      final label = widget.itemLabel(item).toLowerCase();
      final subtitle = widget.itemSubtitle?.call(item)?.toLowerCase() ?? '';
      return label.contains(normalizedQuery) ||
          subtitle.contains(normalizedQuery);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 460),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera con Título y Botón Cerrar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                child: Row(
                  children: [
                    Icon(
                      widget.prefixIcon ?? Icons.manage_search,
                      size: 18,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Barra de Búsqueda Integrada tipo Google (Notion/Slack style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0B1324)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribe para buscar instantáneamente...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                        color: Color(0xFF3B82F6),
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (val) => setState(() => _query = val),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Barra de conteo de coincidencias
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opciones encontradas (${filtered.length})',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      Text(
                        'Filtrado por: "$_query"',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Divider(height: 1),

              // Lista de Opciones Filtradas con Hover y Microinteracciones
              Flexible(
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 36,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 32,
                              color: isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No se encontraron coincidencias',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Prueba buscando con otro término o palabra clave.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (ctx, idx) =>
                            const SizedBox(height: 2),
                        itemBuilder: (ctx, index) {
                          final item = filtered[index];
                          final label = widget.itemLabel(item);
                          final subtitle = widget.itemSubtitle?.call(item);
                          final isSelected = widget.initialValue == item;

                          return Material(
                            color: isSelected
                                ? (isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFEFF6FF))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              hoverColor: isDark
                                  ? const Color(
                                      0xFF1E293B,
                                    ).withValues(alpha: 0.6)
                                  : const Color(0xFFF1F5F9),
                              onTap: () => Navigator.pop(context, item),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : (widget.prefixIcon ??
                                                Icons.chevron_right),
                                      size: 16,
                                      color: isSelected
                                          ? const Color(0xFF10B981)
                                          : (isDark
                                                ? const Color(0xFF64748B)
                                                : const Color(0xFF94A3B8)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            label,
                                            style: GoogleFonts.inter(
                                              fontSize: 12.5,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (subtitle != null &&
                                              subtitle.isNotEmpty) ...[
                                            const SizedBox(height: 1),
                                            Text(
                                              subtitle,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF10B981,
                                          ).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'Seleccionado',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF10B981),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
