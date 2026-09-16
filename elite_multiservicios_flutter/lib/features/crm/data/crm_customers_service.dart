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

/// Modelo de Contrato u Orden de Trabajo para Clientes 360°.
/// Abarca modalidades: Recurrente Mensual, Proyecto Único / Obra, Servicio por Evento, Híbrido.
class CustomerContract {
  final String id;
  final String title;
  final String
  contractType; // 'Recurrente Mensual', 'Proyecto Único', 'Servicio por Evento', 'Híbrido'
  final String
  serviceCategory; // 'Seguridad', 'Limpieza', 'Mantenimiento', 'Software', 'Jardinería'
  final double totalAmount; // Monto global o valor referencial
  final double recurringMonthlyAmount; // Canon recurrente si aplica
  final double oneTimeAmount; // Monto por obra/evento/instalación si aplica
  final String
  paymentTerms; // Ej: '50% Anticipo / 50% Entrega', 'Facturación mensual a 30 días'
  final String
  executionTime; // Ej: 'Contrato 12 meses', '7 días hábiles', '3 días (Feria)'
  final int advancePercentage; // 0, 30, 50, 70, 100
  final String status; // 'Vigente', 'En Ejecución', 'Completado', 'En Pausa'
  final String startDate;
  final String? endDate;
  final String? notes;

  const CustomerContract({
    required this.id,
    required this.title,
    required this.contractType,
    required this.serviceCategory,
    required this.totalAmount,
    this.recurringMonthlyAmount = 0.0,
    this.oneTimeAmount = 0.0,
    required this.paymentTerms,
    required this.executionTime,
    this.advancePercentage = 0,
    required this.status,
    required this.startDate,
    this.endDate,
    this.notes,
  });

  CustomerContract copyWith({
    String? id,
    String? title,
    String? contractType,
    String? serviceCategory,
    double? totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    String? paymentTerms,
    String? executionTime,
    int? advancePercentage,
    String? status,
    String? startDate,
    String? endDate,
    String? notes,
  }) {
    return CustomerContract(
      id: id ?? this.id,
      title: title ?? this.title,
      contractType: contractType ?? this.contractType,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      totalAmount: totalAmount ?? this.totalAmount,
      recurringMonthlyAmount:
          recurringMonthlyAmount ?? this.recurringMonthlyAmount,
      oneTimeAmount: oneTimeAmount ?? this.oneTimeAmount,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      executionTime: executionTime ?? this.executionTime,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
  final List<CustomerContract> contracts;
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
    this.contracts = const [],
    this.opportunityId,
    this.startDate,
    this.notes,
  });

  /// Facturación mensual recurrente sumada de los contratos activos.
  double get monthlyBilling {
    return contracts
        .where((c) => c.status == 'Vigente' || c.status == 'En Ejecución')
        .fold(0.0, (acc, c) => acc + c.recurringMonthlyAmount);
  }

  /// Facturación total acumulada de proyectos únicos y eventos.
  double get totalProjectBilling {
    return contracts.fold(0.0, (acc, c) => acc + c.oneTimeAmount);
  }

  /// Modalidad principal de la cuenta.
  String get primaryContractType {
    if (contracts.isEmpty) return 'Recurrente Mensual';
    final hasRecurring = contracts.any(
      (c) =>
          c.contractType == 'Recurrente Mensual' &&
          (c.status == 'Vigente' || c.status == 'En Ejecución'),
    );
    final hasProject = contracts.any(
      (c) =>
          c.contractType == 'Proyecto Único' &&
          (c.status == 'Vigente' || c.status == 'En Ejecución'),
    );
    final hasEvent = contracts.any(
      (c) =>
          c.contractType == 'Servicio por Evento' &&
          (c.status == 'Vigente' || c.status == 'En Ejecución'),
    );
    final hasHybrid = contracts.any(
      (c) =>
          c.contractType == 'Híbrido' &&
          (c.status == 'Vigente' || c.status == 'En Ejecución'),
    );

    if (hasHybrid || (hasRecurring && hasProject)) return 'Híbrido';
    if (hasRecurring) return 'Recurrente Mensual';
    if (hasProject) return 'Proyecto Único';
    if (hasEvent) return 'Servicio por Evento';
    return contracts.first.contractType;
  }

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
    List<CustomerContract>? contracts,
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
      contracts: contracts ?? this.contracts,
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

  double get totalProjectVolume => _customers.fold<double>(
    0.0,
    (acc, c) => acc + c.totalProjectBilling,
  );

  int get totalActiveCustomers =>
      _customers.where((c) => c.status == 'Activo').length;

  int get totalBranches =>
      _customers.fold<int>(0, (acc, c) => acc + c.branches.length);

  int get totalContracts =>
      _customers.fold<int>(0, (acc, c) => acc + c.contracts.length);

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

  void addContractToCustomer(String customerId, CustomerContract newContract) {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx != -1) {
      final current = _customers[idx];
      final updatedContracts = List<CustomerContract>.from(current.contracts)
        ..add(newContract);
      final updatedServices = Set<String>.from(current.activeServices)
        ..add(newContract.serviceCategory);

      _customers[idx] = current.copyWith(
        contracts: updatedContracts,
        activeServices: updatedServices.toList(),
      );
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
        contracts: [
          CustomerContract(
            id: 'CTR-001',
            title: 'Servicio Recurrente de Limpieza y Mantenimiento Diario',
            contractType: 'Recurrente Mensual',
            serviceCategory: 'Limpieza Integral',
            totalAmount: 162000.0,
            recurringMonthlyAmount: 13500.0,
            paymentTerms: 'Facturación mensual a 30 días',
            executionTime: 'Contrato 12 meses',
            status: 'Vigente',
            startDate: '15 Ene 2025',
          ),
          CustomerContract(
            id: 'CTR-002',
            title: 'Mantenimiento y Reparación de Grupo Electrógeno y Tanques',
            contractType: 'Proyecto Único',
            serviceCategory: 'Mantenimiento',
            totalAmount: 9800.0,
            oneTimeAmount: 9800.0,
            paymentTerms: '50% Anticipo / 50% Recepción Conforme',
            executionTime: '7 días hábiles',
            advancePercentage: 50,
            status: 'Completado',
            startDate: '10 Feb 2025',
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
        contracts: [
          CustomerContract(
            id: 'CTR-003',
            title: 'Puesto Seguridad Perimetral 24/7 y Garitas',
            contractType: 'Recurrente Mensual',
            serviceCategory: 'Seguridad Física',
            totalAmount: 226800.0,
            recurringMonthlyAmount: 18900.0,
            paymentTerms: 'Facturación mensual contra planilla',
            executionTime: 'Contrato 12 meses renovable',
            status: 'Vigente',
            startDate: '01 Mar 2025',
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
        contracts: [
          CustomerContract(
            id: 'CTR-004',
            title: 'Seguridad Integral Multi-Agencia La Paz / El Alto',
            contractType: 'Recurrente Mensual',
            serviceCategory: 'Seguridad Física',
            totalAmount: 348000.0,
            recurringMonthlyAmount: 29000.0,
            paymentTerms: 'Facturación mensual a 30 días',
            executionTime: 'Contrato 24 meses',
            status: 'Vigente',
            startDate: '10 Nov 2024',
          ),
          CustomerContract(
            id: 'CTR-005',
            title: 'Pulido, Sellado y Vitrificado de Pisos Central',
            contractType: 'Proyecto Único',
            serviceCategory: 'Limpieza Integral',
            totalAmount: 12500.0,
            oneTimeAmount: 12500.0,
            paymentTerms: '30% Anticipo / 70% Entrega de Obra',
            executionTime: '5 días hábiles',
            advancePercentage: 30,
            status: 'En Ejecución',
            startDate: '12 Sep 2026',
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
        contracts: [
          CustomerContract(
            id: 'CTR-006',
            title: 'Mantenimiento Paisajístico y Jardinería Periódica',
            contractType: 'Recurrente Mensual',
            serviceCategory: 'Jardinería',
            totalAmount: 54000.0,
            recurringMonthlyAmount: 5400.0,
            paymentTerms: 'Facturación mensual a 30 días',
            executionTime: '10 meses escolares',
            status: 'En Pausa',
            startDate: '01 Feb 2025',
          ),
        ],
      ),
      const CustomerItem(
        id: 'CLI-005',
        legalName: 'Feria Exposición Internacional del Oriente',
        tradeName: 'Fexpocruz Eventos',
        taxId: '4091827364',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: ['Seguridad Física', 'Limpieza Integral'],
        contactPerson: 'Lic. Fernando Banzer',
        phone: '+591 760-99881',
        email: 'eventos@fexpocruz.com.bo',
        startDate: '01 Sep 2026',
        branches: [
          CustomerBranch(
            id: 'BR-008',
            name: 'Predio Ferial - Pabellón Internacional',
            address: 'Av. Roca y Coronado s/n',
            localContact: 'Lic. Fernando Banzer',
            localPhone: '+591 760-99881',
            isHeadquarters: true,
          ),
        ],
        contracts: [
          CustomerContract(
            id: 'CTR-007',
            title: 'Operativo Especial de Seguridad y Limpieza Expocruz 2026',
            contractType: 'Servicio por Evento',
            serviceCategory: 'Seguridad Física',
            totalAmount: 45000.0,
            oneTimeAmount: 45000.0,
            paymentTerms: '50% Anticipo / 50% Cierre del Evento',
            executionTime: '10 días (Feria Internacional)',
            advancePercentage: 50,
            status: 'En Ejecución',
            startDate: '18 Sep 2026',
          ),
        ],
      ),
      const CustomerItem(
        id: 'CLI-006',
        legalName: 'Torre Empresarial Delta S.A.',
        tradeName: 'Torre Delta Tech',
        taxId: '5092837461',
        segment: 'Corporativo B2B',
        status: 'Activo',
        activeServices: ['Software / Tecnología', 'Mantenimiento'],
        contactPerson: 'Ing. Alejandro Soliz',
        phone: '+591 773-45678',
        email: 'sistemas@torredelta.bo',
        startDate: '05 May 2025',
        branches: [
          CustomerBranch(
            id: 'BR-009',
            name: 'Sede Principal',
            address: 'Av. Cristóbal de Mendoza #320',
            localContact: 'Ing. Alejandro Soliz',
            localPhone: '+591 773-45678',
            isHeadquarters: true,
          ),
        ],
        contracts: [
          CustomerContract(
            id: 'CTR-008',
            title: 'Instalación de Sistema Control de Accesos & Portal Web',
            contractType: 'Híbrido',
            serviceCategory: 'Software / Tecnología',
            totalAmount: 58000.0,
            oneTimeAmount: 34000.0,
            recurringMonthlyAmount: 2000.0,
            paymentTerms: '50% Anticipo Implementación + Abono Mensual Soporte',
            executionTime: '45 días instalación + 12 meses soporte',
            advancePercentage: 50,
            status: 'Vigente',
            startDate: '05 May 2025',
          ),
        ],
      ),
    ]);
  }
}
