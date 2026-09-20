import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../repositories/crm_customer_repository.dart';

/// Endpoint RPC para el catálogo maestro de Clientes 360°, Sedes Operativas y Contratos.
class CrmCustomersEndpoint extends Endpoint {
  /// Lista los clientes activos con filtros avanzados.
  Future<List<CrmCustomer>> listCustomers(
    Session session, {
    int limit = 100,
    int offset = 0,
    String? search,
    String? segment,
    String? status,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCustomersView);
    final repo = CrmCustomerDataService(session);
    return await repo.listCustomers(
      limit: limit,
      offset: offset,
      search: search,
      segment: segment,
      status: status,
    );
  }

  /// Obtiene la ficha 360° detallada e hidratada de un cliente.
  Future<CrmCustomerDetailResponse?> getCustomerDetail(
    Session session,
    int id,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCustomersView);
    final repo = CrmCustomerDataService(session);
    return await repo.getCustomerDetail(id);
  }

  /// Obtiene los datos generales de un cliente por su ID.
  Future<CrmCustomer?> getCustomer(Session session, int id) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCustomersView);
    final repo = CrmCustomerDataService(session);
    return await repo.getCustomerById(id);
  }

  /// Registra un nuevo Cliente 360°.
  Future<CrmCustomer> createCustomer(
    Session session,
    CrmCustomer customer, {
    CrmCustomerBranch? initialBranch,
    CrmCustomerContract? initialContract,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomersCreate,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.createCustomer(
      customer,
      initialBranch: initialBranch,
      initialContract: initialContract,
    );
  }

  /// Actualiza los datos generales de un cliente.
  Future<CrmCustomer> updateCustomer(
    Session session,
    CrmCustomer customer,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomersUpdate,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.updateCustomer(customer);
  }

  /// Elimina lógicamente un cliente y sus dependencias.
  Future<bool> deleteCustomer(Session session, int id) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomersDelete,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.deleteCustomer(id);
  }

  // ===========================================================================
  // SEDES OPERATIVAS (BRANCHES)
  // ===========================================================================

  /// Agrega una sede operativa a un cliente.
  Future<CrmCustomerBranch> addBranch(
    Session session,
    CrmCustomerBranch branch,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerBranchesManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.addBranch(branch);
  }

  /// Actualiza una sede operativa existente.
  Future<CrmCustomerBranch> updateBranch(
    Session session,
    CrmCustomerBranch branch,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerBranchesManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.updateBranch(branch);
  }

  /// Elimina lógicamente una sede operativa.
  Future<bool> deleteBranch(Session session, int branchId) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerBranchesManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.deleteBranch(branchId);
  }

  // ===========================================================================
  // CONTRATOS Y ÓRDENES DE TRABAJO (CONTRACTS)
  // ===========================================================================

  /// Registra un contrato con partidas de cotización.
  Future<CrmCustomerContract> addContract(
    Session session,
    CrmCustomerContract contract, {
    List<CrmContractBudgetItem>? budgetItems,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerContractsManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.addContract(contract, budgetItems: budgetItems);
  }

  /// Actualiza un contrato existente.
  Future<CrmCustomerContract> updateContract(
    Session session,
    CrmCustomerContract contract,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerContractsManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.updateContract(contract);
  }

  /// Conclusión formal de contrato/obra con calificación de satisfacción.
  Future<CrmCustomerContract?> completeContract(
    Session session,
    int contractId, {
    required DateTime actualEndDate,
    String? completionNotes,
    int satisfactionRating = 5,
    String? completedBy,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerContractsComplete,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.completeContract(
      contractId,
      actualEndDate: actualEndDate,
      completionNotes: completionNotes,
      satisfactionRating: satisfactionRating,
      completedBy: completedBy,
    );
  }

  /// Renovación directa de un contrato recurrente (+6 / +12 meses).
  Future<CrmCustomerContract?> renewContract(
    Session session,
    int contractId, {
    required int additionalMonths,
    double? adjustedMonthlyAmount,
    String? notes,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerContractsRenew,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.renewContract(
      contractId,
      additionalMonths: additionalMonths,
      adjustedMonthlyAmount: adjustedMonthlyAmount,
      notes: notes,
    );
  }

  /// Actualiza el estado puntual de un contrato (Pausar / Reactivar).
  Future<CrmCustomerContract?> updateContractStatus(
    Session session,
    int contractId,
    String newStatus,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.crmCustomerContractsManage,
    );
    final repo = CrmCustomerDataService(session);
    return await repo.updateContractStatus(contractId, newStatus);
  }

  // ===========================================================================
  // MÉTRICAS FINANCIERAS Y OPERATIVAS
  // ===========================================================================

  /// Obtiene el consolidado de métricas en tiempo real.
  Future<CrmCustomerMetricsResponse> getMetrics(Session session) async {
    await RbacGuard.requirePermission(session, AppPermissions.crmCustomersView);
    final repo = CrmCustomerDataService(session);
    return await repo.getMetrics();
  }
}
