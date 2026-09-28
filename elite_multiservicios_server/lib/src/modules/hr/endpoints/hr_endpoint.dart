import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

class HrEndpoint extends Endpoint {
  // --- Employees ---
  Future<List<HrEmployee>> getEmployees(Session session) async {
    return await HrEmployee.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  Future<HrEmployee> createOrUpdateEmployee(Session session, HrEmployee employee) async {
    if (employee.id == null) {
      employee.createdAt = DateTime.now();
      employee.updatedAt = DateTime.now();
      return await HrEmployee.db.insertRow(session, employee);
    } else {
      employee.updatedAt = DateTime.now();
      return await HrEmployee.db.updateRow(session, employee);
    }
  }

  // --- Attendance ---
  Future<List<HrAttendance>> getAttendance(Session session, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return await HrAttendance.db.find(
      session,
      where: (t) => (t.date >= start) & (t.date < end),
    );
  }

  Future<HrAttendance> markAttendance(Session session, HrAttendance attendance) async {
    if (attendance.id == null) {
      attendance.createdAt = DateTime.now();
      attendance.updatedAt = DateTime.now();
      return await HrAttendance.db.insertRow(session, attendance);
    } else {
      attendance.updatedAt = DateTime.now();
      return await HrAttendance.db.updateRow(session, attendance);
    }
  }

  // --- Payroll ---
  Future<List<HrPayroll>> getPayroll(Session session, int year, int month) async {
    return await HrPayroll.db.find(
      session,
      where: (t) => t.year.equals(year) & t.month.equals(month),
    );
  }

  Future<HrPayroll> processPayroll(Session session, HrPayroll payroll) async {
    payroll.netPay = payroll.baseSalary + payroll.bonuses - payroll.deductions;
    if (payroll.id == null) {
      payroll.createdAt = DateTime.now();
      payroll.updatedAt = DateTime.now();
      return await HrPayroll.db.insertRow(session, payroll);
    } else {
      payroll.updatedAt = DateTime.now();
      return await HrPayroll.db.updateRow(session, payroll);
    }
  }

  Future<bool> payPayroll(Session session, int payrollId) async {
    final payroll = await HrPayroll.db.findById(session, payrollId);
    if (payroll == null || payroll.isPaid) return false;

    payroll.isPaid = true;
    payroll.paymentDate = DateTime.now();
    payroll.updatedAt = DateTime.now();
    await HrPayroll.db.updateRow(session, payroll);

    final employee = await HrEmployee.db.findById(session, payroll.employeeId);

    // Automatically register the expense in Accounting
    final expense = AccountingExpense(
      supplierName: 'Empleado: ${employee?.name ?? 'ID ${payroll.employeeId}'}',
      date: DateTime.now(),
      amount: payroll.netPay,
      category: 'Nómina',
      status: 'Paid',
      description: 'Pago de nómina ${payroll.month}/${payroll.year}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
    await AccountingExpense.db.insertRow(session, expense);
    return true;
  }
}
