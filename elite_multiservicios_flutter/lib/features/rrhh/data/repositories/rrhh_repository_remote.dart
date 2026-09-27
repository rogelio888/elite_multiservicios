import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import 'package:elite_multiservicios_flutter/main.dart' as app;
import 'package:flutter/material.dart';
import '../exceptions/rrhh_remote_exception.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/rrhh_applicant_companion.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_payroll_export_dto.dart';
import '../models/rrhh_shift.dart';
import 'rrhh_repository.dart';

/// Implementación remota del repositorio de RRHH conectada a Serverpod.
/// Implementa los métodos del submódulo Personal (Directorio, Expediente, Reclutamiento, Dossier).
class RrhhRepositoryRemote implements RrhhRepository {
  static const String _notMigratedMsg =
      'Módulo pendiente de migración a Serverpod';

  @override
  bool get isMock => false;

  // ===========================================================================
  // PANTALLA 01: Dashboard Ejecutivo de RRHH
  // ===========================================================================
  @override
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    try {
      return await app.client.rrhhDashboard.getMetrics();
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<List<RrhhRecentMovementDto>> getRecentMovements() async {
    try {
      return await app.client.rrhhDashboard.getRecentMovements(limit: 10);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLA 02 & 03: Submódulo Personal (Directorio y Expediente 360°)
  // ===========================================================================

  /// 1. Lista resumida y paginada de colaboradores para el Directorio.
  @override
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
    String? availabilityStatus,
  }) async {
    try {
      return await app.client.rrhhPersonnel.listEmployeeSummaries(
        status: status,
        employeeType: employeeType,
        availabilityStatus: availabilityStatus,
        areaId: areaId,
        search: search,
        limit: limit ?? 100,
        offset: offset ?? 0,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 2. Obtiene un colaborador por su ID numérico.
  @override
  Future<RrhhEmployee> getEmployeeById(int id) async {
    try {
      final employee = await app.client.rrhhPersonnel.getEmployeeById(
        id,
        includeDeleted: false,
      );
      if (employee == null) {
        throw RrhhRemoteException(
          code: 'NOT_FOUND',
          message: 'Empleado con ID $id no fue encontrado.',
        );
      }
      return employee;
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 3. Obtiene un colaborador por su código institucional (EMP-001).
  @override
  Future<RrhhEmployee?> getEmployeeByCode(String code) async {
    try {
      return await app.client.rrhhPersonnel.getEmployeeByCode(
        code,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 4. Registra un nuevo colaborador directamente en nómina.
  @override
  Future<RrhhEmployee> createEmployee(RrhhEmployee employee) async {
    try {
      return await app.client.rrhhPersonnel.createEmployee(employee);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 5. Actualiza los datos laborales y personales de un empleado.
  @override
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployee(employee);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 6. Contrata formalmente a un postulante promoviéndolo a empleado.
  @override
  Future<RrhhEmployee> hireApplicant({
    required int? applicantId,
    required RrhhEmployee employeeData,
  }) async {
    try {
      if (applicantId == null) {
        throw const RrhhRemoteException(
          code: 'VALIDATION_FAILED',
          message: 'El ID de postulante es obligatorio para contratar.',
        );
      }
      return await app.client.rrhhPersonnel.hireApplicant(
        applicantId: applicantId,
        realStartDate: employeeData.realStartDate,
        fiscalStartDate: employeeData.fiscalStartDate,
        agreedSalary: employeeData.agreedSalary ?? 0.0,
        contractType: employeeData.contractType,
        contractEndDate: employeeData.contractEndDate,
        observations: employeeData.observations,
        workplace: employeeData.workplace,
        supervisor: employeeData.supervisor,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 7. Actualiza la información bancaria del colaborador.
  @override
  Future<RrhhEmployee> updateEmployeeBankInfo(
    int id, {
    String? bankName,
    String? accountType,
    String? accountNumber,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeBankInfo(
        id: id,
        bankName: bankName,
        accountType: accountType,
        accountNumber: accountNumber,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 8. Actualiza los datos de seguridad social (AFP, Seguro de Salud).
  @override
  Future<RrhhEmployee> updateEmployeeSocialSecurity(
    int id, {
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeSocialSecurity(
        id: id,
        afpName: afpName,
        afpNumber: afpNumber,
        healthInsurance: healthInsurance,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 9. Actualiza datos personales complementarios y contacto de emergencia.
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
    try {
      return await app.client.rrhhPersonnel.updateEmployeePersonalInfo(
        id: id,
        fullAddress: fullAddress,
        maritalStatus: maritalStatus,
        childrenCount: childrenCount,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelation: emergencyContactRelation,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 10. Actualiza las condiciones contractuales y de remuneración.
  @override
  Future<RrhhEmployee> updateEmployeeContract(
    int id, {
    String? contractType,
    String? paymentModality,
    String? workdayType,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
    String justification = 'Actualización contractual',
    double? baseSalary,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeContract(
        id: id,
        justification: justification,
        contractType: contractType,
        workdayType: workdayType,
        paymentModality: paymentModality,
        baseSalary: baseSalary,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        contractSignedPdfUrl: contractSignedPdfUrl,
        bonuses: bonuses,
        deductions: deductions,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 11. Actualiza la lista de bonificaciones del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeBonuses(
    int id,
    List<RrhhEmployeeBonus> bonuses,
  ) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeBonuses(
        id: id,
        bonuses: bonuses,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 12. Actualiza la lista de deducciones del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeDeductions(
    int id,
    List<RrhhEmployeeDeduction> deductions,
  ) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeDeductions(
        id: id,
        deductions: deductions,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 13. Actualiza la asignación operativa, ubicación base y supervisor.
  @override
  Future<RrhhEmployee> updateEmployeeAssignment(
    int id, {
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeAssignment(
        id: id,
        shiftId: shiftId,
        baseLocation: baseLocation,
        supervisorEmployeeId: supervisorEmployeeId,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 14. Actualiza el checklist de documentación digital del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeDocuments(
    int id,
    Map<String, String> documentChecklist,
  ) async {
    try {
      final docList = documentChecklist.entries
          .map(
            (e) => RrhhDossierDocument(
              code: e.key,
              name: e.key,
              isRequired: true,
              status: e.value,
            ),
          )
          .toList();
      return await app.client.rrhhPersonnel.updateEmployeeDocuments(
        id: id,
        documentChecklist: docList,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 15. Obtiene el resumen contractual para exposición a Contabilidad.
  @override
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id) async {
    try {
      return await app.client.rrhhPersonnel.getEmployeeContractData(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 16. Soft delete de un empleado en Nómina.
  @override
  Future<bool> deleteEmployee(int id) async {
    try {
      return await app.client.rrhhPersonnel.deleteEmployee(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // DOCUMENTOS & LÍNEA DE TIEMPO DEL EMPLEADO (17 a 21)
  // ===========================================================================

  /// 17. Lista los documentos del expediente digital del colaborador.
  @override
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId) async {
    try {
      return await app.client.rrhhPersonnel.listDocuments(employeeId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 18. Sube / registra un documento en el expediente del colaborador.
  @override
  Future<RrhhEmployeeDocument> uploadEmployeeDocument(
    RrhhEmployeeDocument document,
  ) async {
    try {
      return await app.client.rrhhPersonnel.addDocument(document);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 19. Elimina un documento del expediente digital.
  @override
  Future<bool> deleteEmployeeDocument(int documentId) async {
    try {
      return await app.client.rrhhPersonnel.deleteDocument(documentId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 20. Consulta los hitos de la línea de tiempo del empleado.
  @override
  Future<List<RrhhTimelineEvent>> listTimelineEvents({
    int? employeeId,
    String? category,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? user,
  }) async {
    try {
      final events = await app.client.rrhhPersonnel.listTimelineEvents(
        employeeId ?? 0,
      );
      return events.where((e) {
        if (category != null && category.isNotEmpty && e.category != category) {
          return false;
        }
        if (user != null && user.isNotEmpty && e.registeredBy != user) {
          return false;
        }
        if (startDate != null && e.date.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && e.date.isAfter(endDate)) {
          return false;
        }
        if (search != null && search.trim().isNotEmpty) {
          final q = search.trim().toLowerCase();
          final matchesTitle = e.title.toLowerCase().contains(q);
          final matchesDesc = e.description.toLowerCase().contains(q);
          if (!matchesTitle && !matchesDesc) return false;
        }
        return true;
      }).toList();
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 21. Agrega un hito inmutable a la línea de tiempo del empleado.
  @override
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event) async {
    try {
      return await app.client.rrhhPersonnel.addTimelineEvent(event);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhTimelineEvent?> getTimelineEventById(int id) async {
    return null;
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
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId) async {
    try {
      return await app.client.rrhhAssignment.getActiveAssignmentByEmployee(
        employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // PANTALLA 04: Reclutamiento & Pipeline de Postulantes (22 a 27)
  // ===========================================================================

  /// 22. Lista postulantes con filtros opcionales.
  @override
  Future<List<RrhhApplicantSummaryDto>> listApplicants({
    String? status,
    String? search,
  }) async {
    try {
      final applicants = await app.client.rrhhApplicant.listApplicants(
        status: status,
        search: search,
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );
      return applicants
          .map(
            (a) => RrhhApplicantSummaryDto(
              id: a.id ?? 0,
              code: a.code,
              fullName: a.fullName,
              targetType: a.targetType,
              targetPosition: a.targetPosition ?? '---',
              specialty: a.specialty ?? 'General',
              status: a.status,
              applicationDate: a.applicationDate,
              hasCv: a.hasCvAttached || (a.cvUrl != null && a.cvUrl!.isNotEmpty),
            ),
          )
          .toList();
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 23. Obtiene un postulante por su ID numérico.
  @override
  Future<RrhhApplicant> getApplicantById(int id) async {
    try {
      final applicant = await app.client.rrhhApplicant.getApplicantById(
        id,
        includeDeleted: false,
      );
      if (applicant == null) {
        throw RrhhRemoteException(
          code: 'NOT_FOUND',
          message: 'Postulante con ID $id no fue encontrado.',
        );
      }
      return applicant;
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 24. Registra un nuevo postulante en el pipeline.
  @override
  Future<RrhhApplicant> createApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
  }) async {
    try {
      return await app.client.rrhhApplicant.createApplicant(applicant);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 25. Actualiza los datos de un postulante existente.
  @override
  Future<RrhhApplicant> updateApplicant(RrhhApplicant applicant) async {
    try {
      return await app.client.rrhhApplicant.updateApplicant(applicant);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 26. Modifica el estado del postulante en el pipeline de selección.
  @override
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  }) async {
    try {
      return await app.client.rrhhApplicant.updateApplicantStatus(
        id: applicantId,
        newStatus: newStatus,
        interviewNotes: notes,
        discardReason: discardReason,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 27. Soft delete de un postulante.
  @override
  Future<bool> deleteApplicant(int id) async {
    try {
      return await app.client.rrhhApplicant.deleteApplicant(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhApplicantCompanion> getApplicantCompanion(int applicantId) async {
    return RrhhApplicantCompanion(applicantId: applicantId);
  }

  @override
  Future<void> saveApplicantCompanion(
    int applicantId,
    RrhhApplicantCompanion companion,
  ) async {}

  @override
  Future<List<RrhhApplicant>> findApplicantsByCi(String identityCard) async {
    try {
      return await app.client.rrhhApplicant.listApplicants(
        search: identityCard,
        limit: 20,
        offset: 0,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<void> addInterviewRecord(
    int applicantId,
    RrhhInterviewRecord record,
  ) async {}

  // ===========================================================================
  // PANTALLA 05: Contratación Formal & Expedientes de Contratación (28 a 40)
  // ===========================================================================

  /// 28. Lista los expedientes de contratación activos.
  @override
  Future<List<RrhhHiringDossier>> listActiveDossiers() async {
    try {
      return await app.client.rrhhHiring.listActiveDossiers(
        limit: 100,
        offset: 0,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 29. Obtiene un expediente por su ID numérico.
  @override
  Future<RrhhHiringDossier?> getDossierById(int id) async {
    try {
      return await app.client.rrhhHiring.getDossierById(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 30. Obtiene el expediente activo asociado a un postulante.
  @override
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId) async {
    try {
      return await app.client.rrhhHiring.getDossierByApplicantId(applicantId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 31. Crea un nuevo expediente para un postulante seleccionado.
  @override
  Future<RrhhHiringDossier> createDossierForApplicant(int applicantId) async {
    try {
      return await app.client.rrhhHiring.createDossier(applicantId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 32. Actualiza la Sección 1: Documentación digital y checklist.
  @override
  Future<RrhhHiringDossier> updateDossierSection1(
    int id,
    Map<String, RrhhDossierDocument> documents,
  ) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection1(
        id: id,
        documentChecklist: documents.values.toList(),
        sectionStatus: 'completo',
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 33. Actualiza la Sección 2: Afiliación de seguridad social.
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
    try {
      return await app.client.rrhhHiring.updateDossierSection2(
        id: id,
        afpName: afpName,
        afpNumber: afpNumber,
        healthInsurance: healthInsuranceName,
        notes: section2Notes,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 34. Actualiza la Sección 3: Datos personales complementarios y contacto.
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
    try {
      return await app.client.rrhhHiring.updateDossierSection3(
        id: id,
        fullAddress: fullAddress,
        maritalStatus: maritalStatus,
        childrenCount: childrenCount,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelation: emergencyContactRelation,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 35. Actualiza la Sección 4: Condiciones contractuales y salariales.
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
    try {
      return await app.client.rrhhHiring.updateDossierSection4(
        id: id,
        contractType: contractTypeName ?? contractTypeId,
        workdayType: workdayType,
        paymentModality: paymentModalityName ?? paymentModalityId,
        baseSalary: baseSalary,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        bonuses: bonuses,
        deductions: deductions,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 36. Actualiza la Sección 5: Asignación organizacional y operativa.
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
    try {
      return await app.client.rrhhHiring.updateDossierSection5(
        id: id,
        areaId: int.tryParse(areaId ?? ''),
        positionId: int.tryParse(positionId ?? ''),
        shiftId: shiftId,
        scheduleId: scheduleId,
        baseLocation: baseLocation,
        supervisorEmployeeId: supervisorEmployeeId,
        effectiveStartDate: effectiveStartDate,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 37. Actualiza la Sección 6: Notas de cierre y aprobación del expediente.
  @override
  Future<RrhhHiringDossier> updateDossierSection6(
    int id, {
    String? closingNotes,
    String? approvedBy,
    required String sectionStatus,
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection6(
        id: id,
        closingNotes: closingNotes,
        approvedBy: approvedBy,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 38. Actualiza el estado global del expediente.
  @override
  Future<RrhhHiringDossier> updateDossierStatus(int id, String status) async {
    try {
      return await app.client.rrhhHiring.updateDossierStatus(
        id: id,
        status: status,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 39. Convierte el expediente verificado en empleado activo en Nómina.
  @override
  Future<RrhhEmployee> convertDossierToEmployee(
    int dossierId, {
    String? notes,
  }) async {
    try {
      return await app.client.rrhhHiring.convertDossierToEmployee(dossierId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 40. Soft delete del expediente de contratación.
  @override
  Future<bool> deleteDossier(int id) async {
    try {
      return await app.client.rrhhHiring.deleteDossier(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLAS 06 a 14: Módulos con conexión directa o pendientes de migración
  // ===========================================================================

  @override
  Future<List<RrhhArea>> listAreas() async {
    try {
      return await app.client.rrhhOrganization.listAreas(
        includeInactive: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhArea> createArea(RrhhArea area) async {
    try {
      return await app.client.rrhhOrganization.createArea(area);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhArea> updateArea(RrhhArea area) async {
    try {
      return await app.client.rrhhOrganization.updateArea(area);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<List<RrhhPosition>> listPositions() async {
    try {
      return await app.client.rrhhOrganization.listPositions(
        includeInactive: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhPosition> createPosition(RrhhPosition position) async {
    try {
      return await app.client.rrhhOrganization.createPosition(position);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhPosition> updatePosition(RrhhPosition position) async {
    try {
      return await app.client.rrhhOrganization.updatePosition(position);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<List<RrhhSpecialty>> listSpecialties() async {
    try {
      return await app.client.rrhhOrganization.listSpecialties(
        includeInactive: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty) async {
    try {
      return await app.client.rrhhOrganization.createSpecialty(specialty);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty) async {
    try {
      return await app.client.rrhhOrganization.updateSpecialty(specialty);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<List<RrhhShift>> listShifts() async {
    return const [];
  }

  @override
  Future<RrhhShift> createShift(RrhhShift shift) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhShift> updateShift(RrhhShift shift) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhBaseSchedule>> listBaseSchedules() async {
    return const [];
  }

  @override
  Future<RrhhBaseSchedule> createBaseSchedule(RrhhBaseSchedule schedule) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhBaseSchedule> updateBaseSchedule(RrhhBaseSchedule schedule) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhSchedule>> listSchedules() async {
    return const [];
  }

  @override
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhCatalogItem>> listCatalogItems(RrhhCatalogType type) async {
    return const [];
  }

  @override
  Future<RrhhCatalogItem> createCatalogItem(RrhhCatalogItem item) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhCatalogItem> updateCatalogItem(RrhhCatalogItem item) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? search,
    String? leaveType,
    String? status,
    bool? isPaid,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return const [];
  }

  @override
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id) async {
    return null;
  }

  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveRequest(RrhhLeaveRequest request) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveStatus(
    int id,
    String newStatus, {
    String? reason,
    String? approvedBy,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<bool> deleteLeaveRequest(int id) async {
    return true;
  }

  @override
  Future<List<RrhhLeaveRequest>> listPayrollAffectingLeaves(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return const [];
  }

  @override
  Future<List<RrhhVacationRecord>> listVacationRecords({
    String? search,
    String? status,
    int? employeeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return const [];
  }

  @override
  Future<RrhhVacationRecord?> getVacationRecordById(int id) async {
    return null;
  }

  @override
  Future<RrhhVacationRecord> createVacationRecord(
    RrhhVacationRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhVacationRecord> updateVacationRecord(
    RrhhVacationRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhVacationRecord> updateVacationStatus(
    int id,
    String newStatus, {
    String? reason,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<bool> deleteVacationRecord(int id) async {
    return true;
  }

  @override
  Future<List<RrhhVacationBalance>> listVacationBalances({
    String? search,
    String? balanceStatus,
    int? areaId,
  }) async {
    return const [];
  }

  @override
  Future<RrhhVacationBalance?> getVacationBalanceByEmployee(
    int employeeId,
  ) async {
    return null;
  }

  @override
  Future<List<RrhhVacationRecord>> listPayrollAffectingVacations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return const [];
  }

  @override
  Future<List<RrhhVacation>> listVacations() async {
    return const [];
  }

  @override
  Future<RrhhVacation> requestVacation(RrhhVacation vacation) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhVacation> approveVacation(
    int vacationId, {
    required String approvedBy,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhDisciplinaryRecord>> listDisciplinaryRecords({
    String? status,
    String? faultType,
    String? sanctionType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return const [];
  }

  @override
  Future<RrhhDisciplinaryRecord?> getDisciplinaryRecordById(int id) async {
    return null;
  }

  @override
  Future<RrhhDisciplinaryRecord> createDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhDisciplinaryRecord> updateDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
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
    return true;
  }

  @override
  Future<bool> deleteDisciplinaryRecord(int id) async {
    return true;
  }

  @override
  Future<List<RrhhDisciplinaryRecord>> listPayrollAffectingDisciplinary(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return const [];
  }

  @override
  Future<List<RrhhIncident>> listIncidents({
    String? severity,
    String? search,
  }) async {
    return const [];
  }

  @override
  Future<RrhhIncident> recordIncident(RrhhIncident incident) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return const [];
  }

  @override
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id) async {
    return null;
  }

  @override
  Future<RrhhTerminationRecord> createTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhTerminationRecord> updateTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<bool> updateTerminationStatus(
    int id,
    String newStatus, {
    String? reason,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
  }) async {
    return true;
  }

  @override
  Future<bool> deleteTerminationRecord(int id) async {
    return true;
  }

  @override
  Future<List<RrhhTerminationRecord>> listPayrollAffectingTerminations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return const [];
  }

  @override
  Future<List<RrhhTermination>> listTerminations() async {
    return const [];
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
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhPayrollPeriod>> listPayrollPeriods() async {
    return const [];
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodById(int id) async {
    return null;
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodByMonth(int year, int month) async {
    return null;
  }

  @override
  Future<RrhhPayrollPeriod> createPayrollPeriod(
    int year,
    int month, {
    String? notes,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhPayrollPeriod> closePayrollPeriod(
    int id, {
    String? closedBy,
    String? notes,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<RrhhPayrollPeriod> sendPayrollPeriodToAccounting(
    int id, {
    String? sentBy,
  }) async {
    throw const RrhhRemoteException(
      code: 'MODULE_NOT_MIGRATED',
      message: _notMigratedMsg,
    );
  }

  @override
  Future<List<RrhhPayrollItem>> listPayrollItems(
    int periodId, {
    String? sourceType,
    String? impactType,
  }) async {
    return const [];
  }

  @override
  Future<List<RrhhPayrollItem>> generatePayrollItems(int periodId) async {
    return const [];
  }

  @override
  Future<String> exportPayrollPeriod(int periodId, String format) async {
    return '';
  }

  @override
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(
    int month,
    int year,
  ) async {
    return const [];
  }

  @override
  Future<List<RrhhAttendanceRecord>> listAttendanceRecords({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
    String? serviceName,
  }) async {
    return const [];
  }

  @override
  Future<RrhhAttendanceRecord?> getAttendanceRecordById(int id) async {
    return null;
  }

  @override
  Future<String> exportAttendanceReport({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
  }) async {
    return '';
  }

  @override
  Future<List<RrhhMovementHistory>> listMovements({
    String? movementType,
    int? employeeId,
    int? limit,
    int? offset,
  }) async {
    return const [];
  }

  @override
  Future<List<CrmClientRefDto>> listClientReferences() async {
    return const [];
  }
}
