import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de Sede Operativa de un Cliente.
class CustomerBranch {
  final String name;
  final String address;
  final String localContact;
  final String localPhone;

  const CustomerBranch({
    required this.name,
    required this.address,
    required this.localContact,
    required this.localPhone,
  });
}

/// Modelo de Cliente 360° para el CRM.
class CustomerItem {
  final String id;
  final String legalName;
  final String tradeName;
  final String taxId; // NIT / RUC
  final String
  segment; // 'Corporativo B2B', 'Residencial B2C', 'Sector Público'
  final String status; // 'Activo', 'En Pausa', 'Inactivo'
  final List<String> activeServices;
  final String contactPerson;
  final String phone;
  final String email;
  final List<CustomerBranch> branches;
  final double monthlyBilling;

  const CustomerItem({
    required this.id,
    required this.legalName,
    required this.tradeName,
    required this.taxId,
    required this.segment,
    required this.status,
    required this.activeServices,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.branches,
    required this.monthlyBilling,
  });
}

/// Vista del Directorio Clientes 360° y Sedes Operativas.
class CrmCustomersView extends StatefulWidget {
  const CrmCustomersView({super.key});

  @override
  State<CrmCustomersView> createState() => _CrmCustomersViewState();
}

class _CrmCustomersViewState extends State<CrmCustomersView> {
  String _searchQuery = '';
  String _selectedSegment = 'Todos';

  final List<CustomerItem> _customers = [
    const CustomerItem(
      id: 'CLI-001',
      legalName: 'Corporación Inmobiliaria del Sur S.A.',
      tradeName: 'Torre Corporativa Titanium',
      taxId: '1029384756',
      segment: 'Corporativo B2B',
      status: 'Activo',
      activeServices: ['Limpieza Integral', 'Mantenimiento'],
      contactPerson: 'Lic. Mariana Soto',
      phone: '+591 765-89123',
      email: 'operaciones@titanium.bo',
      monthlyBilling: 13500.0,
      branches: [
        CustomerBranch(
          name: 'Torre Central',
          address: 'Av. San Martín #450, Equipetrol',
          localContact: 'Lic. Mariana Soto',
          localPhone: '+591 765-89123',
        ),
        CustomerBranch(
          name: 'Parqueo Subterráneo y Anexo',
          address: 'Calle 5 Este #12',
          localContact: 'Sr. Hugo Ramos',
          localPhone: '+591 765-89124',
        ),
      ],
    ),
    const CustomerItem(
      id: 'CLI-002',
      legalName: 'Condominio Residencial Las Palmas Real',
      tradeName: 'Las Palmas Real',
      taxId: '3049586712',
      segment: 'Residencial B2C',
      status: 'Activo',
      activeServices: ['Seguridad Física', 'Jardinería'],
      contactPerson: 'Ing. Carlos Mendoza',
      phone: '+591 710-23456',
      email: 'administracion@laspalmasreal.com',
      monthlyBilling: 18900.0,
      branches: [
        CustomerBranch(
          name: 'Pórtico Principal y Garita',
          address: 'Av. Las Palmas Km 3',
          localContact: 'Capitán Suárez',
          localPhone: '+591 710-23457',
        ),
      ],
    ),
    const CustomerItem(
      id: 'CLI-003',
      legalName: 'Banco Ganadero y Financiero',
      tradeName: 'Banco Ganadero',
      taxId: '1002938411',
      segment: 'Corporativo B2B',
      status: 'Activo',
      activeServices: ['Seguridad Física', 'Limpieza Integral'],
      contactPerson: 'Lic. Roberto Pardo',
      phone: '+591 700-11223',
      email: 'servicios@ganadero.com.bo',
      monthlyBilling: 29000.0,
      branches: [
        CustomerBranch(
          name: 'Oficina Central',
          address: 'Calle 21 de Calacoto',
          localContact: 'Lic. Roberto Pardo',
          localPhone: '+591 700-11223',
        ),
        CustomerBranch(
          name: 'Agencia Prado',
          address: 'Av. 16 de Julio #1440',
          localContact: 'Jefe Agencia Prado',
          localPhone: '+591 700-11224',
        ),
        CustomerBranch(
          name: 'Agencia El Alto',
          address: 'Av. 6 de Marzo #500',
          localContact: 'Jefe Agencia El Alto',
          localPhone: '+591 700-11225',
        ),
      ],
    ),
    const CustomerItem(
      id: 'CLI-004',
      legalName: 'Colegio Saint Peter Campus Norte',
      tradeName: 'Colegio Saint Peter',
      taxId: '2093847561',
      segment: 'Sector Educativo',
      status: 'En Pausa',
      activeServices: ['Jardinería'],
      contactPerson: 'Prof. Gabriel Arce',
      phone: '+591 789-01234',
      email: 'mantenimiento@saintpeter.edu.bo',
      monthlyBilling: 5400.0,
      branches: [
        CustomerBranch(
          name: 'Campus Central',
          address: 'Km 8 Carretera al Norte',
          localContact: 'Prof. Gabriel Arce',
          localPhone: '+591 789-01234',
        ),
      ],
    ),
  ];

  List<CustomerItem> get _filteredCustomers {
    return _customers.where((c) {
      final matchesSearch =
          c.legalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.tradeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.taxId.contains(_searchQuery) ||
          c.contactPerson.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSegment =
          _selectedSegment == 'Todos' || c.segment == _selectedSegment;
      return matchesSearch && matchesSegment;
    }).toList();
  }

  void _showCustomerDetail(CustomerItem customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.tradeName,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            customer.legalName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          customer.status,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 14),

                  // Datos Fiscales y Contacto
                  Text(
                    'INFORMACIÓN GENERAL Y FACTURACIÓN',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                          'NIT / Identificación:',
                          customer.taxId,
                          isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoField(
                          'Segmento:',
                          customer.segment,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                          'Contacto Principal:',
                          customer.contactPerson,
                          isDark,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoField(
                          'Teléfono Directo:',
                          customer.phone,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoField(
                    'Correo de Facturación:',
                    customer.email,
                    isDark,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 14),

                  // Sedes Operativas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SEDES DE SERVICIO (${customer.branches.length})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        'Total facturación: Bs. ${customer.monthlyBilling.toStringAsFixed(2)}/mes',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...customer.branches.map(
                    (b) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
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
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  b.address,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                b.localContact,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                b.localPhone,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoField(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredCustomers;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
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
                          'Elite Multiservicios',
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
                      'Directorio de Clientes & Sedes',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ficha unificada de clientes corporativos, residenciales y sedes de servicio.',
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF1E293B),
                      content: Text(
                        'Formulario de alta de cliente 360° disponible en el siguiente paso.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.business, size: 18),
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

          // 2. Filtros y Búsqueda
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.inter(fontSize: 13),
                    decoration: InputDecoration(
                      hintText:
                          'Buscar por razón social, nombre comercial o NIT...',
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
                const SizedBox(width: 14),
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
                  items:
                      [
                            'Todos',
                            'Corporativo B2B',
                            'Residencial B2C',
                            'Sector Educativo',
                          ]
                          .map(
                            (seg) => DropdownMenuItem(
                              value: seg,
                              child: Text('Segmento: $seg'),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSegment = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Grid de Clientes
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
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, idx) {
                  final customer = filtered[idx];
                  return InkWell(
                    onTap: () => _showCustomerDetail(customer),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  customer.tradeName,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  customer.status,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF10B981),
                                  ),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 6,
                            children: customer.activeServices
                                .map(
                                  (srv) => Container(
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
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.apartment,
                                    size: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${customer.branches.length} Sedes',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Bs. ${customer.monthlyBilling.toStringAsFixed(2)} / mes',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
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
}
