// TODO(DTO): reemplazar por cliente Serverpod cuando el backend lo exponga.

/// DTO ligero para listados y tablas de colaboradores.
/// Protege datos sensibles (PII, salario, CI, teléfono personal, dirección).
class RrhhEmployeeSummaryDto {
  final int id;
  final String code;
  final String fullName;
  final String? photoUrl;
  final String employeeType; // 'OFICINA' | 'CAMPO'
  final String area;
  final String position;
  final String specialty;
  final String workplace;
  final String status; // 'ACTIVO' | 'INACTIVO'
  final String availabilityStatus; // 'DISPONIBLE' | 'ASIGNADO' | 'CON_PERMISO' | 'DE_VACACIONES' | 'SUSPENDIDO'
  final DateTime realStartDate;
  final int attachedDocsCount; // e.g. 6/6

  const RrhhEmployeeSummaryDto({
    required this.id,
    required this.code,
    required this.fullName,
    this.photoUrl,
    required this.employeeType,
    required this.area,
    required this.position,
    required this.specialty,
    required this.workplace,
    required this.status,
    required this.availabilityStatus,
    required this.realStartDate,
    required this.attachedDocsCount,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVO';
  bool get isField => employeeType.toUpperCase() == 'CAMPO';
  bool get hasCompleteDocs => attachedDocsCount >= 6;
}
