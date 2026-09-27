import 'package:serverpod/serverpod.dart';
import '../../../authorization/permissions.dart';
import '../../../authorization/rbac_guard.dart';
import '../../../generated/protocol.dart';
import '../repositories/rrhh_hiring_repository.dart';

/// Endpoint RPC para la gestión integral del Expediente de Contratación (FASE C - Hiring Dossier).
/// Conecta la etapa SELECCIONADO de Postulantes con el alta definitiva en Nómina de Empleados.
class RrhhHiringEndpoint extends Endpoint {
  /// 1. Crea un nuevo expediente de contratación para un postulante seleccionado.
  Future<RrhhHiringDossier> createDossier(
    Session session,
    int applicantId,
  ) async {
    final userId = await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.createDossier(
      applicantId: applicantId,
      createdBy: userId,
    );
  }

  /// 2. Obtiene un expediente por su ID.
  Future<RrhhHiringDossier?> getDossierById(
    Session session,
    int id,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhHiringRepository(session);
    return await repo.getDossierById(id);
  }

  /// 3. Obtiene el expediente activo de un postulante.
  Future<RrhhHiringDossier?> getDossierByApplicantId(
    Session session,
    int applicantId,
  ) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhHiringRepository(session);
    return await repo.getDossierByApplicantId(applicantId);
  }

  /// 4. Lista los expedientes activos con filtros opcionales de búsqueda y estado.
  Future<List<RrhhHiringDossier>> listActiveDossiers(
    Session session, {
    String? search,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    await RbacGuard.requirePermission(session, AppPermissions.rrhhPersonalView);
    final repo = RrhhHiringRepository(session);
    return await repo.listActiveDossiers(
      search: search,
      status: status,
      limit: limit,
      offset: offset,
    );
  }

  /// 5. Actualiza la Sección 1: Documentación digital y checklist de verificación.
  Future<RrhhHiringDossier> updateDossierSection1(
    Session session, {
    required int id,
    required List<RrhhDossierDocument> documentChecklist,
    String? sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection1(
      id: id,
      documentChecklist: documentChecklist,
      sectionStatus: sectionStatus,
    );
  }

  /// 6. Actualiza la Sección 2: Afiliación de seguridad social (AFP, Seguro de Salud).
  Future<RrhhHiringDossier> updateDossierSection2(
    Session session, {
    required int id,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? notes,
    required String sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection2(
      id: id,
      afpName: afpName,
      afpNumber: afpNumber,
      healthInsurance: healthInsurance,
      notes: notes,
      sectionStatus: sectionStatus,
    );
  }

  /// 7. Actualiza la Sección 3: Datos personales complementarios y contacto de emergencia.
  Future<RrhhHiringDossier> updateDossierSection3(
    Session session, {
    required int id,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    required String sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection3(
      id: id,
      fullAddress: fullAddress,
      maritalStatus: maritalStatus,
      childrenCount: childrenCount,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      sectionStatus: sectionStatus,
    );
  }

  /// 8. Actualiza la Sección 4: Condiciones contractuales, salarios, bonos y deducciones.
  Future<RrhhHiringDossier> updateDossierSection4(
    Session session, {
    required int id,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    String? notes,
    required String sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection4(
      id: id,
      contractType: contractType,
      workdayType: workdayType,
      paymentModality: paymentModality,
      baseSalary: baseSalary,
      contractStartDate: contractStartDate,
      contractEndDate: contractEndDate,
      bonuses: bonuses,
      deductions: deductions,
      notes: notes,
      sectionStatus: sectionStatus,
    );
  }

  /// 9. Actualiza la Sección 5: Asignación organizacional, área, cargo, turno y base operativa.
  Future<RrhhHiringDossier> updateDossierSection5(
    Session session, {
    required int id,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? notes,
    required String sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection5(
      id: id,
      areaId: areaId,
      positionId: positionId,
      shiftId: shiftId,
      scheduleId: scheduleId,
      baseLocation: baseLocation,
      supervisorEmployeeId: supervisorEmployeeId,
      effectiveStartDate: effectiveStartDate,
      notes: notes,
      sectionStatus: sectionStatus,
    );
  }

  /// 10. Actualiza la Sección 6: Notas de cierre, aprobación y auditoría del expediente.
  Future<RrhhHiringDossier> updateDossierSection6(
    Session session, {
    required int id,
    String? closingNotes,
    String? approvedBy,
    required String sectionStatus,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierSection6(
      id: id,
      closingNotes: closingNotes,
      approvedBy: approvedBy,
      sectionStatus: sectionStatus,
    );
  }

  /// 11. Actualiza el estado global del expediente (abierto, en_proceso, listo_para_convertir, etc.).
  Future<RrhhHiringDossier> updateDossierStatus(
    Session session, {
    required int id,
    required String status,
  }) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.updateDossierStatus(id: id, status: status);
  }

  /// 12. Convierte el expediente verificado en un empleado activo en Nómina (transaccional).
  Future<RrhhEmployee> convertDossierToEmployee(
    Session session,
    int id,
  ) async {
    final userId = await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    return await repo.convertDossierToEmployee(
      id: id,
      createdBy: userId,
    );
  }

  /// 13. Soft delete del expediente de contratación.
  Future<bool> deleteDossier(
    Session session,
    int id,
  ) async {
    await RbacGuard.requirePermission(
      session,
      AppPermissions.rrhhPersonalManage,
    );
    final repo = RrhhHiringRepository(session);
    await repo.deleteDossier(id);
    return true;
  }
}
