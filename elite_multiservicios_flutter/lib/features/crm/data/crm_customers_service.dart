import 'package:flutter/foundation.dart';

/// Modelo de Sede Operativa de un Cliente.
class CustomerBranch {
  final String id;
  final String name;
  final String address;
  final String localContact;
  final String localPhone;
  final bool isHeadquarters;
  final String? notes;

  const CustomerBranch({
    required this.id,
    required this.name,
    required this.address,
    required this.localContact,
    required this.localPhone,
    this.isHeadquarters = false,
    this.notes,
  });

  CustomerBranch copyWith({
    String? id,
    String? name,
    String? address,
    String? localContact,
    String? localPhone,
    bool? isHeadquarters,
    String? notes,
  }) {
    return CustomerBranch(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      localContact: localContact ?? this.localContact,
      localPhone: localPhone ?? this.localPhone,
      isHeadquarters: isHeadquarters ?? this.isHeadquarters,
      notes: notes ?? this.notes,
    );
  }
}

/// Modelo integral de Cliente 360° para el CRM de Elite Multiservicios.
class CustomerItem {
  final String id;
  final String legalName;
  final String tradeName;
  final String taxId; // NIT / RUC
  final String
  segment; // 'Corporativo B2B', 'Residencial B2C', 'Sector Público', 'Sector Educativo'
  final String status; // 'Activo', 'En Pausa', 'Inactivo'
  final List<String> activeServices;
  final String contactPerson;
  final String phone;
  final String email;
  final List<CustomerBranch> branches;
  final double monthlyBilling;
  final String? opportunityId;
  final String? startDate;
  final String? notes;

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
    this.opportunityId,
    this.startDate,
    this.notes,
  });

  CustomerItem copyWith({
    String? id,
    String? legalName,
    String? tradeName,
    String? taxId,
    String? segment,
    String? status,
    List<String>? activeServices,
    String? contactPerson,
    String? phone,
    String? email,
    List<CustomerBranch>? branches,
    double? monthlyBilling,
    String? opportunityId,
    String? startDate,
    String? notes,
  }) {
    return CustomerItem(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      tradeName: tradeName ?? this.tradeName,
      taxId: taxId ?? this.taxId,
      segment: segment ?? this.segment,
      status: status ?? this.status,
      activeServices: activeServices ?? this.activeServices,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      branches: branches ?? this.branches,
      monthlyBilling: monthlyBilling ?? this.monthlyBilling,
      opportunityId: opportunityId ?? this.opportunityId,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
    );
  }
}

/// Servicio singleton reactivo para gestionar el catálogo centralizado de Clientes 360°.
class CrmCustomersService extends ChangeNotifier {
  static final CrmCustomersService _instance = CrmCustomersService._internal();
  factory CrmCustomersService() => _instance;

  CrmCustomersService._internal() {
    _initDefaultCustomers();
  }

  final List<CustomerItem> _customers = [];

  List<CustomerItem> get customers => List.unmodifiable(_customers);

  double get totalMrr => _customers.fold<double>(
    0.0,
    (acc, c) => c.status == 'Activo' ? acc + c.monthlyBilling : acc,
  );

  int get totalActiveCustomers =>
      _customers.where((c) => c.status == 'Activo').length;

  int get totalBranches =>
      _customers.fold<int>(0, (acc, c) => acc + c.branches.length);

  int get totalB2B =>
      _customers.where((c) => c.segment == 'Corporativo B2B').length;

  int get totalB2C =>
      _customers.where((c) => c.segment == 'Residencial B2C').length;

  void addCustomer(CustomerItem customer) {
    _customers.insert(0, customer);
    notifyListeners();
  }

  void updateCustomer(CustomerItem updated) {
    final idx = _customers.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _customers[idx] = updated;
      notifyListeners();
    }
  }

  void addBranchToCustomer(String customerId, CustomerBranch newBranch) {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx != -1) {
      final current = _customers[idx];
      final updatedBranches = List<CustomerBranch>.from(current.branches)
        ..add(newBranch);
      _customers[idx] = current.copyWith(branches: updatedBranches);
      notifyListeners();
    }
  }

  bool isOpportunityPromoted(String opportunityId) {
    return _customers.any((c) => c.opportunityId == opportunityId);
  }

  CustomerItem? getCustomerByOpportunityId(String opportunityId) {
    try {
      return _customers.firstWhere((c) => c.opportunityId == opportunityId);
    } catch (_) {
      return null;
    }
  }

  void _initDefaultCustomers() {
    _customers.addAll([
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
        startDate: '15 Ene 2025',
        branches: [
          CustomerBranch(
            id: 'BR-001',
            name: 'Torre Central',
            address: 'Av. San Martín #450, Equipetrol',
            localContact: 'Lic. Mariana Soto',
            localPhone: '+591 765-89123',
            isHeadquarters: true,
          ),
          CustomerBranch(
            id: 'BR-002',
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
        startDate: '01 Mar 2025',
        branches: [
          CustomerBranch(
            id: 'BR-003',
            name: 'Pórtico Principal y Garita',
            address: 'Av. Las Palmas Km 3',
            localContact: 'Capitán Suárez',
            localPhone: '+591 710-23457',
            isHeadquarters: true,
          ),
        ],
      ),
      const CustomerItem(
        id: 'CLI-003',
        legalName: 'Banco Ganadero y Financiero S.A.',
        tradeName: 'Banco Ganadero',
        taxId: '1002938411',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: ['Seguridad Física', 'Limpieza Integral'],
        contactPerson: 'Lic. Roberto Pardo',
        phone: '+591 700-11223',
        email: 'servicios@ganadero.com.bo',
        monthlyBilling: 29000.0,
        startDate: '10 Nov 2024',
        branches: [
          CustomerBranch(
            id: 'BR-004',
            name: 'Oficina Central',
            address: 'Calle 21 de Calacoto #100',
            localContact: 'Lic. Roberto Pardo',
            localPhone: '+591 700-11223',
            isHeadquarters: true,
          ),
          CustomerBranch(
            id: 'BR-005',
            name: 'Agencia Prado',
            address: 'Av. 16 de Julio #1440',
            localContact: 'Jefe Agencia Prado',
            localPhone: '+591 700-11224',
          ),
          CustomerBranch(
            id: 'BR-006',
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
        startDate: '01 Feb 2025',
        branches: [
          CustomerBranch(
            id: 'BR-007',
            name: 'Campus Central',
            address: 'Km 8 Carretera al Norte',
            localContact: 'Prof. Gabriel Arce',
            localPhone: '+591 789-01234',
            isHeadquarters: true,
          ),
        ],
      ),
    ]);
  }
}
