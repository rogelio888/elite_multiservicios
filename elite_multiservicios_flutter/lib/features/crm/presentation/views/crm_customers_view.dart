import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/crm_customers_service.dart';

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

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  List<CustomerItem> get _filteredCustomers {
    return _service.customers.where((c) {
      final matchesSearch =
          c.legalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.tradeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.taxId.contains(_searchQuery) ||
          c.contactPerson.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSegment =
          _selectedSegment == 'Todos' || c.segment == _selectedSegment;
      final matchesStatus =
          _selectedStatus == 'Todos' || c.status == _selectedStatus;
      final matchesContractType =
          _selectedContractType == 'Todos' ||
          c.primaryContractType == _selectedContractType ||
          c.contracts.any((ctr) => ctr.contractType == _selectedContractType);

      return matchesSearch &&
          matchesSegment &&
          matchesStatus &&
          matchesContractType;
    }).toList();
  }

  // ===========================================================================
  // MODAL: FICHA DETALLADA 360°
  // ===========================================================================
  void _showCustomerDetail(CustomerItem customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          maxChildSize: 0.96,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return DefaultTabController(
              length: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
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
                    const SizedBox(height: 16),

                    // Header del Cliente
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF2563EB,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.business,
                                color: Color(0xFF3B82F6),
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                          letterSpacing: -0.3,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildContractTypeBadge(
                                      customer.primaryContractType,
                                    ),
                                    const SizedBox(width: 6),
                                    _buildStatusBadge(customer.status),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  customer.legalName,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TabBar
                    TabBar(
                      isScrollable: true,
                      indicatorColor: const Color(0xFF2563EB),
                      indicatorWeight: 3,
                      labelColor: const Color(0xFF2563EB),
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        const Tab(text: 'General & Fiscal'),
                        Tab(
                          text:
                              'Sedes Operativas (${customer.branches.length})',
                        ),
                        Tab(
                          text:
                              'Contratos & Trabajos (${customer.contracts.length})',
                        ),
                      ],
                    ),

                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildGeneralTab(customer, isDark),
                          _buildBranchesTab(customer, isDark),
                          _buildContractsTab(customer, isDark),
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                elevation: 0,
              ),
              onPressed: () => _showAddContractDialog(customer),
              icon: const Icon(Icons.add_task, size: 15),
              label: Text(
                'Nuevo Contrato / Proyecto',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
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
          ...customer.contracts.map((ctr) => _buildContractCard(ctr, isDark)),
      ],
    );
  }

  Widget _buildContractCard(CustomerContract contract, bool isDark) {
    final typeColor = _getContractTypeColor(contract.contractType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
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
              Row(
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
                  const SizedBox(width: 8),
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
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      contract.status == 'Vigente' ||
                          contract.status == 'En Ejecución'
                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                      : const Color(0xFF64748B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contract.status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        contract.status == 'Vigente' ||
                            contract.status == 'En Ejecución'
                        ? const Color(0xFF10B981)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
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
                  'Monto Total: Bs. ${contract.oneTimeAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: typeColor,
                  ),
                ),
            ],
          ),
        ],
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

  Widget _buildContractTypeBadge(String type) {
    final color = _getContractTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        type,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
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

  void _toggleCustomerStatus(CustomerItem customer) {
    final nextStatus = customer.status == 'Activo' ? 'En Pausa' : 'Activo';
    _service.updateCustomer(customer.copyWith(status: nextStatus));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Estado de ${customer.tradeName} actualizado a $nextStatus',
        ),
      ),
    );
  }

  // ===========================================================================
  // DIÁLOGO: AGREGAR CONTRATO A CLIENTE EXISTENTE
  // ===========================================================================
  void _showAddContractDialog(CustomerItem customer) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '15000');
    final termsCtrl = TextEditingController(text: '50% Anticipo / 50% Entrega');
    final timeCtrl = TextEditingController(text: '15 días hábiles');
    String contractType = 'Proyecto Único';
    String category = 'Limpieza';
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
              title: Text(
                'Nuevo Contrato / Proyecto para ${customer.tradeName}',
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: contractType,
                          decoration: const InputDecoration(
                            labelText: 'Modalidad de Contratación *',
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Recurrente Mensual',
                              child: Text('Recurrente Mensual'),
                            ),
                            DropdownMenuItem(
                              value: 'Proyecto Único',
                              child: Text('Proyecto Único / Obra'),
                            ),
                            DropdownMenuItem(
                              value: 'Servicio por Evento',
                              child: Text('Servicio por Evento'),
                            ),
                            DropdownMenuItem(
                              value: 'Híbrido',
                              child: Text('Híbrido'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setDialogState(() {
                                contractType = v;
                                if (v == 'Recurrente Mensual') {
                                  termsCtrl.text =
                                      'Facturación mensual a 30 días';
                                  timeCtrl.text = 'Contrato 12 meses';
                                } else if (v == 'Servicio por Evento') {
                                  termsCtrl.text =
                                      '50% Anticipo / 50% Cierre del Evento';
                                  timeCtrl.text = '3 días (Feria)';
                                } else {
                                  termsCtrl.text =
                                      '50% Anticipo / 50% Entrega Conforme';
                                  timeCtrl.text = '15 días hábiles';
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre / Objeto del Contrato *',
                            hintText:
                                'Ej: Pulido de Pisos o Seguridad para Evento',
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
                              child: DropdownButtonFormField<String>(
                                initialValue: category,
                                decoration: const InputDecoration(
                                  labelText: 'Categoría *',
                                  isDense: true,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Seguridad',
                                    child: Text('Seguridad'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Limpieza',
                                    child: Text('Limpieza'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Mantenimiento',
                                    child: Text('Mantenimiento'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Software',
                                    child: Text('Software'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Jardinería',
                                    child: Text('Jardinería'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => category = v);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: amountCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText:
                                      contractType == 'Recurrente Mensual'
                                      ? 'Canon Mensual (Bs.) *'
                                      : 'Monto Total (Bs.) *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || double.tryParse(v) == null)
                                    ? 'Monto inválido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: timeCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Plazo de Ejecución / Duración *',
                            isDense: true,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: termsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Condiciones de Pago *',
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final parsedAmount = double.parse(amountCtrl.text.trim());
                      final newContract = CustomerContract(
                        id: 'CTR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        title: titleCtrl.text.trim(),
                        contractType: contractType,
                        serviceCategory: category,
                        totalAmount: parsedAmount,
                        recurringMonthlyAmount:
                            contractType == 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        oneTimeAmount: contractType != 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        paymentTerms: termsCtrl.text.trim(),
                        executionTime: timeCtrl.text.trim(),
                        status: 'Vigente',
                        startDate: 'Hoy',
                      );

                      _service.addContractToCustomer(customer.id, newContract);
                      Navigator.of(dCtx).pop();
                      Navigator.of(context).pop();
                      _showCustomerDetail(
                        _service.customers.firstWhere(
                          (c) => c.id == customer.id,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Contrato "${newContract.title}" añadido con éxito.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar Contrato'),
                ),
              ],
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
                  Navigator.of(context).pop();
                  _showCustomerDetail(
                    _service.customers.firstWhere((c) => c.id == customer.id),
                  );
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

  // ===========================================================================
  // CONSTRUCCIÓN PRINCIPAL DE LA PANTALLA
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredCustomers;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header y Botón de Registro
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'DIRECTORIO 360°',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Elite Multiservicios CRM',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Directorio Clientes 360° & Contratos',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ficha unificada multi-modalidad: recurrentes mensuales, proyectos únicos, eventos y sedes operativas.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  elevation: 0,
                ),
                onPressed: _showCreateCustomerDialog,
                icon: const Icon(Icons.add_business, size: 18),
                label: Text(
                  'Registrar Cliente',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 2. Tarjetas de Métricas Ejecutivas (KPIs Multi-Modalidad)
          _buildKpiMetricsRow(isDark),

          const SizedBox(height: 20),

          // 3. Barra de Búsqueda y Filtros
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.inter(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Buscar cliente, NIT o contacto...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedContractType,
                  underline: const SizedBox(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'Todos',
                      child: Text('Modalidad: Todas'),
                    ),
                    DropdownMenuItem(
                      value: 'Recurrente Mensual',
                      child: Text('Modalidad: Recurrente'),
                    ),
                    DropdownMenuItem(
                      value: 'Proyecto Único',
                      child: Text('Modalidad: Proyecto Único'),
                    ),
                    DropdownMenuItem(
                      value: 'Servicio por Evento',
                      child: Text('Modalidad: Por Evento'),
                    ),
                    DropdownMenuItem(
                      value: 'Híbrido',
                      child: Text('Modalidad: Híbrido'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedContractType = val);
                    }
                  },
                ),
                DropdownButton<String>(
                  value: _selectedSegment,
                  underline: const SizedBox(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'Todos',
                      child: Text('Segmento: Todos'),
                    ),
                    DropdownMenuItem(
                      value: 'Corporativo B2B',
                      child: Text('Segmento: Corporativo B2B'),
                    ),
                    DropdownMenuItem(
                      value: 'Residencial B2C',
                      child: Text('Segmento: Residencial B2C'),
                    ),
                    DropdownMenuItem(
                      value: 'Sector Educativo',
                      child: Text('Segmento: Sector Educativo'),
                    ),
                    DropdownMenuItem(
                      value: 'Sector Público',
                      child: Text('Segmento: Sector Público'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSegment = val);
                  },
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  underline: const SizedBox(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: 'Todos',
                      child: Text('Estado: Todos'),
                    ),
                    DropdownMenuItem(
                      value: 'Activo',
                      child: Text('Estado: Activo'),
                    ),
                    DropdownMenuItem(
                      value: 'En Pausa',
                      child: Text('Estado: En Pausa'),
                    ),
                    DropdownMenuItem(
                      value: 'Inactivo',
                      child: Text('Estado: Inactivo'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4. Grid de Clientes
          if (filtered.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 40,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No se encontraron clientes con los filtros seleccionados',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 205,
                  ),
                  itemBuilder: (context, idx) {
                    final customer = filtered[idx];
                    final primaryType = customer.primaryContractType;
                    final typeColor = _getContractTypeColor(primaryType);

                    return InkWell(
                      onTap: () => _showCustomerDetail(customer),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    customer.tradeName,
                                    style: GoogleFonts.inter(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _buildContractTypeBadge(primaryType),
                                const SizedBox(width: 6),
                                _buildStatusBadge(customer.status),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.legalName,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: customer.activeServices.take(3).map((
                                srv,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF161F30)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    srv,
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_city,
                                      size: 15,
                                      color: Color(0xFF3B82F6),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${customer.branches.length} ${customer.branches.length == 1 ? 'Sede' : 'Sedes'}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${customer.contracts.length} ${customer.contracts.length == 1 ? 'trabajo' : 'trabajos'}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                if (primaryType == 'Recurrente Mensual')
                                  Text(
                                    'Bs. ${customer.monthlyBilling.toStringAsFixed(2)} / mes',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF10B981),
                                    ),
                                  )
                                else if (primaryType == 'Híbrido')
                                  Text(
                                    'Bs. ${customer.monthlyBilling.toStringAsFixed(0)}/m + Obra',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF3B82F6),
                                    ),
                                  )
                                else
                                  Text(
                                    'Bs. ${customer.totalProjectBilling.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: typeColor,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildKpiMetricsRow(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final kpis = [
          _buildKpiCard(
            'CLIENTES ACTIVOS',
            '${_service.totalActiveCustomers}',
            'de ${_service.customers.length} cuentas registradas',
            Icons.domain,
            const Color(0xFF3B82F6),
            isDark,
          ),
          _buildKpiCard(
            'FACTURACIÓN MRR',
            'Bs. ${_service.totalMrr.toStringAsFixed(0)}',
            'canon recurrente mensual',
            Icons.autorenew,
            const Color(0xFF10B981),
            isDark,
          ),
          _buildKpiCard(
            'PROYECTOS & EVENTOS',
            'Bs. ${_service.totalProjectVolume.toStringAsFixed(0)}',
            'obras cerradas y especiales',
            Icons.construction,
            const Color(0xFF8B5CF6),
            isDark,
          ),
          _buildKpiCard(
            'SEDES ATENDIDAS',
            '${_service.totalBranches}',
            'puntos físicos desplegados',
            Icons.pin_drop_outlined,
            const Color(0xFFF59E0B),
            isDark,
          ),
        ];

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isWide ? 2.1 : 1.6,
          children: kpis,
        );
      },
    );
  }

  Widget _buildKpiCard(
    String label,
    String value,
    String subtext,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: const Color(0xFF64748B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
