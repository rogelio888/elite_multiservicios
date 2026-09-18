/// Servicio contratado por una empresa cliente
class RrhhClientContractedService {
  final String id;
  final String clientId;
  final String
  serviceName; // Ej: 'Jardinería', 'Limpieza', 'Seguridad', 'Mantenimiento'
  final String
  branchLocation; // Sede/Sucursal del cliente (ej. 'Central', 'Equipetrol', 'Sucursal Norte')
  final int requiredStaff;
  final String scheduleSummary;
  final bool isActive;

  String get category => serviceName.toUpperCase();
  int get assignedEmployeesCount => requiredStaff;

  const RrhhClientContractedService({
    required this.id,
    required this.clientId,
    required this.serviceName,
    required this.branchLocation,
    required this.requiredStaff,
    required this.scheduleSummary,
    this.isActive = true,
  });
}

/// Empresa cliente que contrata servicios de Elite Multiservicios
class RrhhClientCompany {
  final String id;
  final String name; // Ej: Kolping, Ventura Mall, Kinesis, Segomeit, Acegal
  final String businessCategory; // Ej: Salud, Retail, Logística, Industrial
  final String address;
  final String contactPerson;
  final String contactPhone;
  final List<RrhhClientContractedService> services;

  String get industry => businessCategory;
  List<String> get branches =>
      services.map((s) => s.branchLocation).toSet().toList();

  const RrhhClientCompany({
    required this.id,
    required this.name,
    required this.businessCategory,
    required this.address,
    required this.contactPerson,
    required this.contactPhone,
    this.services = const [],
  });
}

/// Asignación laboral de un trabajador (Oficina o Campo)
class RrhhAssignment {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String employeeType; // 'OFICINA' o 'CAMPO'

  // Datos específicos si es Oficina
  final String? officeArea;
  final String? officePosition;
  final String? officeDepartmentLeader;

  // Datos específicos si es Campo
  final String? clientCompanyId;
  final String? clientCompanyName;
  final String? contractedServiceId;
  final String? serviceName;
  final String? branchLocation;
  final String? fieldSupervisor;

  // Parámetros de asignación
  final String scheduleName; // Ej. 'Turno Mañana (07:00 - 15:00)'
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'PROGRAMADA', 'ACTIVA', 'FINALIZADA', 'CANCELADA'
  final String notes;

  String get type => employeeType;
  String? get contractedServiceName => serviceName;
  String? get officeRole => officePosition;
  String? get workplaceBranch => branchLocation;
  String get supervisorName =>
      fieldSupervisor ?? officeDepartmentLeader ?? 'Supervisión de Operaciones';

  const RrhhAssignment({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.employeeType,
    this.officeArea,
    this.officePosition,
    this.officeDepartmentLeader,
    this.clientCompanyId,
    this.clientCompanyName,
    this.contractedServiceId,
    this.serviceName,
    this.branchLocation,
    this.fieldSupervisor,
    required this.scheduleName,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.notes,
  });

  RrhhAssignment copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    String? employeeType,
    String? officeArea,
    String? officePosition,
    String? officeDepartmentLeader,
    String? clientCompanyId,
    String? clientCompanyName,
    String? contractedServiceId,
    String? serviceName,
    String? branchLocation,
    String? fieldSupervisor,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? notes,
  }) {
    return RrhhAssignment(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeType: employeeType ?? this.employeeType,
      officeArea: officeArea ?? this.officeArea,
      officePosition: officePosition ?? this.officePosition,
      officeDepartmentLeader:
          officeDepartmentLeader ?? this.officeDepartmentLeader,
      clientCompanyId: clientCompanyId ?? this.clientCompanyId,
      clientCompanyName: clientCompanyName ?? this.clientCompanyName,
      contractedServiceId: contractedServiceId ?? this.contractedServiceId,
      serviceName: serviceName ?? this.serviceName,
      branchLocation: branchLocation ?? this.branchLocation,
      fieldSupervisor: fieldSupervisor ?? this.fieldSupervisor,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
