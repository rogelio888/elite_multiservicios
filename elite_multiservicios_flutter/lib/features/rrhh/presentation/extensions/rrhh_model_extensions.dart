import 'package:flutter/material.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

/// Enums de presentación / UI mantenidos en el frontend.
enum RrhhDossierSectionStatus {
  pendiente,
  enProceso,
  completa;

  String get code {
    switch (this) {
      case RrhhDossierSectionStatus.pendiente:
        return 'pendiente';
      case RrhhDossierSectionStatus.enProceso:
        return 'en_proceso';
      case RrhhDossierSectionStatus.completa:
        return 'completa';
    }
  }

  static RrhhDossierSectionStatus fromCode(String code) {
    switch (code) {
      case 'completa':
        return RrhhDossierSectionStatus.completa;
      case 'en_proceso':
        return RrhhDossierSectionStatus.enProceso;
      case 'pendiente':
      default:
        return RrhhDossierSectionStatus.pendiente;
    }
  }
}

/// Extensiones UI para adaptar los modelos Serverpod a widgets de Flutter.
/// REGLA: Solo transformaciones de presentación, formato, colores e iconos.

/// 1. Extensión para RrhhArea (Serverpod)
extension RrhhAreaUiExtension on RrhhArea {
  Color get color {
    final hexVal = colorTag;
    if (hexVal == null || hexVal.isEmpty) {
      return const Color(0xFF2563EB);
    }
    try {
      String hex = hexVal.replaceAll('#', '').trim();
      if (hex.startsWith('0x') || hex.startsWith('0X')) {
        hex = hex.substring(2);
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFF2563EB);
    }
  }

  IconData get icon {
    switch (code.toUpperCase()) {
      case 'OPE':
      case 'OPERACIONES':
        return Icons.build_outlined;
      case 'SEG':
      case 'SEGURIDAD':
        return Icons.security_outlined;
      case 'LIM':
      case 'LIMPIEZA':
        return Icons.cleaning_services_outlined;
      case 'ADM':
      case 'ADMINISTRACION':
        return Icons.business_outlined;
      case 'RRHH':
        return Icons.people_outline;
      case 'COM':
      case 'VENTAS':
      case 'MARKETING':
        return Icons.support_agent_outlined;
      default:
        return Icons.apartment_outlined;
    }
  }
}

/// 2. Extensión para RrhhEmployee (Serverpod)
extension RrhhEmployeeUiExtension on RrhhEmployee {
  String get displayName => fullName;
  bool get isActive => status.toUpperCase() == 'ACTIVO';
  bool get isField => employeeType.toUpperCase() == 'CAMPO';
  bool get isOffice => employeeType.toUpperCase() == 'OFICINA';
}

/// 3. Extensión para RrhhEmployeeSummaryDto (Serverpod)
extension RrhhEmployeeSummaryDtoUiExtension on RrhhEmployeeSummaryDto {
  bool get isActive => status.toUpperCase() == 'ACTIVO';
  bool get isField => employeeType.toUpperCase() == 'CAMPO';
  bool get isOffice => employeeType.toUpperCase() == 'OFICINA';
  DateTime get realStartDate => hireDate;
}

/// 4. Extensión para RrhhHiringDossier (Serverpod)
extension RrhhHiringDossierUiExtension on RrhhHiringDossier {
  int get completedSectionsCount {
    int count = 0;
    if (section1Status == 'completa') count++;
    if (section2Status == 'completa') count++;
    if (section3Status == 'completa') count++;
    if (section4Status == 'completa') count++;
    if (section5Status == 'completa') count++;
    if (section6Status == 'completa') count++;
    return count;
  }

  double get progressFraction => completedSectionsCount / 6.0;

  String get progressLabel => '${(progressFraction * 100).toInt()}%';

  String get dossierStatusLabel {
    switch (status.toLowerCase()) {
      case 'abierto':
        return 'Abierto';
      case 'pausado':
        return 'Pausado';
      case 'cerrado':
        return 'Cerrado';
      default:
        return status;
    }
  }

  Map<String, RrhhDossierDocument> get documents {
    final map = <String, RrhhDossierDocument>{};
    for (final doc in documentChecklist ?? <RrhhDossierDocument>[]) {
      map[doc.code] = doc;
    }
    return map;
  }

  int get totalRequiredDocsCount =>
      (documentChecklist ?? []).where((d) => d.isRequired).length;

  int get validatedRequiredDocsCount =>
      (documentChecklist ?? []).where((d) => d.isRequired && d.status == 'validado').length;

  bool get areAllRequiredDocumentsValidated =>
      totalRequiredDocsCount > 0 && validatedRequiredDocsCount >= totalRequiredDocsCount;

  bool get isReadyForEmployeeCreation =>
      section1Status == 'completa' &&
      section2Status == 'completa' &&
      section3Status == 'completa' &&
      section4Status == 'completa' &&
      section5Status == 'completa';

  String get applicantFullName => applicantName;
  String get applicantCi => '---';
  String get applicantPhone => '---';
  String? get applicantEmail => null;
  DateTime get applicationDate => createdAt;
  double? get applicantExpectedSalary => baseSalary;
  String? get healthInsuranceName => healthInsurance;
  String? get healthInsuranceId => healthInsurance;
  String? get afpId => afpName;
  String? get contractTypeName => contractType;
  String? get contractTypeId => contractType;
  String get currency => 'BOB';
  String? get paymentModalityId => paymentModality;
  String? get paymentModalityName => paymentModality;
  String? get areaName => areaId != null ? 'Área #$areaId' : null;
  String? get targetArea => areaName;
  String? get positionName => positionId != null ? 'Cargo #$positionId' : null;
  String? get targetPosition => positionName;
  String? get shiftName => shiftId != null ? 'Turno #$shiftId' : null;
  String? get scheduleName => scheduleId != null ? 'Horario #$scheduleId' : null;
  String? get supervisorName => supervisorEmployeeId != null ? 'Supervisor #$supervisorEmployeeId' : null;
  String? get workplaceType => baseLocation;
}

/// 5. Extensión para RrhhDossierDocument (Serverpod)
extension RrhhDossierDocumentUiExtension on RrhhDossierDocument {
  bool get isValidated => status == 'validado';
  bool get isReceived => status == 'recibido';
  bool get isRejected => status == 'rechazado';
  bool get isPending => status == 'pendiente';
  String get requirementType => isRequired ? 'obligatorio' : 'condicional';
}
