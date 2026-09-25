import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/ops_attendance_summary_dto.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_employee_summary_dto.dart';
import '../models/rrhh_payroll_export_dto.dart';
import 'rrhh_mock_dataset.dart';
import 'rrhh_repository.dart';

/// Implementación Mock en memoria del repositorio de RRHH.
/// Alimenta las 14 pantallas con datos realistas según RRHH_WIREFRAMES.md.
class RrhhRepositoryMock implements RrhhRepository {
  static final RrhhRepositoryMock _instance = RrhhRepositoryMock._internal();
  factory RrhhRepositoryMock() => _instance;

  RrhhRepositoryMock._internal() {
    _reset();
  }

  @override
  bool get isMock => true;

  late List<RrhhArea> _areas;
  late List<RrhhPosition> _positions;
  late List<RrhhSpecialty> _specialties;
  late List<RrhhSchedule> _schedules;
  late List<RrhhEmployee> _employees;
  late List<RrhhApplicant> _applicants;
  late List<RrhhLeaveRequest> _leaves;
  late List<RrhhVacation> _vacations;
  late List<RrhhIncident> _incidents;
  late List<RrhhTermination> _terminations;
  late List<RrhhMovementHistory> _movements;
  late List<OpsAttendanceSummaryDto> _attendances;
  late List<CrmClientRefDto> _clientRefs;

  void _reset() {
    _areas = RrhhMockDataset.initialAreas();
    _positions = RrhhMockDataset.initialPositions();
    _specialties = RrhhMockDataset.initialSpecialties();
    _schedules = RrhhMockDataset.initialSchedules();
    _employees = RrhhMockDataset.initialEmployees();
    _applicants = RrhhMockDataset.initialApplicants();
    _attendances = RrhhMockDataset.initialAttendance();
    _clientRefs = RrhhMockDataset.initialClientRefs();
    _leaves = RrhhMockDataset.initialLeaves();
    _vacations = RrhhMockDataset.initialVacations();
    _incidents = RrhhMockDataset.initialIncidents();
    _terminations = RrhhMockDataset.initialTerminations();
    _movements = RrhhMockDataset.initialMovements();
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 01: Dashboard
  // ---------------------------------------------------------------------------
  @override
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    final active = _employees.where((e) => e.status == 'ACTIVO').length;
    final total = _employees.length;
    final field = _employees.where((e) => e.status == 'ACTIVO' && e.employeeType == 'CAMPO').length;
    final office = _employees.where((e) => e.status == 'ACTIVO' && e.employeeType == 'OFICINA').length;
    final pendingApps = _applicants.where((a) => a.status == 'NUEVO' || a.status == 'EN_EVALUACION').length;
    final selectedApps = _applicants.where((a) => a.status == 'SELECCIONADO').length;
    final completeFiles = _employees.where((e) => e.hasCiCopy && e.hasUtilityBill && e.hasHomeSketch && e.hasFelccRecord && e.hasPhoto3x4 && e.hasSusInsurance).length;
    final pct = total > 0 ? double.parse(((completeFiles / total) * 100).toStringAsFixed(1)) : 100.0;

    return RrhhDashboardMetricsResponse(
      activeEmployeesCount: active,
      totalEmployeesCount: total,
      fieldEmployeesCount: field,
      officeEmployeesCount: office,
      pendingApplicantsCount: pendingApps,
      selectedApplicantsCount: selectedApps,
      completeFilesCount: completeFiles,
      pendingFilesCount: total - completeFiles,
      expedientesPercentage: pct,
      expiringContractsCount: 2,
      activeLeavesCount: _leaves.where((l) => l.status == 'APROBADO').length,
      todayAttendanceRate: 92.0,
      todayIncidentsCount: _incidents.length,
    );
  }

  @override
  Future<List<RrhhRecentMovementDto>> getRecentMovements() async {
    return [
      RrhhRecentMovementDto(
        id: '1',
        type: 'CONTRATACION',
        title: 'Alta de Personal',
        description: 'Contratación: EMP-015 Carlos Choque Mamani',
        employeeCode: 'EMP-015',
        employeeName: 'Carlos Choque Mamani',
        workplace: 'Operaciones & Servicios',
        timestamp: DateTime(2026, 9, 24, 10, 30),
        registeredBy: 'Lic. Laura Mendoza',
      ),
      RrhhRecentMovementDto(
        id: '2',
        type: 'PERMISO',
        title: 'Licencia Médica Aprobada',
        description: 'Permiso Aprobado: EMP-003 Carlos Mamani',
        employeeCode: 'EMP-003',
        employeeName: 'Carlos Mamani',
        workplace: 'Operaciones & Servicios',
        timestamp: DateTime(2026, 9, 24, 8, 15),
        registeredBy: 'Lic. Laura Mendoza',
      ),
      RrhhRecentMovementDto(
        id: '3',
        type: 'AJUSTE_SALARIAL',
        title: 'Actualización Salarial',
        description: 'Ajuste Salarial: EMP-001 Juan Carlos Pérez',
        employeeCode: 'EMP-001',
        employeeName: 'Juan Carlos Pérez',
        workplace: 'Operaciones & Servicios',
        timestamp: DateTime(2026, 9, 23, 16, 0),
        registeredBy: 'Gerencia General',
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 02: Directorio de Personal
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    var filtered = _employees.where((e) {
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (e.status.toUpperCase() != status.toUpperCase()) return false;
      }
      if (employeeType != null && employeeType.isNotEmpty && employeeType.toUpperCase() != 'TODOS') {
        if (e.employeeType.toUpperCase() != employeeType.toUpperCase()) return false;
      }
      if (areaId != null && e.areaId != areaId) return false;
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matches = e.code.toLowerCase().contains(q) ||
            e.fullName.toLowerCase().contains(q) ||
            e.position.toLowerCase().contains(q) ||
            e.area.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();

    if (offset != null && offset < filtered.length) {
      filtered = filtered.sublist(offset);
    }
    if (limit != null && filtered.length > limit) {
      filtered = filtered.sublist(0, limit);
    }

    return filtered.map((e) {
      int docs = 0;
      if (e.hasCiCopy) docs++;
      if (e.hasUtilityBill) docs++;
      if (e.hasHomeSketch) docs++;
      if (e.hasFelccRecord) docs++;
      if (e.hasPhoto3x4) docs++;
      if (e.hasSusInsurance) docs++;

      return RrhhEmployeeSummaryDto(
        id: e.id ?? 0,
        code: e.code,
        fullName: e.fullName,
        photoUrl: e.photoUrl,
        employeeType: e.employeeType,
        area: e.area,
        position: e.position,
        specialty: e.specialty,
        workplace: e.workplace,
        status: e.status,
        availabilityStatus: e.availabilityStatus,
        realStartDate: e.realStartDate,
        attachedDocsCount: docs,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 03: Expediente 360°
  // ---------------------------------------------------------------------------
  @override
  Future<RrhhEmployee> getEmployeeById(int id) async {
    return _employees.firstWhere((e) => e.id == id, orElse: () => _employees.first);
  }

  @override
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId) async {
    final emp = await getEmployeeById(employeeId);
    final now = DateTime(2026, 9, 24);
    return [
      RrhhEmployeeDocument(id: 1, employeeId: employeeId, documentType: 'CI', title: 'Fotocopia Cédula de Identidad', fileUrl: 'https://storage/ci.pdf', fileName: 'ci_${emp.code}.pdf', isVerified: emp.hasCiCopy, createdAt: now, updatedAt: now),
      RrhhEmployeeDocument(id: 2, employeeId: employeeId, documentType: 'FELCC', title: 'Certificado Antecedentes FELCC', fileUrl: 'https://storage/felcc.pdf', fileName: 'felcc_${emp.code}.pdf', isVerified: emp.hasFelccRecord, createdAt: now, updatedAt: now),
      RrhhEmployeeDocument(id: 3, employeeId: employeeId, documentType: 'AVISO_LUZ_AGUA', title: 'Aviso de Luz / Agua', fileUrl: 'https://storage/luz.pdf', fileName: 'luz_${emp.code}.pdf', isVerified: emp.hasUtilityBill, createdAt: now, updatedAt: now),
      RrhhEmployeeDocument(id: 4, employeeId: employeeId, documentType: 'CROQUIS', title: 'Croquis Domiciliario', fileUrl: 'https://storage/croquis.pdf', fileName: 'croquis_${emp.code}.pdf', isVerified: emp.hasHomeSketch, createdAt: now, updatedAt: now),
      RrhhEmployeeDocument(id: 5, employeeId: employeeId, documentType: 'FOTO', title: 'Fotografía 3x4 Fondo Rojo', fileUrl: 'https://storage/foto.jpg', fileName: 'foto_${emp.code}.jpg', isVerified: emp.hasPhoto3x4, createdAt: now, updatedAt: now),
      RrhhEmployeeDocument(id: 6, employeeId: employeeId, documentType: 'SEGURO_SUS', title: 'Afiliación Seguro Médico SUS', fileUrl: 'https://storage/sus.pdf', fileName: 'sus_${emp.code}.pdf', isVerified: emp.hasSusInsurance, createdAt: now, updatedAt: now),
    ];
  }

  @override
  Future<List<RrhhTimelineEvent>> listTimelineEvents(int employeeId) async {
    final emp = await getEmployeeById(employeeId);
    return [
      RrhhTimelineEvent(id: 1, employeeId: employeeId, date: emp.realStartDate, title: 'Alta Institucional', description: 'Incorporación a nómina de ${emp.area}', category: 'CONTRATACION', registeredBy: 'Lic. Laura Mendoza', createdAt: emp.realStartDate),
      RrhhTimelineEvent(id: 2, employeeId: employeeId, date: DateTime(2026, 9, 23), title: 'Actualización Salarial', description: 'Ajuste contractual autorizado por Gerencia', category: 'HORARIO', registeredBy: 'Gerencia General', createdAt: DateTime(2026, 9, 23)),
    ];
  }

  @override
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId) async {
    final emp = await getEmployeeById(employeeId);
    if (emp.availabilityStatus != 'ASIGNADO') return null;
    return RrhhAssignment(
      id: 1,
      code: 'ASG-001',
      employeeId: employeeId,
      employeeCode: emp.code,
      employeeName: emp.fullName,
      assignmentType: 'CAMPO',
      customerId: 101,
      customerCompanyName: 'Kolping Bolivia',
      workplaceBranch: emp.workplace,
      contractedServiceName: 'Seguridad Física',
      officeRole: emp.position,
      supervisorName: 'Ricardo Montaño',
      scheduleId: 1,
      scheduleName: 'Operativo Mañana (07:00 - 15:00)',
      startDate: DateTime(2026, 1, 1),
      status: 'ACTIVA',
      notes: 'Supervisado por Ricardo Montaño',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 9, 24),
    );
  }

  @override
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee) async {
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _employees[index] = employee;
      return employee;
    }
    return employee;
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 04: Reclutamiento & Postulantes
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhApplicantSummaryDto>> listApplicants({String? status, String? search}) async {
    var filtered = _applicants.where((a) {
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (a.status.toUpperCase() != status.toUpperCase()) return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        if (!a.code.toLowerCase().contains(q) && !a.fullName.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    return filtered.map((a) => RrhhApplicantSummaryDto(
      id: a.id ?? 0,
      code: a.code,
      fullName: a.fullName,
      targetType: a.targetType,
      targetPosition: a.targetPosition ?? 'Operario',
      specialty: a.specialty ?? 'General',
      status: a.status,
      applicationDate: a.applicationDate,
      hasCv: a.hasCvAttached,
    )).toList();
  }

  @override
  Future<RrhhApplicant> getApplicantById(int id) async {
    return _applicants.firstWhere((a) => a.id == id, orElse: () => _applicants.first);
  }

  @override
  Future<RrhhApplicant> createApplicant(RrhhApplicant applicant) async {
    final nextId = _applicants.length + 10;
    final created = applicant.copyWith(id: nextId, code: 'POST-${nextId.toString().padLeft(3, '0')}');
    _applicants.insert(0, created);
    return created;
  }

  @override
  Future<RrhhApplicant> updateApplicantStatus(int applicantId, String newStatus, {String? notes}) async {
    final index = _applicants.indexWhere((a) => a.id == applicantId);
    if (index != -1) {
      final updated = _applicants[index].copyWith(status: newStatus, interviewNotes: notes ?? _applicants[index].interviewNotes);
      _applicants[index] = updated;
      return updated;
    }
    throw StateError('Postulante no encontrado');
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 05: Contratación Formal (Wizard)
  // ---------------------------------------------------------------------------
  @override
  Future<RrhhEmployee> hireApplicant({required int? applicantId, required RrhhEmployee employeeData}) async {
    final nextId = _employees.length + 1;
    final code = 'EMP-${nextId.toString().padLeft(3, '0')}';
    final hired = employeeData.copyWith(
      id: nextId,
      code: code,
      status: 'ACTIVO',
      availabilityStatus: 'DISPONIBLE',
      corporateEmail: '${employeeData.fullName.toLowerCase().replaceAll(' ', '.')}@elitemultiservicios.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _employees.insert(0, hired);

    if (applicantId != null) {
      final appIdx = _applicants.indexWhere((a) => a.id == applicantId);
      if (appIdx != -1) {
        _applicants[appIdx] = _applicants[appIdx].copyWith(status: 'CONTRATADO');
      }
    }
    _movements.insert(0, RrhhMovementHistory(
      id: _movements.length + 1,
      employeeId: nextId,
      employeeCode: code,
      employeeName: hired.fullName,
      movementType: 'INGRESO',
      previousValue: 'Postulante',
      newValue: 'Empleado Activo (${hired.position})',
      effectiveDate: hired.realStartDate,
      reason: 'Contratación formal concluida con éxito',
      authorizedBy: 'Lic. Laura Mendoza',
      createdAt: DateTime.now(),
    ));
    return hired;
  }

  // ---------------------------------------------------------------------------
  // Catálogos Organizacionales y Turnos
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhArea>> listAreas() async => _areas;
  @override
  Future<RrhhArea> createArea(RrhhArea area) async {
    final c = area.copyWith(id: _areas.length + 1);
    _areas.add(c);
    return c;
  }
  @override
  Future<RrhhArea> updateArea(RrhhArea area) async {
    final idx = _areas.indexWhere((a) => a.id == area.id);
    if (idx != -1) _areas[idx] = area;
    return area;
  }

  @override
  Future<List<RrhhPosition>> listPositions() async => _positions;
  @override
  Future<RrhhPosition> createPosition(RrhhPosition position) async {
    final c = position.copyWith(id: _positions.length + 1);
    _positions.add(c);
    return c;
  }
  @override
  Future<RrhhPosition> updatePosition(RrhhPosition position) async {
    final idx = _positions.indexWhere((p) => p.id == position.id);
    if (idx != -1) _positions[idx] = position;
    return position;
  }

  @override
  Future<List<RrhhSpecialty>> listSpecialties() async => _specialties;
  @override
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty) async {
    final c = specialty.copyWith(id: _specialties.length + 1);
    _specialties.add(c);
    return c;
  }
  @override
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty) async {
    final idx = _specialties.indexWhere((s) => s.id == specialty.id);
    if (idx != -1) _specialties[idx] = specialty;
    return specialty;
  }

  @override
  Future<List<RrhhSchedule>> listSchedules() async => _schedules;
  @override
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule) async {
    final c = schedule.copyWith(id: _schedules.length + 1);
    _schedules.add(c);
    return c;
  }
  @override
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule) async {
    final idx = _schedules.indexWhere((s) => s.id == schedule.id);
    if (idx != -1) _schedules[idx] = schedule;
    return schedule;
  }

  // ---------------------------------------------------------------------------
  // Permisos, Vacaciones, Incidencias y Bajas
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhLeaveRequest>> listLeaveRequests({String? status, String? type, DateTime? month}) async => _leaves;
  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    final c = request.copyWith(id: _leaves.length + 1);
    _leaves.insert(0, c);
    return c;
  }
  @override
  Future<RrhhLeaveRequest> resolveLeaveRequest(int requestId, String newStatus, {String? resolutionNotes}) async {
    final idx = _leaves.indexWhere((l) => l.id == requestId);
    if (idx != -1) {
      final updated = _leaves[idx].copyWith(status: newStatus, resolutionNotes: resolutionNotes, resolvedAt: DateTime.now());
      _leaves[idx] = updated;
      return updated;
    }
    throw StateError('Permiso no encontrado');
  }

  @override
  Future<List<RrhhVacation>> listVacations() async => _vacations;
  @override
  Future<RrhhVacation> requestVacation(RrhhVacation vacation) async {
    final c = vacation.copyWith(id: _vacations.length + 1);
    _vacations.insert(0, c);
    return c;
  }
  @override
  Future<RrhhVacation> approveVacation(int vacationId, {required String approvedBy}) async {
    final idx = _vacations.indexWhere((v) => v.id == vacationId);
    if (idx != -1) {
      final updated = _vacations[idx].copyWith(
        status: 'APROBADO',
        approvedByUserId: 1,
        approvedAt: DateTime.now(),
        notes: 'Aprobado por $approvedBy',
      );
      _vacations[idx] = updated;
      return updated;
    }
    throw StateError('Vacación no encontrada');
  }

  @override
  Future<List<RrhhIncident>> listIncidents({String? severity, String? search}) async => _incidents;
  @override
  Future<RrhhIncident> recordIncident(RrhhIncident incident) async {
    final c = incident.copyWith(id: _incidents.length + 1);
    _incidents.insert(0, c);
    return c;
  }

  @override
  Future<List<RrhhTermination>> listTerminations() async => _terminations;
  @override
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime exitDate,
    required String reason,
    required String exitObservations,
    required String registeredBy,
    required double severancePay,
  }) async {
    final empIdx = _employees.indexWhere((e) => e.id == employeeId);
    if (empIdx == -1) throw StateError('Empleado no encontrado');
    final emp = _employees[empIdx];

    // Regla de Oro: Cambiar a INACTIVO sin borrar registro
    _employees[empIdx] = emp.copyWith(
      status: 'INACTIVO',
      availabilityStatus: 'SUSPENDIDO',
      exitDate: exitDate,
      exitReason: reason,
      exitObservations: exitObservations,
      exitRegisteredBy: registeredBy,
    );

    final termination = RrhhTermination(
      id: _terminations.length + 1,
      code: 'DESV-${(_terminations.length + 1).toString().padLeft(3, '0')}',
      employeeId: employeeId,
      employeeCode: emp.code,
      employeeName: emp.fullName,
      employeeCi: emp.identityCard,
      contractType: emp.contractType,
      entryDate: emp.realStartDate,
      terminationDate: exitDate,
      lastWorkingDay: exitDate,
      reason: reason,
      detailedReason: exitObservations,
      yearsOfService: exitDate.difference(emp.realStartDate).inDays / 365.0,
      severanceAmount: severancePay,
      clearanceCompleted: true,
      createdAt: DateTime.now(),
    );
    _terminations.insert(0, termination);


    _movements.insert(0, RrhhMovementHistory(
      id: _movements.length + 1,
      employeeId: employeeId,
      employeeCode: emp.code,
      employeeName: emp.fullName,
      movementType: 'DESVINCULACION',
      previousValue: 'ACTIVO',
      newValue: 'INACTIVO ($reason)',
      effectiveDate: exitDate,
      reason: exitObservations,
      authorizedBy: registeredBy,
      createdAt: DateTime.now(),
    ));

    return termination;
  }

  // ---------------------------------------------------------------------------
  // Novedades para Nómina, Asistencia APK y Bitácora
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year) async {
    return _employees.where((e) => e.status == 'ACTIVO').map((e) {
      double bonus = 0.0;
      double ded = 0.0;
      if (e.code == 'EMP-001') bonus = 350.0;
      if (e.code == 'EMP-003') ded = 120.0;
      return RrhhPayrollExportDto(
        employeeId: e.id ?? 0,
        employeeCode: e.code,
        fullName: e.fullName,
        identityCard: e.identityCard,
        contractType: e.contractType,
        baseSalary: e.agreedSalary,
        daysWorked: 30,
        authorizedBonuses: bonus,
        authorizedDeductions: ded,
      );
    }).toList();
  }

  @override
  Future<List<OpsAttendanceSummaryDto>> listAttendanceRecords(DateTime date, {String? status, String? area}) async {
    return _attendances;
  }

  @override
  Future<List<RrhhMovementHistory>> listMovements({String? movementType, int? employeeId, int? limit, int? offset}) async {
    return _movements;
  }

  @override
  Future<List<CrmClientRefDto>> listClientReferences() async => _clientRefs;
}
