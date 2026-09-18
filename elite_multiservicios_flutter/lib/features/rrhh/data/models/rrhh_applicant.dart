/// Modelo para candidatos / postulantes que buscan trabajo en la empresa
class RrhhApplicant {
  final String id;
  final String code; // Ej: POST-001
  final String fullName;
  final String identityCard;
  final String phone;
  final String email;
  final String address;
  final DateTime? birthDate;
  final String emergencyContact;
  final String emergencyPhone;
  final String targetArea;
  final String targetPosition;
  final String targetType; // 'OFICINA' o 'CAMPO'
  final String specialty; // Ej. Jardinería, Limpieza, Marketing, Ventas
  final String education;
  final String experienceSummary;
  final String skills;
  final String referencePerson;
  final String referencePhone;
  final DateTime applicationDate;
  final String
  status; // 'NUEVO', 'EN_EVALUACION', 'SELECCIONADO', 'RECHAZADO', 'CONTRATADO'
  final String? interviewNotes;
  final double? expectedSalary;
  final bool hasCvAttached;
  final bool hasIdentityCardCopy;

  const RrhhApplicant({
    required this.id,
    required this.code,
    required this.fullName,
    required this.identityCard,
    required this.phone,
    required this.email,
    required this.address,
    this.birthDate,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.targetArea,
    required this.targetPosition,
    required this.targetType,
    required this.specialty,
    required this.education,
    required this.experienceSummary,
    required this.skills,
    required this.referencePerson,
    required this.referencePhone,
    required this.applicationDate,
    required this.status,
    this.interviewNotes,
    this.expectedSalary,
    this.hasCvAttached = true,
    this.hasIdentityCardCopy = true,
  });

  RrhhApplicant copyWith({
    String? id,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    String? targetPosition,
    String? targetType,
    String? specialty,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    DateTime? applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
  }) {
    return RrhhApplicant(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      targetArea: targetArea ?? this.targetArea,
      targetPosition: targetPosition ?? this.targetPosition,
      targetType: targetType ?? this.targetType,
      specialty: specialty ?? this.specialty,
      education: education ?? this.education,
      experienceSummary: experienceSummary ?? this.experienceSummary,
      skills: skills ?? this.skills,
      referencePerson: referencePerson ?? this.referencePerson,
      referencePhone: referencePhone ?? this.referencePhone,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      interviewNotes: interviewNotes ?? this.interviewNotes,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      hasCvAttached: hasCvAttached ?? this.hasCvAttached,
      hasIdentityCardCopy: hasIdentityCardCopy ?? this.hasIdentityCardCopy,
    );
  }
}
