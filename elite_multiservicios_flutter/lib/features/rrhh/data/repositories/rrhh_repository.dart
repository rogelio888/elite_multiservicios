import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/ops_attendance_summary_dto.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_employee_summary_dto.dart';
import '../models/rrhh_payroll_export_dto.dart';

import 'rrhh_repository_mock.dart';

/// Interfaz abstracta del repositorio de Recursos Humanos (RRHH).
/// Define todos los contratos de datos y operaciones requeridos por las 14 pantallas.
/// Regla R1: La UI NO llama directamente a Serverpod, todo pasa por RrhhRepository.
/// Regla R2: La UI NO conoce si el repository es mock o remoto.
abstract class RrhhRepository {
  /// Instancia global activa. Por defecto apunta al Mock hasta el Paso 6.
  static RrhhRepository current = RrhhRepositoryMock();

  /// Identifica si el repositorio está operando en modo Mock/Simulado.
  bool get isMock;

  // ---------------------------------------------------------------------------
  // PANTALLA 01: Dashboard Ejecutivo de RRHH
  // ---------------------------------------------------------------------------
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics();
  Future<List<RrhhRecentMovementDto>> getRecentMovements();

  // ---------------------------------------------------------------------------
  // PANTALLA 02: Directorio / Nómina de Personal
  // ---------------------------------------------------------------------------
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 03: Expediente del Empleado (Detalle 360°)
  // ---------------------------------------------------------------------------
  Future<RrhhEmployee> getEmployeeById(int id);
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId);
  Future<List<RrhhTimelineEvent>> listTimelineEvents(int employeeId);
  /// Asignación activa reportada por Operaciones (Solo Lectura desde Operaciones)
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId);
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee);

  // ---------------------------------------------------------------------------
  // PANTALLA 04: Reclutamiento & Pipeline de Postulantes
  // ---------------------------------------------------------------------------
  Future<List<RrhhApplicantSummaryDto>> listApplicants({
    String? status,
    String? search,
  });
  Future<RrhhApplicant> getApplicantById(int id);
  Future<RrhhApplicant> createApplicant(RrhhApplicant applicant);
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 05: Contratación Formal (Wizard / Stepper)
  // ---------------------------------------------------------------------------
  Future<RrhhEmployee> hireApplicant({
    required int? applicantId,
    required RrhhEmployee employeeData,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 06: Estructura Organizacional
  // ---------------------------------------------------------------------------
  Future<List<RrhhArea>> listAreas();
  Future<RrhhArea> createArea(RrhhArea area);
  Future<RrhhArea> updateArea(RrhhArea area);

  Future<List<RrhhPosition>> listPositions();
  Future<RrhhPosition> createPosition(RrhhPosition position);
  Future<RrhhPosition> updatePosition(RrhhPosition position);

  Future<List<RrhhSpecialty>> listSpecialties();
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty);
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty);

  // ---------------------------------------------------------------------------
  // PANTALLA 07: Catálogo de Horarios y Turnos Base
  // ---------------------------------------------------------------------------
  Future<List<RrhhSchedule>> listSchedules();
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule);
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule);

  // ---------------------------------------------------------------------------
  // PANTALLA 08: Permisos y Licencias Médicas
  // ---------------------------------------------------------------------------
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? status,
    String? type,
    DateTime? month,
  });
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request);
  Future<RrhhLeaveRequest> resolveLeaveRequest(
    int requestId,
    String newStatus, {
    String? resolutionNotes,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 09: Control de Vacaciones (Ley Laboral Bolivia)
  // ---------------------------------------------------------------------------
  Future<List<RrhhVacation>> listVacations();
  Future<RrhhVacation> requestVacation(RrhhVacation vacation);
  Future<RrhhVacation> approveVacation(
    int vacationId, {
    required String approvedBy,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 10: Régimen Disciplinario e Incidencias
  // ---------------------------------------------------------------------------
  Future<List<RrhhIncident>> listIncidents({
    String? severity,
    String? search,
  });
  Future<RrhhIncident> recordIncident(RrhhIncident incident);

  // ---------------------------------------------------------------------------
  // PANTALLA 11: Desvinculación & Bajas Laborales (Regla de Oro Inactivo)
  // ---------------------------------------------------------------------------
  Future<List<RrhhTermination>> listTerminations();
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime exitDate,
    required String reason,
    required String exitObservations,
    required String registeredBy,
    required double severancePay,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 12: Novedades para Nómina (Entrega a Contabilidad)
  // ---------------------------------------------------------------------------
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year);

  // ---------------------------------------------------------------------------
  // PANTALLA 13: Asistencia de Campo Consolidada (Recepción APK)
  // ---------------------------------------------------------------------------
  Future<List<OpsAttendanceSummaryDto>> listAttendanceRecords(
    DateTime date, {
    String? status,
    String? area,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 14: Bitácora de Movimientos y Auditoría
  // ---------------------------------------------------------------------------
  Future<List<RrhhMovementHistory>> listMovements({
    String? movementType,
    int? employeeId,
    int? limit,
    int? offset,
  });

  // ---------------------------------------------------------------------------
  // Servicios de soporte / Referencias externas
  // ---------------------------------------------------------------------------
  Future<List<CrmClientRefDto>> listClientReferences();
}
