import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/crm_customers_service.dart';
import '../../data/crm_agenda_service.dart';

/// Vista ejecutiva del Directorio Clientes 360° y Sedes Operativas.
class CrmCustomersView extends StatefulWidget {
  const CrmCustomersView({super.key});

  @override
  State<CrmCustomersView> createState() => _CrmCustomersViewState();
}

class _CrmCustomersViewState extends State<CrmCustomersView> {
  final CrmCustomersService _service = CrmCustomersService();

  String _searchQuery = '';
  String _selectedSegment = 'Todos';
  String _selectedStatus = 'Todos';
  String _selectedContractType = 'Todos';
  String _selectedLifecycle = 'Todos';

  CustomerItem? _selectedCustomer;
  String _viewMode =
      'console'; // 'console' (Master-Detail), 'cards' (Mosaico), 'table' (Tabla)
  String _quickFilter =
      'Todos'; // 'Todos', 'Activos', 'En Servicio', 'Por Vencer', 'Recontratar', 'Recurrentes', 'Proyectos'

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    _service.loadCustomers();
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (_selectedCustomer != null) {
          _selectedCustomer =
              _service.getCustomerById(_selectedCustomer!.id) ??
              _selectedCustomer;
        }
        setState(() {});
      }
    });
  }

  List<CustomerItem> get _filteredCustomers {
    final list = _service.customers.where((c) {
      final q = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          c.legalName.toLowerCase().contains(q) ||
          c.tradeName.toLowerCase().contains(q) ||
          c.taxId.contains(q) ||
          c.contactPerson.toLowerCase().contains(q) ||
          c.branches.any(
            (b) =>
                b.name.toLowerCase().contains(q) ||
                b.address.toLowerCase().contains(q),
          );

      final matchesSegment =
          _selectedSegment == 'Todos' || c.segment == _selectedSegment;
      final matchesStatus =
          _selectedStatus == 'Todos' || c.status == _selectedStatus;
      final matchesContractType =
          _selectedContractType == 'Todos' ||
          c.primaryContractType == _selectedContractType ||
          c.contracts.any((ctr) => ctr.contractType == _selectedContractType);
      final matchesLifecycle =
          _selectedLifecycle == 'Todos' ||
          c.lifecycleStage == _selectedLifecycle;

      bool matchesQuickFilter = true;
      switch (_quickFilter) {
        case 'Activos':
          matchesQuickFilter = c.status == 'Activo';
          break;
        case 'En Servicio':
          matchesQuickFilter = c.lifecycleStage == 'En Servicio Activo';
          break;
        case 'Por Vencer':
          matchesQuickFilter = c.lifecycleStage == 'Por Vencer';
          break;
        case 'Recontratar':
          matchesQuickFilter = c.lifecycleStage == 'Listo para Recontratar';
          break;
        case 'Recurrentes':
          matchesQuickFilter =
              c.primaryContractType == 'Recurrente Mensual' ||
              c.contracts.any(
                (ctr) => ctr.contractType == 'Recurrente Mensual',
              );
          break;
        case 'Proyectos':
          matchesQuickFilter =
              c.primaryContractType == 'Proyecto Único' ||
              c.primaryContractType == 'Servicio por Evento' ||
              c.contracts.any(
                (ctr) =>
                    ctr.contractType == 'Proyecto Único' ||
                    ctr.contractType == 'Servicio por Evento',
              );
          break;
        default:
          matchesQuickFilter = true;
      }

      return matchesSearch &&
          matchesSegment &&
          matchesStatus &&
          matchesContractType &&
          matchesLifecycle &&
          matchesQuickFilter;
    }).toList();

    // Mantener sincronizado el cliente seleccionado en modo consola
    if (_selectedCustomer != null &&
        !list.any((c) => c.id == _selectedCustomer!.id)) {
      _selectedCustomer = list.isNotEmpty ? list.first : null;
    } else if (_selectedCustomer == null && list.isNotEmpty) {
      _selectedCustomer = list.first;
    }

    return list;
  }

  Color _getSegmentColor(String segment) {
    switch (segment) {
      case 'Corporativo B2B':
        return const Color(0xFF2563EB); // Azul Real
      case 'Residencial B2C':
        return const Color(0xFF059669); // Esmeralda
      case 'Sector Educativo':
        return const Color(0xFF7C3AED); // Violeta
      case 'Sector Público':
        return const Color(0xFFD97706); // Ámbar
      default:
        return const Color(0xFF475569); // Slate
    }
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return 'EM';
    if (words.length == 1) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  Widget _buildCompanyAvatar(
    CustomerItem customer, {
    double size = 48,
    double fontSize = 16,
  }) {
    final color = _getSegmentColor(customer.segment);
    final initials = _getInitials(customer.tradeName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.9),
            color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  double _calculateLtv(CustomerItem customer) {
    return customer.contracts.fold<double>(
      0.0,
      (acc, c) =>
          acc +
          (c.recurringMonthlyAmount > 0
              ? c.recurringMonthlyAmount * 12
              : c.totalAmount),
    );
  }

  // ===========================================================================
  // MODAL / INSPECTOR: FICHA DETALLADA 360°
  // ===========================================================================
  void _showCustomerDetail(CustomerItem customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          maxChildSize: 0.96,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return ListenableBuilder(
              listenable: _service,
              builder: (innerCtx, _) {
                final currentCustomer =
                    _service.getCustomerById(customer.id) ?? customer;
                return _buildCustomerDetailContent(
                  currentCustomer,
                  isDark,
                  isPane: false,
                  onClose: () => Navigator.of(ctx).pop(),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCustomerDetailContent(
    CustomerItem customer,
    bool isDark, {
    bool isPane = false,
    VoidCallback? onClose,
  }) {
    final ltv = _calculateLtv(customer);

    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: isPane
              ? BorderRadius.circular(16)
              : const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: isPane
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            if (!isPane) ...[
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              const SizedBox(height: 16),
            ],

            // 1. Hero Header del Cliente 360°
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyAvatar(customer, size: 52, fontSize: 17),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                customer.tradeName,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildLifecycleBadge(customer.lifecycleStage),
                            if (customer.hasActiveContracts ||
                                customer.status != 'Activo') ...[
                              const SizedBox(width: 6),
                              _buildStatusBadge(customer.status),
                            ],
                            if (onClose != null) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: onClose,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Cerrar',
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              customer.legalName,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
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
                                    'NIT: ${customer.taxId}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10.5,
                                      color: const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(text: customer.taxId),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'NIT copiado al portapapeles',
                                          ),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.copy,
                                      size: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Cinta de Métricas Financieras de la Cuenta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF161F30)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALOR LTV ESTIMADO',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Bs. ${ltv.toStringAsFixed(0)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 26,
                      width: 1,
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CANON MENSUAL',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.monthlyBilling > 0
                                  ? 'Bs. ${customer.monthlyBilling.toStringAsFixed(0)}/m'
                                  : 'Obra / Proyecto',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 26,
                      width: 1,
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COBERTURA SEDES',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${customer.branches.length} ${customer.branches.length == 1 ? 'Punto' : 'Puntos'}',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 26,
                      width: 1,
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SATISFACCIÓN',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Builder(
                              builder: (_) {
                                final avgRating = customer.averageSatisfaction;
                                final hasRating = avgRating != null;
                                return Row(
                                  children: [
                                    Icon(
                                      hasRating
                                          ? Icons.star
                                          : Icons.star_outline,
                                      size: 13,
                                      color: hasRating
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF94A3B8),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      hasRating
                                          ? '${avgRating.toStringAsFixed(1)} / 5.0'
                                          : 'Pendiente',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: hasRating ? 13.5 : 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: hasRating
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 3. Barra de Acciones Rápidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _showAddContractDialog(customer),
                      icon: const Icon(Icons.add_task, size: 16),
                      label: Text(
                        'Nuevo Contrato / Servicio',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    onPressed: () => _showAddBranchDialog(customer),
                    icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                    label: Text(
                      'Añadir Sede',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (customer.hasActiveContracts)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: customer.status == 'Activo'
                              ? const Color(0xFFD97706)
                              : const Color(0xFF10B981),
                        ),
                      ),
                      onPressed: () => _toggleCustomerStatus(customer),
                      icon: Icon(
                        customer.status == 'Activo'
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: 16,
                        color: customer.status == 'Activo'
                            ? const Color(0xFFD97706)
                            : const Color(0xFF10B981),
                      ),
                      label: Text(
                        customer.status == 'Activo' ? 'Pausar' : 'Activar',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: customer.status == 'Activo'
                              ? const Color(0xFFD97706)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF10B981),
                        ),
                      ),
                      onPressed: () => _showAddContractDialog(
                        customer,
                        prefilledContract: customer.contracts.isNotEmpty
                            ? customer.contracts.last
                            : null,
                      ),
                      icon: const Icon(
                        Icons.replay,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      label: Text(
                        'Recontratar',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 4. TabBar con estilo moderno
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                indicatorColor: const Color(0xFF10B981),
                indicatorWeight: 2.5,
                labelColor: const Color(0xFF10B981),
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Contratos & Obras (${customer.contracts.length})'),
                  Tab(text: 'Sedes Operativas (${customer.branches.length})'),
                  const Tab(text: 'Expediente & Fiscal'),
                ],
              ),
            ),

            // 5. Contenido de las pestañas
            Expanded(
              child: TabBarView(
                children: [
                  _buildContractsTab(customer, isDark),
                  _buildBranchesTab(customer, isDark),
                  _buildGeneralTab(customer, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab(CustomerItem customer, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'INFORMACIÓN FISCAL & CORPORATIVA',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'NIT / RUC',
                customer.taxId,
                Icons.badge_outlined,
                isDark,
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: customer.taxId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('NIT copiado al portapapeles'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Segmento de Mercado',
                customer.segment,
                Icons.pie_chart_outline,
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Modalidad Comercial Principal',
                customer.primaryContractType,
                Icons.handshake_outlined,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Fecha de Ingreso',
                customer.startDate ?? 'Registro Reciente',
                Icons.calendar_today_outlined,
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        Text(
          'CONTACTO PRINCIPAL & FACTURACIÓN',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'Persona de Contacto',
          customer.contactPerson,
          Icons.person_outline,
          isDark,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Teléfono Directo',
                customer.phone,
                Icons.phone_outlined,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Correo de Facturación',
                customer.email,
                Icons.mail_outline,
                isDark,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () => _toggleCustomerStatus(customer),
              icon: Icon(
                customer.status == 'Activo'
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 16,
                color: customer.status == 'Activo'
                    ? const Color(0xFFD97706)
                    : const Color(0xFF10B981),
              ),
              label: Text(
                customer.status == 'Activo'
                    ? 'Pausar Cuenta'
                    : 'Reactivar Cuenta',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBranchesTab(CustomerItem customer, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEDES REGISTRADAS (${customer.branches.length})',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'Ubicaciones físicas donde se ejecutan los servicios.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                elevation: 0,
              ),
              onPressed: () => _showAddBranchDialog(customer),
              icon: const Icon(Icons.add_location_alt, size: 16),
              label: Text(
                'Añadir Sede',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...customer.branches.map((b) => _buildBranchCard(b, isDark)),
      ],
    );
  }

  Widget _buildBranchCard(CustomerBranch branch, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: branch.isHeadquarters
              ? const Color(0xFF3B82F6).withValues(alpha: 0.6)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          width: branch.isHeadquarters ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (branch.isHeadquarters
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF64748B))
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  branch.isHeadquarters
                      ? Icons.domain
                      : Icons.location_on_outlined,
                  color: branch.isHeadquarters
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          branch.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        if (branch.isHeadquarters) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'SEDE MATRIZ',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      branch.address,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_pin_outlined,
                    size: 15,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Contacto Local: ',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    branch.localContact,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    branch.localPhone,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContractsTab(CustomerItem customer, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Resumen Financiero Consolidado
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABONO MENSUAL (MRR)',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bs. ${customer.monthlyBilling.toStringAsFixed(2)} / mes',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OBRAS & PROYECTOS CERRADOS',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bs. ${customer.totalProjectBilling.toStringAsFixed(2)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HISTORIAL DE CONTRATOS & SERVICIOS (${customer.contracts.length})',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (customer.contracts.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('Sin contratos registrados para este cliente.'),
            ),
          )
        else
          ...customer.contracts.map(
            (ctr) => _buildContractCard(ctr, customer, isDark),
          ),
      ],
    );
  }

  Widget _buildContractCard(
    CustomerContract contract,
    CustomerItem customer,
    bool isDark,
  ) {
    final typeColor = _getContractTypeColor(contract.contractType);
    final isCompleted = contract.status == 'Completado';
    final isActive =
        contract.status == 'Vigente' || contract.status == 'En Ejecución';
    final isPaused = contract.status == 'En Pausa';
    final isRecurring =
        contract.contractType == 'Recurrente Mensual' ||
        contract.contractType == 'Híbrido';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: typeColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        contract.contractType.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: typeColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        contract.serviceCategory,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (contract.branchName != null &&
                        contract.branchName!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF3B82F6,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              contract.branchName!,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: const Color(0xFF3B82F6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildOriginBadge(contract.originType),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : (isActive
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.12)
                            : (contract.status == 'Cancelado'
                                  ? const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.15)
                                  : (contract.status == 'En Renegociación'
                                        ? const Color(
                                            0xFF8B5CF6,
                                          ).withValues(alpha: 0.15)
                                        : const Color(
                                            0xFFF59E0B,
                                          ).withValues(alpha: 0.12)))),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contract.status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : (isActive
                              ? const Color(0xFF3B82F6)
                              : (contract.status == 'Cancelado'
                                    ? const Color(0xFFEF4444)
                                    : (contract.status == 'En Renegociación'
                                          ? const Color(0xFF8B5CF6)
                                          : const Color(0xFFF59E0B)))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            contract.title,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 14,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                contract.executionTime,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.payments_outlined,
                size: 14,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  contract.paymentTerms,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Si está completado, mostrar datos de entrega y conformidad
          if (isCompleted) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF10B981),
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Entrega Conforme: ${contract.actualEndDate ?? contract.startDate}',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          contract.satisfactionRating ?? 5,
                          (i) => const Icon(
                            Icons.star,
                            color: Color(0xFFF59E0B),
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (contract.completionNotes != null &&
                      contract.completionNotes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '"${contract.completionNotes}"',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Alcance Técnico del Servicio
          if (contract.serviceScope != null &&
              contract.serviceScope!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.engineering_outlined,
                        size: 14,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Alcance Técnico & Especificaciones:',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    contract.serviceScope!.trim(),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Partidas Presupuestarias Cotizadas
          if (contract.budgetItems.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 14,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Presupuesto Desglosado (${contract.budgetItems.length} partidas):',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: Bs. ${contract.budgetItems.fold<double>(0.0, (sum, item) => sum + item.subtotal).toStringAsFixed(2)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...contract.budgetItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 5,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.description,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF334155),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 2)} ${item.unit} x Bs. ${item.unitPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Bs. ${item.subtotal.toStringAsFixed(2)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Importes y botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inicio: ${contract.startDate}',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              if (contract.contractType == 'Recurrente Mensual')
                Text(
                  'Canon: Bs. ${contract.recurringMonthlyAmount.toStringAsFixed(2)} / mes',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                )
              else if (contract.contractType == 'Híbrido')
                Text(
                  'Obra: Bs. ${contract.oneTimeAmount.toStringAsFixed(0)} + Bs. ${contract.recurringMonthlyAmount.toStringAsFixed(0)}/mes',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B82F6),
                  ),
                )
              else
                Text(
                  'Monto: Bs. ${contract.oneTimeAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: typeColor,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // BARRA DE ACCIONES OPERATIVAS Y RECONTRATO
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (isActive || contract.status == 'En Renegociación') ...[
                if (isActive)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () =>
                        _showCompleteContractDialog(customer, contract),
                    icon: const Icon(Icons.check_circle_outline, size: 14),
                    label: Text(
                      'Concluir Trabajo',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (isRecurring && isActive)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6366F1),
                      side: const BorderSide(color: Color(0xFF6366F1)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () =>
                        _showRenewContractDialog(customer, contract),
                    icon: const Icon(Icons.autorenew, size: 14),
                    label: Text(
                      'Renovar (+12m)',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (isActive)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD97706),
                      side: const BorderSide(color: Color(0xFFD97706)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () {
                      _service.updateContractStatus(
                        customer.id,
                        contract.id,
                        'En Pausa',
                      );
                      if (_selectedCustomer?.id == customer.id) {
                        _selectedCustomer = _service.getCustomerById(
                          customer.id,
                        );
                        setState(() {});
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contrato puesto en pausa.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.pause, size: 14),
                    label: Text(
                      'Pausar',
                      style: GoogleFonts.inter(fontSize: 11.5),
                    ),
                  ),
                if (contract.status == 'En Pausa' ||
                    contract.status == 'En Renegociación')
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3B82F6),
                      side: const BorderSide(color: Color(0xFF3B82F6)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () =>
                        _showReopenNegotiationDialog(customer, contract),
                    icon: const Icon(Icons.sync_alt, size: 14),
                    label: Text(
                      contract.status == 'En Renegociación'
                          ? 'Actualizar Renegociación'
                          : 'Reabrir Negociación',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (contract.status != 'Culminado' &&
                    contract.status != 'Cancelado')
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: () =>
                        _showCancelContractDialog(customer, contract),
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: Text(
                      'Cancelar Contrato',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
              if (isCompleted)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                    elevation: 0,
                  ),
                  onPressed: () => _showAddContractDialog(
                    customer,
                    prefilledContract: contract,
                  ),
                  icon: const Icon(Icons.replay, size: 14),
                  label: Text(
                    'Volver a Contratar este Servicio',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (isPaused)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () {
                    _service.updateContractStatus(
                      customer.id,
                      contract.id,
                      'Vigente',
                    );
                    if (_selectedCustomer?.id == customer.id) {
                      _selectedCustomer = _service.getCustomerById(customer.id);
                      setState(() {});
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contrato reactivado exitosamente.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, size: 14),
                  label: Text(
                    'Reactivar',
                    style: GoogleFonts.inter(fontSize: 11.5),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOriginBadge(String origin) {
    Color col;
    switch (origin) {
      case 'Recontratación':
        col = const Color(0xFF10B981);
        break;
      case 'Renovación':
        col = const Color(0xFF6366F1);
        break;
      case 'Adicional':
        col = const Color(0xFF06B6D4);
        break;
      default:
        col = const Color(0xFF64748B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: col.withValues(alpha: 0.25)),
      ),
      child: Text(
        origin,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: col,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    bool isDark, {
    VoidCallback? onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
              if (onCopy != null)
                InkWell(
                  onTap: onCopy,
                  child: const Icon(
                    Icons.copy,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                )
              else
                Icon(icon, size: 14, color: const Color(0xFF64748B)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getContractTypeColor(String type) {
    switch (type) {
      case 'Recurrente Mensual':
        return const Color(0xFF10B981);
      case 'Proyecto Único':
        return const Color(0xFF8B5CF6);
      case 'Servicio por Evento':
        return const Color(0xFFF59E0B);
      case 'Híbrido':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF64748B);
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Activo':
        color = const Color(0xFF10B981);
        break;
      case 'En Pausa':
        color = const Color(0xFFD97706);
        break;
      default:
        color = const Color(0xFFEF4444);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildLifecycleBadge(String stage) {
    Color color;
    switch (stage) {
      case 'En Servicio Activo':
        color = const Color(0xFF10B981);
        break;
      case 'Por Vencer':
        color = const Color(0xFFD97706);
        break;
      default:
        color = const Color(0xFF8B5CF6); // Listo para Recontratar
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        stage,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _toggleCustomerStatus(CustomerItem customer) {
    final nextStatus = customer.status == 'Activo' ? 'En Pausa' : 'Activo';
    _service.updateCustomer(customer.copyWith(status: nextStatus));
    if (_selectedCustomer?.id == customer.id) {
      _selectedCustomer = _service.getCustomerById(customer.id);
      setState(() {});
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Estado de ${customer.tradeName} actualizado a $nextStatus',
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  // ===========================================================================
  // MODAL: CONCLUIR TRABAJO / SERVICIO FORMALMENTE
  // ===========================================================================
  void _showCompleteContractDialog(
    CustomerItem customer,
    CustomerContract contract,
  ) {
    final now = DateTime.now();
    final dateCtrl = TextEditingController(
      text: '${now.day} ${_getMonthName(now.month)} ${now.year}',
    );
    final notesCtrl = TextEditingController(
      text:
          'Recepción conforme de servicio sin observaciones. Entrega a satisfacción del cliente.',
    );
    int rating = 5;
    bool scheduleQualityCheck = false;

    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
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
                      Icons.assignment_turned_in,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Concluir y Entregar Trabajo',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente: ${customer.tradeName} | Sede: ${contract.branchName ?? "Matriz"}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Fecha Real de Conclusión *',
                        isDense: true,
                        prefixIcon: Icon(Icons.calendar_today, size: 16),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'CALIFICACIÓN DE CONFORMIDAD DEL CLIENTE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36),
                          icon: Icon(
                            starIndex <= rating
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFF59E0B),
                            size: 26,
                          ),
                          onPressed: () {
                            setDialogState(() => rating = starIndex);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Acta de Entrega / Observaciones de Cierre',
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setDialogState(() {
                          scheduleQualityCheck = !scheduleQualityCheck;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: scheduleQualityCheck
                                ? const Color(0xFF10B981)
                                : (isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: scheduleQualityCheck,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (val) {
                                setDialogState(() {
                                  scheduleQualityCheck = val ?? false;
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Agendar control de calidad en Agenda (Opcional)',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Desmarcado por defecto. Si no se marca, no se creará ninguna tarea.',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Confirmar Conclusión'),
                  onPressed: () async {
                    await _service.completeContract(
                      customer.id,
                      contract.id,
                      completionDate: dateCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
                      rating: rating,
                    );
                    if (scheduleQualityCheck) {
                      CrmAgendaService().scheduleQualityCheckTask(
                        clientName: customer.tradeName,
                        contactPerson: customer.contactPerson,
                        phone: customer.phone,
                        contractTitle: contract.title,
                        customerId: customer.id,
                        contractId: contract.id,
                      );
                    }
                    if (dCtx.mounted) Navigator.of(dCtx).pop();
                    if (!mounted) return;
                    if (_selectedCustomer?.id == customer.id) {
                      _selectedCustomer = _service.getCustomerById(customer.id);
                      setState(() {});
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF065F46),
                        content: Text(
                          scheduleQualityCheck
                              ? 'Trabajo concluido con éxito. Tarea de control de calidad (72h) agendada en la Agenda Comercial.'
                              : 'Trabajo concluido con éxito y registrado en el historial del cliente.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // MODAL: RENOVAR CONTRATO RECURRENTE
  // ===========================================================================
  void _showRenewContractDialog(
    CustomerItem customer,
    CustomerContract contract,
  ) {
    int additionalMonths = 12;
    final amountCtrl = TextEditingController(
      text: contract.recurringMonthlyAmount.toStringAsFixed(0),
    );
    final notesCtrl = TextEditingController(
      text:
          'Renovación acordada con cliente. Plazo extendido +12 meses con tarifa pactada.',
    );

    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.autorenew,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Renovación Express de Contrato',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: additionalMonths,
                      decoration: const InputDecoration(
                        labelText: 'Período Adicional de Extensión *',
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 6,
                          child: Text('+6 Meses Adicionales'),
                        ),
                        DropdownMenuItem(
                          value: 12,
                          child: Text('+12 Meses (1 Año Adicional)'),
                        ),
                        DropdownMenuItem(
                          value: 24,
                          child: Text('+24 Meses (2 Años Adicionales)'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() {
                            additionalMonths = v;
                            notesCtrl.text =
                                'Renovación acordada con cliente. Plazo extendido +$v meses.';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Canon Mensual Ajustado (Bs.) *',
                        isDense: true,
                        prefixText: 'Bs. ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones / Términos de la Renovación',
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.autorenew, size: 16),
                  label: const Text('Confirmar Renovación'),
                  onPressed: () async {
                    final parsed =
                        double.tryParse(amountCtrl.text.trim()) ??
                        contract.recurringMonthlyAmount;
                    await _service.renewContract(
                      customer.id,
                      contract.id,
                      additionalMonths: additionalMonths,
                      adjustedMonthlyAmount: parsed,
                      notes: notesCtrl.text.trim(),
                    );
                    if (dCtx.mounted) Navigator.of(dCtx).pop();
                    if (!mounted) return;
                    if (_selectedCustomer?.id == customer.id) {
                      _selectedCustomer = _service.getCustomerById(customer.id);
                      setState(() {});
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF4338CA),
                        content: Text(
                          'Contrato renovado con éxito por +$additionalMonths meses.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // MODAL: REABRIR NEGOCIACIÓN EN PIPELINE
  // ===========================================================================
  void _showReopenNegotiationDialog(
    CustomerItem customer,
    CustomerContract contract,
  ) {
    final reasonCtrl = TextEditingController(
      text: 'Cliente solicitó ajuste de partidas presupuestarias y alcance.',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
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
                      Icons.sync_alt,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reabrir Negociación en Pipeline',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Devuelve la oportunidad al Pipeline para modificar la cotización.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cliente: ${customer.tradeName} | ID Oportunidad: ${customer.opportunityId ?? "Asociada"}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: reasonCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Motivo / Justificación de Reapertura *',
                          hintText:
                              'Indicá la razón por la que se reabre la negociación...',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Requerido'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.sync_alt, size: 16),
                  label: const Text('Reabrir en Negociación'),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await _service.reopenContractNegotiation(
                        customer.id,
                        contract.id,
                        reason: reasonCtrl.text.trim(),
                        opportunityId: customer.opportunityId,
                      );
                      if (dCtx.mounted) Navigator.of(dCtx).pop();
                      if (!mounted) return;
                      if (_selectedCustomer?.id == customer.id) {
                        _selectedCustomer = _service.getCustomerById(
                          customer.id,
                        );
                        setState(() {});
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF1E3A8A),
                          content: Text(
                            'Negociación reabierta. La oportunidad se movió a la etapa "Negociación" en el Pipeline.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // MODAL: CANCELAR / RESCINDIR CONTRATO
  // ===========================================================================
  void _showCancelContractDialog(
    CustomerItem customer,
    CustomerContract contract,
  ) {
    final reasonCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cancelar / Rescindir Contrato',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Registra formalmente la rescisión o cancelación del servicio.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cliente: ${customer.tradeName} | Sede: ${contract.branchName ?? "Matriz"}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: reasonCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Motivo de Rescisión / Cancelación *',
                          hintText:
                              'Indicá el motivo formal de la cancelación...',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Requerido'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Volver'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.cancel, size: 16),
                  label: const Text('Confirmar Cancelación'),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await _service.cancelContract(
                        customer.id,
                        contract.id,
                        reason: reasonCtrl.text.trim(),
                      );
                      if (dCtx.mounted) Navigator.of(dCtx).pop();
                      if (!mounted) return;
                      if (_selectedCustomer?.id == customer.id) {
                        _selectedCustomer = _service.getCustomerById(
                          customer.id,
                        );
                        setState(() {});
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF7F1D1D),
                          content: Text(
                            'Contrato cancelado / rescindido con éxito.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS DEL PRESUPUESTADOR & COTIZADOR
  // ===========================================================================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF64748B),
        letterSpacing: 0.6,
      ),
    );
  }

  static const List<Map<String, String>> _kCategoryOptions = [
    {'value': 'Limpieza Integral', 'label': 'Limpieza Integral & Desinfección'},
    {'value': 'Seguridad Física', 'label': 'Seguridad Física & Vigilancia'},
    {'value': 'Mantenimiento', 'label': 'Mantenimiento Técnico & Edilicio'},
    {
      'value': 'Software / Tecnología',
      'label': 'Software & Infraestructura TI',
    },
    {'value': 'Jardinería', 'label': 'Jardinería & Paisajismo'},
  ];

  static String _canonicalCategory(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return 'Limpieza Integral';
    }
    final lower = raw.toLowerCase().trim();
    if (lower.contains('limpi')) {
      return 'Limpieza Integral';
    }
    if (lower.contains('segur')) {
      return 'Seguridad Física';
    }
    if (lower.contains('manten')) {
      return 'Mantenimiento';
    }
    if (lower.contains('soft') ||
        lower.contains('tecno') ||
        lower.contains('sist')) {
      return 'Software / Tecnología';
    }
    if (lower.contains('jardin')) {
      return 'Jardinería';
    }
    return 'Limpieza Integral';
  }

  String _getDefaultScopeForCategory(String rawCategory) {
    final category = _canonicalCategory(rawCategory);
    switch (category) {
      case 'Seguridad Física':
        return 'Servicio de vigilancia física y control de accesos. Incluye guardias de seguridad uniformados, rondas perimetrales continuas, libro de novedades digital y respuesta rápida ante contingencias.';
      case 'Limpieza Integral':
        return 'Servicio de limpieza técnica integral y desinfección en áreas comunes, pasillos y sanitarios de lunes a sábado. Incluye provisión mensual de químicos certificados, aspirado y pulido de pisos.';
      case 'Mantenimiento':
        return 'Mantenimiento preventivo mensual y correctivo prioritario 24/7 de tableros eléctricos, generadores de respaldo y bombas de agua. Incluye actas técnicas de entrega y control de carga.';
      case 'Software / Tecnología':
        return 'Administración y soporte de infraestructura de redes, seguridad perimetral de firewall, respaldo automático en nube de servidores y mesa de ayuda para colaboradores.';
      case 'Jardinería':
        return 'Mantenimiento integral de áreas verdes, corte de césped, poda formativa de arbustos, desmalezado y control fitosanitario con frecuencia quincenal.';
      default:
        return 'Prestación de servicios profesionales de calidad según las necesidades operativas de la cuenta.';
    }
  }

  List<ContractBudgetItem> _getDefaultBudgetItemsForCategory(
    String rawCategory,
    String contractType,
  ) {
    final category = _canonicalCategory(rawCategory);
    final isRecurrent = contractType == 'Recurrente Mensual';
    switch (category) {
      case 'Seguridad Física':
        return [
          ContractBudgetItem(
            id: 'ITM-1',
            description:
                'Puesto de Vigilancia Física 24/7 (Guardias rotativos)',
            quantity: 2,
            unit: isRecurrent ? 'Mes' : 'Puesto',
            unitPrice: 3800,
          ),
          ContractBudgetItem(
            id: 'ITM-2',
            description: 'Equipamiento táctico, linternas y libro de control',
            quantity: 1,
            unit: isRecurrent ? 'Mes' : 'Global',
            unitPrice: 600,
          ),
        ];
      case 'Limpieza Integral':
        return [
          ContractBudgetItem(
            id: 'ITM-1',
            description: 'Operarios de limpieza integral (Turno matutino)',
            quantity: 2,
            unit: isRecurrent ? 'Mes' : 'Mes',
            unitPrice: 2800,
          ),
          ContractBudgetItem(
            id: 'ITM-2',
            description: 'Insumos químicos industriales y bolsas de residuos',
            quantity: 1,
            unit: isRecurrent ? 'Mes' : 'Global',
            unitPrice: 1200,
          ),
        ];
      case 'Mantenimiento':
        return [
          ContractBudgetItem(
            id: 'ITM-1',
            description: 'Inspección técnica preventiva y diagnóstico mensual',
            quantity: 1,
            unit: isRecurrent ? 'Mes' : 'Global',
            unitPrice: 3200,
          ),
          ContractBudgetItem(
            id: 'ITM-2',
            description: 'Disponibilidad para emergencias correctivas 24/7',
            quantity: 1,
            unit: isRecurrent ? 'Mes' : 'Global',
            unitPrice: 1500,
          ),
        ];
      case 'Software / Tecnología':
        return [
          ContractBudgetItem(
            id: 'ITM-1',
            description: 'Administración de red, servidores y backups',
            quantity: 1,
            unit: isRecurrent ? 'Mes' : 'Global',
            unitPrice: 4000,
          ),
          ContractBudgetItem(
            id: 'ITM-2',
            description: 'Soporte técnico y mesa de ayuda Helpdesk',
            quantity: 8,
            unit: 'Horas',
            unitPrice: 150,
          ),
        ];
      default:
        return [
          ContractBudgetItem(
            id: 'ITM-1',
            description: 'Mantenimiento de áreas verdes y jardines',
            quantity: 2,
            unit: isRecurrent ? 'Mes' : 'Visita',
            unitPrice: 1800,
          ),
        ];
    }
  }

  // ===========================================================================
  // MODAL: PRESUPUESTADOR & COTIZADOR INTEGRAL (NUEVO CONTRATO / RECONTRATACIÓN)
  // ===========================================================================
  void _showAddContractDialog(
    CustomerItem customer, {
    CustomerContract? prefilledContract,
  }) {
    final isRecontract = prefilledContract != null;
    final initialCategoryRaw = isRecontract
        ? prefilledContract.serviceCategory
        : (customer.activeServices.isNotEmpty
              ? customer.activeServices.first
              : 'Limpieza Integral');
    String category = _canonicalCategory(initialCategoryRaw);
    String contractType = isRecontract
        ? prefilledContract.contractType
        : 'Recurrente Mensual';

    final titleCtrl = TextEditingController(
      text: isRecontract
          ? '${prefilledContract.title} (Recontratación)'
          : 'Servicio de $category para ${customer.tradeName}',
    );

    final scopeCtrl = TextEditingController(
      text:
          isRecontract &&
              prefilledContract.serviceScope != null &&
              prefilledContract.serviceScope!.isNotEmpty
          ? prefilledContract.serviceScope
          : _getDefaultScopeForCategory(category),
    );

    final termsCtrl = TextEditingController(
      text: isRecontract
          ? prefilledContract.paymentTerms
          : (contractType == 'Recurrente Mensual'
                ? 'Facturación mensual a 30 días'
                : '50% Anticipo / 50% Entrega Conforme'),
    );

    final timeCtrl = TextEditingController(
      text: isRecontract
          ? prefilledContract.executionTime
          : (contractType == 'Recurrente Mensual'
                ? 'Contrato 12 meses'
                : '15 días hábiles'),
    );

    int advancePct = isRecontract
        ? prefilledContract.advancePercentage
        : (contractType == 'Recurrente Mensual' ? 0 : 50);

    String? selectedBranchId;
    if (customer.branches.isNotEmpty) {
      if (isRecontract &&
          prefilledContract.branchId != null &&
          customer.branches.any((b) => b.id == prefilledContract.branchId)) {
        selectedBranchId = prefilledContract.branchId;
      } else {
        selectedBranchId = customer.branches.first.id;
      }
    }

    // Lista de partidas presupuestarias
    List<ContractBudgetItem> budgetItems = [];
    if (isRecontract && prefilledContract.budgetItems.isNotEmpty) {
      budgetItems = List.from(prefilledContract.budgetItems);
    } else {
      budgetItems = _getDefaultBudgetItemsForCategory(category, contractType);
    }

    final formKey = GlobalKey<FormState>();
    int currentTab = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            final isRecurrent = contractType == 'Recurrente Mensual';

            // Cálculo dinámico del total de partidas
            final totalBudget = budgetItems.fold<double>(
              0.0,
              (acc, item) => acc + item.subtotal,
            );

            return Dialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: SizedBox(
                width: math.min(1160.0, MediaQuery.of(ctx).size.width - 40),
                height: math.min(880.0, MediaQuery.of(ctx).size.height - 40),
                child: Column(
                  children: [
                    // 1. Cabecera del Cotizador
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF131D31)
                            : const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  (isRecontract
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF2563EB))
                                      .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isRecontract
                                  ? Icons.replay
                                  : Icons.calculate_outlined,
                              color: isRecontract
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF2563EB),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isRecontract
                                          ? 'Recontratación & Cotizador Integral'
                                          : 'Armar Presupuesto & Nuevo Contrato',
                                      style: GoogleFonts.inter(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF2563EB,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF2563EB,
                                          ).withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Text(
                                        customer.tradeName,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF3B82F6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Definí el alcance técnico, costeá partidas con cálculo automático y formalizá las condiciones contractuales.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            tooltip: 'Cerrar',
                            onPressed: () => Navigator.of(dCtx).pop(),
                          ),
                        ],
                      ),
                    ),

                    // 2. BARRA DE PESTAÑAS (SEGMENTED TABS) CON ESTILO ENTERPRISE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF10192B)
                            : const Color(0xFFF1F5F9),
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setDialogState(() => currentTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: currentTab == 0
                                        ? const Color(0xFF2563EB)
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 16,
                                    color: currentTab == 0
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '1. Alcance Técnico & Sede',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: currentTab == 0
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: currentTab == 0
                                          ? (isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A))
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () => setDialogState(() => currentTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: currentTab == 1
                                        ? const Color(0xFF2563EB)
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 16,
                                    color: currentTab == 1
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '2. Presupuesto & Partidas',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: currentTab == 1
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: currentTab == 1
                                          ? (isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A))
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${budgetItems.length} ítems',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. CONTENIDO ESPACIOSO A ANCHO COMPLETO (SEGÚN PESTAÑA ACTIVA)
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: currentTab == 0
                              ? // ==================== PESTAÑA 1: ALCANCE TÉCNICO Y SEDE ====================
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isRecontract)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 18,
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF10B981,
                                          ).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF10B981,
                                            ).withValues(alpha: 0.25),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.verified_outlined,
                                              size: 20,
                                              color: Color(0xFF10B981),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Recontratación de cuenta: Podés ajustar la categoría de servicio o sede según los nuevos requerimientos del cliente.',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.5,
                                                  color: const Color(
                                                    0xFF10B981,
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Tarjeta 1: Parámetros del Servicio & Sede
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF131D31)
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle(
                                            'PARÁMETROS DEL SERVICIO Y SEDE OPERATIVA',
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: DropdownButtonFormField<String>(
                                                  key: ValueKey(
                                                    'cat_$category',
                                                  ),
                                                  initialValue: category,
                                                  isExpanded: true,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Categoría de Servicio *',
                                                    isDense: true,
                                                  ),
                                                  items: _kCategoryOptions
                                                      .map(
                                                        (
                                                          opt,
                                                        ) => DropdownMenuItem(
                                                          value: opt['value']!,
                                                          child: Text(
                                                            opt['label']!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (v) {
                                                    if (v != null &&
                                                        v != category) {
                                                      setDialogState(() {
                                                        category = v;
                                                        titleCtrl.text =
                                                            'Servicio de $category para ${customer.tradeName}';
                                                        scopeCtrl.text =
                                                            _getDefaultScopeForCategory(
                                                              v,
                                                            );
                                                        budgetItems =
                                                            _getDefaultBudgetItemsForCategory(
                                                              v,
                                                              contractType,
                                                            );
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: DropdownButtonFormField<String>(
                                                  key: ValueKey(
                                                    'type_$contractType',
                                                  ),
                                                  initialValue: contractType,
                                                  isExpanded: true,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Modalidad de Contratación *',
                                                    isDense: true,
                                                  ),
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value:
                                                          'Recurrente Mensual',
                                                      child: Text(
                                                        'Recurrente Mensual',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Proyecto Único',
                                                      child: Text(
                                                        'Proyecto Único / Obra',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value:
                                                          'Servicio por Evento',
                                                      child: Text(
                                                        'Servicio por Evento',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Híbrido',
                                                      child: Text(
                                                        'Híbrido (Mensual + Obra)',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (v) {
                                                    if (v != null) {
                                                      setDialogState(() {
                                                        contractType = v;
                                                        if (v ==
                                                            'Recurrente Mensual') {
                                                          termsCtrl.text =
                                                              'Facturación mensual a 30 días';
                                                          timeCtrl.text =
                                                              'Contrato 12 meses';
                                                          advancePct = 0;
                                                        } else if (v ==
                                                            'Servicio por Evento') {
                                                          termsCtrl.text =
                                                              '50% Anticipo / 50% Cierre del Evento';
                                                          timeCtrl.text =
                                                              '3 días (Feria / Evento)';
                                                          advancePct = 50;
                                                        } else {
                                                          termsCtrl.text =
                                                              '50% Anticipo / 50% Entrega Conforme';
                                                          timeCtrl.text =
                                                              '15 días hábiles';
                                                          advancePct = 50;
                                                        }
                                                        budgetItems =
                                                            _getDefaultBudgetItemsForCategory(
                                                              category,
                                                              v,
                                                            );
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          DropdownButtonFormField<String?>(
                                            key: ValueKey(
                                              'branch_$selectedBranchId',
                                            ),
                                            initialValue:
                                                customer.branches.any(
                                                  (b) =>
                                                      b.id == selectedBranchId,
                                                )
                                                ? selectedBranchId
                                                : (customer.branches.isNotEmpty
                                                      ? customer
                                                            .branches
                                                            .first
                                                            .id
                                                      : null),
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Sede Operativa Asignada *',
                                              prefixIcon: Icon(
                                                Icons.business_outlined,
                                                size: 20,
                                              ),
                                              isDense: true,
                                            ),
                                            items: customer.branches.isEmpty
                                                ? const [
                                                    DropdownMenuItem<String?>(
                                                      value: null,
                                                      child: Text(
                                                        'Sin sedes asignadas',
                                                      ),
                                                    ),
                                                  ]
                                                : customer.branches
                                                      .map(
                                                        (b) =>
                                                            DropdownMenuItem<
                                                              String?
                                                            >(
                                                              value: b.id,
                                                              child: Text(
                                                                '${b.name} — ${b.address}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                      )
                                                      .toList(),
                                            onChanged: (v) {
                                              if (v != null) {
                                                setDialogState(
                                                  () => selectedBranchId = v,
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            controller: titleCtrl,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Nombre / Objeto del Contrato *',
                                              hintText:
                                                  'Ej: Servicio Integral de Limpieza Técnica y Sanitización para Torre Titanium',
                                              prefixIcon: Icon(
                                                Icons.description_outlined,
                                                size: 20,
                                              ),
                                              isDense: true,
                                            ),
                                            validator: (v) =>
                                                (v == null || v.trim().isEmpty)
                                                ? 'Requerido'
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    // Tarjeta 2: Condiciones Comerciales
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF131D31)
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle(
                                            'CONDICIONES COMERCIALES, PLAZOS Y ANTICIPOS',
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: TextFormField(
                                                  controller: timeCtrl,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Plazo de Ejecución / Duración *',
                                                    isDense: true,
                                                  ),
                                                  validator: (v) =>
                                                      (v == null ||
                                                          v.trim().isEmpty)
                                                      ? 'Requerido'
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  controller: termsCtrl,
                                                  decoration: const InputDecoration(
                                                    labelText:
                                                        'Condiciones de Facturación & Pago *',
                                                    isDense: true,
                                                  ),
                                                  validator: (v) =>
                                                      (v == null ||
                                                          v.trim().isEmpty)
                                                      ? 'Requerido'
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                flex: 2,
                                                child: DropdownButtonFormField<int>(
                                                  key: ValueKey(
                                                    'adv_$advancePct',
                                                  ),
                                                  initialValue:
                                                      const [
                                                        0,
                                                        30,
                                                        50,
                                                        70,
                                                        100,
                                                      ].contains(advancePct)
                                                      ? advancePct
                                                      : 0,
                                                  isExpanded: true,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText:
                                                            '% Anticipo Inicial',
                                                        isDense: true,
                                                      ),
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 0,
                                                      child: Text(
                                                        '0% (Planilla mensual)',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 30,
                                                      child: Text(
                                                        '30% Anticipo',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 50,
                                                      child: Text(
                                                        '50% Anticipo',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 70,
                                                      child: Text(
                                                        '70% Anticipo',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 100,
                                                      child: Text(
                                                        '100% Contado',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (v) {
                                                    if (v != null) {
                                                      setDialogState(
                                                        () => advancePct = v,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    // Tarjeta 3: Alcance Técnico & Especificaciones
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF131D31)
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildSectionTitle(
                                                'ESPECIFICACIÓN TÉCNICA & ALCANCE DEL TRABAJO',
                                              ),
                                              OutlinedButton.icon(
                                                style: OutlinedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  minimumSize: const Size(
                                                    0,
                                                    30,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setDialogState(() {
                                                    scopeCtrl.text =
                                                        _getDefaultScopeForCategory(
                                                          category,
                                                        );
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 14,
                                                ),
                                                label: Text(
                                                  'Restablecer Plantilla Sugerida',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Detallá minuciosamente el personal asignado, horarios, maquinaria suministrada, insumos y compromisos asumidos.',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: scopeCtrl,
                                            maxLines: 5,
                                            minLines: 4,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              height: 1.45,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Detallá aquí el alcance técnico y operativo acordado con el cliente...',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (v) =>
                                                (v == null || v.trim().isEmpty)
                                                ? 'Especificá el alcance técnico'
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Botón de paso siguiente
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2563EB,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            setDialogState(
                                              () => currentTab = 1,
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Continuar a Partidas Presupuestarias (Paso 2) →',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : // ==================== PESTAÑA 2: PARTIDAS Y COTIZACIÓN ====================
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF131D31)
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      _buildSectionTitle(
                                                        'DESGLOSE DE PARTIDAS & PRESUPUESTO',
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 3,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              const Color(
                                                                0xFF10B981,
                                                              ).withValues(
                                                                alpha: 0.15,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          '${budgetItems.length} partidas cotizadas',
                                                          style:
                                                              GoogleFonts.jetBrainsMono(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    const Color(
                                                                      0xFF10B981,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Costeá cada ítem individualmente. El total del contrato se actualiza en tiempo real.',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: const Color(
                                                        0xFF64748B,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF2563EB,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10,
                                                      ),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setDialogState(() {
                                                    budgetItems.add(
                                                      ContractBudgetItem(
                                                        id: 'ITM-${DateTime.now().millisecondsSinceEpoch % 10000}',
                                                        description: '',
                                                        quantity: 1,
                                                        unit: isRecurrent
                                                            ? 'Mes'
                                                            : 'Global',
                                                        unitPrice: 0,
                                                      ),
                                                    );
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  'Añadir Partida',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 18),

                                          // Lista de partidas espaciosas
                                          if (budgetItems.isEmpty)
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(40),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? const Color(0xFF0F172A)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: isDark
                                                      ? const Color(0xFF1E293B)
                                                      : const Color(0xFFE2E8F0),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.receipt_long_outlined,
                                                    size: 42,
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ).withValues(alpha: 0.5),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'No hay partidas presupuestarias registradas',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isDark
                                                          ? const Color(
                                                              0xFF94A3B8,
                                                            )
                                                          : const Color(
                                                              0xFF475569,
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Hacé clic en "+ Añadir Partida" para costear el servicio.',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: const Color(
                                                        0xFF64748B,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: budgetItems.length,
                                              separatorBuilder: (_, _) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (context, idx) {
                                                final item = budgetItems[idx];
                                                return Container(
                                                  padding: const EdgeInsets.all(
                                                    14,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? const Color(
                                                            0xFF0F172A,
                                                          )
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color: isDark
                                                          ? const Color(
                                                              0xFF1E293B,
                                                            )
                                                          : const Color(
                                                              0xFFE2E8F0,
                                                            ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Fila 1: Concepto con ancho completo
                                                      TextFormField(
                                                        initialValue:
                                                            item.description,
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Concepto / Partida Cotizada #${idx + 1}',
                                                          hintText:
                                                              'Ej: 2 Operarios de limpieza para turno matutino con químicos incluidos',
                                                          isDense: true,
                                                          prefixIcon:
                                                              const Icon(
                                                                Icons.edit_note,
                                                                size: 18,
                                                                color: Color(
                                                                  0xFF64748B,
                                                                ),
                                                              ),
                                                        ),
                                                        onChanged: (v) =>
                                                            budgetItems[idx] =
                                                                item.copyWith(
                                                                  description:
                                                                      v,
                                                                ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),

                                                      // Fila 2: Métricas numéricas bien espaciadas
                                                      Row(
                                                        children: [
                                                          // Cantidad
                                                          SizedBox(
                                                            width: 100,
                                                            child: TextFormField(
                                                              initialValue: item
                                                                  .quantity
                                                                  .toStringAsFixed(
                                                                    item.quantity %
                                                                                1 ==
                                                                            0
                                                                        ? 0
                                                                        : 2,
                                                                  ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              style: GoogleFonts.jetBrainsMono(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                        'Cantidad *',
                                                                    isDense:
                                                                        true,
                                                                  ),
                                                              onChanged: (v) {
                                                                final parsed =
                                                                    double.tryParse(
                                                                      v,
                                                                    ) ??
                                                                    1.0;
                                                                setDialogState(
                                                                  () => budgetItems[idx] =
                                                                      item.copyWith(
                                                                        quantity:
                                                                            parsed,
                                                                      ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 14,
                                                          ),

                                                          // Unidad de Medida
                                                          SizedBox(
                                                            width: 140,
                                                            child: DropdownButtonFormField<String>(
                                                              key: ValueKey(
                                                                'unit_${item.id}_${item.unit}',
                                                              ),
                                                              initialValue:
                                                                  const [
                                                                    'Mes',
                                                                    'Puesto',
                                                                    'Global',
                                                                    'Horas',
                                                                    'm²',
                                                                    'Unidad',
                                                                    'Visita',
                                                                  ].contains(
                                                                    item.unit,
                                                                  )
                                                                  ? item.unit
                                                                  : 'Mes',
                                                              isExpanded: true,
                                                              decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                        'Unidad *',
                                                                    isDense:
                                                                        true,
                                                                  ),
                                                              items: const [
                                                                DropdownMenuItem(
                                                                  value: 'Mes',
                                                                  child: Text(
                                                                    'Mes',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      'Puesto',
                                                                  child: Text(
                                                                    'Puesto',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      'Global',
                                                                  child: Text(
                                                                    'Global',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      'Horas',
                                                                  child: Text(
                                                                    'Horas',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value: 'm²',
                                                                  child: Text(
                                                                    'm²',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      'Unidad',
                                                                  child: Text(
                                                                    'Unidad',
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      'Visita',
                                                                  child: Text(
                                                                    'Visita',
                                                                  ),
                                                                ),
                                                              ],
                                                              onChanged: (v) {
                                                                if (v != null) {
                                                                  setDialogState(
                                                                    () => budgetItems[idx] =
                                                                        item.copyWith(
                                                                          unit:
                                                                              v,
                                                                        ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 14,
                                                          ),

                                                          // Precio Unitario
                                                          Expanded(
                                                            child: TextFormField(
                                                              initialValue: item
                                                                  .unitPrice
                                                                  .toStringAsFixed(
                                                                    0,
                                                                  ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              style: GoogleFonts.jetBrainsMono(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                        'Precio Unitario *',
                                                                    prefixText:
                                                                        'Bs. ',
                                                                    isDense:
                                                                        true,
                                                                  ),
                                                              onChanged: (v) {
                                                                final parsed =
                                                                    double.tryParse(
                                                                      v,
                                                                    ) ??
                                                                    0.0;
                                                                setDialogState(
                                                                  () => budgetItems[idx] =
                                                                      item.copyWith(
                                                                        unitPrice:
                                                                            parsed,
                                                                      ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 18,
                                                          ),

                                                          // Subtotal Partida
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'SUBTOTAL',
                                                                style: GoogleFonts.jetBrainsMono(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color(
                                                                    0xFF64748B,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                'Bs. ${item.subtotal.toStringAsFixed(2)}',
                                                                style: GoogleFonts.jetBrainsMono(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: isDark
                                                                      ? const Color(
                                                                          0xFFE2E8F0,
                                                                        )
                                                                      : const Color(
                                                                          0xFF0F172A,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),

                                                          // Eliminar
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 20,
                                                              color: Color(
                                                                0xFFEF4444,
                                                              ),
                                                            ),
                                                            tooltip:
                                                                'Eliminar partida',
                                                            onPressed: () {
                                                              setDialogState(
                                                                () => budgetItems
                                                                    .removeAt(
                                                                      idx,
                                                                    ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // 4. BARRA INFERIOR FLOTANTE DE TOTALES & ACCIONES
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131D31) : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Resumen Financiero Destacado
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isRecurrent
                                        ? 'CANON MENSUAL ESTIMADO'
                                        : 'MONTO TOTAL DEL CONTRATO',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  if (advancePct > 0) ...[
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFF59E0B,
                                        ).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFF59E0B,
                                          ).withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        'Anticipo $advancePct%: Bs. ${(totalBudget * advancePct / 100).toStringAsFixed(2)}',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isRecurrent
                                    ? 'Bs. ${totalBudget.toStringAsFixed(2)} / mes'
                                    : 'Bs. ${totalBudget.toStringAsFixed(2)}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: isRecurrent
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: () => Navigator.of(dCtx).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 12),
                          if (currentTab == 1)
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () =>
                                  setDialogState(() => currentTab = 0),
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: const Text('Volver a Alcance'),
                            ),
                          if (currentTab == 1) const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isRecontract
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: Icon(
                              isRecontract ? Icons.replay : Icons.verified,
                              size: 16,
                            ),
                            label: Text(
                              isRecontract
                                  ? 'Confirmar Recontratación'
                                  : 'Aprobar & Activar Contrato',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                if (budgetItems.isEmpty || totalBudget <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor agrega al menos una partida con precio unitario válido.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final selectedBranch = customer.branches
                                    .firstWhere(
                                      (b) => b.id == selectedBranchId,
                                      orElse: () => customer.branches.first,
                                    );
                                final now = DateTime.now();
                                final dateStr =
                                    '${now.day} ${_getMonthName(now.month)} ${now.year}';

                                final newContract = CustomerContract(
                                  id: 'CTR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                                  title: titleCtrl.text.trim(),
                                  contractType: contractType,
                                  serviceCategory: category,
                                  totalAmount: totalBudget,
                                  recurringMonthlyAmount: isRecurrent
                                      ? totalBudget
                                      : 0.0,
                                  oneTimeAmount: !isRecurrent
                                      ? totalBudget
                                      : 0.0,
                                  paymentTerms: termsCtrl.text.trim(),
                                  executionTime: timeCtrl.text.trim(),
                                  advancePercentage: advancePct,
                                  status: 'Vigente',
                                  startDate: dateStr,
                                  branchId: selectedBranch.id,
                                  branchName: selectedBranch.name,
                                  originType: isRecontract
                                      ? 'Recontratación'
                                      : 'Adicional',
                                  budgetItems: budgetItems,
                                  serviceScope: scopeCtrl.text.trim(),
                                );

                                _service.addContractToCustomer(
                                  customer.id,
                                  newContract,
                                );
                                setState(() {
                                  _selectedCustomer = _service.customers
                                      .firstWhere((c) => c.id == customer.id);
                                });
                                Navigator.of(dCtx).pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF065F46),
                                    content: Text(
                                      isRecontract
                                          ? 'Servicio recontratado con éxito por Bs. ${totalBudget.toStringAsFixed(2)}'
                                          : 'Contrato "${newContract.title}" activado por Bs. ${totalBudget.toStringAsFixed(2)}',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // DIÁLOGO: AGREGAR SEDE OPERATIVA
  // ===========================================================================
  void _showAddBranchDialog(CustomerItem customer) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final contactCtrl = TextEditingController(text: customer.contactPerson);
    final phoneCtrl = TextEditingController(text: customer.phone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dCtx) {
        final isDark = Theme.of(dCtx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Añadir Sede a ${customer.tradeName}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la Sede *',
                      hintText: 'Ej: Sucursal Equipetrol / Anexo Parqueo',
                      isDense: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Dirección Completa *',
                      hintText: 'Ej: Av. San Martín #450, Edif. Torre',
                      isDense: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: contactCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Encargado Local *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono Local *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dCtx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newBranch = CustomerBranch(
                    id: 'BR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                    name: nameCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                    localContact: contactCtrl.text.trim(),
                    localPhone: phoneCtrl.text.trim(),
                  );
                  _service.addBranchToCustomer(customer.id, newBranch);
                  Navigator.of(dCtx).pop();
                  if (_selectedCustomer?.id == customer.id) {
                    _selectedCustomer = _service.getCustomerById(customer.id);
                    setState(() {});
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sede "${newBranch.name}" registrada con éxito.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Guardar Sede'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // DIÁLOGO: ALTA NUEVO CLIENTE 360° (MULTI-MODALIDAD + SEDE OBLIGATORIA)
  // ===========================================================================
  void _showCreateCustomerDialog() {
    final formKey = GlobalKey<FormState>();
    final tradeNameCtrl = TextEditingController();
    final legalNameCtrl = TextEditingController();
    final taxIdCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    // Modalidad y Contrato inicial
    String contractType = 'Recurrente Mensual';
    final contractTitleCtrl = TextEditingController(
      text: 'Servicio Recurrente Integral',
    );
    final amountCtrl = TextEditingController(text: '12000');
    final executionTimeCtrl = TextEditingController(text: 'Contrato 12 meses');
    final paymentTermsCtrl = TextEditingController(
      text: 'Facturación mensual a 30 días',
    );

    // Sede inicial obligatoria
    final branchNameCtrl = TextEditingController(text: 'Sede Central / Matriz');
    final branchAddressCtrl = TextEditingController();
    final branchContactCtrl = TextEditingController();
    final branchPhoneCtrl = TextEditingController();

    String segment = 'Corporativo B2B';
    final List<String> availableServices = [
      'Seguridad Física',
      'Limpieza Integral',
      'Mantenimiento',
      'Software / Tecnología',
      'Jardinería',
    ];
    final Set<String> selectedServices = {'Seguridad Física'};

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alta de Cliente 360°',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Configuración fiscal, contrato inicial y sede matriz obligatoria.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 640,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECCIÓN 1: DATOS FISCALES
                        _buildSectionHeader('1. DATOS FISCALES & DE IDENTIDAD'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: tradeNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Comercial *',
                                  hintText: 'Ej: Condominio Las Palmas Real',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: taxIdCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'NIT / RUC *',
                                  hintText: 'Ej: 1029384019',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: legalNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Razón Social Oficial *',
                                  hintText: 'Ej: Inversiones del Norte S.R.L.',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: segment,
                                decoration: const InputDecoration(
                                  labelText: 'Segmento *',
                                  isDense: true,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Corporativo B2B',
                                    child: Text('Corporativo B2B'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Residencial B2C',
                                    child: Text('Residencial B2C'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sector Educativo',
                                    child: Text('Sector Educativo'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sector Público',
                                    child: Text('Sector Público'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => segment = v);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        // SECCIÓN 2: CONTACTO
                        _buildSectionHeader('2. CONTACTO PRINCIPAL'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: contactCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Persona de Contacto *',
                                  hintText: 'Ej: Lic. Marcelo Vaca',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: phoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Teléfono / Móvil *',
                                  hintText: 'Ej: +591 789-12345',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Correo de Facturación *',
                            hintText: 'Ej: contabilidad@cliente.com',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),

                        const SizedBox(height: 18),
                        // SECCIÓN 3: CONTRATO / MODALIDAD INICIAL
                        _buildSectionHeader(
                          '3. MODALIDAD DEL TRABAJO / CONTRATO INICIAL',
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: contractType,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Contrato *',
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Recurrente Mensual',
                              child: Text('Recurrente Mensual (Abono fijo)'),
                            ),
                            DropdownMenuItem(
                              value: 'Proyecto Único',
                              child: Text('Proyecto Único / Obra Cerrada'),
                            ),
                            DropdownMenuItem(
                              value: 'Servicio por Evento',
                              child: Text('Servicio por Evento / Feria'),
                            ),
                            DropdownMenuItem(
                              value: 'Híbrido',
                              child: Text('Híbrido (Implementación + Abono)'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setDialogState(() {
                                contractType = v;
                                if (v == 'Recurrente Mensual') {
                                  contractTitleCtrl.text =
                                      'Servicio Recurrente Mensual';
                                  executionTimeCtrl.text = 'Contrato 12 meses';
                                  paymentTermsCtrl.text =
                                      'Facturación mensual a 30 días';
                                } else if (v == 'Servicio por Evento') {
                                  contractTitleCtrl.text =
                                      'Operativo Especial para Evento';
                                  executionTimeCtrl.text = '3 días (Evento)';
                                  paymentTermsCtrl.text =
                                      '50% Anticipo / 50% Cierre del Evento';
                                } else {
                                  contractTitleCtrl.text =
                                      'Obra Cerrada / Mantenimiento Especial';
                                  executionTimeCtrl.text = '15 días hábiles';
                                  paymentTermsCtrl.text =
                                      '50% Anticipo / 50% Entrega Conforme';
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: contractTitleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Objeto del Contrato / Trabajo *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: amountCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText:
                                      contractType == 'Recurrente Mensual'
                                      ? 'Canon Mensual (Bs.) *'
                                      : 'Monto Total del Trabajo (Bs.) *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || double.tryParse(v) == null)
                                    ? 'Monto inválido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: executionTimeCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Plazo / Duración *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: paymentTermsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Condiciones de Pago *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),

                        const SizedBox(height: 18),
                        // SECCIÓN 4: SEDE MATRIZ
                        _buildSectionHeader(
                          '4. SEDE OPERATIVA MATRIZ (OBLIGATORIA)',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Punto físico de partida para el despliegue del servicio.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: branchNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Sede Matriz *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: branchAddressCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Dirección Física *',
                                  hintText: 'Ej: Av. Banzer 4to Anillo #210',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        // SECCIÓN 5: SERVICIOS
                        _buildSectionHeader('5. LÍNEAS DE SERVICIO'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableServices.map((srv) {
                            final isSel = selectedServices.contains(srv);
                            return FilterChip(
                              label: Text(srv),
                              selected: isSel,
                              selectedColor: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.2),
                              checkmarkColor: const Color(0xFF3B82F6),
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSel
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSel
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF64748B),
                              ),
                              onSelected: (selected) {
                                setDialogState(() {
                                  if (selected) {
                                    selectedServices.add(srv);
                                  } else if (selectedServices.length > 1) {
                                    selectedServices.remove(srv);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final newId =
                          'CLI-${DateTime.now().millisecondsSinceEpoch % 10000}';
                      final initialBranch = CustomerBranch(
                        id: 'BR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        name: branchNameCtrl.text.trim(),
                        address: branchAddressCtrl.text.trim(),
                        localContact: branchContactCtrl.text.trim().isNotEmpty
                            ? branchContactCtrl.text.trim()
                            : contactCtrl.text.trim(),
                        localPhone: branchPhoneCtrl.text.trim().isNotEmpty
                            ? branchPhoneCtrl.text.trim()
                            : phoneCtrl.text.trim(),
                        isHeadquarters: true,
                      );

                      final parsedAmount = double.parse(amountCtrl.text.trim());
                      final initialContract = CustomerContract(
                        id: 'CTR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        title: contractTitleCtrl.text.trim(),
                        contractType: contractType,
                        serviceCategory: selectedServices.first,
                        totalAmount: parsedAmount,
                        recurringMonthlyAmount:
                            contractType == 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        oneTimeAmount: contractType != 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        paymentTerms: paymentTermsCtrl.text.trim(),
                        executionTime: executionTimeCtrl.text.trim(),
                        status: 'Vigente',
                        startDate: 'Hoy',
                      );

                      final newCustomer = CustomerItem(
                        id: newId,
                        legalName: legalNameCtrl.text.trim(),
                        tradeName: tradeNameCtrl.text.trim(),
                        taxId: taxIdCtrl.text.trim(),
                        segment: segment,
                        status: 'Activo',
                        activeServices: selectedServices.toList(),
                        contactPerson: contactCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        startDate: 'Hoy',
                        branches: [initialBranch],
                        contracts: [initialContract],
                      );

                      _service.addCustomer(newCustomer);
                      Navigator.of(dCtx).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF0F172A),
                          content: Text(
                            'Cliente "${newCustomer.tradeName}" registrado como ${initialContract.contractType}.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Completar Registro 360°'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF3B82F6),
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildStatusDot(
    String status, {
    bool hasActiveContracts = true,
    bool isCompleted = false,
  }) {
    Color col;
    if (status == 'En Pausa') {
      col = const Color(0xFFF59E0B);
    } else if (hasActiveContracts) {
      col = const Color(0xFF10B981);
    } else if (isCompleted) {
      col = const Color(0xFF8B5CF6);
    } else {
      col = const Color(0xFF94A3B8);
    }
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: col,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: col.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatsRibbon(bool isDark) {
    final activeCount = _service.totalActiveCustomers;
    final totalCount = _service.customers.length;
    final mrr = _service.totalMrr;
    final projectVol = _service.totalProjectVolume;
    final branches = _service.totalBranches;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 750;
          if (isNarrow) {
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildRibbonItem(
                  'FACTURACIÓN MRR',
                  'Bs. ${mrr.toStringAsFixed(0)}/m',
                  Icons.autorenew,
                  const Color(0xFF10B981),
                  isDark,
                ),
                _buildRibbonItem(
                  'OBRAS & PROYECTOS',
                  'Bs. ${projectVol.toStringAsFixed(0)}',
                  Icons.business_center_outlined,
                  const Color(0xFF8B5CF6),
                  isDark,
                ),
                _buildRibbonItem(
                  'CUENTAS ACTIVAS',
                  '$activeCount de $totalCount cuentas',
                  Icons.verified_outlined,
                  const Color(0xFF3B82F6),
                  isDark,
                ),
                _buildRibbonItem(
                  'SEDES DESPLEGADAS',
                  '$branches puntos',
                  Icons.location_city_outlined,
                  const Color(0xFFF59E0B),
                  isDark,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _buildRibbonItem(
                  'FACTURACIÓN MRR',
                  'Bs. ${mrr.toStringAsFixed(0)} / mes',
                  Icons.autorenew,
                  const Color(0xFF10B981),
                  isDark,
                  tag: 'Recurrente',
                ),
              ),
              _buildRibbonDivider(isDark),
              Expanded(
                child: _buildRibbonItem(
                  'OBRAS & PROYECTOS',
                  'Bs. ${projectVol.toStringAsFixed(0)}',
                  Icons.business_center_outlined,
                  const Color(0xFF8B5CF6),
                  isDark,
                  tag: 'Total acumulado',
                ),
              ),
              _buildRibbonDivider(isDark),
              Expanded(
                child: _buildRibbonItem(
                  'CUENTAS GESTIONADAS',
                  '$activeCount de $totalCount activas',
                  Icons.verified_outlined,
                  const Color(0xFF3B82F6),
                  isDark,
                  tag: 'Directorio',
                ),
              ),
              _buildRibbonDivider(isDark),
              Expanded(
                child: _buildRibbonItem(
                  'SEDES & COBERTURA',
                  '$branches sedes operativas',
                  Icons.location_city_outlined,
                  const Color(0xFFF59E0B),
                  isDark,
                  tag: 'Puntos físicos',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRibbonDivider(bool isDark) {
    return Container(
      height: 32,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildRibbonItem(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark, {
    String? tag,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (tag != null) ...[
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '• $tag',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          color: const Color(0xFF94A3B8),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommandAndFilterBar(bool isDark, int count) {
    final quickFilters = [
      'Todos',
      'Activos',
      'En Servicio',
      'Por Vencer',
      'Recontratar',
      'Recurrentes',
      'Proyectos',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1: Título ejecutivo + Botón de nuevo registro
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Clientes 360°',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    '$count ${count == 1 ? 'cuenta' : 'cuentas'}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showCreateCustomerDialog,
              icon: const Icon(Icons.add_business, size: 16),
              label: Text(
                'Registrar Cliente',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Fila 2: Búsqueda interactiva + Chips de filtrado rápido + Switcher de vistas
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Input de búsqueda
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: GoogleFonts.inter(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Buscar cliente, NIT, contacto o sede...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: const Color(0xFF94A3B8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 17,
                            color: Color(0xFF64748B),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 15),
                                  onPressed: () =>
                                      setState(() => _searchQuery = ''),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Switcher de Vista (Consola, Tarjetas, Tabla)
                  Container(
                    height: 38,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildViewModeButton(
                          'console',
                          Icons.view_sidebar_rounded,
                          'Consola Master-Detail',
                          isDark,
                        ),
                        _buildViewModeButton(
                          'cards',
                          Icons.grid_view_rounded,
                          'Mosaico de Tarjetas',
                          isDark,
                        ),
                        _buildViewModeButton(
                          'table',
                          Icons.table_rows_rounded,
                          'Tabla Ejecutiva',
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Chips de filtrado rápido horizontal
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: quickFilters.map((qf) {
                    final isSelected = _quickFilter == qf;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _quickFilter = qf),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF0F172A))
                                : (isDark
                                      ? const Color(0xFF161F30)
                                      : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: Text(
                            qf,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewModeButton(
    String mode,
    IconData icon,
    String tooltip,
    bool isDark,
  ) {
    final isSelected = _viewMode == mode;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF2563EB) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterDetailView(
    List<CustomerItem> customers,
    bool isDark,
    BoxConstraints constraints,
  ) {
    final isWide = constraints.maxWidth >= 1050;

    if (!isWide) {
      return Column(
        children: customers.map((customer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildMasterListCard(
              customer,
              isDark,
              isSelected: false,
              onTap: () {
                _showCustomerDetail(customer);
              },
            ),
          );
        }).toList(),
      );
    }

    final activeCustomer = _selectedCustomer != null
        ? (_service.customers
                  .where((c) => c.id == _selectedCustomer!.id)
                  .firstOrNull ??
              _selectedCustomer!)
        : (customers.isNotEmpty ? customers.first : null);

    return SizedBox(
      height: 820,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Panel Maestro (Lista de Cuentas)
          SizedBox(
            width: 380,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  itemCount: customers.length,
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (_, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final cust = customers[index];
                    final isSelected = activeCustomer?.id == cust.id;
                    return _buildMasterListCard(
                      cust,
                      isDark,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() => _selectedCustomer = cust);
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 2. Panel Detalle (Live 360° Inspector)
          Expanded(
            child: activeCustomer != null
                ? _buildCustomerDetailContent(
                    activeCustomer,
                    isDark,
                    isPane: true,
                    onClose: () => setState(() => _selectedCustomer = null),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.contact_page_outlined,
                            size: 48,
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Selecciona una cuenta del directorio',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Audita su ficha 360°, contratos activos y sedes en tiempo real.',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterListCard(
    CustomerItem customer,
    bool isDark, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final segmentColor = _getSegmentColor(customer.segment);
    final isRecurrent = customer.primaryContractType == 'Recurrente Mensual';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF2563EB).withValues(alpha: 0.07))
              : (isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyAvatar(customer, size: 40, fontSize: 13),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          customer.tradeName,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _buildStatusDot(
                        customer.status,
                        hasActiveContracts: customer.hasActiveContracts,
                        isCompleted: customer.contracts.any(
                          (c) => c.status == 'Completado',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIT: ${customer.taxId} • ${customer.branches.length} ${customer.branches.length == 1 ? 'sede' : 'sedes'}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: segmentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          customer.segment,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: segmentColor,
                          ),
                        ),
                      ),
                      Text(
                        isRecurrent
                            ? 'Bs. ${customer.monthlyBilling.toStringAsFixed(0)}/m'
                            : 'Bs. ${customer.totalProjectBilling.toStringAsFixed(0)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isRecurrent
                              ? const Color(0xFF10B981)
                              : const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<CustomerItem> customers, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 650
            ? 1
            : (constraints.maxWidth < 1150 ? 2 : 3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.45,
          ),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            final isRecurrent =
                customer.primaryContractType == 'Recurrente Mensual';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cabecera de la tarjeta
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyAvatar(customer, size: 44, fontSize: 15),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    customer.tradeName,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                _buildStatusDot(
                                  customer.status,
                                  hasActiveContracts:
                                      customer.hasActiveContracts,
                                  isCompleted: customer.contracts.any(
                                    (c) => c.status == 'Completado',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.legalName,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIT: ${customer.taxId}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10.5,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Fila de badges e info operativa
                  Row(
                    children: [
                      _buildLifecycleBadge(customer.lifecycleStage),
                      const Spacer(),
                      Text(
                        '${customer.branches.length} ${customer.branches.length == 1 ? 'sede' : 'sedes'}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),

                  // Facturación y acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRecurrent
                                ? 'CANON RECURRENTE'
                                : 'VOLUMEN PROYECTO',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            isRecurrent
                                ? 'Bs. ${customer.monthlyBilling.toStringAsFixed(0)}/m'
                                : 'Bs. ${customer.totalProjectBilling.toStringAsFixed(0)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isRecurrent
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        onPressed: () => _showCustomerDetail(customer),
                        child: Text(
                          'Auditar Ficha',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTableView(List<CustomerItem> customers, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 950),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
              ),
              dataRowMinHeight: 52,
              dataRowMaxHeight: 64,
              columns: [
                DataColumn(
                  label: Text(
                    'CLIENTE & RAZÓN SOCIAL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SEGMENTO',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'SEDES',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CICLO DE VIDA',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'FACTURACIÓN',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ACCIONES',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
              rows: customers.map((c) {
                final isRecurrent =
                    c.primaryContractType == 'Recurrente Mensual';
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          _buildCompanyAvatar(c, size: 34, fontSize: 11),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.tradeName,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'NIT: ${c.taxId} • ${c.legalName}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getSegmentColor(
                            c.segment,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          c.segment,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getSegmentColor(c.segment),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${c.branches.length} ${c.branches.length == 1 ? 'sede' : 'sedes'}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(_buildLifecycleBadge(c.lifecycleStage)),
                    DataCell(
                      Text(
                        isRecurrent
                            ? 'Bs. ${c.monthlyBilling.toStringAsFixed(0)}/m'
                            : 'Bs. ${c.totalProjectBilling.toStringAsFixed(0)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isRecurrent
                              ? const Color(0xFF10B981)
                              : const Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 18,
                            ),
                            tooltip: 'Ver Ficha 360°',
                            onPressed: () => _showCustomerDetail(c),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.replay,
                              size: 18,
                              color: Color(0xFF10B981),
                            ),
                            tooltip: 'Recontratar Servicio',
                            onPressed: () => _showAddContractDialog(c),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 52,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 14),
          Text(
            'No se encontraron cuentas',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No hay clientes que coincidan con los filtros aplicados o término de búsqueda.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _quickFilter = 'Todos';
                _selectedSegment = 'Todos';
                _selectedStatus = 'Todos';
                _selectedContractType = 'Todos';
                _selectedLifecycle = 'Todos';
              });
            },
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: const Text('Restablecer Filtros'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CONSTRUCCIÓN PRINCIPAL DE LA PANTALLA
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customers = _filteredCustomers;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cinta Ejecutiva Compacta de Métricas
              _buildCompactStatsRibbon(isDark),

              const SizedBox(height: 18),

              // 2. Barra de Comandos, Búsqueda, Filtros Rápidos y Vista
              _buildCommandAndFilterBar(isDark, customers.length),

              const SizedBox(height: 18),

              // 3. Contenedor de Vista Activa
              if (customers.isEmpty)
                _buildEmptySearchState(isDark)
              else if (_viewMode == 'console')
                _buildMasterDetailView(customers, isDark, constraints)
              else if (_viewMode == 'cards')
                _buildGridView(customers, isDark)
              else
                _buildTableView(customers, isDark),
            ],
          ),
        );
      },
    );
  }
}
