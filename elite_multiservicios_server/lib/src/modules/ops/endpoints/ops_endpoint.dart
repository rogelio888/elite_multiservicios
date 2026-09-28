import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

class OpsEndpoint extends Endpoint {
  // --- Inventory ---
  Future<List<OpsInventoryItem>> getInventory(Session session) async {
    return await OpsInventoryItem.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  Future<OpsInventoryItem> createOrUpdateItem(Session session, OpsInventoryItem item) async {
    if (item.id == null) {
      item.createdAt = DateTime.now();
      item.updatedAt = DateTime.now();
      return await OpsInventoryItem.db.insertRow(session, item);
    } else {
      item.updatedAt = DateTime.now();
      return await OpsInventoryItem.db.updateRow(session, item);
    }
  }

  // --- Service Contracts ---
  Future<List<OpsServiceContract>> getContracts(Session session) async {
    return await OpsServiceContract.db.find(
      session,
      orderBy: (t) => t.startDate,
      orderDescending: true,
    );
  }

  Future<OpsServiceContract> createOrUpdateContract(Session session, OpsServiceContract contract) async {
    if (contract.id == null) {
      contract.createdAt = DateTime.now();
      contract.updatedAt = DateTime.now();
      return await OpsServiceContract.db.insertRow(session, contract);
    } else {
      contract.updatedAt = DateTime.now();
      return await OpsServiceContract.db.updateRow(session, contract);
    }
  }

  // --- Work Orders ---
  Future<List<OpsWorkOrder>> getWorkOrders(Session session, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return await OpsWorkOrder.db.find(
      session,
      where: (t) => (t.date >= start) & (t.date < end),
    );
  }

  Future<OpsWorkOrder> createOrUpdateWorkOrder(Session session, OpsWorkOrder order) async {
    if (order.id == null) {
      order.createdAt = DateTime.now();
      order.updatedAt = DateTime.now();
      return await OpsWorkOrder.db.insertRow(session, order);
    } else {
      order.updatedAt = DateTime.now();
      return await OpsWorkOrder.db.updateRow(session, order);
    }
  }

  // --- Inventory Usage & Accounting Integration ---
  Future<OpsInventoryUsage> registerUsage(Session session, OpsInventoryUsage usage) async {
    // Buscar el item
    final item = await OpsInventoryItem.db.findById(session, usage.itemId);
    if (item == null) throw Exception('Item no encontrado');

    // Descontar inventario
    item.quantityInStock -= usage.quantityUsed;
    item.updatedAt = DateTime.now();
    await OpsInventoryItem.db.updateRow(session, item);

    // Calcular costo
    usage.totalCost = usage.quantityUsed * item.averageCost;
    usage.createdAt = DateTime.now();
    final insertedUsage = await OpsInventoryUsage.db.insertRow(session, usage);

    // Registrar costo en contabilidad automáticamente
    final expense = AccountingExpense(
      supplierName: 'Insumos Operativos',
      date: DateTime.now(),
      amount: usage.totalCost,
      category: 'Insumos Operativos',
      status: 'Paid',
      description: 'Uso en O.T. #${usage.workOrderId}: ${usage.quantityUsed} ${item.unit} de ${item.name}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
    await AccountingExpense.db.insertRow(session, expense);

    return insertedUsage;
  }
}
