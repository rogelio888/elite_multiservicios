import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import '../models/crm_client_ref_dto.dart';
import '../models/rrhh_applicant_companion.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_employee_summary_dto.dart';
import '../models/rrhh_hiring_dossier.dart';
import '../models/rrhh_payroll_export_dto.dart';
import '../models/rrhh_shift.dart';
import 'package:flutter/material.dart';
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
  Future<List<RrhhTimelineEvent>> listTimelineEvents({
    int? employeeId,
    String? category,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? user,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhTimelineEvent?> getTimelineEventById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  List<String> listTimelineCategories() {
    return RrhhTimelineCategory.all;
  }

  @override
  List<String> listActiveUsers() {
    return const [
      'Lic. Laura Mendoza',
      'Ing. Carlos Ramos',
      'Dra. Mariana Flores',
      'Lic. Roberto Torrez',
      'Admin RRHH',
    ];
  }

  @override
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event) async {
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
  Future<RrhhEmployee> updateEmployeeBankInfo(
    int id, {
    String? bankName,
    String? accountType,
    String? accountNumber,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeSocialSecurity(
    int id, {
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeePersonalInfo(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeContract(
    int id, {
    String? contractType,
    String? paymentModality,
    String? workdayType,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeBonuses(
    int id,
    List<RrhhEmployeeBonus> bonuses,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeDeductions(
    int id,
    List<RrhhEmployeeDeduction> deductions,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeAssignment(
    int id, {
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> updateEmployeeDocuments(
    int id,
    Map<String, String> documentChecklist,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id) async {
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
  Future<RrhhApplicantCompanion> getApplicantCompanion(int applicantId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<void> saveApplicantCompanion(int applicantId, RrhhApplicantCompanion companion) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhApplicant>> findApplicantsByCi(String identityCard) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhApplicant> createApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<void> addInterviewRecord(
    int applicantId,
    RrhhInterviewRecord record,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhHiringDossier>> listActiveDossiers() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier?> getDossierById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> createDossierForApplicant(int applicantId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection1(
    int id,
    Map<String, RrhhDossierDocument> documents,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection2(
    int id, {
    String? afpId,
    String? afpName,
    String? afpNumber,
    String? healthInsuranceId,
    String? healthInsuranceName,
    String? section2Notes,
    required String sectionStatus,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection3(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    required String sectionStatus,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection4(
    int id, {
    String? contractTypeId,
    String? contractTypeName,
    String? workdayType,
    String? paymentModalityId,
    String? paymentModalityName,
    double? baseSalary,
    String? currency,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    required String sectionStatus,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection5(
    int id, {
    String? areaId,
    String? areaName,
    String? positionId,
    String? positionName,
    String? shiftId,
    String? shiftName,
    String? scheduleId,
    String? scheduleName,
    String? baseLocation,
    String? supervisorEmployeeId,
    String? supervisorName,
    DateTime? effectiveStartDate,
    required String sectionStatus,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhHiringDossier> updateDossierStatus(int id, String status) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhEmployee> convertDossierToEmployee(int dossierId, {String? notes}) async {
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
  Future<List<RrhhShift>> listShifts() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhShift> createShift(RrhhShift shift) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhShift> updateShift(RrhhShift shift) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhBaseSchedule>> listBaseSchedules() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhBaseSchedule> createBaseSchedule(RrhhBaseSchedule schedule) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhBaseSchedule> updateBaseSchedule(RrhhBaseSchedule schedule) async {
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
  Future<List<RrhhCatalogItem>> listCatalogItems(RrhhCatalogType type) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhCatalogItem> createCatalogItem(RrhhCatalogItem item) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhCatalogItem> updateCatalogItem(RrhhCatalogItem item) async {
    throw UnimplementedError(_pendingMsg);
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 08: Permisos y Licencias Médicas (Bloque 3)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? search,
    String? leaveType,
    String? status,
    bool? isPaid,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveRequest(RrhhLeaveRequest request) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveStatus(
    int id,
    String newStatus, {
    String? reason,
    String? approvedBy,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> deleteLeaveRequest(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhLeaveRequest>> listPayrollAffectingLeaves(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 09: Control de Vacaciones (Ley Laboral Bolivia)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhVacationRecord>> listVacationRecords({
    String? search,
    String? status,
    int? employeeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacationRecord?> getVacationRecordById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacationRecord> createVacationRecord(RrhhVacationRecord record) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacationRecord> updateVacationRecord(RrhhVacationRecord record) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacationRecord> updateVacationStatus(
    int id,
    String newStatus, {
    String? reason,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> deleteVacationRecord(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhVacationBalance>> listVacationBalances({
    String? search,
    String? balanceStatus,
    int? areaId,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhVacationBalance?> getVacationBalanceByEmployee(int employeeId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhVacationRecord>> listPayrollAffectingVacations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
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

  // ---------------------------------------------------------------------------
  // PANTALLA 10: Régimen Disciplinario e Incidencias (Ley Laboral Bolivia)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhDisciplinaryRecord>> listDisciplinaryRecords({
    String? status,
    String? faultType,
    String? sanctionType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhDisciplinaryRecord?> getDisciplinaryRecordById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhDisciplinaryRecord> createDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhDisciplinaryRecord> updateDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> updateDisciplinaryStatus(
    int id,
    String newStatus, {
    String? reason,
    String? dischargeText,
    String? sanctionType,
    int? suspensionDays,
    double? salaryDeduction,
    String? sanctionDescription,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> deleteDisciplinaryRecord(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhDisciplinaryRecord>> listPayrollAffectingDisciplinary(
    DateTime fromDate,
    DateTime toDate,
  ) async {
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
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhTerminationRecord> createTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhTerminationRecord> updateTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> updateTerminationStatus(
    int id,
    String newStatus, {
    String? reason,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<bool> deleteTerminationRecord(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhTerminationRecord>> listPayrollAffectingTerminations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
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
  Future<List<RrhhPayrollPeriod>> listPayrollPeriods() async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodByMonth(int year, int month) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPayrollPeriod> createPayrollPeriod(int year, int month, {String? notes}) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPayrollPeriod> closePayrollPeriod(int id, {String? closedBy, String? notes}) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhPayrollPeriod> sendPayrollPeriodToAccounting(int id, {String? sentBy}) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhPayrollItem>> listPayrollItems(int periodId, {String? sourceType, String? impactType}) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhPayrollItem>> generatePayrollItems(int periodId) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<String> exportPayrollPeriod(int periodId, String format) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<List<RrhhAttendanceRecord>> listAttendanceRecords({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
    String? serviceName,
  }) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<RrhhAttendanceRecord?> getAttendanceRecordById(int id) async {
    throw UnimplementedError(_pendingMsg);
  }

  @override
  Future<String> exportAttendanceReport({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
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
