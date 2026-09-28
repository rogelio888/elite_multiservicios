import 'package:serverpod/serverpod.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../exceptions/app_exception.dart';
import '../../../generated/protocol.dart';

/// Repositorio para la administración integral del Expediente de Contratación (RrhhHiringDossier).
/// Conecta la etapa SELECCIONADO de Postulantes con el alta definitiva en Nómina de Empleados.
class RrhhHiringRepository {
  final Session session;

  const RrhhHiringRepository(this.session);

  /// Helper que identifica si un cargo, área o especialidad corresponde a Seguridad Física.
  bool _isSecurityPosition({
    String? position,
    String? area,
    String? specialty,
  }) {
    final combined = '${position ?? ''} ${area ?? ''} ${specialty ?? ''}'
        .toLowerCase();
    return combined.contains('seguridad') ||
        combined.contains('guardia') ||
        combined.contains('vigilante') ||
        combined.contains('custodio') ||
        combined.contains('sereno');
  }

  /// Helper que enmascara salario y compensaciones si la sesión carece de rrhh.compensation.view.
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

  /// Construye el checklist estándar adaptado a CAMPO vs OFICINA y según el cargo.
  List<RrhhDossierDocument> _buildDefaultChecklist({
    required String workplaceType,
    required String targetPosition,
    Map<String, bool>? recruitmentValidatedDocs,
  }) {
    final isCampo = workplaceType.toUpperCase() == 'CAMPO';
    final posLower = targetPosition.toLowerCase();
    final isSecurity = _isSecurityPosition(position: targetPosition);
    final isProfessional =
        posLower.contains('lic') ||
        posLower.contains('ing') ||
        posLower.contains('contador') ||
        posLower.contains('abogad') ||
        posLower.contains('jefe') ||
        posLower.contains('coordinador') ||
        posLower.contains('analista');
    final requiresDriver =
        posLower.contains('chofer') ||
        posLower.contains('conductor') ||
        posLower.contains('mensajero') ||
        posLower.contains('móvil') ||
        posLower.contains('movil');

    final felccRequired = isCampo || isSecurity;

    return [
      RrhhDossierDocument(
        code: 'CI',
        name: 'Fotocopia de Cédula de Identidad',
        isRequired: true,
        status: (recruitmentValidatedDocs?['CI'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['CI'] == true,
      ),
      RrhhDossierDocument(
        code: 'AVISO',
        name: 'Aviso de luz o agua',
        isRequired: true,
        status: (recruitmentValidatedDocs?['AVISO'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['AVISO'] == true,
      ),
      RrhhDossierDocument(
        code: 'CROQUIS',
        name: 'Croquis domiciliario',
        isRequired: true,
        status: (recruitmentValidatedDocs?['CROQUIS'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['CROQUIS'] == true,
      ),
      RrhhDossierDocument(
        code: 'FOTO',
        name: 'Foto 3x4 fondo rojo',
        isRequired: true,
        status: (recruitmentValidatedDocs?['FOTO'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['FOTO'] == true,
      ),
      RrhhDossierDocument(
        code: 'SUS',
        name: 'Constancia SUS',
        isRequired: true,
        status: (recruitmentValidatedDocs?['SUS'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['SUS'] == true,
      ),
      RrhhDossierDocument(
        code: 'FELCC',
        name: 'Certificado FELCC',
        isRequired: felccRequired,
        status: (recruitmentValidatedDocs?['FELCC'] == true)
            ? 'validado'
            : 'pendiente',
        validatedInRecruitment: recruitmentValidatedDocs?['FELCC'] == true,
      ),
      RrhhDossierDocument(
        code: 'TITULO',
        name: 'Título profesional',
        isRequired: isProfessional,
        status: 'pendiente',
      ),
      RrhhDossierDocument(
        code: 'LICENCIA',
        name: 'Licencia de conducir',
        isRequired: requiresDriver,
        status: 'pendiente',
      ),
    ];
  }

  /// Genera el siguiente código correlativo para expedientes (DOS-001, DOS-002, ...).
  Future<String> generateNextDossierCode({Transaction? transaction}) async {
    final count = await RrhhHiringDossier.db.count(
      session,
      transaction: transaction,
    );
    String candidate = 'DOS-${(count + 1).toString().padLeft(3, '0')}';
    var existing = await RrhhHiringDossier.db.findFirstRow(
      session,
      where: (t) => t.code.equals(candidate),
      transaction: transaction,
    );
    int counter = count + 1;
    while (existing != null) {
      counter++;
      candidate = 'DOS-${counter.toString().padLeft(3, '0')}';
      existing = await RrhhHiringDossier.db.findFirstRow(
        session,
        where: (t) => t.code.equals(candidate),
        transaction: transaction,
      );
    }
    return candidate;
  }

  /// Genera el siguiente código correlativo para empleados (EMP-001, EMP-002, ...).
  Future<String> generateNextEmployeeCode({Transaction? transaction}) async {
    final count = await RrhhEmployee.db.count(
      session,
      transaction: transaction,
    );
    String candidate = 'EMP-${(count + 1).toString().padLeft(3, '0')}';
    var existing = await RrhhEmployee.db.findFirstRow(
      session,
      where: (t) => t.code.equals(candidate),
      transaction: transaction,
    );
    int counter = count + 1;
    while (existing != null) {
      counter++;
      candidate = 'EMP-${counter.toString().padLeft(3, '0')}';
      existing = await RrhhEmployee.db.findFirstRow(
        session,
        where: (t) => t.code.equals(candidate),
        transaction: transaction,
      );
    }
    return candidate;
  }

  /// 1. Crea un nuevo expediente de contratación para un postulante.
  /// Valida existencia del postulante y que no tenga ya un expediente activo.
  Future<RrhhHiringDossier> createDossier({
    required int applicantId,
    required String createdBy,
  }) async {
    final applicant = await RrhhApplicant.db.findFirstRow(
      session,
      where: (t) => t.id.equals(applicantId) & t.isDeleted.equals(false),
    );
    if (applicant == null) {
      throw EntityNotFoundException('RrhhApplicant', applicantId);
    }

    final activeDossier = await getDossierByApplicantId(applicantId);
    if (activeDossier != null) {
      throw ConflictException(
        'Ya existe un expediente activo (${activeDossier.code}) para este postulante.',
      );
    }

    final code = await generateNextDossierCode();
    final now = DateTime.now().toUtc();

    final defaultDocs = _buildDefaultChecklist(
      workplaceType: applicant.targetType,
      targetPosition: applicant.targetPosition ?? 'Operario',
      recruitmentValidatedDocs: {
        if (applicant.hasIdentityCardCopy) 'CI': true,
      },
    );

    final toInsert = RrhhHiringDossier(
      code: code,
      applicantId: applicant.id,
      applicantCode: applicant.code,
      applicantName: applicant.fullName,
      status: 'abierto',
      section1Status: 'pendiente',
      section2Status: 'pendiente',
      section3Status: 'pendiente',
      section4Status: 'pendiente',
      section5Status: 'pendiente',
      section6Status: 'pendiente',
      documentChecklist: defaultDocs,
      areaId: applicant.areaId,
      positionId: applicant.positionId,
      baseLocation: applicant.targetType,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await RrhhHiringDossier.db.insertRow(session, toInsert);
  }

  /// 2. Obtiene un expediente por su ID si no está eliminado.
  Future<RrhhHiringDossier?> getDossierById(int id) async {
    return await RrhhHiringDossier.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// 3. Obtiene el expediente activo de un postulante (no convertido, no cancelado y no eliminado).
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId) async {
    return await RrhhHiringDossier.db.findFirstRow(
      session,
      where: (t) =>
          t.applicantId.equals(applicantId) &
          t.isDeleted.equals(false) &
          t.status.notEquals('convertido') &
          t.status.notEquals('cancelado'),
    );
  }

  /// 4. Lista expedientes activos con filtros y paginación.
  Future<List<RrhhHiringDossier>> listActiveDossiers({
    String? search,
    String? status,
    int? limit,
    int? offset,
  }) async {
    return await RrhhHiringDossier.db.find(
      session,
      where: (t) {
        var expr = t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toLowerCase());
        } else {
          expr =
              expr &
              t.status.notEquals('convertido') &
              t.status.notEquals('cancelado');
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr =
              expr &
              (t.code.ilike(query) |
                  t.applicantCode.ilike(query) |
                  t.applicantName.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit ?? 100,
      offset: offset ?? 0,
    );
  }

  /// 5. Actualiza la Sección 1: Documentación digital y checklist estructurado.
  Future<RrhhHiringDossier> updateDossierSection1({
    required int id,
    required List<RrhhDossierDocument> documentChecklist,
    String? sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final requiredDocs = documentChecklist.where((d) => d.isRequired);
    final allRequiredOk =
        requiredDocs.isNotEmpty &&
        requiredDocs.every((d) => d.status.toLowerCase() == 'validado');
    final hasAnyProgress = documentChecklist.any(
      (d) => d.status.toLowerCase() != 'pendiente',
    );

    final computedStatus =
        sectionStatus ??
        (allRequiredOk
            ? 'completa'
            : (hasAnyProgress ? 'en_proceso' : 'pendiente'));

    final newStatus = dossier.status == 'abierto'
        ? 'en_proceso'
        : dossier.status;
    final now = DateTime.now().toUtc();

    final updated = dossier.copyWith(
      documentChecklist: documentChecklist,
      section1Status: computedStatus,
      status: newStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 6. Actualiza la Sección 2: Afiliación seguridad social (AFP, CNS, etc.).
  Future<RrhhHiringDossier> updateDossierSection2({
    required int id,
    required String? afpName,
    required String? afpNumber,
    required String? healthInsurance,
    required String? notes,
    required String sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final newStatus = dossier.status == 'abierto'
        ? 'en_proceso'
        : dossier.status;
    final now = DateTime.now().toUtc();

    final updated = dossier.copyWith(
      afpName: afpName,
      afpNumber: afpNumber,
      healthInsurance: healthInsurance,
      section2Notes: notes,
      section2Status: sectionStatus,
      status: newStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 7. Actualiza la Sección 3: Datos personales complementarios y contactos de emergencia.
  Future<RrhhHiringDossier> updateDossierSection3({
    required int id,
    required String? fullAddress,
    required String? maritalStatus,
    required int? childrenCount,
    required String? emergencyContactName,
    required String? emergencyContactPhone,
    required String? emergencyContactRelation,
    required String sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final newStatus = dossier.status == 'abierto'
        ? 'en_proceso'
        : dossier.status;
    final now = DateTime.now().toUtc();

    final updated = dossier.copyWith(
      fullAddress: fullAddress,
      maritalStatus: maritalStatus,
      childrenCount: childrenCount,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      section3Status: sectionStatus,
      status: newStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 8. Actualiza la Sección 4: Condiciones contractuales y salariales.
  Future<RrhhHiringDossier> updateDossierSection4({
    required int id,
    required String? contractType,
    required String? workdayType,
    required String? paymentModality,
    required double? baseSalary,
    required DateTime? contractStartDate,
    required DateTime? contractEndDate,
    required List<RrhhEmployeeBonus>? bonuses,
    required List<RrhhEmployeeDeduction>? deductions,
    required String? notes,
    required String sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final newStatus = dossier.status == 'abierto'
        ? 'en_proceso'
        : dossier.status;
    final now = DateTime.now().toUtc();

    final updated = dossier.copyWith(
      contractType: contractType,
      workdayType: workdayType,
      paymentModality: paymentModality,
      baseSalary: baseSalary,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      bonuses: bonuses,
      deductions: deductions,
      section4Notes: notes,
      section4Status: sectionStatus,
      status: newStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 9. Actualiza la Sección 5: Asignación operativa y organizacional.
  Future<RrhhHiringDossier> updateDossierSection5({
    required int id,
    required int? areaId,
    required int? positionId,
    required String? shiftId,
    required String? scheduleId,
    required String? baseLocation,
    required String? supervisorEmployeeId,
    required DateTime? effectiveStartDate,
    required String? notes,
    required String sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final newStatus = dossier.status == 'abierto'
        ? 'en_proceso'
        : dossier.status;
    final now = DateTime.now().toUtc();

    final updated = dossier.copyWith(
      areaId: areaId,
      positionId: positionId,
      shiftId: shiftId,
      scheduleId: scheduleId,
      baseLocation: baseLocation,
      supervisorEmployeeId: supervisorEmployeeId,
      effectiveStartDate: effectiveStartDate,
      section5Notes: notes,
      section5Status: sectionStatus,
      status: newStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 10. Actualiza la Sección 6: Aprobación y cierre del expediente.
  Future<RrhhHiringDossier> updateDossierSection6({
    required int id,
    required String? closingNotes,
    required String? approvedBy,
    required String sectionStatus,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final now = DateTime.now().toUtc();
    final updated = dossier.copyWith(
      closingNotes: closingNotes,
      approvedBy: approvedBy,
      approvedAt: approvedBy != null ? now : dossier.approvedAt,
      section6Status: sectionStatus,
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 11. Actualiza el estado global del expediente.
  Future<RrhhHiringDossier> updateDossierStatus({
    required int id,
    required String status,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    final now = DateTime.now().toUtc();
    final updated = dossier.copyWith(
      status: status.trim().toLowerCase(),
      updatedAt: now,
    );

    return await RrhhHiringDossier.db.updateRow(session, updated);
  }

  /// 12. Convierte formalmente el expediente de contratación en un Empleado en Nómina.
  /// Valida que las 5 primeras secciones estén completas y aplica la mutación transaccional.
  Future<RrhhEmployee> convertDossierToEmployee({
    required int id,
    required String createdBy,
  }) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    if (dossier.status == 'convertido' || dossier.employeeId != null) {
      throw ConflictException(
        'El expediente ya fue convertido previamente a empleado.',
      );
    }

    // Validación de secciones completas
    if (dossier.section1Status != 'completa' ||
        dossier.section2Status != 'completa' ||
        dossier.section3Status != 'completa' ||
        dossier.section4Status != 'completa' ||
        dossier.section5Status != 'completa') {
      throw ValidationException(
        'No se puede convertir el expediente a empleado: las secciones 1 a 5 deben estar completas.',
      );
    }

    final applicantId = dossier.applicantId;
    if (applicantId == null) {
      throw ValidationException(
        'El expediente no tiene un postulante asociado.',
      );
    }

    final applicant = await RrhhApplicant.db.findFirstRow(
      session,
      where: (t) => t.id.equals(applicantId),
    );
    if (applicant == null) {
      throw EntityNotFoundException('RrhhApplicant', applicantId);
    }

    // Validación 3.3: FELCC obligatorio para seguridad
    final isSecurity = _isSecurityPosition(
      position: applicant.targetPosition,
      area: applicant.targetArea,
      specialty: applicant.specialty,
    );
    if (isSecurity) {
      final felccDoc = dossier.documentChecklist?.firstWhere(
        (d) => d.code.toUpperCase() == 'FELCC',
        orElse: () => RrhhDossierDocument(
          code: 'FELCC',
          name: 'FELCC',
          isRequired: true,
          status: 'pendiente',
        ),
      );
      if (felccDoc == null || felccDoc.status.toLowerCase() != 'validado') {
        throw ValidationException(
          'El Certificado FELCC es obligatorio para cargos de seguridad.',
        );
      }
    }

    final inserted = await session.db.transaction((tx) async {
      final now = DateTime.now().toUtc();
      final employeeCode = await generateNextEmployeeCode(transaction: tx);

      final newEmployee = RrhhEmployee(
        code: employeeCode,
        fullName: applicant.fullName,
        birthDate: applicant.birthDate,
        birthPlace: 'Santa Cruz de la Sierra',
        identityCard: applicant.identityCard,
        phone: applicant.phone,
        address:
            dossier.fullAddress ??
            applicant.address ??
            'Sin dirección registrada',
        occupation: applicant.targetPosition ?? 'Personal Operativo',
        personalReference: applicant.referencePerson ?? 'Referencia personal',
        referencePhone: applicant.referencePhone ?? applicant.phone,
        employeeType: applicant.targetType,
        area: applicant.targetArea ?? 'Operaciones',
        areaId: dossier.areaId ?? applicant.areaId,
        position: applicant.targetPosition ?? 'Operario',
        positionId: dossier.positionId ?? applicant.positionId,
        specialty: applicant.specialty ?? 'General',
        specialtyId: applicant.specialtyId,
        workplace: dossier.baseLocation ?? 'Planta Central',
        supervisor: dossier.supervisorEmployeeId ?? 'Sin asignar',
        realStartDate:
            dossier.effectiveStartDate ?? dossier.contractStartDate ?? now,
        fiscalStartDate:
            dossier.contractStartDate ?? dossier.effectiveStartDate ?? now,
        agreedSalary: dossier.baseSalary ?? 0.0,
        contractType: dossier.contractType ?? 'INDEFINIDO',
        contractEndDate: dossier.contractEndDate,
        observations:
            'Alta formal de empleado desde expediente ${dossier.code}',
        status: 'ACTIVO',
        availabilityStatus: 'DISPONIBLE',
        paymentModality: dossier.paymentModality ?? 'MENSUAL',
        workScheduleType: dossier.workdayType ?? 'TIEMPO_COMPLETO_48H',
        hasCiCopy: applicant.hasIdentityCardCopy,
        corporateEmail: applicant.email,
        applicantId: applicant.id,
        // Campos Fase B
        afpName: dossier.afpName,
        afpNumber: dossier.afpNumber,
        healthInsurance: dossier.healthInsurance,
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
        documentChecklist: dossier.documentChecklist,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final insertedEmployee = await RrhhEmployee.db.insertRow(
        session,
        newEmployee,
        transaction: tx,
      );

      // 3. Actualizar postulante a 'CONTRATADO'
      final updatedApplicant = applicant.copyWith(
        status: 'CONTRATADO',
        updatedAt: now,
      );
      await RrhhApplicant.db.updateRow(
        session,
        updatedApplicant,
        transaction: tx,
      );

      // 4. Actualizar expediente de contratación
      final updatedDossier = dossier.copyWith(
        employeeId: insertedEmployee.id,
        convertedEmployeeCode: insertedEmployee.code,
        status: 'convertido',
        section6Status: 'completa',
        closedAt: now,
        updatedAt: now,
      );
      await RrhhHiringDossier.db.updateRow(
        session,
        updatedDossier,
        transaction: tx,
      );

      // 5. Registrar evento en la línea de tiempo
      final timelineEvent = RrhhTimelineEvent(
        employeeId: insertedEmployee.id!,
        date: now,
        title: 'Alta de empleado desde expediente',
        description:
            'Alta de empleado desde expediente de contratación ${dossier.code}. Código asignado: ${insertedEmployee.code}.',
        category: 'CONTRATACION',
        registeredBy: createdBy,
        createdAt: now,
      );
      await RrhhTimelineEvent.db.insertRow(
        session,
        timelineEvent,
        transaction: tx,
      );

      return insertedEmployee;
    });

    return await _maskSensitiveCompensation(inserted);
  }

  /// 13. Soft delete del expediente de contratación.
  /// Solo se permite eliminar si el estado es 'abierto' o 'pausado'.
  Future<void> deleteDossier(int id) async {
    final dossier = await getDossierById(id);
    if (dossier == null) {
      throw EntityNotFoundException('RrhhHiringDossier', id);
    }

    if (dossier.status != 'abierto' && dossier.status != 'pausado') {
      throw ValidationException(
        'Solo se pueden eliminar expedientes en estado abierto o pausado. Estado actual: "${dossier.status}".',
      );
    }

    final now = DateTime.now().toUtc();
    final updated = dossier.copyWith(
      isDeleted: true,
      deletedAt: now,
      updatedAt: now,
    );

    await RrhhHiringDossier.db.updateRow(session, updated);
  }
}
