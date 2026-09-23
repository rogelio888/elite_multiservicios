import 'package:flutter/material.dart';
import '../models/rrhh_applicant.dart';
import '../models/rrhh_assignment.dart';
import '../models/rrhh_employee.dart';
import '../models/rrhh_labor_management.dart';
import '../models/rrhh_organization.dart';
import '../models/rrhh_schedule.dart';
import 'rrhh_mock_data.dart';

/// Servicio en memoria reactivo para el módulo completo de Recursos Humanos
class RrhhStateService extends ChangeNotifier {
  static final RrhhStateService _instance = RrhhStateService._internal();
  factory RrhhStateService() => _instance;

  RrhhStateService._internal() {
    _areas = List.from(RrhhMockData.initialAreas);
    _positions = List.from(RrhhMockData.initialPositions);
    _specialties = List.from(RrhhMockData.initialSpecialties);
    _clients = List.from(RrhhMockData.initialClients);
    _schedules = List.from(RrhhMockData.initialSchedules);
    _applicants = List.from(RrhhMockData.initialApplicants);
    _employees = List.from(RrhhMockData.initialEmployees);
    _assignments = List.from(RrhhMockData.initialAssignments);
    _leaves = List.from(RrhhMockData.initialLeaves);
    _vacations = List.from(RrhhMockData.initialVacations);
    _incidents = List.from(RrhhMockData.initialIncidents);
    _movements = List.from(RrhhMockData.initialMovements);
    _exits = _employees
        .where((e) => e.status == 'INACTIVO')
        .map(
          (e) => RrhhExitRecord(
            id: 'exit-${e.id}',
            employeeId: e.id,
            employeeName: e.fullName,
            employeeCode: e.code,
            exitDate:
                e.exitDate ?? DateTime.now().subtract(const Duration(days: 30)),
            reason: e.exitReason ?? 'Conclusión de contrato a plazo fijo',
            observations:
                e.exitObservations ??
                'Liquidación de beneficios sociales cancelada y entrega de puesto completada.',
            documentationAttached:
                'Acta de finiquito firmada ante el Ministerio de Trabajo.',
            processedBy: e.exitRegisteredBy ?? 'Lic. Laura Mendoza (RRHH)',
            severancePay: 5400.0,
          ),
        )
        .toList();
    _salaryAdjustments = [
      RrhhSalaryAdjustment(
        id: 'adj-001',
        employeeId: 'emp-001',
        employeeName: 'Juan Carlos Pérez Mendoza',
        type: 'BONO',
        amount: 350.0,
        concept: 'Bono de Puntualidad y Cero Faltas (Septiembre)',
        authorizedBy: 'Lic. Laura Mendoza (RRHH)',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RrhhSalaryAdjustment(
        id: 'adj-002',
        employeeId: 'emp-002',
        employeeName: 'María Elena Gómez Rojas',
        type: 'ANTICIPO',
        amount: 500.0,
        concept: 'Anticipo quincenal solicitado por colaborador',
        authorizedBy: 'Lic. Laura Mendoza (RRHH)',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      RrhhSalaryAdjustment(
        id: 'adj-003',
        employeeId: 'emp-003',
        employeeName: 'Carlos Eduardo Mamani Choque',
        type: 'DESCUENTO_AUTORIZADO',
        amount: 120.0,
        concept: 'Reposición de Credencial institucional dañada',
        authorizedBy: 'Lic. Laura Mendoza (RRHH)',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  /// Reinicializa el estado con la semilla de mock data para pruebas unitarias
  void resetForTesting() {
    _areas = List.from(RrhhMockData.initialAreas);
    _positions = List.from(RrhhMockData.initialPositions);
    _specialties = List.from(RrhhMockData.initialSpecialties);
    _clients = List.from(RrhhMockData.initialClients);
    _schedules = List.from(RrhhMockData.initialSchedules);
    _applicants = List.from(RrhhMockData.initialApplicants);
    _employees = List.from(RrhhMockData.initialEmployees);
    _assignments = List.from(RrhhMockData.initialAssignments);
    _leaves = List.from(RrhhMockData.initialLeaves);
    _vacations = List.from(RrhhMockData.initialVacations);
    _incidents = List.from(RrhhMockData.initialIncidents);
    _movements = List.from(RrhhMockData.initialMovements);
    _exits = _employees
        .where((e) => e.status == 'INACTIVO')
        .map(
          (e) => RrhhExitRecord(
            id: 'exit-${e.id}',
            employeeId: e.id,
            employeeName: e.fullName,
            employeeCode: e.code,
            exitDate:
                e.exitDate ?? DateTime.now().subtract(const Duration(days: 30)),
            reason: e.exitReason ?? 'Conclusión de contrato a plazo fijo',
            observations:
                e.exitObservations ??
                'Liquidación de beneficios sociales cancelada y entrega de puesto completada.',
            documentationAttached:
                'Acta de finiquito firmada ante el Ministerio de Trabajo.',
            processedBy: e.exitRegisteredBy ?? 'Lic. Laura Mendoza (RRHH)',
            severancePay: 5400.0,
          ),
        )
        .toList();
    _salaryAdjustments = [
      RrhhSalaryAdjustment(
        id: 'adj-001',
        employeeId: 'emp-001',
        employeeName: 'Juan Carlos Pérez Mendoza',
        type: 'BONO',
        amount: 350.0,
        concept: 'Bono de Puntualidad y Cero Faltas (Septiembre)',
        authorizedBy: 'Lic. Laura Mendoza (RRHH)',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
    notifyListeners();
  }

  // -------------------------------------------------------------
  // ESTADO LOCAL EN MEMORIA
  // -------------------------------------------------------------
  late List<RrhhArea> _areas;
  late List<RrhhPosition> _positions;
  late List<RrhhSpecialty> _specialties;
  late List<RrhhClientCompany> _clients;
  late List<RrhhWorkSchedule> _schedules;
  late List<RrhhApplicant> _applicants;
  late List<RrhhEmployee> _employees;
  late List<RrhhAssignment> _assignments;
  late List<RrhhLeaveRequest> _leaves;
  late List<RrhhVacationRequest> _vacations;
  late List<RrhhIncident> _incidents;
  late List<RrhhLaborMovement> _movements;
  late List<RrhhExitRecord> _exits;
  late List<RrhhSalaryAdjustment> _salaryAdjustments;

  // -------------------------------------------------------------
  // GETTERS PÚBLICOS
  // -------------------------------------------------------------
  List<RrhhArea> get areas => List.unmodifiable(_areas);
  List<RrhhPosition> get positions => List.unmodifiable(_positions);
  List<RrhhSpecialty> get specialties => List.unmodifiable(_specialties);
  List<RrhhClientCompany> get clients => List.unmodifiable(_clients);
  List<RrhhClientCompany> get clientCompanies => List.unmodifiable(_clients);
  List<RrhhWorkSchedule> get schedules => List.unmodifiable(_schedules);
  List<RrhhApplicant> get applicants => List.unmodifiable(_applicants);
  List<RrhhEmployee> get employees => List.unmodifiable(_employees);
  List<RrhhEmployee> get allEmployees => List.unmodifiable(_employees);
  List<RrhhAssignment> get assignments => List.unmodifiable(_assignments);
  List<RrhhLeaveRequest> get leaves => List.unmodifiable(_leaves);
  List<RrhhVacationRequest> get vacations => List.unmodifiable(_vacations);
  List<RrhhIncident> get incidents => List.unmodifiable(_incidents);
  List<RrhhLaborMovement> get movements => List.unmodifiable(_movements);
  List<RrhhExitRecord> get exits => List.unmodifiable(_exits);
  List<RrhhSalaryAdjustment> get salaryAdjustments =>
      List.unmodifiable(_salaryAdjustments);

  List<RrhhSalaryAdjustment> getAdjustmentsForEmployee(String employeeId) =>
      _salaryAdjustments.where((a) => a.employeeId == employeeId).toList();

  void addSalaryAdjustment(RrhhSalaryAdjustment adjustment) {
    _salaryAdjustments.insert(0, adjustment);
    notifyListeners();
  }

  // Filtros rápidos
  List<RrhhEmployee> get activeEmployees =>
      _employees.where((e) => e.status == 'ACTIVO').toList();
  List<RrhhEmployee> get inactiveEmployees =>
      _employees.where((e) => e.status == 'INACTIVO').toList();
  List<RrhhEmployee> get officeEmployees =>
      activeEmployees.where((e) => e.employeeType == 'OFICINA').toList();
  List<RrhhEmployee> get fieldEmployees =>
      activeEmployees.where((e) => e.employeeType == 'CAMPO').toList();

  List<RrhhApplicant> get pendingApplicants => _applicants
      .where((a) => a.status == 'NUEVO' || a.status == 'EN_EVALUACION')
      .toList();
  List<RrhhApplicant> get selectedApplicants =>
      _applicants.where((a) => a.status == 'SELECCIONADO').toList();

  List<RrhhLeaveRequest> get pendingLeaves =>
      _leaves.where((l) => l.status == 'PENDIENTE').toList();
  List<RrhhVacationRequest> get pendingVacations =>
      _vacations.where((v) => v.status == 'PENDIENTE').toList();

  // -------------------------------------------------------------
  // DASHBOARD METRICS CALCULADAS
  // -------------------------------------------------------------
  int get totalEmployeesCount => _employees.length;
  int get activeEmployeesCount => activeEmployees.length;
  int get inactiveEmployeesCount => inactiveEmployees.length;
  int get officeEmployeesCount => officeEmployees.length;
  int get fieldEmployeesCount => fieldEmployees.length;
  int get pendingApplicantsCount => pendingApplicants.length;

  int get contractsExpiringSoonCount {
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 45));
    return activeEmployees.where((e) {
      if (e.contractEndDate == null) return false;
      return e.contractEndDate!.isAfter(now) &&
          e.contractEndDate!.isBefore(threshold);
    }).length;
  }

  int get pendingDocumentsEmployeesCount {
    return activeEmployees.where((e) => e.attachedDocumentsCount < 6).length;
  }

  int get unassignedFieldEmployeesCount {
    final activeFieldIds = _assignments
        .where((a) => a.status == 'ACTIVA')
        .map((a) => a.employeeId)
        .toSet();
    return fieldEmployees.where((e) => !activeFieldIds.contains(e.id)).length;
  }

  // -------------------------------------------------------------
  // MÉTODOS DE MUTACIÓN REACTIVOS (POSTULANTES)
  // -------------------------------------------------------------
  void addApplicant(RrhhApplicant applicant) {
    _applicants.insert(0, applicant);
    notifyListeners();
  }

  void updateApplicantStatus(String id, String newStatus, {String? notes}) {
    final index = _applicants.indexWhere((a) => a.id == id);
    if (index != -1) {
      final old = _applicants[index];
      _applicants[index] = old.copyWith(
        status: newStatus,
        interviewNotes: notes ?? old.interviewNotes,
      );
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // CONTRATACIÓN (POSTULANTE SELECCIONADO -> EMPLEADO NUEVO)
  // -------------------------------------------------------------
  RrhhEmployee hireApplicant({
    required RrhhApplicant applicant,
    required String code,
    required String employeeType,
    required String area,
    required String position,
    required String specialty,
    required String workplace,
    required String supervisor,
    required double agreedSalary,
    required String contractType,
    DateTime? contractEndDate,
    required String scheduleName,
    required String observations,
    required String processedBy,
    DateTime? birthDate,
    String? birthPlace,
    String? occupation,
    String? personalReference,
    String? referencePhone,
    DateTime? realStartDate,
    DateTime? fiscalStartDate,
    bool hasCiCopy = true,
    bool hasUtilityBill = true,
    bool hasHomeSketch = true,
    bool hasFelccRecord = false,
    bool hasPhoto3x4 = true,
    bool hasSusInsurance = true,
  }) {
    // 1. Crear nuevo empleado con credenciales temporales generadas
    final cleanName = applicant.fullName.trim();
    final newEmployee = RrhhEmployee(
      id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
      code: code,
      fullName: cleanName,
      birthDate: birthDate ?? applicant.birthDate,
      birthPlace: birthPlace ?? 'Santa Cruz, Bolivia',
      identityCard: applicant.identityCard,
      phone: applicant.phone,
      address: applicant.address,
      occupation: occupation ?? applicant.targetPosition,
      personalReference: personalReference ?? applicant.referencePerson,
      referencePhone: referencePhone ?? applicant.referencePhone,
      employeeType: employeeType,
      area: area,
      position: position,
      specialty: specialty,
      workplace: workplace,
      supervisor: supervisor,
      realStartDate: realStartDate ?? DateTime.now(),
      fiscalStartDate: fiscalStartDate ?? DateTime.now(),
      agreedSalary: agreedSalary,
      contractType: contractType,
      contractEndDate: contractEndDate,
      observations: observations,
      status: 'ACTIVO',
      hasCiCopy: hasCiCopy,
      hasUtilityBill: hasUtilityBill,
      hasHomeSketch: hasHomeSketch,
      hasFelccRecord: hasFelccRecord,
      hasPhoto3x4: hasPhoto3x4,
      hasSusInsurance: hasSusInsurance,
      timeline: [
        RrhhTimelineEvent(
          id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          title: 'Contratación Oficial & Alta en Nómina',
          description:
              'Candidato promovido tras selección. Asignado como $position en $workplace.',
          category: 'CONTRATACION',
          registeredBy: processedBy,
        ),
      ],
    );

    // 2. Insertar a la lista de colaboradores
    _employees.insert(0, newEmployee);

    // 3. Crear asignación laboral inicial
    final newAssignment = RrhhAssignment(
      id: 'asg-${DateTime.now().millisecondsSinceEpoch}',
      employeeId: newEmployee.id,
      employeeName: newEmployee.fullName,
      employeeCode: newEmployee.code,
      employeeType: employeeType,
      officeArea: employeeType == 'OFICINA' ? area : null,
      officePosition: employeeType == 'OFICINA' ? position : null,
      officeDepartmentLeader: employeeType == 'OFICINA' ? supervisor : null,
      clientCompanyName: employeeType == 'CAMPO' ? workplace : null,
      serviceName: employeeType == 'CAMPO' ? specialty : null,
      branchLocation: employeeType == 'CAMPO' ? workplace : null,
      fieldSupervisor: employeeType == 'CAMPO' ? supervisor : null,
      scheduleName: scheduleName,
      startDate: DateTime.now(),
      status: 'ACTIVA',
      notes: 'Asignación generada automáticamente al contratar al colaborador.',
    );
    _assignments.insert(0, newAssignment);

    // 4. Actualizar estado del postulante a CONTRATADO
    updateApplicantStatus(
      applicant.id,
      'CONTRATADO',
      notes: 'Contratado formalmente bajo código $code.',
    );

    // 5. Registrar movimiento laboral inicial
    _movements.insert(
      0,
      RrhhLaborMovement(
        id: 'mov-${DateTime.now().millisecondsSinceEpoch}',
        employeeId: newEmployee.id,
        employeeName: newEmployee.fullName,
        employeeCode: newEmployee.code,
        effectiveDate: DateTime.now(),
        movementType: 'CAMBIO_CARGO',
        previousValue: 'Postulante Seleccionado',
        newValue: '$position ($employeeType)',
        justification: 'Alta y firma de contrato de trabajo inicial.',
        authorizedBy: processedBy,
      ),
    );

    notifyListeners();
    return newEmployee;
  }

  // -------------------------------------------------------------
  // MÉTODOS DE EMPLEADOS (ALTA DIRECTA, EDICIÓN, DESVINCULACIÓN)
  // -------------------------------------------------------------
  void addEmployee(RrhhEmployee employee) {
    _employees.insert(0, employee);
    notifyListeners();
  }

  void updateEmployee(RrhhEmployee employee) {
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _employees[index] = employee;
      notifyListeners();
    }
  }

  void updateEmployeeDocuments({
    required String employeeId,
    required bool hasCiCopy,
    required bool hasUtilityBill,
    required bool hasHomeSketch,
    required bool hasFelccRecord,
    required bool hasPhoto3x4,
    required bool hasSusInsurance,
    String? updatedBy,
  }) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final newTimeline = List<RrhhTimelineEvent>.from(emp.timeline);
      newTimeline.insert(
        0,
        RrhhTimelineEvent(
          id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          title: 'Expediente Físico Actualizado',
          description:
              'Se completaron y verificaron documentos físicos en legajo.',
          category: 'DOCUMENTOS',
          registeredBy: updatedBy ?? 'Lic. Laura Mendoza (RRHH)',
        ),
      );
      _employees[index] = emp.copyWith(
        hasCiCopy: hasCiCopy,
        hasUtilityBill: hasUtilityBill,
        hasHomeSketch: hasHomeSketch,
        hasFelccRecord: hasFelccRecord,
        hasPhoto3x4: hasPhoto3x4,
        hasSusInsurance: hasSusInsurance,
        timeline: newTimeline,
      );
      notifyListeners();
    }
  }

  void terminateEmployee({
    required String employeeId,
    DateTime? exitDate,
    String? exitReason,
    String? reason,
    String? exitObservations,
    String? exitNotes,
    String? exitRegisteredBy,
    String? processedBy,
    double severancePay = 4500.0,
  }) {
    final effectiveExitDate = exitDate ?? DateTime.now();
    final effectiveReason = exitReason ?? reason ?? 'Renuncia voluntaria';
    final effectiveObservations =
        exitObservations ??
        exitNotes ??
        'Desvinculación registrada formalmente.';
    final effectiveProcessedBy =
        exitRegisteredBy ?? processedBy ?? 'Lic. Laura Mendoza (RRHH)';

    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      final emp = _employees[index];
      final newTimeline = List<RrhhTimelineEvent>.from(emp.timeline);
      newTimeline.insert(
        0,
        RrhhTimelineEvent(
          id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
          date: effectiveExitDate,
          title: 'Desvinculación Laboral ($effectiveReason)',
          description: effectiveObservations,
          category: 'DESVINCULACION',
          registeredBy: effectiveProcessedBy,
        ),
      );

      _employees[index] = emp.copyWith(
        status: 'INACTIVO',
        exitDate: effectiveExitDate,
        exitReason: effectiveReason,
        exitObservations: effectiveObservations,
        exitRegisteredBy: effectiveProcessedBy,
        timeline: newTimeline,
      );

      _exits.insert(
        0,
        RrhhExitRecord(
          id: 'exit-${DateTime.now().millisecondsSinceEpoch}',
          employeeId: emp.id,
          employeeName: emp.fullName,
          employeeCode: emp.code,
          exitDate: effectiveExitDate,
          reason: effectiveReason,
          observations: effectiveObservations,
          documentationAttached:
              'Finiquito firmado y acta de entrega de inventario.',
          processedBy: effectiveProcessedBy,
          severancePay: severancePay,
        ),
      );

      // Finalizar asignaciones activas del empleado
      for (int i = 0; i < _assignments.length; i++) {
        if (_assignments[i].employeeId == employeeId &&
            _assignments[i].status == 'ACTIVA') {
          _assignments[i] = _assignments[i].copyWith(
            status: 'FINALIZADA',
            endDate: effectiveExitDate,
            notes:
                '${_assignments[i].notes} - Finalizada por desvinculación laboral.',
          );
        }
      }

      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // ORGANIZACIÓN
  // -------------------------------------------------------------
  void addArea(RrhhArea area) {
    _areas.add(area);
    notifyListeners();
  }

  void addPosition(RrhhPosition position) {
    _positions.add(position);
    notifyListeners();
  }

  void addSpecialty(RrhhSpecialty specialty) {
    _specialties.add(specialty);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // ASIGNACIONES Y HORARIOS
  // -------------------------------------------------------------
  void addAssignment(RrhhAssignment assignment) {
    _assignments.insert(0, assignment);
    notifyListeners();
  }

  void endAssignment(String assignmentId, {String? notes}) {
    final index = _assignments.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(
        status: 'FINALIZADA',
        endDate: DateTime.now(),
        notes: notes ?? _assignments[index].notes,
      );
      notifyListeners();
    }
  }

  /// Obtiene la lista histórica completa de asignaciones y rotaciones de un colaborador,
  /// ordenada cronológicamente (desde el puesto inicial donde empezó hasta el actual).
  List<RrhhAssignment> getRotationHistory(String employeeId) {
    final list = _assignments.where((a) => a.employeeId == employeeId).toList();
    list.sort((a, b) => a.startDate.compareTo(b.startDate));
    return list;
  }

  /// Obtiene la asignación activa vigente de un colaborador (si existe)
  RrhhAssignment? getActiveAssignment(String employeeId) {
    try {
      return _assignments.firstWhere(
        (a) => a.employeeId == employeeId && a.status == 'ACTIVA',
      );
    } catch (_) {
      return null;
    }
  }

  /// Rota a un colaborador a un nuevo destino (empresa/servicio en campo u oficina),
  /// guardando fielmente de dónde partió (origen), el historial sucesivo y motivo.
  void rotateEmployee({
    required String employeeId,
    required String employeeName,
    required String employeeCode,
    required String type,
    String? clientCompanyId,
    String? clientCompanyName,
    String? contractedServiceId,
    String? contractedServiceName,
    String? officeArea,
    String? officeRole,
    String? workplaceBranch,
    required String scheduleName,
    required String supervisorName,
    required String rotationReason,
    String? notes,
    DateTime? effectiveDate,
  }) {
    final now = effectiveDate ?? DateTime.now();

    // 1. Obtener la asignación activa previa para rescatar el origen exacto
    RrhhAssignment? currentActive;
    try {
      currentActive = _assignments.firstWhere(
        (a) => a.employeeId == employeeId && a.status == 'ACTIVA',
      );
    } catch (_) {
      currentActive = null;
    }

    String originText;
    int nextRotationNumber = 1;

    if (currentActive != null) {
      originText = currentActive.fullDestinationSummary;
      nextRotationNumber = currentActive.rotationNumber + 1;
    } else {
      originText = 'Puesto Inicial de Contratación';
      nextRotationNumber = 1;
    }

    // 2. Finalizar la asignación previa guardando fecha de cierre
    for (int i = 0; i < _assignments.length; i++) {
      if (_assignments[i].employeeId == employeeId &&
          _assignments[i].status == 'ACTIVA') {
        _assignments[i] = _assignments[i].copyWith(
          status: 'FINALIZADA',
          endDate: now,
          notes: 'Rotado a nuevo destino: $rotationReason',
        );
      }
    }

    final newDestinationSummary = type == 'OFICINA'
        ? 'Oficina Central: Área ${officeArea ?? "General"} • Cargo: ${officeRole ?? "Operativo"}'
        : 'Empresa: ${clientCompanyName ?? "Cliente"} • Servicio: ${contractedServiceName ?? "General"} • Sede: ${workplaceBranch ?? "Principal"}';

    // 3. Crear y registrar la nueva asignación activa con trazabilidad de origen
    final newAssignment = RrhhAssignment(
      id: 'asg-${DateTime.now().millisecondsSinceEpoch}',
      employeeId: employeeId,
      employeeName: employeeName,
      employeeCode: employeeCode,
      employeeType: type,
      clientCompanyId: clientCompanyId,
      clientCompanyName: clientCompanyName,
      contractedServiceId: contractedServiceId ?? 'svc-01',
      serviceName: contractedServiceName,
      officeArea: officeArea,
      officePosition: officeRole,
      branchLocation:
          workplaceBranch ??
          (type == 'OFICINA' ? 'Oficina Central' : 'Sede Principal'),
      scheduleName: scheduleName,
      fieldSupervisor: supervisorName,
      officeDepartmentLeader: supervisorName,
      originDescription: originText,
      rotationReason: rotationReason,
      rotationNumber: nextRotationNumber,
      startDate: now,
      status: 'ACTIVA',
      notes: notes ?? 'Rotación operativa registrada por RRHH.',
    );

    _assignments.insert(0, newAssignment);

    // 4. Sincronizar el expediente del empleado (workplace, supervisor y timeline)
    final empIndex = _employees.indexWhere((e) => e.id == employeeId);
    if (empIndex != -1) {
      final oldEmp = _employees[empIndex];
      final updatedTimeline = List<RrhhTimelineEvent>.from(oldEmp.timeline);
      updatedTimeline.insert(
        0,
        RrhhTimelineEvent(
          id: 'ev-rot-${DateTime.now().millisecondsSinceEpoch}',
          date: now,
          title: 'Rotación de Personal #$nextRotationNumber',
          description:
              'Traslado desde: $originText → Hacia: $newDestinationSummary. Motivo: $rotationReason.',
          category: 'ASIGNACION',
          registeredBy: supervisorName.isNotEmpty
              ? supervisorName
              : 'RRHH Operaciones',
        ),
      );

      _employees[empIndex] = oldEmp.copyWith(
        workplace:
            workplaceBranch ??
            (type == 'OFICINA'
                ? 'Oficina Central'
                : clientCompanyName ?? oldEmp.workplace),
        supervisor: supervisorName.isNotEmpty
            ? supervisorName
            : oldEmp.supervisor,
        area: officeArea ?? oldEmp.area,
        position: officeRole ?? oldEmp.position,
        timeline: updatedTimeline,
      );
    }

    // 5. Registrar movimiento laboral
    _movements.insert(
      0,
      RrhhLaborMovement(
        id: 'mov-${DateTime.now().millisecondsSinceEpoch}',
        employeeId: employeeId,
        employeeName: employeeName,
        employeeCode: employeeCode,
        effectiveDate: now,
        movementType: type == 'OFICINA'
            ? 'TRANSFERENCIA_SEDE'
            : 'CAMBIO_CLIENTE',
        previousValue: originText,
        newValue: newDestinationSummary,
        justification: rotationReason,
        authorizedBy: 'Lic. Laura Mendoza (RRHH)',
      ),
    );

    notifyListeners();
  }

  void assignEmployee({
    required String employeeId,
    required String employeeName,
    required String employeeCode,
    required String type,
    String? clientCompanyId,
    String? clientCompanyName,
    String? contractedServiceName,
    String? officeArea,
    String? officeRole,
    String? workplaceBranch,
    required String scheduleName,
    required String supervisorName,
    String? rotationReason,
  }) {
    rotateEmployee(
      employeeId: employeeId,
      employeeName: employeeName,
      employeeCode: employeeCode,
      type: type,
      clientCompanyId: clientCompanyId,
      clientCompanyName: clientCompanyName,
      contractedServiceName: contractedServiceName,
      officeArea: officeArea,
      officeRole: officeRole,
      workplaceBranch: workplaceBranch,
      scheduleName: scheduleName,
      supervisorName: supervisorName,
      rotationReason: rotationReason ?? 'Reasignación de funciones',
    );
  }

  void addSchedule(RrhhWorkSchedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void addClientCompany(RrhhClientCompany client) {
    _clients.add(client);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // GESTIÓN LABORAL (PERMISOS, VACACIONES, INCIDENCIAS, MOVIMIENTOS)
  // -------------------------------------------------------------
  void submitLeaveRequest(RrhhLeaveRequest request) {
    _leaves.insert(0, request);
    notifyListeners();
  }

  void requestLeave(RrhhLeaveRequest request) => submitLeaveRequest(request);

  void respondLeaveRequest(
    String id,
    String status, {
    required String approvedBy,
    String? notes,
  }) {
    final index = _leaves.indexWhere((l) => l.id == id);
    if (index != -1) {
      _leaves[index] = _leaves[index].copyWith(
        status: status,
        approvedBy: approvedBy,
        responseDate: DateTime.now(),
        responseNotes: notes,
      );
      notifyListeners();
    }
  }

  void reviewLeave(
    String id,
    String status, {
    String approvedBy = 'Lic. Laura Mendoza (RRHH)',
  }) {
    respondLeaveRequest(id, status, approvedBy: approvedBy);
  }

  void submitVacationRequest(RrhhVacationRequest request) {
    _vacations.insert(0, request);
    notifyListeners();
  }

  void requestVacation(RrhhVacationRequest request) =>
      submitVacationRequest(request);

  void respondVacationRequest(
    String id,
    String status, {
    required String approvedBy,
  }) {
    final index = _vacations.indexWhere((v) => v.id == id);
    if (index != -1) {
      _vacations[index] = _vacations[index].copyWith(
        status: status,
        approvedBy: approvedBy,
      );
      notifyListeners();
    }
  }

  void reviewVacation(
    String id,
    String status, {
    String approvedBy = 'Lic. Laura Mendoza (RRHH)',
  }) {
    respondVacationRequest(id, status, approvedBy: approvedBy);
  }

  void registerIncident(RrhhIncident incident) {
    _incidents.insert(0, incident);
    notifyListeners();
  }

  void addIncident(RrhhIncident incident) => registerIncident(incident);

  void registerMovement(RrhhLaborMovement movement) {
    _movements.insert(0, movement);
    notifyListeners();
  }

  void addMovement(RrhhLaborMovement movement) => registerMovement(movement);
}
