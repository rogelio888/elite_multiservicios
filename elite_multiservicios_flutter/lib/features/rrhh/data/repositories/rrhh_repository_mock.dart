import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/ops_attendance_summary_dto.dart';
import '../models/rrhh_applicant_companion.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_employee_summary_dto.dart';
import '../models/rrhh_hiring_dossier.dart';
import '../models/rrhh_payroll_export_dto.dart';
import '../models/rrhh_shift.dart';
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
  late List<RrhhShift> _shifts;
  late List<RrhhBaseSchedule> _baseSchedules;
  late List<RrhhCatalogItem> _catalogItems;
  late List<RrhhEmployee> _employees;
  late List<RrhhApplicant> _applicants;
  late Map<int, RrhhApplicantCompanion> _applicantCompanions;
  late List<RrhhHiringDossier> _dossiers;
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
    _shifts = RrhhMockDataset.initialShifts();
    _baseSchedules = RrhhMockDataset.initialBaseSchedules();
    _catalogItems = RrhhMockDataset.initialCatalogItems();
    _employees = RrhhMockDataset.initialEmployees();
    _applicants = RrhhMockDataset.initialApplicants();
    _applicantCompanions = _buildInitialCompanions();
    _attendances = RrhhMockDataset.initialAttendance();
    _clientRefs = RrhhMockDataset.initialClientRefs();
    _leaves = RrhhMockDataset.initialLeaves();
    _vacations = RrhhMockDataset.initialVacations();
    _incidents = RrhhMockDataset.initialIncidents();
    _terminations = RrhhMockDataset.initialTerminations();
    _movements = RrhhMockDataset.initialMovements();
    _dossiers = _buildInitialDossiers();
  }

  List<RrhhHiringDossier> _buildInitialDossiers() {
    final list = <RrhhHiringDossier>[];
    for (final a in _applicants) {
      if (a.status == 'SELECCIONADO') {
        final checklist = RrhhDossierDocument.defaultChecklistFor(
          workplaceType: a.targetType,
          targetPosition: a.targetPosition ?? 'Operario',
        );
        list.add(
          RrhhHiringDossier(
            id: list.length + 1,
            applicantId: a.id ?? 0,
            applicantCode: a.code,
            applicantName: a.fullName,
            applicantCi: a.identityCard,
            applicantPhone: a.phone,
            applicantEmail: a.email,
            targetArea: a.targetArea ?? 'General',
            targetPosition: a.targetPosition ?? 'Operario',
            workplaceType: a.targetType,
            applicationDate: a.applicationDate,
            createdAt: a.createdAt,
            status: 'abierto',
            section1Status: 'pendiente',
            documents: checklist,
          ),
        );
      }
    }
    // ── Postulante extra de prueba con Secciones 2-3 ya completas ──
    final extraId = list.length + 1;
    final extraChecklist = RrhhDossierDocument.defaultChecklistFor(
      workplaceType: 'OFICINA',
      targetPosition: 'Analista Administrativo',
    );
    list.add(
      RrhhHiringDossier(
        id: extraId,
        applicantId: 999,
        applicantCode: 'POST-015',
        applicantName: 'Carla Reyes Torrez',
        applicantCi: '9123456 SC',
        applicantPhone: '76543210',
        applicantEmail: 'carla.reyes@gmail.com',
        targetArea: 'Administración',
        targetPosition: 'Analista Administrativo',
        workplaceType: 'OFICINA',
        applicationDate: DateTime(2026, 9, 10),
        createdAt: DateTime(2026, 9, 15),
        status: 'abierto',
        section1Status: 'completa',
        section2Status: 'completa',
        section3Status: 'completa',
        documents: extraChecklist,
        afpId: 'AFP-001',
        afpName: 'Gestora Pública de la Seguridad Social de Largo Plazo',
        afpNumber: 'GP-9123456',
        healthInsuranceId: 'SEGURO-001',
        healthInsuranceName: 'Caja Nacional de Salud (CNS)',
        section2Notes: 'Afiliación verificada el 15/09/2026',
        fullAddress: 'Barrio Equipetrol, Av. San Martín #1540, Santa Cruz',
        maritalStatus: 'Casado',
        childrenCount: 2,
        emergencyContactName: 'Roberto Reyes',
        emergencyContactPhone: '71234567',
        emergencyContactRelation: 'Padre',
      ),
    );

    // ── Postulante de prueba con Secciones 1 a 5 ya completas (5/6 Listo para convertir) ──
    final listoId = list.length + 1;
    final listoChecklist = RrhhDossierDocument.defaultChecklistFor(
      workplaceType: 'CAMPO',
      targetPosition: 'Supervisor de Operaciones',
    );
    list.add(
      RrhhHiringDossier(
        id: listoId,
        applicantId: 998,
        applicantCode: 'POST-016',
        applicantName: 'Daniela Morales Ramos',
        applicantCi: '8345129 SC',
        applicantPhone: '70012345',
        applicantEmail: 'daniela.morales@gmail.com',
        targetArea: 'Operaciones',
        targetPosition: 'Supervisor de Operaciones',
        workplaceType: 'CAMPO',
        applicationDate: DateTime(2026, 9, 8),
        createdAt: DateTime(2026, 9, 12),
        status: 'abierto',
        section1Status: 'completa',
        section2Status: 'completa',
        section3Status: 'completa',
        section4Status: 'completa',
        section5Status: 'completa',
        documents: listoChecklist,
        afpId: 'AFP-001',
        afpName: 'Gestora Pública de la Seguridad Social de Largo Plazo',
        afpNumber: 'GP-8345129',
        healthInsuranceId: 'SEGURO-001',
        healthInsuranceName: 'Caja Nacional de Salud (CNS)',
        section2Notes: 'Afiliación verificada',
        fullAddress: 'Av. Banzer 4to Anillo, Condominio Sevilla Real #45',
        maritalStatus: 'Soltero',
        childrenCount: 1,
        emergencyContactName: 'Carlos Morales',
        emergencyContactPhone: '72345678',
        emergencyContactRelation: 'Hermano',
        contractTypeId: 'CONT-IND',
        contractTypeName: 'Indefinido',
        workdayType: 'Completa',
        paymentModalityId: 'MOD-MEN',
        paymentModalityName: 'Mensual',
        baseSalary: 4500.0,
        currency: 'BOB',
        contractStartDate: DateTime(2026, 10, 1),
        bonuses: [
          RrhhEmployeeBonus(
            code: 'BONO-PUNTUALIDAD',
            name: 'Bono de Puntualidad y Asistencia',
            amount: 250.0,
            type: 'MENSUAL',
          ),
          RrhhEmployeeBonus(
            code: 'BONO-TRANSPORTE',
            name: 'Bono de Transporte / Movilidad',
            amount: 300.0,
            type: 'MENSUAL',
          ),
        ],
        deductions: [],
        areaId: 'AREA-001',
        areaName: 'Operaciones',
        positionId: 'POS-002',
        positionName: 'Supervisor de Operaciones',
        shiftId: 'T-01',
        shiftName: 'Turno Mañana (07:00 - 15:00)',
        scheduleId: 'SCH-01',
        scheduleName: 'Lunes a Viernes',
        baseLocation: 'Puesto Campo / Clientes',
        supervisorEmployeeId: 'EMP-001',
        supervisorName: 'Lic. Laura Mendoza (Jefatura RRHH)',
        effectiveStartDate: DateTime(2026, 10, 1),
      ),
    );
    return list;
  }

  Map<int, RrhhApplicantCompanion> _buildInitialCompanions() {
    final now = DateTime(2026, 9, 24);
    return {
      // POST-012: NUEVO (CAMPO)
      12: RrhhApplicantCompanion(
        applicantId: 12,
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'REGISTRO',
            toStatus: 'NUEVO',
            timestamp: now.subtract(const Duration(days: 1)),
            author: 'Lic. Laura Mendoza',
            notes: 'Postulación recibida en recepción',
          ),
        ],
      ),
      // POST-016: EN_REVISION (CAMPO)
      16: RrhhApplicantCompanion(
        applicantId: 16,
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'REGISTRO',
            toStatus: 'NUEVO',
            timestamp: now.subtract(const Duration(days: 3)),
            author: 'Lic. Laura Mendoza',
            notes: 'Postulación en línea',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'NUEVO',
            toStatus: 'EN_REVISION',
            timestamp: now.subtract(const Duration(days: 2)),
            author: 'Lic. Laura Mendoza',
            notes: 'Pasa a validación de antecedentes y libreta militar',
          ),
        ],
      ),
      // POST-015: ENTREVISTA (OFICINA)
      15: RrhhApplicantCompanion(
        applicantId: 15,
        evaluation: const RrhhApplicantEvaluation(
          educationLevel: 'Licenciatura',
          professionalTitle: 'Lic. en Administración de Empresas',
          experienceSummary: '3 años como asistente contable y compras',
          technicalSkills: ['Excel Avanzado', 'ERP', 'Facturación SIAT', 'Redacción'],
          personalReferenceName: 'Lic. Mariana Soto',
          personalReferencePhone: '73344556',
          workReferenceName: 'Lic. Carlos Quiroga',
          workReferencePhone: '71122334',
          salaryExpectation: 3500.0,
        ),
        interviewRecord: RrhhInterviewRecord(
          dateTime: now.subtract(const Duration(hours: 4)),
          interviewers: ['Encargada de RRHH', 'Dueño'],
          modality: 'Presencial',
          notes: 'Manejo impecable de SIAT y conciliaciones bancarias.',
          result: 'Apto',
        ),
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'REGISTRO',
            toStatus: 'NUEVO',
            timestamp: now.subtract(const Duration(days: 4)),
            author: 'Lic. Laura Mendoza',
            notes: 'Recepción de CV',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'NUEVO',
            toStatus: 'EN_REVISION',
            timestamp: now.subtract(const Duration(days: 3)),
            author: 'Lic. Laura Mendoza',
            notes: 'Requisitos académicos verificados',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'EN_REVISION',
            toStatus: 'ENTREVISTA',
            timestamp: now.subtract(const Duration(days: 1)),
            author: 'Lic. Laura Mendoza',
            notes: 'Convocada a entrevista presencial',
          ),
        ],
      ),
      // POST-017: PRUEBAS (CAMPO)
      17: RrhhApplicantCompanion(
        applicantId: 17,
        evaluation: const RrhhApplicantEvaluation(
          education: 'Técnico Medio Industrial',
          experienceSummary: '4 años en fábricas y plantas agroindustriales',
          technicalSkills: ['Hidrolavadoras', 'Trabajo en altura', 'Químicos de planta'],
          personalReferenceName: 'Ing. Mateo Vargas',
          personalReferencePhone: '74455667',
          workReferenceName: 'Lic. Roberto Paz',
          workReferencePhone: '78899001',
          rotatingShiftsAvailable: true,
          clientBranchesAvailable: true,
          physicalFitnessDeclared: true,
        ),
        interviewRecord: RrhhInterviewRecord(
          dateTime: now.subtract(const Duration(days: 2)),
          interviewers: ['Encargada de RRHH'],
          modality: 'Presencial',
          notes: 'Experiencia operativa comprobada. Se deriva a prueba técnica de maquinaria.',
          result: 'Apto',
        ),
        documents: const RrhhApplicantDocumentsChecklist(
          hasCiCopy: true,
          hasUtilityBill: true,
          hasHomeSketch: true,
          hasPhoto3x4: true,
          hasSus: false,
          hasFelcc: true,
        ),
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'EN_REVISION',
            toStatus: 'ENTREVISTA',
            timestamp: now.subtract(const Duration(days: 3)),
            author: 'Lic. Laura Mendoza',
            notes: 'Perfil operativo calificado',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'ENTREVISTA',
            toStatus: 'PRUEBAS',
            timestamp: now.subtract(const Duration(days: 1)),
            author: 'Lic. Laura Mendoza',
            notes: 'Aprobó entrevista. Derivado a prueba de hidrolavado.',
          ),
        ],
      ),
      // POST-014: SELECCIONADO (CAMPO) - Listo para contratación
      14: RrhhApplicantCompanion(
        applicantId: 14,
        evaluation: const RrhhApplicantEvaluation(
          education: 'Bachiller - Libreta Militar',
          experienceSummary: '3 años en custodia corporativa en Torre Duo y Manzana 40',
          technicalSkills: ['Defensa personal', 'Primeros auxilios', 'Libro de novedades'],
          personalReferenceName: 'Rosa Soto (Madre)',
          personalReferencePhone: '79900112',
          workReferenceName: 'Cap. Jorge Roca',
          workReferencePhone: '72233445',
          rotatingShiftsAvailable: true,
          clientBranchesAvailable: true,
          drivingLicense: 'Cat. A (Motocicleta)',
          physicalFitnessDeclared: true,
        ),
        interviewRecord: RrhhInterviewRecord(
          dateTime: now.subtract(const Duration(days: 5)),
          interviewers: ['Dueño', 'Encargada de RRHH'],
          modality: 'Presencial',
          notes: 'Excelente porte y disciplina. Referencias laborales impecables.',
          result: 'Apto',
        ),
        documents: const RrhhApplicantDocumentsChecklist(
          hasCiCopy: true,
          hasUtilityBill: true,
          hasHomeSketch: true,
          hasPhoto3x4: true,
          hasSus: true,
          hasFelcc: true,
        ),
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'ENTREVISTA',
            toStatus: 'PRUEBAS',
            timestamp: now.subtract(const Duration(days: 4)),
            author: 'Lic. Laura Mendoza',
            notes: 'Prueba de reflejos y tiro superada',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'PRUEBAS',
            toStatus: 'SELECCIONADO',
            timestamp: now.subtract(const Duration(days: 2)),
            author: 'Lic. Laura Mendoza',
            notes: 'Aprobado por Gerencia. Documentación completa. Listo para contratar.',
          ),
        ],
      ),
      // POST-010: RECHAZADO
      10: RrhhApplicantCompanion(
        applicantId: 10,
        isEligibleForRehire: true,
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'EN_REVISION',
            toStatus: 'RECHAZADO',
            timestamp: now.subtract(const Duration(days: 7)),
            author: 'Lic. Laura Mendoza',
            notes: 'No presentó certificado de antecedentes FELCC dentro del plazo establecido.',
          ),
        ],
      ),
    };
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
  // FASE B: Actualizaciones de secciones del Expediente de Contratación
  // ---------------------------------------------------------------------------
  @override
  Future<RrhhEmployee> updateEmployeeBankInfo(
    int id, {
    String? bankName,
    String? accountType,
    String? accountNumber,
  }) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(
      bankName: bankName,
      accountType: accountType,
      accountNumber: accountNumber,
    );
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployee> updateEmployeeSocialSecurity(
    int id, {
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  }) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(
      afpName: afpName,
      afpNumber: afpNumber,
      healthInsurance: healthInsurance,
    );
    return updateEmployee(updated);
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
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(
      fullAddress: fullAddress,
      maritalStatus: maritalStatus,
      childrenCount: childrenCount,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
    );
    return updateEmployee(updated);
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
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(
      contractType: contractType ?? emp.contractType,
      paymentModality: paymentModality ?? emp.paymentModality,
      workdayType: workdayType,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      contractSignedPdfUrl: contractSignedPdfUrl,
    );
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployee> updateEmployeeBonuses(
    int id,
    List<RrhhEmployeeBonus> bonuses,
  ) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(bonuses: bonuses);
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployee> updateEmployeeDeductions(
    int id,
    List<RrhhEmployeeDeduction> deductions,
  ) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(deductions: deductions);
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployee> updateEmployeeAssignment(
    int id, {
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  }) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(
      shiftId: shiftId,
      baseLocation: baseLocation,
      supervisorEmployeeId: supervisorEmployeeId,
    );
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployee> updateEmployeeDocuments(
    int id,
    Map<String, String> documentChecklist,
  ) async {
    final emp = await getEmployeeById(id);
    final updated = emp.copyWith(documentChecklist: documentChecklist);
    return updateEmployee(updated);
  }

  @override
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id) async {
    final emp = await getEmployeeById(id);
    return RrhhEmployeeContractData(
      employeeId: emp.id ?? id,
      code: emp.code,
      fullName: emp.fullName,
      status: emp.status,
      contractType: emp.contractType,
      baseSalary: emp.agreedSalary,
      paymentModality: emp.paymentModality,
      bonuses: emp.bonuses,
      deductions: emp.deductions,
      contractStartDate: emp.contractStartDate ?? emp.realStartDate,
      terminationDate: emp.exitDate,
    );
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 04: Reclutamiento & Postulantes
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhApplicantSummaryDto>> listApplicants({String? status, String? search}) async {
    var filtered = _applicants.where((a) {
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (a.status.toUpperCase() != status.toUpperCase()) return false;
      } else {
        // Por defecto, en la vista principal o TODOS, no mostrar los ya CONTRATADOS
        if (a.status == 'CONTRATADO') return false;
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
  Future<RrhhApplicantCompanion> getApplicantCompanion(int applicantId) async {
    return _applicantCompanions.putIfAbsent(
      applicantId,
      () => RrhhApplicantCompanion(
        applicantId: applicantId,
        history: [
          RrhhStatusHistoryEntry(
            fromStatus: 'INICIO',
            toStatus: _applicants.firstWhere((a) => a.id == applicantId, orElse: () => _applicants.first).status,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            author: 'Lic. Laura Mendoza',
            notes: 'Registro inicial de postulación',
          ),
        ],
      ),
    );
  }

  @override
  Future<void> saveApplicantCompanion(int applicantId, RrhhApplicantCompanion companion) async {
    _applicantCompanions[applicantId] = companion;
  }

  @override
  Future<List<RrhhApplicant>> findApplicantsByCi(String identityCard) async {
    final cleanInput = identityCard.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
    if (cleanInput.isEmpty) return [];
    return _applicants.where((a) {
      final existing = a.identityCard.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
      return existing == cleanInput || existing.startsWith(cleanInput) || cleanInput.startsWith(existing);
    }).toList();
  }

  @override
  Future<RrhhApplicant> createApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
  }) async {
    final nextId = _applicants.length + 20;
    final created = applicant.copyWith(
      id: nextId,
      code: 'POST-${nextId.toString().padLeft(3, '0')}',
      status: 'NUEVO',
    );
    _applicants.insert(0, created);

    final comp = (companion ?? RrhhApplicantCompanion(applicantId: nextId)).copyWith(
      applicantId: nextId,
      history: [
        RrhhStatusHistoryEntry(
          fromStatus: 'REGISTRO',
          toStatus: 'NUEVO',
          timestamp: DateTime.now(),
          author: 'Lic. Laura Mendoza',
          notes: 'Postulante registrado en Fase 1',
        ),
      ],
    );
    _applicantCompanions[nextId] = comp;
    return created;
  }

  @override
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  }) async {
    final index = _applicants.indexWhere((a) => a.id == applicantId);
    if (index != -1) {
      final old = _applicants[index];
      final updated = old.copyWith(
        status: newStatus,
        interviewNotes: notes ?? old.interviewNotes,
        discardReason: discardReason ?? old.discardReason,
      );
      _applicants[index] = updated;

      // Actualizar trazabilidad en el companion
      final currentComp = await getApplicantCompanion(applicantId);
      final newHistory = List<RrhhStatusHistoryEntry>.from(currentComp.history)
        ..add(RrhhStatusHistoryEntry(
          fromStatus: old.status,
          toStatus: newStatus,
          timestamp: DateTime.now(),
          author: 'Lic. Laura Mendoza',
          notes: discardReason ?? notes ?? 'Transición de etapa',
        ));
      _applicantCompanions[applicantId] = currentComp.copyWith(
        history: newHistory,
        isEligibleForRehire: isEligibleForRehire ?? currentComp.isEligibleForRehire,
      );

      if (newStatus == 'SELECCIONADO') {
        await createDossierForApplicant(applicantId);
      }

      return updated;
    }
    throw StateError('Postulante no encontrado');
  }

  @override
  Future<void> addInterviewRecord(
    int applicantId,
    RrhhInterviewRecord record,
  ) async {
    final currentComp = await getApplicantCompanion(applicantId);
    _applicantCompanions[applicantId] = currentComp.copyWith(
      interviewRecord: record,
    );
    final index = _applicants.indexWhere((a) => a.id == applicantId);
    if (index != -1) {
      _applicants[index] = _applicants[index].copyWith(
        interviewNotes: 'Entrevista (${record.modality}) [${record.result}]: ${record.notes}',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 05: Contratación Formal & Expedientes de Contratación (FASE C)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhHiringDossier>> listActiveDossiers() async {
    return _dossiers.where((d) => d.status != 'cerrado').toList();
  }

  @override
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId) async {
    try {
      return _dossiers.firstWhere((d) => d.applicantId == applicantId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhHiringDossier?> getDossierById(int id) async {
    try {
      return _dossiers.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhHiringDossier> createDossierForApplicant(int applicantId) async {
    final existing = await getDossierByApplicantId(applicantId);
    if (existing != null) return existing;

    final applicant = await getApplicantById(applicantId);
    final nextId = _dossiers.isEmpty
        ? 1
        : (_dossiers.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1);

    final checklist = RrhhDossierDocument.defaultChecklistFor(
      workplaceType: applicant.targetType,
      targetPosition: applicant.targetPosition ?? 'Operario',
    );

    final dossier = RrhhHiringDossier(
      id: nextId,
      applicantId: applicant.id ?? applicantId,
      applicantCode: applicant.code,
      applicantName: applicant.fullName,
      applicantCi: applicant.identityCard,
      applicantPhone: applicant.phone,
      applicantEmail: applicant.email,
      targetArea: applicant.targetArea ?? 'General',
      targetPosition: applicant.targetPosition ?? 'Operario',
      workplaceType: applicant.targetType,
      applicationDate: applicant.applicationDate,
      createdAt: DateTime.now(),
      status: 'abierto',
      section1Status: 'pendiente',
      documents: checklist,
    );

    _dossiers.insert(0, dossier);

    final currentComp = await getApplicantCompanion(applicantId);
    final newHistory = List<RrhhStatusHistoryEntry>.from(currentComp.history)
      ..add(RrhhStatusHistoryEntry(
        fromStatus: applicant.status,
        toStatus: 'SELECCIONADO',
        timestamp: DateTime.now(),
        author: 'Sistema RRHH',
        notes: 'Expediente de contratación creado',
      ));
    _applicantCompanions[applicantId] = currentComp.copyWith(history: newHistory);

    return dossier;
  }

  @override
  Future<RrhhHiringDossier> updateDossierSection1(
    int id,
    Map<String, RrhhDossierDocument> documents,
  ) async {
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');

    final current = _dossiers[index];
    final requiredDocs = documents.values.where((d) => d.isRequired);
    final allRequiredOk = requiredDocs.isNotEmpty &&
        requiredDocs.every((d) => d.status == 'validado');
    final hasAnyProgress =
        documents.values.any((d) => d.status != 'pendiente');

    final String sec1Status = allRequiredOk
        ? 'completa'
        : (hasAnyProgress ? 'en_proceso' : 'pendiente');

    final updated = current.copyWith(
      documents: documents,
      section1Status: sec1Status,
    );
    _dossiers[index] = updated;
    return updated;
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
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');

    final updated = _dossiers[index].copyWith(
      afpId: afpId,
      afpName: afpName,
      afpNumber: afpNumber,
      healthInsuranceId: healthInsuranceId,
      healthInsuranceName: healthInsuranceName,
      section2Notes: section2Notes,
      section2Status: sectionStatus,
    );
    _dossiers[index] = updated;
    return updated;
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
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');

    final updated = _dossiers[index].copyWith(
      fullAddress: fullAddress,
      maritalStatus: maritalStatus,
      childrenCount: childrenCount,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      section3Status: sectionStatus,
    );
    _dossiers[index] = updated;
    return updated;
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
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');

    final updated = _dossiers[index].copyWith(
      contractTypeId: contractTypeId,
      contractTypeName: contractTypeName,
      workdayType: workdayType,
      paymentModalityId: paymentModalityId,
      paymentModalityName: paymentModalityName,
      baseSalary: baseSalary,
      currency: currency,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      bonuses: bonuses,
      deductions: deductions,
      section4Status: sectionStatus,
    );
    _dossiers[index] = updated;
    return updated;
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
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');

    final updated = _dossiers[index].copyWith(
      areaId: areaId,
      areaName: areaName,
      positionId: positionId,
      positionName: positionName,
      shiftId: shiftId,
      shiftName: shiftName,
      scheduleId: scheduleId,
      scheduleName: scheduleName,
      baseLocation: baseLocation,
      supervisorEmployeeId: supervisorEmployeeId,
      supervisorName: supervisorName,
      effectiveStartDate: effectiveStartDate,
      section5Status: sectionStatus,
    );
    _dossiers[index] = updated;
    return updated;
  }

  @override
  Future<RrhhHiringDossier> updateDossierStatus(int id, String status) async {
    final index = _dossiers.indexWhere((d) => d.id == id);
    if (index == -1) throw StateError('Expediente no encontrado');
    final updated = _dossiers[index].copyWith(status: status);
    _dossiers[index] = updated;
    return updated;
  }

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
        final currentComp = await getApplicantCompanion(applicantId);
        final newHistory = List<RrhhStatusHistoryEntry>.from(currentComp.history)
          ..add(RrhhStatusHistoryEntry(
            fromStatus: 'SELECCIONADO',
            toStatus: 'CONTRATADO',
            timestamp: DateTime.now(),
            author: 'Lic. Laura Mendoza',
            notes: 'Contratación formal concluida: asignado código $code',
          ));
        _applicantCompanions[applicantId] = currentComp.copyWith(history: newHistory);
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
  Future<List<RrhhShift>> listShifts() async => _shifts;
  @override
  Future<RrhhShift> createShift(RrhhShift shift) async {
    final nextId = _shifts.isEmpty ? 1 : (_shifts.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1);
    final c = shift.copyWith(id: nextId);
    _shifts.add(c);
    return c;
  }
  @override
  Future<RrhhShift> updateShift(RrhhShift shift) async {
    final idx = _shifts.indexWhere((s) => s.id == shift.id);
    if (idx != -1) _shifts[idx] = shift;
    return shift;
  }

  @override
  Future<List<RrhhBaseSchedule>> listBaseSchedules() async => _baseSchedules;
  @override
  Future<RrhhBaseSchedule> createBaseSchedule(RrhhBaseSchedule schedule) async {
    final nextId = _baseSchedules.isEmpty ? 1 : (_baseSchedules.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1);
    final c = schedule.copyWith(id: nextId);
    _baseSchedules.add(c);
    return c;
  }
  @override
  Future<RrhhBaseSchedule> updateBaseSchedule(RrhhBaseSchedule schedule) async {
    final idx = _baseSchedules.indexWhere((s) => s.id == schedule.id);
    if (idx != -1) _baseSchedules[idx] = schedule;
    return schedule;
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

  @override
  Future<List<RrhhCatalogItem>> listCatalogItems(RrhhCatalogType type) async {
    return _catalogItems.where((c) => c.catalogType == type).toList();
  }
  @override
  Future<RrhhCatalogItem> createCatalogItem(RrhhCatalogItem item) async {
    final nextId = _catalogItems.isEmpty ? 1 : (_catalogItems.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1);
    final c = item.copyWith(id: nextId);
    _catalogItems.add(c);
    return c;
  }
  @override
  Future<RrhhCatalogItem> updateCatalogItem(RrhhCatalogItem item) async {
    final idx = _catalogItems.indexWhere((c) => c.id == item.id);
    if (idx != -1) _catalogItems[idx] = item;
    return item;
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
