import 'package:serverpod/serverpod.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../exceptions/app_exception.dart';
import '../../../generated/protocol.dart';
import 'rrhh_applicant_repository.dart';

/// Repositorio relacional para la gestión integral del Expediente de Empleados,
/// Contratación transaccional de Postulantes, Documentos Digitales y Línea de Tiempo.
class RrhhPersonnelRepository {
  final Session session;

  const RrhhPersonnelRepository(this.session);

  /// Helper que identifica si un cargo, área o especialidad corresponde a Seguridad Física.
  bool _isSecurityPosition({String? position, String? area, String? specialty}) {
    final combined = '${position ?? ''} ${area ?? ''} ${specialty ?? ''}'.toLowerCase();
    return combined.contains('seguridad') ||
        combined.contains('guardia') ||
        combined.contains('vigilante') ||
        combined.contains('custodio') ||
        combined.contains('sereno');
  }

  /// Helper único que enmascara salario y compensaciones si la sesión carece de rrhh.compensation.view.
  Future<RrhhEmployee> _maskSensitiveCompensation(
    RrhhEmployee employee, {
    Set<String>? userPermissions,
  }) async {
    final canView = await RbacGuard.hasPermission(
      session,
      AppPermissions.rrhhCompensationView,
      userPermissions: userPermissions,
    );
    if (canView) {
      return employee;
    }
    return employee.copyWith(
      agreedSalary: null,
      bonuses: null,
      deductions: null,
    );
  }

  /// Helper único para enmascarar listas de colaboradores.
  Future<List<RrhhEmployee>> _maskSensitiveCompensationList(
    List<RrhhEmployee> employees, {
    Set<String>? userPermissions,
  }) async {
    final canView = await RbacGuard.hasPermission(
      session,
      AppPermissions.rrhhCompensationView,
      userPermissions: userPermissions,
    );
    if (canView) {
      return employees;
    }
    return employees
        .map((e) => e.copyWith(
              agreedSalary: null,
              bonuses: null,
              deductions: null,
            ))
        .toList();
  }

  // ===========================================================================
  // 1. EMPLEADOS / EXPEDIENTES
  // ===========================================================================

  /// Lista empleados con filtros por estado, entorno laboral, disponibilidad o búsqueda textual.
  Future<List<RrhhEmployee>> listEmployees({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    int limit = 100,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    final rows = await RrhhEmployee.db.find(
      session,
      where: (t) {
        var expr = includeDeleted
            ? Constant.bool(true)
            : t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (employeeType != null && employeeType.trim().isNotEmpty) {
          expr =
              expr & t.employeeType.equals(employeeType.trim().toUpperCase());
        }
        if (availabilityStatus != null &&
            availabilityStatus.trim().isNotEmpty) {
          expr =
              expr &
              t.availabilityStatus.equals(
                availabilityStatus.trim().toUpperCase(),
              );
        }
        if (areaId != null) {
          expr = expr & t.areaId.equals(areaId);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr =
              expr &
              (t.fullName.ilike(query) |
                  t.identityCard.ilike(query) |
                  t.code.ilike(query) |
                  t.position.ilike(query) |
                  t.specialty.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.code,
      limit: limit,
      offset: offset,
    );
    return await _maskSensitiveCompensationList(rows);
  }

  /// Obtiene un empleado por su ID.
  Future<RrhhEmployee?> getEmployeeById(
    int id, {
    bool includeDeleted = false,
  }) async {
    final row = await RrhhEmployee.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(id) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
    if (row == null) return null;
    return await _maskSensitiveCompensation(row);
  }

  /// Obtiene un empleado por su código institucional (ej: EMP-001).
  Future<RrhhEmployee?> getEmployeeByCode(
    String code, {
    bool includeDeleted = false,
  }) async {
    final row = await RrhhEmployee.db.findFirstRow(
      session,
      where: (t) =>
          t.code.equals(code.trim().toUpperCase()) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
    if (row == null) return null;
    return await _maskSensitiveCompensation(row);
  }

  /// Genera el siguiente código institucional disponible (EMP-001, EMP-002, etc.).
  Future<String> generateNextEmployeeCode() async {
    final count = await RrhhEmployee.db.count(session);
    var candidate = 'EMP-${(count + 1).toString().padLeft(3, '0')}';
    var existing = await getEmployeeByCode(candidate, includeDeleted: true);
    int counter = count + 1;
    while (existing != null) {
      counter++;
      candidate = 'EMP-${counter.toString().padLeft(3, '0')}';
      existing = await getEmployeeByCode(candidate, includeDeleted: true);
    }
    return candidate;
  }

  /// Crea un empleado formal en el sistema, asegurando código único y registrando evento de contratación.
  Future<RrhhEmployee> createEmployee(
    RrhhEmployee employee, {
    String registeredBy = 'Recursos Humanos',
  }) async {
    final cleanFullName = employee.fullName.trim();
    final cleanCi = employee.identityCard.trim();
    final cleanPhone = employee.phone.trim();

    if (cleanFullName.isEmpty) {
      throw FormatException('El nombre completo del empleado es obligatorio.');
    }
    if (cleanCi.isEmpty) {
      throw FormatException('El documento de identidad (CI) es obligatorio.');
    }
    if (cleanPhone.isEmpty) {
      throw FormatException('El teléfono de contacto es obligatorio.');
    }

    String finalCode = employee.code.trim().toUpperCase();
    if (finalCode.isEmpty || finalCode == 'AUTO' || finalCode == 'EMP-') {
      finalCode = await generateNextEmployeeCode();
    } else {
      final duplicate = await getEmployeeByCode(
        finalCode,
        includeDeleted: true,
      );
      if (duplicate != null) {
        throw FormatException(
          'El código "$finalCode" ya se encuentra asignado a otro empleado.',
        );
      }
    }

    // Correo institucional por defecto si no fue provisto
    String? corporateEmail = employee.corporateEmail?.trim().toLowerCase();
    if (corporateEmail == null || corporateEmail.isEmpty) {
      final nameParts = cleanFullName
          .toLowerCase()
          .replaceAll('á', 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll('ó', 'o')
          .replaceAll('ú', 'u')
          .replaceAll('ñ', 'n')
          .split(RegExp(r'\s+'));
      if (nameParts.length >= 2) {
        corporateEmail =
            '${nameParts.first}.${nameParts.last}@elitemultiservicios.com';
      } else {
        corporateEmail = '${nameParts.first}@elitemultiservicios.com';
      }
    }

    final isSecurity = _isSecurityPosition(
      position: employee.position,
      area: employee.area,
      specialty: employee.specialty,
    );
    if (isSecurity) {
      final felccDocValid = employee.documentChecklist?.any(
            (d) =>
                d.code.toUpperCase() == 'FELCC' &&
                d.status.toLowerCase() == 'validado',
          ) ??
          false;
      if (!felccDocValid) {
        throw ValidationException(
          'El Certificado FELCC es obligatorio para cargos de seguridad.',
        );
      }
    }

    final now = DateTime.now().toUtc();
    final toInsert = employee.copyWith(
      code: finalCode,
      fullName: cleanFullName,
      identityCard: cleanCi,
      phone: cleanPhone,
      corporateEmail: corporateEmail,
      status: employee.status.trim().toUpperCase(),
      employeeType: employee.employeeType.trim().toUpperCase(),
      availabilityStatus: employee.availabilityStatus.trim().toUpperCase(),
      paymentModality: employee.paymentModality.trim().toUpperCase(),
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    final inserted = await RrhhEmployee.db.insertRow(session, toInsert);

    // Registrar hito de contratación en la línea de tiempo
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: inserted.id!,
        date: employee.realStartDate,
        title: 'Contratación e incorporación en nómina',
        description:
            'Incorporación formal como ${employee.position} en modalidad ${employee.contractType}. Sueldo base: Bs. ${(employee.agreedSalary ?? 0.0).toStringAsFixed(2)}.',
        category: 'CONTRATACION',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(inserted);
  }

  /// Actualiza los datos laborales o personales del empleado.
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee) async {
    final existing = await getEmployeeById(employee.id!);
    if (existing == null) {
      throw FormatException('El colaborador solicitado no existe.');
    }

    final now = DateTime.now().toUtc();
    final toUpdate = employee.copyWith(
      fullName: employee.fullName.trim(),
      identityCard: employee.identityCard.trim(),
      phone: employee.phone.trim(),
      status: employee.status.trim().toUpperCase(),
      employeeType: employee.employeeType.trim().toUpperCase(),
      availabilityStatus: employee.availabilityStatus.trim().toUpperCase(),
      paymentModality: employee.paymentModality.trim().toUpperCase(),
      updatedAt: now,
    );

    final updated = await RrhhEmployee.db.updateRow(session, toUpdate);
    return await _maskSensitiveCompensation(updated);
  }

  /// Contratación transaccional de un Postulante Seleccionado.
  Future<RrhhEmployee> hireApplicant({
    required int applicantId,
    required DateTime realStartDate,
    required DateTime fiscalStartDate,
    required double agreedSalary,
    required String contractType,
    DateTime? contractEndDate,
    String? observations,
    String? workplace,
    String? supervisor,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final applicantRepo = RrhhRecruitmentRepository(session);
    final applicant = await applicantRepo.getApplicantById(applicantId);
    if (applicant == null) {
      throw FormatException('El postulante especificado no existe.');
    }

    if (applicant.status == 'CONTRATADO') {
      throw FormatException('Este postulante ya fue contratado previamente.');
    }

    final employeeCode = await generateNextEmployeeCode();

    final newEmployee = RrhhEmployee(
      code: employeeCode,
      fullName: applicant.fullName,
      birthDate: applicant.birthDate,
      birthPlace: 'Santa Cruz de la Sierra',
      identityCard: applicant.identityCard,
      phone: applicant.phone,
      address: applicant.address ?? 'Sin dirección registrada',
      occupation: applicant.specialty ?? 'Personal Operativo',
      personalReference: applicant.referencePerson ?? 'Referencia personal',
      referencePhone: applicant.referencePhone ?? applicant.phone,
      employeeType: applicant.targetType,
      area: applicant.targetArea ?? 'Operaciones',
      areaId: applicant.areaId,
      position: applicant.targetPosition ?? 'Operario',
      positionId: applicant.positionId,
      specialty: applicant.specialty ?? 'General',
      specialtyId: applicant.specialtyId,
      workplace: workplace ?? 'Sede Principal / A definir',
      supervisor: supervisor ?? 'Encargada de RRHH',
      realStartDate: realStartDate,
      fiscalStartDate: fiscalStartDate,
      agreedSalary: agreedSalary,
      contractType: contractType,
      contractEndDate: contractEndDate,
      observations:
          observations ?? 'Contratado desde pipeline de reclutamiento.',
      status: 'ACTIVO',
      availabilityStatus: 'DISPONIBLE',
      paymentModality: 'MENSUAL',
      workScheduleType: 'TIEMPO_COMPLETO_48H',
      hasCiCopy: applicant.hasIdentityCardCopy,
      applicantId: applicant.id,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final createdEmployee = await createEmployee(
      newEmployee,
      registeredBy: registeredBy,
    );

    // Marcar postulante como 'CONTRATADO'
    await applicantRepo.updateApplicantStatus(
      applicant.id!,
      newStatus: 'CONTRATADO',
      interviewNotes: 'Contratado formalmente bajo el código $employeeCode.',
    );

    return createdEmployee;
  }

  /// Actualiza el estado de disponibilidad del personal para Operaciones.
  Future<RrhhEmployee> updateAvailabilityStatus(
    int id, {
    required String newAvailabilityStatus,
  }) async {
    final existing = await getEmployeeById(id);
    if (existing == null) {
      throw FormatException('El colaborador solicitado no existe.');
    }

    final valid = [
      'DISPONIBLE',
      'ASIGNADO',
      'DE_VACACIONES',
      'CON_PERMISO',
      'SUSPENDIDO',
    ];
    final normalized = newAvailabilityStatus.trim().toUpperCase();
    if (!valid.contains(normalized)) {
      throw FormatException(
        'Estado de disponibilidad no válido: $newAvailabilityStatus',
      );
    }

    final toUpdate = existing.copyWith(
      availabilityStatus: normalized,
      updatedAt: DateTime.now().toUtc(),
    );

    return await RrhhEmployee.db.updateRow(session, toUpdate);
  }

  /// Desvinculación de un trabajador: pasa a INACTIVO sin borrado físico, conservando todo su historial.
  Future<RrhhEmployee> terminateEmployee(
    int id, {
    required DateTime exitDate,
    required String exitReason,
    String? exitObservations,
    required String registeredBy,
  }) async {
    final existing = await getEmployeeById(id);
    if (existing == null) {
      throw FormatException('El colaborador solicitado no existe.');
    }

    final now = DateTime.now().toUtc();
    final toUpdate = existing.copyWith(
      status: 'INACTIVO',
      availabilityStatus: 'SUSPENDIDO',
      exitDate: exitDate,
      exitReason: exitReason.trim(),
      exitObservations: exitObservations?.trim(),
      exitRegisteredBy: registeredBy.trim(),
      updatedAt: now,
    );

    final updated = await RrhhEmployee.db.updateRow(session, toUpdate);

    // Registrar hito de desvinculación en la línea de tiempo
    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: exitDate,
        title: 'Desvinculación laboral',
        description: 'Motivo: $exitReason. ${exitObservations ?? ""}'.trim(),
        category: 'DESVINCULACION',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return updated;
  }

  /// Soft delete administrativo (en caso de error de digitación).
  Future<bool> deleteEmployee(int id) async {
    final existing = await getEmployeeById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhEmployee.db.updateRow(
      session,
      existing.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    return true;
  }

  // ===========================================================================
  // 1.1 FASE B: ACTUALIZACIONES GRANULARES Y EXPOSICIÓN CONTRACTUAL
  // ===========================================================================

  /// Obtiene el resumen contractual y salarial de un empleado para exposición a Contabilidad.
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    return RrhhEmployeeContractData(
      employeeId: employee.id ?? id,
      code: employee.code,
      fullName: employee.fullName,
      status: employee.status,
      contractType: employee.contractType,
      baseSalary: employee.agreedSalary,
      paymentModality: employee.paymentModality,
      workdayType: employee.workdayType,
      bonuses: employee.bonuses,
      deductions: employee.deductions,
      contractStartDate: employee.contractStartDate ?? employee.realStartDate,
      contractEndDate: employee.contractEndDate,
      terminationDate: employee.exitDate,
    );
  }

  /// Actualiza los datos de cuenta y entidad bancaria del empleado.
  Future<RrhhEmployee> updateEmployeeBankInfo({
    required int id,
    String? bankName,
    String? accountType,
    String? accountNumber,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      bankName: bankName,
      accountType: accountType,
      accountNumber: accountNumber,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de datos bancarios',
        description:
            'Actualización de datos bancarios: Banco ${bankName ?? "N/A"}, Cuenta ${accountNumber ?? "N/A"} (${accountType ?? "N/A"}).',
        category: 'CONTRATO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza la información de seguridad social (AFP, CNS, etc.).
  Future<RrhhEmployee> updateEmployeeSocialSecurity({
    required int id,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      afpName: afpName,
      afpNumber: afpNumber,
      healthInsurance: healthInsurance,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de seguridad social',
        description:
            'Actualización de seguridad social: AFP ${afpName ?? "N/A"} (#${afpNumber ?? "N/A"}), Seguro: ${healthInsurance ?? "N/A"}.',
        category: 'CONTRATO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza los datos personales complementarios y contacto de emergencia.
  Future<RrhhEmployee> updateEmployeePersonalInfo({
    required int id,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      fullAddress: fullAddress,
      address: fullAddress ?? employee.address,
      maritalStatus: maritalStatus,
      childrenCount: childrenCount,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de datos personales',
        description:
            'Actualización de datos personales complementarios y contactos de emergencia.',
        category: 'PERSONAL',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza las condiciones contractuales y salariales del empleado.
  Future<RrhhEmployee> updateEmployeeContract({
    required int id,
    required String justification,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    String registeredBy = 'Recursos Humanos',
  }) async {
    // Validación 3.2: Justificación obligatoria >= 20 caracteres
    if (justification.trim().length < 20) {
      throw ValidationException(
        'La justificación debe tener al menos 20 caracteres.',
      );
    }

    // Validación 3.1: Fecha efectiva <= 30 días desde hoy
    final maxFuture = DateTime.now().toUtc().add(const Duration(days: 30));
    final checkDate = contractStartDate;
    if (checkDate != null && checkDate.isAfter(maxFuture)) {
      throw ValidationException(
        'La fecha efectiva no puede superar los 30 días desde hoy.',
      );
    }

    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      contractType: contractType,
      workdayType: workdayType,
      paymentModality: paymentModality,
      agreedSalary: baseSalary ?? employee.agreedSalary,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      contractSignedPdfUrl: contractSignedPdfUrl,
      bonuses: bonuses,
      deductions: deductions,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de datos contractuales',
        description:
            'Actualización contractual: Modalidad ${contractType ?? employee.contractType}, Jornada ${workdayType ?? employee.workdayType}, Sueldo Bs. ${(baseSalary ?? employee.agreedSalary ?? 0.0).toStringAsFixed(2)}. Justificación: ${justification.trim()}',
        category: 'CONTRATO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza la lista de bonificaciones asignadas al colaborador.
  Future<RrhhEmployee> updateEmployeeBonuses({
    required int id,
    required List<RrhhEmployeeBonus> bonuses,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      bonuses: bonuses,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de bonificaciones',
        description:
            'Actualización de ${bonuses.length} bonificaciones asignadas al colaborador.',
        category: 'CONTRATO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza la lista de deducciones asignadas al colaborador.
  Future<RrhhEmployee> updateEmployeeDeductions({
    required int id,
    required List<RrhhEmployeeDeduction> deductions,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      deductions: deductions,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de deducciones',
        description:
            'Actualización de ${deductions.length} deducciones asignadas al colaborador.',
        category: 'CONTRATO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza la asignación operativa, base y supervisor del colaborador.
  Future<RrhhEmployee> updateEmployeeAssignment({
    required int id,
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      shiftId: shiftId,
      baseLocation: baseLocation,
      supervisorEmployeeId: supervisorEmployeeId,
      workplace: baseLocation ?? employee.workplace,
      supervisor: supervisorEmployeeId ?? employee.supervisor,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de asignación organizacional',
        description:
            'Actualización de asignación: Turno ${shiftId ?? "N/A"}, Base ${baseLocation ?? "N/A"}, Supervisor ${supervisorEmployeeId ?? "N/A"}.',
        category: 'MOVIMIENTO',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// Actualiza el checklist de documentación entregada por el empleado.
  Future<RrhhEmployee> updateEmployeeDocuments({
    required int id,
    required List<RrhhDossierDocument> documentChecklist,
    String registeredBy = 'Recursos Humanos',
  }) async {
    final employee = await getEmployeeById(id);
    if (employee == null) {
      throw EntityNotFoundException('RrhhEmployee', id);
    }

    final now = DateTime.now().toUtc();
    final updated = employee.copyWith(
      documentChecklist: documentChecklist,
      updatedAt: now,
    );

    final saved = await RrhhEmployee.db.updateRow(session, updated);

    await RrhhTimelineEvent.db.insertRow(
      session,
      RrhhTimelineEvent(
        employeeId: id,
        date: now,
        title: 'Actualización de checklist documental',
        description:
            'Actualización de checklist documental (${documentChecklist.length} documentos registrados).',
        category: 'PERSONAL',
        registeredBy: registeredBy,
        createdAt: now,
      ),
    );

    return await _maskSensitiveCompensation(saved);
  }

  /// TAREA 4: Lista resumida y paginada de colaboradores para el Directorio de Personal.
  /// No incluye campos sensibles salariales ni bancarios.
  Future<List<RrhhEmployeeSummaryDto>> listEmployeeSummaries({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    final rows = await RrhhEmployee.db.find(
      session,
      where: (t) {
        var expr = includeDeleted
            ? Constant.bool(true)
            : t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (employeeType != null && employeeType.trim().isNotEmpty) {
          expr =
              expr & t.employeeType.equals(employeeType.trim().toUpperCase());
        }
        if (availabilityStatus != null &&
            availabilityStatus.trim().isNotEmpty) {
          expr =
              expr &
              t.availabilityStatus.equals(
                availabilityStatus.trim().toUpperCase(),
              );
        }
        if (areaId != null) {
          expr = expr & t.areaId.equals(areaId);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr =
              expr &
              (t.fullName.ilike(query) |
                  t.identityCard.ilike(query) |
                  t.code.ilike(query) |
                  t.position.ilike(query) |
                  t.specialty.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.code,
      limit: limit,
      offset: offset,
    );

    return rows
        .map(
          (e) => RrhhEmployeeSummaryDto(
            id: e.id!,
            code: e.code,
            fullName: e.fullName,
            identityCard: e.identityCard,
            phone: e.phone,
            employeeType: e.employeeType,
            area: e.area,
            position: e.position,
            workplace: e.workplace,
            status: e.status,
            availabilityStatus: e.availabilityStatus,
            hireDate: e.realStartDate,
            photoUrl: e.photoUrl,
          ),
        )
        .toList();
  }

  /// TAREA 4: Retorna el conteo total de empleados coincidentes con los filtros especificados.
  Future<int> countEmployees({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    bool includeDeleted = false,
  }) async {
    return await RrhhEmployee.db.count(
      session,
      where: (t) {
        var expr = includeDeleted
            ? Constant.bool(true)
            : t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (employeeType != null && employeeType.trim().isNotEmpty) {
          expr =
              expr & t.employeeType.equals(employeeType.trim().toUpperCase());
        }
        if (availabilityStatus != null &&
            availabilityStatus.trim().isNotEmpty) {
          expr =
              expr &
              t.availabilityStatus.equals(
                availabilityStatus.trim().toUpperCase(),
              );
        }
        if (areaId != null) {
          expr = expr & t.areaId.equals(areaId);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr =
              expr &
              (t.fullName.ilike(query) |
                  t.identityCard.ilike(query) |
                  t.code.ilike(query) |
                  t.position.ilike(query) |
                  t.specialty.ilike(query));
        }
        return expr;
      },
    );
  }

  // ===========================================================================
  // 2. DOCUMENTOS ADJUNTOS AL EXPEDIENTE
  // ===========================================================================

  /// Lista los documentos adjuntos de un empleado.
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId) async {
    return await RrhhEmployeeDocument.db.find(
      session,
      where: (t) => t.employeeId.equals(employeeId),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Agrega un documento digital al expediente.
  Future<RrhhEmployeeDocument> addDocument(
    RrhhEmployeeDocument document,
  ) async {
    final now = DateTime.now().toUtc();
    return await RrhhEmployeeDocument.db.insertRow(
      session,
      document.copyWith(createdAt: now, updatedAt: now),
    );
  }

  /// Elimina un documento del expediente.
  Future<bool> deleteDocument(int documentId) async {
    final doc = await RrhhEmployeeDocument.db.findById(session, documentId);
    if (doc == null) return false;
    await RrhhEmployeeDocument.db.deleteRow(session, doc);
    return true;
  }

  // ===========================================================================
  // 3. LÍNEA DE TIEMPO / HISTORIAL LABORAL
  // ===========================================================================

  /// Lista los hitos históricos de un colaborador ordenados cronológicamente.
  Future<List<RrhhTimelineEvent>> listTimelineEvents(int employeeId) async {
    return await RrhhTimelineEvent.db.find(
      session,
      where: (t) => t.employeeId.equals(employeeId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Agrega un hito manual a la línea de tiempo del empleado.
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event) async {
    final now = DateTime.now().toUtc();
    return await RrhhTimelineEvent.db.insertRow(
      session,
      event.copyWith(createdAt: now),
    );
  }

  // ===========================================================================
  // 4. SEEDER DE EMPLEADOS INICIALES
  // ===========================================================================

  /// Sembrado inicial de colaboradores si la base de datos se encuentra vacía.
  Future<void> seedInitialEmployees() async {
    final count = await RrhhEmployee.db.count(session);
    if (count > 0) return;

    final now = DateTime.now().toUtc();

    final defaultEmployees = [
      // 1. EMP-001 (Campo - Operaciones)
      RrhhEmployee(
        code: 'EMP-001',
        fullName: 'Carlos Mendoza Rios',
        birthDate: DateTime.utc(1989, 5, 12),
        birthPlace: 'Santa Cruz de la Sierra',
        identityCard: '5829104 SCZ',
        phone: '+591 71029384',
        address: 'Barrio Hamacas Calle 4 #120',
        occupation: 'Técnico Especialista en Mantenimiento',
        personalReference: 'Roberto Mendoza (Hermano)',
        referencePhone: '+591 71099881',
        employeeType: 'CAMPO',
        area: 'Operaciones',
        position: 'Técnico de Mantenimiento',
        specialty: 'Mantenimiento Electromecánico',
        workplace: 'Kolping - Central',
        supervisor: 'Ricardo Montaño Justiniano',
        realStartDate: DateTime.utc(2022, 3, 1),
        fiscalStartDate: DateTime.utc(2022, 3, 1),
        agreedSalary: 4500.0,
        contractType: 'Indefinido',
        observations: 'Técnico líder de cuadrilla electromecánica.',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        paymentModality: 'MENSUAL',
        workScheduleType: 'TIEMPO_COMPLETO_48H',
        hasCiCopy: true,
        hasUtilityBill: true,
        hasHomeSketch: true,
        hasFelccRecord: true,
        hasPhoto3x4: true,
        hasSusInsurance: true,
        corporateEmail: 'carlos.mendoza@elitemultiservicios.com',
        createdAt: now,
        updatedAt: now,
      ),

      // 2. EMP-002 (Campo - Jardinería)
      RrhhEmployee(
        code: 'EMP-002',
        fullName: 'Jorge Luis Aguilera Paredes',
        birthDate: DateTime.utc(1994, 9, 23),
        birthPlace: 'Montero, Santa Cruz',
        identityCard: '6291048 SCZ',
        phone: '+591 72109483',
        address: 'Villa 1ro de Mayo Calle 9 #34',
        occupation: 'Jardinero Profesional',
        personalReference: 'Rosa Paredes (Madre)',
        referencePhone: '+591 72199002',
        employeeType: 'CAMPO',
        area: 'Operaciones',
        position: 'Jardinero',
        specialty: 'Jardinería & Paisajismo',
        workplace: 'Ventura Mall - Principal',
        supervisor: 'Ricardo Montaño Justiniano',
        realStartDate: DateTime.utc(2022, 6, 15),
        fiscalStartDate: DateTime.utc(2022, 6, 15),
        agreedSalary: 2800.0,
        contractType: 'Indefinido',
        observations:
            'Especialista en podado artístico y mantenimiento de césped.',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        paymentModality: 'MENSUAL',
        workScheduleType: 'TIEMPO_COMPLETO_48H',
        hasCiCopy: true,
        hasUtilityBill: true,
        hasHomeSketch: true,
        hasFelccRecord: true,
        hasPhoto3x4: true,
        hasSusInsurance: true,
        corporateEmail: 'jorge.aguilera@elitemultiservicios.com',
        createdAt: now,
        updatedAt: now,
      ),

      // 3. EMP-003 (Campo - Limpieza)
      RrhhEmployee(
        code: 'EMP-003',
        fullName: 'Miguel Ángel Vargas Flores',
        birthDate: DateTime.utc(1991, 11, 30),
        birthPlace: 'Santa Cruz de la Sierra',
        identityCard: '7102934 SCZ',
        phone: '+591 73291048',
        address: 'Plan 3000, Barrio San Luis',
        occupation: 'Operario de Limpieza y Desinfección',
        personalReference: 'Ana Flores (Madre)',
        referencePhone: '+591 73299100',
        employeeType: 'CAMPO',
        area: 'Operaciones',
        position: 'Operario de Limpieza',
        specialty: 'Limpieza e Higiene Hospitalaria/Industrial',
        workplace: 'Kolping - Central',
        supervisor: 'Ricardo Montaño Justiniano',
        realStartDate: DateTime.utc(2023, 1, 10),
        fiscalStartDate: DateTime.utc(2023, 1, 10),
        agreedSalary: 2600.0,
        contractType: 'Indefinido',
        observations: 'Capacitado en manejo de pulidoras industriales.',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        paymentModality: 'MENSUAL',
        workScheduleType: 'TIEMPO_COMPLETO_48H',
        hasCiCopy: true,
        hasUtilityBill: true,
        hasHomeSketch: true,
        hasFelccRecord: true,
        hasPhoto3x4: true,
        hasSusInsurance: true,
        corporateEmail: 'miguel.vargas@elitemultiservicios.com',
        createdAt: now,
        updatedAt: now,
      ),

      // 4. EMP-004 (Oficina - Recursos Humanos)
      RrhhEmployee(
        code: 'EMP-004',
        fullName: 'Paola Andrea Torrico Vaca',
        birthDate: DateTime.utc(1993, 7, 8),
        birthPlace: 'Santa Cruz de la Sierra',
        identityCard: '6829104 SCZ',
        phone: '+591 75018294',
        address: 'Equipetrol Calle 7 #88',
        occupation: 'Licenciada en Recursos Humanos y Psicología Laboral',
        personalReference: 'Javier Torrico (Hermano)',
        referencePhone: '+591 75099112',
        employeeType: 'OFICINA',
        area: 'Recursos Humanos',
        position: 'Encargada de Recursos Humanos',
        specialty: 'Gestión del Talento',
        workplace: 'Oficina Central Elite Multiservicios',
        supervisor: 'Gerente General',
        realStartDate: DateTime.utc(2021, 8, 1),
        fiscalStartDate: DateTime.utc(2021, 8, 1),
        agreedSalary: 4500.0,
        contractType: 'Indefinido',
        observations: 'Encargada titular de RRHH y Bienestar Laboral.',
        status: 'ACTIVO',
        availabilityStatus: 'ASIGNADO',
        paymentModality: 'MENSUAL',
        workScheduleType: 'HORARIO_OFICINA',
        hasCiCopy: true,
        hasUtilityBill: true,
        hasHomeSketch: true,
        hasFelccRecord: true,
        hasPhoto3x4: true,
        hasSusInsurance: true,
        corporateEmail: 'paola.torrico@elitemultiservicios.com',
        createdAt: now,
        updatedAt: now,
      ),

      // 5. EMP-005 (Inactivo / Desvinculado para probar que el historial no se borra)
      RrhhEmployee(
        code: 'EMP-005',
        fullName: 'Héctor Baldivieso Ramos',
        birthDate: DateTime.utc(1987, 4, 15),
        birthPlace: 'Cochabamba',
        identityCard: '5192834 CBBA',
        phone: '+591 76019284',
        address: 'Km 6 Doble Vía La Guardia',
        occupation: 'Guardia de Seguridad',
        personalReference: 'Raúl Baldivieso (Padre)',
        referencePhone: '+591 76000192',
        employeeType: 'CAMPO',
        area: 'Operaciones',
        position: 'Guardia de Seguridad',
        specialty: 'Seguridad Física & CCTV',
        workplace: 'Kolping - Central',
        supervisor: 'Ricardo Montaño Justiniano',
        realStartDate: DateTime.utc(2023, 2, 1),
        fiscalStartDate: DateTime.utc(2023, 2, 1),
        agreedSalary: 2800.0,
        contractType: 'Plazo Fijo',
        contractEndDate: DateTime.utc(2024, 2, 1),
        observations:
            'Conclusión de contrato a plazo fijo con finiquito visado.',
        status: 'INACTIVO',
        availabilityStatus: 'SUSPENDIDO',
        paymentModality: 'MENSUAL',
        workScheduleType: 'TIEMPO_COMPLETO_48H',
        hasCiCopy: true,
        hasUtilityBill: true,
        hasHomeSketch: true,
        hasFelccRecord: true,
        hasPhoto3x4: true,
        hasSusInsurance: true,
        corporateEmail: 'hector.baldivieso@elitemultiservicios.com',
        exitDate: DateTime.utc(2024, 2, 1),
        exitReason: 'Conclusión regular de contrato a plazo fijo',
        exitObservations:
            'Entrega de uniforme y liquidación de beneficios sociales cancelada.',
        exitRegisteredBy: 'Paola Andrea Torrico Vaca',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final emp in defaultEmployees) {
      final inserted = await RrhhEmployee.db.insertRow(session, emp);

      // Crear hito inicial de contratación
      await RrhhTimelineEvent.db.insertRow(
        session,
        RrhhTimelineEvent(
          employeeId: inserted.id!,
          date: emp.realStartDate,
          title: 'Contratación e incorporación en nómina',
          description:
              'Incorporación formal como ${emp.position} en modalidad ${emp.contractType}.',
          category: 'CONTRATACION',
          registeredBy: 'Recursos Humanos',
          createdAt: now,
        ),
      );

      // Si es inactivo, crear hito de salida
      if (emp.status == 'INACTIVO' && emp.exitDate != null) {
        await RrhhTimelineEvent.db.insertRow(
          session,
          RrhhTimelineEvent(
            employeeId: inserted.id!,
            date: emp.exitDate!,
            title: 'Desvinculación laboral',
            description:
                'Motivo: ${emp.exitReason}. ${emp.exitObservations ?? ""}'
                    .trim(),
            category: 'DESVINCULACION',
            registeredBy: emp.exitRegisteredBy ?? 'Recursos Humanos',
            createdAt: now,
          ),
        );
      }
    }
  }
}
