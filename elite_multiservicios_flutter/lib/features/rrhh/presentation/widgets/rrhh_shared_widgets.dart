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

/// Selector de búsqueda predictiva en tiempo real (estilo Google Search).
/// Sustituye los Dropdowns toscos por una barra de búsqueda con sugerencias compactas y filtrado instantáneo.
class RrhhSearchableSelector<T extends Object> extends StatefulWidget {
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
    this.hintText = 'Escribe para buscar...',
    this.initialValue,
    required this.items,
    required this.itemLabel,
    this.itemSubtitle,
    this.prefixIcon = Icons.search,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  State<RrhhSearchableSelector<T>> createState() =>
      _RrhhSearchableSelectorState<T>();
}

class _RrhhSearchableSelectorState<T extends Object>
    extends State<RrhhSearchableSelector<T>> {
  late TextEditingController _textCtrl;
  late FocusNode _focusNode;
  final GlobalKey _fieldKey = GlobalKey();
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
    _textCtrl = TextEditingController(
      text: widget.initialValue != null
          ? widget.itemLabel(widget.initialValue!)
          : '',
    );
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant RrhhSearchableSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedItem = widget.initialValue;
      final newText = widget.initialValue != null
          ? widget.itemLabel(widget.initialValue!)
          : '';
      if (_textCtrl.text != newText) {
        _textCtrl.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RawAutocomplete<T>(
          textEditingController: _textCtrl,
          focusNode: _focusNode,
          displayStringForOption: widget.itemLabel,
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) {
              return widget.items;
            }
            return widget.items.where((item) {
              final label = widget.itemLabel(item).toLowerCase();
              final subtitle =
                  widget.itemSubtitle?.call(item)?.toLowerCase() ?? '';
              return label.contains(query) || subtitle.contains(query);
            });
          },
          onSelected: (T selection) {
            setState(() {
              _selectedItem = selection;
              _textCtrl.text = widget.itemLabel(selection);
            });
            widget.onChanged(selection);
          },
          fieldViewBuilder:
              (ctx, textEditingController, focusNode, onFieldSubmitted) {
                return TextFormField(
                  key: _fieldKey,
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hintText,
                    prefixIcon: Icon(
                      widget.prefixIcon ?? Icons.search,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            tooltip: 'Limpiar',
                            onPressed: () {
                              textEditingController.clear();
                              setState(() => _selectedItem = null);
                              widget.onChanged(null);
                            },
                          )
                        : const Icon(Icons.arrow_drop_down, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              },
          optionsViewBuilder: (ctx, onSelected, options) {
            final renderBox =
                _fieldKey.currentContext?.findRenderObject() as RenderBox?;
            final fieldWidth = renderBox?.size.width ?? 400.0;
            final optionList = options.toList();

            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                child: Container(
                  width: fieldWidth,
                  constraints: const BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: optionList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No se encontraron coincidencias',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shrinkWrap: true,
                          itemCount: optionList.length,
                          separatorBuilder: (ctx, idx) => Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          itemBuilder: (context, index) {
                            final item = optionList[index];
                            final label = widget.itemLabel(item);
                            final subtitle = widget.itemSubtitle?.call(item);
                            final isCurrent = _selectedItem == item;

                            return InkWell(
                              onTap: () => onSelected(item),
                              child: Container(
                                color: isCurrent
                                    ? (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFEFF6FF))
                                    : Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 9,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isCurrent
                                          ? Icons.check_circle
                                          : (widget.prefixIcon ?? Icons.search),
                                      size: 15,
                                      color: isCurrent
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
                                              fontWeight: isCurrent
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
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
