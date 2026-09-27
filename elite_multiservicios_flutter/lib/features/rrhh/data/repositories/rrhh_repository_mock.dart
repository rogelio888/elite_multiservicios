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
  late List<RrhhVacationRecord> _vacationRecords;
  late List<RrhhVacation> _vacations;
  late List<RrhhDisciplinaryRecord> _disciplinaryRecords;
  late List<RrhhIncident> _incidents;
  late List<RrhhTerminationRecord> _terminationRecords;
  late List<RrhhTermination> _terminations;
  late List<RrhhPayrollPeriod> _payrollPeriods;
  late List<RrhhPayrollItem> _payrollItems;
  late List<RrhhMovementHistory> _movements;
  late List<RrhhAttendanceRecord> _attendanceRecords;
  late List<CrmClientRefDto> _clientRefs;
  late List<RrhhTimelineEvent> _timelineEvents;

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
    _attendanceRecords = RrhhMockDataset.initialAttendanceRecords();
    _clientRefs = RrhhMockDataset.initialClientRefs();
    _leaves = RrhhMockDataset.initialLeaves();
    _vacationRecords = RrhhMockDataset.initialVacationRecords();
    _vacations = RrhhMockDataset.initialVacations();
    _disciplinaryRecords = RrhhMockDataset.initialDisciplinaryRecords();
    _incidents = RrhhMockDataset.initialIncidents();
    _terminationRecords = RrhhMockDataset.initialTerminationRecords();
    _terminations = RrhhMockDataset.initialTerminations();
    _payrollPeriods = RrhhMockDataset.initialPayrollPeriods();
    _payrollItems = RrhhMockDataset.initialPayrollItems();
    _movements = RrhhMockDataset.initialMovements();
    _timelineEvents = RrhhMockDataset.initialTimelineEvents();
    _dossiers = _buildInitialDossiers();

    // Sincronizar empleado de BAJA-001 (Fernando Roca, id: 18) a estado BAJA
    final rocaIdx = _employees.indexWhere((e) => e.id == 18);
    if (rocaIdx != -1) {
      _employees[rocaIdx] = _employees[rocaIdx].copyWith(
        status: 'BAJA',
        availabilityStatus: 'INACTIVO',
        exitDate: DateTime(2026, 9, 10),
        exitReason: 'Renuncia voluntaria',
        exitObservations: 'Finiquito liquidado y firmado en Ministerio de Trabajo',
        exitRegisteredBy: 'Lic. Laura Mendoza',
      );
    }
  }

  List<RrhhHiringDossier> _buildInitialDossiers() {
    final list = <RrhhHiringDossier>[];
    for (final a in _applicants) {
      if (a.status == 'SELECCIONADO' && a.code != 'POST-016') {
        final comp = _applicantCompanions[a.id];
        final validatedDocsMap = <String, bool>{};
        if (comp?.documents != null) {
          if (comp!.documents.hasCiCopy) validatedDocsMap['CI'] = true;
          if (comp.documents.hasUtilityBill) validatedDocsMap['AVISO'] = true;
          if (comp.documents.hasHomeSketch) validatedDocsMap['CROQUIS'] = true;
          if (comp.documents.hasPhoto3x4) validatedDocsMap['FOTO'] = true;
          if (comp.documents.hasSus) validatedDocsMap['SUS'] = true;
          if (comp.documents.hasFelcc) validatedDocsMap['FELCC'] = true;
        }

        final checklist = RrhhDossierDocument.defaultChecklistFor(
          workplaceType: a.targetType,
          targetPosition: a.targetPosition ?? 'Operario',
          recruitmentValidatedDocs: validatedDocsMap,
        );

        const String sec1Status = 'pendiente';

        // Match area and position from catalogs if possible
        String? matchedAreaId;
        String? matchedAreaName = a.targetArea;
        for (final area in _areas) {
          if (area.name.toLowerCase().contains((a.targetArea ?? '').toLowerCase()) ||
              (a.targetArea ?? '').toLowerCase().contains(area.name.toLowerCase())) {
            matchedAreaId = area.id?.toString();
            matchedAreaName = area.name;
            break;
          }
        }
        if (matchedAreaId == null && _areas.isNotEmpty) {
          matchedAreaId = _areas.first.id?.toString();
          matchedAreaName ??= _areas.first.name;
        }

        String? matchedPosId;
        String? matchedPosName = a.targetPosition;
        for (final pos in _positions) {
          if (pos.name.toLowerCase().contains((a.targetPosition ?? '').toLowerCase()) ||
              (a.targetPosition ?? '').toLowerCase().contains(pos.name.toLowerCase())) {
            matchedPosId = pos.id?.toString();
            matchedPosName = pos.name;
            break;
          }
        }
        if (matchedPosId == null && _positions.isNotEmpty) {
          matchedPosId = _positions.first.id?.toString();
          matchedPosName ??= _positions.first.name;
        }

        final emergName = comp?.evaluation.personalReferenceName ??
            a.referencePerson ??
            a.emergencyContact;
        final emergPhone = comp?.evaluation.personalReferencePhone ??
            a.referencePhone ??
            a.emergencyPhone;
        final expectedSal = comp?.evaluation.salaryExpectation ??
            (a.expectedSalary != null && a.expectedSalary! > 0
                ? a.expectedSalary
                : null);

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
            section1Status: sec1Status,
            preloadedFromApplicant: true,
            documents: checklist,
            fullAddress: (a.address != null && a.address!.isNotEmpty) ? a.address : null,
            emergencyContactName: emergName,
            emergencyContactPhone: emergPhone,
            applicantExpectedSalary: expectedSal,
            areaId: matchedAreaId,
            areaName: matchedAreaName,
            positionId: matchedPosId,
            positionName: matchedPosName,
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
    final rawListoChecklist = RrhhDossierDocument.defaultChecklistFor(
      workplaceType: 'CAMPO',
      targetPosition: 'Supervisor de Operaciones',
    );
    final listoChecklist = rawListoChecklist.map((key, doc) => MapEntry(
          key,
          doc.copyWith(
            status: 'validado',
            receivedAt: DateTime(2026, 9, 10),
            scannedFileUrl:
                'https://storage.elitemultiservicios.com/expedientes/post_016_${key.toLowerCase()}.pdf',
          ),
        ));
    list.add(
      RrhhHiringDossier(
        id: listoId,
        applicantId: 16,
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
          hasCiCopy: false,
          hasUtilityBill: true,
          hasHomeSketch: true,
          hasPhoto3x4: false,
          hasSus: false,
          hasFelcc: false,
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
      // POST-026: SELECCIONADO (CAMPO) - Rogelio Arandia Arandia
      26: RrhhApplicantCompanion(
        applicantId: 26,
        evaluation: const RrhhApplicantEvaluation(
          education: 'Bachiller en Humanidades - Libreta Militar',
          experienceSummary: '4 años en seguridad privada y custodia de condominios',
          technicalSkills: ['Defensa personal', 'Primeros auxilios', 'Control de accesos'],
          personalReferenceName: 'brigida',
          personalReferencePhone: '7712345',
          workReferenceName: 'Lic. Marco Justiniano',
          workReferencePhone: '71199882',
          rotatingShiftsAvailable: true,
          clientBranchesAvailable: true,
          physicalFitnessDeclared: true,
          salaryExpectation: 3600.0,
        ),
        interviewRecord: RrhhInterviewRecord(
          dateTime: now.subtract(const Duration(days: 4)),
          interviewers: ['Encargada de RRHH', 'Dueño'],
          modality: 'Presencial',
          notes: 'Entrevista satisfactoria. Documentación y referencias comprobadas.',
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
            timestamp: now.subtract(const Duration(days: 3)),
            author: 'Lic. Laura Mendoza',
            notes: 'Prueba práctica de rondas y libro de control superada',
          ),
          RrhhStatusHistoryEntry(
            fromStatus: 'PRUEBAS',
            toStatus: 'SELECCIONADO',
            timestamp: now.subtract(const Duration(days: 1)),
            author: 'Lic. Laura Mendoza',
            notes: 'Fases 1, 2 y 3 completadas. Derivado a Expediente de Contratación.',
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
  Future<List<RrhhTimelineEvent>> listTimelineEvents({
    int? employeeId,
    String? category,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? user,
  }) async {
    await Future.delayed(const Duration(milliseconds: 30));
    final result = _timelineEvents.where((e) {
      if (employeeId != null && e.employeeId != employeeId) return false;
      if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'todas') {
        if (e.category.toLowerCase() != category.toLowerCase()) return false;
      }
      if (user != null && user.isNotEmpty && user.toLowerCase() != 'todos') {
        if (e.registeredBy.toLowerCase() != user.toLowerCase()) return false;
      }
      if (startDate != null && e.date.isBefore(startDate)) return false;
      if (endDate != null) {
        final inclusiveEnd =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        if (e.date.isAfter(inclusiveEnd)) return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matchCode =
            'EVT-${(e.id ?? 0).toString().padLeft(6, '0')}'.toLowerCase().contains(q);
        final matchTitle = e.title.toLowerCase().contains(q);
        final matchDesc = e.description.toLowerCase().contains(q);
        final matchUser = e.registeredBy.toLowerCase().contains(q);
        final matchEmpName = (e.employeeName ?? '').toLowerCase().contains(q);
        final matchEmpCode = (e.employeeCode ?? '').toLowerCase().contains(q);
        final matchSource = (e.sourceCode ?? '').toLowerCase().contains(q);
        if (!matchCode &&
            !matchTitle &&
            !matchDesc &&
            !matchUser &&
            !matchEmpName &&
            !matchEmpCode &&
            !matchSource) {
          return false;
        }
      }
      return true;
    }).toList();
    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  @override
  Future<RrhhTimelineEvent?> getTimelineEventById(int id) async {
    await Future.delayed(const Duration(milliseconds: 20));
    try {
      return _timelineEvents.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<String> listTimelineCategories() {
    return RrhhTimelineCategory.all;
  }

  @override
  List<String> listActiveUsers() {
    final users = _timelineEvents.map((e) => e.registeredBy).toSet().toList();
    users.sort();
    return users;
  }

  @override
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event) async {
    final nextId = _timelineEvents.isEmpty
        ? 1
        : _timelineEvents.map((e) => (e.id ?? 0)).reduce((a, b) => a > b ? a : b) + 1;
    final saved = event.copyWith(id: nextId);
    _timelineEvents.insert(0, saved);
    return saved;
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
    final comp = await getApplicantCompanion(applicantId);
    final nextId = _dossiers.isEmpty
        ? 1
        : (_dossiers.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1);

    final validatedDocsMap = <String, bool>{};
    if (comp.documents.hasCiCopy) validatedDocsMap['CI'] = true;
    if (comp.documents.hasUtilityBill) validatedDocsMap['AVISO'] = true;
    if (comp.documents.hasHomeSketch) validatedDocsMap['CROQUIS'] = true;
    if (comp.documents.hasPhoto3x4) validatedDocsMap['FOTO'] = true;
    if (comp.documents.hasSus) validatedDocsMap['SUS'] = true;
    if (comp.documents.hasFelcc) validatedDocsMap['FELCC'] = true;

    final checklist = RrhhDossierDocument.defaultChecklistFor(
      workplaceType: applicant.targetType,
      targetPosition: applicant.targetPosition ?? 'Operario',
      recruitmentValidatedDocs: validatedDocsMap,
    );

    const String sec1Status = 'pendiente';

    // Match area and position
    String? matchedAreaId;
    String? matchedAreaName = applicant.targetArea;
    for (final area in _areas) {
      if (area.name.toLowerCase().contains((applicant.targetArea ?? '').toLowerCase()) ||
          (applicant.targetArea ?? '').toLowerCase().contains(area.name.toLowerCase())) {
        matchedAreaId = area.id?.toString();
        matchedAreaName = area.name;
        break;
      }
    }
    if (matchedAreaId == null && _areas.isNotEmpty) {
      matchedAreaId = _areas.first.id?.toString();
      matchedAreaName ??= _areas.first.name;
    }

    String? matchedPosId;
    String? matchedPosName = applicant.targetPosition;
    for (final pos in _positions) {
      if (pos.name.toLowerCase().contains((applicant.targetPosition ?? '').toLowerCase()) ||
          (applicant.targetPosition ?? '').toLowerCase().contains(pos.name.toLowerCase())) {
        matchedPosId = pos.id?.toString();
        matchedPosName = pos.name;
        break;
      }
    }
    if (matchedPosId == null && _positions.isNotEmpty) {
      matchedPosId = _positions.first.id?.toString();
      matchedPosName ??= _positions.first.name;
    }

    final emergName = comp.evaluation.personalReferenceName ??
        applicant.referencePerson ??
        applicant.emergencyContact;
    final emergPhone = comp.evaluation.personalReferencePhone ??
        applicant.referencePhone ??
        applicant.emergencyPhone;
    final expectedSal = comp.evaluation.salaryExpectation ??
        (applicant.expectedSalary != null && applicant.expectedSalary! > 0
            ? applicant.expectedSalary
            : null);

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
      section1Status: sec1Status,
      preloadedFromApplicant: true,
      documents: checklist,
      fullAddress: (applicant.address != null && applicant.address!.isNotEmpty)
          ? applicant.address
          : null,
      emergencyContactName: emergName,
      emergencyContactPhone: emergPhone,
      applicantExpectedSalary: expectedSal,
      areaId: matchedAreaId,
      areaName: matchedAreaName,
      positionId: matchedPosId,
      positionName: matchedPosName,
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
  Future<RrhhEmployee> convertDossierToEmployee(int dossierId, {String? notes}) async {
    final dIdx = _dossiers.indexWhere((d) => d.id == dossierId);
    if (dIdx == -1) throw StateError('Expediente no encontrado');
    final dossier = _dossiers[dIdx];

    // 1. Idempotencia: si ya está cerrado y tiene código de empleado, devolver el existente
    if (dossier.status == 'cerrado' && dossier.convertedEmployeeCode != null) {
      final existing = _employees.firstWhere(
        (e) => e.code == dossier.convertedEmployeeCode,
        orElse: () => _employees.first,
      );
      return existing;
    }

    // 2. Validar que las 5 secciones estén completas
    if (dossier.section1Status != 'completa' ||
        dossier.section2Status != 'completa' ||
        dossier.section3Status != 'completa' ||
        dossier.section4Status != 'completa' ||
        dossier.section5Status != 'completa') {
      throw StateError('El expediente no está listo para convertir');
    }

    // 3. Generar código correlativo EMP-XXX buscando el mayor número existente
    int maxEmpNum = 0;
    for (final e in _employees) {
      final match = RegExp(r'EMP-(\d+)').firstMatch(e.code);
      if (match != null) {
        final val = int.tryParse(match.group(1)!) ?? 0;
        if (val > maxEmpNum && val < 90) {
          maxEmpNum = val;
        } else if (val > maxEmpNum && maxEmpNum == 0) {
          maxEmpNum = val;
        }
      }
    }
    final nextNum = maxEmpNum + 1;
    final code = 'EMP-${nextNum.toString().padLeft(3, '0')}';

    // 4. Buscar datos del postulante para complementar
    final appIdx = _applicants.indexWhere((a) => a.id == dossier.applicantId);
    final app = appIdx != -1 ? _applicants[appIdx] : null;

    final now = DateTime.now();
    final realStart = dossier.effectiveStartDate ?? dossier.contractStartDate ?? now;
    final fiscalStart = dossier.contractStartDate ?? realStart;

    // 5. Mapear RrhhEmployee con todos los datos del expediente
    final newEmployee = RrhhEmployee(
      id: nextNum,
      code: code,
      fullName: app?.fullName ?? dossier.applicantName,
      birthDate: app?.birthDate,
      birthPlace: 'Bolivia',
      identityCard: app?.identityCard ?? dossier.applicantCi,
      phone: app?.phone ?? dossier.applicantPhone,
      address: dossier.fullAddress ?? '',
      occupation: dossier.targetPosition,
      personalReference: (dossier.emergencyContactName != null && dossier.emergencyContactName!.isNotEmpty)
          ? dossier.emergencyContactName!
          : (app?.referencePerson ?? ''),
      referencePhone: (dossier.emergencyContactPhone != null && dossier.emergencyContactPhone!.isNotEmpty)
          ? dossier.emergencyContactPhone!
          : (app?.referencePhone ?? ''),
      employeeType: dossier.workplaceType,
      area: dossier.areaName ?? dossier.targetArea,
      areaId: app?.areaId ?? (dossier.areaId != null ? int.tryParse(dossier.areaId!) : 1),
      position: dossier.positionName ?? dossier.targetPosition,
      positionId: app?.positionId ?? (dossier.positionId != null ? int.tryParse(dossier.positionId!) : 2),
      specialty: app?.specialty ?? 'General',
      specialtyId: app?.specialtyId,
      workplace: dossier.baseLocation ?? 'Sede Central',
      supervisor: dossier.supervisorName ?? 'Sin supervisor asignado',
      realStartDate: realStart,
      fiscalStartDate: fiscalStart,
      agreedSalary: dossier.baseSalary ?? 0.0,
      contractType: dossier.contractTypeName ?? 'Indefinido',
      contractEndDate: dossier.contractEndDate,
      observations: notes ?? 'Alta formal generada automáticamente desde Expediente ${dossier.applicantCode}.',
      status: 'ACTIVO',
      availabilityStatus: 'DISPONIBLE',
      paymentModality: dossier.paymentModalityName ?? 'MENSUAL',
      workScheduleType: dossier.scheduleName ?? 'TIEMPO_COMPLETO_48H',
      hasCiCopy: dossier.documents['CI']?.isValidated ?? false,
      hasUtilityBill: dossier.documents['AVISO']?.isValidated ?? false,
      hasHomeSketch: dossier.documents['CROQUIS']?.isValidated ?? false,
      hasFelccRecord: dossier.documents['FELCC']?.isValidated ?? false,
      hasPhoto3x4: dossier.documents['FOTO']?.isValidated ?? false,
      hasSusInsurance: dossier.documents['SUS']?.isValidated ?? false,
      corporateEmail: (app?.email != null && app!.email!.isNotEmpty)
          ? app.email!
          : (dossier.applicantEmail ?? '${dossier.applicantName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@elitemultiservicios.com'),
      afpName: dossier.afpName,
      afpNumber: dossier.afpNumber,
      healthInsurance: dossier.healthInsuranceName,
      fullAddress: dossier.fullAddress,
      maritalStatus: dossier.maritalStatus,
      childrenCount: dossier.childrenCount,
      emergencyContactName: dossier.emergencyContactName,
      emergencyContactPhone: dossier.emergencyContactPhone,
      emergencyContactRelation: dossier.emergencyContactRelation,
      workdayType: dossier.workdayType,
      contractStartDate: dossier.contractStartDate,
      bonuses: dossier.bonuses,
      deductions: dossier.deductions,
      shiftId: dossier.shiftId,
      baseLocation: dossier.baseLocation,
      supervisorEmployeeId: dossier.supervisorEmployeeId,
      documentChecklist: dossier.documents.map((k, v) => MapEntry(k, v.status)),
      createdAt: now,
      updatedAt: now,
    );

    // 6. Insertar en lista de empleados en primera posición
    _employees.insert(0, newEmployee);

    // 7. Actualizar el expediente a cerrado
    _dossiers[dIdx] = dossier.copyWith(
      status: 'cerrado',
      closedAt: now,
      section6Status: 'completa',
      convertedEmployeeCode: code,
      convertedEmployeeId: nextNum,
      closingNotes: notes,
    );

    // 8. Actualizar postulante a CONTRATADO y su trazabilidad
    if (appIdx != -1) {
      _applicants[appIdx] = _applicants[appIdx].copyWith(status: 'CONTRATADO');
      final comp = await getApplicantCompanion(dossier.applicantId);
      final newHistory = List<RrhhStatusHistoryEntry>.from(comp.history)
        ..add(RrhhStatusHistoryEntry(
          fromStatus: 'SELECCIONADO',
          toStatus: 'CONTRATADO',
          timestamp: now,
          author: 'Lic. Laura Mendoza',
          notes: 'Contratación formal concluida desde Expediente ${dossier.applicantCode}. Código asignado: $code',
        ));
      _applicantCompanions[dossier.applicantId] = comp.copyWith(history: newHistory);
    }

    // 9. Registrar historial de movimiento
    _movements.insert(0, RrhhMovementHistory(
      id: _movements.length + 1,
      employeeId: nextNum,
      employeeCode: code,
      employeeName: newEmployee.fullName,
      movementType: 'INGRESO',
      previousValue: 'Postulante Seleccionado (${dossier.applicantCode})',
      newValue: 'Empleado Activo (${newEmployee.position})',
      effectiveDate: newEmployee.realStartDate,
      reason: 'Alta formal desde Expediente de Contratación',
      authorizedBy: 'Lic. Laura Mendoza',
      createdAt: now,
    ));

    return newEmployee;
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
    return _leaves.where((l) {
      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        final matchesEmployee = l.employeeName.toLowerCase().contains(query);
        final matchesEmpCode = l.employeeCode.toLowerCase().contains(query);
        final matchesCode = l.code.toLowerCase().contains(query);
        final matchesReason = l.reason.toLowerCase().contains(query);
        if (!matchesEmployee && !matchesEmpCode && !matchesCode && !matchesReason) {
          return false;
        }
      }
      if (leaveType != null && leaveType.isNotEmpty && leaveType != 'TODOS') {
        if (l.leaveType.toUpperCase() != leaveType.toUpperCase()) return false;
      }
      if (status != null && status.isNotEmpty && status != 'TODOS') {
        if (l.status.toLowerCase() != status.toLowerCase()) return false;
      }
      if (isPaid != null) {
        if (l.isPaid != isPaid) return false;
      }
      if (fromDate != null) {
        if (l.endDate.isBefore(fromDate)) return false;
      }
      if (toDate != null) {
        if (l.startDate.isAfter(toDate)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id) async {
    try {
      return _leaves.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    int maxNum = 0;
    for (final l in _leaves) {
      final match = RegExp(r'PERM-(\d+)').firstMatch(l.code);
      if (match != null) {
        final val = int.tryParse(match.group(1)!) ?? 0;
        if (val > maxNum) maxNum = val;
      }
    }
    final nextId = _leaves.isEmpty ? 1 : _leaves.map((l) => l.id).reduce((a, b) => a > b ? a : b) + 1;
    final code = 'PERM-${(maxNum + 1).toString().padLeft(3, '0')}';
    final now = DateTime.now();

    final newRequest = request.copyWith(
      id: nextId,
      code: code,
      createdAt: now,
      updatedAt: now,
    );
    _leaves.insert(0, newRequest);
    return newRequest;
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveRequest(RrhhLeaveRequest request) async {
    final idx = _leaves.indexWhere((l) => l.id == request.id);
    if (idx != -1) {
      final updated = request.copyWith(updatedAt: DateTime.now());
      _leaves[idx] = updated;
      return updated;
    }
    throw StateError('Permiso no encontrado para actualizar');
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveStatus(
    int id,
    String newStatus, {
    String? reason,
    String? approvedBy,
  }) async {
    final idx = _leaves.indexWhere((l) => l.id == id);
    if (idx != -1) {
      final current = _leaves[idx];
      final now = DateTime.now();
      final updated = current.copyWith(
        status: newStatus,
        updatedAt: now,
        rejectionReason: reason ?? current.rejectionReason,
        approvedAt: newStatus == RrhhLeaveStatus.aprobado ? now : current.approvedAt,
        approvedBy: newStatus == RrhhLeaveStatus.aprobado ? (approvedBy ?? 'RRHH') : current.approvedBy,
      );
      _leaves[idx] = updated;
      return updated;
    }
    throw StateError('Permiso no encontrado');
  }

  @override
  Future<bool> deleteLeaveRequest(int id) async {
    final initialLength = _leaves.length;
    _leaves.removeWhere((l) => l.id == id);
    return _leaves.length < initialLength;
  }

  @override
  Future<List<RrhhLeaveRequest>> listPayrollAffectingLeaves(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return _leaves.where((l) {
      final isApprovedOrDone = l.status == RrhhLeaveStatus.aprobado ||
          l.status == RrhhLeaveStatus.finalizado ||
          l.status == RrhhLeaveStatus.enCurso;
      if (!isApprovedOrDone) return false;
      final overlaps = !(l.endDate.isBefore(fromDate) || l.startDate.isAfter(toDate));
      return overlaps;
    }).toList();
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
    return _vacationRecords.where((r) {
      if (employeeId != null && r.employeeId != employeeId) return false;
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (r.status.toLowerCase() != status.toLowerCase()) return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matches = r.code.toLowerCase().contains(q) ||
            r.employeeCode.toLowerCase().contains(q) ||
            r.employeeName.toLowerCase().contains(q) ||
            (r.notes?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }
      if (fromDate != null && r.endDate.isBefore(fromDate)) return false;
      if (toDate != null && r.startDate.isAfter(toDate)) return false;
      return true;
    }).toList();
  }

  @override
  Future<RrhhVacationRecord?> getVacationRecordById(int id) async {
    try {
      return _vacationRecords.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhVacationRecord> createVacationRecord(RrhhVacationRecord record) async {
    int maxNum = 0;
    for (final v in _vacationRecords) {
      final match = RegExp(r'VAC-(\d+)').firstMatch(v.code);
      if (match != null) {
        final val = int.tryParse(match.group(1)!) ?? 0;
        if (val > maxNum) maxNum = val;
      }
    }
    final nextId = _vacationRecords.isEmpty
        ? 1
        : _vacationRecords.map((v) => v.id).reduce((a, b) => a > b ? a : b) + 1;
    final code = 'VAC-${(maxNum + 1).toString().padLeft(3, '0')}';
    final now = DateTime.now();

    final newRecord = record.copyWith(
      id: nextId,
      code: code,
      createdAt: now,
      updatedAt: now,
    );
    _vacationRecords.insert(0, newRecord);
    return newRecord;
  }

  @override
  Future<RrhhVacationRecord> updateVacationRecord(RrhhVacationRecord record) async {
    final idx = _vacationRecords.indexWhere((r) => r.id == record.id);
    if (idx != -1) {
      final updated = record.copyWith(updatedAt: DateTime.now());
      _vacationRecords[idx] = updated;
      return updated;
    }
    throw StateError('Registro de vacación no encontrado');
  }

  @override
  Future<RrhhVacationRecord> updateVacationStatus(
    int id,
    String newStatus, {
    String? reason,
  }) async {
    final idx = _vacationRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final current = _vacationRecords[idx];
      final now = DateTime.now();
      String? notes = current.notes;
      if (reason != null && reason.trim().isNotEmpty) {
        notes = (notes != null && notes.isNotEmpty)
            ? '$notes | Motivo cambio estado ($newStatus): $reason'
            : 'Motivo cambio estado ($newStatus): $reason';
      }
      final updated = current.copyWith(
        status: newStatus,
        notes: notes,
        updatedAt: now,
      );
      _vacationRecords[idx] = updated;
      return updated;
    }
    throw StateError('Registro de vacación no encontrado');
  }

  @override
  Future<bool> deleteVacationRecord(int id) async {
    final initialLength = _vacationRecords.length;
    _vacationRecords.removeWhere((r) => r.id == id);
    return _vacationRecords.length < initialLength;
  }

  @override
  Future<List<RrhhVacationBalance>> listVacationBalances({
    String? search,
    String? balanceStatus,
    int? areaId,
  }) async {
    final now = DateTime(2026, 9, 26);
    final balances = <RrhhVacationBalance>[];

    for (final emp in _employees) {
      if (emp.status != 'ACTIVO') continue;
      if (areaId != null && emp.areaId != areaId) continue;

      final balance = _computeEmployeeBalance(emp, now);

      if (balanceStatus != null &&
          balanceStatus.isNotEmpty &&
          balanceStatus.toUpperCase() != 'TODOS') {
        if (balance.balanceStatus.toLowerCase() != balanceStatus.toLowerCase()) {
          continue;
        }
      }

      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matches = balance.employeeName.toLowerCase().contains(q) ||
            balance.employeeCode.toLowerCase().contains(q);
        if (!matches) continue;
      }

      balances.add(balance);
    }

    return balances;
  }

  @override
  Future<RrhhVacationBalance?> getVacationBalanceByEmployee(int employeeId) async {
    final now = DateTime(2026, 9, 26);
    try {
      final emp = _employees.firstWhere((e) => e.id == employeeId);
      return _computeEmployeeBalance(emp, now);
    } catch (_) {
      return null;
    }
  }

  RrhhVacationBalance _computeEmployeeBalance(RrhhEmployee emp, DateTime asOfDate) {
    final hireDate = emp.realStartDate;
    final antiquity = asOfDate.difference(hireDate);
    final years = RrhhVacationCalculator.getCompletedYears(hireDate, asOfDate);
    final assignedDays = RrhhVacationCalculator.getAssignedDays(hireDate, asOfDate);

    // Sum of used days in current period (status gozado or en_curso)
    final usedDays = _vacationRecords.where((r) {
      if (r.employeeId != emp.id) return false;
      return r.status == RrhhVacationRecordStatus.gozado ||
          r.status == RrhhVacationRecordStatus.enCurso;
    }).fold<int>(0, (sum, r) => sum + r.daysCounted);

    final pendingDays = (assignedDays - usedDays).clamp(0, 999);

    final nextAnniv = RrhhVacationCalculator.getNextAnniversary(hireDate, asOfDate);
    final daysUntilAnniv = nextAnniv.difference(asOfDate).inDays;

    String status;
    if (years < 1) {
      status = RrhhVacationBalanceStatus.sinDerecho;
    } else if (pendingDays == 0) {
      status = RrhhVacationBalanceStatus.agotado;
    } else if (daysUntilAnniv <= 30) {
      status = RrhhVacationBalanceStatus.parcial;
    } else {
      status = RrhhVacationBalanceStatus.disponible;
    }

    return RrhhVacationBalance(
      employeeId: emp.id ?? 0,
      employeeCode: emp.code,
      employeeName: emp.fullName,
      hireDate: hireDate,
      antiquity: antiquity,
      assignedDays: assignedDays,
      usedDays: usedDays,
      pendingDays: pendingDays,
      balanceStatus: status,
      nextAnniversary: nextAnniv,
      daysUntilAnniversary: daysUntilAnniv,
    );
  }

  @override
  Future<List<RrhhVacationRecord>> listPayrollAffectingVacations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return _vacationRecords.where((r) {
      final affects = r.status == RrhhVacationRecordStatus.gozado ||
          r.status == RrhhVacationRecordStatus.enCurso ||
          r.status == RrhhVacationRecordStatus.programado;
      if (!affects) return false;
      final overlaps = !(r.endDate.isBefore(fromDate) || r.startDate.isAfter(toDate));
      return overlaps;
    }).toList();
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
    return _disciplinaryRecords.where((r) {
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (r.status.toLowerCase() != status.toLowerCase()) return false;
      }
      if (faultType != null && faultType.isNotEmpty && faultType.toUpperCase() != 'TODOS') {
        if (r.faultType.toLowerCase() != faultType.toLowerCase()) return false;
      }
      if (sanctionType != null && sanctionType.isNotEmpty && sanctionType.toUpperCase() != 'TODOS') {
        if (r.sanctionType?.toLowerCase() != sanctionType.toLowerCase()) return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matches = r.code.toLowerCase().contains(q) ||
            r.employeeCode.toLowerCase().contains(q) ||
            r.employeeName.toLowerCase().contains(q) ||
            r.incidentDescription.toLowerCase().contains(q) ||
            (r.notes?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }
      if (fromDate != null && r.incidentDate.isBefore(fromDate)) return false;
      if (toDate != null && r.incidentDate.isAfter(toDate)) return false;
      return true;
    }).toList();
  }

  @override
  Future<RrhhDisciplinaryRecord?> getDisciplinaryRecordById(int id) async {
    try {
      return _disciplinaryRecords.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhDisciplinaryRecord> createDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    int maxNum = 0;
    for (final r in _disciplinaryRecords) {
      final match = RegExp(r'INC-(\d+)').firstMatch(r.code);
      if (match != null) {
        final val = int.tryParse(match.group(1)!) ?? 0;
        if (val > maxNum) maxNum = val;
      }
    }
    final nextCode = 'INC-${(maxNum + 1).toString().padLeft(3, '0')}';
    final nextId = _disciplinaryRecords.fold<int>(0, (max, r) => r.id > max ? r.id : max) + 1;

    final created = record.copyWith(
      id: nextId,
      code: nextCode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _disciplinaryRecords.insert(0, created);
    return created;
  }

  @override
  Future<RrhhDisciplinaryRecord> updateDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    final idx = _disciplinaryRecords.indexWhere((r) => r.id == record.id);
    if (idx != -1) {
      final updated = record.copyWith(updatedAt: DateTime.now());
      _disciplinaryRecords[idx] = updated;
      return updated;
    }
    throw StateError('Registro disciplinario no encontrado');
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
    final idx = _disciplinaryRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final current = _disciplinaryRecords[idx];
      final updated = current.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        notes: reason ?? current.notes,
        dischargeText: dischargeText ?? current.dischargeText,
        dischargeDate: dischargeText != null ? DateTime.now() : current.dischargeDate,
        sanctionType: sanctionType ?? current.sanctionType,
        suspensionDays: suspensionDays ?? current.suspensionDays,
        salaryDeduction: salaryDeduction ?? current.salaryDeduction,
        sanctionDescription: sanctionDescription ?? current.sanctionDescription,
        sanctionedAt: newStatus == RrhhDisciplinaryStatus.sancionada ? DateTime.now() : current.sanctionedAt,
        sanctionedBy: newStatus == RrhhDisciplinaryStatus.sancionada ? 'Gerencia de RRHH' : current.sanctionedBy,
      );
      _disciplinaryRecords[idx] = updated;
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteDisciplinaryRecord(int id) async {
    final idx = _disciplinaryRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final record = _disciplinaryRecords[idx];
      if (record.status != RrhhDisciplinaryStatus.registrada) {
        throw StateError('Solo se pueden eliminar incidencias en estado registrada.');
      }
      _disciplinaryRecords.removeAt(idx);
      return true;
    }
    return false;
  }

  @override
  Future<List<RrhhDisciplinaryRecord>> listPayrollAffectingDisciplinary(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return _disciplinaryRecords.where((r) {
      if (r.status != RrhhDisciplinaryStatus.sancionada) return false;
      final hasDeduction = (r.salaryDeduction != null && r.salaryDeduction! > 0) ||
          r.sanctionType == RrhhSanctionTypes.suspension ||
          r.sanctionType == RrhhSanctionTypes.pecuniaria;
      if (!hasDeduction) return false;
      if (r.incidentDate.isBefore(fromDate) || r.incidentDate.isAfter(toDate)) return false;
      return true;
    }).toList();
  }

  @override
  Future<List<RrhhIncident>> listIncidents({String? severity, String? search}) async => _incidents;
  @override
  Future<RrhhIncident> recordIncident(RrhhIncident incident) async {
    final c = incident.copyWith(id: _incidents.length + 1);
    _incidents.insert(0, c);
    return c;
  }

  // ---------------------------------------------------------------------------
  // PANTALLA 11: Desvinculación & Bajas Laborales (Regla de Oro Inactivo / LGT Bolivia)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return _terminationRecords.where((r) {
      if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
        if (r.status.toLowerCase() != status.toLowerCase()) return false;
      }
      if (terminationType != null && terminationType.isNotEmpty && terminationType.toUpperCase() != 'TODOS') {
        if (r.terminationType.toLowerCase() != terminationType.toLowerCase()) return false;
      }
      if (search != null && search.trim().isNotEmpty) {
        final q = search.trim().toLowerCase();
        final matches = r.code.toLowerCase().contains(q) ||
            r.employeeCode.toLowerCase().contains(q) ||
            r.employeeName.toLowerCase().contains(q) ||
            r.reason.toLowerCase().contains(q) ||
            (r.notes?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }
      if (fromDate != null && r.terminationDate.isBefore(fromDate)) return false;
      if (toDate != null && r.terminationDate.isAfter(toDate)) return false;
      return true;
    }).toList();
  }

  @override
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id) async {
    try {
      return _terminationRecords.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RrhhTerminationRecord> createTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    int maxNum = 0;
    for (final r in _terminationRecords) {
      final match = RegExp(r'BAJA-(\d+)').firstMatch(r.code);
      if (match != null) {
        final val = int.tryParse(match.group(1)!) ?? 0;
        if (val > maxNum) maxNum = val;
      }
    }
    final nextCode = 'BAJA-${(maxNum + 1).toString().padLeft(3, '0')}';
    final nextId = _terminationRecords.fold<int>(0, (max, r) => r.id > max ? r.id : max) + 1;
    final deadline = record.paymentDeadline ?? record.lastWorkDay.add(const Duration(days: 15));

    final created = record.copyWith(
      id: nextId,
      code: nextCode,
      paymentDeadline: deadline,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _terminationRecords.insert(0, created);

    if (created.status == RrhhTerminationStatus.finalizada) {
      _applyTerminationToEmployee(created);
    }

    return created;
  }

  @override
  Future<RrhhTerminationRecord> updateTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    final idx = _terminationRecords.indexWhere((r) => r.id == record.id);
    if (idx != -1) {
      final deadline = record.paymentDeadline ?? record.lastWorkDay.add(const Duration(days: 15));
      final updated = record.copyWith(
        paymentDeadline: deadline,
        updatedAt: DateTime.now(),
      );
      _terminationRecords[idx] = updated;

      if (updated.status == RrhhTerminationStatus.finalizada) {
        _applyTerminationToEmployee(updated);
      }
      return updated;
    }
    throw StateError('Registro de desvinculación no encontrado');
  }

  @override
  Future<bool> updateTerminationStatus(
    int id,
    String newStatus, {
    String? reason,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
  }) async {
    final idx = _terminationRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final current = _terminationRecords[idx];
      final isFinalizing = newStatus == RrhhTerminationStatus.finalizada;
      final now = DateTime.now();

      final updated = current.copyWith(
        status: newStatus,
        updatedAt: now,
        notes: reason ?? current.notes,
        paymentCompleted: paymentCompleted ?? current.paymentCompleted,
        paymentCompletedAt: (paymentCompleted == true)
            ? (paymentCompletedAt ?? now)
            : (paymentCompleted == false ? null : current.paymentCompletedAt),
        processedAt: isFinalizing ? now : current.processedAt,
        processedBy: isFinalizing ? 'Gerencia de RRHH' : current.processedBy,
      );
      _terminationRecords[idx] = updated;

      if (isFinalizing) {
        _applyTerminationToEmployee(updated);
      }

      return true;
    }
    return false;
  }

  void _applyTerminationToEmployee(RrhhTerminationRecord record) {
    final empIdx = _employees.indexWhere((e) => e.id == record.employeeId);
    if (empIdx != -1) {
      final emp = _employees[empIdx];
      _employees[empIdx] = emp.copyWith(
        status: 'BAJA',
        availabilityStatus: 'INACTIVO',
        exitDate: record.terminationDate,
        exitReason: record.reason,
        exitObservations: record.justifiedCause ?? record.notes,
        exitRegisteredBy: record.createdBy,
      );
    }
  }

  @override
  Future<bool> deleteTerminationRecord(int id) async {
    final idx = _terminationRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final record = _terminationRecords[idx];
      if (record.status != RrhhTerminationStatus.registrada) {
        throw StateError('Solo se pueden eliminar desvinculaciones en estado registrada.');
      }
      _terminationRecords.removeAt(idx);
      return true;
    }
    return false;
  }

  @override
  Future<List<RrhhTerminationRecord>> listPayrollAffectingTerminations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return _terminationRecords.where((r) {
      if (r.status == RrhhTerminationStatus.cancelada) return false;
      if (r.terminationDate.isBefore(fromDate) || r.terminationDate.isAfter(toDate)) {
        return false;
      }
      return true;
    }).toList();
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
  // PANTALLA 12: Novedades para Nómina (Entrega a Contabilidad)
  // ---------------------------------------------------------------------------
  @override
  Future<List<RrhhPayrollPeriod>> listPayrollPeriods() async {
    final list = List<RrhhPayrollPeriod>.from(_payrollPeriods);
    list.sort((a, b) {
      final cmp = b.year.compareTo(a.year);
      if (cmp != 0) return cmp;
      return b.month.compareTo(a.month);
    });
    return list;
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodById(int id) async {
    final idx = _payrollPeriods.indexWhere((p) => p.id == id);
    if (idx != -1) return _payrollPeriods[idx];
    return null;
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodByMonth(int year, int month) async {
    final idx = _payrollPeriods.indexWhere((p) => p.year == year && p.month == month);
    if (idx != -1) return _payrollPeriods[idx];
    return null;
  }

  @override
  Future<RrhhPayrollPeriod> createPayrollPeriod(int year, int month, {String? notes}) async {
    final existing = await getPayrollPeriodByMonth(year, month);
    if (existing != null) {
      throw StateError('Ya existe un período registrado para el mes $month/$year');
    }

    final id = _payrollPeriods.isEmpty ? 1 : _payrollPeriods.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
    final mStr = month.toString().padLeft(2, '0');
    final code = 'NOM-$year-$mStr';
    final now = DateTime.now();

    final newPeriod = RrhhPayrollPeriod(
      id: id,
      code: code,
      year: year,
      month: month,
      status: RrhhPayrollPeriodStatus.abierto,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
    _payrollPeriods.add(newPeriod);

    // Generar automáticamente los items a partir de las novedades del mes
    await generatePayrollItems(newPeriod.id);

    return newPeriod;
  }

  @override
  Future<RrhhPayrollPeriod> closePayrollPeriod(int id, {String? closedBy, String? notes}) async {
    final idx = _payrollPeriods.indexWhere((p) => p.id == id);
    if (idx == -1) throw StateError('Período de nómina no encontrado');

    final current = _payrollPeriods[idx];
    if (current.isClosed || current.isSent || current.isProcessed) {
      throw StateError('El período ya se encuentra cerrado o procesado');
    }

    final now = DateTime.now();
    final updated = current.copyWith(
      status: RrhhPayrollPeriodStatus.cerrado,
      closedAt: now,
      closedBy: closedBy ?? 'Lic. Laura Mendoza',
      notes: notes ?? current.notes,
      updatedAt: now,
    );
    _payrollPeriods[idx] = updated;
    return updated;
  }

  @override
  Future<RrhhPayrollPeriod> sendPayrollPeriodToAccounting(int id, {String? sentBy}) async {
    final idx = _payrollPeriods.indexWhere((p) => p.id == id);
    if (idx == -1) throw StateError('Período de nómina no encontrado');

    final current = _payrollPeriods[idx];
    if (current.isOpen) {
      throw StateError('Debe cerrar el período antes de enviarlo a Contabilidad');
    }

    final now = DateTime.now();
    final updated = current.copyWith(
      status: RrhhPayrollPeriodStatus.enviado,
      sentAt: now,
      sentBy: sentBy ?? 'Lic. Laura Mendoza',
      updatedAt: now,
    );
    _payrollPeriods[idx] = updated;
    return updated;
  }

  @override
  Future<List<RrhhPayrollItem>> listPayrollItems(
    int periodId, {
    String? sourceType,
    String? impactType,
  }) async {
    return _payrollItems.where((it) {
      if (it.periodId != periodId) return false;
      if (sourceType != null && sourceType.isNotEmpty && sourceType.toLowerCase() != 'todos') {
        if (it.sourceType.toLowerCase() != sourceType.toLowerCase()) return false;
      }
      if (impactType != null && impactType.isNotEmpty && impactType.toLowerCase() != 'todos') {
        if (it.impactType.toLowerCase() != impactType.toLowerCase()) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<RrhhPayrollItem>> generatePayrollItems(int periodId) async {
    final period = await getPayrollPeriodById(periodId);
    if (period == null) throw StateError('Período no encontrado');

    final fromDate = DateTime(period.year, period.month, 1);
    final toDate = (period.month == 12)
        ? DateTime(period.year + 1, 1, 1).subtract(const Duration(seconds: 1))
        : DateTime(period.year, period.month + 1, 1).subtract(const Duration(seconds: 1));

    // Si ya tiene items pre-poblados y no queremos duplicar
    final existingItems = _payrollItems.where((i) => i.periodId == periodId).toList();
    if (existingItems.isNotEmpty) {
      return existingItems;
    }

    final generated = <RrhhPayrollItem>[];
    int nextId = _payrollItems.isEmpty ? 1 : _payrollItems.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;

    // 1. Permisos aprobados en el mes
    final leaves = await listLeaveRequests(status: 'aprobado');
    for (final l in leaves) {
      if (l.startDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
          l.startDate.isBefore(toDate.add(const Duration(days: 1)))) {
        final isUnpaid = !l.isPaid;
        final dailyRate = 100.0;
        final deduction = isUnpaid ? -(l.durationDays * dailyRate) : null;
        generated.add(
          RrhhPayrollItem(
            id: nextId++,
            periodId: periodId,
            employeeId: l.employeeId,
            employeeCode: l.employeeCode,
            employeeName: l.employeeName,
            sourceType: RrhhPayrollSourceType.permiso,
            sourceId: l.id,
            sourceCode: l.code,
            effectiveDate: l.startDate,
            description: '${l.leaveType}: ${l.reason} (${l.durationDays} d)',
            impactType: isUnpaid ? RrhhPayrollImpactType.descuento : RrhhPayrollImpactType.sinImpacto,
            impactAmount: deduction ?? 0.0,
            notes: isUnpaid ? 'Descuento proporcional a días no trabajados' : 'Con goce de haberes',
          ),
        );
      }
    }

    // 2. Vacaciones gozadas en el mes
    final vacations = await listVacationRecords(status: 'gozada');
    for (final v in vacations) {
      if (v.startDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
          v.startDate.isBefore(toDate.add(const Duration(days: 1)))) {
        generated.add(
          RrhhPayrollItem(
            id: nextId++,
            periodId: periodId,
            employeeId: v.employeeId,
            employeeCode: v.employeeCode,
            employeeName: v.employeeName,
            sourceType: RrhhPayrollSourceType.vacacion,
            sourceId: v.id,
            sourceCode: v.code,
            effectiveDate: v.startDate,
            description: 'Uso de vacaciones anuales (${v.daysCounted} días hábiles)',
            impactType: RrhhPayrollImpactType.sinImpacto,
            impactAmount: 0.0,
            notes: 'Días remunerados con cargo a la planilla regular',
          ),
        );
      }
    }

    // 3. Incidencias sancionadas en el mes
    final incidents = await listDisciplinaryRecords(status: 'sancionada');
    for (final inc in incidents) {
      if (inc.incidentDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
          inc.incidentDate.isBefore(toDate.add(const Duration(days: 1)))) {
        final amount = inc.salaryDeduction != null
            ? -inc.salaryDeduction!
            : (inc.suspensionDays != null ? -(inc.suspensionDays! * 100.0) : null);
        generated.add(
          RrhhPayrollItem(
            id: nextId++,
            periodId: periodId,
            employeeId: inc.employeeId,
            employeeCode: inc.employeeCode,
            employeeName: inc.employeeName,
            sourceType: RrhhPayrollSourceType.incidencia,
            sourceId: inc.id,
            sourceCode: inc.code,
            effectiveDate: inc.incidentDate,
            description: '${inc.sanctionType ?? "Sanción"}: ${inc.incidentDescription}',
            impactType: (amount != null && amount < 0) ? RrhhPayrollImpactType.descuento : RrhhPayrollImpactType.sinImpacto,
            impactAmount: amount ?? 0.0,
            notes: inc.notes,
          ),
        );
      }
    }

    // 4. Desvinculaciones efectivas en el mes
    final terminations = await listPayrollAffectingTerminations(fromDate, toDate);
    for (final term in terminations) {
      generated.add(
        RrhhPayrollItem(
          id: nextId++,
          periodId: periodId,
          employeeId: term.employeeId,
          employeeCode: term.employeeCode,
          employeeName: term.employeeName,
          sourceType: RrhhPayrollSourceType.desvinculacion,
          sourceId: term.id,
          sourceCode: term.code,
          effectiveDate: term.terminationDate,
          description: '${term.terminationType}: ${term.reason}',
          impactType: RrhhPayrollImpactType.pagoExtra,
          impactAmount: term.paymentCompleted ? 5000.0 : 2500.0,
          notes: term.notes ?? 'Liquidación de beneficios sociales',
        ),
      );
    }

    _payrollItems.addAll(generated);
    return generated;
  }

  @override
  Future<String> exportPayrollPeriod(int periodId, String format) async {
    final period = await getPayrollPeriodById(periodId);
    if (period == null) throw StateError('Período no encontrado');
    final items = await listPayrollItems(periodId);

    if (format.toLowerCase() == 'csv') {
      final buffer = StringBuffer();
      buffer.writeln('PERIODO,EMPLEADO_CODIGO,EMPLEADO_NOMBRE,TIPO_NOVEDAD,CODIGO_ORIGEN,FECHA_EFECTIVA,DESCRIPCION,IMPACTO_TIPO,MONTO_BS');
      for (final it in items) {
        buffer.writeln('${period.code},"${it.employeeCode}","${it.employeeName}","${it.sourceType}","${it.sourceCode}","${it.effectiveDate.toIso8601String().substring(0, 10)}","${it.description}","${it.impactType}",${it.impactAmount ?? 0}');
      }
      return buffer.toString();
    } else {
      final buffer = StringBuffer();
      buffer.writeln('REPORTE CONSOLIDADO DE NOVEDADES PARA NOMINA — ${period.code}');
      buffer.writeln('Generado: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Estado: ${period.status.toUpperCase()}');
      buffer.writeln('');
      buffer.writeln('Empleado\tTipo\tCódigo\tFecha\tDescripción\tImpacto\tMonto (Bs)');
      for (final it in items) {
        buffer.writeln('${it.employeeName} (${it.employeeCode})\t${it.sourceType}\t${it.sourceCode}\t${it.effectiveDate.toIso8601String().substring(0, 10)}\t${it.description}\t${it.impactType}\t${it.impactAmount ?? 0}');
      }
      return buffer.toString();
    }
  }

  // ---------------------------------------------------------------------------
  // Asistencia APK y Bitácora
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
  Future<List<RrhhAttendanceRecord>> listAttendanceRecords({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
    String? serviceName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    var result = List<RrhhAttendanceRecord>.from(_attendanceRecords);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((r) {
        return r.employeeName.toLowerCase().contains(q) ||
            r.employeeCode.toLowerCase().contains(q) ||
            r.code.toLowerCase().contains(q) ||
            r.clientName.toLowerCase().contains(q) ||
            r.serviceName.toLowerCase().contains(q) ||
            r.location.toLowerCase().contains(q);
      }).toList();
    }

    if (dateRange != null) {
      result = result.where((r) {
        final d = DateTime(r.date.year, r.date.month, r.date.day);
        final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
        final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
        return (d.isAfter(start) || d.isAtSameMomentAs(start)) &&
            (d.isBefore(end) || d.isAtSameMomentAs(end));
      }).toList();
    }

    if (status != null && status.isNotEmpty && status.toUpperCase() != 'TODOS') {
      result = result.where((r) => r.status.toLowerCase() == status.toLowerCase()).toList();
    }

    if (clientName != null && clientName.isNotEmpty && clientName.toUpperCase() != 'TODOS') {
      result = result.where((r) => r.clientName.toLowerCase() == clientName.toLowerCase()).toList();
    }

    if (serviceName != null && serviceName.isNotEmpty && serviceName.toUpperCase() != 'TODOS') {
      result = result.where((r) => r.serviceName.toLowerCase() == serviceName.toLowerCase()).toList();
    }

    result.sort((a, b) {
      final cmp = b.date.compareTo(a.date);
      if (cmp != 0) return cmp;
      return a.code.compareTo(b.code);
    });

    return result;
  }

  @override
  Future<RrhhAttendanceRecord?> getAttendanceRecordById(int id) async {
    await Future.delayed(const Duration(milliseconds: 30));
    try {
      return _attendanceRecords.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> exportAttendanceReport({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
  }) async {
    final records = await listAttendanceRecords(
      query: query,
      dateRange: dateRange,
      status: status,
      clientName: clientName,
    );

    final buffer = StringBuffer();
    buffer.writeln('CÓDIGO,FECHA,EMPLEADO_ID,EMPLEADO,CLIENTE,SERVICIO,SEDE,ENTRADA_PROG,ENTRADA_REAL,SALIDA_PROG,SALIDA_REAL,HORAS_TRABAJADAS,TARDANZA_MIN,ESTADO,OBSERVACIONES');
    for (final r in records) {
      String fmtTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      buffer.writeln(
        '${r.code},'
        '${r.date.toIso8601String().substring(0, 10)},'
        '${r.employeeCode},'
        '"${r.employeeName}",'
        '"${r.clientName}",'
        '"${r.serviceName}",'
        '"${r.location}",'
        '${fmtTime(r.scheduledEntry)},'
        '${r.actualEntry != null ? fmtTime(r.actualEntry!) : "-"},'
        '${fmtTime(r.scheduledExit)},'
        '${r.actualExit != null ? fmtTime(r.actualExit!) : "-"},'
        '${r.workedHours ?? 0.0},'
        '${r.lateMinutes ?? 0},'
        '${r.status.toUpperCase()},'
        '"${r.incidents ?? ""}"',
      );
    }
    return buffer.toString();
  }

  @override
  Future<List<RrhhMovementHistory>> listMovements({String? movementType, int? employeeId, int? limit, int? offset}) async {
    return _movements;
  }

  @override
  Future<List<CrmClientRefDto>> listClientReferences() async => _clientRefs;
}
