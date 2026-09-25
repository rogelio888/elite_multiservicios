import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/ops_attendance_summary_dto.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_employee_summary_dto.dart';
import '../models/rrhh_payroll_export_dto.dart';
import 'rrhh_repository.dart';

/// Implementación remota del repositorio de RRHH conectada a Serverpod.
/// Todos los métodos lanzan UnimplementedError hasta la fase de integración (Paso 6).
class RrhhRepositoryRemote implements RrhhRepository {
  static const String _pendingMsg = 'Pendiente Paso 6 - integración con Serverpod';

  @override
  bool get isMock => false;

  @override
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhRecentMovementDto>> getRecentMovements() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> getEmployeeById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhTimelineEvent>> listTimelineEvents(int employeeId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhApplicantSummaryDto>> listApplicants({
    String? status,
    String? search,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhApplicant> getApplicantById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhApplicant> createApplicant(RrhhApplicant applicant) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> hireApplicant({
    required int? applicantId,
    required RrhhEmployee employeeData,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhArea>> listAreas() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhArea> createArea(RrhhArea area) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhArea> updateArea(RrhhArea area) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhPosition>> listPositions() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPosition> createPosition(RrhhPosition position) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPosition> updatePosition(RrhhPosition position) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhSpecialty>> listSpecialties() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhSchedule>> listSchedules() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? status,
    String? type,
    DateTime? month,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest> resolveLeaveRequest(
    int requestId,
    String newStatus, {
    String? resolutionNotes,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhVacation>> listVacations() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacation> requestVacation(RrhhVacation vacation) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacation> approveVacation(
    int vacationId, {
    required String approvedBy,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhIncident>> listIncidents({
    String? severity,
    String? search,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhIncident> recordIncident(RrhhIncident incident) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhTermination>> listTerminations() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime exitDate,
    required String reason,
    required String exitObservations,
    required String registeredBy,
    required double severancePay,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<OpsAttendanceSummaryDto>> listAttendanceRecords(
    DateTime date, {
    String? status,
    String? area,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhMovementHistory>> listMovements({
    String? movementType,
    int? employeeId,
    int? limit,
    int? offset,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<CrmClientRefDto>> listClientReferences() async {
    throw UnimplementedError(_pendingMsg);
  }
}
