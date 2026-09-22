import 'dart:async';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart' show client;
import 'crm_pipeline_service.dart';

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

/// Partida o Ítem individual dentro del presupuesto / cotización de un Contrato.
class ContractBudgetItem {
  final String id;
  final String description;
  final double quantity;
  final String
  unit; // 'Mes', 'Puesto', 'Global', 'Horas', 'm²', 'Unidad', 'Visita'
  final double unitPrice;
  final int? catalogItemId;

  const ContractBudgetItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.catalogItemId,
  });

  double get subtotal => quantity * unitPrice;

  ContractBudgetItem copyWith({
    String? id,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    int? catalogItemId,
  }) {
    return ContractBudgetItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      catalogItemId: catalogItemId ?? this.catalogItemId,
    );
  }
}

/// Modelo de Contrato u Orden de Trabajo para Clientes 360°.
/// Abarca modalidades: Recurrente Mensual, Proyecto Único / Obra, Servicio por Evento, Híbrido.
class CustomerContract {
  final String id;
  final int? rawContractId;
  final String title;
  final String
  contractType; // 'Recurrente Mensual', 'Proyecto Único', 'Servicio por Evento', 'Híbrido'
  final String
  serviceCategory; // 'Seguridad', 'Limpieza', 'Mantenimiento', 'Software', 'Jardinería'
  final String
  serviceFrequency; // 'Lunes a Viernes', 'Lunes a Sábado', '24/7 (Continuo)', 'Interdiario', 'Fin de Semana'
  final String? scheduleHours; // Ej: '08:00 - 17:00'
  final int? billingCycleDay; // Día de corte de facturación mensual (1 al 31)
  final String? specificRequirements; // Requisitos operativos específicos
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
  final String? branchId;
  final String? branchName;
  final String
  originType; // 'Venta Nueva', 'Recontratación', 'Renovación', 'Adicional'
  final String? actualEndDate;
  final String? completionNotes;
  final int? satisfactionRating; // 1 a 5 estrellas
  final String? completedBy;
  final List<ContractBudgetItem> budgetItems;
  final String? serviceScope; // Especificación técnica detallada del alcance

  const CustomerContract({
    required this.id,
    this.rawContractId,
    required this.title,
    required this.contractType,
    required this.serviceCategory,
    this.serviceFrequency = 'Lunes a Viernes',
    this.scheduleHours,
    this.billingCycleDay = 5,
    this.specificRequirements,
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
    this.branchId,
    this.branchName,
    this.originType = 'Venta Nueva',
    this.actualEndDate,
    this.completionNotes,
    this.satisfactionRating,
    this.completedBy,
    this.budgetItems = const [],
    this.serviceScope,
  });

  CustomerContract copyWith({
    String? id,
    int? rawContractId,
    String? title,
    String? contractType,
    String? serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
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
    String? branchId,
    String? branchName,
    String? originType,
    String? actualEndDate,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    List<ContractBudgetItem>? budgetItems,
    String? serviceScope,
  }) {
    return CustomerContract(
      id: id ?? this.id,
      rawContractId: rawContractId ?? this.rawContractId,
      title: title ?? this.title,
      contractType: contractType ?? this.contractType,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceFrequency: serviceFrequency ?? this.serviceFrequency,
      scheduleHours: scheduleHours ?? this.scheduleHours,
      billingCycleDay: billingCycleDay ?? this.billingCycleDay,
      specificRequirements: specificRequirements ?? this.specificRequirements,
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
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      originType: originType ?? this.originType,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      completionNotes: completionNotes ?? this.completionNotes,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
      completedBy: completedBy ?? this.completedBy,
      budgetItems: budgetItems ?? this.budgetItems,
      serviceScope: serviceScope ?? this.serviceScope,
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

  /// Indica si el cliente tiene al menos un contrato activo (Vigente o En Ejecución).
  bool get hasActiveContracts =>
      contracts.any((c) => c.status == 'Vigente' || c.status == 'En Ejecución');

  /// Calificación promedio de satisfacción de los contratos completados.
  double? get averageSatisfaction {
    final rated = contracts
        .where((c) => c.satisfactionRating != null && c.satisfactionRating! > 0)
        .map((c) => c.satisfactionRating!)
        .toList();
    if (rated.isEmpty) return null;
    return rated.reduce((a, b) => a + b) / rated.length;
  }

  /// Facturación mensual recurrente sumada de los contratos activos.
  double get monthlyBilling {
    return contracts
        .where((c) => c.status == 'Vigente' || c.status == 'En Ejecución')
        .fold(0.0, (acc, c) => acc + c.recurringMonthlyAmount);
  }

  /// Facturación total acumulada de proyectos únicos, eventos y obras cerradas.
  double get totalProjectBilling {
    return contracts.fold(0.0, (acc, c) {
      if (c.contractType == 'Proyecto Único' ||
          c.contractType == 'Servicio por Evento' ||
          c.contractType == 'Híbrido' ||
          c.status == 'Completado') {
        final amount = c.oneTimeAmount > 0 ? c.oneTimeAmount : c.totalAmount;
        return acc + amount;
      }
      return acc;
    });
  }

  /// Estado operativo visible de la cuenta
  String get operationalStatus {
    if (status == 'En Pausa') return 'En Pausa';
    if (status == 'Inactivo') return 'Inactivo';
    if (!hasActiveContracts) {
      if (contracts.any((c) => c.status == 'Completado')) {
        return 'Concluido';
      }
      return 'Sin Contrato';
    }
    return 'Activo';
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

  /// Etapa de fidelización y ciclo de vida de la cuenta.
  String get lifecycleStage {
    if (contracts.isEmpty) return 'Listo para Recontratar';
    final activeContracts = contracts
        .where((c) => c.status == 'Vigente' || c.status == 'En Ejecución')
        .toList();

    if (activeContracts.isEmpty) {
      return 'Listo para Recontratar';
    }

    // Si tiene contratos recurrentes con nota de vencimiento próximo o en ejecución final
    final hasExpiring = activeContracts.any((c) {
      final text = '${c.executionTime} ${c.notes ?? ''} ${c.endDate ?? ''}'
          .toLowerCase();
      return text.contains('vence') ||
          text.contains('renovación') ||
          text.contains('próximo');
    });

    if (hasExpiring) return 'Por Vencer';
    return 'En Servicio Activo';
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

/// Servicio singleton reactivo para gestionar el catálogo centralizado de Clientes 360°
/// conectado directamente a los endpoints RPC de Serverpod y PostgreSQL.
class CrmCustomersService extends ChangeNotifier {
  static final CrmCustomersService _instance = CrmCustomersService._internal();
  factory CrmCustomersService({Client? customClient}) {
    if (customClient != null) {
      _instance._clientOverride = customClient;
    }
    return _instance;
  }

  CrmCustomersService._internal();

  Client? _clientOverride;
  Client get _activeClient => _clientOverride ?? client;

  final List<CustomerItem> _customers = [];
  bool _isLoading = false;
  String? _error;

  List<CustomerItem> get customers => List.unmodifiable(_customers);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga la lista de clientes reales desde PostgreSQL vía Serverpod RPC.
  Future<void> loadCustomers({
    String? search,
    String? segment,
    String? status,
  }) async {
    _isLoading = true;
    _error = null;
    scheduleMicrotask(() => notifyListeners());

    try {
      final remoteCustomers = await _activeClient.crmCustomers.listCustomers(
        limit: 200,
        offset: 0,
        search: search,
        segment: segment,
        status: status,
      );

      _customers.clear();
      for (final c in remoteCustomers) {
        if (c.id != null) {
          try {
            final detail = await _activeClient.crmCustomers.getCustomerDetail(
              c.id!,
            );
            if (detail != null) {
              _customers.add(_fromDetailResponse(detail));
              continue;
            }
          } catch (_) {}
        }
        _customers.add(_fromCrmCustomer(c));
      }
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al cargar clientes: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  CustomerItem? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<CustomerItem> searchCustomers(String query) {
    if (query.trim().isEmpty) return List.unmodifiable(_customers);
    final q = query.toLowerCase();
    return _customers.where((c) {
      return c.legalName.toLowerCase().contains(q) ||
          c.tradeName.toLowerCase().contains(q) ||
          c.taxId.contains(q) ||
          c.contactPerson.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> addCustomer(CustomerItem customer) async {
    _customers.insert(0, customer);
    notifyListeners();

    try {
      final crmCust = _toCrmCustomer(customer);
      final created = await _activeClient.crmCustomers.createCustomer(crmCust);

      for (final b in customer.branches) {
        await _activeClient.crmCustomers.addBranch(
          CrmCustomerBranch(
            code: b.id,
            customerId: created.id!,
            name: b.name,
            address: b.address,
            localContact: b.localContact,
            localPhone: b.localPhone,
            isHeadquarters: b.isHeadquarters,
            notes: b.notes,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      for (final ctr in customer.contracts) {
        await _activeClient.crmCustomers.addContract(
          CrmCustomerContract(
            code: ctr.id,
            customerId: created.id!,
            title: ctr.title,
            contractType: ctr.contractType,
            serviceCategory: ctr.serviceCategory,
            serviceFrequency: ctr.serviceFrequency,
            scheduleHours: ctr.scheduleHours,
            billingCycleDay: ctr.billingCycleDay,
            specificRequirements: ctr.specificRequirements,
            totalAmount: ctr.totalAmount,
            recurringMonthlyAmount: ctr.recurringMonthlyAmount,
            oneTimeAmount: ctr.oneTimeAmount,
            paymentTerms: ctr.paymentTerms,
            executionTime: ctr.executionTime,
            advancePercentage: ctr.advancePercentage,
            status: ctr.status,
            startDate: DateTime.now().toUtc(),
            originType: ctr.originType,
            serviceScope: ctr.serviceScope,
            notes: ctr.notes,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
          budgetItems: ctr.budgetItems
              .map(
                (b) => CrmContractBudgetItem(
                  contractId: 0,
                  catalogItemId: b.catalogItemId,
                  description: b.description,
                  quantity: b.quantity,
                  unit: b.unit,
                  unitPrice: b.unitPrice,
                  isDeleted: false,
                  createdAt: DateTime.now().toUtc(),
                  updatedAt: DateTime.now().toUtc(),
                ),
              )
              .toList(),
        );
      }
      await loadCustomers();
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al persistir cliente: $e');
    }
  }

  Future<void> updateCustomer(CustomerItem updated) async {
    final idx = _customers.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _customers[idx] = updated;
      notifyListeners();
    }
    try {
      await _activeClient.crmCustomers.updateCustomer(_toCrmCustomer(updated));
      await loadCustomers();
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al actualizar cliente: $e');
    }
  }

  Future<void> addBranchToCustomer(
    String customerId,
    CustomerBranch newBranch,
  ) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx != -1) {
      final current = _customers[idx];
      final updatedBranches = List<CustomerBranch>.from(current.branches)
        ..add(newBranch);
      _customers[idx] = current.copyWith(branches: updatedBranches);
      notifyListeners();
    }
    try {
      final rawId = int.tryParse(customerId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawId != null && rawId > 0) {
        await _activeClient.crmCustomers.addBranch(
          CrmCustomerBranch(
            code: newBranch.id,
            customerId: rawId,
            name: newBranch.name,
            address: newBranch.address,
            localContact: newBranch.localContact,
            localPhone: newBranch.localPhone,
            isHeadquarters: newBranch.isHeadquarters,
            notes: newBranch.notes,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al agregar sede: $e');
    }
  }

  Future<void> addContractToCustomer(
    String customerId,
    CustomerContract newContract,
  ) async {
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
    try {
      final rawId = int.tryParse(customerId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawId != null && rawId > 0) {
        final savedContract = await _activeClient.crmCustomers.addContract(
          CrmCustomerContract(
            code: newContract.id,
            customerId: rawId,
            title: newContract.title,
            contractType: newContract.contractType,
            serviceCategory: newContract.serviceCategory,
            serviceFrequency: newContract.serviceFrequency,
            scheduleHours: newContract.scheduleHours,
            billingCycleDay: newContract.billingCycleDay,
            specificRequirements: newContract.specificRequirements,
            totalAmount: newContract.totalAmount,
            recurringMonthlyAmount: newContract.recurringMonthlyAmount,
            oneTimeAmount: newContract.oneTimeAmount,
            paymentTerms: newContract.paymentTerms,
            executionTime: newContract.executionTime,
            advancePercentage: newContract.advancePercentage,
            status: newContract.status,
            startDate: DateTime.now().toUtc(),
            originType: newContract.originType,
            serviceScope: newContract.serviceScope,
            notes: newContract.notes,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
          budgetItems: newContract.budgetItems
              .map(
                (b) => CrmContractBudgetItem(
                  contractId: 0,
                  catalogItemId: b.catalogItemId,
                  description: b.description,
                  quantity: b.quantity,
                  unit: b.unit,
                  unitPrice: b.unitPrice,
                  isDeleted: false,
                  createdAt: DateTime.now().toUtc(),
                  updatedAt: DateTime.now().toUtc(),
                ),
              )
              .toList(),
        );
        if (idx != -1) {
          final current = _customers[idx];
          final updatedContracts = current.contracts.map((c) {
            if (c.id == newContract.id) {
              return c.copyWith(rawContractId: savedContract.id);
            }
            return c;
          }).toList();
          _customers[idx] = current.copyWith(contracts: updatedContracts);
        }
      }
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al agregar contrato: $e');
    }
  }

  /// Conclusión formal de obra, servicio o proyecto.
  Future<void> completeContract(
    String customerId,
    String contractId, {
    required String completionDate,
    String? notes,
    int rating = 5,
    String completedBy = 'Carlos V.',
  }) async {
    final cIdx = _customers.indexWhere((c) => c.id == customerId);
    if (cIdx == -1) return;
    final customer = _customers[cIdx];
    final contractIdx = customer.contracts.indexWhere(
      (c) => c.id == contractId,
    );
    if (contractIdx == -1) return;
    final contract = customer.contracts[contractIdx];

    final updatedContracts = customer.contracts.map((ctr) {
      if (ctr.id == contractId) {
        return ctr.copyWith(
          status: 'Completado',
          actualEndDate: completionDate,
          completionNotes: notes,
          satisfactionRating: rating,
          completedBy: completedBy,
        );
      }
      return ctr;
    }).toList();

    _customers[cIdx] = customer.copyWith(contracts: updatedContracts);
    notifyListeners();

    try {
      final rawContractId =
          contract.rawContractId ??
          int.tryParse(contract.id.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawContractId != null && rawContractId > 0) {
        DateTime actualEnd = DateTime.now().toUtc();
        try {
          final parts = completionDate.split('/');
          if (parts.length == 3) {
            actualEnd = DateTime.utc(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          } else {
            actualEnd =
                DateTime.tryParse(completionDate)?.toUtc() ??
                DateTime.now().toUtc();
          }
        } catch (_) {}

        await _activeClient.crmCustomers.completeContract(
          rawContractId,
          actualEndDate: actualEnd,
          completionNotes: notes,
          satisfactionRating: rating,
          completedBy: completedBy,
        );
      }
    } catch (e) {
      debugPrint(
        '[CrmCustomersService] Error al persistir completeContract: $e',
      );
    }
  }

  /// Renovación directa de un contrato recurrente (+6 / +12 meses).
  Future<void> renewContract(
    String customerId,
    String contractId, {
    required int additionalMonths,
    double? adjustedMonthlyAmount,
    String? notes,
  }) async {
    final cIdx = _customers.indexWhere((c) => c.id == customerId);
    if (cIdx == -1) return;
    final customer = _customers[cIdx];
    final contractIdx = customer.contracts.indexWhere(
      (c) => c.id == contractId,
    );
    if (contractIdx == -1) return;
    final contract = customer.contracts[contractIdx];

    final updatedContracts = customer.contracts.map((ctr) {
      if (ctr.id == contractId) {
        final newExecution = 'Renovado +$additionalMonths meses';
        final newMonthly = adjustedMonthlyAmount ?? ctr.recurringMonthlyAmount;
        return ctr.copyWith(
          status: 'Vigente',
          executionTime: newExecution,
          recurringMonthlyAmount: newMonthly,
          originType: 'Renovación',
          notes:
              notes ??
              'Contrato renovado por $additionalMonths meses adicionales.',
        );
      }
      return ctr;
    }).toList();

    _customers[cIdx] = customer.copyWith(contracts: updatedContracts);
    notifyListeners();

    try {
      final rawContractId =
          contract.rawContractId ??
          int.tryParse(contract.id.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawContractId != null && rawContractId > 0) {
        await _activeClient.crmCustomers.renewContract(
          rawContractId,
          additionalMonths: additionalMonths,
          adjustedMonthlyAmount: adjustedMonthlyAmount,
          notes: notes,
        );
      }
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al persistir renewContract: $e');
    }
  }

  /// Cambio de estado puntual de un contrato (Pausar / Reactivar).
  Future<void> updateContractStatus(
    String customerId,
    String contractId,
    String newStatus,
  ) async {
    final cIdx = _customers.indexWhere((c) => c.id == customerId);
    if (cIdx == -1) return;
    final customer = _customers[cIdx];
    final contractIdx = customer.contracts.indexWhere(
      (c) => c.id == contractId,
    );
    if (contractIdx == -1) return;
    final contract = customer.contracts[contractIdx];

    final updatedContracts = customer.contracts.map((ctr) {
      if (ctr.id == contractId) {
        return ctr.copyWith(status: newStatus);
      }
      return ctr;
    }).toList();

    _customers[cIdx] = customer.copyWith(contracts: updatedContracts);
    notifyListeners();

    try {
      final rawContractId =
          contract.rawContractId ??
          int.tryParse(contract.id.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawContractId != null && rawContractId > 0) {
        await _activeClient.crmCustomers.updateContractStatus(
          rawContractId,
          newStatus,
        );
      }
    } catch (e) {
      debugPrint(
        '[CrmCustomersService] Error al persistir updateContractStatus: $e',
      );
    }
  }

  /// Reabre la negociación de un contrato, actualizando su estado a 'En Renegociación'
  /// y retornando la oportunidad correspondiente al Pipeline en la etapa 'Negociación'.
  Future<void> reopenContractNegotiation(
    String customerId,
    String contractId, {
    required String reason,
    String? opportunityId,
  }) async {
    final cIdx = _customers.indexWhere((c) => c.id == customerId);
    if (cIdx == -1) return;
    final customer = _customers[cIdx];
    final updatedContracts = customer.contracts.map((ctr) {
      if (ctr.id == contractId) {
        return ctr.copyWith(
          status: 'En Renegociación',
          notes: ctr.notes != null && ctr.notes!.isNotEmpty
              ? '${ctr.notes}\n[Renegociación]: $reason'
              : '[Renegociación]: $reason',
        );
      }
      return ctr;
    }).toList();

    _customers[cIdx] = customer.copyWith(contracts: updatedContracts);
    notifyListeners();

    // Reabrir oportunidad en el Pipeline si existe
    final targetOppId = opportunityId ?? customer.opportunityId;
    if (targetOppId != null && targetOppId.isNotEmpty) {
      await CrmPipelineService().reopenDealToNegotiation(
        targetOppId,
        reason: reason,
      );
    }
  }

  /// Cancela o rescinde un contrato formalmente con justificación.
  Future<void> cancelContract(
    String customerId,
    String contractId, {
    required String reason,
  }) async {
    final cIdx = _customers.indexWhere((c) => c.id == customerId);
    if (cIdx == -1) return;
    final customer = _customers[cIdx];
    final contractIdx = customer.contracts.indexWhere(
      (c) => c.id == contractId,
    );
    if (contractIdx == -1) return;
    final contract = customer.contracts[contractIdx];

    final updatedContracts = customer.contracts.map((ctr) {
      if (ctr.id == contractId) {
        return ctr.copyWith(
          status: 'Cancelado',
          notes: ctr.notes != null && ctr.notes!.isNotEmpty
              ? '${ctr.notes}\n[Cancelación]: $reason'
              : '[Cancelación]: $reason',
        );
      }
      return ctr;
    }).toList();

    _customers[cIdx] = customer.copyWith(contracts: updatedContracts);
    notifyListeners();

    try {
      final rawContractId =
          contract.rawContractId ??
          int.tryParse(contract.id.replaceAll(RegExp(r'[^0-9]'), ''));
      if (rawContractId != null && rawContractId > 0) {
        await _activeClient.crmCustomers.updateContractStatus(
          rawContractId,
          'Cancelado',
        );
      }
    } catch (e) {
      debugPrint('[CrmCustomersService] Error al persistir cancelContract: $e');
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

  static CustomerItem _fromDetailResponse(CrmCustomerDetailResponse detail) {
    final c = detail.customer;
    return CustomerItem(
      id: c.code.isNotEmpty ? c.code : (c.id?.toString() ?? ''),
      legalName: c.legalName,
      tradeName: c.tradeName,
      taxId: c.taxId,
      segment: c.segment,
      status: c.status,
      activeServices: c.activeServices,
      contactPerson: c.contactPerson,
      phone: c.phone,
      email: c.email,
      opportunityId: c.opportunityId?.toString(),
      startDate: c.startDate != null
          ? '${c.startDate!.day.toString().padLeft(2, '0')}/${c.startDate!.month.toString().padLeft(2, '0')}/${c.startDate!.year}'
          : null,
      notes: c.notes,
      branches: detail.branches
          .map(
            (b) => CustomerBranch(
              id: b.code.isNotEmpty ? b.code : (b.id?.toString() ?? ''),
              name: b.name,
              address: b.address,
              localContact: b.localContact,
              localPhone: b.localPhone,
              isHeadquarters: b.isHeadquarters,
              notes: b.notes,
            ),
          )
          .toList(),
      contracts: detail.contracts
          .map(
            (ctr) => CustomerContract(
              id: ctr.code.isNotEmpty ? ctr.code : (ctr.id?.toString() ?? ''),
              rawContractId: ctr.id,
              title: ctr.title,
              contractType: ctr.contractType,
              serviceCategory: ctr.serviceCategory,
              serviceFrequency: ctr.serviceFrequency,
              scheduleHours: ctr.scheduleHours,
              billingCycleDay: ctr.billingCycleDay,
              specificRequirements: ctr.specificRequirements,
              totalAmount: ctr.totalAmount,
              recurringMonthlyAmount: ctr.recurringMonthlyAmount,
              oneTimeAmount: ctr.oneTimeAmount,
              paymentTerms: ctr.paymentTerms,
              executionTime: ctr.executionTime,
              advancePercentage: ctr.advancePercentage,
              status: ctr.status,
              startDate:
                  '${ctr.startDate.day.toString().padLeft(2, '0')}/${ctr.startDate.month.toString().padLeft(2, '0')}/${ctr.startDate.year}',
              notes: ctr.notes,
              branchId: ctr.branchId?.toString(),
              originType: ctr.originType,
              actualEndDate: ctr.actualEndDate?.toString(),
              completionNotes: ctr.completionNotes,
              satisfactionRating: ctr.satisfactionRating,
              completedBy: ctr.completedBy,
              serviceScope: ctr.serviceScope,
              budgetItems: detail.budgetItems
                  .where((b) => b.contractId == ctr.id)
                  .map(
                    (b) => ContractBudgetItem(
                      id: b.id.toString(),
                      catalogItemId: b.catalogItemId,
                      description: b.description,
                      quantity: b.quantity,
                      unit: b.unit,
                      unitPrice: b.unitPrice,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  static CustomerItem _fromCrmCustomer(CrmCustomer c) {
    return CustomerItem(
      id: c.code.isNotEmpty ? c.code : (c.id?.toString() ?? ''),
      legalName: c.legalName,
      tradeName: c.tradeName,
      taxId: c.taxId,
      segment: c.segment,
      status: c.status,
      activeServices: c.activeServices,
      contactPerson: c.contactPerson,
      phone: c.phone,
      email: c.email,
      opportunityId: c.opportunityId?.toString(),
      startDate: c.startDate != null
          ? '${c.startDate!.day.toString().padLeft(2, '0')}/${c.startDate!.month.toString().padLeft(2, '0')}/${c.startDate!.year}'
          : null,
      notes: c.notes,
      branches: const [],
      contracts: const [],
    );
  }

  static CrmCustomer _toCrmCustomer(CustomerItem c) {
    final rawId = int.tryParse(c.id.replaceAll(RegExp(r'[^0-9]'), ''));
    final now = DateTime.now().toUtc();
    return CrmCustomer(
      id: rawId != null && rawId > 0 ? rawId : null,
      code: c.id.startsWith('CLI') ? c.id : '',
      legalName: c.legalName,
      tradeName: c.tradeName,
      taxId: c.taxId,
      segment: c.segment,
      status: c.status,
      activeServices: c.activeServices,
      contactPerson: c.contactPerson,
      phone: c.phone,
      email: c.email,
      opportunityId: c.opportunityId != null
          ? int.tryParse(c.opportunityId!.replaceAll(RegExp(r'[^0-9]'), ''))
          : null,
      startDate: now,
      notes: c.notes,
      createdAt: now,
      updatedAt: now,
    );
  }

  @visibleForTesting
  void initDefaultCustomersForTesting() {
    _customers.clear();
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
            branchId: 'BR-001',
            branchName: 'Torre Central',
            originType: 'Venta Nueva',
          ),
          CustomerContract(
            id: 'CTR-002',
            title: 'Mantenimiento y Reparación de Grupo Electrógeno y Tanques',
            contractType: 'Proyecto Único',
            serviceCategory: 'Mantenimiento',
            totalAmount: 18500.0,
            oneTimeAmount: 18500.0,
            paymentTerms: '50% Anticipo / 50% Conformidad',
            executionTime: '15 días calendario',
            advancePercentage: 50,
            status: 'Vigente',
            startDate: '10 Feb 2025',
            branchId: 'BR-001',
            branchName: 'Torre Central',
            originType: 'Adicional',
          ),
        ],
      ),
      const CustomerItem(
        id: 'CLI-002',
        legalName: 'Condominio Residencial Las Palmas Real',
        tradeName: 'Condominio Las Palmas Real',
        taxId: '3029182736',
        segment: 'Residencial B2C',
        status: 'Activo',
        activeServices: ['Seguridad Física'],
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
            branchId: 'BR-003',
            branchName: 'Pórtico Principal y Garita',
            originType: 'Venta Nueva',
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
            branchId: 'BR-004',
            branchName: 'Oficina Central',
            originType: 'Venta Nueva',
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
            branchId: 'BR-004',
            branchName: 'Oficina Central',
            originType: 'Adicional',
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
            branchId: 'BR-007',
            branchName: 'Campus Central',
            originType: 'Venta Nueva',
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
            branchId: 'BR-008',
            branchName: 'Predio Ferial - Pabellón Internacional',
            originType: 'Venta Nueva',
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
            branchId: 'BR-009',
            branchName: 'Sede Principal',
            originType: 'Venta Nueva',
          ),
        ],
      ),
    ]);
    notifyListeners();
  }
}
